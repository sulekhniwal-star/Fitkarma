/// §P12-D AI Roast Mode & Persona Tone Management
///
/// Implements opt-in Roast mode, 4 tone variants (gentle, motivational, roast, no_nonsense),
/// system prompt tone injection, and automatic distress/crisis safety overrides matching §P12-D spec.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AiCoachTone {
  gentle,
  motivational,
  roast,
  noNonsense;

  String get displayName => switch (this) {
        gentle => '🌱 Gentle',
        motivational => '🔥 Motivational',
        roast => '🌶️ Roast Mode',
        noNonsense => '⚡ No-Nonsense',
      };

  String get systemPromptInstruction => switch (this) {
        gentle =>
          'Tone: Gentle. Empathetic, warm, encouraging framing. Focus on effort and self-compassion.',
        motivational =>
          'Tone: Motivational. High-energy, inspiring, action-oriented. Empower the user with vision and momentum.',
        roast =>
          'Tone: Roast. Witty, sarcastic, tough-love humor exposing excuses. Keep it playful, safe, and actionable without being mean-spirited.',
        noNonsense =>
          'Tone: No-Nonsense. Direct, concise, data-driven. Zero fluff, precise numbers and bulleted action steps.',
      };
}

class AiCoachToneState {
  const AiCoachToneState({
    this.selectedTone = AiCoachTone.motivational,
    this.isCrisisOverrideActive = false,
    this.lastDistressKeyword,
  });

  final AiCoachTone selectedTone;
  final bool isCrisisOverrideActive;
  final String? lastDistressKeyword;

  bool get isRoastEnabled => selectedTone == AiCoachTone.roast && !isCrisisOverrideActive;

  /// Effective tone evaluated after crisis/distress guardrails.
  AiCoachTone get effectiveTone {
    if (isCrisisOverrideActive) return AiCoachTone.gentle;
    return selectedTone;
  }

  String get promptInstruction => effectiveTone.systemPromptInstruction;

  AiCoachToneState copyWith({
    AiCoachTone? selectedTone,
    bool? isCrisisOverrideActive,
    String? lastDistressKeyword,
    bool clearOverride = false,
  }) {
    return AiCoachToneState(
      selectedTone: selectedTone ?? this.selectedTone,
      isCrisisOverrideActive: clearOverride
          ? false
          : (isCrisisOverrideActive ?? this.isCrisisOverrideActive),
      lastDistressKeyword: clearOverride
          ? null
          : (lastDistressKeyword ?? this.lastDistressKeyword),
    );
  }
}

class AiCoachToneNotifier extends Notifier<AiCoachToneState> {
  static const List<String> distressKeywords = [
    'pain',
    'hurt',
    'injured',
    'depression',
    'crying',
    'anxiety',
    'hopeless',
    'suicide',
    'dizzy',
    'fainted',
    'sick',
    'vomiting',
  ];

  @override
  AiCoachToneState build() {
    return const AiCoachToneState(selectedTone: AiCoachTone.motivational);
  }

  void setTone(AiCoachTone tone) {
    state = state.copyWith(selectedTone: tone, clearOverride: true);
  }

  void toggleRoastMode(bool enableRoast) {
    if (enableRoast) {
      setTone(AiCoachTone.roast);
    } else {
      setTone(AiCoachTone.motivational);
    }
  }

  /// Scans user input for distress/crisis signals and forces `gentle` override if detected (§P12-D safety guardrail).
  bool evaluateMessageSafety(String userMessage) {
    final lower = userMessage.toLowerCase();
    for (final kw in distressKeywords) {
      if (lower.contains(kw)) {
        state = state.copyWith(
          isCrisisOverrideActive: true,
          lastDistressKeyword: kw,
        );
        return true; // Distress signal detected
      }
    }
    return false;
  }

  void clearCrisisOverride() {
    state = state.copyWith(clearOverride: true);
  }
}

final aiCoachToneProvider =
    NotifierProvider<AiCoachToneNotifier, AiCoachToneState>(
  AiCoachToneNotifier.new,
);
