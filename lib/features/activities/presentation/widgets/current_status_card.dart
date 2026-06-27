import 'package:flutter/material.dart';

import '../../domain/activity_summary.dart';
import '../activity_strings.dart';

class CurrentStatusCard extends StatelessWidget {
  const CurrentStatusCard({
    super.key,
    required this.summary,
    this.babyReference,
  });

  final ActivitySummary summary;
  final String? babyReference;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = ActivityStrings.of(context);
    final status = summary.currentStatus;
    final title = switch (status.status) {
      BabyStatus.sleeping => strings.sleeping,
      BabyStatus.awake => strings.awake,
      BabyStatus.unknown => strings.unknownStatus,
    };
    final subtitle = switch (status.status) {
      BabyStatus.sleeping => _sleepingSubtitle(status, strings),
      BabyStatus.awake =>
        status.since == null
            ? strings.lastSleepChange
            : strings.since(_time(status.since!)),
      BabyStatus.unknown => strings.recordSleepHint,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              status.status == BabyStatus.sleeping
                  ? Icons.nightlight_round
                  : status.status == BabyStatus.awake
                  ? Icons.wb_sunny_outlined
                  : Icons.help_outline,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.currentStatusFor(babyReference),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sleepingSubtitle(CurrentBabyStatus status, ActivityStrings strings) {
    final since = status.since;
    final sleepingFor = status.sleepingFor;
    final parts = <String>[];
    if (since != null) parts.add(strings.sinceLower(_time(since)));
    if (sleepingFor != null) {
      parts.add(strings.durationAgo(_duration(sleepingFor)));
    }
    return strings.sleepingSubtitle(parts);
  }

  String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String _duration(Duration value) {
    if (value.inHours >= 1) {
      final hours = value.inHours;
      final minutes = value.inMinutes.remainder(60);
      return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}min';
    }
    return '${value.inMinutes}min';
  }
}
