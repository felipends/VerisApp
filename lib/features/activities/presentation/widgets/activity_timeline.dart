import 'package:flutter/material.dart';

import '../../domain/baby_activity.dart';
import '../activity_grouping.dart';
import '../activity_strings.dart';
import 'activity_day_section.dart';

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({
    super.key,
    required this.activities,
    required this.isLoading,
    required this.onActivityTap,
  });

  final List<BabyActivity> activities;
  final bool isLoading;
  final ValueChanged<BabyActivity> onActivityTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.2)),
      );
    }
    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Text(
          ActivityStrings.of(context).noActivitiesToday,
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF7B8794), height: 1.45),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupActivitiesByDay(activities)
          .map(
            (group) =>
                ActivityDaySection(group: group, onActivityTap: onActivityTap),
          )
          .toList(),
    );
  }
}
