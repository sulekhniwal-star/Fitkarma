import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/services/womens_health_engine.dart';

class WomensHealthStep extends StatefulWidget {
  final bool enableWomensHealth;
  final ValueChanged<bool> onToggleEnable;
  final ValueChanged<CycleProfile?> onProfileChanged;
  final VoidCallback onNext;

  const WomensHealthStep({
    super.key,
    required this.enableWomensHealth,
    required this.onToggleEnable,
    required this.onProfileChanged,
    required this.onNext,
  });

  @override
  State<WomensHealthStep> createState() => _WomensHealthStepState();
}

class _WomensHealthStepState extends State<WomensHealthStep> {
  int _cycleLength = 28;
  int _currentDay = 10;
  bool _hasPcos = false;
  final _engine = const WomensHealthEngine();

  @override
  Widget build(BuildContext context) {
    final profile = widget.enableWomensHealth
        ? _engine.evaluateCycle(
            cycleLengthDays: _cycleLength,
            currentCycleDay: _currentDay,
            hasPCOS: _hasPcos,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: "Women's Advanced Health Layer",
            hindi: 'महिला स्वास्थ्य एवं हार्मोनल संतुलन',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Cycle-aware training intensity, carb periodization, and PCOS insulin calibrations.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                // Enable Toggle Card
                BentoCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const BilingualLabel(
                      english: 'Enable Cycle-Sync Intelligence',
                      hindi: 'हार्मोनल चक्र सिंक्रोनाइज़ेशन चालू करें',
                    ),
                    subtitle: Text(
                      'Adapts workout volume and macros to your menstrual cycle phases.',
                      style: AppTypography.bodySmall,
                    ),
                    value: widget.enableWomensHealth,
                    activeThumbColor: AppColors.accentPurple,
                    onChanged: (val) {
                      widget.onToggleEnable(val);
                      if (val) {
                        widget.onProfileChanged(
                          _engine.evaluateCycle(
                            cycleLengthDays: _cycleLength,
                            currentCycleDay: _currentDay,
                            hasPCOS: _hasPcos,
                          ),
                        );
                      } else {
                        widget.onProfileChanged(null);
                      }
                    },
                  ),
                ),
                if (widget.enableWomensHealth && profile != null) ...[
                  const SizedBox(height: 16),
                  // Current Phase Live Badge
                  BentoCard(
                    isGlowing: true,
                    glowColor: AppColors.accentPurple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Day $_currentDay of $_cycleLength',
                              style: AppTypography.h3.copyWith(color: AppColors.accentPurple),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentPurple.withAlpha(40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                profile.currentPhase.name.toUpperCase(),
                                style: AppTypography.label.copyWith(color: AppColors.accentPurple),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(profile.phaseSummary, style: AppTypography.bodySmall),
                        const SizedBox(height: 4),
                        Text(profile.phaseSummaryHindi, style: AppTypography.bilingualSub),
                        const Divider(height: 20),
                        Text('⚡ ${profile.trainingRecommendation}', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryCyan)),
                        const SizedBox(height: 4),
                        Text('🥗 ${profile.nutritionRecommendation}', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryEmerald)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Cycle Length & Current Day Controls
                  BentoCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BilingualLabel(english: 'Average Cycle Length', hindi: 'मासिक धर्म चक्र की अवधि'),
                            Text('$_cycleLength days', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          ],
                        ),
                        Slider(
                          value: _cycleLength.toDouble(),
                          min: 21,
                          max: 40,
                          activeColor: AppColors.accentPurple,
                          inactiveColor: AppColors.surfaceDark,
                          onChanged: (val) {
                            setState(() => _cycleLength = val.toInt());
                            widget.onProfileChanged(_engine.evaluateCycle(
                              cycleLengthDays: _cycleLength,
                              currentCycleDay: _currentDay,
                              hasPCOS: _hasPcos,
                            ));
                          },
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BilingualLabel(english: 'Current Day in Cycle', hindi: 'चक्र का वर्तमान दिन'),
                            Text('Day $_currentDay', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.accentPurple)),
                          ],
                        ),
                        Slider(
                          value: _currentDay.toDouble(),
                          min: 1,
                          max: _cycleLength.toDouble(),
                          activeColor: AppColors.accentPurple,
                          inactiveColor: AppColors.surfaceDark,
                          onChanged: (val) {
                            setState(() => _currentDay = val.toInt());
                            widget.onProfileChanged(_engine.evaluateCycle(
                              cycleLengthDays: _cycleLength,
                              currentCycleDay: _currentDay,
                              hasPCOS: _hasPcos,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // PCOS Mode Toggle
                  BentoCard(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const BilingualLabel(
                        english: 'PCOS / PCOD Management Mode',
                        hindi: 'पीसीओएस / पीसीओडी मोड',
                      ),
                      subtitle: Text(
                        'Prioritizes low glycemic index Indian meals and insulin sensitivity workouts.',
                        style: AppTypography.bodySmall,
                      ),
                      value: _hasPcos,
                      activeColor: AppColors.accentPurple,
                      onChanged: (val) {
                        setState(() => _hasPcos = val ?? false);
                        widget.onProfileChanged(_engine.evaluateCycle(
                          cycleLengthDays: _cycleLength,
                          currentCycleDay: _currentDay,
                          hasPCOS: _hasPcos,
                        ));
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Continue  •  आगे बढ़ें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
