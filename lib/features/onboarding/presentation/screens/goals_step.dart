import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../metabolism/services/metabolism_engine.dart';

class GoalsStep extends StatelessWidget {
  final Goal selectedGoal;
  final ValueChanged<Goal> onGoalSelected;
  final VoidCallback onNext;

  const GoalsStep({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: 'What is your primary health goal?',
            hindi: 'आपका मुख्य फिटनेस लक्ष्य क्या है?',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Your metabolic budget and daily mission will adapt to this goal.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildGoalCard(
                  goal: Goal.fatLoss,
                  title: 'Fat Loss & Visceral Reduction',
                  hindi: 'चर्बी कम करना और पेट की चर्बी घटाना',
                  desc: 'Caloric deficit (-450 kcal), high protein, and metabolic conditioning.',
                  icon: Icons.local_fire_department_rounded,
                  accent: AppColors.accentCoral,
                ),
                const SizedBox(height: 12),
                _buildGoalCard(
                  goal: Goal.muscleGain,
                  title: 'Lean Muscle Hypertrophy',
                  hindi: 'मांसपेशियां बढ़ाना और स्ट्रेंथ',
                  desc: 'Caloric surplus (+300 kcal), progressive resistance training, and high protein.',
                  icon: Icons.fitness_center_rounded,
                  accent: AppColors.primaryCyan,
                ),
                const SizedBox(height: 12),
                _buildGoalCard(
                  goal: Goal.maintenance,
                  title: 'Metabolic Balance & Healthspan',
                  hindi: 'संतुलित वज़न और दीर्घायु स्वास्थ्य',
                  desc: 'Isocaloric nutrition, circadian rhythm optimization, and recovery.',
                  icon: Icons.favorite_rounded,
                  accent: AppColors.primaryEmerald,
                ),
                const SizedBox(height: 12),
                _buildGoalCard(
                  goal: Goal.athleticPerformance,
                  title: 'Athletic Conditioning & Endurance',
                  hindi: 'सहनशक्ति और एथलेटिक प्रदर्शन',
                  desc: 'Targeted carb periodization, VO2 max progression, and agility.',
                  icon: Icons.directions_run_rounded,
                  accent: AppColors.accentAmber,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Continue  •  आगे बढ़ें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required Goal goal,
    required String title,
    required String hindi,
    required String desc,
    required IconData icon,
    required Color accent,
  }) {
    final isSelected = selectedGoal == goal;

    return BentoCard(
      onTap: () => onGoalSelected(goal),
      isGlowing: isSelected,
      glowColor: accent,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? accent.withAlpha(50) : AppColors.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? accent : AppColors.textSecondary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BilingualLabel(
                  english: title,
                  hindi: hindi,
                  primaryStyle: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, style: AppTypography.bodySmall),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: accent, size: 24),
        ],
      ),
    );
  }
}
