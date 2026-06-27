import 'package:flutter/material.dart';

import '../../domain/app_language_option.dart';
import '../mvp3_strings.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AppLanguageOption selected;
  final ValueChanged<AppLanguageOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = Mvp3Strings.of(context);
    return SegmentedButton<AppLanguageOption>(
      segments: [
        ButtonSegment(
          value: AppLanguageOption.system,
          label: Text(strings.system),
        ),
        ButtonSegment(
          value: AppLanguageOption.pt,
          label: Text(strings.portuguese),
        ),
        ButtonSegment(
          value: AppLanguageOption.en,
          label: Text(strings.english),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) {
        if (selection.isEmpty) return;
        onSelected(selection.first);
      },
    );
  }
}
