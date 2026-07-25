/// §P16-B Vernacular Voice Log Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'voice_models.dart';
import 'voice_log_service.dart';

class VoiceLogState {
  const VoiceLogState({
    this.selectedLanguage = VernacularLanguage.hindi,
    this.isRecording = false,
    this.activeTranscript,
    this.lastResult,
    this.logHistory = const [],
    this.successMessage,
  });

  final VernacularLanguage selectedLanguage;
  final bool isRecording;
  final String? activeTranscript;
  final VoiceLogResult? lastResult;
  final List<VoiceLogResult> logHistory;
  final String? successMessage;

  VoiceLogState copyWith({
    VernacularLanguage? selectedLanguage,
    bool? isRecording,
    String? activeTranscript,
    VoiceLogResult? lastResult,
    List<VoiceLogResult>? logHistory,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return VoiceLogState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isRecording: isRecording ?? this.isRecording,
      activeTranscript: activeTranscript ?? this.activeTranscript,
      lastResult: lastResult ?? this.lastResult,
      logHistory: logHistory ?? this.logHistory,
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class VoiceLogNotifier extends Notifier<VoiceLogState> {
  late final VoiceLogService _service;

  @override
  VoiceLogState build() {
    _service = const VoiceLogService();
    return const VoiceLogState();
  }

  void setLanguage(VernacularLanguage language) {
    state = state.copyWith(
      selectedLanguage: language,
      successMessage: '🌐 Selected language: ${language.displayName}',
    );
  }

  void startRecording() {
    state = state.copyWith(
      isRecording: true,
      activeTranscript: '🎙️ Listening in ${state.selectedLanguage.displayName}...',
    );
  }

  void stopRecording() {
    state = state.copyWith(isRecording: false);
  }

  Future<void> processVoiceLog({String? simulatedAudioText}) async {
    state = state.copyWith(isRecording: true);

    final result = await _service.logFromVoice(
      simulatedAudioText: simulatedAudioText,
      preferredLanguage: state.selectedLanguage.code,
    );

    state = state.copyWith(
      isRecording: false,
      activeTranscript: result.transcript,
      lastResult: result,
      logHistory: [result, ...state.logHistory],
      successMessage: '✅ Logged: ${result.summary} (${result.calories} kcal)',
    );
  }
}

final voiceLogProvider = NotifierProvider<VoiceLogNotifier, VoiceLogState>(
  VoiceLogNotifier.new,
);
