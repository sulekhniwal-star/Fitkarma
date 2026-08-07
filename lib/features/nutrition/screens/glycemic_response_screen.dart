import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/glycemic_scoring_engine.dart';

/// §P5-M Glycemic Response & Personal Food Scoring Screen
/// Route: /food/glycemic-scoring
class GlycemicResponseScreen extends StatefulWidget {
  const GlycemicResponseScreen({super.key});

  @override
  State<GlycemicResponseScreen> createState() => _GlycemicResponseScreenState();
}

class _GlycemicResponseScreenState extends State<GlycemicResponseScreen> {
  final _engine = const GlycemicScoringEngine();
  double _baselineGlucose = 95.0; // mg/dL
  double _peakGlucose = 143.0;   // +48 mg/dL spike simulate
  String _selectedFood = 'Ripe Banana';

  late FoodGlycemicScore _scoreResult;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final now = DateTime.now();
    final sampleReadings = [
      CgmReading(timestamp: now.add(const Duration(minutes: 30)), glucoseMgDl: _baselineGlucose + 15.0),
      CgmReading(timestamp: now.add(const Duration(minutes: 60)), glucoseMgDl: _peakGlucose),
      CgmReading(timestamp: now.add(const Duration(minutes: 90)), glucoseMgDl: _peakGlucose - 10.0),
      CgmReading(timestamp: now.add(const Duration(minutes: 120)), glucoseMgDl: _baselineGlucose + 5.0),
    ];

    final result = _engine.computeScore(
      postMealReadings: sampleReadings,
      baselineGlucose: _baselineGlucose,
      foodItemName: _selectedFood,
    );

    setState(() {
      _scoreResult = result;
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
        title: Text('Glycemic Response & Food Score', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CGM Simulation GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Continuous Glucose Monitor (CGM) Map', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),

                  // Food Item Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Food Item Evaluated', style: AppTypography.bodySm),
                      DropdownButton<String>(
                        value: _selectedFood,
                        dropdownColor: AppColors.surface1,
                        items: const [
                          DropdownMenuItem(value: 'Ripe Banana', child: Text('Ripe Banana')),
                          DropdownMenuItem(value: 'White Rice Thali', child: Text('White Rice Thali')),
                          DropdownMenuItem(value: 'Paneer Tikka', child: Text('Paneer Tikka')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedFood = val;
                              if (val == 'Paneer Tikka') {
                                _peakGlucose = 112.0; // +17 mg/dL (Score 10)
                              } else if (val == 'White Rice Thali') {
                                _peakGlucose = 130.0; // +35 mg/dL (Score 7)
                              } else {
                                _peakGlucose = 143.0; // +48 mg/dL (Score 3)
                              }
                            });
                            _recalculate();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Baseline & Peak Sliders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Baseline Pre-Meal Glucose', style: AppTypography.bodySm),
                      Text('${_baselineGlucose.round()} mg/dL', style: AppTypography.labelLg),
                    ],
                  ),
                  Slider(
                    value: _baselineGlucose,
                    min: 70,
                    max: 130,
                    activeColor: AppColors.teal,
                    onChanged: (val) {
                      setState(() => _baselineGlucose = val);
                      _recalculate();
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Peak Post-Meal Glucose (90 min)', style: AppTypography.bodySm),
                      Text('${_peakGlucose.round()} mg/dL', style: AppTypography.labelLg.copyWith(color: AppColors.accent)),
                    ],
                  ),
                  Slider(
                    value: _peakGlucose,
                    min: 90,
                    max: 200,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      setState(() => _peakGlucose = val);
                      _recalculate();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Personal Food Score Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: _getScoreColor(_scoreResult.score).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Personal Food Score', style: AppTypography.h3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getScoreColor(_scoreResult.score).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_scoreResult.score.round()}/10',
                          style: AppTypography.h2.copyWith(color: _getScoreColor(_scoreResult.score)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sugar Spike Delta: +${_scoreResult.glucoseDelta.round()} mg/dL',
                    style: AppTypography.labelLg.copyWith(color: _getScoreColor(_scoreResult.score)),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Mitigation Recommendation Alert
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.bg0,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Insulin Spike Mitigation Prompt:', style: AppTypography.labelLg.copyWith(color: AppColors.accent)),
                        const SizedBox(height: 4),
                        Text(_scoreResult.recommendation, style: AppTypography.bodySm.copyWith(height: 1.4)),
                      ],
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
    if (score >= 9.0) return AppColors.success;
    if (score >= 6.0) return AppColors.teal;
    return AppColors.error;
  }
}
