# Family Nutrition Integration

## 1. Feature Description
Solves the real-world Indian household cooking challenge where single-pot dishes (handis of dal, kadhais of sabzi, stacks of rotis) are shared across family members with differing nutritional and clinical needs:
- **Single-Pot Recipe Scaler & Macro Decomposer**: Deconstructs multi-portion master dishes into exact per-member calorie, protein, carbohydrate, and fat allocations based on serving katoris taken.
- **Multi-Member Goal Alignment**:
  - *Primary User (Self)*: Caloric deficit / high protein plate strategies.
  - *Spouse / Partner*: Maintenance, lean muscle, and balanced hydration.
  - *Seniors / Parents*: Low Glycemic Index and reduced sodium adaptations (e.g. skimming excessive top-layer tadka oils).
  - *Children / Teens*: Nutrient density, calcium, and healthy growth fats.
- **Batch Cooking Synergy**: Saves 45–60 minutes of separate cooking while keeping each member on their respective nutritional targets.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Family Nutrition Integration)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/family_nutrition_engine.dart`: Pure Dart mathematical engine for pot-to-plate macro decomposition, dynamic yield calculations, and role-based plate calibrations.
- `lib/features/nutrition/presentation/family_nutrition_screen.dart`: Interactive Bento UI with master pot dish presets, real-time katori adjusters, individual decomposed macro badges, and custom plate modification tips.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/familyProfiles/{memberId}`
  - Writes: Optional shared family recipes under `/users/{uid}/familyRecipes/{recipeId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic mathematical ratio partitioning, macronutrient decomposition, and role-based tip generation in pure Dart.
- **AI Logic:** None in core family nutrition decomposition engine.

## 6. Deviations from Spec
- None. Fully adheres to Family Nutrition Integration specifications.
