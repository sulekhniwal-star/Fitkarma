import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bilingual_label.dart';

class MuscleGroupInfo {
  final String key;
  final String name;
  final String hindi;
  final IconData icon;

  const MuscleGroupInfo({
    required this.key,
    required this.name,
    required this.hindi,
    required this.icon,
  });
}

class BodySorenessMap extends StatelessWidget {
  final Map<String, int> sorenessMap; // muscleKey -> severity (1 to 5)
  final void Function(String key, int severity) onSorenessToggled;

  static const List<MuscleGroupInfo> muscleGroups = [
    MuscleGroupInfo(key: 'traps_neck', name: 'Neck & Traps', hindi: 'गर्दन और ट्रैप्स', icon: Icons.accessibility_new_rounded),
    MuscleGroupInfo(key: 'shoulders', name: 'Shoulders (Delts)', hindi: 'कंधे (डेल्ट्स)', icon: Icons.fitness_center_rounded),
    MuscleGroupInfo(key: 'chest', name: 'Chest (Pectorals)', hindi: 'छाती (पेक्स)', icon: Icons.shield_rounded),
    MuscleGroupInfo(key: 'back', name: 'Upper & Lower Back', hindi: 'पीठ (लैट्स और स्पाइन)', icon: Icons.airline_seat_recline_extra_rounded),
    MuscleGroupInfo(key: 'arms', name: 'Arms (Biceps & Triceps)', hindi: 'हाथ (बाइसेप्स/ट्राइसेप्स)', icon: Icons.sports_gymnastics_rounded),
    MuscleGroupInfo(key: 'core', name: 'Core & Abs', hindi: 'पेट एवं कोर', icon: Icons.circle_outlined),
    MuscleGroupInfo(key: 'quads', name: 'Quads & Hip Flexors', hindi: 'जांघें (क्वाड्स)', icon: Icons.directions_walk_rounded),
    MuscleGroupInfo(key: 'hamstrings', name: 'Hamstrings & Glutes', hindi: 'हैमस्ट्रिंग्स और ग्लूट्स', icon: Icons.directions_run_rounded),
    MuscleGroupInfo(key: 'calves', name: 'Calves & Ankles', hindi: 'पिंडलियां (काव्स)', icon: Icons.do_not_step_rounded),
  ];

  const BodySorenessMap({
    super.key,
    required this.sorenessMap,
    required this.onSorenessToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BilingualLabel(
              english: 'Muscle Soreness Heatmap',
              hindi: 'मांसपेशियों में दर्द / थकान का स्तर',
            ),
            Text(
              '${sorenessMap.length} Areas Logged',
              style: AppTypography.label.copyWith(color: AppColors.accentAmber),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: muscleGroups.map((muscle) {
            final severity = sorenessMap[muscle.key] ?? 0;
            final isSore = severity > 0;

            Color accentColor = AppColors.surfaceGlass;
            if (severity == 1 || severity == 2) accentColor = AppColors.primaryCyan;
            if (severity == 3 || severity == 4) accentColor = AppColors.accentAmber;
            if (severity >= 5) accentColor = AppColors.accentCoral;

            return InkWell(
              onTap: () {
                // Cycle: 0 -> 2 (mild) -> 4 (moderate) -> 5 (extreme) -> 0
                int nextSeverity = 0;
                if (severity == 0) nextSeverity = 2;
                else if (severity == 2) nextSeverity = 4;
                else if (severity == 4) nextSeverity = 5;
                else nextSeverity = 0;

                onSorenessToggled(muscle.key, nextSeverity);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSore ? accentColor.withAlpha(35) : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSore ? accentColor : AppColors.borderGlass,
                    width: isSore ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      muscle.icon,
                      size: 16,
                      color: isSore ? accentColor : AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      muscle.name,
                      style: AppTypography.bodySmall.copyWith(
                        color: isSore ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: isSore ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (isSore) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$severity/5',
                          style: AppTypography.label.copyWith(
                            color: AppColors.background,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
