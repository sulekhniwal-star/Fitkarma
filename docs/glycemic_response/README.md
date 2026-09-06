# Glycemic Response & Personal Food Scoring

## 1. Feature Description
Simulates postprandial blood glucose excursions and assigns a Personal Food Score (1–10) to Indian meals, calculating Glycemic Load (GL) blunting through fiber buffers, protein co-ingestion, meal sequencing (Salad ➔ Protein ➔ Carbs), and post-meal Shatpawali walks.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Glycemic Response & Personal Food Scoring)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/glycemic_response_engine.dart`: Pure Dart mathematical model calculating raw/buffered Glycemic Load ($\text{GI} \times \text{Carbs} / 100$), buffer multipliers, predicted glucose excursions ($\text{mg/dL}$), and Personal Food Scores ($1.0\text{–}10.0$).
- `lib/features/nutrition/presentation/glycemic_response_screen.dart`: Interactive glycemic simulation screen featuring Personal Food Score gauges, meal sequencing toggles, and applied buffer cards.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
  - Writes: Optional cached food scores under `/users/{uid}/foodScores/{foodId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic Glycemic Load formulas, buffer attenuation math, and excursion models in pure Dart.
- **AI Logic:** None in core glycemic simulation engine.

## 6. Deviations from Spec
- None. Fully adheres to Glycemic Response & Personal Food Scoring specifications.
