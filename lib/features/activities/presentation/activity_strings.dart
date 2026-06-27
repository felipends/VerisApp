import 'package:flutter/material.dart';

import '../domain/activity_type.dart';
import '../../app_shell/domain/baby_profile.dart';

class ActivityStrings {
  ActivityStrings._(this.isEnglish);

  final bool isEnglish;

  static ActivityStrings of(BuildContext context) =>
      ActivityStrings._(Localizations.localeOf(context).languageCode == 'en');

  String babyReference(BabyProfile? profile) {
    final name = profile?.name?.trim();
    if (name != null && name.isNotEmpty) {
      return isEnglish ? 'for $name' : 'de $name';
    }
    if (isEnglish) return 'for the baby';
    return switch (profile?.sex) {
      BabySex.female => 'da bebê',
      BabySex.male || BabySex.notInformed || null => 'do bebê',
    };
  }

  String activityTitle(String babyReference) =>
      isEnglish ? 'Activity $babyReference' : 'Atividade $babyReference';

  String currentStatusFor(String? babyReference) {
    if (babyReference == null) {
      return isEnglish ? 'Current status' : 'Estado atual';
    }
    return isEnglish
        ? 'Current status $babyReference'
        : 'Estado atual $babyReference';
  }

  String get today => isEnglish ? 'Today' : 'Hoje';
  String get yesterday => isEnglish ? 'Yesterday' : 'Ontem';
  String get dailySummary => isEnglish ? 'Daily summary' : 'Resumo do dia';
  String get lastFeeding => isEnglish ? 'Last feeding' : 'Última mamada';
  String get napsToday => isEnglish ? 'Naps today' : 'Sonecas hoje';
  String get diapersToday => isEnglish ? 'Diapers today' : 'Fraldas hoje';
  String get notRecordedYet =>
      isEnglish ? 'Not recorded yet' : 'Ainda não registrada';
  String get noActivitiesToday => isEnglish
      ? 'No activity recorded today.\nUse the buttons above to record the first one.'
      : 'Nenhuma atividade registrada hoje.\nUse os botões acima para registrar a primeira.';

  String get sleeping => isEnglish ? 'Sleeping' : 'Dormindo';
  String get awake => isEnglish ? 'Awake' : 'Acordado';
  String get unknownStatus =>
      isEnglish ? 'Not enough information' : 'Sem informação suficiente';
  String get lastSleepChange =>
      isEnglish ? 'Last sleep change' : 'Última troca de sono';
  String get recordSleepHint => isEnglish
      ? 'Record sleep or wake-up to see the current status.'
      : 'Registre sono ou vigília para ver o estado atual.';
  String since(String time) => isEnglish ? 'Since $time' : 'Desde $time';
  String sleepingSubtitle(List<String> parts) =>
      parts.isEmpty ? sleeping : '$sleeping ${parts.join(' · ')}';
  String sinceLower(String time) => isEnglish ? 'since $time' : 'desde $time';
  String durationAgo(String duration) =>
      isEnglish ? 'for $duration' : 'há $duration';

  String activityType(ActivityType type) => switch (type) {
    ActivityType.feeding => isEnglish ? 'Feeding' : 'Mamou',
    ActivityType.sleepStarted => isEnglish ? 'Fell asleep' : 'Dormiu',
    ActivityType.sleepEnded => isEnglish ? 'Woke up' : 'Acordou',
    ActivityType.diaper => isEnglish ? 'Diaper' : 'Fralda',
  };

  String registeredNow(ActivityType type) => isEnglish
      ? '${activityType(type)} recorded just now'
      : '${activityType(type)} registrado agora';
}
