
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../application/food_controller.dart';
import '../domain/food_item.dart';

class FoodLoggingScreen extends ConsumerStatefulWidget {
  final String? initialMealType;

  const FoodLoggingScreen({
    super.key,
    this.initialMealType,
  });

  @override
  ConsumerState<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}

class _FoodLoggingScreenState extends ConsumerState<FoodLoggingScreen> {
  final _searchController = TextEditingController();
  String? _selectedMealType;
  String? _selectedCategory;
  FoodItem? _selectedFood;

  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];
  final List<String> _categories = [
    'all',
    'breakfast',
    'lunch',
    'dinner',
    'snack',
    'street_food',
    'sweets',
    'beverages'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.initialMealType ?? 'breakfast';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(foodSearchProvider(
      query: _searchController.text.isNotEmpty ? _searchController.text : null,
      category: _selectedCategory != 'all' ? _selectedCategory : null,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Log Food',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Meal Type Selector
          _buildMealTypeSelector(),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search food (e.g., "roti", "dal", "idli")',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),

                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Category Chips
          _buildCategoryChips(),

          // Search Results
          Expanded(
            child: searchResults.when(
              data: (foods) {
                if (foods.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildFoodList(foods);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _mealTypes.map((type) {
          final isSelected = _selectedMealType == type;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(
                  type.capitalize(),
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                onSelected: (_) {
                  setState(() => _selectedMealType = type);

                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category ||
              (category == 'all' && _selectedCategory == null);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                category.capitalize(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.accent,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              onSelected: (_) {
                setState(() {

                  _selectedCategory = category == 'all' ? null : category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodList(List<FoodItem> foods) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return _FoodItemCard(
          food: food,
          onTap: () => _showAddFoodDialog(food),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No foods found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),

              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),

              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFoodDialog(FoodItem food) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddFoodBottomSheet(
        food: food,
        mealType: _selectedMealType!,
        onAdd: (servings, note) async {
          final success = await ref.read(foodLogControllerProvider.notifier).logFood(
                foodItemId: food.id,
                mealType: _selectedMealType!,
                servings: servings,
                note: note,
              );

          if (success && context.mounted) {
            context.pop();
            context.pop(); // Return to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${food.name} logged successfully! +5 Karma'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      ),
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const _FoodItemCard({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 8),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Food Icon/Image
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),

              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (food.nameHindi != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        food.nameHindi!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),

                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${food.calories.toInt()} kcal • ${food.servingSize}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),

              // Macros
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _MacroBadge('P', food.protein, Colors.orange),
                  const SizedBox(height: 4),
                  _MacroBadge('C', food.carbs, Colors.blue),
                  const SizedBox(height: 4),
                  _MacroBadge('F', food.fats, Colors.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MacroBadge(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Text(
        '$label: ${value.toInt()}g',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AddFoodBottomSheet extends StatefulWidget {
  final FoodItem food;
  final String mealType;
  final Function(double servings, String? note) onAdd;

  const _AddFoodBottomSheet({
    required this.food,
    required this.mealType,
    required this.onAdd,
  });

  @override
  State<_AddFoodBottomSheet> createState() => _AddFoodBottomSheetState();
}

class _AddFoodBottomSheetState extends State<_AddFoodBottomSheet> {
  double _servings = 1;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nutrition = widget.food.calculateNutrition(_servings);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),

              ),
            ),
            const SizedBox(height: 24),

            // Food Name
            Text(
              widget.food.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Adding to ${widget.mealType.capitalize()}',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Servings Selector
            Text(
              'Servings',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),

            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildServingButton(0.5, '½'),
                const SizedBox(width: 8),
                _buildServingButton(1, '1'),
                const SizedBox(width: 8),
                _buildServingButton(1.5, '1½'),
                const SizedBox(width: 8),
                _buildServingButton(2, '2'),
                const SizedBox(width: 8),
                _buildServingButton(3, '3'),
              ],
            ),
            const SizedBox(height: 24),

            // Nutrition Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  _buildNutritionRow(
                    'Calories',
                    '${nutrition['calories']?.toInt()} kcal',
                    AppColors.primary,
                  ),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroColumn(
                          'Protein',
                          '${nutrition['protein']?.toInt()}g',
                          Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildMacroColumn(
                          'Carbs',
                          '${nutrition['carbs']?.toInt()}g',
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildMacroColumn(
                          'Fats',
                          '${nutrition['fats']?.toInt()}g',
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Note
            TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onAdd(_servings, _noteController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Diary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServingButton(double value, String label) {
    final isSelected = _servings == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _servings = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),

        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),

        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Extension for capitalize
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
