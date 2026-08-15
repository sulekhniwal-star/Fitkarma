import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/nutrition/widgets/voice_log_bottom_sheet.dart';
import 'package:fitkarma/features/nutrition/providers/voice_log_provider.dart';
import 'package:fitkarma/core/brain/voice_log_service.dart';

void main() {
  testWidgets('§P16-B VoiceLogBottomSheet renders mic, language picker, and confirms transcribed meal',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer(
      overrides: [
        speechToTextClientProvider.overrideWithValue(
          const MockSpeechToTextClient(simulatedTranscript: '2 Paneer Tikka and Roti'),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: VoiceLogBottomSheet(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Voice Logging'), findsOneWidget);
    expect(find.text('Hindi (हिंदी)'), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsWidgets);

    // Tap mic to start recording
    await tester.tap(find.byKey(const Key('mic_button')));
    await tester.pumpAndSettle();

    expect(container.read(voiceLogProvider).isRecording, isTrue);

    // Tap stop to process
    await tester.tap(find.byKey(const Key('mic_button')));
    await tester.pumpAndSettle();

    // Result card appears
    expect(find.text('Transcribed:'), findsOneWidget);
    expect(find.text('"2 Paneer Tikka and Roti"'), findsOneWidget);
    expect(find.text('Confirm & Log Meal'), findsOneWidget);
  });
}
