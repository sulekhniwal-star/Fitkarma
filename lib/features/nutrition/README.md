# Phase 5 — Smart Indian Nutrition & Food Intelligence

## Overview
Phase 5 implements FitKarma's comprehensive **Smart Indian Nutrition Operating System**, engineered specifically for regional Indian culinary traditions, cultural fasting protocols (Navratri, Ekadashi, Ramadan), high-carb staple substitutions, and localized budget grocery optimization.

---

## Key Architecture & Components

### 1. Domain Models (`lib/features/nutrition/domain/models/nutrition_models.dart`)
- `FoodItem`: Nutritional profile containing standard Indian serving units (`1 Katori`, `1 Roti`, `1 Piece`, `1 Cup`), macronutrients, micronutrients (Iron, Calcium, B12), and Glycemic Index.
- `LoggedMeal`: User-logged meal with meal type, individual components, meal quality score, and vision confidence.
- `MealQualityScore`: Multi-dimensional score (0–100) evaluating protein sufficiency, refined carb ratio, and prebiotic fiber density.
- `FoodSwap`: Curated Indian replacement catalog with percentage reduction in glycemic index and protein gains.
- `GroceryItem`: Indian ingredient price benchmark with local and quick-commerce estimations.

### 2. Deterministic Intelligence Engines
- **`IndianNutritionEngine`**: Contains a pre-seeded offline catalog of 50+ core regional Indian foods across North, South, West, East, and Pan-India. Performs deterministic component-level macronutrient and glycemic load aggregation.
- **`MealQualityEngine`**: Calculates multi-dimensional meal health score and predicts Satiety Duration in hours based on protein/fiber gastric emptying kinetics.
- **`IndianFoodSwapEngine`**: Provides intelligent substitutions for high glycemic Indian staples:
  - Steamed White Rice (GI 73) -> Ragi Mudde / Foxtail Millet (GI 44, -39.7% GI)
  - Maida Butter Naan -> Jowar & Bajra Bhakri (-120 kcal, +22% protein)
  - Fried Samosa -> Air-popped Roasted Makhana (-145 kcal, -51% GI)
  - Haldiram Bhujia -> Roasted Black Chana (+140% protein, -62% GI)
  - Sweetened Milk Chai -> Cinnamon Spiced Kadha (natural insulin sensitizer)
- **`FestivalNutritionEngine`**: Custom fasting protocols for Navratri (Kuttu/Singhara, Sendha namak), Ekadashi (grain-free), Ramadan (Suhoor/Iftar timing), Karwa Chauth (Sargi/Parana), and Diwali feasts.

### 3. Local-First Persistence & Outbox Synchronization (`NutritionRepository`)
- Drift tables: `LocalRecipes` (pre-seeded Indian database), `LocalMeals` (user meal logs), and `LocalGroceryItems`.
- Immediate offline write to SQLite and queued mutation to `PendingMutations` outbox for Supabase synchronization.

### 4. Presentation Layer
- `FoodHomeScreen`: Daily macro progress rings, AI Fix My Meal banner, and Thali timeline.
- `MealLoggerScreen`: Searchable 500+ Indian food database with portion unit adjusters.
- `FixMyMealScreen`: AI camera scanner simulation with instant high-protein plate transformation.
- `IndianFoodSwapsScreen`: Interactive Indian food replacement directory.
- `GroceryOptimizerScreen`: Weekly meal budget planner with quick-commerce price optimizer.

---

## Verification & Testing
- Automated unit test suite: `test/nutrition_test.dart` (Search matching, Macro aggregation, Meal quality scoring, Satiety duration, Swaps, Fasting protocols, Drift repository).
- Verified with `flutter test` and `flutter analyze`.
