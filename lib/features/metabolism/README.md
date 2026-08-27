# Adaptive Metabolism Engine (Base Version)

## 1. Feature Description
Calculates the user's dynamic True Daily Energy Expenditure (TDEE) and metabolic adaptation index using 14-day energy balance modeling, dynamically shifting calorie and macronutrient targets.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-G Phase 0, Phase 15)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/features/metabolism/domain/adaptive_metabolism_engine.dart`: Pure Dart deterministic calculator computing Mifflin-St Jeor BMR, dynamic energy balance TDEE ($\Delta\text{weight} \times 7700\text{ kcal} / 14$), metabolic state (`suppressed`, `normal`, `elevated`), and macro distribution (protein/carbs/fats).
- `lib/features/metabolism/data/metabolism_repository.dart`: Firestore repository with offline caching and seamless local calculation fallback.
- `lib/features/metabolism/providers/metabolism_provider.dart`: Riverpod state provider managing the user's adaptive metabolism profile.
- `lib/features/metabolism/presentation/metabolism_card.dart`: Glassmorphism bento card displaying True TDEE, metabolic state badges, and macro distribution pills.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/metabolism/current`
  - Fields: `bmr`, `staticTdee`, `dynamicTdee`, `adaptationFactor`, `metabolicState`, `targetCalories`, `targetProteinGrams`, `targetCarbsGrams`, `targetFatsGrams`, `calculatedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict owner access (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% pure Dart mathematical calculations for BMR, dynamic TDEE, metabolic state thresholds ($<0.92$ suppressed, $>1.08$ elevated), and macronutrient targets.
- **AI Logic:** None in the core calculator; the Health OS Brain reads these deterministic numbers to generate context in daily briefings.

## 6. Deviations from Spec
- None. Fully adheres to the base adaptive metabolism specification.
