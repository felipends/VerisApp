import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veris/app.dart';
import 'package:veris/features/activities/presentation/widgets/activity_list_item.dart';
import 'package:veris/features/activities/presentation/widgets/edit_activity_sheet.dart';
import 'package:veris/features/activities/domain/activity_type.dart';
import 'package:veris/features/app_shell/domain/app_theme_option.dart';

void main() {
  setUp(() {
    seedCompletedOnboarding();
  });

  testWidgets('first access shows onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_settings': jsonEncode({'localeMode': 'system'}),
    });

    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Personalize'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining(RegExp('Pular|Skip')),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining(RegExp('Pular|Skip')), findsOneWidget);
  });

  testWidgets('skip opens home and persists onboarding completion', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app_settings': jsonEncode({'localeMode': 'system'}),
    });

    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining(RegExp('Pular|Skip')),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining(RegExp('Pular|Skip')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        RegExp('Estado atual do bebê|Current status for the baby'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Personalize'), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('baby_profile'), contains('onboardingCompletedAt'));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        RegExp('Estado atual do bebê|Current status for the baby'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Personalize'), findsNothing);
  });

  testWidgets('drawer opens by menu and navigates to settings', (tester) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(settingsFinder(), findsOneWidget);

    await tester.tap(settingsFinder());
    await tester.pumpAndSettle();

    expect(settingsFinder(), findsOneWidget);
  });

  testWidgets('settings shows privacy copy', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();
    await openSettings(tester);

    expect(find.textContaining(RegExp('dispositivo|device')), findsOneWidget);
  });

  testWidgets('settings edits and clears baby name', (tester) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();
    await openSettings(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Lia');
    await tester.tap(saveChangesFinder());
    await tester.pumpAndSettle();
    var prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('baby_profile'), contains('"name":"Lia"'));

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(saveChangesFinder());
    await tester.pumpAndSettle();
    prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('baby_profile'), contains('"name":null'));
  });

  testWidgets('settings theme selection persists', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();
    await openSettings(tester);

    await tester.scrollUntilVisible(
      find.textContaining(RegExp('Rosa|pink')),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.ensureVisible(find.textContaining(RegExp('Rosa|pink')));
    await tester.tap(find.textContaining(RegExp('Rosa|pink')));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString('baby_profile'),
      contains(AppThemeOption.lightPink.name),
    );
  });

  testWidgets('saved baby name appears in home status text', (tester) async {
    seedCompletedOnboarding(name: 'Clara', localeMode: 'pt');

    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(find.text('Atividade de Clara'), findsOneWidget);
    expect(find.text('Estado atual de Clara'), findsOneWidget);
  });

  testWidgets('onboarding theme selection waits for start to persist', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app_settings': jsonEncode({'localeMode': 'system'}),
    });

    await tester.binding.setSurfaceSize(const Size(1000, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.textContaining(RegExp('Rosa|pink')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining(RegExp('Rosa|pink')));
    await tester.pumpAndSettle();

    var prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('baby_profile'), isNull);

    await tester.scrollUntilVisible(
      find.textContaining(RegExp('Começar|Start')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining(RegExp('Começar|Start')));
    await tester.pumpAndSettle();

    prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString('baby_profile'),
      contains(AppThemeOption.lightPink.name),
    );
    expect(prefs.getString('baby_profile'), contains('onboardingCompletedAt'));
  });

  testWidgets('shows summary, status, and quick actions', (tester) async {
    seedCompletedOnboarding(localeMode: 'pt');
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(find.text('Estado atual do bebê'), findsOneWidget);
    expect(find.text('Resumo do dia'), findsOneWidget);
    expect(find.text(ActivityType.feeding.label), findsWidgets);
    expect(find.text('Ainda não registrada'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('home activity content follows English app locale', (
    tester,
  ) async {
    seedCompletedOnboarding(name: 'Clara', localeMode: 'en');

    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(find.text('Activity for Clara'), findsOneWidget);
    expect(find.text('Current status for Clara'), findsOneWidget);
    expect(find.text('Daily summary'), findsOneWidget);
    expect(find.text('Last feeding'), findsOneWidget);
    expect(find.text('Naps today'), findsOneWidget);
    expect(find.text('Diapers today'), findsOneWidget);
    expect(find.text('Not recorded yet'), findsOneWidget);
    expect(find.text('Feeding'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Diaper'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Diaper'), findsOneWidget);
  });

  testWidgets(
    'registers Fralda with one tap and updates timeline and summary',
    (tester) async {
      await tester.pumpWidget(const VerisApp());
      await tester.pumpAndSettle();

      await tapQuickAction(tester, ActivityType.diaper);
      await tester.pumpAndSettle();

      expect(find.text('Fralda registrado agora'), findsOneWidget);
      expect(find.byType(ActivityListItem), findsOneWidget);
      expect(find.text(ActivityType.diaper.label), findsWidgets);
      expect(find.text('1'), findsOneWidget);
    },
  );

  testWidgets('rapid double tap creates only one timeline activity', (
    tester,
  ) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(ActivityType.diaper.label),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    final action = find.text(ActivityType.diaper.label).first;
    await tester.tap(action);
    await tester.tap(action);
    await tester.pumpAndSettle();

    expect(find.byType(ActivityListItem), findsOneWidget);
    expect(find.text('Fralda registrado agora'), findsOneWidget);
  });

  testWidgets('edit sheet saves changed type and note in timeline', (
    tester,
  ) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();
    await tapQuickAction(tester, ActivityType.diaper);
    await tester.pumpAndSettle();

    final timelineItem = find.descendant(
      of: find.byType(ActivityListItem),
      matching: find.text(ActivityType.diaper.label),
    );
    await tester.tap(timelineItem);
    await tester.pumpAndSettle();

    final sheet = find.byType(EditActivitySheet);
    expect(sheet, findsOneWidget);
    await tester.tap(
      find.descendant(
        of: sheet,
        matching: find.text(ActivityType.feeding.label),
      ),
    );
    await tester.enterText(
      find.descendant(of: sheet, matching: find.byType(TextField)),
      'mamou pouco',
    );
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    expect(sheet, findsNothing);
    expect(find.byType(ActivityListItem), findsOneWidget);
    expect(find.text('mamou pouco'), findsOneWidget);
    expect(find.text(ActivityType.feeding.label), findsWidgets);
    expect(find.text('Fraldas hoje'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
  });

  testWidgets(
    'delete through edit sheet removes activity and recalculates summary',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const VerisApp());
      await tester.pumpAndSettle();
      await tapQuickAction(tester, ActivityType.diaper);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      final timelineItem = find.descendant(
        of: find.byType(ActivityListItem),
        matching: find.text(ActivityType.diaper.label),
      );
      await tester.tap(timelineItem);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Excluir atividade'),
        160,
        scrollable: find
            .descendant(
              of: find.byType(EditActivitySheet),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('Excluir atividade'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
      await tester.pumpAndSettle();

      expect(find.byType(ActivityListItem), findsNothing);
      expect(
        find.text(
          'Nenhuma atividade registrada hoje.\nUse os botões acima para registrar a primeira.',
        ),
        findsOneWidget,
      );
      expect(find.text('0'), findsNWidgets(2));
    },
  );

  for (final label in ActivityType.values.map((type) => type.label)) {
    testWidgets('tapping $label adds activity and shows SnackBar', (
      tester,
    ) async {
      await tester.pumpWidget(const VerisApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text(label),
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(label).first);
      await tester.pump();

      expect(find.text('$label registrado agora'), findsOneWidget);
    });
  }
}

void seedCompletedOnboarding({String? name, String localeMode = 'pt'}) {
  final completedProfile = jsonEncode({
    'name': name,
    'sex': null,
    'birthDate': null,
    'ageInMonths': null,
    'theme': 'defaultTheme',
    'createdAt': DateTime.utc(2026, 6, 27).toIso8601String(),
    'updatedAt': DateTime.utc(2026, 6, 27).toIso8601String(),
    'onboardingCompletedAt': DateTime.utc(2026, 6, 27).toIso8601String(),
  });
  SharedPreferences.setMockInitialValues({
    'baby_profile': completedProfile,
    'app_settings': jsonEncode({'localeMode': localeMode}),
  });
}

Future<void> openSettings(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Menu'));
  await tester.pumpAndSettle();
  await tester.tap(settingsFinder());
  await tester.pumpAndSettle();
}

Finder settingsFinder() =>
    find.textContaining(RegExp('Configurações|Settings'));

Finder saveChangesFinder() =>
    find.textContaining(RegExp('Salvar alterações|Save changes'));

Future<void> tapQuickAction(WidgetTester tester, ActivityType type) async {
  await tester.scrollUntilVisible(
    find.text(type.label),
    240,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text(type.label).first);
}
