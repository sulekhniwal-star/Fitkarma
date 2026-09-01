import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/festival_adaptation_engine.dart';

class FestivalNutritionScreen extends StatefulWidget {
  final int baseCalories;
  final int baseProtein;

  const FestivalNutritionScreen({
    super.key,
    this.baseCalories = 2100,
    this.baseProtein = 135,
  });

  @override
  State<FestivalNutritionScreen> createState() => _FestivalNutritionScreenState();
}

class _FestivalNutritionScreenState extends State<FestivalNutritionScreen> {
  FestivalType _selectedFestival = FestivalType.diwaliHoli;

  @override
  Widget build(BuildContext context) {
    final strategy = FestivalAdaptationEngine.generateStrategy(
      festival: _selectedFestival,
      baseCalories: widget.baseCalories,
      baseProtein: widget.baseProtein,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Festival Nutrition & Vrat Mode',
          regionalText: 'त्यौहार एवं व्रत पोषण अनुकूलन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Festival Selector Horizontal List
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: FestivalType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = FestivalType.values[index];
                    final isSelected = _selectedFestival == f;

                    return ChoiceChip(
                      selected: isSelected,
                      selectedColor: AppColors.gold.withValues(alpha: 0.2),
                      backgroundColor: AppColors.surfaceElevated,
                      side: BorderSide(color: isSelected ? AppColors.gold : AppColors.glassBorder),
                      label: Text(
                        f.name.split('(')[0].trim(),
                        style: TextStyle(
                          color: isSelected ? AppColors.gold : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                      onSelected: (_) => setState(() => _selectedFestival = f),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Hero Adjusted Festival Target Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.gold,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: _selectedFestival.name,
                          regionalText: _selectedFestival.regionalName,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Text(
                            _selectedFestival.isFasting ? 'FASTING PROTOCOL' : 'FEAST PROTOCOL',
                            style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Adjusted Target',
                          value: '${strategy.adjustedTargetCalories}',
                          unit: 'kcal',
                          isHero: true,
                          accentColor: AppColors.gold,
                        ),
                        GlowingMetric(
                          label: 'Calorie Buffer',
                          value: '${_selectedFestival.calorieAllowanceDelta > 0 ? "+${_selectedFestival.calorieAllowanceDelta}" : _selectedFestival.calorieAllowanceDelta}',
                          unit: 'kcal',
                          accentColor: _selectedFestival.calorieAllowanceDelta >= 0 ? AppColors.karmaGreen : AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Protein Anchor',
                          value: '${strategy.adjustedTargetProtein}g',
                          unit: 'target',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      strategy.culturalCoachingNote,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Damage Control Protocols
              const Text(
                'DAMAGE CONTROL PROTOCOL (सुरक्षा एवं संतुलन नियम)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...strategy.damageControlSteps.map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.karmaGreen, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 4. Smart Sweet / Mithai Swaps
              const Text(
                '✨ MITHAI & DISH SMART SWAPS (मिष्ठान एवं व्यंजन विकल्प)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...strategy.sweetSmartSwaps.map((swap) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.swap_horiz_rounded, color: AppColors.focusBlue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            swap,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
