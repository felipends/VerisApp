import 'package:flutter/material.dart';

import 'app_shell_controller.dart';
import 'mvp3_strings.dart';
import 'widgets/baby_profile_form.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.controller});

  final AppShellController controller;

  @override
  Widget build(BuildContext context) {
    final strings = Mvp3Strings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Text(
                  strings.onboardingTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.onboardingBody,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.92),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BabyProfileForm(
                      initialProfile: controller.profile,
                      primaryActionLabel: strings.start,
                      onSubmit: (profile) => controller.completeOnboarding(
                        updatedProfile: profile,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text(strings.skip),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
