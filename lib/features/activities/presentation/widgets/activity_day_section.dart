import 'package:flutter/material.dart';

import '../../domain/baby_activity.dart';
import '../activity_grouping.dart';
import '../activity_strings.dart';
import 'activity_list_item.dart';

class ActivityDaySection extends StatelessWidget {
  const ActivityDaySection({
    super.key,
    required this.group,
    required this.onActivityTap,
  });

  final ActivityDayGroup group;
  final ValueChanged<BabyActivity> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final strings = ActivityStrings.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizedTitle(group.title, strings),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF7B8794),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          ...group.activities.asMap().entries.map(
            (entry) => ActivityListItem(
              activity: entry.value,
              showConnector: entry.key != group.activities.length - 1,
              onTap: () => onActivityTap(entry.value),
            ),
          ),
        ],
      ),
    );
  }

  String _localizedTitle(String title, ActivityStrings strings) =>
      switch (title) {
        'Hoje' => strings.today,
        'Ontem' => strings.yesterday,
        _ => title,
      };
}
