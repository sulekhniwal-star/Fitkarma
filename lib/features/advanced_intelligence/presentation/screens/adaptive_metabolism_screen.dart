import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/adaptive_metabolism_engine.dart';

class AdaptiveMetabolismScreen extends ConsumerStatefulWidget {
  const AdaptiveMetabolismScreen({super.key});

  @override
  ConsumerState<AdaptiveMetabolismScreen> createState() => _AdaptiveMetabolismScreenState();
}

class _AdaptiveMetabolismScreenState extends ConsumerState<AdaptiveMetabolismScreen> {
  final _engine = const AdaptiveMetabolismEngine();
  int _weeksInDeficit = 6;
  final double _weightDelta = -0.1; // Stalling

  @override
  Widget build(BuildContext context) {
    final report = _engine.calculateMetabolicAdaptation(
      id: 'metabolic-1',
      userId: 'user-demo',
      weightKg: 78.0,
      heightCm: 175.0,
      age: 28,
      isMale: true,
      currentIntakeKcal: 1750,
      weightDeltaPast3WeeksKg: _weightDelta,
      weeksInDeficit: _weeksInDeficit,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Adaptive Metabolism OS', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Metabolic Efficiency Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.accentCoral,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ESTIMATED TDEE', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                          Text('${report.estimatedTdee.toInt()} kcal', style: AppTypography.heroMetric.copyWith(fontSize: 32)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          report.plateauStatus.name.toUpperCase(),
                          style: AppTypography.label.copyWith(color: AppColors.accentAmber, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Baseline BMR', '${report.baselineBmr.toInt()} kcal'),
                      _buildMetric('Adaptation Index', '${(report.metabolicAdaptationFactor * 100).toInt()}%'),
                      _buildMetric('Deficit Weeks', '$_weeksInDeficit wks'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Plateau Breaker Strategy Card
            Text('Plateau Breaker Strategy', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              glowColor: AppColors.primaryEmerald,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.primaryEmerald),
                      const SizedBox(width: 8),
                      Text('Prescribed Protocol', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(report.strategyDescription, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(report.strategyDescriptionHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Deficit Progression Slider
            Text('Simulate Weeks in Continuous Deficit', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weeks in Deficit: $_weeksInDeficit', style: AppTypography.h3),
                      Text('Adaptive Slowdown: ${((1.0 - report.metabolicAdaptationFactor) * 100).toStringAsFixed(0)}%', style: AppTypography.label.copyWith(color: AppColors.accentCoral)),
                    ],
                  ),
                  Slider(
                    value: _weeksInDeficit.toDouble(),
                    min: 1,
                    max: 16,
                    divisions: 15,
                    activeColor: AppColors.primaryCyan,
                    onChanged: (val) {
                      setState(() => _weeksInDeficit = val.toInt());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h3.copyWith(color: AppColors.primaryCyan)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
