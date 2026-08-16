import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/nutrition_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/food_db_repository.dart';
import '../data/food_log_repository.dart';
import '../providers/nutrition_provider.dart';
import '../providers/food_db_provider.dart';

class NutritionLoggerScreen extends ConsumerStatefulWidget {
  const NutritionLoggerScreen({super.key});

  @override
  ConsumerState<NutritionLoggerScreen> createState() => _NutritionLoggerScreenState();
}

class _NutritionLoggerScreenState extends ConsumerState<NutritionLoggerScreen> {
  final _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q == _currentQuery) return;
    setState(() => _currentQuery = q);
  }

  Future<void> _logFood(FoodReferenceItem item, BuildContext ctx) async {
    // Write to Drift first (offline-safe), then sync to Worker
    final logRepo = ref.read(foodLogRepositoryProvider);
    final mealType = _guessMealType();

    await logRepo.logFood(FoodLogEntry(
      foodName: item.foodName,
      calories: item.calories,
      proteinG: item.proteinG,
      carbsG: item.carbsG,
      fatG: item.fatG,
      fiberG: item.fiberG,
      mealType: mealType,
      consumeTime: DateTime.now(),
    ));

    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryEmerald.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${item.foodName} logged ✓',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    // Refresh today's logs
    ref.invalidate(todaysFoodLogsProvider);
  }

  MealType _guessMealType() {
    final hour = DateTime.now().hour;
    if (hour < 10) return MealType.breakfast;
    if (hour < 15) return MealType.lunch;
    if (hour < 18) return MealType.snacks;
    return MealType.dinner;
  }

  @override
  Widget build(BuildContext context) {
    final nutritionState = ref.watch(nutritionProvider);
    final searchResults = _currentQuery.length >= 2
        ? ref.watch(foodSearchProvider(_currentQuery))
        : null;
    final todaysLogs = ref.watch(todaysFoodLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Smart Nutrition Logger', style: AppTypography.titleLarge),
        elevation: 0,
        actions: [
          // Offline indicator
          FutureBuilder<bool>(
            future: _checkOnline(),
            builder: (ctx, snap) {
              final isOnline = snap.data ?? true;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.primaryEmerald : AppColors.warningAmber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: AppTypography.labelSmall.copyWith(
                        color: isOnline ? AppColors.primaryEmerald : AppColors.warningAmber,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Protein Deficit Alert
                    if (nutritionState.isProteinDeficit)
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.warningAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          border: Border.all(color: AppColors.warningAmber),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: AppColors.warningAmber),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Protein Deficit: under 70% of ${nutritionState.targetProtein.round()}g target.',
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.warningAmber),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Macro Summary Card
                    GlassCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Daily Calories', style: AppTypography.titleMedium),
                              Text(
                                '${nutritionState.totalCalories.round()} / ${nutritionState.targetCalories.round()} kcal',
                                style: AppTypography.titleLarge
                                    .copyWith(color: AppColors.primaryCyan),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildMacroProgressBar('Protein', nutritionState.totalProtein,
                              nutritionState.targetProtein, AppColors.primaryEmerald),
                          const SizedBox(height: AppSpacing.sm),
                          _buildMacroProgressBar('Carbs', nutritionState.totalCarbs,
                              250.0, AppColors.warningAmber),
                          const SizedBox(height: AppSpacing.sm),
                          _buildMacroProgressBar(
                              'Fats', nutritionState.totalFat, 65.0, AppColors.infoBlue),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Today's logs summary
                    todaysLogs.when(
                      data: (logs) => logs.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Today — ${logs.length} item${logs.length == 1 ? '' : 's'} logged',
                                    style: AppTypography.titleMedium),
                                const SizedBox(height: AppSpacing.sm),
                                ...logs.take(3).map((log) => Padding(
                                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.circle, size: 6,
                                              color: AppColors.primaryEmerald),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(log.foodName,
                                                style: AppTypography.bodyMedium,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          Text('${log.calories.round()} kcal',
                                              style: AppTypography.labelSmall),
                                        ],
                                      ),
                                    )),
                                if (logs.length > 3)
                                  Text('+ ${logs.length - 3} more',
                                      style: AppTypography.labelSmall
                                          .copyWith(color: AppColors.textSecondary)),
                                const SizedBox(height: AppSpacing.lg),
                              ],
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    // Search Field
                    Text('Search Food Database', style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.glassBgMid,
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: AppTypography.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Type to search… e.g. "dal", "roti", "chicken"',
                          hintStyle: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textSecondary),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.textSecondary),
                          suffixIcon: _currentQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppColors.textSecondary),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _currentQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Search results
            if (_currentQuery.length >= 2 && searchResults != null)
              searchResults.when(
                loading: () => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                              color: AppColors.primaryCyan),
                          const SizedBox(height: AppSpacing.md),
                          Text('Searching food database…',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: GlassCard(
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off, color: AppColors.warningAmber),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Offline — showing local results only',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.warningAmber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                data: (items) => items.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                          child: GlassCard(
                            child: Text(
                              'No results for "$_currentQuery". Try a different spelling.',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) {
                              final item = items[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: _FoodResultCard(
                                  item: item,
                                  onLog: () => _logFood(item, ctx),
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      ),
              )
            else if (_currentQuery.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                  child: Column(
                    children: [
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    color: AppColors.primaryCyan, size: 18),
                                const SizedBox(width: 8),
                                Text('Offline-First Food DB',
                                    style: AppTypography.titleMedium
                                        .copyWith(color: AppColors.primaryCyan)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '1,937+ Indian foods available offline.\n'
                              'Search works without internet — results sync to cloud when online.',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                  child: Text(
                    'Type at least 2 characters to search',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroProgressBar(
      String label, double current, double target, Color color) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMedium),
            Text('${current.round()} / ${target.round()} g',
                style: AppTypography.labelSmall),
          ],
        ),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.bgSecondary,
          color: color,
          minHeight: 6.0,
          borderRadius: BorderRadius.circular(3.0),
        ),
      ],
    );
  }

  Future<bool> _checkOnline() async {
    try {
      final result =
          await InternetAddress.lookup('cloudflare.com').timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

// ── Food Result Card ──────────────────────────────────────────────────────────
class _FoodResultCard extends StatelessWidget {
  final FoodReferenceItem item;
  final VoidCallback onLog;

  const _FoodResultCard({required this.item, required this.onLog});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category color badge
          Container(
            width: 4,
            height: 56,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: _categoryColor(item.category),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.foodName,
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '${item.calories.round()} kcal · P:${item.proteinG}g  C:${item.carbsG}g  F:${item.fatG}g',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (item.category.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(item.category,
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.primaryCyan)),
                  ),
              ],
            ),
          ),
          // Log button
          GestureDetector(
            onTap: onLog,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: AppColors.primaryEmerald, size: 16),
                  const SizedBox(width: 4),
                  Text('Log',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.primaryEmerald)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String category) {
    final c = category.toLowerCase();
    if (c.contains('non-veg') || c.contains('chicken') || c.contains('fish')) {
      return AppColors.warningAmber;
    }
    if (c.contains('high protein') || c.contains('paneer') || c.contains('egg')) {
      return AppColors.primaryEmerald;
    }
    if (c.contains('south indian') || c.contains('north indian')) {
      return AppColors.primaryCyan;
    }
    if (c.contains('sweet') || c.contains('dessert') || c.contains('snack')) {
      return AppColors.infoBlue;
    }
    return AppColors.primaryCyan.withValues(alpha: 0.6);
  }
}
