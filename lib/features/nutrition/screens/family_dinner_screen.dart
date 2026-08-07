import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/family_meal_planner_engine.dart';

/// §P5-Q Family Nutrition Integration Screen
/// Route: /food/family-dinner
class FamilyDinnerScreen extends StatefulWidget {
  const FamilyDinnerScreen({super.key});

  @override
  State<FamilyDinnerScreen> createState() => _FamilyDinnerScreenState();
}

class _FamilyDinnerScreenState extends State<FamilyDinnerScreen> {
  final _engine = const FamilyMealPlannerEngine();

  final List<FamilyMemberProfile> _familyMembers = const [
    FamilyMemberProfile(id: 'fam_1', name: 'Father (Rajesh)', role: 'Father', goals: ['diabetes_reversal']),
    FamilyMemberProfile(id: 'fam_2', name: 'Mother (Sunita)', role: 'Mother', goals: ['weight_loss']),
    FamilyMemberProfile(id: 'fam_3', name: 'Child (Aarav)', role: 'Child', goals: ['growth_stage']),
  ];

  late UnifiedFamilyMealPlan _plan;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final plan = _engine.planDinner(familyMembers: _familyMembers);
    setState(() {
      _plan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Family Dinner Engine', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Base Dish GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Unified Family Main Dish', style: AppTypography.bodySm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('GI ${_plan.selectedRecipe.glycemicIndex.round()} (Low GI)', style: AppTypography.labelMd.copyWith(color: AppColors.success)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_plan.selectedRecipe.name, style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(_plan.selectedRecipe.description, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _plan.conflictResolutionSummary,
                      style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Adapted Portions per Member Section
            Text('Adapted Portions per Family Member:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),

            for (final member in _familyMembers) ...[
              Builder(builder: (context) {
                final portion = _plan.memberPortions[member.id]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface1,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                member.role == 'Father'
                                    ? Icons.person
                                    : (member.role == 'Mother' ? Icons.person_3 : Icons.child_care),
                                color: AppColors.teal,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(member.name, style: AppTypography.labelLg),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.teal.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(portion.portionMultiplier * 100).round()}% Portion',
                              style: AppTypography.bodySm.copyWith(color: AppColors.teal, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Roti: ${portion.rotiGuidance}', style: AppTypography.labelLg.copyWith(fontSize: 13)),
                      Text('Sides: ${portion.sideDishGuidance}', style: AppTypography.bodySm),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.bg0,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          portion.customInstruction,
                          style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
