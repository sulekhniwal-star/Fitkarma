import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/main.dart';

void main() {
  testWidgets('FitKarma smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitKarmaApp());
    expect(find.text('FitKarma'), findsOneWidget);
    expect(find.text('Phase 0 Foundation Ready'), findsOneWidget);
  });
}
