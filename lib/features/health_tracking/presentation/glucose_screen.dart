import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/glucose_engine.dart';

final glucoseListProvider = StateProvider<List<GlucoseReading>>((ref) {
  return [
    GlucoseReading(
      id: 'gl_1',
      glucoseMgDl: 124,
      contextType: GlucoseContextType.postMeal2h,
      correlatedMealName: 'Rajma Chawal + Curd Thali',
      preMealGlucose: 96,
      recordedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    GlucoseReading(
      id: 'gl_2',
      glucoseMgDl: 94,
      contextType: GlucoseContextType.fasting,
      recordedAt: DateTime.now().subtract(const Duration(hours: 9)),
    ),
    GlucoseReading(
      id: 'gl_3',
      glucoseMgDl: 132,
      contextType: GlucoseContextType.postMeal2h,
      correlatedMealName: 'Roti + Paneer Bhurji + Daal',
      preMealGlucose: 102,
      recordedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});

class GlucoseScreen extends ConsumerWidget {
  const GlucoseScreen({super.key});

  Color _getStatusColor(GlucoseStatus status) {
    switch (status) {
      case GlucoseStatus.normal:
        return AppColors.karmaGreen;
      case GlucoseStatus.elevated:
        return AppColors.energyOrange;
      case GlucoseStatus.high:
        return AppColors.alertRed;
      case GlucoseStatus.hypoglycemic:
        return AppColors.focusBlue;
    }
  }

  void _showAddGlucoseDialog(BuildContext context, WidgetRef ref) {
    final glucoseController = TextEditingController(text: '110');
    final mealController = TextEditingController();
    final preMealController = TextEditingController();
    GlucoseContextType selectedType = GlucoseContextType.postMeal2h;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualLabel(
                    primaryText: 'Log Blood Glucose',
                    regionalText: 'ब्लड शुगर (ग्लूकोज) दर्ज करें',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: glucoseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Glucose Level (mg/dL)',
                      hintText: '110',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GlucoseContextType>(
                    initialValue: selectedType,
                    dropdownColor: AppColors.surfaceElevated,
                    decoration: const InputDecoration(labelText: 'Context / Timing'),
                    items: GlucoseContextType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (selectedType == GlucoseContextType.postMeal2h) ...[
                    TextField(
                      controller: mealController,
                      decoration: const InputDecoration(
                        labelText: 'Correlated Meal (e.g. Daal Roti Thali)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: preMealController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pre-Meal Baseline (mg/dL, optional)',
                        hintText: '95',
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                      ),
                      onPressed: () {
                        final val = int.tryParse(glucoseController.text) ?? 110;
                        final preMeal = int.tryParse(preMealController.text);
                        final meal = mealController.text.trim().isNotEmpty ? mealController.text.trim() : null;

                        final newReading = GlucoseReading(
                          id: 'gl_${DateTime.now().millisecondsSinceEpoch}',
                          glucoseMgDl: val,
                          contextType: selectedType,
                          correlatedMealName: meal,
                          preMealGlucose: preMeal,
                          recordedAt: DateTime.now(),
                        );

                        final current = ref.read(glucoseListProvider);
                        ref.read(glucoseListProvider.notifier).state = [newReading, ...current];
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Save Glucose Reading', style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(glucoseListProvider);
    final summary = GlucoseEngine.evaluateReadings(readings);
    final statusColor = _getStatusColor(summary.currentStatus);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Blood Glucose & Glycemic Health',
          regionalText: 'ब्लड ग्लूकोज एवं इन्सुलिन संवेदनशीलता',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.karmaGreen,
        icon: const Icon(Icons.add_rounded, color: AppColors.textInverse),
        label: const Text('Log Glucose', style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w700)),
        onPressed: () => _showAddGlucoseDialog(context, ref),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Estimated HbA1c & Time In Range Hero Card
              BentoCard(
                hasGlow: true,
                glowColor: statusColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Estimated HbA1c & Glycemic Load',
                          regionalText: 'अनुमानित HbA1c एवं ग्लूकोज स्तर',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '${summary.timeInRangePercent.round()}% IN RANGE',
                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Estimated HbA1c',
                          value: '${summary.estimatedHbA1c}%',
                          unit: summary.estimatedHbA1c < 5.7 ? 'Optimal' : 'Elevated',
                          isHero: true,
                          accentColor: summary.estimatedHbA1c < 5.7 ? AppColors.karmaGreen : AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Avg Glucose',
                          value: '${summary.averageGlucoseMgDl.round()}',
                          unit: 'mg/dL',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Time-in-Range',
                          value: '${summary.timeInRangePercent.round()}%',
                          unit: '70-140 mg/dL',
                          accentColor: statusColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Actionable Glycemic Insight
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.monitor_heart_rounded, color: statusColor, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Insulin Sensitivity Insight',
                            regionalText: 'इन्सुलिन एवं खान-पान सलाह',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            summary.glycemicInsight,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Historical Glucose & Meal Excursions
              const Text(
                'GLUCOSE LOGS & MEAL SPIKES (ग्लूकोज एवं भोजन प्रभाव)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: readings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final reading = readings[index];
                  final isSpike = reading.mealExcursion != null && reading.mealExcursion! > 30;

                  return BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${reading.glucoseMgDl} mg/dL',
                                  style: AppTypography.titleSmall.copyWith(
                                    color: reading.glucoseMgDl <= reading.contextType.normalMax ? AppColors.karmaGreen : AppColors.energyOrange,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.surfaceElevated,
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Text(
                                    reading.contextType.name.split(' ')[0],
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            if (reading.correlatedMealName != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '🍽️ ${reading.correlatedMealName}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ],
                        ),
                        if (reading.mealExcursion != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isSpike ? AppColors.alertRed : AppColors.karmaGreen).withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                            ),
                            child: Text(
                              '+${reading.mealExcursion} mg/dL',
                              style: TextStyle(
                                color: isSpike ? AppColors.alertRed : AppColors.karmaGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
