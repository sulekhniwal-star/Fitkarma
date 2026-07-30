# Nutrition Feature (`lib/features/nutrition/`)

## Purpose
Manages the Indian food database, 5-dimension meal quality scoring, macro/micro tracking, rule-based protein alerts, and meal vision cache.

## Subdirectories
- **`models/`**: `IndianFoodItem`, `LoggedMeal`, and `MealQualityScore` data models.
- **`providers/`**: Riverpod state management for daily nutrition logging, macro targets, and protein alerts.
- **`screens/`**: Interactive `NutritionLoggerScreen` for searching Indian dishes and logging meals.
