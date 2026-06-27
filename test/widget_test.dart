import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veris/app.dart';
import 'package:veris/features/activities/presentation/widgets/activity_list_item.dart';
import 'package:veris/features/activities/presentation/widgets/edit_activity_sheet.dart';
import 'package:veris/features/activities/domain/activity_type.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows summary, status, and quick actions', (tester) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(find.text('Estado atual'), findsOneWidget);
    expect(find.text('Resumo do dia'), findsOneWidget);
    expect(find.text(ActivityType.feeding.label), findsWidgets);
    expect(find.text('Ainda não registrada'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
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

    await tester.tap(find.byType(ActivityListItem));
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

      await tester.tap(find.byType(ActivityListItem));
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
          'Nenhuma atividade registrada hoje.\nUse os botoes acima para registrar a primeira.',
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

Future<void> tapQuickAction(WidgetTester tester, ActivityType type) async {
  await tester.scrollUntilVisible(
    find.text(type.label),
    240,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text(type.label).first);
}
