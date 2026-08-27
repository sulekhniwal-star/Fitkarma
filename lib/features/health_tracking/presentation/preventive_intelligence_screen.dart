import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/preventive_intelligence_engine.dart';

class PreventiveIntelligenceScreen extends StatelessWidget {
  final int systolicBp;
  final int diastolicBp;
  final double fastingGlucoseMgDl;
  final double bmi;
  final double rolling7DaySleepDebtHours;
  final double currentHrvMs;
  final double baselineHrvMs;
  final double currentRhrBpm;
  final double baselineRhrBpm;

  const PreventiveIntelligenceScreen({
    super.key,
    this.systolicBp = 122,
    this.diastolicBp = 78,
    this.fastingGlucoseMgDl = 96.0,
    this.bmi = 23.4,
    this.rolling7DaySleepDebtHours = 0.8,
    this.currentHrvMs = 58.0,
    this.baselineHrvMs = 60.0,
    this.currentRhrBpm = 56.0,
    this.baselineRhrBpm = 54.0,
  });

  Color _getTierColor(RiskTier tier) {
    switch (tier) {
      case RiskTier.optimal:
        return AppColors.karmaGreen;
      case RiskTier.moderate:
        return AppColors.focusBlue;
      case RiskTier.elevated:
        return AppColors.energyOrange;
      case RiskTier.high:
        return AppColors.alertRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = PreventiveIntelligenceEngine.evaluatePreventiveHealth(
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      fastingGlucoseMgDl: fastingGlucoseMgDl,
      bmi: bmi,
      rolling7DaySleepDebtHours: rolling7DaySleepDebtHours,
      currentHrvMs: currentHrvMs,
      baselineHrvMs: baselineHrvMs,
      currentRhrBpm: currentRhrBpm,
      baselineRhrBpm: baselineRhrBpm,
    );

    final tierColor = _getTierColor(report.cardiometabolicTier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Preventive Health & Cardiometabolic Risk',
          regionalText: 'निवारक स्वास्थ्य एवं हृदय-मेटाबॉलिक जोखिम',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Cardiometabolic Risk Gauge
              BentoCard(
                hasGlow: true,
                glowColor: tierColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Cardiometabolic Risk Score',
                          regionalText: 'हृदय-मेटाबॉलिक समग्र स्कोर',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            report.cardiometabolicTier.name.toUpperCase(),
                            style: TextStyle(color: tierColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Risk Score',
                          value: '${report.cardiometabolicRiskScore}',
                          unit: '/100',
                          isHero: true,
                          accentColor: tierColor,
                        ),
                        GlowingMetric(
                          label: 'Asian-Indian BMI',
                          value: bmi.toStringAsFixed(1),
                          unit: 'kg/m²',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Autonomic Balance',
                          value: report.autonomicState == AutonomicState.balanced ? 'Optimal' : 'Active',
                          accentColor: AppColors.aiPurple,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      report.clinicalSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Risk Contributors Breakdown Bento Card
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Biomarker Risk Attribution',
                      regionalText: 'बायोमार्कर योगदान कारक',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildContributionRow('Blood Pressure Load', report.bpContribution, 30, AppColors.energyOrange),
                    const SizedBox(height: AppSpacing.sm),
                    _buildContributionRow('Fasting Glycemic Index', report.glucoseContribution, 30, AppColors.focusBlue),
                    const SizedBox(height: AppSpacing.sm),
                    _buildContributionRow('Asian-Indian Adiposity (BMI)', report.bmiContribution, 25, AppColors.aiPurple),
                    const SizedBox(height: AppSpacing.sm),
                    _buildContributionRow('7-Day Sleep Deficit', report.sleepDebtContribution, 15, AppColors.karmaGreen),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Preventive Action Protocols
              const Text(
                'PREVENTIVE ACTION PROTOCOLS (निवारक जीवनशैली योजना)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.preventiveActionProtocols.map(
                (protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: AppColors.karmaGreen, size: 20),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            protocol,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContributionRow(String label, int points, int maxPoints, Color color) {
    final fraction = (points / maxPoints).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            Text('$points / $maxPoints pts', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: fraction,
          backgroundColor: AppColors.surfaceElevated,
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 4,
          borderRadius: AppRadii.radiusSm,
        ),
      ],
    );
  }
}
