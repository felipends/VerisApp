import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/app_theme_option.dart';
import '../../domain/baby_profile.dart';
import '../mvp3_strings.dart';
import 'theme_selector.dart';

enum _AgeInputMode { birthDate, ageMonths }

class BabyProfileForm extends StatefulWidget {
  const BabyProfileForm({
    super.key,
    required this.onSubmit,
    this.initialProfile,
    this.primaryActionLabel,
    this.showThemeSelector = true,
    this.onThemeChanged,
  });

  final BabyProfile? initialProfile;
  final Future<void> Function(BabyProfile profile) onSubmit;
  final String? primaryActionLabel;
  final bool showThemeSelector;
  final ValueChanged<AppThemeOption>? onThemeChanged;

  @override
  State<BabyProfileForm> createState() => _BabyProfileFormState();
}

class _BabyProfileFormState extends State<BabyProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _monthsController;
  BabySex? _sex;
  _AgeInputMode? _ageMode;
  DateTime? _birthDate;
  late AppThemeOption _theme;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _monthsController = TextEditingController(
      text: profile?.ageInMonths?.toString() ?? '',
    );
    _sex = profile?.sex;
    _birthDate = profile?.birthDate;
    _ageMode = profile?.birthDate != null
        ? _AgeInputMode.birthDate
        : profile?.ageInMonths != null
        ? _AgeInputMode.ageMonths
        : null;
    _theme = profile?.theme ?? AppThemeOption.defaultTheme;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = Mvp3Strings.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: strings.nameLabel,
              hintText: strings.nameHint,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _SectionLabel(label: strings.sexLabel),
          const SizedBox(height: 8),
          SegmentedButton<BabySex>(
            segments: [
              ButtonSegment(value: BabySex.female, label: Text(strings.female)),
              ButtonSegment(value: BabySex.male, label: Text(strings.male)),
              ButtonSegment(
                value: BabySex.notInformed,
                label: Text(strings.preferNotToSay),
              ),
            ],
            selected: _sex == null ? <BabySex>{} : {_sex!},
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              setState(() {
                _sex = selection.isEmpty ? null : selection.first;
              });
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _sex == null
                  ? null
                  : () => setState(() {
                      _sex = null;
                    }),
              child: Text(strings.clear),
            ),
          ),
          const SizedBox(height: 4),
          _SectionLabel(label: strings.ageLabel),
          const SizedBox(height: 8),
          SegmentedButton<_AgeInputMode>(
            segments: [
              ButtonSegment(
                value: _AgeInputMode.birthDate,
                label: Text(strings.birthDateMode),
              ),
              ButtonSegment(
                value: _AgeInputMode.ageMonths,
                label: Text(strings.ageMonthsMode),
              ),
            ],
            selected: _ageMode == null ? <_AgeInputMode>{} : {_ageMode!},
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              setState(() {
                _ageMode = selection.isEmpty ? null : selection.first;
                if (_ageMode == _AgeInputMode.birthDate) {
                  _monthsController.clear();
                } else if (_ageMode == _AgeInputMode.ageMonths) {
                  _birthDate = null;
                }
              });
            },
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (_ageMode) {
              _AgeInputMode.birthDate => _BirthDatePicker(
                key: const ValueKey('birth-date'),
                birthDate: _birthDate,
                onPick: _pickBirthDate,
                onClear: _clearAge,
                label: strings.birthDateLabel,
                clearLabel: strings.clear,
              ),
              _AgeInputMode.ageMonths => _MonthsField(
                key: const ValueKey('age-months'),
                controller: _monthsController,
                label: strings.ageMonthsLabel,
                onClear: _clearAge,
                clearLabel: strings.clear,
              ),
              null => _AgeHint(
                key: const ValueKey('age-empty'),
                hint: strings.selectAgeHint,
              ),
            },
          ),
          const SizedBox(height: 16),
          if (widget.showThemeSelector) ...[
            _SectionLabel(label: strings.themeLabel),
            const SizedBox(height: 8),
            ThemeSelector(
              selected: _theme,
              onSelected: (theme) {
                setState(() {
                  _theme = theme;
                });
                widget.onThemeChanged?.call(theme);
              },
            ),
          ],
          if (widget.primaryActionLabel != null) ...[
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _submit,
              child: Text(widget.primaryActionLabel!),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (picked == null) return;
    setState(() {
      _ageMode = _AgeInputMode.birthDate;
      _birthDate = picked;
      _monthsController.clear();
    });
  }

  void _clearAge() {
    setState(() {
      _ageMode = null;
      _birthDate = null;
      _monthsController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    const BabyReferenceService().validateAge(
      birthDate: _birthDate,
      ageInMonths: _ageMode == _AgeInputMode.ageMonths
          ? int.tryParse(_monthsController.text.trim())
          : null,
    );

    final now = DateTime.now();
    final base = widget.initialProfile ?? BabyProfile.empty(now: now);
    final months = _ageMode == _AgeInputMode.ageMonths
        ? int.tryParse(_monthsController.text.trim())
        : null;
    await widget.onSubmit(
      base.copyWith(
        name: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        sex: _sex,
        birthDate: _birthDate,
        ageInMonths: months,
        theme: _theme,
        updatedAt: now,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _BirthDatePicker extends StatelessWidget {
  const _BirthDatePicker({
    super.key,
    required this.birthDate,
    required this.onPick,
    required this.onClear,
    required this.label,
    required this.clearLabel,
  });

  final DateTime? birthDate;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final String label;
  final String clearLabel;

  @override
  Widget build(BuildContext context) {
    final text = birthDate == null
        ? label
        : '${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(onPressed: onPick, child: Text(text)),
        if (onClear != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: onClear, child: Text(clearLabel)),
          ),
      ],
    );
  }
}

class _MonthsField extends StatelessWidget {
  const _MonthsField({
    super.key,
    required this.controller,
    required this.label,
    required this.onClear,
    required this.clearLabel,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback? onClear;
  final String clearLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, hintText: '0-36'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            final parsed = int.tryParse(value.trim());
            if (parsed == null || parsed < 0 || parsed > 36) {
              return '0-36';
            }
            return null;
          },
        ),
        if (onClear != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: onClear, child: Text(clearLabel)),
          ),
      ],
    );
  }
}

class _AgeHint extends StatelessWidget {
  const _AgeHint({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
