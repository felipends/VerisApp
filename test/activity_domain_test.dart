import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veris/features/activities/data/activity_repository.dart';
import 'package:veris/features/activities/data/local_activity_storage.dart';
import 'package:veris/features/activities/domain/activity_rate_limiter.dart';
import 'package:veris/features/activities/domain/activity_summary.dart';
import 'package:veris/features/activities/domain/activity_type.dart';
import 'package:veris/features/activities/domain/baby_activity.dart';
import 'package:veris/features/activities/presentation/activity_controller.dart';
import 'package:veris/features/activities/presentation/activity_grouping.dart';

void main() {
  test('ActivityType exposes Portuguese labels', () {
    expect(ActivityType.feeding.label, 'Mamou');
    expect(ActivityType.sleepStarted.label, 'Dormiu');
    expect(ActivityType.sleepEnded.label, 'Acordou');
    expect(ActivityType.diaper.label, 'Fralda');
  });

  test('BabyActivity creates ids and serializes', () {
    final now = DateTime(2026, 6, 26, 18, 42);
    final activity = BabyActivity.create(
      ActivityType.feeding,
      now: now,
      note: 'ok',
    );

    expect(activity.id, contains('feeding'));
    expect(activity.occurredAt, now);
    expect(activity.createdAt, now);
    expect(activity.note, 'ok');

    final json = activity.toJson();
    expect(json.containsKey('updatedAt'), isFalse);
    final restored = BabyActivity.fromJson(json);
    expect(restored.id, activity.id);
    expect(restored.type, ActivityType.feeding);
    expect(restored.occurredAt, now);
    expect(restored.note, 'ok');

    final legacy = BabyActivity.fromJson({
      'id': 'legacy',
      'type': 'diaper',
      'occurredAt': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
    });
    expect(legacy.updatedAt, isNull);
    expect(legacy.note, isNull);
  });

  test('groups by day and orders newest first', () {
    final now = DateTime(2026, 6, 26, 19);
    final activities = [
      BabyActivity.create(ActivityType.feeding, now: DateTime(2026, 6, 25, 22)),
      BabyActivity.create(
        ActivityType.sleepEnded,
        now: DateTime(2026, 6, 26, 17),
      ),
      BabyActivity.create(
        ActivityType.sleepStarted,
        now: DateTime(2026, 6, 26, 18),
      ),
      BabyActivity.create(ActivityType.feeding, now: DateTime(2026, 6, 24, 9)),
    ];

    final groups = groupActivitiesByDay(activities, now: now);

    expect(groups.map((group) => group.title), ['Hoje', 'Ontem', '24/06/2026']);
    expect(groups.first.activities.map((activity) => activity.type), [
      ActivityType.sleepStarted,
      ActivityType.sleepEnded,
    ]);
  });

  test('summary calculates today and current sleeping status', () {
    final now = DateTime(2026, 6, 26, 19);
    final service = ActivitySummaryService();
    final summary = service.calculate([
      BabyActivity.create(
        ActivityType.feeding,
        now: DateTime(2026, 6, 25, 23, 59),
      ),
      BabyActivity.create(ActivityType.feeding, now: DateTime(2026, 6, 26, 8)),
      BabyActivity.create(ActivityType.diaper, now: DateTime(2026, 6, 26, 9)),
      BabyActivity.create(
        ActivityType.sleepStarted,
        now: DateTime(2026, 6, 26, 10),
      ),
      BabyActivity.create(
        ActivityType.sleepEnded,
        now: DateTime(2026, 6, 26, 11),
      ),
      BabyActivity.create(
        ActivityType.sleepStarted,
        now: DateTime(2026, 6, 26, 18, 30),
      ),
    ], now: now);

    expect(summary.lastFeedingToday?.occurredAt, DateTime(2026, 6, 26, 8));
    expect(summary.diapersToday, 1);
    expect(summary.completedNapsToday, 1);
    expect(summary.currentStatus.status, BabyStatus.sleeping);
    expect(summary.currentStatus.since, DateTime(2026, 6, 26, 18, 30));
    expect(summary.currentStatus.sleepingFor, const Duration(minutes: 30));
  });

  test('rate limiter enforces per-type, global, and burst limits', () {
    final limiter = ActivityRateLimiter();
    final t0 = DateTime(2026, 6, 26, 12);
    expect(limiter.accept(ActivityType.feeding, now: t0), isTrue);
    expect(
      limiter.accept(
        ActivityType.feeding,
        now: t0.add(const Duration(milliseconds: 799)),
      ),
      isFalse,
    );
    expect(
      limiter.accept(
        ActivityType.diaper,
        now: t0.add(const Duration(milliseconds: 200)),
      ),
      isFalse,
    );
    expect(
      limiter.accept(
        ActivityType.diaper,
        now: t0.add(const Duration(milliseconds: 300)),
      ),
      isTrue,
    );

    final burstLimiter = ActivityRateLimiter(
      perTypeCooldown: Duration.zero,
      globalCooldown: Duration.zero,
    );
    for (var i = 0; i < 6; i++) {
      expect(
        burstLimiter.accept(
          ActivityType.values[i % ActivityType.values.length],
          now: t0.add(Duration(milliseconds: i * 10)),
        ),
        isTrue,
      );
    }
    expect(
      burstLimiter.accept(
        ActivityType.feeding,
        now: t0.add(const Duration(seconds: 2)),
      ),
      isFalse,
    );
    expect(
      burstLimiter.accept(
        ActivityType.feeding,
        now: t0.add(const Duration(seconds: 4)),
      ),
      isTrue,
    );
  });

  test('repository update and delete persist sorted activities', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = ActivityRepository(LocalActivityStorage());
    final older = await repository.add(
      ActivityType.feeding,
      now: DateTime(2026, 6, 26, 8),
    );
    final newer = await repository.add(
      ActivityType.diaper,
      now: DateTime(2026, 6, 26, 9),
    );

    final moved = older.copyWith(
      type: ActivityType.sleepStarted,
      occurredAt: DateTime(2026, 6, 26, 10),
      updatedAt: DateTime(2026, 6, 26, 10, 1),
      note: 'corrigido',
    );
    await repository.update(moved);
    var loaded = await repository.load();
    expect(loaded.map((activity) => activity.id), [older.id, newer.id]);
    expect(loaded.first.type, ActivityType.sleepStarted);
    expect(loaded.first.note, 'corrigido');

    await repository.delete(older.id);
    loaded = await repository.load();
    expect(loaded.map((activity) => activity.id), [newer.id]);
  });

  test(
    'controller ignores rapid duplicate add and updates in-memory list',
    () async {
      SharedPreferences.setMockInitialValues({});
      final controller = ActivityController(
        repository: ActivityRepository(LocalActivityStorage()),
      );
      await controller.load();

      final t0 = DateTime(2026, 6, 26, 8);
      final first = await controller.add(ActivityType.diaper, now: t0);
      final ignored = await controller.add(
        ActivityType.diaper,
        now: t0.add(const Duration(milliseconds: 100)),
      );

      expect(first, isNotNull);
      expect(ignored, isNull);
      expect(controller.activities, hasLength(1));
      expect((await controller.repository.load()), hasLength(1));

      final updated = await controller.update(
        first!.copyWith(type: ActivityType.feeding, note: 'editada'),
        now: t0.add(const Duration(minutes: 1)),
      );
      expect(updated, isNotNull);
      expect(controller.activities.single.type, ActivityType.feeding);
      expect(controller.activities.single.note, 'editada');

      final deleted = await controller.delete(first.id);
      expect(deleted, isTrue);
      expect(controller.activities, isEmpty);
      expect((await controller.repository.load()), isEmpty);
    },
  );
}
