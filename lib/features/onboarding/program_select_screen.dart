import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/program_select_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';

class ProgramSelectScreen extends ConsumerStatefulWidget {
  const ProgramSelectScreen({super.key});

  @override
  ConsumerState<ProgramSelectScreen> createState() =>
      _ProgramSelectScreenState();
}

class _ProgramSelectScreenState extends ConsumerState<ProgramSelectScreen> {
  @override
  void initState() {
    super.initState();
    // Load recommendations on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(onboardingProgramSelectProvider.notifier)
          .loadRecommendation(ref.read(databaseProvider), 'onboarding_user');
    });
  }

  void _onBack() {
    final prev = ref.read(onboardingFlowProvider.notifier).back();
    if (prev != null && mounted) {
      context.go(pathForStep(prev));
    }
  }

  Future<void> _onSelectBlueprint() async {
    final db = ref.read(databaseProvider);
    final notifier = ref.read(onboardingProgramSelectProvider.notifier);
    await notifier.saveToDb(db, 'onboarding_user');

    if (mounted) {
      final next = ref.read(onboardingFlowProvider.notifier).advance();
      if (next != null) {
        context.go(pathForStep(next));
      } else {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColorsDark.bg0 : AppColorsDark.bg0;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsDark.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsDark.textSecondary;

    final selectState = ref.watch(onboardingProgramSelectProvider);
    final recommended = selectState.recommendedProgram;
    final selected = selectState.selectedProgram;

    if (selectState.isLoading || recommended == null || selected == null) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColorsDark.primary),
        ),
      );
    }

    final isRecommendedSelected = selected.id == recommended.id;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: _onBack,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingProgressIndicator(currentStep: 4, totalSteps: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BilingualLabel(
                      englishText: 'Your Recommended Blueprint',
                      hindiText: 'आपका अनुशंसित ब्लूप्रिंट',
                      englishStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      alignment: CrossAxisAlignment.center,
                    ),
                    const SizedBox(height: 20),
                    // Hero Recommendation Card
                    BentoCard(
                      onTap: () {
                        ref
                            .read(onboardingProgramSelectProvider.notifier)
                            .selectProgram(recommended);
                      },
                      customBgColor: isRecommendedSelected
                          ? AppColorsDark.primaryMuted
                          : AppColorsDark.glass,
                      hasSecondaryGlow: isRecommendedSelected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColorsDark.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'RECOMMENDED',
                                  style: AppTypography.labelMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isRecommendedSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColorsDark.primary,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            recommended.name,
                            style: AppTypography.h1.copyWith(
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recommended.targetUser,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColorsDark.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            recommended.description,
                            style: AppTypography.bodyMd.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                            color: AppColorsDark.divider,
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Evolution Timeline:',
                            style: AppTypography.labelLg.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTimeline(
                            recommended,
                            textPrimary,
                            textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Explore Other Blueprints',
                      style: AppTypography.h2.copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 12),
                    // Alternative blueprints list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ProgramBlueprint.all.length,
                      itemBuilder: (context, index) {
                        final prog = ProgramBlueprint.all[index];
                        // Skip rendering recommended program in list to avoid duplicates
                        if (prog.id == recommended.id)
                          return const SizedBox.shrink();

                        final isSelected = selected.id == prog.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: BentoCard(
                            onTap: () {
                              ref
                                  .read(
                                    onboardingProgramSelectProvider.notifier,
                                  )
                                  .selectProgram(prog);
                            },
                            customBgColor: isSelected
                                ? AppColorsDark.primaryMuted
                                : AppColorsDark.glass,
                            hasSecondaryGlow: isSelected,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        prog.name,
                                        style: AppTypography.h2.copyWith(
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColorsDark.primary,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  prog.targetUser,
                                  style: AppTypography.bodySm.copyWith(
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  prog.description,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: textSecondary,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 16),
                                  const Divider(
                                    color: AppColorsDark.divider,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTimeline(
                                    prog,
                                    textPrimary,
                                    textSecondary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    FitButton(
                      onPressed: _onSelectBlueprint,
                      child: Text('Select: ${selected.name}'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(
    ProgramBlueprint prog,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildTimelineNode(
            prog.name,
            'Current',
            AppColorsDark.primary,
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppColorsDark.textMuted),
        Expanded(
          child: _buildTimelineNode(
            prog.evolvesToLabel,
            'Next Tier',
            AppColorsDark.secondary,
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppColorsDark.textMuted),
        Expanded(
          child: _buildTimelineNode(
            'Peak Performance',
            'Goal Stage',
            AppColorsDark.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(String title, String label, Color color) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: AppTypography.labelMd.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(color: AppColorsDark.textMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
