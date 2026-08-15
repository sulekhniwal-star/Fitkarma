import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/family_health_hub_engine.dart';

final familyHubStateProvider = StateProvider<FamilyHubEvaluation>((ref) {
  const engine = FamilyHealthHubEngine();
  final sampleMembers = [
    const FamilyMemberProfile(
      id: 'm1',
      firstName: 'Ramesh',
      relationship: 'Dad',
      age: 54,
      role: FamilyRole.parent,
      healthScore: 71,
      bpStatus: '⚠️ Moderate',
      stepsToday: 4200,
      sleepHours: 6.1,
      activeProgramOrRisk: 'Hypertension watch',
      activeRisks: [HealthRiskType.hypertension],
      bpCheckDaysAgo: 3,
      lowProteinDays: 0,
    ),
    const FamilyMemberProfile(
      id: 'm2',
      firstName: 'Sunita',
      relationship: 'Mom',
      age: 51,
      role: FamilyRole.parent,
      healthScore: 78,
      bpStatus: 'Normal',
      stepsToday: 6100,
      sleepHours: 7.4,
      activeProgramOrRisk: 'Menopause Wellness',
      activeRisks: [],
      bpCheckDaysAgo: 1,
      lowProteinDays: 0,
    ),
    const FamilyMemberProfile(
      id: 'm3',
      firstName: 'Arjun',
      relationship: 'Son (You)',
      age: 28,
      role: FamilyRole.self,
      healthScore: 84,
      bpStatus: 'Normal',
      stepsToday: 9400,
      sleepHours: 7.8,
      activeProgramOrRisk: 'Readiness: High',
      activeRisks: [],
      bpCheckDaysAgo: 0,
      lowProteinDays: 0,
    ),
    const FamilyMemberProfile(
      id: 'm4',
      firstName: 'Priya',
      relationship: 'Daughter',
      age: 24,
      role: FamilyRole.child,
      healthScore: 79,
      bpStatus: 'Normal',
      stepsToday: 7800,
      sleepHours: 8.1,
      activeProgramOrRisk: 'Protein: ⚠️ Low',
      activeRisks: [HealthRiskType.lowProtein],
      bpCheckDaysAgo: 0,
      lowProteinDays: 4,
    ),
  ];

  return engine.evaluateFamilyHub(
    familyId: 'fam_sharma',
    familyName: 'The Sharma Family',
    rawMembers: sampleMembers,
  );
});

final familyNudgeStatusProvider = StateProvider<String>((ref) => '');

/// §P9-D Family Health Hub Screen
/// Route: /family
class FamilyHubScreen extends ConsumerWidget {
  const FamilyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eval = ref.watch(familyHubStateProvider);
    final nudgeStatus = ref.watch(familyNudgeStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Family Health Hub', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nudge Action Banner
              if (nudgeStatus.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    nudgeStatus,
                    style: AppTypography.bodySm.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Family Hub Header BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(eval.familyName, style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '👨‍👩‍👧‍👦 ${eval.members.length} Household Members',
                            style: AppTypography.labelSmall.copyWith(
                                color: AppColors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'One household subscription • Consented privacy sharing',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Family Members Cards List
              Text('Household Members', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Column(
                children: [
                  for (final m in eval.members)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      m.relationship == 'Dad'
                                          ? '👨'
                                          : m.relationship == 'Mom'
                                              ? '👩'
                                              : m.relationship.contains('Son')
                                                  ? '🧑'
                                                  : '👧',
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${m.relationship} (${m.firstName}, ${m.age})',
                                        style: AppTypography.labelLg),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('Health Score: ${m.healthScore}',
                                      style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                    'Steps: ${m.stepsToday.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('Sleep: ${m.sleepHours}h',
                                    style: AppTypography.bodySm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('BP: ${m.bpStatus}',
                                    style: AppTypography.bodySm.copyWith(
                                        color: m.bpStatus.contains('⚠️')
                                            ? AppColors.warning
                                            : AppColors.success,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Active Family Alerts & Nudges Section
              if (eval.activeAlerts.isNotEmpty) ...[
                Text('Family Alerts & Nudges', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                Column(
                  children: [
                    for (final alert in eval.activeAlerts)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: alert.severity == FamilyNudgeSeverity.high
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: alert.severity == FamilyNudgeSeverity.high
                                  ? AppColors.error.withValues(alpha: 0.3)
                                  : AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  alert.message,
                                  style: AppTypography.bodySm
                                      .copyWith(color: AppColors.textPrimary),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      alert.severity == FamilyNudgeSeverity.high
                                          ? AppColors.error
                                          : AppColors.warning,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  ref
                                          .read(familyNudgeStatusProvider.notifier)
                                          .state =
                                      'Sent "${alert.actionText}" to ${alert.targetMemberName} 💪';
                                },
                                child: Text(alert.actionText,
                                    style: AppTypography.labelSmall.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
