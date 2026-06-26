import '../domain/baby_activity.dart';

class ActivityDayGroup {
  const ActivityDayGroup({required this.title, required this.activities});

  final String title;
  final List<BabyActivity> activities;
}

List<ActivityDayGroup> groupActivitiesByDay(
  List<BabyActivity> activities, {
  DateTime? now,
}) {
  final today = _dateOnly(now ?? DateTime.now());
  final sorted = [...activities]
    ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  final grouped = <DateTime, List<BabyActivity>>{};
  for (final activity in sorted) {
    grouped.putIfAbsent(_dateOnly(activity.occurredAt), () => []).add(activity);
  }
  return grouped.entries
      .map(
        (entry) => ActivityDayGroup(
          title: _dayTitle(entry.key, today),
          activities: entry.value,
        ),
      )
      .toList();
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _dayTitle(DateTime date, DateTime today) {
  if (date == today) return 'Hoje';
  if (date == today.subtract(const Duration(days: 1))) return 'Ontem';
  return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
