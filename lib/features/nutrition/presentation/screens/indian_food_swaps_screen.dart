import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/services/indian_food_swap_engine.dart';

class IndianFoodSwapsScreen extends StatelessWidget {
  const IndianFoodSwapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const engine = IndianFoodSwapEngine();
    final swapsByCategory = engine.getSwapsByCategory();

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
          english: 'Smart Indian Food Swaps',
          hindi: 'स्वस्थ भारतीय विकल्प निर्देशिका',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: swapsByCategory.entries.map((entry) {
          final category = entry.key;
          final swaps = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: AppTypography.h3.copyWith(color: AppColors.primaryCyan)),
              const SizedBox(height: 12),
              ...swaps.map((swap) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  swap.originalFoodName,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.accentCoral,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward, color: AppColors.primaryEmerald, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  swap.swapFoodName,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primaryEmerald,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(swap.swapFoodNameHindi, style: AppTypography.bilingualSub),
                          const Divider(color: AppColors.borderGlass, height: 16),
                          Text(swap.reason, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildMetricChip('GI: -${swap.glycemicReductionPercent.toInt()}%', AppColors.primaryEmerald),
                              const SizedBox(width: 8),
                              if (swap.proteinGainPercent > 0)
                                _buildMetricChip('Protein: +${swap.proteinGainPercent.toInt()}%', AppColors.primaryCyan),
                              const SizedBox(width: 8),
                              _buildMetricChip('${swap.calorieDifference.toInt()} kcal', AppColors.accentAmber),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(text, style: AppTypography.label.copyWith(fontSize: 10, color: color)),
    );
  }
}
