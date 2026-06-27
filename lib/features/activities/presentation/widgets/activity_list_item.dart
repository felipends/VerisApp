import 'package:flutter/material.dart';

import '../../domain/baby_activity.dart';
import '../activity_strings.dart';
import '../activity_type_icon.dart';

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({
    super.key,
    required this.activity,
    this.showConnector = true,
    this.onTap,
  });

  final BabyActivity activity;
  final bool showConnector;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
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
                          height: showConnector ? 36 : 0,
                          color: const Color(0xFFE5E7EB),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            activity.type.icon,
                            size: 16,
                            color: const Color(0xFF7B8794),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ActivityStrings.of(
                              context,
                            ).activityType(activity.type),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (onTap != null)
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Color(0xFFC1C7D0),
                            ),
                        ],
                      ),
                      if (activity.note case final note?) ...[
                        const SizedBox(height: 5),
                        Text(
                          note,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7B8794),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _time(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
