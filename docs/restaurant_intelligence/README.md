# Indian Restaurant Intelligence (Menu OCR, Chain Presets)

## 1. Feature Description
Provides curated menu items and nutritional profiles for popular Indian restaurant styles and chains (Dhabas, North Indian, Udupi cafes) alongside "Order This, Not That" smart swaps to cut surplus cooking fats and preserve protein when dining out.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Indian Restaurant Intelligence)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/restaurant_intelligence_engine.dart`: Pure Dart data model and catalog defining restaurant chain presets (`RestaurantChainPreset`) and universal dining swap matrices (`SmartFoodSwap`).
- `lib/features/nutrition/presentation/restaurant_intelligence_screen.dart`: Restaurant menu explorer with chain selector chips, "Order This, Not That" comparison cards, and one-tap logging to the daily nutrition plan.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: Seeded offline restaurant database
  - Writes: Logged dishes committed to `/users/{uid}/dailyNutrition/{date}.loggedMeals`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic restaurant menu catalogs, smart swap suggestions, and calorie/protein delta math in pure Dart.
- **AI Logic:** Optional backend OCR line parsing for custom physical menus.

## 6. Deviations from Spec
- None. Fully adheres to Indian Restaurant Intelligence specifications.
