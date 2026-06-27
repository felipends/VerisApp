import 'app_language_option.dart';

class AppSettings {
  const AppSettings({this.localeMode = AppLanguageOption.system});

  final AppLanguageOption localeMode;

  AppSettings copyWith({AppLanguageOption? localeMode}) =>
      AppSettings(localeMode: localeMode ?? this.localeMode);

  Map<String, Object?> toJson() => {'localeMode': localeMode.name};

  factory AppSettings.fromJson(Map<String, Object?> json) => AppSettings(
    localeMode: AppLanguageOption.values.firstWhere(
      (option) => option.name == json['localeMode'],
      orElse: () => AppLanguageOption.system,
    ),
  );
}
