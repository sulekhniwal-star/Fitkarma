import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/body_analytics_models.dart';
import '../../domain/services/body_composition_engine.dart';
import '../../domain/services/visual_comparison_engine.dart';

class BodyAnalyticsScreen extends StatefulWidget {
  final String userId;
  final String gender;
  final double heightCm;

  const BodyAnalyticsScreen({
    super.key,
    this.userId = 'demo-user-001',
    this.gender = 'male',
    this.heightCm = 175.0,
  });

  @override
  State<BodyAnalyticsScreen> createState() => _BodyAnalyticsScreenState();
}

class _BodyAnalyticsScreenState extends State<BodyAnalyticsScreen> {
  final _compositionEngine = const BodyCompositionEngine();
  final _comparisonEngine = const VisualComparisonEngine();

  late BodyCompositionEstimate _currentEstimate;
  late List<ProgressPhotoEntry> _photos;

  @override
  void initState() {
    super.initState();
    _currentEstimate = _compositionEngine.estimateComposition(
      id: 'comp-1',
      userId: widget.userId,
      gender: widget.gender,
      heightCm: widget.heightCm,
      weightKg: 76.5,
      neckCircumferenceCm: 38.0,
      waistCircumferenceCm: 82.0,
      calculatedAt: DateTime.now(),
    );

    _photos = [
      ProgressPhotoEntry(
        id: 'photo-1',
        userId: widget.userId,
        poseType: PhotoPoseType.front,
        localFilePath: 'assets/demo/front_baseline.jpg',
        poseConfidence: 0.95,
        recordedAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      ProgressPhotoEntry(
        id: 'photo-2',
        userId: widget.userId,
        poseType: PhotoPoseType.front,
        localFilePath: 'assets/demo/front_latest.jpg',
        poseConfidence: 0.98,
        recordedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: BilingualLabel(
          english: 'Visual Body & Composition OS',
          hindi: 'शारीरिक संरचना व रूपांतरण',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.straighten_rounded, color: AppColors.primaryCyan),
            tooltip: 'Calculate Body Fat %',
            onPressed: () => _showAnthropometricCalculator(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Body Fat & Lean Mass Bento Card
            _buildCompositionHero(),
            const SizedBox(height: 16),

            // 2. Waist-to-Height Ratio (WHtR) & FFMI Bento Grid
            Row(
              children: [
                Expanded(child: _buildWhtrCard()),
                const SizedBox(width: 12),
                Expanded(child: _buildFfmiCard()),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Indian Health Insight Card
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, color: AppColors.primaryCyan, size: 20),
                      const SizedBox(width: 8),
                      Text('Phenotype & Visceral Insight', style: AppTypography.h3.copyWith(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_currentEstimate.insight, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(_currentEstimate.insightHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryEmerald, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Progress Photo Comparison Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Visual Timeline (60 Days Apart)', style: AppTypography.h3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 12, color: AppColors.primaryCyan),
                      const SizedBox(width: 4),
                      Text('On-Device Encrypted', style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.primaryCyan)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPhotoComparisonCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompositionHero() {
    return BentoCard(
      isGlowing: true,
      glowColor: AppColors.primaryCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESTIMATED BODY FAT', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${_currentEstimate.bodyFatPercent}%', style: AppTypography.heroMetric.copyWith(color: AppColors.primaryCyan, fontSize: 44)),
                      const SizedBox(width: 8),
                      Text('Fitness Tier', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryEmerald),
                ),
                child: Text(
                  '${_currentEstimate.category.name.toUpperCase()} TIER',
                  style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMiniMetric(
                  'Lean Muscle Mass',
                  '${_currentEstimate.leanMassKg} kg',
                  AppColors.primaryEmerald,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniMetric(
                  'Fat Mass',
                  '${_currentEstimate.fatMassKg} kg',
                  AppColors.accentAmber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniMetric(
                  'Total Weight',
                  '${_currentEstimate.totalWeightKg} kg',
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }

  Widget _buildMiniMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildWhtrCard() {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WAIST-TO-HEIGHT (WHtR)', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${_currentEstimate.waistToHeightRatio}', style: AppTypography.h2.copyWith(color: AppColors.primaryEmerald)),
              const SizedBox(width: 4),
              const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primaryEmerald),
            ],
          ),
          const SizedBox(height: 4),
          Text('Ideal (<0.50 ratio)', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
        ],
      ),
    );
  }

  Widget _buildFfmiCard() {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FAT-FREE MASS INDEX', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${_currentEstimate.ffmi}', style: AppTypography.h2.copyWith(color: AppColors.primaryCyan)),
              const SizedBox(width: 4),
              const Icon(Icons.fitness_center, size: 16, color: AppColors.primaryCyan),
            ],
          ),
          const SizedBox(height: 4),
          Text('Above Average Muscularity', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPhotoComparisonCard() {
    final comp = _comparisonEngine.comparePhotos(
      baseline: _photos.first,
      latest: _photos.last,
      baselineWeightKg: 82.0,
      latestWeightKg: 76.5,
      baselineBodyFatPct: 22.0,
      latestBodyFatPct: 16.5,
      baselineWaistCm: 88.0,
      latestWaistCm: 82.0,
    );

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_outline, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 6),
                        Text('Day 1 Baseline', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                        Text('82.0 kg • 22% Fat', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryCyan),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 48, color: AppColors.primaryCyan),
                        const SizedBox(height: 6),
                        Text('Day ${comp.daysApart} Current', style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
                        Text('76.5 kg • 16.5% Fat', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDeltaBadge('Weight', '${comp.weightDeltaKg ?? -5.5} kg', AppColors.primaryEmerald),
              _buildDeltaBadge('Body Fat', '${comp.bodyFatDeltaPct ?? -5.5}%', AppColors.primaryCyan),
              _buildDeltaBadge('Waist', '${comp.waistDeltaCm ?? -6.0} cm', AppColors.primaryEmerald),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeltaBadge(String label, String delta, Color color) {
    return Column(
      children: [
        Text(label, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(delta, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void _showAnthropometricCalculator(BuildContext context) {
    final weightController = TextEditingController(text: '76.5');
    final waistController = TextEditingController(text: '82.0');
    final neckController = TextEditingController(text: '38.0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
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
              Text('Anthropometric Body Composition Test', style: AppTypography.h3),
              const SizedBox(height: 6),
              Text(
                'U.S. Navy standard adapted with Asian-Indian central fat distribution parameters.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: waistController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Waist at Navel (cm)', labelStyle: TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: neckController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Neck Circumference (cm)', labelStyle: TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final w = double.tryParse(weightController.text) ?? 76.5;
                    final waist = double.tryParse(waistController.text) ?? 82.0;
                    final neck = double.tryParse(neckController.text) ?? 38.0;

                    setState(() {
                      _currentEstimate = _compositionEngine.estimateComposition(
                        id: const Uuid().v4(),
                        userId: widget.userId,
                        gender: widget.gender,
                        heightCm: widget.heightCm,
                        weightKg: w,
                        neckCircumferenceCm: neck,
                        waistCircumferenceCm: waist,
                        calculatedAt: DateTime.now(),
                      );
                    });

                    Navigator.pop(ctx);
                  },
                  child: Text('Calculate & Save', style: AppTypography.label.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
