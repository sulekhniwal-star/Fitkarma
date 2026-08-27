import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/grocery_optimization_engine.dart';

class GroceryOptimizationScreen extends StatefulWidget {
  final int dailyProteinTarget;

  const GroceryOptimizationScreen({
    super.key,
    this.dailyProteinTarget = 135,
  });

  @override
  State<GroceryOptimizationScreen> createState() => _GroceryOptimizationScreenState();
}

class _GroceryOptimizationScreenState extends State<GroceryOptimizationScreen> {
  late WeeklyGroceryPlan _plan;
  bool _isVegetarian = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  void _loadPlan() {
    _plan = GroceryOptimizationEngine.generateWeeklyGroceryPlan(
      dailyProteinTargetGrams: widget.dailyProteinTarget,
      isVegetarian: _isVegetarian,
    );
  }

  void _toggleItem(int index) {
    setState(() {
      final item = _plan.items[index];
      _plan.items[index] = item.copyWith(isChecked: !item.isChecked);
    });
  }

  void _copyToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('🛒 FitKarma Weekly Indian Grocery List:');
    for (final item in _plan.items) {
      buffer.writeln('• ${item.name} (${item.quantity}) — ₹${item.estimatedPriceInr}');
    }
    buffer.writeln('\nTotal Estimated: ₹${_plan.totalEstimatedCostInr} | Protein Yield: ${_plan.totalProteinYieldGrams}g');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grocery list copied to clipboard for Blinkit / Zepto / Kirana!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Budget Grocery Optimizer',
          regionalText: 'साप्ताहिक बजट एवं किराना योजना',
          alignment: CrossAxisAlignment.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: AppColors.focusBlue),
            tooltip: 'Copy List',
            onPressed: _copyToClipboard,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dietary Preference Filter Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Vegetarian Grocery Only (शाकाहारी)', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  Switch(
                    value: _isVegetarian,
                    activeThumbColor: AppColors.karmaGreen,
                    onChanged: (val) {
                      setState(() {
                        _isVegetarian = val;
                        _loadPlan();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // 2. Hero Weekly Budget & Protein Yield Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.karmaGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: '7-Day Nutrition Budget',
                          regionalText: 'साप्ताहिक पोषण व्यय अनुमान',
                        ),
                        Icon(Icons.savings_rounded, color: AppColors.karmaGreen, size: 20),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Estimated Cost',
                          value: '₹${_plan.totalEstimatedCostInr}',
                          unit: '/week',
                          isHero: true,
                          accentColor: AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Protein Yield',
                          value: '${_plan.totalProteinYieldGrams.round()}g',
                          unit: '7-day total',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Cost / g Protein',
                          value: '₹${_plan.averageCostPerGramProtein}',
                          unit: 'per gram',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. High Protein Efficiency Callout
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, color: AppColors.gold, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Soya Chunks (₹0.21/g P) & Sattu (₹0.48/g P) provide maximum protein density per Rupee.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Interactive Grocery Checklist
              const Text(
                'WEEKLY KIRANA CHECKLIST (किराना खरीदारी सूची)',
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
                itemCount: _plan.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _plan.items[index];

                  return BentoCard(
                    onTap: () => _toggleItem(index),
                    backgroundColor: item.isChecked ? AppColors.surfaceElevated.withValues(alpha: 0.5) : AppColors.surface,
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isChecked,
                          activeColor: AppColors.karmaGreen,
                          onChanged: (_) => _toggleItem(index),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 13,
                                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                  color: item.isChecked ? AppColors.textMuted : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${item.regionalName} • ${item.quantity}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${item.estimatedPriceInr}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.karmaGreen, fontSize: 13),
                            ),
                            Text(
                              '+${item.totalProteinGrams.round()}g P',
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ],
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
