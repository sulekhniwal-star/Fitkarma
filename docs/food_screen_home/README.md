# Food Screen Home

## 1. Feature Description
Serves as the central Smart Indian Nutrition hub featuring a live caloric/macro budget hero bento card with concentric Activity Rings, 4-phase meal timing split (Breakfast, Lunch, Evening Snack, Dinner), pre-seeded 100+ Indian staple food database, and interactive logging.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Food Screen Home)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/nutrition_models.dart`: Domain entities for food items, 4-phase meal schedules, and logged meal entries.
- `lib/features/nutrition/data/indian_food_database.dart`: Pre-seeded offline database of staple Indian foods with calories, protein, carbs, fats, fiber, and regional names.
- `lib/features/nutrition/providers/nutrition_provider.dart`: Riverpod StateNotifier tracking daily calories, macronutrient progression, remaining budgets, and logged meals.
- `lib/features/nutrition/presentation/food_screen_home.dart`: Main nutrition dashboard with concentric activity rings, macro bars, 4 meal slots, and search bottom sheet.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyNutrition/{date}`
  - Fields: `targetCalories`, `targetProtein`, `consumedCalories`, `consumedProtein`, `loggedMeals`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic macro sums, remaining calorie formulas, Activity Ring proportions, and offline Indian food lookups in pure Dart.
- **AI Logic:** None in core food home screen; AI photo logging is handled by the downstream "Fix My Meal" vision layer.

## 6. Deviations from Spec
- None. Fully adheres to Food Screen Home specifications.
