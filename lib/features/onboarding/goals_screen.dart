import 'dart:async';

import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/goals_controller.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// §P1-C — Goals Screen  (Step 1 of 5)
///
/// Multi-select goal picker with:
///  • max 3 goals, shake + toast on limit hit
///  • conditional weight-target slider for weight_loss / muscle_gain
///  • saves JSON array to Drift on Continue
class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen>
    with TickerProviderStateMixin {
  // Shake animation key → per-card animation controller
  final Map<String, AnimationController> _shakeControllers = {};
  final Map<String, Animation<double>> _shakeAnimations = {};

  // Toast overlay
  OverlayEntry? _toastEntry;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    for (final goal in GoalOption.all) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _shakeControllers[goal.id] = ctrl;
      _shakeAnimations[goal.id] = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 6, end: -4), weight: 2),
        TweenSequenceItem(tween: Tween(begin: -4, end: 4), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
      ]).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _toastEntry?.remove();
    for (final c in _shakeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onGoalTapped(String goalId) {
    final toggled = ref.read(onboardingGoalsProvider.notifier).toggleGoal(goalId);
    if (!toggled) {
      _shakeControllers[goalId]?.forward(from: 0);
      _showLimitToast();
    }
  }

  void _showLimitToast() {
    _toastTimer?.cancel();
    _toastEntry?.remove();

    _toastEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColorsDark.surface1,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColorsDark.glassBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Maximum 3 goals selectable',
                    style: AppTypography.labelLg.copyWith(color: AppColorsDark.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'अधिकतम 3 लक्ष्य चुने जा सकते हैं',
                    style: AppTypography.bodySm.copyWith(color: AppColorsDark.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_toastEntry!);
    _toastTimer = Timer(const Duration(seconds: 2), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  void _onContinue() async {
    // Save to DB (user ID stub — in real app comes from auth session)
    // For now, save with a placeholder ID if no user is seeded
    // Note: DB save is best-effort; we advance regardless (can retry on sync)
    // notifier.saveToDb(db, userId) — hooked once auth is in place
    final next = ref.read(onboardingFlowProvider.notifier).advance();
    if (next != null && mounted) context.go(pathForStep(next));
  }

  void _onBack() {
    final prev = ref.read(onboardingFlowProvider.notifier).back();
    if (prev != null && mounted) context.go(pathForStep(prev));
  }

  void _onSkip() {
    final next = ref.read(onboardingFlowProvider.notifier).skip();
    if (next != null && mounted) context.go(pathForStep(next));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalsState = ref.watch(onboardingGoalsProvider);
    final bg = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final canBack = ref.watch(onboardingCanGoBackProvider);
    final canSkip = ref.watch(onboardingCanSkipProvider);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canBack
            ? IconButton(
                key: const Key('goals_back_btn'),
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary),
                onPressed: _onBack,
              )
            : null,
        actions: [
          if (canSkip)
            TextButton(
              key: const Key('goals_skip_btn'),
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: AppTypography.bodyMd.copyWith(color: textSecondary),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress bar
            const OnboardingProgressIndicator(currentStep: 1, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    Text(
                      'Choose up to 3 Goals',
                      style: AppTypography.displayMd.copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'We personalise your plan around what matters most to you.',
                      style: AppTypography.bodyMd.copyWith(color: textSecondary),
                    ),
                    const SizedBox(height: 24),

                    // 2-column goal grid
                    _GoalGrid(
                      selected: goalsState.selectedGoals,
                      shakeAnimations: _shakeAnimations,
                      onTap: _onGoalTapped,
                    ),

                    const SizedBox(height: 20),

                    // Conditional target-weight slider
                    AnimatedSize(
                      duration: const Duration(milliseconds: 320),
                      curve: AppSprings.smoothAnimationCurve,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 280),
                        opacity: goalsState.showTargetWeightSlider ? 1.0 : 0.0,
                        child: goalsState.showTargetWeightSlider
                            ? _TargetWeightSlider(
                                targetWeight: goalsState.targetWeight ?? 75.0,
                                onChanged: (v) => ref
                                    .read(onboardingGoalsProvider.notifier)
                                    .updateTargetWeight(v),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FitButton(
                key: const Key('goals_continue_btn'),
                onPressed: goalsState.selectedGoals.isNotEmpty ? _onContinue : null,
                height: 54,
                child: Text(
                  'Continue',
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GoalGrid
// ─────────────────────────────────────────────────────────────────────────────

class _GoalGrid extends StatelessWidget {
  const _GoalGrid({
    required this.selected,
    required this.shakeAnimations,
    required this.onTap,
  });

  final List<String> selected;
  final Map<String, Animation<double>> shakeAnimations;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: GoalOption.all.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.0,
      ),
      itemBuilder: (context, i) {
        final goal = GoalOption.all[i];
        final isSelected = selected.contains(goal.id);
        return AnimatedBuilder(
          animation: shakeAnimations[goal.id]!,
          builder: (context, child) => Transform.translate(
            offset: Offset(shakeAnimations[goal.id]!.value, 0),
            child: child,
          ),
          child: _GoalChip(
            goal: goal,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () => onTap(goal.id),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GoalChip
// ─────────────────────────────────────────────────────────────────────────────

class _GoalChip extends StatefulWidget {
  const _GoalChip({
    required this.goal,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final GoalOption goal;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_GoalChip> createState() => _GoalChipState();
}

class _GoalChipState extends State<_GoalChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: AppSprings.touchResponseCurve),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final surface = widget.isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
    final glassBorder = widget.isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder;
    final textPrimary = widget.isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = widget.isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? primary.withValues(alpha: 0.15)
                : surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected ? primary : glassBorder,
              width: widget.isSelected ? 1.5 : 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Selected indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? primary : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected ? primary : glassBorder,
                    width: 1.5,
                  ),
                ),
                child: widget.isSelected
                    ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              // Emoji + label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(widget.goal.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.goal.label,
                            style: AppTypography.labelLg.copyWith(
                              color: widget.isSelected ? primary : textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.goal.labelHindi,
                      style: AppTypography.labelMd.copyWith(
                        color: textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TargetWeightSlider
// ─────────────────────────────────────────────────────────────────────────────

class _TargetWeightSlider extends StatelessWidget {
  const _TargetWeightSlider({
    required this.targetWeight,
    required this.onChanged,
  });

  final double targetWeight;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final surface = isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    // Round to nearest 0.5
    final displayWeight = (targetWeight * 2).round() / 2.0;

    return Container(
      key: const Key('goals_target_weight_slider'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target Weight',
                style: AppTypography.labelLg.copyWith(color: textSecondary),
              ),
              Text(
                '${displayWeight.toStringAsFixed(1)} kg',
                style: AppTypography.h3.copyWith(color: primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: primary,
              inactiveTrackColor: primary.withValues(alpha: 0.2),
              thumbColor: primary,
              overlayColor: primary.withValues(alpha: 0.15),
              trackHeight: 4,
            ),
            child: Slider(
              key: const Key('goals_weight_slider'),
              value: targetWeight.clamp(40.0, 150.0),
              min: 40.0,
              max: 150.0,
              divisions: 220, // 0.5 kg steps over 110 kg range
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('40 kg', style: AppTypography.labelMd.copyWith(color: textSecondary)),
              Text('150 kg', style: AppTypography.labelMd.copyWith(color: textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
