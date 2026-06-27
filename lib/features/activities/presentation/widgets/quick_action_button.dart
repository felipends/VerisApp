import 'package:flutter/material.dart';

import '../../domain/activity_type.dart';
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
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: FilledButton.icon(
        onPressed: enabled ? onTap : null,
        icon: Icon(type.icon, size: 20),
        label: Text(type.label),
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: const Color(0xFFEAF8F7),
          disabledBackgroundColor: const Color(0xFFF4F5F7),
          foregroundColor: const Color(0xFF1F2933),
          disabledForegroundColor: const Color(0xFFB0B7C3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFDDEAE8)),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
