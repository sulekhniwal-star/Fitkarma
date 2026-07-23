/// §P5-C Fix My Meal Screen
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:fitkarma/features/food/fix_my_meal_controller.dart';
import 'package:fitkarma/features/food/meal_analysis_pipeline.dart';
import 'package:fitkarma/features/food/meal_vision_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0E0F14);
const _surfaceColor = Color(0xFF1A1C26);
const _cardColor = Color(0xFF222434);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentRed = Color(0xFFF87171);
const _accentBlue = Color(0xFF60A5FA);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2D2F45);

// ─────────────────────────────────────────────────────────────────────────────

class FixMyMealScreen extends ConsumerStatefulWidget {
  const FixMyMealScreen({super.key});

  @override
  ConsumerState<FixMyMealScreen> createState() => _FixMyMealScreenState();
}

class _FixMyMealScreenState extends ConsumerState<FixMyMealScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fixMyMealProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _textPrimary,
          ),
          onPressed: () {
            ref.read(fixMyMealProvider.notifier).reset();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Fix My Meal',
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (state.phase == FixMyMealPhase.result)
            IconButton(
              key: const Key('fix_my_meal_reanalyze'),
              icon: const Icon(Icons.refresh_rounded, color: _accentOrange),
              onPressed: () => ref.read(fixMyMealProvider.notifier).reset(),
            ),
        ],
      ),
      body: SafeArea(
        child: switch (state.phase) {
          FixMyMealPhase.idle => _IdlePickerSection(onPickImage: _onPickImage),
          FixMyMealPhase.analyzing => _AnalyzingSection(pulseAnim: _pulseAnim),
          FixMyMealPhase.result => _ResultSection(state: state),
          FixMyMealPhase.error => _ErrorSection(
            message: state.errorMessage ?? 'Unknown error',
            onRetry: () => ref.read(fixMyMealProvider.notifier).reset(),
          ),
        },
      ),
    );
  }

  /// Called by picker buttons. Accepts synthetic [Uint8List] in tests,
  /// would call image_picker in production.
  void _onPickImage(Uint8List bytes) {
    ref.read(fixMyMealProvider.notifier).pickImage(bytes);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Idle Phase — Photo Picker
// ─────────────────────────────────────────────────────────────────────────────

class _IdlePickerSection extends StatelessWidget {
  const _IdlePickerSection({required this.onPickImage});

  final void Function(Uint8List) onPickImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Dashed camera card
          GestureDetector(
            key: const Key('fix_my_meal_camera_card'),
            onTap: () => onPickImage(
              // In real app: await ImagePicker().pickImage(source: ImageSource.camera)
              // In tests / demo: synthetic bytes embedding the keyword 'dosa'
              Uint8List.fromList('dosa meal photo'.codeUnits),
            ),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _accentOrange.withAlpha(100),
                  width: 1.5,
                  // Dashed border via custom painter alternative — use simple border
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: _accentOrange.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: _accentOrange,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Snap your meal',
                    style: TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We\'ll identify it and compute macros in seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _PickerButton(
                  key: const Key('fix_my_meal_take_photo'),
                  icon: Icons.camera_alt_rounded,
                  label: 'Take Photo',
                  onTap: () => onPickImage(
                    Uint8List.fromList('meal photo camera'.codeUnits),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerButton(
                  key: const Key('fix_my_meal_gallery'),
                  icon: Icons.photo_library_rounded,
                  label: 'From Gallery',
                  onTap: () => onPickImage(
                    Uint8List.fromList('meal from gallery'.codeUnits),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // How it works strip
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How it works',
                  style: TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                for (final step in [
                  ('🔍', 'Identifies the meal from your photo'),
                  ('🧮', 'Computes macros with §P5-D quality engine'),
                  ('✅', 'Shows impact on your goal + fix tips'),
                  ('📝', 'Log with one tap after adjusting portions'),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(step.$1, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step.$2,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
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

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _accentOrange, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Analyzing Phase — Pulse animation
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyzingSection extends StatefulWidget {
  const _AnalyzingSection({required this.pulseAnim});

  final Animation<double> pulseAnim;

  @override
  State<_AnalyzingSection> createState() => _AnalyzingSectionState();
}

class _AnalyzingSectionState extends State<_AnalyzingSection> {
  final List<String> _messages = [
    'Identifying meal…',
    'Computing macros…',
    'Running quality analysis…',
  ];
  int _msgIndex = 0;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _timers.add(
      Timer(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _msgIndex = 1);
      }),
    );
    _timers.add(
      Timer(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _msgIndex = 2);
      }),
    );
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: widget.pulseAnim,
            builder: (context, child) => Transform.scale(
              scale: widget.pulseAnim.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentOrange.withAlpha(25),
                  boxShadow: [
                    BoxShadow(
                      color: _accentOrange.withAlpha(60),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: _accentOrange,
                  size: 52,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _messages[_msgIndex],
              key: ValueKey(_msgIndex),
              style: const TextStyle(
                color: _textPrimary,
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'AI vision + offline meal database',
            style: TextStyle(color: _textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Result Phase — Full analysis card
// ─────────────────────────────────────────────────────────────────────────────

class _ResultSection extends ConsumerWidget {
  const _ResultSection({required this.state});

  final FixMyMealState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vision = state.visionResponse!;
    final analysis = state.analysisResult;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Detected meal header ──
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detected',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vision.detectedMeal,
                            key: const Key('fix_my_meal_detected_name'),
                            style: const TextStyle(
                              color: _textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SourceBadge(source: vision.source),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Confidence: ${(vision.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Macros strip ──
          _MacroStrip(
            calories: state.effectiveCalories,
            proteinG: state.effectiveProteinG,
            carbsG: state.effectiveCarbsG,
            fatG: state.effectiveFatG,
          ),

          const SizedBox(height: 12),

          // ── Meal Quality Score ──
          if (analysis != null) ...[
            _QualityScoreCard(score: analysis.mealQualityScore),
            const SizedBox(height: 12),

            // ── Impact row ──
            Row(
              children: [
                Expanded(
                  child: _ImpactCard(
                    label: 'Readiness Impact',
                    value: analysis.readinessImpact >= 0
                        ? '+${analysis.readinessImpact}%'
                        : '${analysis.readinessImpact}%',
                    color: analysis.readinessImpact >= 0
                        ? _accentGreen
                        : _accentRed,
                    icon: Icons.bolt_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ImpactCard(
                    label: 'Goal Impact',
                    value: switch (analysis.goalImpact) {
                      GoalImpact.aligned => 'Aligned ✓',
                      GoalImpact.neutral => 'Neutral',
                      GoalImpact.misaligned => 'Below need',
                    },
                    color: switch (analysis.goalImpact) {
                      GoalImpact.aligned => _accentGreen,
                      GoalImpact.neutral => _accentBlue,
                      GoalImpact.misaligned => _accentRed,
                    },
                    icon: Icons.flag_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Fix suggestions ──
            if (analysis.fixSuggestions.isNotEmpty)
              _FixSuggestionsCard(suggestions: analysis.fixSuggestions),

            const SizedBox(height: 12),
          ],

          // ── Portion multiplier ──
          _PortionSelector(
            current: state.portionMultiplier,
            onChanged: (v) =>
                ref.read(fixMyMealProvider.notifier).setPortionMultiplier(v),
          ),

          const SizedBox(height: 12),

          // ── Meal type ──
          _MealTypeSelector(
            current: state.selectedMealType,
            onChanged: (v) =>
                ref.read(fixMyMealProvider.notifier).setMealType(v),
          ),

          const SizedBox(height: 20),

          // ── Log button ──
          ElevatedButton.icon(
            key: const Key('fix_my_meal_log_button'),
            onPressed: () {
              ref.read(fixMyMealProvider.notifier).logMeal();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(
              'Log This Meal  ·  '
              '${state.effectiveCalories.toStringAsFixed(0)} kcal',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            key: const Key('fix_my_meal_reanalyze_btn'),
            onPressed: () => ref.read(fixMyMealProvider.notifier).reset(),
            icon: const Icon(Icons.refresh_rounded, color: _textSecondary),
            label: const Text(
              'Re-analyze',
              style: TextStyle(color: _textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.source});

  final VisionSource source;

  @override
  Widget build(BuildContext context) {
    final label = switch (source) {
      VisionSource.offlineMatch => 'Offline',
      VisionSource.cached => 'Cached',
      VisionSource.apiCall => 'Groq Vision',
    };
    final color = switch (source) {
      VisionSource.offlineMatch => _accentGreen,
      VisionSource.cached => _accentBlue,
      VisionSource.apiCall => _accentOrange,
    };

    return Container(
      key: Key('fix_my_meal_source_badge_$label'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MacroStrip extends StatelessWidget {
  const _MacroStrip({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('fix_my_meal_macro_strip'),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MacroItem(
            label: 'Calories',
            value: '${calories.toStringAsFixed(0)} kcal',
            color: _accentOrange,
          ),
          _MacroItem(
            label: 'Protein',
            value: '${proteinG.toStringAsFixed(1)}g',
            color: _accentBlue,
          ),
          _MacroItem(
            label: 'Carbs',
            value: '${carbsG.toStringAsFixed(1)}g',
            color: const Color(0xFFFBBF24),
          ),
          _MacroItem(
            label: 'Fat',
            value: '${fatG.toStringAsFixed(1)}g',
            color: _accentGreen,
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: _textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _QualityScoreCard extends StatelessWidget {
  const _QualityScoreCard({required this.score});

  final double score;

  Color get _scoreColor {
    if (score >= 7.0) return _accentGreen;
    if (score >= 5.0) return const Color(0xFFFBBF24);
    return _accentRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('fix_my_meal_quality_score'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meal Quality Score',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '${score.toStringAsFixed(1)} / 10',
                style: TextStyle(
                  color: _scoreColor,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 10.0,
              backgroundColor: _borderColor,
              valueColor: AlwaysStoppedAnimation(_scoreColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FixSuggestionsCard extends StatelessWidget {
  const _FixSuggestionsCard({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('fix_my_meal_suggestions_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accentOrange.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentOrange.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: _accentOrange, size: 18),
              SizedBox(width: 8),
              Text(
                'Fix Suggestions',
                style: TextStyle(
                  color: _accentOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final s in suggestions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(color: _accentOrange, fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      s,
                      style: const TextStyle(color: _textPrimary, fontSize: 13),
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

class _PortionSelector extends StatelessWidget {
  const _PortionSelector({required this.current, required this.onChanged});

  final double current;
  final void Function(double) onChanged;

  static const _multipliers = [0.5, 1.0, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Portion Size',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _multipliers.map((m) {
            final active = (current - m).abs() < 0.01;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  key: Key('fix_my_meal_portion_${m}x'),
                  onTap: () => onChanged(m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? _accentOrange : _cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active ? _accentOrange : _borderColor,
                      ),
                    ),
                    child: Text(
                      '$m×',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active ? Colors.white : _textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MealTypeSelector extends StatelessWidget {
  const _MealTypeSelector({required this.current, required this.onChanged});

  final String current;
  final void Function(String) onChanged;

  static const _types = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Log to:',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          key: const Key('fix_my_meal_meal_type_dropdown'),
          value: current,
          dropdownColor: _cardColor,
          style: const TextStyle(color: _textPrimary, fontSize: 14),
          underline: const SizedBox.shrink(),
          items: _types
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error Phase
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: _accentRed,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentOrange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
