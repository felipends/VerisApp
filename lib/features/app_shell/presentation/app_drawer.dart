import 'package:flutter/material.dart';

import 'mvp3_strings.dart';
import 'app_shell_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.controller,
    required this.onSettingsTap,
  });

  final AppShellController controller;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final strings = Mvp3Strings.of(context);
    final babyName = controller.profile?.name?.trim();
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Veris',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    babyName == null || babyName.isEmpty
                        ? strings.appSubtitle
                        : babyName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text(strings.home),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(strings.settings),
              onTap: onSettingsTap,
            ),
          ],
        ),
      ),
    );
  }
}
