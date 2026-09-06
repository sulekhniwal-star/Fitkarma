# Multi-Dimensional Meal Quality Score

## 1. Feature Description
Evaluates Indian meals across five distinct physiological and biochemical dimensions, computing a weighted 0–100 composite quality score and assigning an actionable grade ($A^+$, $A$, $B$, $C$) alongside tailored Indian food optimization suggestions:
1. **Protein Bioavailability & Completeness (30% weight)**: Analyzes total protein grams, DIAAS/PDCAAS completeness, and complementary amino acid pairings (e.g. grain methionine + pulse lysine).
2. **Glycemic & Insulin Load (25% weight)**: Calculates fiber-to-carbohydrate ratios, starch bioavailability, and insulin spike buffering.
3. **Micronutrient Density (20% weight)**: Evaluates bioavailable Iron, B12, Calcium, Folate, and Zinc per 100 kcal.
4. **Satiety & Caloric Density (15% weight)**: Predicts gastric volume distension and satiety hormone activation (GLP-1/PYY).
5. **Anti-Inflammatory & Processing Index (10% weight)**: Checks whole food purity against deep-fried oxidations (palm oil/vanaspati) and refined sugars.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Multi-Dimensional Meal Quality Score)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/multi_dimensional_quality_engine.dart`: Pure Dart mathematical engine for the 5-pillar scoring algorithm, status classification, tier grades, and Indian culinary calibration recommendations.
- `lib/features/nutrition/presentation/multi_dimensional_quality_screen.dart`: Interactive Bento UI showcasing the composite hero score, phase switcher, 5-pillar linear progress indicators, and Ayurvedic Shad-Rasa synergy insights.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
  - Writes: Cached quality reports under `/users/{uid}/dailyNutrition/{date}.qualityReport`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic mathematical calculations, weighted multi-dimensional synthesis, and culinary calibration mappings in pure Dart.
- **AI Logic:** None in core quality scoring engine.

## 6. Deviations from Spec
- None. Fully adheres to Multi-Dimensional Meal Quality Score specifications.
