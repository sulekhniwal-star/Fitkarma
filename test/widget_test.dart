// This is a basic Flutter widget test for the Fitkarma App.
import 'package:fitkarma/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Fitkarma style guide screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitkarmaApp());

    // Verify that our branding header and tabs are present.
    expect(find.text('FITKARMA'), findsOneWidget);
    expect(find.text('Health Dashboard'), findsOneWidget);
  });
}
