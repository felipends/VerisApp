import 'package:flutter/material.dart';

import '../../domain/activity_type.dart';
import '../activity_strings.dart';
import '../activity_type_icon.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.type,
    required this.onTap,
    this.enabled = true,
  });

  final ActivityType type;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: FilledButton.icon(
        onPressed: enabled ? onTap : null,
        icon: Icon(type.icon, size: 20),
        label: Text(ActivityStrings.of(context).activityType(type)),
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: colors.primaryContainer.withValues(alpha: 0.55),
          disabledBackgroundColor: colors.surfaceContainerHighest,
          foregroundColor: colors.onPrimaryContainer,
          disabledForegroundColor: colors.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colors.primary.withValues(alpha: 0.16)),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
