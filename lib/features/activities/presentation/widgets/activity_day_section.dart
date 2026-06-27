import 'package:flutter/material.dart';

import '../activity_grouping.dart';
import 'activity_list_item.dart';

class ActivityDaySection extends StatelessWidget {
  const ActivityDaySection({super.key, required this.group});

  final ActivityDayGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
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
            ),
          ),
        ],
      ),
    );
  }
}
