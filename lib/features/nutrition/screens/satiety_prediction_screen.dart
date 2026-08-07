import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/satiety_prediction_engine.dart';

/// §P5-P Satiety Prediction Engine Screen
/// Route: /food/satiety-prediction
class SatietyPredictionScreen extends StatefulWidget {
  const SatietyPredictionScreen({super.key});

  @override
  State<SatietyPredictionScreen> createState() => _SatietyPredictionScreenState();
}

class _SatietyPredictionScreenState extends State<SatietyPredictionScreen> {
  final _engine = const SatietyPredictionEngine();
  IndianSatietyItem _selectedItem = SeededIndianSatietyTable.items.first;

  late SatietyPredictionResult _result;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final res = _engine.computeForSeededItem(_selectedItem);
    setState(() {
      _result = res;
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
        title: Text('Satiety Prediction Engine', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reference Table Item Selector GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Indian Food Satiety Reference Table', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Item', style: AppTypography.bodySm),
                      DropdownButton<IndianSatietyItem>(
                        value: _selectedItem,
                        dropdownColor: AppColors.surface1,
                        items: SeededIndianSatietyTable.items
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item.name, style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedItem = val);
                            _recalculate();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Satiety Score Result Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: _getScoreColor(_result.satietyScore).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Satiety Index Score', style: AppTypography.h3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getScoreColor(_result.satietyScore).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_result.satietyScore.round()} / 100',
                          style: AppTypography.h2.copyWith(
                            color: _getScoreColor(_result.satietyScore),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Fullness Factor Note
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bg0,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant, color: AppColors.teal, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Primary Fullness Factor: ${_result.fullnessNote}',
                            style: AppTypography.bodySm.copyWith(height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Formula breakdown rows
                  _ScoreFactorRow(label: 'Protein Fullness (+2.8x)', value: '+${_result.proteinContribution} pts'),
                  _ScoreFactorRow(label: 'Fiber Expansion (+4.0x)', value: '+${_result.fiberContribution} pts'),
                  _ScoreFactorRow(label: 'Gastric Volume (+1.2x)', value: '+${_result.volumeContribution} pts'),
                  _ScoreFactorRow(label: 'Processing Penalty (-12.0x)', value: '-${_result.processingPenalty} pts'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Seeded Reference Table Overview
            Text('Seeded Indian Food Comparison:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final item in SeededIndianSatietyTable.items)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item == _selectedItem ? AppColors.surface1 : AppColors.surface0,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: item == _selectedItem ? AppColors.primary : AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: AppTypography.labelLg),
                        Text('${item.calories.round()} kcal · Protein: ${item.proteinG.round()}g', style: AppTypography.bodySm),
                      ],
                    ),
                    Text(
                      'Score: ${_engine.computeForSeededItem(item).satietyScore.round()}/100',
                      style: AppTypography.labelLg.copyWith(
                        color: _getScoreColor(_engine.computeForSeededItem(item).satietyScore),
                      ),
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

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.teal;
    return AppColors.error;
  }
}

class _ScoreFactorRow extends StatelessWidget {
  final String label;
  final String value;

  const _ScoreFactorRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
          Text(value, style: AppTypography.labelLg.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
