import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/wedding_transformation_provider.dart';

/// §P12-C Wedding Transformation Mode Screen
/// Route: /wedding/dashboard
class WeddingDashboardScreen extends ConsumerWidget {
  const WeddingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wedding = ref.watch(weddingTransformationProvider);

    final phaseName = switch (wedding.currentPhase) {
      WeddingPhase.foundation => 'FOUNDATION BUILDING',
      WeddingPhase.peakShred => 'PEAK SHRED PHASE',
      WeddingPhase.finalTaper => 'FINAL TAPER & GLOW',
    };

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Wedding Prep Dashboard 💍', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wedding Countdown BentoCard
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF831843), Color(0xFF9D174D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D174D).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text('WEDDING COUNTDOWN', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${wedding.daysRemaining} ', style: AppTypography.h1.copyWith(color: AppColors.bg0, fontSize: 42)),
                        Text('Days Left', style: AppTypography.h3.copyWith(color: AppColors.bg0.withValues(alpha: 0.9))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Phase: [$phaseName]',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Specialized Daily Action Checklist
              Text('Specialized Daily Action Checklist', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        activeColor: AppColors.primary,
                        title: Text('Skin Hydration Target (${wedding.hydrationTargetLiters} L)', style: AppTypography.labelLg),
                        subtitle: Text('3.5L water with electrolytes for skin radiance', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        value: wedding.hasSkinNutritionChecked,
                        onChanged: (val) {
                          ref.read(weddingTransformationProvider.notifier).toggleSkinNutrition(val ?? false);
                        },
                      ),
                      const Divider(height: 1),
                      CheckboxListTile(
                        activeColor: AppColors.primary,
                        title: Text('Cortisol Control Check', style: AppTypography.labelLg),
                        subtitle: Text('10-min deep breathing to prevent wedding stress breakouts', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        value: wedding.hasStressChecked,
                        onChanged: (val) {
                          ref.read(weddingTransformationProvider.notifier).toggleStressCheck(val ?? false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Macro Guidelines (Phase-Shifted) BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phase-Shifted Macro Guidelines', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroStat(label: 'Calories', value: '${wedding.calorieTarget.toInt()} kcal'),
                        _MacroStat(label: 'Protein', value: '${wedding.proteinTargetG.toInt()}g'),
                        _MacroStat(label: 'Hydration', value: '${wedding.hydrationTargetLiters}L'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  final String label;
  final String value;

  const _MacroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.h3.copyWith(color: AppColors.primary)),
      ],
    );
  }
}
