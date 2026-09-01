# Protein Distribution & Timing Intelligence

## 1. Feature Description
Optimizes Muscle Protein Synthesis (MPS) by tracking 4 timed protein boluses across the day, evaluating leucine thresholds ($\ge 2.2\text{–}2.5\text{g}$), and prescribing peri-workout nutrition protocols with Indian cereal-legume amino acid complementarity guidance.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Protein Distribution & Timing Intelligence)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/protein_timing_engine.dart`: Pure Dart calculation engine for 4-bolus targets, leucine estimation, MPS trigger evaluation, and amino acid pairing rules.
- `lib/features/nutrition/presentation/protein_timing_screen.dart`: Interactive 4-bolus timeline screen featuring MPS status gauges, leucine indicators, and peri-workout timing prescriptions.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic bolus partitioning, leucine threshold math, and amino acid pairing logic in pure Dart.
- **AI Logic:** None in core protein timing engine.

## 6. Deviations from Spec
- None. Fully adheres to Protein Distribution & Timing Intelligence specifications.
