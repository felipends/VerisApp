import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/activity_summary.dart';
import '../domain/activity_type.dart';
import '../domain/baby_activity.dart';
import 'activity_controller.dart';
import '../../app_shell/presentation/app_drawer.dart';
import '../../app_shell/presentation/app_shell_controller.dart';
import '../../app_shell/presentation/settings_page.dart';
import 'activity_strings.dart';
import 'widgets/activity_timeline.dart';
import 'widgets/current_status_card.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/edit_activity_sheet.dart';
import 'widgets/quick_action_button.dart';

class ActivityHomePage extends StatefulWidget {
  const ActivityHomePage({
    super.key,
    required this.controller,
    required this.appShellController,
  });

  final ActivityController controller;
  final AppShellController appShellController;

  @override
  State<ActivityHomePage> createState() => _ActivityHomePageState();
}

class _ActivityHomePageState extends State<ActivityHomePage> {
  static const _summaryService = ActivitySummaryService();

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        controller: widget.appShellController,
        onSettingsTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  SettingsPage(controller: widget.appShellController),
            ),
          );
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 420 ? 32.0 : 24.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, _) {
                    final activities = widget.controller.activities;
                    final summary = _summaryService.calculate(activities);
                    final strings = ActivityStrings.of(context);
                    final babyReference = strings.babyReference(
                      widget.appShellController.profile,
                    );
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24,
                        horizontalPadding,
                        32,
                      ),
                      children: [
                        Row(
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                                icon: const Icon(Icons.menu),
                                tooltip: 'Menu',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          strings.activityTitle(babyReference),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _todayLabel(context),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 28),
                        CurrentStatusCard(
                          summary: summary,
                          babyReference: babyReference,
                        ),
                        const SizedBox(height: 14),
                        DailySummaryCard(summary: summary),
                        const SizedBox(height: 20),
                        ...ActivityType.values.map(
                          (type) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: QuickActionButton(
                              type: type,
                              enabled:
                                  !widget.controller.isActionDisabled &&
                                  !widget.controller.isTypeSaving(type),
                              onTap: () => _add(type),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ActivityTimeline(
                          activities: activities,
                          isLoading: widget.controller.isLoading,
                          onActivityTap: _openEditSheet,
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
    final previousError = widget.controller.errorMessage;
    final activity = await widget.controller.add(type);
    if (!mounted) return;
    if (activity != null) {
      _showFeedbackSnackBar(ActivityStrings.of(context).registeredNow(type));
      return;
    }

    final currentError = widget.controller.errorMessage;
    if (currentError != null && currentError != previousError) {
      _showFeedbackSnackBar(currentError);
    }
  }

  void _showFeedbackSnackBar(String message) {
    final snackBarWidth = math.min(
      MediaQuery.sizeOf(context).width - 48,
      320.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: snackBarWidth,
        shape: const StadiumBorder(),
        content: Text(message, textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _openEditSheet(BabyActivity activity) async {
    await showEditActivitySheet(
      context: context,
      controller: widget.controller,
      activity: activity,
    );
  }

  String _todayLabel(BuildContext context) {
    final now = DateTime.now();
    return '${ActivityStrings.of(context).today}, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
}
