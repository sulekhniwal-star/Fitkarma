import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/monthly_report_models.dart';
import 'providers/monthly_report_provider.dart';

/// Screen displaying the Comprehensive Monthly Health & Transformation Report
class MonthlyHealthReportScreen extends ConsumerWidget {
  const MonthlyHealthReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(monthlyReportProvider);
    final gradeColor = Color(report.grade.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: BilingualLabel(
          primaryText: 'Monthly Health Report • ${report.monthTitle}',
          regionalText:
              'मासिक स्वास्थ्य रिपोर्ट • ${report.regionalMonthTitle}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.karmaGreen),
            tooltip: 'Share Doctor Clinical Summary',
            onPressed: () => _showDoctorSummaryModal(context, report),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Monthly Score & Grade Card
            _buildHeroScoreCard(report, gradeColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Executive Clinical Summary Card
            _buildExecutiveSummaryCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Top Monthly Clinical Wins
            const BilingualLabel(
              primaryText: 'Monthly Transformation Wins',
              regionalText: 'मासिक स्वास्थ्य उपलब्धियां व कर्म लाभ',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.topWins.map((win) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildWinCard(win),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. 5-Pillar Monthly Breakdown
            const BilingualLabel(
              primaryText: '5-Pillar Health Scorecard',
              regionalText: 'पंच-स्तंभीय स्वास्थ्य मूल्यांकन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.pillarSummaries.map((pillar) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPillarCard(pillar),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Next 30-Day Clinical Priorities
            const BilingualLabel(
              primaryText: 'Next 30-Day Clinical Focus',
              regionalText: 'आगामी ३० दिनों के प्रमुख स्वास्थ्य लक्ष्य',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.nextMonthPriorities.map((prio) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPriorityCard(prio),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Doctor Consultation Share Card
            _buildDoctorShareBanner(context, report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroScoreCard(MonthlyHealthReport report, Color gradeColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: gradeColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, color: gradeColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Grade ${report.grade.grade} • ${report.grade.label}',
                      style: AppTypography.bodySmall.copyWith(
                        color: gradeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '30-Day Synthesis',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Monthly Health Score',
                value: report.compositeScore.toStringAsFixed(0),
                unit: '/100',
                accentColor: gradeColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biological Age',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${report.biologicalAge.toStringAsFixed(1)} yrs',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${report.biologicalAgeDelta <= 0 ? "" : "+"}${report.biologicalAgeDelta.toStringAsFixed(1)}y)',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pace: ${report.agingPace.toStringAsFixed(2)}x yrs/yr',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryCard(MonthlyHealthReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.focusBlue, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Executive Clinical Summary',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.clinicalExecutiveSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalClinicalExecutiveSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinCard(MonthlyHealthWin win) {
    return BentoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.karmaGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getWinIconData(win.iconName),
              color: AppColors.karmaGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  win.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  win.regionalTitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  win.metricImpact,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: AppColors.gold, size: 12),
                const SizedBox(width: 3),
                Text(
                  '+${win.karmaEarned}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard(MonthlyPillarSummary pillar) {
    final isHigh = pillar.score >= 80;
    final pillarColor = isHigh ? AppColors.karmaGreen : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getPillarIconData(pillar.iconName),
                      color: AppColors.focusBlue, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    pillar.title,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: pillarColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${pillar.score.toInt()}/100 • ${pillar.statusLabel}',
                  style: AppTypography.bodySmall.copyWith(
                    color: pillarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            pillar.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pillar.primaryMetric,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  pillar.monthDelta,
                  style: AppTypography.bodySmall.copyWith(
                    color: pillar.isPositiveDelta
                        ? AppColors.karmaGreen
                        : AppColors.energyOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            pillar.primaryMetricLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: (pillar.score / 100.0).clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(pillarColor),
            minHeight: 4,
            borderRadius: AppRadii.radiusSm,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...pillar.bulletInsights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: AppColors.focusBlue,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        insight,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPriorityCard(NextMonthFocusArea priority) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  priority.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Priority Target',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            priority.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            priority.rationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.flag_outlined,
                    color: AppColors.energyOrange, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Goal: ${priority.targetGoal}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorShareBanner(
      BuildContext context, MonthlyHealthReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_hospital_outlined,
                  color: AppColors.focusBlue, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Doctor-Ready Clinical Summary',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Share an aggregated 30-day clinical briefing with your physician or Ayurvedic doctor.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.radiusMd,
                ),
              ),
              icon: const Icon(Icons.copy_all, color: Colors.white, size: 16),
              label: const Text('View & Copy Clinical Summary',
                  style: TextStyle(color: Colors.white)),
              onPressed: () => _showDoctorSummaryModal(context, report),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPillarIconData(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite;
      case 'bolt':
        return Icons.bolt;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.health_and_safety;
    }
  }

  IconData _getWinIconData(String name) {
    switch (name) {
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'nights_stay':
        return Icons.nights_stay;
      default:
        return Icons.star;
    }
  }

  void _showDoctorSummaryModal(
      BuildContext context, MonthlyHealthReport report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ListView(
                controller: scrollController,
                children: [
                  const BilingualLabel(
                    primaryText: 'Doctor Clinical Briefing (30-Day)',
                    regionalText: 'चिकित्सक परामर्श सारांश',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: AppRadii.radiusMd,
                      border: Border.all(color: AppColors.surfaceElevated),
                    ),
                    child: SelectableText(
                      report.doctorSummaryParagraph,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.focusBlue),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.radiusMd,
                            ),
                          ),
                          icon: const Icon(Icons.copy,
                              size: 16, color: AppColors.focusBlue),
                          label: const Text('Copy to Clipboard',
                              style: TextStyle(color: AppColors.focusBlue)),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: report.doctorSummaryParagraph));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Clinical summary copied to clipboard!'),
                                backgroundColor: AppColors.karmaGreen,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.focusBlue,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.radiusMd,
                            ),
                          ),
                          icon: const Icon(Icons.done,
                              size: 16, color: Colors.white),
                          label: const Text('Close',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
