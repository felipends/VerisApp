import 'package:flutter/material.dart';

import '../../domain/activity_type.dart';
import '../../domain/baby_activity.dart';
import '../activity_controller.dart';
import '../activity_strings.dart';

Future<void> showEditActivitySheet({
  required BuildContext context,
  required ActivityController controller,
  required BabyActivity activity,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) =>
        EditActivitySheet(controller: controller, activity: activity),
  );
}

class EditActivitySheet extends StatefulWidget {
  const EditActivitySheet({
    super.key,
    required this.controller,
    required this.activity,
  });

  final ActivityController controller;
  final BabyActivity activity;

  @override
  State<EditActivitySheet> createState() => _EditActivitySheetState();
}

class _EditActivitySheetState extends State<EditActivitySheet> {
  late ActivityType _type;
  late DateTime _date;
  late TimeOfDay _timeOfDay;
  late final TextEditingController _noteController;

  bool _working = false;

  @override
  void initState() {
    super.initState();
    _type = widget.activity.type;
    _date = DateTime(
      widget.activity.occurredAt.year,
      widget.activity.occurredAt.month,
      widget.activity.occurredAt.day,
    );
    _timeOfDay = TimeOfDay.fromDateTime(widget.activity.occurredAt);
    _noteController = TextEditingController(text: widget.activity.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final strings = ActivityStrings.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final busy = _working || widget.controller.isSaving;
          return FractionallySizedBox(
            heightFactor: 0.94,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.isEnglish ? 'Edit activity' : 'Editar atividade',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.isEnglish
                      ? 'Adjust anything that is wrong and save.'
                      : 'Ajuste o que estiver errado e salve.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B8794),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.isEnglish ? 'Type' : 'Tipo',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF5F6B7A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ActivityType.values
                      .map(
                        (type) => ChoiceChip(
                          label: Text(strings.activityType(type)),
                          selected: _type == type,
                          onSelected: busy
                              ? null
                              : (_) => setState(() => _type = type),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _type == type
                                ? const Color(0xFF1F2933)
                                : const Color(0xFF5F6B7A),
                          ),
                          selectedColor: const Color(0xFFDDF4F2),
                          backgroundColor: const Color(0xFFF7F8FA),
                          side: const BorderSide(color: Color(0xFFE6E9EF)),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                _ActionField(
                  label: strings.isEnglish ? 'Date' : 'Data',
                  value: _dateLabel(context),
                  icon: Icons.calendar_today_outlined,
                  onTap: busy ? null : _pickDate,
                ),
                const SizedBox(height: 12),
                _ActionField(
                  label: strings.isEnglish ? 'Time' : 'Horário',
                  value: _timeLabel(context),
                  icon: Icons.schedule_outlined,
                  onTap: busy ? null : _pickTime,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _noteController,
                  enabled: !busy,
                  maxLines: 2,
                  maxLength: 80,
                  decoration: InputDecoration(
                    labelText: strings.isEnglish
                        ? 'Note (optional)'
                        : 'Observação (opcional)',
                    hintText: strings.isEnglish
                        ? 'E.g.: fed a little'
                        : 'Ex.: mamou pouco',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: busy ? null : _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: Text(
                    busy
                        ? (strings.isEnglish ? 'Saving...' : 'Salvando...')
                        : (strings.isEnglish
                              ? 'Save changes'
                              : 'Salvar alterações'),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: busy ? null : _confirmDelete,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFFB42318),
                    side: const BorderSide(color: Color(0xFFF2B8B5)),
                  ),
                  child: Text(
                    strings.isEnglish ? 'Delete activity' : 'Excluir atividade',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(
      () => _date = DateTime(selected.year, selected.month, selected.day),
    );
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _timeOfDay,
    );
    if (selected == null || !mounted) return;
    setState(() => _timeOfDay = selected);
  }

  Future<void> _save() async {
    setState(() => _working = true);
    final occurredAt = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
    );
    final note = _noteController.text.trim();
    final updated = widget.activity.copyWith(
      type: _type,
      occurredAt: occurredAt,
      note: note.isEmpty ? null : note,
    );
    final saved = await widget.controller.update(updated);
    if (!mounted) return;
    setState(() => _working = false);

    if (saved != null) {
      Navigator.of(context).pop();
      return;
    }

    final error = widget.controller.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          ActivityStrings.of(context).isEnglish
              ? 'Delete activity?'
              : 'Excluir atividade?',
        ),
        content: Text(
          ActivityStrings.of(context).isEnglish
              ? 'This action cannot be undone.'
              : 'Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              ActivityStrings.of(context).isEnglish ? 'Cancel' : 'Cancelar',
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              ActivityStrings.of(context).isEnglish ? 'Delete' : 'Excluir',
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _working = true);
    final deleted = await widget.controller.delete(widget.activity.id);
    if (!mounted) return;
    setState(() => _working = false);

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ActivityStrings.of(context).isEnglish
                ? 'Activity deleted'
                : 'Atividade excluída',
          ),
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    final error = widget.controller.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  String _dateLabel(BuildContext context) {
    final date = _date;
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  String _timeLabel(BuildContext context) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(_timeOfDay, alwaysUse24HourFormat: true);
  }
}

class _ActionField extends StatelessWidget {
  const _ActionField({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF5F6B7A)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B8794),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right, color: Color(0xFFC1C7D0)),
          ],
        ),
      ),
    );
  }
}
