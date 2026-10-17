import 'package:flutter_test/flutter_test.dart';
import 'package:rim_coffee/app/app.dart';

void main() {
  testWidgets('La app abre en la pantalla de demostración', (tester) async {
    await tester.pumpWidget(const RimCoffeeApp());

    expect(find.text('Rim Coffee'), findsWidgets);
    expect(find.text('Soy cliente'), findsOneWidget);
    expect(find.text('Soy el beneficiario'), findsOneWidget);
  });
}
