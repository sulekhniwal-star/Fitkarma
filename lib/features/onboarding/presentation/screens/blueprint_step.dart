import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/onboarding_state.dart';

class BlueprintStep extends StatelessWidget {
  final ProgramBlueprint selectedBlueprint;
  final ValueChanged<ProgramBlueprint> onBlueprintSelected;
  final VoidCallback onNext;

  const BlueprintStep({
    super.key,
    required this.selectedBlueprint,
    required this.onBlueprintSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: 'Select Program Blueprint',
            hindi: 'वर्कआउट प्रोग्राम का चयन करें',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Dynamic workout structure calibrated to your Ayurvedic constitution and equipment.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildBlueprintTile(
                  blueprint: ProgramBlueprint.hypertrophyAesthetics,
                  title: 'Hypertrophy & Physique Aesthetics',
                  hindi: 'मसल हाइपरट्रॉफी एवं बॉडी रीकंपोजीशन',
                  desc: '4-day upper/lower split, RPE-based overload, high volume focus.',
                  icon: Icons.fitness_center_rounded,
                  accent: AppColors.primaryCyan,
                ),
                const SizedBox(height: 12),
                _buildBlueprintTile(
                  blueprint: ProgramBlueprint.strengthPower,
                  title: 'Pure Strength & Heavy Compound',
                  hindi: 'स्ट्रेंथ एवं भारी कंपाउंड लिफ्ट्स',
                  desc: '3-day powerlifting foundation (Squat/Bench/Deadlift/OHP) with deload protocols.',
                  icon: Icons.hardware_rounded,
                  accent: AppColors.accentCoral,
                ),
                const SizedBox(height: 12),
                _buildBlueprintTile(
                  blueprint: ProgramBlueprint.metabolicConditioning,
                  title: 'Metabolic Conditioning & HIIT',
                  hindi: 'मेटाबॉलिक कंडीशनिंग एवं फैट बर्न',
                  desc: 'High-density circuits, kettlebell complexes, and Zone 2 cardio.',
                  icon: Icons.speed_rounded,
                  accent: AppColors.accentAmber,
                ),
                const SizedBox(height: 12),
                _buildBlueprintTile(
                  blueprint: ProgramBlueprint.mobilityLongevity,
                  title: 'Mobility, Yoga & Longevity',
                  hindi: 'योग, मोबिलिटी एवं दीर्घायु स्वास्थ्य',
                  desc: 'Ayurvedic movement flows, joint longevity, core stabilization, and breathwork.',
                  icon: Icons.self_improvement_rounded,
                  accent: AppColors.primaryEmerald,
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
              'Generate Diet Plan  •  आगे बढ़ें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueprintTile({
    required ProgramBlueprint blueprint,
    required String title,
    required String hindi,
    required String desc,
    required IconData icon,
    required Color accent,
  }) {
    final isSelected = selectedBlueprint == blueprint;

    return BentoCard(
      onTap: () => onBlueprintSelected(blueprint),
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
            child: Icon(icon, color: isSelected ? accent : AppColors.textSecondary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BilingualLabel(
                  english: title,
                  hindi: hindi,
                  primaryStyle: AppTypography.bodyMedium.copyWith(
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
            Icon(Icons.check_circle_rounded, color: accent, size: 22),
        ],
      ),
    );
  }
}
