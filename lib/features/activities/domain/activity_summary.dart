import 'activity_type.dart';
import 'baby_activity.dart';

enum BabyStatus { sleeping, awake, unknown }

class CurrentBabyStatus {
  const CurrentBabyStatus({required this.status, this.since, this.sleepingFor});

  final BabyStatus status;
  final DateTime? since;
  final Duration? sleepingFor;
}

class ActivitySummary {
  const ActivitySummary({
    required this.lastFeedingToday,
    required this.currentStatus,
    required this.completedNapsToday,
    required this.diapersToday,
  });

  final BabyActivity? lastFeedingToday;
  final CurrentBabyStatus currentStatus;
  final int completedNapsToday;
  final int diapersToday;
}

class ActivitySummaryService {
  const ActivitySummaryService();

  ActivitySummary calculate(List<BabyActivity> activities, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today =
        activities
            .where((activity) => _isSameDay(activity.occurredAt, reference))
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final sleepEvents =
        activities
            .where(
              (activity) =>
                  activity.type == ActivityType.sleepStarted ||
                  activity.type == ActivityType.sleepEnded,
            )
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final lastSleepEvent = sleepEvents.isEmpty ? null : sleepEvents.first;

    return ActivitySummary(
      lastFeedingToday: today
          .where((a) => a.type == ActivityType.feeding)
          .firstOrNull,
      currentStatus: _statusFrom(lastSleepEvent, reference),
      completedNapsToday: _completedNapsToday(today),
      diapersToday: today.where((a) => a.type == ActivityType.diaper).length,
    );
  }

  CurrentBabyStatus _statusFrom(BabyActivity? event, DateTime now) {
    if (event == null) {
      return const CurrentBabyStatus(status: BabyStatus.unknown);
    }
    if (event.type == ActivityType.sleepStarted) {
      return CurrentBabyStatus(
        status: BabyStatus.sleeping,
        since: event.occurredAt,
        sleepingFor: now.difference(event.occurredAt),
      );
    }
    return CurrentBabyStatus(status: BabyStatus.awake, since: event.occurredAt);
  }

  int _completedNapsToday(List<BabyActivity> todayNewestFirst) {
    final ascending = [...todayNewestFirst]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    var hasOpenSleep = false;
    var completed = 0;
    for (final activity in ascending) {
      if (activity.type == ActivityType.sleepStarted) {
        hasOpenSleep = true;
      }
      if (activity.type == ActivityType.sleepEnded && hasOpenSleep) {
        completed++;
        hasOpenSleep = false;
      }
    }
    return completed;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
