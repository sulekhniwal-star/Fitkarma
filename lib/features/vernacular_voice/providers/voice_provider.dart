import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/voice_engine.dart';
import '../domain/voice_models.dart';

@immutable
class VoiceState {
  final VoiceRecordingState recordingState;
  final VernacularLanguage selectedLanguage;
  final VoiceTranscriptResult? currentTranscript;
  final List<VoiceTranscriptResult> voiceHistory;
  final VoiceAudioPrompt? audioPrompt;
  final String? errorMessage;

  const VoiceState({
    this.recordingState = VoiceRecordingState.idle,
    this.selectedLanguage = VernacularLanguage.hinglish,
    this.currentTranscript,
    this.voiceHistory = const [],
    this.audioPrompt,
    this.errorMessage,
  });

  VoiceState copyWith({
    VoiceRecordingState? recordingState,
    VernacularLanguage? selectedLanguage,
    VoiceTranscriptResult? currentTranscript,
    List<VoiceTranscriptResult>? voiceHistory,
    VoiceAudioPrompt? audioPrompt,
    String? errorMessage,
  }) {
    return VoiceState(
      recordingState: recordingState ?? this.recordingState,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentTranscript: currentTranscript ?? this.currentTranscript,
      voiceHistory: voiceHistory ?? this.voiceHistory,
      audioPrompt: audioPrompt ?? this.audioPrompt,
      errorMessage: errorMessage,
    );
  }
}

final vernacularVoiceProvider =
    StateNotifierProvider<VernacularVoiceNotifier, VoiceState>((ref) {
  return VernacularVoiceNotifier();
});

class VernacularVoiceNotifier extends StateNotifier<VoiceState> {
  VernacularVoiceNotifier() : super(_buildInitialState());

  static const VoiceEngine _engine = VoiceEngine();

  static VoiceState _buildInitialState() {
    final initialHistory = [
      _engine.processVoiceTranscript(
        transcript: '2 jowar bhakri, 1 bowl dal tadka aur taak',
        forcedLanguage: VernacularLanguage.marathi,
      ),
      _engine.processVoiceTranscript(
        transcript: 'Subah 45 minute walk kiya aur 6000 steps hue',
        forcedLanguage: VernacularLanguage.hinglish,
      ),
    ];

    return VoiceState(
      voiceHistory: initialHistory,
      currentTranscript: initialHistory.first,
      audioPrompt: _engine.generateAudioPrompt(initialHistory.first),
    );
  }

  void selectLanguage(VernacularLanguage lang) {
    state = state.copyWith(selectedLanguage: lang);
  }

  void startListening() {
    state = state.copyWith(
      recordingState: VoiceRecordingState.listening,
      errorMessage: null,
    );
  }

  void processVoiceInput(String spokenTranscript) {
    if (spokenTranscript.trim().isEmpty) {
      state = state.copyWith(
        recordingState: VoiceRecordingState.idle,
        errorMessage: 'No speech detected. Please speak clearly into the microphone.',
      );
      return;
    }

    state = state.copyWith(recordingState: VoiceRecordingState.processing);

    final result = _engine.processVoiceTranscript(
      transcript: spokenTranscript,
      forcedLanguage: state.selectedLanguage,
    );

    final prompt = _engine.generateAudioPrompt(result);

    state = state.copyWith(
      recordingState: VoiceRecordingState.success,
      currentTranscript: result,
      voiceHistory: [result, ...state.voiceHistory],
      audioPrompt: prompt,
    );
  }

  void resetSession() {
    state = state.copyWith(
      recordingState: VoiceRecordingState.idle,
      errorMessage: null,
    );
  }
}
