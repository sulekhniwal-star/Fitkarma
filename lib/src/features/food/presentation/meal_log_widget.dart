import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../application/food_controller.dart';
import '../domain/food_log.dart';

class MealLogWidget extends ConsumerWidget {
  const MealLogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealLogsAsync = ref.watch(mealWiseLogsProvider);

    return mealLogsAsync.when(
      data: (mealLogs) {
        return Column(
          children: [
            _buildMealSection(
              context,
              ref,
              'Breakfast',
              mealLogs['breakfast'] ?? [],
              Icons.wb_sunny,
              Colors.orange,
              () => _navigateToFoodLog(context, 'breakfast'),
            ),
            _buildMealSection(
              context,
              ref,
              'Lunch',
              mealLogs['lunch'] ?? [],
              Icons.restaurant,
              Colors.green,
              () => _navigateToFoodLog(context, 'lunch'),
            ),
            _buildMealSection(
              context,
              ref,
              'Dinner',
              mealLogs['dinner'] ?? [],
              Icons.nightlight_round,
              Colors.purple,
              () => _navigateToFoodLog(context, 'dinner'),
            ),
            _buildMealSection(
              context,
              ref,
              'Snacks',
              mealLogs['snack'] ?? [],
              Icons.cookie,
              Colors.pink,
              () => _navigateToFoodLog(context, 'snack'),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<FoodLog> logs,
    IconData icon,
    Color color,
    VoidCallback onAdd,
  ) {
    final totalCalories = logs.fold<double>(
      0,
      (sum, log) => sum + (log.totalNutrition['calories'] ?? 0),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),

      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),

                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (logs.isNotEmpty)
                        Text(
                          '${totalCalories.toInt()} kcal',
                          style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),

                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),

                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Food Items
          if (logs.isNotEmpty) ...[
            Divider(
              color: Colors.white.withValues(alpha: 0.1),

              height: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return _FoodLogItem(
                  log: log,
                  onDelete: () => _deleteLog(context, ref, log.id),
                );
              },
            ),
          ],

          // Empty State
          if (logs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'No items logged',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),

            ),
        ],
      ),
    );
  }

  Widget _FoodLogItem({
    required FoodLog log,
    required VoidCallback onDelete,
  }) {
    final nutrition = log.totalNutrition;
    final calories = nutrition['calories']?.toInt() ?? 0;

    return Dismissible(
      key: Key(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          log.foodItemName ?? 'Unknown Food',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${log.servings}x serving • $calories kcal',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),

        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (log.note != null && log.note!.isNotEmpty)
              Icon(
                Icons.note,
                size: 16,
                color: Colors.white.withValues(alpha: 0.4),
              ),

            const SizedBox(width: 8),
            Text(
              '$calories',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFoodLog(BuildContext context, String mealType) {
    context.push('/food-log?mealType=$mealType');
  }

  Future<void> _deleteLog(BuildContext context, WidgetRef ref, String logId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Entry?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will remove the food from your log.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(foodLogControllerProvider.notifier).deleteLog(logId);
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}
