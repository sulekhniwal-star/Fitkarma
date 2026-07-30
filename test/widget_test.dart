import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/main.dart';

void main() {
  testWidgets('FitKarma smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FitKarmaApp()));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to FitKarma'), findsOneWidget);
  });
}
