# Nutrition Adherence Engine

## 1. Feature Description
Evaluates rolling 7-day nutritional consistency, caloric tolerance bands ($\pm 10\text{–}20\%$), and protein attainment with compassionate anti-guilt coaching and streak armor protections.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Nutrition Adherence Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/nutrition_adherence_engine.dart`: Pure Dart mathematical model calculating composite adherence scores (40% calories, 40% protein, 20% consistency) and managing streak freeze shields.
- `lib/features/nutrition/presentation/nutrition_adherence_screen.dart`: Interactive adherence dashboard screen featuring weekly score cards, streak shields, 7-day variance breakdowns, and compassionate feedback.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: Rolling 7-day records from `/users/{uid}/dailyNutrition/{date}`
  - Writes: Adherence metrics to `/users/{uid}/stats.adherence`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic variance scoring, streak calculation, and shield rules in pure Dart.
- **AI Logic:** None in core adherence calculation engine.

## 6. Deviations from Spec
- None. Fully adheres to Nutrition Adherence Engine specifications.
