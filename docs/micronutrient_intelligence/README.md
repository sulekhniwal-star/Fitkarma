# Micronutrient Intelligence Core

## 1. Feature Description
Monitors essential micronutrients prone to deficiency in Indian diets (Vitamin B12, D3, Elemental Iron, Magnesium, Zinc, Calcium), tracking daily RDA percentages, deficiency warnings, and bioavailability synergies (e.g. Vitamin C + Iron absorption boosts).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Micronutrient Intelligence Core)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/micronutrient_engine.dart`: Pure Dart calculation engine determining RDA attainment percentages, Indian dietary deficiency flags, and nutrient synergy rules.
- `lib/features/nutrition/presentation/micronutrient_intelligence_screen.dart`: Micronutrient dashboard screen featuring overall adequacy scores, nutrient progress indicators, deficiency watchlists, and Indian food source guides.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: User profile diet (`/users/{uid}`) and logged meals (`/users/{uid}/dailyNutrition/{date}`)
  - Writes: Aggregated micronutrient score under `/users/{uid}/dailyNutrition/{date}.micronutrientScore`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic RDA scoring formulas, absorption synergy logic, and Indian food mappings in pure Dart.
- **AI Logic:** None in core micronutrient engine.

## 6. Deviations from Spec
- None. Fully adheres to Micronutrient Intelligence Core specifications.
