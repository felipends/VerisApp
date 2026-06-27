import 'package:flutter/material.dart';

enum AppThemeOption {
  defaultTheme,
  babyBlue,
  lightYellow,
  lightGreen,
  lightPink,
}

class AppThemePalette {
  const AppThemePalette({required this.primary, required this.background});

  final Color primary;
  final Color background;
}

class AppThemeService {
  const AppThemeService();

  AppThemePalette paletteFor(AppThemeOption option) => switch (option) {
    AppThemeOption.defaultTheme => const AppThemePalette(
      primary: Color(0xFF69D6D2),
      background: Color(0xFFFBFAF7),
    ),
    AppThemeOption.babyBlue => const AppThemePalette(
      primary: Color(0xFFA7D8FF),
      background: Color(0xFFF7FBFF),
    ),
    AppThemeOption.lightYellow => const AppThemePalette(
      primary: Color(0xFFFFE8A3),
      background: Color(0xFFFFFDF5),
    ),
    AppThemeOption.lightGreen => const AppThemePalette(
      primary: Color(0xFFBCEAD5),
      background: Color(0xFFF7FCF9),
    ),
    AppThemeOption.lightPink => const AppThemePalette(
      primary: Color(0xFFFFC9D6),
      background: Color(0xFFFFF8FA),
    ),
  };

  ThemeData themeDataFor(AppThemeOption option) {
    final palette = paletteFor(option);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        primary: palette.primary,
        surface: Colors.white,
      ),
      primaryColor: palette.primary,
      dividerColor: const Color(0xFFE5E7EB),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color(0xFF1F2933),
        displayColor: const Color(0xFF1F2933),
      ),
    );
  }
}
