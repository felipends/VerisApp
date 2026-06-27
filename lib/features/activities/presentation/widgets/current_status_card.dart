import 'package:flutter/material.dart';

import '../../domain/activity_summary.dart';

class CurrentStatusCard extends StatelessWidget {
  const CurrentStatusCard({super.key, required this.summary});

  final ActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final status = summary.currentStatus;
    final title = switch (status.status) {
      BabyStatus.sleeping => 'Dormindo',
      BabyStatus.awake => 'Acordado',
      BabyStatus.unknown => 'Sem informação suficiente',
    };
    final subtitle = switch (status.status) {
      BabyStatus.sleeping => _sleepingSubtitle(status),
      BabyStatus.awake =>
        status.since == null
            ? 'Última troca de sono'
            : 'Desde ${_time(status.since!)}',
      BabyStatus.unknown => 'Registre sono ou vigília para ver o estado atual.',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCEBE9)),
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
                  'Estado atual',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF7B8794),
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
                    color: const Color(0xFF5F6B7A),
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

  String _sleepingSubtitle(CurrentBabyStatus status) {
    final since = status.since;
    final sleepingFor = status.sleepingFor;
    final parts = <String>[];
    if (since != null) parts.add('desde ${_time(since)}');
    if (sleepingFor != null) parts.add('há ${_duration(sleepingFor)}');
    return parts.isEmpty ? 'Dormindo' : 'Dormindo ${parts.join(' · ')}';
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
