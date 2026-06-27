import 'package:flutter/material.dart';

import '../domain/baby_profile.dart';
import 'app_shell_controller.dart';
import 'mvp3_strings.dart';
import 'widgets/baby_profile_form.dart';
import 'widgets/language_selector.dart';
import 'widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.controller});

  final AppShellController controller;

  @override
  Widget build(BuildContext context) {
    final strings = Mvp3Strings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final profile = controller.profile;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionCard(
                  title: strings.babySection,
                  child: BabyProfileForm(
                    initialProfile: profile,
                    primaryActionLabel: strings.saveChanges,
                    showThemeSelector: false,
                    onSubmit: (updatedProfile) => controller.updateProfile(
                      _preserveOnboardingState(
                        profile,
                        updatedProfile.copyWith(theme: controller.themeOption),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: strings.appearanceSection,
                  child: ThemeSelector(
                    selected: controller.themeOption,
                    onSelected: (theme) => controller.updateTheme(theme),
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: strings.languageSection,
                  child: LanguageSelector(
                    selected: controller.localeMode,
                    onSelected: (mode) => controller.updateLocale(mode),
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: strings.privacySection,
                  child: Text(
                    strings.privacyBody,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BabyProfile _preserveOnboardingState(
    BabyProfile? current,
    BabyProfile updated,
  ) {
    if (current == null) return updated;
    return updated.copyWith(
      onboardingCompletedAt: current.onboardingCompletedAt,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
