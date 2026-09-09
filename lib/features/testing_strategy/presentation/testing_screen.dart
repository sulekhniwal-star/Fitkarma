import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/testing_models.dart';
import 'providers/testing_provider.dart';

/// Screen displaying Testing Strategy, Multi-Layer Testing Pyramid,
/// Feature-by-Feature Coverage Metrics, and Automated Test Execution.
class TestingScreen extends ConsumerWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testingProvider);
    final notifier = ref.read(testingProvider.notifier);
    final report = state.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Testing Strategy & Pyramid',
          regionalText: 'परीक्षण रणनीति व कवरेज रिपोर्ट',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: AppColors.karmaGreen),
            tooltip: 'Run All Tests',
            onPressed: state.isRunningAll ? null : () => notifier.runAllTests(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showTestingPhilosophyModal(context),
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

            // 1. Hero Testing Score & Stats Card
            _buildHeroStatsCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Testing Layer Filter Chips
            _buildLayerFilterChips(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Testing Pyramid Visual Architecture
            _buildPyramidArchitectureCard(),
            const SizedBox(height: AppSpacing.md),

            // 4. Feature Test Suites Header & List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BilingualLabel(
                  primaryText: 'Feature Test Suites (${state.filteredSuites.length})',
                  regionalText: 'मॉड्यूल-वार परीक्षण सूची',
                ),
                TextButton(
                  onPressed: () => notifier.selectLayer(null),
                  child: const Text('Show All Layers', style: TextStyle(color: AppColors.focusBlue, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...state.filteredSuites.map(
              (suite) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _buildSuiteCard(suite),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 5. Run Full Suite Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.focusBlue,
                  shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: state.isRunningAll
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.verified, color: Colors.white, size: 18),
                label: Text(
                  state.isRunningAll ? 'Executing 105 Tests...' : 'Execute Full Project Test Suite',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: state.isRunningAll ? null : () => notifier.runAllTests(),
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
          const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.karmaGreen, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatsCard(TestingPyramidReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_outlined, color: AppColors.karmaGreen, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '100% SUITES PASSING',
                      style: TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 10),
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
                  'Runtime: ${report.totalExecutionTimeMs} ms',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
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
                label: 'Passing Tests',
                value: '${report.totalPassedTests}',
                unit: '/ ${report.totalTestsCount}',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              GlowingMetric(
                label: 'Code Coverage',
                value: '${report.overallCoveragePercent}',
                unit: '%',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLayerFilterChips(TestingState state, TestingNotifier notifier) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('All Layers', style: TextStyle(fontSize: 11)),
            selected: state.selectedLayer == null,
            selectedColor: AppColors.focusBlue,
            backgroundColor: AppColors.surfaceElevated,
            labelStyle: TextStyle(
              color: state.selectedLayer == null ? Colors.white : AppColors.textSecondary,
              fontWeight: state.selectedLayer == null ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) => notifier.selectLayer(null),
          ),
          const SizedBox(width: 6),
          ...TestLayer.values.map((layer) {
            final isSelected = state.selectedLayer == layer;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(layer.name.split(' ').first, style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: AppColors.focusBlue,
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => notifier.selectLayer(isSelected ? null : layer),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPyramidArchitectureCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.layers_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Testing Pyramid Architecture & Target Thresholds',
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildPyramidTier('Security Rules & Storage', '100% Target', AppColors.alertRed),
          _buildPyramidTier('Integration & E2E Flows', '80% Target', AppColors.energyOrange),
          _buildPyramidTier('Widget & Bento Component Tests', '85% Target', AppColors.focusBlue),
          _buildPyramidTier('Pure Dart Deterministic Algorithms', '95%+ Target', AppColors.karmaGreen),
        ],
      ),
    );
  }

  Widget _buildPyramidTier(String title, String target, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppRadii.radiusSm,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
            Text(target, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuiteCard(FeatureTestSuite suite) {
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
                        suite.featureName,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        '${suite.passedCount}/${suite.testCount} PASSED',
                        style: const TextStyle(color: AppColors.karmaGreen, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  suite.regionalFeatureName,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${suite.coveragePercent}% Coverage',
                      style: const TextStyle(color: AppColors.focusBlue, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${suite.executionTimeMs} ms • ${suite.layer.name}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTestingPhilosophyModal(BuildContext context) {
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
                primaryText: 'FitKarma Testing Philosophy',
                regionalText: 'परीक्षण पद्धति व गुणवत्ता मानक',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma follows a deterministic testing pyramid: pure Dart algorithms require 95%+ coverage with zero network/cloud dependencies. Widget tests verify responsive Bento layouts, and integration tests validate offline-first synchronization.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understood', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
