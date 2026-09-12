import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/services/preventive_intelligence_engine.dart';

class GlucoseTrackingScreen extends StatefulWidget {
  const GlucoseTrackingScreen({super.key});

  @override
  State<GlucoseTrackingScreen> createState() => _GlucoseTrackingScreenState();
}

class _GlucoseTrackingScreenState extends State<GlucoseTrackingScreen> {
  final _glucoseController = TextEditingController(text: '108');
  bool _isFasting = true;
  final _engine = const PreventiveIntelligenceEngine();

  late HbA1cEstimate _hba1cEstimate;
  late ThinFatRiskAssessment _thinFatAssessment;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final val = double.tryParse(_glucoseController.text) ?? 100.0;
    setState(() {
      _hba1cEstimate = _engine.estimateHbA1c(val);
      _thinFatAssessment = _engine.evaluateThinFatPhenotype(
        bmi: 22.1, // Asian Indian normal BMI range
        fastingGlucoseMgDl: _isFasting ? val : null,
        systolicBp: 122,
        restingHeartRate: 72,
      );
    });
  }

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Metabolic & Glucose',
          hindi: 'ग्लूकोज व मेटाबॉलिक स्वास्थ्य',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ADAG HbA1c Estimation Bento Card
            BentoCard(
              isGlowing: true,
              glowColor: _hba1cEstimate.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_hba1cEstimate.estimatedHbA1c}%',
                            style: AppTypography.h1.copyWith(
                              color: _hba1cEstimate.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Estimated HbA1c (ADAG Formula)',
                              style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _hba1cEstimate.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _hba1cEstimate.color),
                        ),
                        child: Text(
                          _hba1cEstimate.glycemicCategory,
                          style: AppTypography.label.copyWith(color: _hba1cEstimate.color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _hba1cEstimate.insight,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Thin-Fat Phenotype Risk Card
            if (_thinFatAssessment.isAtRisk)
              BentoCard(
                isGlowing: true,
                glowColor: AppColors.accentCoral,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.accentCoral, size: 22),
                        const SizedBox(width: 8),
                        Text('Thin-Fat Phenotype Detected',
                            style: AppTypography.h3.copyWith(color: AppColors.accentCoral)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _thinFatAssessment.summary,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _thinFatAssessment.summaryHindi,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Log New Blood Glucose
            Text('Record Glucose Reading', style: AppTypography.h3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassHover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Glucose (mg/dL)', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                        TextField(
                          controller: _glucoseController,
                          keyboardType: TextInputType.number,
                          style: AppTypography.h3,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => _recalculate(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Fasting'),
                          selected: _isFasting,
                          onSelected: (val) {
                            setState(() {
                              _isFasting = true;
                              _recalculate();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Post-Meal'),
                          selected: !_isFasting,
                          onSelected: (val) {
                            setState(() {
                              _isFasting = false;
                              _recalculate();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Indian Low-GI Food Swaps
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, color: AppColors.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text('Glycemic Optimizations (Indian Diet)', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSwapItem('White Rice', 'Ragi / Foxtail Millet (Kangni)', 'Reduces insulin surge by 34%'),
                  _buildSwapItem('Maida Naan/Roti', 'Jowar & Bajra Multi-grain Roti', 'High soluble fiber blunts absorption'),
                  _buildSwapItem('Chai with Sugar', 'Spiced Kadha / Green Tea with Cinnamon', 'Natural insulin-sensitizing polyphenol'),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapItem(String from, String to, String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(from, style: AppTypography.bodySmall.copyWith(color: AppColors.accentCoral, decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, color: AppColors.primaryEmerald, size: 14),
              const SizedBox(width: 6),
              Text(to, style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(benefit, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
