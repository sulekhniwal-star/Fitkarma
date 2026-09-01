import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/micronutrient_engine.dart';

class MicronutrientIntelligenceScreen extends StatefulWidget {
  final bool isVegetarian;

  const MicronutrientIntelligenceScreen({
    super.key,
    this.isVegetarian = true,
  });

  @override
  State<MicronutrientIntelligenceScreen> createState() => _MicronutrientIntelligenceScreenState();
}

class _MicronutrientIntelligenceScreenState extends State<MicronutrientIntelligenceScreen> {
  late MicronutrientReport _report;

  @override
  void initState() {
    super.initState();
    _report = MicronutrientEngine.evaluateMicronutrients(
      isVegetarian: widget.isVegetarian,
      loggedMealCount: 3,
    );
  }

  Color _getNutrientColor(int pct) {
    if (pct >= 85) return AppColors.karmaGreen;
    if (pct >= 60) return AppColors.focusBlue;
    return AppColors.alertRed;
  }

  @override
  Widget build(BuildContext context) {
    final Color heroColor = _report.overallMicronutrientScore >= 75 ? AppColors.karmaGreen : AppColors.energyOrange;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Micronutrient Intelligence Core',
          regionalText: 'सूक्ष्म पोषक तत्व एवं विटामिन संतुलन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Micronutrient Score Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: heroColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Micronutrient Adequacy Index',
                          regionalText: 'दैनिक सूक्ष्म पोषक समग्र स्कोर',
                        ),
                        Icon(Icons.shield_rounded, color: AppColors.karmaGreen, size: 22),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Adequacy Score',
                          value: '${_report.overallMicronutrientScore}',
                          unit: '/100',
                          isHero: true,
                          accentColor: heroColor,
                        ),
                        GlowingMetric(
                          label: 'Key Trackers',
                          value: '${_report.nutrients.length}',
                          unit: 'essential',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Monitors vital micronutrients prone to deficiency in Indian diets (B12, D3, Iron, Magnesium, Zinc, Calcium) with bioavailability synergy pairing.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Deficiency Risk Warnings
              if (_report.deficiencyWarnings.isNotEmpty) ...[
                BentoCard(
                  backgroundColor: AppColors.alertRed.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppColors.alertRed, size: 18),
                          SizedBox(width: 6),
                          Text('Indian Dietary Watchlist', style: TextStyle(color: AppColors.alertRed, fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ..._report.deficiencyWarnings.map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• $w', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.25)),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 3. Micronutrient RDA Gauges
              const Text(
                'DAILY RDA PROGRESSION (दैनिक आरडीए लक्ष्य)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ..._report.nutrients.map((n) {
                final col = _getNutrientColor(n.percentageOfRda);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.type.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                                Text(n.type.regionalName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${n.currentIntake} / ${n.rda} ${n.type.unit}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: col.withValues(alpha: 0.15),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Text(
                                    '${n.percentageOfRda}%',
                                    style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: (n.percentageOfRda / 100.0).clamp(0.0, 1.0),
                          backgroundColor: AppColors.surfaceElevated,
                          valueColor: AlwaysStoppedAnimation(col),
                          minHeight: 4,
                          borderRadius: AppRadii.radiusSm,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Top Food Sources: ${n.topIndianSource}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 4. Bioavailability Synergy Cards
              const Text(
                'BIOAVAILABILITY SYNERGIES (अवशोषण बढ़ाने के नियम)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ..._report.bioavailabilitySynergies.map((syn) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            syn,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
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
