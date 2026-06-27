import 'package:flutter/material.dart';

import '../domain/activity_type.dart';
import 'activity_controller.dart';
import 'widgets/activity_timeline.dart';
import 'widgets/quick_action_button.dart';

class ActivityHomePage extends StatefulWidget {
  const ActivityHomePage({super.key, required this.controller});

  final ActivityController controller;

  @override
  State<ActivityHomePage> createState() => _ActivityHomePageState();
}

class _ActivityHomePageState extends State<ActivityHomePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/images/veris_logo.png',
          height: 40,
          semanticLabel: 'Veris',
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 420 ? 32.0 : 24.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, _) {
                    final last = widget.controller.activities.firstOrNull;
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24,
                        horizontalPadding,
                        32,
                      ),
                      children: [
                        Text(
                          'Baby Log',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _todayLabel(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF7B8794)),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Última atividade',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: const Color(0xFF7B8794),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          last == null
                              ? 'Nenhum registro ainda'
                              : '${last.type.label} às ${_time(last.occurredAt)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 28),
                        ...ActivityType.values.map(
                          (type) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: QuickActionButton(
                              type: type,
                              onTap: () => _add(type),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (widget.controller.errorMessage case final message?)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              message,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ActivityTimeline(
                          activities: widget.controller.activities,
                          isLoading: widget.controller.isLoading,
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _add(ActivityType type) async {
    final activity = await widget.controller.add(type);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          activity == null
              ? 'Erro ao registrar'
              : '${type.label} registrado agora',
        ),
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    return 'Hoje, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  String _time(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
