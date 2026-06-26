import 'package:flutter/material.dart';

import '../../domain/baby_activity.dart';
import '../activity_type_icon.dart';

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({
    super.key,
    required this.activity,
    this.showConnector = true,
  });

  final BabyActivity activity;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              _time(activity.occurredAt),
              style: const TextStyle(
                color: Color(0xFF7B8794),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 18,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 1,
                    height: showConnector ? 28 : 0,
                    color: const Color(0xFFE5E7EB),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Icon(
                  activity.type.icon,
                  size: 16,
                  color: const Color(0xFF7B8794),
                ),
                const SizedBox(width: 8),
                Text(
                  activity.type.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _time(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
