import 'package:flutter/foundation.dart';

import '../data/app_settings_repository.dart';
import '../data/baby_profile_repository.dart';
import '../domain/app_language_option.dart';
import '../domain/app_settings.dart';
import '../domain/app_theme_option.dart';
import '../domain/baby_profile.dart';

class AppShellController extends ChangeNotifier {
  AppShellController({
    required this.profileRepository,
    required this.settingsRepository,
  });

  final BabyProfileRepository profileRepository;
  final AppSettingsRepository settingsRepository;

  BabyProfile? profile;
  AppSettings settings = const AppSettings();
  bool isLoading = true;
  String? errorMessage;
  bool _loaded = false;

  AppThemeOption get themeOption =>
      profile?.theme ?? AppThemeOption.defaultTheme;
  AppLanguageOption get localeMode => settings.localeMode;
  bool get hasCompletedOnboarding => profile?.hasCompletedOnboarding ?? false;

  Future<void> load() async {
    if (_loaded) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final loadedProfile = await profileRepository.load();
      final loadedSettings = await settingsRepository.load();
      profile = loadedProfile;
      settings = loadedSettings;
      _loaded = true;
    } catch (_) {
      errorMessage = 'Não foi possível carregar as configurações.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTheme(AppThemeOption theme, {DateTime? now}) async {
    final updated = (profile ?? BabyProfile.empty(now: now)).copyWith(
      theme: theme,
      updatedAt: now ?? DateTime.now(),
    );
    await updateProfile(updated);
  }

  Future<void> updateLocale(AppLanguageOption localeMode) async {
    settings = settings.copyWith(localeMode: localeMode);
    await settingsRepository.save(settings);
    notifyListeners();
  }

  Future<void> updateProfile(BabyProfile updatedProfile) async {
    const BabyReferenceService().validateAge(
      birthDate: updatedProfile.birthDate,
      ageInMonths: updatedProfile.ageInMonths,
    );
    profile = updatedProfile;
    await profileRepository.save(updatedProfile);
    notifyListeners();
  }

  Future<void> completeOnboarding({
    BabyProfile? updatedProfile,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();
    final completed =
        (updatedProfile ?? profile ?? BabyProfile.empty(now: timestamp))
            .copyWith(updatedAt: timestamp, onboardingCompletedAt: timestamp);
    await updateProfile(completed);
  }

  Future<void> skipOnboarding({DateTime? now}) async {
    final timestamp = now ?? DateTime.now();
    final skipped = (profile ?? BabyProfile.empty(now: timestamp)).copyWith(
      updatedAt: timestamp,
      onboardingCompletedAt: timestamp,
    );
    await updateProfile(skipped);
  }
}
