import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FitKarmaApp()));

    // Verify that onboarding appears
    expect(
      find.text('Welcome to FitKarma'),
      findsNothing,
    ); // It's in the sub-step now, wait
    // Actually the onboarding screen has "Choose your language" first.
    expect(find.text('Choose your language'), findsOneWidget);
  });
}
