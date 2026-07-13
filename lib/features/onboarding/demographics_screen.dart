import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// §P1-D — Demographics Screen  (Step 2 of 5 — No Skip)
///
/// Collects:
///  • Gender (Male / Female toggle)
///  • Age slider  (13 – 100)
///  • Height slider (100 – 220 cm)  with metric ↔ imperial toggle
///  • Weight slider (20 – 200 kg)   with metric ↔ imperial toggle
///  • Activity level selector (5 pills)
///
/// Derives and displays:
///  • Live BMI with colour-coded category bar
///
/// On Continue:
///  • Validates ranges
///  • Computes TDEE + daily calorie target (Mifflin-St Jeor, never AI)
///  • Persists to Drift `users` table
///  • Navigates to next onboarding step
class DemographicsScreen extends ConsumerStatefulWidget {
  const DemographicsScreen({super.key});

  @override
  ConsumerState<DemographicsScreen> createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends ConsumerState<DemographicsScreen> {
  String? _validationError;

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onContinue() async {
    final notifier = ref.read(demographicsProvider.notifier);
    final error = notifier.validate();
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }
    setState(() => _validationError = null);
    // saveToDb: best-effort; always advance regardless (synced later)
    // notifier.saveToDb(db, userId) — hooked once auth is in place
    final next = ref.read(onboardingFlowProvider.notifier).advance();
    if (next != null && mounted) context.go(pathForStep(next));
  }

  void _onBack() {
    final prev = ref.read(onboardingFlowProvider.notifier).back();
    if (prev != null && mounted) context.go(pathForStep(prev));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(demographicsProvider);
    final bg = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final canBack = ref.watch(onboardingCanGoBackProvider);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canBack
            ? IconButton(
                key: const Key('demographics_back_btn'),
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary),
                onPressed: _onBack,
              )
            : null,
        actions: [
          // Metric ↔ Imperial toggle
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _UnitToggle(
              isMetric: state.unitIsMetric,
              onToggle: () => ref.read(demographicsProvider.notifier).toggleUnit(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgressIndicator(currentStep: 2, totalSteps: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Header ───────────────────────────────────────────────
                    Text(
                      'Tell us about yourself',
                      style: AppTypography.displayMd.copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'We use this to personalise your calorie & fitness targets.',
                      style: AppTypography.bodyMd.copyWith(color: textSecondary),
                    ),
                    const SizedBox(height: 28),

                    // ── Gender ───────────────────────────────────────────────
                    _SectionLabel(label: 'Gender', labelHindi: 'लिंग', isDark: isDark),
                    const SizedBox(height: 10),
                    _GenderToggle(
                      selected: state.gender,
                      onChanged: (g) => ref.read(demographicsProvider.notifier).setGender(g),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),

                    // ── Age ──────────────────────────────────────────────────
                    _SliderSection(
                      key: const Key('demographics_age_slider_section'),
                      labelEnglish: 'Age',
                      labelHindi: 'आयु',
                      value: state.age.toDouble(),
                      displayValue: '${state.age} yrs',
                      min: 13,
                      max: 100,
                      divisions: 87,
                      isDark: isDark,
                      onChanged: (v) =>
                          ref.read(demographicsProvider.notifier).setAge(v.round()),
                    ),
                    const SizedBox(height: 20),

                    // ── Height ───────────────────────────────────────────────
                    _SliderSection(
                      key: const Key('demographics_height_slider_section'),
                      labelEnglish: 'Height',
                      labelHindi: 'ऊँचाई',
                      value: state.heightCm,
                      displayValue: state.heightDisplay,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      isDark: isDark,
                      onChanged: (v) =>
                          ref.read(demographicsProvider.notifier).setHeight(v),
                    ),
                    const SizedBox(height: 20),

                    // ── Weight ───────────────────────────────────────────────
                    _SliderSection(
                      key: const Key('demographics_weight_slider_section'),
                      labelEnglish: 'Weight',
                      labelHindi: 'वजन',
                      value: state.weightKg,
                      displayValue: state.weightDisplay,
                      min: 20,
                      max: 200,
                      divisions: 360, // 0.5 kg steps
                      isDark: isDark,
                      onChanged: (v) =>
                          ref.read(demographicsProvider.notifier).setWeight(v),
                    ),
                    const SizedBox(height: 28),

                    // ── Live BMI ─────────────────────────────────────────────
                    _BmiCard(bmi: state.bmi, isDark: isDark),
                    const SizedBox(height: 28),

                    // ── Activity Level ───────────────────────────────────────
                    _SectionLabel(
                      label: 'Activity Level',
                      labelHindi: 'गतिविधि स्तर',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _ActivityLevelSelector(
                      selected: state.activityLevel,
                      onChanged: (l) =>
                          ref.read(demographicsProvider.notifier).setActivity(l),
                      isDark: isDark,
                    ),

                    // ── Validation error ─────────────────────────────────────
                    if (_validationError != null) ...[
                      const SizedBox(height: 16),
                      _ValidationError(message: _validationError!, isDark: isDark),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Continue ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FitButton(
                key: const Key('demographics_continue_btn'),
                onPressed: _onContinue,
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
// _SectionLabel
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.labelHindi,
    required this.isDark,
  });

  final String label;
  final String labelHindi;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary    = isDark ? AppColorsDark.textPrimary    : AppColorsLight.textPrimary;
    final textSecondary  = isDark ? AppColorsDark.textSecondary  : AppColorsLight.textSecondary;
    return Row(
      children: [
        Text(label, style: AppTypography.h3.copyWith(color: textPrimary)),
        const SizedBox(width: 8),
        Text(
          labelHindi,
          style: AppTypography.bodySm.copyWith(color: textSecondary),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GenderToggle
// ─────────────────────────────────────────────────────────────────────────────

class _GenderToggle extends StatelessWidget {
  const _GenderToggle({
    required this.selected,
    required this.onChanged,
    required this.isDark,
  });

  final Gender selected;
  final ValueChanged<Gender> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderChip(
            key: const Key('demographics_gender_male'),
            label: 'Male',
            labelHindi: 'पुरुष',
            emoji: '♂️',
            isSelected: selected == Gender.male,
            isDark: isDark,
            onTap: () => onChanged(Gender.male),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderChip(
            key: const Key('demographics_gender_female'),
            label: 'Female',
            labelHindi: 'महिला',
            emoji: '♀️',
            isSelected: selected == Gender.female,
            isDark: isDark,
            onTap: () => onChanged(Gender.female),
          ),
        ),
      ],
    );
  }
}

class _GenderChip extends StatefulWidget {
  const _GenderChip({
    super.key,
    required this.label,
    required this.labelHindi,
    required this.emoji,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String labelHindi;
  final String emoji;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_GenderChip> createState() => _GenderChipState();
}

class _GenderChipState extends State<_GenderChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _pressCtrl, curve: AppSprings.touchResponseCurve));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary       = widget.isDark ? AppColorsDark.primary       : AppColorsLight.primary;
    final surface       = widget.isDark ? AppColorsDark.surface1      : AppColorsLight.surface1;
    final glassBorder   = widget.isDark ? AppColorsDark.glassBorder   : AppColorsLight.glassBorder;
    final textPrimary   = widget.isDark ? AppColorsDark.textPrimary   : AppColorsLight.textPrimary;
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.isSelected ? primary.withValues(alpha: 0.15) : surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: widget.isSelected ? primary : glassBorder,
              width: widget.isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: AppTypography.h3.copyWith(
                  color: widget.isSelected ? primary : textPrimary,
                ),
              ),
              Text(
                widget.labelHindi,
                style: AppTypography.bodySm.copyWith(color: textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SliderSection  (reusable Age / Height / Weight)
// ─────────────────────────────────────────────────────────────────────────────

class _SliderSection extends StatelessWidget {
  const _SliderSection({
    super.key,
    required this.labelEnglish,
    required this.labelHindi,
    required this.value,
    required this.displayValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.isDark,
    required this.onChanged,
  });

  final String labelEnglish;
  final String labelHindi;
  final double value;
  final String displayValue;
  final double min;
  final double max;
  final int divisions;
  final bool isDark;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary       = isDark ? AppColorsDark.primary       : AppColorsLight.primary;
    final surface       = isDark ? AppColorsDark.surface1      : AppColorsLight.surface1;
    final textPrimary   = isDark ? AppColorsDark.textPrimary   : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    labelEnglish,
                    style: AppTypography.labelLg.copyWith(color: textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    labelHindi,
                    style: AppTypography.bodySm.copyWith(color: textSecondary),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
                  displayValue,
                  key: ValueKey(displayValue),
                  style: AppTypography.h3.copyWith(color: primary),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor:   primary,
              inactiveTrackColor: primary.withValues(alpha: 0.18),
              thumbColor:         primary,
              overlayColor:       primary.withValues(alpha: 0.12),
              trackHeight:        4,
              thumbShape:         const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                min.round().toString(),
                style: AppTypography.labelMd.copyWith(color: textSecondary),
              ),
              Text(
                max.round().toString(),
                style: AppTypography.labelMd.copyWith(color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BmiCard  — Live BMI display with colour-coded indicator bar
// ─────────────────────────────────────────────────────────────────────────────

class _BmiCard extends StatelessWidget {
  const _BmiCard({required this.bmi, required this.isDark});

  final BmiResult bmi;
  final bool isDark;

  // Colour for each category (using brand tokens where possible)
  Color get _barColor {
    return switch (bmi.category) {
      BmiCategory.underweight => const Color(0xFF60A5FA),  // blue-400
      BmiCategory.normal      => AppColorsDark.success,    // green
      BmiCategory.overweight  => AppColorsDark.warning,    // amber
      BmiCategory.obese       => AppColorsDark.error,      // red
    };
  }

  @override
  Widget build(BuildContext context) {
    final surface       = isDark ? AppColorsDark.surface1      : AppColorsLight.surface1;
    final textPrimary   = isDark ? AppColorsDark.textPrimary   : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final glassBorder   = isDark ? AppColorsDark.glassBorder   : AppColorsLight.glassBorder;

    return Container(
      key: const Key('demographics_bmi_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: label + live score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMI',
                    style: AppTypography.labelLg.copyWith(color: textSecondary),
                  ),
                  Text(
                    'Body Mass Index',
                    style: AppTypography.bodySm.copyWith(color: textSecondary),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Column(
                  key: ValueKey(bmi.displayName),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bmi.displayName,
                      style: AppTypography.displayMd.copyWith(color: _barColor),
                    ),
                    Text(
                      bmi.categoryLabel,
                      style: AppTypography.labelLg.copyWith(color: _barColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Colour track bar
          Stack(
            children: [
              // Background track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF60A5FA), // Underweight — blue
                      Color(0xFF4ADE80), // Normal — green
                      Color(0xFFFBBF24), // Overweight — amber
                      Color(0xFFF87171), // Obese — red
                    ],
                  ),
                ),
              ),
              // Indicator dot
              Positioned(
                left: MediaQuery.of(context).size.width * 0.0 +
                    (MediaQuery.of(context).size.width - 72) *
                        bmi.barFraction
                        - 6,
                top: -2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _barColor,
                    border: Border.all(
                      color: isDark ? AppColorsDark.bg0 : AppColorsLight.bg0,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _barColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Under', style: AppTypography.labelMd.copyWith(color: textSecondary)),
              Text('Normal', style: AppTypography.labelMd.copyWith(color: textSecondary)),
              Text('Over', style: AppTypography.labelMd.copyWith(color: textSecondary)),
              Text('Obese', style: AppTypography.labelMd.copyWith(color: textSecondary)),
            ],
          ),
          const SizedBox(height: 10),

          // Calorie target preview
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _barColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: _barColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department_rounded,
                    color: _barColor, size: 16),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    key: ValueKey(bmi.categoryLabel),
                    'Estimated daily target will be shown after Continue',
                    style: AppTypography.bodySm.copyWith(color: textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActivityLevelSelector
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityLevelSelector extends StatelessWidget {
  const _ActivityLevelSelector({
    required this.selected,
    required this.onChanged,
    required this.isDark,
  });

  final ActivityLevel selected;
  final ValueChanged<ActivityLevel> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ActivityLevel.values.map((level) {
        final isSelected = selected == level;
        return _ActivityPill(
          level: level,
          isSelected: isSelected,
          isDark: isDark,
          onTap: () => onChanged(level),
        );
      }).toList(),
    );
  }
}

class _ActivityPill extends StatefulWidget {
  const _ActivityPill({
    required this.level,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final ActivityLevel level;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_ActivityPill> createState() => _ActivityPillState();
}

class _ActivityPillState extends State<_ActivityPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _pressCtrl, curve: AppSprings.touchResponseCurve));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary       = widget.isDark ? AppColorsDark.primary       : AppColorsLight.primary;
    final surface       = widget.isDark ? AppColorsDark.surface1      : AppColorsLight.surface1;
    final glassBorder   = widget.isDark ? AppColorsDark.glassBorder   : AppColorsLight.glassBorder;
    final textPrimary   = widget.isDark ? AppColorsDark.textPrimary   : AppColorsLight.textPrimary;
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: widget.isSelected ? primary.withValues(alpha: 0.15) : surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: widget.isSelected ? primary : glassBorder,
              width: widget.isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.level.label,
                style: AppTypography.labelLg.copyWith(
                  color: widget.isSelected ? primary : textPrimary,
                ),
              ),
              Text(
                widget.level.labelHindi,
                style: AppTypography.labelMd.copyWith(color: textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _UnitToggle  (metric ↔ imperial)
// ─────────────────────────────────────────────────────────────────────────────

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.isMetric, required this.onToggle});

  final bool isMetric;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final primary  = isDark ? AppColorsDark.primary  : AppColorsLight.primary;
    final surface  = isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
    final textMuted = isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted;

    return GestureDetector(
      key: const Key('demographics_unit_toggle'),
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UnitLabel(text: 'kg/cm', isActive: isMetric, primary: primary, muted: textMuted),
            const SizedBox(width: 6),
            Text('·', style: TextStyle(color: textMuted)),
            const SizedBox(width: 6),
            _UnitLabel(text: 'lbs/ft', isActive: !isMetric, primary: primary, muted: textMuted),
          ],
        ),
      ),
    );
  }
}

class _UnitLabel extends StatelessWidget {
  const _UnitLabel({
    required this.text,
    required this.isActive,
    required this.primary,
    required this.muted,
  });

  final String text;
  final bool isActive;
  final Color primary;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: AppTypography.labelMd.copyWith(
        color: isActive ? primary : muted,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
      ),
      child: Text(text),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ValidationError
// ─────────────────────────────────────────────────────────────────────────────

class _ValidationError extends StatelessWidget {
  const _ValidationError({required this.message, required this.isDark});

  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final errorColor = isDark ? AppColorsDark.error : AppColorsLight.error;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: errorColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMd.copyWith(color: errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
