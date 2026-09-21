import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/life_events/domain/services/wedding_transformation_engine.dart';

class WeddingModeScreen extends ConsumerStatefulWidget {
  const WeddingModeScreen({super.key});

  @override
  ConsumerState<WeddingModeScreen> createState() => _WeddingModeScreenState();
}

class _WeddingModeScreenState extends ConsumerState<WeddingModeScreen> {
  final _engine = const WeddingTransformationEngine();
  final double _currentWeight = 76.0;
  final double _targetWeight = 70.0;
  final double _currentWaist = 88.0;
  final double _targetWaist = 80.0;
  final int _weeksOut = 8;

  @override
  Widget build(BuildContext context) {
    final plan = _engine.createWeddingPlan(
      id: 'wedding-plan-1',
      userId: 'user-demo',
      weddingDate: DateTime.now().add(Duration(days: _weeksOut * 7)),
      currentWeightKg: _currentWeight,
      targetWeightKg: _targetWeight,
      currentWaistCm: _currentWaist,
      targetWaistCm: _targetWaist,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Wedding (Shaadi) Mode', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Countdown
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.accentCoral,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${plan.daysRemaining} DAYS TO GO', style: AppTypography.h2.copyWith(color: AppColors.accentCoral)),
                          Text('Garment & Physique Sculpting', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_weeksOut WEEKS OUT',
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem('Current Waist', '${plan.baselineWaistCm.toInt()} cm'),
                      _buildMetricItem('Target Waist', '${plan.targetWaistCm.toInt()} cm'),
                      _buildMetricItem('Delta', '-${(plan.baselineWaistCm - plan.targetWaistCm).toInt()} cm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Phase & Strategy
            Text('Current Phase Protocol', style: AppTypography.h2),
            const SizedBox(height: 12),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.currentPhaseName, style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                  const SizedBox(height: 4),
                  Text(plan.currentPhaseNameHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Text('Weekly Milestones & Actions:', style: AppTypography.h3),
                  const SizedBox(height: 8),
                  ...plan.weeklyMilestones.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: AppColors.primaryEmerald, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(m, style: AppTypography.bodyMedium)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Garment Fit Checkpoints
            Text('Garment Fit & Stage Presence Timeline', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildTimelineCard('Weeks 12-8', 'Metabolic Foundation & Caloric Priming', 'Establish caloric deficit, clean up sugar & alcohol.', _weeksOut >= 8),
            const SizedBox(height: 8),
            _buildTimelineCard('Weeks 7-4', 'Lean Definition & Stage Posture', 'Core & shoulder sculpting for heavy lehenga/sherwani balance.', _weeksOut >= 4 && _weeksOut < 8),
            const SizedBox(height: 8),
            _buildTimelineCard('Weeks 3-1', 'Peak Week & Anti-Bloat Glow', 'Sodium taper, potassium increase, skin radiance protocols.', _weeksOut < 4),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h3.copyWith(color: AppColors.primaryCyan)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTimelineCard(String time, String title, String desc, bool isActive) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      glowColor: isActive ? AppColors.primaryEmerald : null,
      isGlowing: isActive,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isActive ? AppColors.primaryEmerald : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                Text(title, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(desc, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
