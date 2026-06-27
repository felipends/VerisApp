import 'package:flutter_test/flutter_test.dart';
import 'package:veris/features/activities/domain/activity_type.dart';
import 'package:veris/features/activities/domain/baby_activity.dart';
import 'package:veris/features/activities/presentation/activity_grouping.dart';

void main() {
  test('ActivityType exposes Portuguese labels', () {
    expect(ActivityType.feeding.label, 'Mamou');
    expect(ActivityType.sleepStarted.label, 'Dormiu');
    expect(ActivityType.sleepEnded.label, 'Acordou');
  });

  test('BabyActivity creates ids and serializes', () {
    final now = DateTime(2026, 6, 26, 18, 42);
    final activity = BabyActivity.create(ActivityType.feeding, now: now);

    expect(activity.id, contains('feeding'));
    expect(activity.occurredAt, now);
    expect(activity.createdAt, now);

    final restored = BabyActivity.fromJson(activity.toJson());
    expect(restored.id, activity.id);
    expect(restored.type, ActivityType.feeding);
    expect(restored.occurredAt, now);
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
}
