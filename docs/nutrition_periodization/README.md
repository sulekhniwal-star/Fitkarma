# Nutrition Periodization Engine

## 1. Feature Description
Calculates dynamic 7-day carbohydrate and caloric wave periodization, matching high-carb surplus targets to heavy compound training days, reducing carbs on rest days for insulin sensitivity, and supporting planned refeed days and Indian fasting (Vrat) modes.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Nutrition Periodization Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/nutrition_periodization_engine.dart`: Pure Dart calculation engine for daily carb cycling factors ($4.0\text{g/kg}$ on heavy days vs $1.8\text{g/kg}$ on rest days), caloric offsets ($+250\text{ kcal}$ to $-250\text{ kcal}$), and refeed calibrations.
- `lib/features/nutrition/presentation/nutrition_periodization_screen.dart`: Interactive 7-day periodization planner screen displaying daily macro targets, weekly average metrics, refeed toggles, and Indian Vrat fasting calibrators.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/nutritionPeriodization/config`
  - Fields: `weeklySchedule`, `averageWeeklyCalories`, `isRefeedEnabled`, `isVratModeActive`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic carb cycling math, bodyweight-scaled macro targets, and weekly caloric averages in pure Dart.
- **AI Logic:** None in core periodization engine.

## 6. Deviations from Spec
- None. Fully adheres to Nutrition Periodization Engine specifications.
