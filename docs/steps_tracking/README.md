# Steps Screen (Auto-detection & Sync)

## 1. Feature Description
Tracks daily step accumulation, calculated walking distance (km), active calorie burn, and hourly cadence distribution, featuring a quick 10-minute Shatpawali (शतपावली) post-meal burst logger.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Steps Screen)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/domain/step_tracker_engine.dart`: Pure Dart calculation engine calculating stride distance based on height, weight-adjusted active calorie expenditure, and hourly cadence distributions.
- `lib/features/health_tracking/presentation/steps_screen.dart`: Interactive step dashboard featuring hero progress rings, distance/calorie metrics, hourly activity bar charts, and "+1,000 steps" post-meal walk action.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.steps`
  - Fields: `totalSteps`, `distanceKm`, `activeCaloriesBurned`, `hourlyCadence`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic stride geometry, active energy expenditure formulas, hourly distribution graphs, and atomic increment sync.
- **AI Logic:** None in core step counting.

## 6. Deviations from Spec
- None. Fully adheres to Steps Screen specifications.
