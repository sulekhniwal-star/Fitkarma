import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/cicd_models.dart';
import 'providers/cicd_provider.dart';

/// Screen displaying Enterprise CI/CD Pipeline Dashboard, GitHub Actions Status,
/// Automated Test & Linting Stages, and Release Artifact Downloads.
class CicdScreen extends ConsumerWidget {
  const CicdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cicdProvider);
    final notifier = ref.read(cicdProvider.notifier);
    final report = state.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'CI/CD Pipeline & Releases',
          regionalText: 'निरंतर एकीकरण व परिनियोजन',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Trigger Pipeline Run',
            onPressed:
                state.isRunning ? null : () => notifier.triggerPipelineRun(),
          ),
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success / Status Banner
            if (state.successMessage != null)
              _buildSuccessBanner(state.successMessage!),

            // 1. Hero Pipeline Run & Branch Status Bento Card
            _buildHeroStatusCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Release Artifacts Bento Card
            _buildArtifactsCard(context, report),
            const SizedBox(height: AppSpacing.md),

            // 3. Stage-by-Stage Execution Timeline
            const BilingualLabel(
              primaryText: 'Pipeline Execution Stages (7/7)',
              regionalText: 'पाइपलाइन निष्पादन चरण विवरण',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.stages.map((stage) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildStageCard(stage),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Trigger CI/CD Run Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.focusBlue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: state.isRunning
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.rocket_launch,
                        color: Colors.white, size: 18),
                label: Text(
                  state.isRunning
                      ? 'Executing Automated CI/CD Pipeline...'
                      : 'Trigger Automated CI/CD Build Run',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                onPressed: state.isRunning
                    ? null
                    : () => notifier.triggerPipelineRun(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: AppColors.karmaGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatusCard(CicdPipelineReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.karmaGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'PIPELINE ${report.overallStatus.name.toUpperCase()}',
                      style: const TextStyle(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${report.totalDurationSeconds ~/ 60}m ${report.totalDurationSeconds % 60}s Duration',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const GlowingMetric(
                label: 'Build Status',
                value: '100%',
                unit: 'Green',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Branch: ${report.branch} @ ${report.commitHash}',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.focusBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report.commitMessage,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textPrimary, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactsCard(BuildContext context, CicdPipelineReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Compiled Release Artifacts',
                style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildArtifactRow(
            icon: Icons.android,
            title: 'Android App Bundle (.aab)',
            subtitle: 'Signed production bundle • 24.2 MB',
            color: AppColors.karmaGreen,
          ),
          const SizedBox(height: 6),
          _buildArtifactRow(
            icon: Icons.apple,
            title: 'iOS Release Archive (.ipa)',
            subtitle: 'TestFlight & App Store ready',
            color: AppColors.focusBlue,
          ),
          const SizedBox(height: 6),
          _buildArtifactRow(
            icon: Icons.cloud_done,
            title: 'Firebase Functions & Rules',
            subtitle: 'Cloud deployment complete',
            color: AppColors.energyOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 9)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              'COMPILED',
              style: TextStyle(
                  color: color, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard(StageRunRecord stage) {
    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.karmaGreen, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stage.stage.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        '${stage.durationSeconds}s',
                        style: const TextStyle(
                            color: AppColors.focusBlue,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  stage.stage.regionalName,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.logsSummary,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'FitKarma CI/CD Architecture',
                regionalText: 'निरंतर एकीकरण व परिनियोजन वास्तुकला',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma utilizes automated GitHub Actions workflows for continuous integration (formatting, fatal lint checks, 105+ unit tests with coverage, and zero-secrets scanning) and continuous deployment (release AAB, IPA, and Firebase Cloud Functions deployment).',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understood',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
