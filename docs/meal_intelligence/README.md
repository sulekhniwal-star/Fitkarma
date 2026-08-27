# Smart Indian Meal Intelligence (Offline Seeded Food DB, Local Meal-Quality Scoring)

## 1. Feature Description
Provides a comprehensive offline database of 100+ Indian staple foods, instant local meal-quality scoring (0–100), regional cuisine and dietary filter tags, and an interactive side-by-side food comparison and swap calculator.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Smart Indian Meal Intelligence)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/meal_intelligence_engine.dart`: Pure Dart mathematical model calculating item-level meal quality scores ($0\text{–}100$) based on protein density, fiber ratios, and healthy fat thresholds, alongside comparative food swap deltas ($\Delta\text{Calories}, \Delta\text{Protein}, \Delta\text{Fiber}$).
- `lib/features/nutrition/data/indian_food_database.dart`: Pre-seeded offline catalog of staple Indian foods with bilingual labels and macro breakdowns.
- `lib/features/nutrition/presentation/smart_meal_intelligence_screen.dart`: Food explorer interface with dietary filter chips, instant quality score badges, and side-by-side comparison modal.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: Static offline database embedded in app bundle; user custom foods saved under `/users/{uid}/customFoods/{foodId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic quality scoring algorithms, macro deltas, search filters, and food swap calculations in pure Dart.
- **AI Logic:** None in core food intelligence database.

## 6. Deviations from Spec
- None. Fully adheres to Smart Indian Meal Intelligence specifications.
