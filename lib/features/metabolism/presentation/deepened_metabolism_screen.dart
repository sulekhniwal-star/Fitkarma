import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/deepened_metabolism_models.dart';
import '../providers/deepened_metabolism_provider.dart';

/// Screen displaying Deepened Adaptive Metabolism Engine, Energy Expenditure Decomposition (BMR+TEF+EAT+NEAT),
/// Ayurvedic Jatharagni Chrono-Nutrition, and Macro-Cycling Refeed Protocols.
class DeepenedMetabolismScreen extends ConsumerWidget {
  const DeepenedMetabolismScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deepenedMetabolismProvider);
    final notifier = ref.read(deepenedMetabolismProvider.notifier);
    final report = state.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Adaptive Metabolism OS',
          regionalText: 'गहन चयापचय व रीफीड चक्र',
        ),
        actions: [
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
            // Success Banner
            if (state.successMessage != null)
              _buildSuccessBanner(state.successMessage!),

            // 1. Hero Dynamic TDEE & Adaptive Thermogenesis Card
            _buildHeroMetabolismCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. 4-Pillar Energy Expenditure Decomposition Card
            _buildDecompositionCard(report.decomposition),
            const SizedBox(height: AppSpacing.md),

            // 3. Macro-Cycling Training vs Rest Day Card
            _buildMacroCyclingCard(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 4. Refeed Protocol & Leptin Reset Card
            if (report.recommendedRefeed != RefeedProtocol.none)
              _buildRefeedCard(state, notifier),
            if (report.recommendedRefeed != RefeedProtocol.none)
              const SizedBox(height: AppSpacing.md),

            // 5. Ayurvedic Jatharagni & Chrono-Nutrition Card
            _buildJatharagniCard(report),
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

  Widget _buildHeroMetabolismCard(DeepenedMetabolismReport report) {
    final base = report.baseProfile;
    final isSuppressed = report.isMetabolicAdaptationSevere;
    final statusColor =
        isSuppressed ? AppColors.alertRed : AppColors.karmaGreen;

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
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSuppressed
                          ? Icons.warning_amber_rounded
                          : Icons.local_fire_department,
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'METABOLIC STATE: ${base.metabolicState.name.toUpperCase()}',
                      style: TextStyle(
                          color: statusColor,
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
                  'Adaptation: ${(base.adaptationFactor * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      color: AppColors.focusBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
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
                label: 'True Dynamic TDEE',
                value: '${base.dynamicTdee.round()}',
                unit: 'kcal',
                accentColor: statusColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Daily Intake:',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                    Text(
                      '${base.targetCalories} kcal / day',
                      style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Resistance Score: ${report.metabolicResistanceScore.toInt()}/100',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.energyOrange, fontSize: 10),
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

  Widget _buildDecompositionCard(EnergyExpenditureDecomposition decomp) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart_outline,
                  color: AppColors.focusBlue, size: 18),
              SizedBox(width: 6),
              Text(
                'Energy Expenditure Decomposition (TDEE)',
                style: TextStyle(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDecompRow('BMR (Basal Metabolic Rate)', decomp.bmrCalories,
              0.65, AppColors.karmaGreen),
          _buildDecompRow('NEAT (Non-Exercise Movement)', decomp.neatCalories,
              0.18, AppColors.focusBlue),
          _buildDecompRow('EAT (Exercise Thermogenesis)', decomp.eatCalories,
              0.12, AppColors.energyOrange),
          _buildDecompRow('TEF (Thermic Effect of Food)', decomp.tefCalories,
              0.05, AppColors.gold),
        ],
      ),
    );
  }

  Widget _buildDecompRow(String title, double kcal, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 11)),
              Text('${kcal.round()} kcal (${(pct * 100).round()}%)',
                  style: TextStyle(
                      color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCyclingCard(
      DeepenedMetabolismState state, DeepenedMetabolismNotifier notifier) {
    final cycling = state.report.macroCycling;
    final isTraining = state.dayType == ActiveDayType.trainingDay;
    final calories =
        isTraining ? cycling.trainingDayCalories : cycling.restDayCalories;
    final protein = isTraining
        ? cycling.trainingDayProteinGrams
        : cycling.restDayProteinGrams;
    final carbs =
        isTraining ? cycling.trainingDayCarbsGrams : cycling.restDayCarbsGrams;
    final fats =
        isTraining ? cycling.trainingDayFatsGrams : cycling.restDayFatsGrams;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sync_alt, color: AppColors.gold, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Macro-Cycling Allocation',
                    style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Training Day',
                        style: TextStyle(fontSize: 10)),
                    selected: isTraining,
                    selectedColor: AppColors.karmaGreen,
                    backgroundColor: AppColors.surfaceElevated,
                    labelStyle: TextStyle(
                        color:
                            isTraining ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.bold),
                    onSelected: (_) =>
                        notifier.setDayType(ActiveDayType.trainingDay),
                  ),
                  const SizedBox(width: 4),
                  ChoiceChip(
                    label:
                        const Text('Rest Day', style: TextStyle(fontSize: 10)),
                    selected: !isTraining,
                    selectedColor: AppColors.focusBlue,
                    backgroundColor: AppColors.surfaceElevated,
                    labelStyle: TextStyle(
                        color: !isTraining
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold),
                    onSelected: (_) =>
                        notifier.setDayType(ActiveDayType.restDay),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isTraining
                ? 'Higher carbohydrates (+35g) to maximize glycogen replenishment and training output.'
                : 'Lower carbohydrates (-35g) and higher healthy fats for fat oxidation on rest days.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroPill('Calories', '$calories', 'kcal', AppColors.gold),
              _buildMacroPill(
                  'Protein', '${protein}g', '1.8g/kg', AppColors.focusBlue),
              _buildMacroPill(
                  'Carbs', '${carbs}g', 'Fuel', AppColors.karmaGreen),
              _buildMacroPill(
                  'Fats', '${fats}g', 'Hormones', AppColors.energyOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(unit,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildRefeedCard(
      DeepenedMetabolismState state, DeepenedMetabolismNotifier notifier) {
    final refeed = state.report.recommendedRefeed;
    final isActive = state.isRefeedActive;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt,
                      color: AppColors.energyOrange, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    refeed.name,
                    style: const TextStyle(
                        color: AppColors.energyOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (isActive ? AppColors.karmaGreen : AppColors.energyOrange)
                          .withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  isActive ? 'REFEED ACTIVE' : 'RECOMMENDED',
                  style: TextStyle(
                      color: isActive
                          ? AppColors.karmaGreen
                          : AppColors.energyOrange,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            refeed.rationale,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textPrimary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive
                    ? AppColors.surfaceElevated
                    : AppColors.energyOrange,
                shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd),
              ),
              onPressed: () => notifier.toggleRefeedMode(),
              child: Text(
                isActive
                    ? 'End Refeed & Return to Deficit'
                    : 'Activate +${refeed.extraCalories} kcal Refeed Window',
                style: TextStyle(
                    color: isActive ? AppColors.textSecondary : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJatharagniCard(DeepenedMetabolismReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                'Ayurvedic Agni: ${report.jatharagniState.name.split('(').first.trim()}',
                style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.circadianAgniMealTip,
            style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary, height: 1.35, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalCircadianAgniMealTip,
            style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary, height: 1.35, fontSize: 10),
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
                primaryText: 'Deepened Adaptive Metabolism Science',
                regionalText: 'गहन चयापचय विज्ञान व कार्यप्रणाली',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma deepens metabolic intelligence by decomposing TDEE into BMR, TEF, EAT, and NEAT. It quantifies Adaptive Thermogenesis down-regulation, triggers structured leptin refeeds, and integrates Ayurvedic Jatharagni chrono-nutrition.',
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
