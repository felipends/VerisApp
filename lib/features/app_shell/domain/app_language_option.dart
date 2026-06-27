import 'package:flutter/widgets.dart';

enum AppLanguageOption { system, pt, en }

class AppLocaleService {
  const AppLocaleService();

  static const supportedLocales = <Locale>[Locale('pt'), Locale('en')];

  Locale? localeFor(AppLanguageOption option) => switch (option) {
    AppLanguageOption.system => null,
    AppLanguageOption.pt => const Locale('pt'),
    AppLanguageOption.en => const Locale('en'),
  };

  Locale resolve(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return const Locale('pt');
    for (final supportedLocale in supported) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('pt');
  }
}
