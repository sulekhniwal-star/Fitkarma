# Nutrition Reliability Score & Data Confidence Shield

## 1. Feature Description
Evaluates the scientific reliability, completeness, and precision of a user's daily nutrition logs. Rather than treating all logged numbers as ground truth, the **Data Confidence Shield** calculates confidence intervals ($\pm \text{kcal}$, $\pm \text{g protein}$) and dynamically adjusts for hidden preparation fats, late-night memory decay, and missing meal phases.
- **Meal Phase Completeness (35% weight)**: Detects whether all 4 core Indian meal phases (Breakfast, Lunch, Evening Snack, Dinner) are recorded.
- **Portion Measurement Precision (25% weight)**: Evaluates use of standardized Indian units (katoris, grams, pieces) vs. vague generic estimations.
- **Cooking Medium & Tadka Calibration (20% weight)**: Adds an automatic +180 kcal buffer for unrecorded home cooking oils (mustard oil, ghee, tadka/chhonk) unless explicitly logged.
- **Real-Time Logging Timeliness (10% weight)**: Rewards live logging vs. retroactive end-of-day batch entry (which suffers from ~35% recall bias).
- **Macronutrient Energy Coherence (10% weight)**: Reconciles Atwater macro sums ($4P + 4C + 9F$) with logged calories.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Nutrition Reliability Score & Data Confidence Shield)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/nutrition_reliability_engine.dart`: Pure Dart mathematical calculator for reliability scoring, uncertainty margins ($\pm \text{kcal}$, $\pm \text{g protein}$), and Indian cooking medium calibrations.
- `lib/features/nutrition/presentation/nutrition_reliability_screen.dart`: Bento UI displaying the Data Confidence Shield status, uncertainty boundaries, cooking medium toggles, and 5-pillar reliability breakdowns.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
  - Writes: `/users/{uid}/dailyNutrition/{date}.reliabilityReport`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic mathematical calculations, uncertainty interval formulas, and Atwater consistency validations in pure Dart.
- **AI Logic:** None in core reliability engine.

## 6. Deviations from Spec
- None. Fully adheres to Nutrition Reliability Score & Data Confidence Shield specifications.
