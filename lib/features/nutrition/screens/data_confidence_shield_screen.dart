import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/data_confidence_shield.dart';

/// §P5-O Data Confidence Shield Screen
/// Route: /food/confidence-shield
class DataConfidenceShieldScreen extends StatefulWidget {
  const DataConfidenceShieldScreen({super.key});

  @override
  State<DataConfidenceShieldScreen> createState() => _DataConfidenceShieldScreenState();
}

class _DataConfidenceShieldScreenState extends State<DataConfidenceShieldScreen> {
  final _shield = const DataConfidenceShield();

  int _loggedDaysCount = 3; // Out of 7 days with >=3 meals
  int _proteinMetCount = 3; // Out of 7 days
  int _waterMetCount = 4;   // Out of 7 days

  late ShieldStatus _status;

  @override
  void initState() {
    super.initState();
    _evaluate();
  }

  void _evaluate() {
    final logs = List.generate(7, (i) {
      return DailyReliabilityLog(
        mealsLogged: i < _loggedDaysCount ? 3 : 1,
        wasProteinTargetMet: i < _proteinMetCount,
        wasWaterTargetMet: i < _waterMetCount,
      );
    });

    final status = _shield.evaluateLoggingQuality(
      pastWeekLogs: logs,
      weightPlateauWeeks: 3.0,
    );

    setState(() {
      _status = status;
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
        title: Text('Data Confidence Shield', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shield Lockout / Unlocked Status Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: _status.isLockoutActive ? AppColors.accent.withValues(alpha: 0.12) : AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: _status.isLockoutActive ? AppColors.accent : AppColors.success,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _status.isLockoutActive ? Icons.shield : Icons.verified_user,
                        color: _status.isLockoutActive ? AppColors.accent : AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _status.isLockoutActive ? 'METABOLIC TARGET LOCKOUT ACTIVE' : 'DATA CONFIDENCE HIGH — ADAPTATIONS UNLOCKED',
                          style: AppTypography.labelLg.copyWith(
                            color: _status.isLockoutActive ? AppColors.accent : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '7-Day Rolling Reliability: ${(_status.reliabilityScore * 100).round()}% (Threshold: 70%)',
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _status.alertMessage,
                    style: AppTypography.bodySm.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Reliability Equation Simulators
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rolling 7-Day Log Simulator', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),

                  // Meal Logged Days (40% Weight)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Days with >=3 Meals Logged (40%)', style: AppTypography.bodySm),
                      Text('$_loggedDaysCount / 7 days', style: AppTypography.labelLg),
                    ],
                  ),
                  Slider(
                    value: _loggedDaysCount.toDouble(),
                    min: 0,
                    max: 7,
                    divisions: 7,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _loggedDaysCount = val.round());
                      _evaluate();
                    },
                  ),

                  // Protein Target Met Days (30% Weight)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Protein Consistency Days (30%)', style: AppTypography.bodySm),
                      Text('$_proteinMetCount / 7 days', style: AppTypography.labelLg.copyWith(color: AppColors.teal)),
                    ],
                  ),
                  Slider(
                    value: _proteinMetCount.toDouble(),
                    min: 0,
                    max: 7,
                    divisions: 7,
                    activeColor: AppColors.teal,
                    onChanged: (val) {
                      setState(() => _proteinMetCount = val.round());
                      _evaluate();
                    },
                  ),

                  // Hydration Logged Days (30% Weight)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hydration Logged Days (30%)', style: AppTypography.bodySm),
                      Text('$_waterMetCount / 7 days', style: AppTypography.labelLg.copyWith(color: AppColors.accent)),
                    ],
                  ),
                  Slider(
                    value: _waterMetCount.toDouble(),
                    min: 0,
                    max: 7,
                    divisions: 7,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      setState(() => _waterMetCount = val.round());
                      _evaluate();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
