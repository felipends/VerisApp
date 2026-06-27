import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/activities/data/activity_repository.dart';
import 'features/activities/data/local_activity_storage.dart';
import 'features/activities/presentation/activity_controller.dart';
import 'features/activities/presentation/activity_home_page.dart';
import 'features/app_shell/data/app_settings_repository.dart';
import 'features/app_shell/data/baby_profile_repository.dart';
import 'features/app_shell/domain/app_language_option.dart';
import 'features/app_shell/domain/app_theme_option.dart';
import 'features/app_shell/presentation/app_shell_controller.dart';
import 'features/app_shell/presentation/onboarding_page.dart';

class VerisApp extends StatefulWidget {
  const VerisApp({super.key, this.controller, this.appShellController});

  final ActivityController? controller;
  final AppShellController? appShellController;

  @override
  State<VerisApp> createState() => _VerisAppState();
}

class _VerisAppState extends State<VerisApp> {
  late final ActivityController _activityController;
  late final AppShellController _appShellController;
  final _themeService = const AppThemeService();
  final _localeService = const AppLocaleService();

  @override
  void initState() {
    super.initState();
    _activityController =
        widget.controller ??
        ActivityController(
          repository: ActivityRepository(LocalActivityStorage()),
        );
    _appShellController =
        widget.appShellController ??
        AppShellController(
          profileRepository: BabyProfileRepository(),
          settingsRepository: AppSettingsRepository(),
        );
    _appShellController.load();
  }

  @override
  void dispose() {
    if (widget.controller == null) _activityController.dispose();
    if (widget.appShellController == null) _appShellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appShellController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Veris',
          debugShowCheckedModeBanner: false,
          theme: _themeService.themeDataFor(_appShellController.themeOption),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocaleService.supportedLocales,
          locale: _localeService.localeFor(_appShellController.localeMode),
          localeResolutionCallback: (locale, supportedLocales) =>
              _localeService.resolve(locale, supportedLocales),
          home: _homeForShell(),
        );
      },
    );
  }

  Widget _homeForShell() {
    if (_appShellController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_appShellController.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(_appShellController.errorMessage!)),
      );
    }
    if (!_appShellController.hasCompletedOnboarding) {
      return OnboardingPage(controller: _appShellController);
    }
    return ActivityHomePage(
      controller: _activityController,
      appShellController: _appShellController,
    );
  }
}
