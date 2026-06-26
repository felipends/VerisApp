import 'package:flutter/material.dart';

import 'features/activities/data/activity_repository.dart';
import 'features/activities/data/local_activity_storage.dart';
import 'features/activities/presentation/activity_controller.dart';
import 'features/activities/presentation/activity_home_page.dart';

class VerisApp extends StatelessWidget {
  const VerisApp({super.key, this.controller});

  final ActivityController? controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBFAF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF69D6D2),
          primary: const Color(0xFF69D6D2),
          surface: Colors.white,
        ),
        dividerColor: const Color(0xFFE5E7EB),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1F2933),
          displayColor: const Color(0xFF1F2933),
        ),
      ),
      home: ActivityHomePage(
        controller:
            controller ??
            ActivityController(
              repository: ActivityRepository(LocalActivityStorage()),
            ),
      ),
    );
  }
}
