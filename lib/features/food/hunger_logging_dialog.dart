/// §P5-L Hunger & Craving Logging UI Prompt / Modal Dialog
///
/// Interactive dialog displaying 1-5 subjective hunger score selector,
/// craving type filter chips (Sweet, Salty, Fatty, Spicy, Late-Night Binge),
/// stress level slider, and real-time pre-emptive snacking alert banner.
library;

import 'package:fitkarma/features/food/adaptive_hunger_controller.dart';
import 'package:fitkarma/features/food/adaptive_hunger_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor       = Color(0xFF161822);
const _surfaceColor  = Color(0xFF202334);
const _accentOrange  = Color(0xFFFF6B35);
const _accentGreen   = Color(0xFF4ADE80);
const _accentRed     = Color(0xFFF87171);
const _accentYellow  = Color(0xFFFBBF24);
const _accentPurple  = Color(0xFFA78BFA);
const _textPrimary   = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor   = Color(0xFF2E324A);

class HungerLoggingDialog extends ConsumerStatefulWidget {
  const HungerLoggingDialog({super.key});

  @override
  ConsumerState<HungerLoggingDialog> createState() => _HungerLoggingDialogState();
}

class _HungerLoggingDialogState extends ConsumerState<HungerLoggingDialog> {
  int _selectedHungerScore = 3; // default Neutral
  CravingType? _selectedCraving;
  double _stressLevel = 2.5;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hungerCravingProvider);
    final notifier = ref.read(hungerCravingProvider.notifier);

    return Dialog(
      backgroundColor: _bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Log Hunger & Craving 🥪',
                    style: TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: _textSecondary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Proactive Intervention Banner ──
              if (state.activeIntervention.shouldTriggerNudge) ...[
                Container(
                  key: const Key('hunger_intervention_banner'),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _accentOrange.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _accentOrange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt_rounded, color: _accentOrange, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            state.activeIntervention.nudgeTitle,
                            style: const TextStyle(
                              color: _accentOrange,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.activeIntervention.nudgeBody,
                        style: const TextStyle(color: _textPrimary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // ── 1 to 5 Hunger Scale Segmented Selector ──
              const Text(
                'Subjective Hunger Level (1 = Stuffed, 5 = Starving)',
                style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final score = index + 1;
                  final isSelected = _selectedHungerScore == score;

                  return GestureDetector(
                    key: Key('hunger_score_chip_$score'),
                    onTap: () => setState(() => _selectedHungerScore = score),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected ? _scoreColor(score) : _surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _scoreColor(score) : _borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$score',
                          style: TextStyle(
                            color: isSelected ? Colors.black : _textPrimary,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  _scoreLabel(_selectedHungerScore),
                  style: TextStyle(
                    color: _scoreColor(_selectedHungerScore),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Craving Type Selector Chips ──
              const Text(
                'Active Craving Type (Optional)',
                style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CravingType.values.map((type) {
                  final isSelected = _selectedCraving == type;
                  return FilterChip(
                    key: Key('craving_chip_${type.name}'),
                    label: Text(_cravingLabel(type)),
                    selected: isSelected,
                    onSelected: (val) => setState(() {
                      _selectedCraving = val ? type : null;
                    }),
                    selectedColor: _accentPurple.withAlpha(40),
                    backgroundColor: _surfaceColor,
                    checkmarkColor: _accentPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? _accentPurple : _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? _accentPurple : _borderColor),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // ── Stress Level Slider ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work / Daily Stress Level',
                    style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${_stressLevel.toStringAsFixed(1)} / 5.0',
                    style: const TextStyle(color: _accentYellow, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ),
              Slider(
                key: const Key('hunger_stress_slider'),
                value: _stressLevel,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                activeColor: _accentYellow,
                inactiveColor: _surfaceColor,
                onChanged: (val) {
                  setState(() => _stressLevel = val);
                  notifier.setStressLevel(val);
                },
              ),

              const SizedBox(height: 16),

              // ── Submit Button ──
              ElevatedButton(
                key: const Key('hunger_submit_btn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  notifier.logHungerAndCraving(
                    hungerScore: _selectedHungerScore,
                    cravingType: _selectedCraving,
                    stressLevel: _stressLevel,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Log Hunger & Save',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _scoreColor(int score) {
    return switch (score) {
      1 => _accentGreen,
      2 => _accentGreen,
      3 => _accentYellow,
      4 => _accentOrange,
      5 => _accentRed,
      _ => _accentYellow,
    };
  }

  String _scoreLabel(int score) {
    return switch (score) {
      1 => '1 - Stuffed / Full 🟢',
      2 => '2 - Satisfied 🟢',
      3 => '3 - Neutral 🟡',
      4 => '4 - Hungry 🟠',
      5 => '5 - Starving 🔴',
      _ => '',
    };
  }

  String _cravingLabel(CravingType type) {
    return switch (type) {
      CravingType.sweet          => 'Sweet 🍫',
      CravingType.salty          => 'Salty 🥨',
      CravingType.fatty          => 'Fatty 🍟',
      CravingType.spicy          => 'Spicy 🌶️',
      CravingType.lateNightBinge => 'Late-Night Binge 🌙',
    };
  }
}
