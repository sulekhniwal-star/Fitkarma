import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/body_soreness_map.dart';
import '../providers/recovery_provider.dart';

class RecoveryLogScreen extends ConsumerWidget {
  const RecoveryLogScreen({super.key});

  Color _getScoreColor(int score) {
    if (score < 30) return AppColors.karmaGreen;
    if (score < 60) return AppColors.energyOrange;
    return AppColors.alertRed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorenessAsync = ref.watch(bodySorenessProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Recovery & Soreness Log',
          regionalText: 'मांसपेशी दर्द एवं पुनर्प्राप्ति',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: sorenessAsync.when(
          data: (sorenessMap) {
            final score = sorenessMap.cumulativeScore;
            final scoreColor = _getScoreColor(score);
            final protocols = sorenessMap.reliefProtocols;

            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Cumulative Soreness Score Bento Card
                  BentoCard(
                    hasGlow: score > 50,
                    glowColor: scoreColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              primaryText: 'Body Soreness Index',
                              regionalText: 'कुल शारीरिक थकान',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              score > 60
                                  ? 'High Strain: Focus on rest & mobility'
                                  : score > 30
                                      ? 'Moderate DOMS: Active recovery recommended'
                                      : 'Optimal: Fresh & ready to train',
                              style: AppTypography.bodySmall.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ActivityRings(
                          size: 90,
                          rings: [
                            RingData(
                              progress: (score / 100).clamp(0.0, 1.0),
                              color: scoreColor,
                              strokeWidth: 8,
                            ),
                          ],
                          centerWidget: Text(
                            '$score%',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Muscle Group Soreness Grid
                  const Text(
                    'TAP TO LOG SORENESS (मांसपेशियों का चयन करें)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: MuscleGroup.values.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final muscle = MuscleGroup.values[index];
                      final currentLevel = sorenessMap.muscleStates[muscle] ?? SorenessLevel.none;

                      return _buildMuscleRow(
                        context: context,
                        ref: ref,
                        muscle: muscle,
                        currentLevel: currentLevel,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Targeted Relief Protocols
                  BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.healing_rounded, color: AppColors.focusBlue, size: 20),
                            SizedBox(width: 8),
                            BilingualLabel(
                              primaryText: 'Targeted Relief Protocols',
                              regionalText: 'सुझाई गई पुनर्प्राप्ति तकनीकें',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...protocols.map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildMuscleRow({
    required BuildContext context,
    required WidgetRef ref,
    required MuscleGroup muscle,
    required SorenessLevel currentLevel,
  }) {
    return BentoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  muscle.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  muscle.regionalName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: SorenessLevel.values.map((level) {
              final isSelected = currentLevel == level;
              final levelColor = Color(level.colorHex);

              return GestureDetector(
                onTap: () {
                  ref.read(bodySorenessProvider.notifier).updateMuscleSoreness(muscle, level);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? levelColor : AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: isSelected ? levelColor : AppColors.glassBorder,
                    ),
                  ),
                  child: Text(
                    '${level.value}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
