import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/benchmarking_models.dart';
import 'providers/benchmarking_provider.dart';

class BenchmarkingScreen extends ConsumerStatefulWidget {
  const BenchmarkingScreen({super.key});

  @override
  ConsumerState<BenchmarkingScreen> createState() => _BenchmarkingScreenState();
}

class _BenchmarkingScreenState extends ConsumerState<BenchmarkingScreen> {
  BenchmarkCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(benchmarkingProvider);
    final tierColor = Color(report.overallTier.colorCode);

    final filteredMetrics = _selectedCategory == null
        ? report.allMetrics
        : report.allMetrics.where((m) => m.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Benchmarks & Percentiles',
              style: AppTypography.titleLarge,
            ),
            Text(
              'South Asian Demographic Cohort Calibration',
              style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroPercentileCard(report, tierColor),
            const SizedBox(height: AppSpacing.md),
            _buildStrengthsAndGrowthCard(report),
            const SizedBox(height: AppSpacing.md),
            _buildCategoryFilterRow(),
            const SizedBox(height: AppSpacing.md),
            _buildMetricsList(filteredMetrics),
            const SizedBox(height: AppSpacing.md),
            _buildBellCurveVisualizer(report),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPercentileCard(FitnessBenchmarkReport report, Color tierColor) {
    final topPercent = (100.0 - report.compositeFitnessPercentile).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tierColor.withAlpha(35),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tierColor.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: tierColor.withAlpha(30),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  border: Border.all(color: tierColor),
                ),
                child: Text(
                  report.overallTier.title.toUpperCase(),
                  style: TextStyle(
                    color: tierColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'N = ${report.cohortProfile.cohortSampleSize.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} PEERS',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Top $topPercent%',
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 48,
            ),
          ),
          Text(
            '${report.compositeFitnessPercentile}th COMPOSITE PERCENTILE',
            style: AppTypography.bodySmall.copyWith(
              color: tierColor,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              report.cohortProfile.cohortName,
              style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndGrowthCard(FitnessBenchmarkReport report) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('Superpower', style: AppTypography.metricLabel),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  report.primaryStrengthDomain,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.focusBlue, size: 16),
                    const SizedBox(width: 4),
                    Text('Growth Area', style: AppTypography.metricLabel),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  report.primaryGrowthDomain,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: FilterChip(
              label: const Text('All Domains', style: TextStyle(fontSize: 11)),
              selected: _selectedCategory == null,
              selectedColor: AppColors.focusBlue,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = null;
                  });
                }
              },
            ),
          ),
          ...BenchmarkCategory.values.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                label: Text(cat.label.split('(').first.trim(), style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: AppColors.focusBlue,
                backgroundColor: AppColors.surfaceElevated,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? cat : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMetricsList(List<BenchmarkMetric> metrics) {
    return Column(
      children: metrics.map((metric) => _buildMetricCard(metric)).toList(),
    );
  }

  Widget _buildMetricCard(BenchmarkMetric metric) {
    final metricColor = Color(metric.tier.colorCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.name,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      metric.regionalName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: metricColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: metricColor.withAlpha(120)),
                ),
                child: Text(
                  '${metric.percentile}th %ile',
                  style: TextStyle(
                    color: metricColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Output: ${metric.userValue % 1 == 0 ? metric.userValue.toInt() : metric.userValue} ${metric.unit}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Cohort Avg: ${metric.cohortMean} ${metric.unit.split(' ').first}',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.full),
            child: LinearProgressIndicator(
              value: metric.percentile / 100.0,
              minHeight: 6,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(metricColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.contextualInsight,
            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            metric.regionalContextualInsight,
            style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.focusBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildBellCurveVisualizer(FitnessBenchmarkReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Demographic Cohort Distribution (Gaussian)',
            regionalText: 'जनसांख्यिकीय समूह सामान्य वितरण वक्र',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Calibrated using 48,000+ anonymized South Asian physiological telemetry profiles. Your composite score places you at standard deviation Z = +1.32.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: CustomPaint(
              painter: _BellCurvePainter(percentile: report.compositeFitnessPercentile),
            ),
          ),
        ],
      ),
    );
  }
}

class _BellCurvePainter extends CustomPainter {
  final double percentile;

  _BellCurvePainter({required this.percentile});

  @override
  void paint(Canvas canvas, Size size) {
    final curvePaint = Paint()
      ..color = AppColors.focusBlue.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = AppColors.focusBlue.withAlpha(35)
      ..style = PaintingStyle.fill;

    final markerPaint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2.0;

    final path = Path();
    final fillPath = Path();

    fillPath.moveTo(0, size.height - 10);

    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = (x / size.width) * 6 - 3; // -3 to +3
      final yValue = exp(-0.5 * normalizedX * normalizedX) / sqrt(2 * pi);
      final y = size.height - 15 - (yValue * (size.height - 30) * 2.5);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height - 10);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, curvePaint);

    // Draw user position marker
    final userX = (percentile / 100.0) * size.width;
    canvas.drawLine(Offset(userX, 10), Offset(userX, size.height - 10), markerPaint);

    final dotPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(userX, 15), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _BellCurvePainter oldDelegate) {
    return oldDelegate.percentile != percentile;
  }
}
