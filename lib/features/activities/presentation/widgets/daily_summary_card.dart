import 'package:flutter/material.dart';

import '../../domain/activity_summary.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key, required this.summary});

  final ActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E9EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do dia',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF7B8794),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Última mamada', value: _feedingValue()),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Sonecas hoje',
            value: '${summary.completedNapsToday}',
          ),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Fraldas hoje', value: '${summary.diapersToday}'),
        ],
      ),
    );
  }

  String _feedingValue() => summary.lastFeedingToday == null
      ? 'Ainda não registrada'
      : _time(summary.lastFeedingToday!.occurredAt);

  String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5F6B7A),
              fontSize: 15,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
