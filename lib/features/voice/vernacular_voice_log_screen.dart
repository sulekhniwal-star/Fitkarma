/// §P16-B Vernacular Voice Logging UI Screen
///
/// Route: `/voice-log`
/// Features multi-language selector (Hindi, Tamil, Telugu, Marathi, Bengali, Kannada, English-India),
/// mic input button, live transcript view, code-mixed phrase chips, and macro/exercise result card matching §P16-B spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'voice_controller.dart';
import 'voice_models.dart';

class VernacularVoiceLogScreen extends ConsumerStatefulWidget {
  const VernacularVoiceLogScreen({super.key});

  static const routeName = '/voice-log';

  @override
  ConsumerState<VernacularVoiceLogScreen> createState() => _VernacularVoiceLogScreenState();
}

class _VernacularVoiceLogScreenState extends ConsumerState<VernacularVoiceLogScreen> {
  final _manualInputCtrl = TextEditingController(text: '2 roti aur 1 katori dal khaya');

  @override
  void dispose() {
    _manualInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceLogProvider);
    final notifier = ref.read(voiceLogProvider.notifier);

    ref.listen<VoiceLogState>(voiceLogProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF0EA5E9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '🎙️ Vernacular Voice Logging',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Language Picker Selector Row
            const Text(
              '🌐 Select Speech Language (ASR Locale)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildLanguagePicker(state, notifier),
            const SizedBox(height: 24),

            // 2. Animated Mic Input Button
            _buildMicButton(state, notifier),
            const SizedBox(height: 24),

            // 3. Live Transcript Output Card
            _buildTranscriptCard(state),
            const SizedBox(height: 20),

            // 4. Code-Mixed Speech Example Chips
            const Text(
              '🗣️ Sample Code-Mixed Inputs',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildSampleChips(notifier),
            const SizedBox(height: 20),

            // 5. Parsed Result Output Card
            if (state.lastResult != null) ...[
              const Text(
                '📊 Parsed Macro & Exercise Log',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildResultCard(state.lastResult!),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagePicker(VoiceLogState state, VoiceLogNotifier notifier) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: VernacularLanguage.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final lang = VernacularLanguage.values[idx];
          final isSelected = state.selectedLanguage == lang;

          return ChoiceChip(
            label: Text(lang.displayName),
            selected: isSelected,
            selectedColor: const Color(0xFF0EA5E9),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            onSelected: (_) => notifier.setLanguage(lang),
          );
        },
      ),
    );
  }

  Widget _buildMicButton(VoiceLogState state, VoiceLogNotifier notifier) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (state.isRecording) {
                notifier.stopRecording();
              } else {
                notifier.processVoiceLog(simulatedAudioText: _manualInputCtrl.text.trim());
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: state.isRecording
                      ? [Colors.redAccent, Colors.pinkAccent]
                      : [const Color(0xFF0EA5E9), const Color(0xFF6366F1)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (state.isRecording ? Colors.redAccent : const Color(0xFF0EA5E9)).withValues(alpha: 0.5),
                    blurRadius: state.isRecording ? 30 : 15,
                    spreadRadius: state.isRecording ? 10 : 2,
                  ),
                ],
              ),
              child: Icon(
                state.isRecording ? Icons.mic : Icons.mic_none_rounded,
                color: Colors.white,
                size: 46,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.isRecording ? 'Listening in ${state.selectedLanguage.displayName}...' : 'Tap Mic to Speak in ${state.selectedLanguage.displayName}',
            style: TextStyle(
              color: state.isRecording ? Colors.redAccent : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(VoiceLogState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transcript (Azure Speech ASR)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(state.selectedLanguage.azureLocale, style: const TextStyle(color: Color(0xFF0EA5E9), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            state.activeTranscript ?? 'Press mic or select a sample phrase below to begin speech transcription.',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleChips(VoiceLogNotifier notifier) {
    final samples = [
      '2 roti aur 1 katori dal khaya',
      'Rendhu dosa matrum sambar saapitten',
      'Rendu idli mariyu sambar thinnanu',
      '30 mins gym workout kiya',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: samples.map((s) {
        return ActionChip(
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 12)),
          onPressed: () {
            _manualInputCtrl.text = s;
            notifier.processVoiceLog(simulatedAudioText: s);
          },
        );
      }).toList(),
    );
  }

  Widget _buildResultCard(VoiceLogResult res) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                res.summary,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ ${(res.confidenceScore * 100).toInt()}% Confidence',
                  style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroStat('Calories', '${res.calories} kcal', Colors.orangeAccent),
              _buildMacroStat('Protein', '${res.proteinG}g', Colors.lightBlueAccent),
              _buildMacroStat('Carbs', '${res.carbsG}g', Colors.amberAccent),
              _buildMacroStat('Fat', '${res.fatG}g', Colors.pinkAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
