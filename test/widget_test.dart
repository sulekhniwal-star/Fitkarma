import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/main.dart';

void main() {
  testWidgets('FitKarmaApp launches and renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FitKarmaApp(),
      ),
    );

    expect(find.text('FitKarma'), findsOneWidget);
  });
}
