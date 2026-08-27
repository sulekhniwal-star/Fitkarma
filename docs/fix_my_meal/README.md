# "Fix My Meal" AI Photo Analysis (Vision Cost Optimization)

## 1. Feature Description
Analyzes Indian meal photos or pre-configured dish presets to detect constituent food items, estimate portion sizes and macro totals, and provide 3 targeted "Fix My Meal" calibrations (protein swaps, glycemic buffers, oil reductions).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 "Fix My Meal" AI Photo Analysis)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/vision_meal_models.dart`: Domain entities representing detected food components (`DetectedFoodItem`), actionable optimization suggestions (`FixMyMealSuggestion`), and composite vision analysis results (`VisionMealAnalysisResult`).
- `lib/features/nutrition/data/fix_my_meal_templates.dart`: Pre-seeded deterministic Indian meal templates (North Indian Thali, South Indian Tiffin) with offline fallback data.
- `lib/features/nutrition/presentation/fix_my_meal_screen.dart`: Interactive photo analysis interface with detected foods list, dynamic macro adjustment gauges, and "Fix My Meal" calibration toggle cards.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/visionCache/{imageHash}`
  - Fields: `mealName`, `detectedFoods`, `totalCalories`, `totalProtein`, `totalCarbs`, `totalFats`, `fixMyMealSuggestions`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Image compression, MD5 perceptual cache hashing, offline meal templates, and macro delta calculations in pure Dart.
- **AI Logic:** Multimodal vision parsing of new, uncached photos executed server-side via Cloud Functions.

## 6. Deviations from Spec
- None. Fully adheres to "Fix My Meal" specifications.
