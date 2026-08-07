import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/food_swap_service.dart';

/// §P5-R Indian Food Substitution & Swap Engine Screen
/// Route: /food/smart-swaps
class IndianFoodSwapScreen extends StatefulWidget {
  const IndianFoodSwapScreen({super.key});

  @override
  State<IndianFoodSwapScreen> createState() => _IndianFoodSwapScreenState();
}

class _IndianFoodSwapScreenState extends State<IndianFoodSwapScreen> {
  final _service = const FoodSwapService();
  String _selectedKey = 'samosa_fried';

  late SmartSubstitute _activeSubstitute;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final sub = _service.checkSubstitution(_selectedKey)!;
    setState(() {
      _activeSubstitute = sub;
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
        title: Text('Smart Indian Food Swaps', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Swap Selector GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Craving & Caved Food Selector', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Original Food', style: AppTypography.bodySm),
                      DropdownButton<String>(
                        value: _selectedKey,
                        dropdownColor: AppColors.surface1,
                        items: SeededTargetSwapIndex.registry.entries
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value.originalFoodName, style: AppTypography.labelLg.copyWith(color: AppColors.error)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedKey = val);
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

            // Smart Swap Display Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('High-Adherence Smart Swap', style: AppTypography.h3),
                      const Icon(Icons.swap_horiz, color: AppColors.success, size: 24),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_activeSubstitute.alternativeName, style: AppTypography.h2.copyWith(color: AppColors.success)),
                  const SizedBox(height: AppSpacing.md),

                  // Calorie & Protein Deltas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SwapDeltaBadge(
                        label: 'Calorie Savings',
                        value: '${_activeSubstitute.calorieDelta.round()} kcal',
                        isPositive: false, // negative calories is good!
                      ),
                      _SwapDeltaBadge(
                        label: 'Protein Gain',
                        value: '+${_activeSubstitute.proteinDelta.round()} g',
                        isPositive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Swap Recipe Instructions
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
                        Text('Swap Preparation Instructions:', style: AppTypography.labelLg.copyWith(color: AppColors.teal)),
                        const SizedBox(height: 4),
                        Text(_activeSubstitute.swapInstructions, style: AppTypography.bodySm.copyWith(height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Target Swap Index Overview
            Text('Seeded Target Swap Index:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final entry in SeededTargetSwapIndex.registry.entries)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: entry.key == _selectedKey ? AppColors.surface1 : AppColors.surface0,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: entry.key == _selectedKey ? AppColors.success : AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${entry.value.originalFoodName} ➔ ${entry.value.alternativeName}', style: AppTypography.labelLg),
                        Text(
                          '${entry.value.calorieDelta.round()} kcal · +${entry.value.proteinDelta.round()}g Protein',
                          style: AppTypography.bodySm.copyWith(color: AppColors.teal),
                        ),
                      ],
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
}

class _SwapDeltaBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _SwapDeltaBadge({required this.label, required this.value, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.h2.copyWith(
            color: isPositive ? AppColors.success : AppColors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
