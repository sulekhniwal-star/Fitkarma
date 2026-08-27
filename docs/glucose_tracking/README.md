# Glucose Screen (Meal Correlation, HbA1c Estimation)

## 1. Feature Description
Tracks blood glucose readings across fasting and postprandial contexts, computes estimated HbA1c ($eA1c = (\text{Avg Glucose} + 46.7) / 28.7$) and Time-in-Range (70–140 mg/dL), and correlates glycemic spikes to specific Indian meals.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Glucose Screen)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/domain/glucose_engine.dart`: Pure Dart mathematical model implementing Nathan et al. estimated HbA1c formula, Time-In-Range (TIR) metrics, and meal excursion calculations ($\Delta\text{Glucose}$).
- `lib/features/health_tracking/presentation/glucose_screen.dart`: Glucose dashboard displaying eHbA1c hero bento card, Time-in-Range percentage badge, meal correlation list, and logging modal.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/glucoseLogs/{logId}`
  - Fields: `glucoseMgDl`, `contextType`, `correlatedMealName`, `preMealGlucose`, `recordedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic eHbA1c formulas, Time-In-Range statistics, and meal excursion arithmetic in pure Dart.
- **AI Logic:** None in core glycemic calculations.

## 6. Deviations from Spec
- None. Fully adheres to Glucose Tracking specifications.
