// §P16-B Vernacular Voice Logging Bottom Sheet UI
// Cross-reference: §P16-B in Fitkarma_documentation.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/voice_log_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../providers/voice_log_provider.dart';

class VoiceLogBottomSheet extends ConsumerWidget {
  const VoiceLogBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceLogProvider);
    final notifier = ref.read(voiceLogProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header & Language Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.mic, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Voice Logging', style: AppTypography.h2),
                ],
              ),
              DropdownButton<VernacularLanguage>(
                value: state.selectedLanguage,
                dropdownColor: AppColors.surface1,
                underline: const SizedBox(),
                items: VernacularLanguage.values.map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang.displayName, style: AppTypography.labelMd),
                  );
                }).toList(),
                onChanged: (lang) {
                  if (lang != null) {
                    notifier.setLanguage(lang);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Speak naturally in your preferred language or Hinglish',
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Central Microphone Interaction
          Center(
            child: GestureDetector(
              key: const Key('mic_button'),
              onTap: () {
                if (state.isRecording) {
                  notifier.stopRecordingAndProcess();
                } else if (!state.isProcessing) {
                  notifier.startRecording();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.isRecording
                      ? AppColors.error
                      : (state.isProcessing ? AppColors.accent : AppColors.primary),
                  boxShadow: [
                    BoxShadow(
                      color: (state.isRecording ? AppColors.error : AppColors.primary)
                          .withAlpha(80),
                      blurRadius: state.isRecording ? 24 : 12,
                      spreadRadius: state.isRecording ? 8 : 2,
                    ),
                  ],
                ),
                child: Icon(
                  state.isRecording
                      ? Icons.stop
                      : (state.isProcessing ? Icons.hourglass_top : Icons.mic),
                  size: 42.0,
                  color: AppColors.bg0,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              state.isRecording
                  ? 'Listening... Tap to stop'
                  : (state.isProcessing ? 'Transcribing & Parsing...' : 'Tap mic to speak'),
              style: AppTypography.labelLg.copyWith(
                color: state.isRecording ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Result Card if Transcribed
          if (state.result != null) ...[
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transcribed:', style: AppTypography.labelSmall),
                      Text(state.result!.detectedLanguageLocale,
                          style: AppTypography.labelSmall.copyWith(color: AppColors.teal)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('"${state.result!.rawTranscript}"', style: AppTypography.bodyMd),
                  const Divider(color: AppColors.glassBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Parsed:', style: AppTypography.labelSmall),
                      Text(
                        '${state.result!.totalCalories} kcal · ${state.result!.totalProteinGrams.round()}g P',
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  Text(state.result!.parsedSummary, style: AppTypography.h2),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.bg0,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              onPressed: () {
                Navigator.of(context).pop(state.result);
              },
              child: Text('Confirm & Log Meal', style: AppTypography.h3),
            ),
          ],
        ],
      ),
    );
  }
}
