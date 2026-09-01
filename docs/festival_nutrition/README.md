# Festival Nutrition Adaptation

## 1. Feature Description
Calibrates daily caloric targets, fasting/feast allocations, damage control steps (Shatpawali walks, salad buffers), and healthier Mithai swaps for major Indian festivals (Diwali, Holi, Navratri Vrat, Ramadan, Eid, and Puja).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Festival Nutrition Adaptation)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/festival_adaptation_engine.dart`: Pure Dart calculation engine providing festival configurations, caloric buffers ($+400\text{ kcal}$ feast to $-150\text{ kcal}$ fasting), damage control protocols, and Mithai smart swaps.
- `lib/features/nutrition/presentation/festival_nutrition_screen.dart`: Interactive festival manager screen featuring preset chips, adjusted caloric targets, feast/fasting badges, and cultural coaching narratives.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/settings.activeFestival`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic festival calorie buffers, fasting protocols, and Mithai swap rules in pure Dart.
- **AI Logic:** None in core festival nutrition engine.

## 6. Deviations from Spec
- None. Fully adheres to Festival Nutrition Adaptation specifications.
