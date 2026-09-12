import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/services/dosha_scoring_engine.dart';

class DoshaQuizStep extends StatefulWidget {
  final ValueChanged<DoshaProfile> onDoshaCalculated;
  final VoidCallback onNext;

  const DoshaQuizStep({
    super.key,
    required this.onDoshaCalculated,
    required this.onNext,
  });

  @override
  State<DoshaQuizStep> createState() => _DoshaQuizStepState();
}

class _DoshaQuizStepState extends State<DoshaQuizStep> {
  final Map<String, String> _answers = {}; // questionId -> 'vata' | 'pitta' | 'kapha'
  final _engine = const DoshaScoringEngine();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: 'Ayurvedic Dosha Assessment',
            hindi: 'आयुर्वेदिक प्रकृति एवं त्रिदोष परीक्षण',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Understand your body constitution (Prakriti) for tailored nutrition and recovery.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: DoshaScoringEngine.questions.length,
              itemBuilder: (context, index) {
                final q = DoshaScoringEngine.questions[index];
                final selectedOption = _answers[q.id];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BilingualLabel(
                          english: '${index + 1}. ${q.question}',
                          hindi: q.questionHindi,
                          primaryStyle: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildOptionTile(
                          questionId: q.id,
                          type: 'vata',
                          label: q.vataOption,
                          labelHindi: q.vataOptionHindi,
                          isSelected: selectedOption == 'vata',
                          accent: AppColors.primaryCyan,
                        ),
                        const SizedBox(height: 8),
                        _buildOptionTile(
                          questionId: q.id,
                          type: 'pitta',
                          label: q.pittaOption,
                          labelHindi: q.pittaOptionHindi,
                          isSelected: selectedOption == 'pitta',
                          accent: AppColors.accentCoral,
                        ),
                        const SizedBox(height: 8),
                        _buildOptionTile(
                          questionId: q.id,
                          type: 'kapha',
                          label: q.kaphaOption,
                          labelHindi: q.kaphaOptionHindi,
                          isSelected: selectedOption == 'kapha',
                          accent: AppColors.accentAmber,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              int vata = 0, pitta = 0, kapha = 0;
              for (final val in _answers.values) {
                if (val == 'vata') vata += 10;
                if (val == 'pitta') pitta += 10;
                if (val == 'kapha') kapha += 10;
              }
              // Default fallback if some questions skipped
              if (vata == 0 && pitta == 0 && kapha == 0) {
                vata = 10;
                pitta = 10;
                kapha = 10;
              }

              final profile = _engine.calculateDosha(
                vataPoints: vata,
                pittaPoints: pitta,
                kaphaPoints: kapha,
              );

              widget.onDoshaCalculated(profile);
              widget.onNext();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Calculate Prakriti  •  आगे बढ़ें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String questionId,
    required String type,
    required String label,
    required String labelHindi,
    required bool isSelected,
    required Color accent,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _answers[questionId] = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? accent.withAlpha(35) : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : AppColors.borderGlass,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? accent : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BilingualLabel(
                english: label,
                hindi: labelHindi,
                primaryStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                secondaryStyle: AppTypography.bilingualSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
