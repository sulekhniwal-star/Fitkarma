import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';
import 'package:fitkarma/features/onboarding/diet_plan_controller.dart';
import 'package:fitkarma/features/onboarding/diet_plan_models.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:fitkarma/shared/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// §P1-E — AI Diet Plan Results Screen  (Step 3 of 5)
///
/// States:
///   loading  → ShimmerLoader skeleton cards
///   loaded   → 7-day tab header + DailyTargets card + MealCards list
///   error    → FitErrorState with Retry button
///
/// Controls:
///   [Regenerate (N left)]  → force-refreshes via DietPlanService
///   [Accept Plan →]        → advances onboarding flow
class DietPlanScreen extends ConsumerStatefulWidget {
  const DietPlanScreen({super.key});

  @override
  ConsumerState<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends ConsumerState<DietPlanScreen> {
  // Build a stub request using demographics state; replaced with real user
  // data once auth is wired.
  DietPlanRequest get _request {
    final demo = ref.read(demographicsProvider);
    return DietPlanRequest(
      userId:         'onboarding_user',
      age:            demo.age,
      gender:         demo.gender,
      weightKg:       demo.weightKg,
      heightCm:       demo.heightCm,
      activityLevel:  demo.activityLevel,
      goals:          const ['general_fitness'],
      calorieTarget:  demo.dailyCalorieTarget,
      proteinTargetG: computeProteinTarget(demo.weightKg),
    );
  }

  @override
  void initState() {
    super.initState();
    // Kick off plan generation on first render — only if not already loaded/loading.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final status = ref.read(dietPlanProvider).status;
      if (status == DietPlanStatus.idle || status == DietPlanStatus.error) {
        ref.read(dietPlanProvider.notifier).load(_request);
      }
    });
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onAccept() {
    final next = ref.read(onboardingFlowProvider.notifier).advance();
    if (next != null && mounted) context.go(pathForStep(next));
  }

  void _onBack() {
    final prev = ref.read(onboardingFlowProvider.notifier).back();
    if (prev != null && mounted) context.go(pathForStep(prev));
  }

  void _onRegenerate() =>
      ref.read(dietPlanProvider.notifier).regenerate(_request);

  void _onRetry() =>
      ref.read(dietPlanProvider.notifier).load(_request);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final planState     = ref.watch(dietPlanProvider);
    final bg            = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary   = isDark ? AppColorsDark.textPrimary   : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final canBack       = ref.watch(onboardingCanGoBackProvider);
    final canSkip       = ref.watch(onboardingCanSkipProvider);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canBack
            ? IconButton(
                key: const Key('diet_plan_back_btn'),
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary),
                onPressed: _onBack,
              )
            : null,
        actions: [
          if (canSkip)
            TextButton(
              key: const Key('diet_plan_skip_btn'),
              onPressed: () {
                final next = ref.read(onboardingFlowProvider.notifier).skip();
                if (next != null && mounted) context.go(pathForStep(next));
              },
              child: Text('Skip',
                  style: AppTypography.bodyMd.copyWith(color: textSecondary)),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgressIndicator(currentStep: 3, totalSteps: 5),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: AppSprings.smoothAnimationCurve,
                child: switch (planState.status) {
                  DietPlanStatus.idle    => const SizedBox.shrink(),
                  DietPlanStatus.loading => _buildSkeleton(isDark),
                  DietPlanStatus.error   => _buildError(isDark, planState),
                  DietPlanStatus.loaded  => _buildPlan(context, isDark, textPrimary, textSecondary, planState),
                },
              ),
            ),
            _buildFooter(isDark, planState),
          ],
        ),
      ),
    );
  }

  // ── Skeleton (shimmer while loading) ─────────────────────────────────────

  Widget _buildSkeleton(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('diet_plan_skeleton'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _SkeletonBlock(width: 220, height: 28, isDark: isDark),
          const SizedBox(height: 6),
          _SkeletonBlock(width: 160, height: 16, isDark: isDark),
          const SizedBox(height: 20),
          // Day tab row
          Row(
            children: List.generate(
              7,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                  child: _SkeletonBlock(height: 42, isDark: isDark),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SkeletonBlock(height: 80, isDark: isDark),
          const SizedBox(height: 16),
          ..._mealTypeLabels.expand(
            (label) => [
              _SkeletonBlock(width: 100, height: 18, isDark: isDark),
              const SizedBox(height: 8),
              _SkeletonBlock(height: 90, isDark: isDark),
              const SizedBox(height: 14),
            ],
          ),
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────

  Widget _buildError(bool isDark, DietPlanState state) {
    return SingleChildScrollView(
      key: const ValueKey('diet_plan_error'),
      padding: const EdgeInsets.all(AppSpacing.screenH),
      child: FitErrorState(
        englishMessage: state.errorMessage ?? 'Failed to generate your diet plan.',
        hindiMessage:   'आहार योजना बनाने में विफल।',
        onRetry:        _onRetry,
      ),
    );
  }

  // ── Loaded plan ────────────────────────────────────────────────────────────

  Widget _buildPlan(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    DietPlanState state,
  ) {
    final plan        = state.plan!;
    final selectedDay = plan.days[state.selectedDayIndex];

    return SingleChildScrollView(
      key: const ValueKey('diet_plan_loaded'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Header
          Text(
            'Your Personalised 7-Day Indian Diet Plan',
            style: AppTypography.displayMd.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (!plan.isAiGenerated) ...[
                const Icon(Icons.offline_bolt_rounded,
                    size: 13, color: AppColorsDark.accent),
                const SizedBox(width: 4),
                Text(
                  'Offline plan — connect for AI-personalised',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColorsDark.accent,
                  ),
                ),
              ] else
                Text(
                  'Personalised by AI · Indian nutrition science',
                  style: AppTypography.bodySm.copyWith(color: textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Day tabs
          _DayTabRow(
            days:          plan.days,
            selectedIndex: state.selectedDayIndex,
            isDark:        isDark,
            onTap:         (i) => ref.read(dietPlanProvider.notifier).selectDay(i),
          ),
          const SizedBox(height: 16),

          // Daily targets card
          _DailyTargetsCard(
            calorieTarget:  plan.dailyCalorieTarget,
            proteinTargetG: plan.dailyProteinTargetG,
            actualCalories: selectedDay.totalCalories,
            actualProteinG: selectedDay.totalProteinG,
            isDark:         isDark,
          ),
          const SizedBox(height: 20),

          // Meal cards
          ..._buildMealSections(selectedDay, isDark, textPrimary, textSecondary),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<Widget> _buildMealSections(
    DietDay day,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    final widgets = <Widget>[];
    for (final mealType in _mealTypeLabels) {
      final meals = day.meals.where((m) => m.mealType == mealType).toList();
      if (meals.isEmpty) continue;
      widgets
        ..add(Text(
          _mealTypeDisplay[mealType]!,
          style: AppTypography.h3.copyWith(color: textSecondary),
        ))
        ..add(const SizedBox(height: 8));
      for (final meal in meals) {
        widgets
          ..add(_MealCard(meal: meal, isDark: isDark))
          ..add(const SizedBox(height: 10));
      }
      widgets.add(const SizedBox(height: 8));
    }
    return widgets;
  }

  // ── Footer (Regenerate + Accept) ──────────────────────────────────────────

  Widget _buildFooter(bool isDark, DietPlanState state) {
    final isLoaded = state.hasData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          // Regenerate
          Expanded(
            flex: 2,
            child: FitButton(
              key: const Key('diet_plan_regenerate_btn'),
              onPressed: (isLoaded && state.regeneratesLeft > 0)
                  ? _onRegenerate
                  : null,
              type:   FitButtonType.secondary,
              height: 54,
              child: Text(
                'Regenerate (${state.regeneratesLeft} left)',
                style: AppTypography.labelLg.copyWith(
                  color: isDark
                      ? AppColorsDark.textPrimary
                      : AppColorsLight.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Accept
          Expanded(
            flex: 3,
            child: FitButton(
              key: const Key('diet_plan_accept_btn'),
              onPressed: isLoaded ? _onAccept : null,
              height:    54,
              child: Text(
                'Accept Plan  →',
                style: AppTypography.h3.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _mealTypeLabels = ['breakfast', 'lunch', 'snack', 'dinner'];
  static const _mealTypeDisplay = {
    'breakfast': '🌅  Breakfast',
    'lunch':     '☀️  Lunch',
    'snack':     '🍎  Snack',
    'dinner':    '🌙  Dinner',
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// _DayTabRow
// ─────────────────────────────────────────────────────────────────────────────

class _DayTabRow extends StatelessWidget {
  const _DayTabRow({
    required this.days,
    required this.selectedIndex,
    required this.isDark,
    required this.onTap,
  });

  final List<DietDay> days;
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('diet_plan_day_tabs'),
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final isSelected = i == selectedIndex;
          final primary    = isDark ? AppColorsDark.primary    : AppColorsLight.primary;
          final surface    = isDark ? AppColorsDark.surface1   : AppColorsLight.surface1;
          final glassBorder= isDark ? AppColorsDark.glassBorder: AppColorsLight.glassBorder;
          final textPrimary= isDark ? AppColorsDark.textPrimary: AppColorsLight.textPrimary;
          final abbrev     = days[i].day.substring(0, 3);

          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primary : surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isSelected ? primary : glassBorder,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Text(
                abbrev,
                style: AppTypography.labelLg.copyWith(
                  color: isSelected ? Colors.white : textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DailyTargetsCard
// ─────────────────────────────────────────────────────────────────────────────

class _DailyTargetsCard extends StatelessWidget {
  const _DailyTargetsCard({
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.actualCalories,
    required this.actualProteinG,
    required this.isDark,
  });

  final int    calorieTarget;
  final int    proteinTargetG;
  final int    actualCalories;
  final double actualProteinG;
  final bool   isDark;

  @override
  Widget build(BuildContext context) {
    final surface     = isDark ? AppColorsDark.surface0   : AppColorsLight.surface0;
    final glassBorder = isDark ? AppColorsDark.glassBorder: AppColorsLight.glassBorder;
    final primary     = isDark ? AppColorsDark.primary    : AppColorsLight.primary;
    final teal        = isDark ? AppColorsDark.teal       : AppColorsLight.teal;
    final textPrimary = isDark ? AppColorsDark.textPrimary: AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    final calFrac     = (actualCalories / calorieTarget).clamp(0.0, 1.0);
    final proFrac     = (actualProteinG / proteinTargetG).clamp(0.0, 1.0);

    return Container(
      key: const Key('diet_plan_targets_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: glassBorder),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            surface,
            primary.withValues(alpha: 0.04),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Targets',
              style: AppTypography.h3.copyWith(color: textPrimary)),
          const SizedBox(height: 12),
          _MacroBar(
            label:  '🔥 Calories',
            target: '$calorieTarget kcal',
            actual: '$actualCalories kcal',
            fraction: calFrac,
            barColor: primary,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 10),
          _MacroBar(
            label:  '💪 Protein',
            target: '${proteinTargetG}g',
            actual: '${actualProteinG.round()}g',
            fraction: proFrac,
            barColor: teal,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.target,
    required this.actual,
    required this.fraction,
    required this.barColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String label;
  final String target;
  final String actual;
  final double fraction;
  final Color barColor;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelLg.copyWith(color: textSecondary)),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: actual,
                    style: AppTypography.labelLg.copyWith(
                        color: textPrimary, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ' / $target',
                    style: AppTypography.labelMd.copyWith(color: textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: barColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MealCard
// ─────────────────────────────────────────────────────────────────────────────

class _MealCard extends StatefulWidget {
  const _MealCard({required this.meal, required this.isDark});

  final DietMeal meal;
  final bool isDark;

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _pressCtrl, curve: AppSprings.touchResponseCurve));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark      = widget.isDark;
    final surface     = isDark ? AppColorsDark.surface1   : AppColorsLight.surface1;
    final glassBorder = isDark ? AppColorsDark.glassBorder: AppColorsLight.glassBorder;
    final primary     = isDark ? AppColorsDark.primary    : AppColorsLight.primary;
    final teal        = isDark ? AppColorsDark.teal       : AppColorsLight.teal;
    final accent      = isDark ? AppColorsDark.accent     : AppColorsLight.accent;
    final textPrimary = isDark ? AppColorsDark.textPrimary: AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final textMuted   = isDark ? AppColorsDark.textMuted  : AppColorsLight.textMuted;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp:   (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:        surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border:       Border.all(color: glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + calories
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.meal.name,
                      style: AppTypography.h3.copyWith(color: textPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: primary.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      '${widget.meal.calories} kcal',
                      style: AppTypography.labelMd.copyWith(
                          color: primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Macro pills row
              Row(
                children: [
                  _MacroPill(
                      label: '${widget.meal.proteinG.round()}g P', color: teal),
                  const SizedBox(width: 6),
                  _MacroPill(
                      label: '${widget.meal.carbsG.round()}g C', color: accent),
                  const SizedBox(width: 6),
                  _MacroPill(
                      label: '${widget.meal.fatG.round()}g F',
                      color: textSecondary),
                ],
              ),
              // Tip (if any)
              if (widget.meal.tip != null) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        size: 13, color: textMuted),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        widget.meal.tip!,
                        style: AppTypography.bodySm.copyWith(color: textMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelMd.copyWith(
          color:      color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SkeletonBlock  — animated shimmer placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _SkeletonBlock extends StatefulWidget {
  const _SkeletonBlock({
    this.width,
    required this.height,
    required this.isDark,
  });

  final double? width;
  final double height;
  final bool isDark;

  @override
  State<_SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<_SkeletonBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width:  widget.width,
        height: widget.height,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color:        base.withValues(alpha: _anim.value + 0.3),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
