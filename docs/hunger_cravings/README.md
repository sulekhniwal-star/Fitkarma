# Adaptive Hunger & Cravings Engine

## 1. Feature Description
Distinguishes biological hunger from psychological/sleep-deprived hedonic cravings, providing a 15-minute dopamine reset timer and low-calorie-density Indian high-volume satiety food prescriptions (cucumber chaat, sabja mucilage, roasted makhana).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Adaptive Hunger & Cravings Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/hunger_cravings_engine.dart`: Pure Dart diagnostic matrix classifying hunger types (`biological`, `hedonicCraving`, `sleepDeprivedGhrelin`) and providing high-volume Indian satiety prescriptions.
- `lib/features/nutrition/presentation/hunger_cravings_screen.dart`: Interactive diagnostic screen with diagnostic check switches, 15-minute delay countdown timer, and volume food hack cards.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: Sleep duration from `/users/{uid}/dailySleep/{date}`
  - Writes: Optional craving logging under `/users/{uid}/cravingLogs/{logId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic diagnostic decision tree, timer logic, and satiety volume hack database in pure Dart.
- **AI Logic:** None in core hunger & cravings engine.

## 6. Deviations from Spec
- None. Fully adheres to Adaptive Hunger & Cravings Engine specifications.
