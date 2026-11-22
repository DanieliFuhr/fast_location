
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_location/main.dart';

void main() {
  testWidgets('FastLocation abre a tela principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FastLocationApp());

    // Aguarda os 3 segundos da tela inicial.
    await tester.pump(const Duration(seconds: 3));

    // Aguarda a transição para a tela principal.
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Encontre um endereço'), findsOneWidget);
  });
}
