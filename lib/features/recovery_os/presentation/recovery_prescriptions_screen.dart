import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/recovery_behavior_engine.dart';

class RecoveryPrescriptionsScreen extends StatefulWidget {
  final double currentStrain;
  final int sorenessScore;
  final double sleepDebtHours;

  const RecoveryPrescriptionsScreen({
    super.key,
    this.currentStrain = 13.5,
    this.sorenessScore = 35,
    this.sleepDebtHours = 1.8,
  });

  @override
  State<RecoveryPrescriptionsScreen> createState() => _RecoveryPrescriptionsScreenState();
}

class _RecoveryPrescriptionsScreenState extends State<RecoveryPrescriptionsScreen> {
  final Set<String> _completedIds = {};

  void _toggleBehavior(String id) {
    setState(() {
      if (_completedIds.contains(id)) {
        _completedIds.remove(id);
      } else {
        _completedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prescriptions = RecoveryBehaviorEngine.generateDailyPrescriptions(
      currentStrain: widget.currentStrain,
      sorenessScore: widget.sorenessScore,
      sleepDebtHours: widget.sleepDebtHours,
      completedBehaviorIds: _completedIds,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Recovery Prescriptions',
          regionalText: 'दैनिक रिकवरी आदतें',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Personalized Daily Prescriptions Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.aiPurple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: AppColors.aiPurple, size: 20),
                        SizedBox(width: 8),
                        BilingualLabel(
                          primaryText: "Today's Recovery Prescriptions",
                          regionalText: 'आज के लिए सुझाई गई रिकवरी आदतें',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...prescriptions.map((item) {
                      final isDone = _completedIds.contains(item.behavior.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BentoCard(
                          backgroundColor: AppColors.surfaceElevated,
                          border: Border.all(
                            color: isDone ? AppColors.karmaGreen : AppColors.glassBorder,
                          ),
                          onTap: () => _toggleBehavior(item.behavior.id),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                item.behavior.icon,
                                color: isDone ? AppColors.karmaGreen : AppColors.focusBlue,
                                size: 22,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.behavior.name,
                                          style: AppTypography.titleSmall.copyWith(
                                            color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '+${item.behavior.estimatedHrvImpactMs.toStringAsFixed(1)}ms HRV',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.karmaGreen,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.instruction,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Why: ${item.priorityReason}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.aiPurple,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDone ? AppColors.karmaGreen : Colors.transparent,
                                  border: Border.all(
                                    color: isDone ? AppColors.karmaGreen : AppColors.glassBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: isDone
                                    ? const Icon(Icons.check_rounded, size: 14, color: AppColors.textInverse)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. All Trackable Recovery Behaviors Catalog
              const Text(
                'ALL RECOVERY HABITS (सभी आदतें)',
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
                itemCount: RecoveryBehaviorType.values.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final behavior = RecoveryBehaviorType.values[index];
                  final isLogged = _completedIds.contains(behavior.id);

                  return BentoCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    onTap: () => _toggleBehavior(behavior.id),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              behavior.icon,
                              color: isLogged ? AppColors.karmaGreen : AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  behavior.name,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${behavior.regionalName} • ${behavior.category}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: isLogged,
                          activeThumbColor: AppColors.karmaGreen,
                          onChanged: (_) => _toggleBehavior(behavior.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
