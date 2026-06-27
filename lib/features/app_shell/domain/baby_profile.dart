import 'app_theme_option.dart';

enum BabySex { female, male, notInformed }

class BabyProfile {
  const BabyProfile({
    this.name,
    this.sex,
    this.birthDate,
    this.ageInMonths,
    this.theme = AppThemeOption.defaultTheme,
    required this.createdAt,
    required this.updatedAt,
    this.onboardingCompletedAt,
  });

  factory BabyProfile.empty({DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    return BabyProfile(createdAt: timestamp, updatedAt: timestamp);
  }

  final String? name;
  final BabySex? sex;
  final DateTime? birthDate;
  final int? ageInMonths;
  final AppThemeOption theme;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? onboardingCompletedAt;

  bool get hasCompletedOnboarding => onboardingCompletedAt != null;

  BabyProfile copyWith({
    Object? name = _unset,
    Object? sex = _unset,
    Object? birthDate = _unset,
    Object? ageInMonths = _unset,
    AppThemeOption? theme,
    DateTime? updatedAt,
    Object? onboardingCompletedAt = _unset,
  }) {
    return BabyProfile(
      name: name == _unset ? this.name : name as String?,
      sex: sex == _unset ? this.sex : sex as BabySex?,
      birthDate: birthDate == _unset ? this.birthDate : birthDate as DateTime?,
      ageInMonths: ageInMonths == _unset
          ? this.ageInMonths
          : ageInMonths as int?,
      theme: theme ?? this.theme,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      onboardingCompletedAt: onboardingCompletedAt == _unset
          ? this.onboardingCompletedAt
          : onboardingCompletedAt as DateTime?,
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'sex': sex?.name,
    'birthDate': birthDate?.toIso8601String(),
    'ageInMonths': ageInMonths,
    'theme': theme.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'onboardingCompletedAt': onboardingCompletedAt?.toIso8601String(),
  };

  factory BabyProfile.fromJson(Map<String, Object?> json) => BabyProfile(
    name: json['name'] as String?,
    sex: _enumByName(BabySex.values, json['sex'] as String?),
    birthDate: _date(json['birthDate'] as String?),
    ageInMonths: json['ageInMonths'] as int?,
    theme:
        _enumByName(AppThemeOption.values, json['theme'] as String?) ??
        AppThemeOption.defaultTheme,
    createdAt: _date(json['createdAt'] as String?) ?? DateTime.now(),
    updatedAt: _date(json['updatedAt'] as String?) ?? DateTime.now(),
    onboardingCompletedAt: _date(json['onboardingCompletedAt'] as String?),
  );
}

const _unset = Object();

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

DateTime? _date(String? value) =>
    value == null ? null : DateTime.tryParse(value);

class BabyReferenceService {
  const BabyReferenceService();

  String referenceFor(BabyProfile? profile) {
    final name = profile?.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    return switch (profile?.sex) {
      BabySex.female => 'A bebê',
      BabySex.male || BabySex.notInformed || null => 'O bebê',
    };
  }

  void validateAge({DateTime? birthDate, int? ageInMonths, DateTime? now}) {
    if (birthDate != null && ageInMonths != null) {
      throw ArgumentError('birthDate and ageInMonths are mutually exclusive.');
    }
    if (birthDate != null && birthDate.isAfter(now ?? DateTime.now())) {
      throw ArgumentError('birthDate cannot be in the future.');
    }
    if (ageInMonths != null && (ageInMonths < 0 || ageInMonths > 36)) {
      throw ArgumentError('ageInMonths must be between 0 and 36.');
    }
  }
}
