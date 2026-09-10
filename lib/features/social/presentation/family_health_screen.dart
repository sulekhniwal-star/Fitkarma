import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/family_models.dart';
import 'providers/family_provider.dart';

/// Screen displaying the Intergenerational Family Health Hub (Parivar Swasthya Kendra)
class FamilyHealthScreen extends ConsumerWidget {
  const FamilyHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyHealthProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Family Health Hub (Parivar)',
          regionalText: 'पारिवारिक स्वास्थ्य केंद्र एवं सेवा',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showFamilyPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Household Wellness Hero Banner
            _buildHouseholdHeroBanner(state),
            const SizedBox(height: AppSpacing.md),

            // 2. Seasonal Ayurvedic Kitchen Medicine Card
            _buildSeasonalAyurvedaCard(state.seasonalTip),
            const SizedBox(height: AppSpacing.md),

            // 3. Family Members Vitals & Activity List
            const BilingualLabel(
              primaryText: 'Intergenerational Health Monitoring',
              regionalText: 'परिवार के सदस्यों का स्वास्थ्य अवलोकन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...state.familyMembers.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildMemberVitalsCard(context, ref, member),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Recent Seva Nudges Stream
            if (state.recentNudges.isNotEmpty) ...[
              const BilingualLabel(
                primaryText: 'Recent Care Reminders (Seva Nudges)',
                regionalText: 'हाल ही में भेजे गए स्वास्थ्य स्मरण',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildRecentNudgesList(state.recentNudges),
              const SizedBox(height: AppSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHouseholdHeroBanner(FamilyHealthHubState state) {
    final score = state.familyHouseholdHealthScore;
    final scoreColor = score >= 85.0
        ? AppColors.karmaGreen
        : score >= 70.0
            ? AppColors.focusBlue
            : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.family_restroom,
                        color: AppColors.focusBlue, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${state.familyMembers.length} Household Members',
                      style: AppTypography.metricLabel.copyWith(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${state.totalFamilyStepsToday} Total Family Steps',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Household Health Index',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${score.toStringAsFixed(1)}%',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aggregated vitals stability, daily movement, and Shatpawali adherence.',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${score.toInt()}%',
                label: 'Parivar Wellness',
                accentColor: scoreColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (score / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalAyurvedaCard(SeasonalFamilyAyurvedaTip tip) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.10),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.spa, color: AppColors.karmaGreen, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ayurvedic Senior Care (Gharelu Nuskha)',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.karmaGreen.withValues(alpha: 0.2),
                        borderRadius: AppRadii.radiusFull,
                      ),
                      child: Text(
                        tip.benefitCategory,
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.karmaGreen,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tip.title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.description,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary, height: 1.3),
                ),
                const SizedBox(height: 4),
                Text(
                  'Key Ingredients: ${tip.keyIngredients}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberVitalsCard(
      BuildContext context, WidgetRef ref, FamilyMemberProfile member) {
    final statusColor = Color(member.status.colorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name, Relation, and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfaceElevated,
                    child: Icon(
                      member.relation == FamilyRelationType.father ||
                              member.relation == FamilyRelationType.mother
                          ? Icons.elderly
                          : member.relation == FamilyRelationType.spouse
                              ? Icons.favorite
                              : Icons.person,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      Text(
                        '${member.relation.regionalLabel} • ${member.age} yrs',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  member.status.title,
                  style: AppTypography.metricLabel.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Vitals Grid (BP, Steps, Shatpawali)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Blood Pressure Pill
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Blood Pressure',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  Text(
                    member.hasBpLogged
                        ? '${member.latestSystolicBp}/${member.latestDiastolicBp} mmHg'
                        : 'Not Logged',
                    style: AppTypography.bodyLarge.copyWith(
                      color: member.hasBpLogged
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Steps & Goal
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Daily Movement',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  Text(
                    '${member.todaySteps} / ${member.dailyStepTarget}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Shatpawali Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Shatpawali',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  Text(
                    member.completedShatpawaliToday ? 'Completed' : 'Pending',
                    style: AppTypography.bodyLarge.copyWith(
                      color: member.completedShatpawaliToday
                          ? AppColors.karmaGreen
                          : AppColors.energyOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Steps Progress bar
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: member.stepProgressFraction,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                member.stepProgressFraction >= 1.0
                    ? AppColors.karmaGreen
                    : AppColors.focusBlue,
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Caregiver Note
          Text(
            member.caregiverNote,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Action Button: One-Tap Seva Nudge
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!member.completedShatpawaliToday)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.energyOrange.withValues(alpha: 0.15),
                    foregroundColor: AppColors.energyOrange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.send, size: 14),
                  label: const Text('Prompt Shatpawali Walk'),
                  onPressed: () {
                    ref.read(familyHealthProvider.notifier).sendSevaNudge(
                          memberId: member.id,
                          memberName: member.name,
                          nudgeType: 'Shatpawali Prompt',
                          message:
                              'Sent caring post-dinner Shatpawali walk prompt to ${member.name}.',
                          regionalMessage:
                              '${member.name} को शतपावली का स्नेहपूर्ण स्मरण भेजा गया।',
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Prompt sent to ${member.name}!'),
                        backgroundColor: AppColors.karmaGreen,
                      ),
                    );
                  },
                )
              else
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.karmaGreen,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.check, size: 14),
                  label: const Text('Active & Safe'),
                  onPressed: null,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNudgesList(List<FamilyCareNudge> nudges) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: nudges.map((nudge) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                const Icon(Icons.mark_email_read,
                    color: AppColors.focusBlue, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    nudge.message,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textPrimary, fontSize: 11),
                  ),
                ),
                Text(
                  '${DateTime.now().difference(nudge.sentAt).inMinutes}m ago',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFamilyPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Intergenerational Family Care (Parivar)',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma’s Family Health Hub enables caregivers to actively support aging parents and family members:\n\n'
                '• Remote Blood Pressure & Fasting Glucose tracking.\n'
                '• One-Tap Seva Nudges to gently remind elders of post-meal Shatpawali.\n'
                '• Seasonal Ayurvedic kitchen medicine remedies for natural digestive and joint support.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
