// §P16-B Voice Log Riverpod Provider & State Management
// Cross-reference: §P16-B in Fitkarma_documentation.md

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/voice_log_service.dart';

class VoiceLogState {
  final bool isRecording;
  final bool isProcessing;
  final VernacularLanguage selectedLanguage;
  final String? transcript;
  final VoiceLogResult? result;
  final String? error;

  const VoiceLogState({
    this.isRecording = false,
    this.isProcessing = false,
    this.selectedLanguage = VernacularLanguage.hindi,
    this.transcript,
    this.result,
    this.error,
  });

  VoiceLogState copyWith({
    bool? isRecording,
    bool? isProcessing,
    VernacularLanguage? selectedLanguage,
    String? transcript,
    VoiceLogResult? result,
    String? error,
  }) {
    return VoiceLogState(
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      transcript: transcript ?? this.transcript,
      result: result ?? this.result,
      error: error,
    );
  }
}

class VoiceLogNotifier extends StateNotifier<VoiceLogState> {
  final VoiceLogService _service;

  VoiceLogNotifier(this._service) : super(const VoiceLogState());

  void setLanguage(VernacularLanguage language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void startRecording() {
    state = state.copyWith(
      isRecording: true,
      isProcessing: false,
      transcript: null,
      result: null,
      error: null,
    );
  }

  Future<void> stopRecordingAndProcess({Uint8List? customAudioBytes}) async {
    state = state.copyWith(isRecording: false, isProcessing: true);

    try {
      final audioBytes = customAudioBytes ?? Uint8List.fromList([0, 1, 2, 3]);
      final logResult = await _service.logFromVoice(
        audioBytes: audioBytes,
        preferredLanguage: state.selectedLanguage,
      );

      state = state.copyWith(
        isProcessing: false,
        transcript: logResult.rawTranscript,
        result: logResult,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Voice transcription failed. Please try again.',
      );
    }
  }

  void reset() {
    state = VoiceLogState(selectedLanguage: state.selectedLanguage);
  }
}

final voiceLogProvider =
    StateNotifierProvider<VoiceLogNotifier, VoiceLogState>((ref) {
  final service = ref.watch(voiceLogServiceProvider);
  return VoiceLogNotifier(service);
});
