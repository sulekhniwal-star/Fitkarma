# Indian Food Substitution & Swap Engine

## 1. Feature Description
Provides culturally authentic, high-retention dietary substitutions tailored specifically for Indian households across four core optimization vectors:
- **Protein Upgrade**: Converts carb-dense staples to anabolic meals (e.g. Aloo Paratha ➔ Sattu Stuffed Paratha (+9.5g Protein), White Rice ➔ Soya Chunks & Veg Pulao (+13.7g Protein)).
- **Low GI & Fiber Boost**: Blunts postprandial glucose spikes without removing beloved textures (e.g. Butter Naan ➔ Ragi-Besan Missi Roti (-60% GL), Aloo Poha ➔ Sprouted Moong Poha).
- **Caloric Deficit & Fat Cut**: Eliminates deep-fried oils and excess calories (e.g. Fried Samosa ➔ Roasted Spiced Makhana (-355 kcal), Full-Fat Malai Paneer ➔ Low-Fat Cow Milk Paneer (-195 kcal)).
- **Ayurvedic & Gut Synergy**: Pacifies Pitta/Kapha and improves probiotic assimilation (e.g. Sweet Masala Chai ➔ Spiced Mint Buttermilk / Chaas).
- **Delta Impact Metrics & 1-Tap Logging**: Live $\Delta \text{Calories}$, $\Delta \text{Protein}$, $\Delta \text{Fiber}$, and 5-Star taste fidelity match with instant logging into the daily food log.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Indian Food Substitution & Swap Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/food_swap_engine.dart`: Pure Dart deterministic database of culturally verified Indian swaps, delta macro calculations, and taste fidelity scores.
- `lib/features/nutrition/presentation/food_swap_screen.dart`: Interactive Bento UI with category filters, side-by-side before vs. after comparison cards, delta pills, chef preparation tips, and 1-tap food logging.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyNutrition/{date}.loggedMeals`
  - Writes: Updates `/users/{uid}/dailyNutrition/{date}.loggedMeals` on swap application
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic culinary substitution matrix, Atwater macronutrient deltas, and taste fidelity calibration in pure Dart.
- **AI Logic:** None in core substitution engine.

## 6. Deviations from Spec
- None. Fully adheres to Indian Food Substitution & Swap Engine specifications.
