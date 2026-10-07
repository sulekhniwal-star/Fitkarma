import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import '../../domain/models/thali_preset_models.dart';

class ThaliPresetsScreen extends ConsumerStatefulWidget {
  const ThaliPresetsScreen({super.key});

  @override
  ConsumerState<ThaliPresetsScreen> createState() => _ThaliPresetsScreenState();
}

class _ThaliPresetsScreenState extends ConsumerState<ThaliPresetsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'High Protein 💪', 'North India', 'South India', 'Gujarat', 'East India'];

  @override
  Widget build(BuildContext context) {
    final allPresets = IndianThaliRepository.presets;
    final filteredPresets = allPresets.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'High Protein 💪') return p.dietaryBadge.contains('Protein');
      return p.region.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
          p.dietaryBadge.toLowerCase().contains(_selectedFilter.toLowerCase());
    }).toList();

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
          english: 'Indian Thali Presets',
          hindi: 'भारतीय संपूर्ण थाली लॉग',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: AppColors.primaryCyan.withAlpha(50),
                    backgroundColor: AppColors.surfaceCard,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(color: isSelected ? AppColors.primaryCyan : AppColors.borderGlass),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Thali List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPresets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final thali = filteredPresets[index];
                return _buildThaliCard(context, thali);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThaliCard(BuildContext context, ThaliPreset thali) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(thali.title, style: AppTypography.h3),
                    Text(thali.hindiTitle, style: AppTypography.bilingualSub),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryEmerald.withAlpha(80)),
                ),
                child: Text(
                  thali.dietaryBadge,
                  style: AppTypography.label.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            thali.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Total Macros Pill Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlassHover,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroStat('Calories', '${thali.totalCalories.toInt()} kcal', AppColors.accentAmber),
                _buildMacroStat('Protein', '${thali.totalProtein.toStringAsFixed(1)}g', AppColors.primaryCyan),
                _buildMacroStat('Carbs', '${thali.totalCarbs.toStringAsFixed(1)}g', AppColors.primaryEmerald),
                _buildMacroStat('Fats', '${thali.totalFat.toStringAsFixed(1)}g', AppColors.accentCoral),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Item breakdown
          Text('Thali Components (${thali.items.length} items):', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          ...thali.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 14, color: AppColors.primaryCyan),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.name} (${item.portion})',
                        style: AppTypography.bodySmall.copyWith(fontSize: 12),
                      ),
                    ),
                    Text(
                      '${item.protein.toStringAsFixed(0)}g P • ${item.calories.toInt()} cal',
                      style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 16),

          // 1-Tap Log CTA
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _logThali(thali),
              icon: const Icon(Icons.restaurant, color: Colors.black, size: 18),
              label: Text(
                '1-Tap Log This Entire Thali',
                style: AppTypography.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.label.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Future<void> _logThali(ThaliPreset thali) async {
    final repo = ref.read(nutritionRepositoryProvider);
    final userId = ref.read(activeUserIdProvider);

    await repo.logDirectMeal(
      userId: userId,
      name: thali.title,
      mealType: 'Thali / Full Meal',
      calories: thali.totalCalories,
      protein: thali.totalProtein,
      carbs: thali.totalCarbs,
      fat: thali.totalFat,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged ${thali.title} (${thali.totalCalories.toInt()} kcal, ${thali.totalProtein.toStringAsFixed(1)}g Protein)!'),
        backgroundColor: AppColors.primaryEmerald,
      ),
    );
    Navigator.of(context).pop();
  }
}
