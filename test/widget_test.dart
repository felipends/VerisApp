import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veris/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows empty state', (tester) async {
    await tester.pumpWidget(const VerisApp());
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Nenhuma atividade registrada hoje.\nUse os botoes acima para registrar a primeira.',
      ),
      findsOneWidget,
    );
  });

  for (final label in ['Mamou', 'Dormiu', 'Acordou']) {
    testWidgets('tapping $label adds activity and shows SnackBar', (
      tester,
    ) async {
      await tester.pumpWidget(const VerisApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text(label).first);
      await tester.pump();

      expect(find.text('$label registrado agora'), findsOneWidget);
      expect(find.text('Hoje'), findsWidgets);
      expect(find.text(label), findsWidgets);
    });
  }
}
