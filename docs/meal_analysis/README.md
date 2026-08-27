# Meal Analysis Pipeline

## 1. Feature Description
Evaluates logged Indian meal compositions across Protein Density ($>30\%$ protein calories), Glycemic/Fiber Balance, and Satiety Indices to generate composite meal quality grades (A+, A, B, C) and deterministic food calibration suggestions.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Meal Analysis Pipeline)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/meal_analysis_engine.dart`: Pure Dart mathematical model calculating Protein-to-Calorie ratio, Fiber-to-Carb ratio, Composite Quality Score ($0.45\text{P} + 0.35\text{F} + 0.20\text{S}$), and Indian food calibration tips.
- `lib/features/nutrition/presentation/meal_analysis_screen.dart`: Multi-dimension meal breakdown screen featuring quality grade badges, macro breakdown pills, and actionable booster cards.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic macronutrient formulas, quality scoring weights, and rule-based Indian food calibration suggestions in pure Dart.
- **AI Logic:** None in core pipeline engine.

## 6. Deviations from Spec
- None. Fully adheres to Meal Analysis Pipeline specifications.
