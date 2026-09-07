# Satiety Prediction Engine

## 1. Feature Description
Predicts postprandial fullness duration (in hours and minutes) and the next expected hunger horizon using a deterministic biochemical satiety model calibrated for Indian diets:
- **Protein Satiety Vector (35% weight)**: Leucine threshold and total protein kinetics triggering Peptide YY (PYY) and Cholecystokinin (CCK) secretion in the duodenum.
- **Dietary Fiber & Viscosity Vector (30% weight)**: Soluble fiber creating a viscous gel layer in the stomach, delaying gastric clearance.
- **Food Volume & Water Matrix (20% weight)**: High-volume, water-rich whole Indian dishes (sabzi, lauki, kheera, chaas) activating mechanical gastric vagal stretch receptors.
- **Glycemic Stability Vector (15% weight)**: Guards against reactive hypoglycemia caused by refined carbohydrates and missing protein buffers.
- **Actionable Satiety Boosters**: Generates high-satiety, low-calorie micro-interventions (e.g. roasted cumin chaas, raw cucumber/salad, low-fat paneer).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Satiety Prediction Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/satiety_prediction_engine.dart`: Pure Dart mathematical engine for fullness timeline modeling, next hunger horizon computation, and satiety booster recommendations.
- `lib/features/nutrition/presentation/satiety_prediction_screen.dart`: Interactive Bento UI displaying predicted fullness duration, hunger horizon clock, physiological vector progress bars, and personalized Indian food boosters.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
  - Writes: Optional local cache in Hive / ephemeral state
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic peptide kinetics mathematical calculations and gastric emptying models in pure Dart.
- **AI Logic:** None in core satiety calculation engine.

## 6. Deviations from Spec
- None. Fully adheres to Satiety Prediction Engine specifications.
