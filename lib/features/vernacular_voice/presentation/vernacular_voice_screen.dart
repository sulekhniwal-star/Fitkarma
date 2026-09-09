import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/voice_models.dart';
import '../providers/voice_provider.dart';

/// Screen enabling natural vernacular speech-to-intent health logging
/// supporting 10 Indian languages/dialects with real-time food NLP.
class VernacularVoiceScreen extends ConsumerStatefulWidget {
  const VernacularVoiceScreen({super.key});

  @override
  ConsumerState<VernacularVoiceScreen> createState() => _VernacularVoiceScreenState();
}

class _VernacularVoiceScreenState extends ConsumerState<VernacularVoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _micPulseController;
  final TextEditingController _customSpeechController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _micPulseController.dispose();
    _customSpeechController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vernacularVoiceProvider);
    final notifier = ref.read(vernacularVoiceProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Vernacular Voice OS',
          regionalText: 'मातृभाषा आवाज़ से स्वास्थ्य लॉगिंग',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Language Selector Pills
            _buildLanguageSelector(state.selectedLanguage, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Microphone & Audio Visualizer Card
            _buildHeroMicrophoneCard(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Current Parsed Result & Macro Decomposition Card
            if (state.currentTranscript != null)
              _buildTranscriptResultCard(state.currentTranscript!),
            if (state.currentTranscript != null)
              const SizedBox(height: AppSpacing.md),

            // 4. Voice Logging History Stream
            _buildVoiceHistoryCard(state.voiceHistory),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(VernacularLanguage current, VernacularVoiceNotifier notifier) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: VernacularLanguage.values.map((lang) {
          final isSelected = lang == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Text(lang.flagEmoji, style: const TextStyle(fontSize: 13)),
              label: Text('${lang.name} (${lang.nativeName})'),
              selected: isSelected,
              selectedColor: AppColors.karmaGreen.withValues(alpha: 0.2),
              backgroundColor: AppColors.surfaceElevated,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.karmaGreen : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.karmaGreen : AppColors.glassBorder,
              ),
              onSelected: (_) => notifier.selectLanguage(lang),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeroMicrophoneCard(VoiceState state, VernacularVoiceNotifier notifier) {
    final isListening = state.recordingState == VoiceRecordingState.listening;
    final isProcessing = state.recordingState == VoiceRecordingState.processing;

    final promptExamples = [
      '2 roti, 1 bowl dal tadka aur cucumber salad',
      '२ ज्वारीची भाकरी आणि पिठलं',
      'இரண்டு இட்லி சாம்பார் மற்றும் ஒரு கப் காபி',
      'రెండు దోశలు మరియు పప్పు',
      'Subah 45 minute walk kiya aur 5000 steps hue',
      '1 glass coconut water with lemon',
    ];

    return BentoCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Voice Assistant: ${state.selectedLanguage.name}',
                regionalText: state.selectedLanguage.nativeName,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isListening
                      ? AppColors.alertRed.withValues(alpha: 0.15)
                      : AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(
                    color: isListening ? AppColors.alertRed : AppColors.karmaGreen,
                  ),
                ),
                child: Text(
                  isListening ? 'Listening...' : (isProcessing ? 'Transcribing...' : 'Ready'),
                  style: TextStyle(
                    color: isListening ? AppColors.alertRed : AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Glowing Mic Button
          GestureDetector(
            onTap: () {
              if (isListening) {
                notifier.processVoiceInput(
                  _customSpeechController.text.isNotEmpty
                      ? _customSpeechController.text
                      : '2 roti, 1 bowl dal tadka aur salad',
                );
              } else {
                notifier.startListening();
              }
            },
            child: AnimatedBuilder(
              animation: _micPulseController,
              builder: (context, child) {
                return Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isListening
                        ? AppColors.alertRed.withValues(alpha: 0.2 + (_micPulseController.value * 0.2))
                        : AppColors.karmaGreen.withValues(alpha: 0.15),
                    border: Border.all(
                      color: isListening ? AppColors.alertRed : AppColors.karmaGreen,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isListening
                            ? AppColors.alertRed.withValues(alpha: 0.4)
                            : AppColors.karmaGreen.withValues(alpha: 0.3),
                        blurRadius: isListening ? (16 + (_micPulseController.value * 12)) : 16,
                        spreadRadius: isListening ? 4 : 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? AppColors.alertRed : AppColors.karmaGreen,
                      size: 38,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isListening ? 'Tap mic to stop and process speech' : 'Tap microphone and speak in your mother tongue',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Speech simulator input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customSpeechController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Or type speech phrase to simulate voice...',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      notifier.processVoiceInput(val);
                      _customSpeechController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.karmaGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
                ),
                onPressed: () {
                  if (_customSpeechController.text.trim().isNotEmpty) {
                    notifier.processVoiceInput(_customSpeechController.text);
                    _customSpeechController.clear();
                  }
                },
                child: const Icon(Icons.arrow_forward, color: AppColors.background, size: 18),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Quick prompt chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: promptExamples.map((prompt) {
              return ActionChip(
                backgroundColor: AppColors.surfaceElevated,
                label: Text(prompt, style: const TextStyle(color: AppColors.focusBlue, fontSize: 11)),
                onPressed: () {
                  _customSpeechController.text = prompt;
                  notifier.processVoiceInput(prompt);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptResultCard(VoiceTranscriptResult result) {
    final entity = result.parsedEntity;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(result.detectedLanguage.flagEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    '${result.detectedLanguage.name} • ${(result.confidenceScore * 100).toInt()}% Confidence',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entity.intentType.label,
                  style: const TextStyle(color: AppColors.focusBlue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
              border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.record_voice_over, color: AppColors.karmaGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${result.rawTranscript}"',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Extracted entities
          if (entity.intentType == VoiceIntentType.mealNutrition) ...[
            Row(
              children: [
                Expanded(
                  child: GlowingMetric(
                    value: entity.calories.toInt().toString(),
                    unit: 'kcal',
                    label: 'Calories',
                    accentColor: AppColors.karmaGreen,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.surfaceElevated),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMacroPill('Protein', '${entity.proteinGrams.toStringAsFixed(1)}g', AppColors.focusBlue),
                          _buildMacroPill('Carbs', '${entity.carbsGrams.toStringAsFixed(1)}g', AppColors.energyOrange),
                          _buildMacroPill('Fat', '${entity.fatGrams.toStringAsFixed(1)}g', AppColors.alertRed),
                          _buildMacroPill('Fiber', '${entity.fiberGrams.toStringAsFixed(1)}g', AppColors.karmaGreen),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.karmaGreen.withValues(alpha: 0.08),
                borderRadius: AppRadii.radiusSm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_walk, color: AppColors.karmaGreen, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entity.regionalPostMealGuidance,
                      style: const TextStyle(color: AppColors.karmaGreen, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (entity.intentType == VoiceIntentType.waterHydration) ...[
            GlowingMetric(
              value: '${entity.waterMl}',
              unit: 'mL',
              label: 'Water Intake Logged',
              accentColor: AppColors.focusBlue,
            ),
          ] else if (entity.intentType == VoiceIntentType.workoutPhysicalActivity) ...[
            Row(
              children: [
                Expanded(
                  child: GlowingMetric(
                    value: '${entity.workoutDurationMinutes}',
                    unit: 'mins',
                    label: 'Duration',
                    accentColor: AppColors.karmaGreen,
                  ),
                ),
                if (entity.stepsCount > 0)
                  Expanded(
                    child: GlowingMetric(
                      value: '${entity.stepsCount}',
                      unit: 'steps',
                      label: 'Steps',
                      accentColor: AppColors.focusBlue,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceHistoryCard(List<VoiceTranscriptResult> history) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Voice Logging History',
                regionalText: 'ध्वनि लॉगिंग इतिहास',
              ),
              Icon(Icons.history, color: AppColors.textSecondary, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Chronological stream of speech transcripts and parsed physiological events.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          if (history.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('No voice logs yet. Tap the microphone to record.', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...history.map((h) => _buildHistoryItem(h)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(VoiceTranscriptResult item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.3),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.detectedLanguage.flagEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.parsedEntity.primarySummary,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${item.recordedAt.hour.toString().padLeft(2, '0')}:${item.recordedAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '"${item.rawTranscript}"',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              primaryText: 'Vernacular Voice Science',
              regionalText: 'मातृभाषा आवाज़ लॉगिंग दर्शन',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma\'s Vernacular Voice OS overcomes literacy and typing friction across Bharat by processing natural speech transcripts across 10 Indian languages. It pairs on-device phonetic token extraction with an extensive database of Indian regional culinary preparations (Bhakri, Roti, Idli, Dosa, Pesarattu, Dal, Fish curry) to instantly log calories, macros, and hydration with zero keyboard input.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
