import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/hunger_cravings_engine.dart';

class HungerCravingsScreen extends StatefulWidget {
  const HungerCravingsScreen({super.key});

  @override
  State<HungerCravingsScreen> createState() => _HungerCravingsScreenState();
}

class _HungerCravingsScreenState extends State<HungerCravingsScreen> {
  bool _isSudden = true;
  bool _isSpecificCraving = true;
  bool _willingToEatKhichdi = false;
  final double _sleepHours = 5.5;

  Timer? _timer;
  int _secondsRemaining = 900; // 15 minutes
  bool _isTimerActive = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerActive = true;
      _secondsRemaining = 900;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _isTimerActive = false);
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final report = HungerCravingsEngine.diagnoseHunger(
      isSuddenOnset: _isSudden,
      isSpecificFoodCraved: _isSpecificCraving,
      sleepHoursLastNight: _sleepHours,
      willingToEatSimpleDalKhichdi: _willingToEatKhichdi,
    );

    final Color statusColor = report.detectedType == HungerType.biological
        ? AppColors.karmaGreen
        : report.detectedType == HungerType.sleepDeprivedGhrelin
            ? AppColors.aiPurple
            : AppColors.energyOrange;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Adaptive Hunger & Craving Diagnostic',
          regionalText: 'भूख बनाम लालसा निदान एवं समाधान',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Quick Diagnostic Questionnaire
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Craving Diagnostic Check',
                      regionalText: 'त्वरित भूख जांच',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Did the craving hit suddenly?', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      subtitle: const Text('Sudden onset signals dopamine craving', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      value: _isSudden,
                      activeThumbColor: AppColors.energyOrange,
                      onChanged: (val) => setState(() => _isSudden = val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Are you craving a hyper-specific food?', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      subtitle: const Text('e.g. Samosa, Gulab Jamun, Chocolate', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      value: _isSpecificCraving,
                      activeThumbColor: AppColors.energyOrange,
                      onChanged: (val) => setState(() => _isSpecificCraving = val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Would you eat plain boiled eggs or dalia?', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      subtitle: const Text('True hunger accepts simple whole foods', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      value: _willingToEatKhichdi,
                      activeThumbColor: AppColors.karmaGreen,
                      onChanged: (val) => setState(() => _willingToEatKhichdi = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Diagnostic Result Hero Card
              BentoCard(
                hasGlow: true,
                glowColor: statusColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: report.detectedType.name,
                          regionalText: report.detectedType.regionalName,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Text(
                            report.detectedType.isTrueHunger ? 'TRUE HUNGER' : 'FALSE CRAVING',
                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      report.rootCauseAnalysis,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.35),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        'Action: ${report.instantActionStep}',
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 15-Minute Craving Delay Protocol Timer
              if (!report.detectedType.isTrueHunger) ...[
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('15-Minute Dopamine Reset Timer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                          Icon(Icons.timer_outlined, color: AppColors.focusBlue, size: 20),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GlowingMetric(
                        label: 'Time Remaining',
                        value: _formatTimer(_secondsRemaining),
                        isHero: true,
                        accentColor: AppColors.focusBlue,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Drink 400ml water. Over 85% of hedonic cravings vanish after 15 minutes of behavioral delay.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.focusBlue,
                          shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                        ),
                        onPressed: _isTimerActive ? null : _startTimer,
                        child: Text(_isTimerActive ? 'Timer Running...' : 'Start 15-Min Delay', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 4. Indian Satiety Volume Hacks
              const Text(
                'HIGH-VOLUME SATIETY HACKS (पेट भरने वाले कम कैलोरी खाद्य)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...HungerCravingsEngine.indianVolumeHacks.map((hack) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hack.title, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text('${hack.regionalTitle} • ${hack.portion}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 2),
                              Text(hack.satietyMechanism, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.karmaGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Text(
                            '${hack.calories} kcal',
                            style: const TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
