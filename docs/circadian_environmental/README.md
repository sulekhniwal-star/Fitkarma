# Recovery Operating System — Circadian & Environmental Intelligence

## 1. Feature Description
Synchronizes the user's daily recovery, training windows, and hydration with master circadian biological milestones (Morning Light Anchor, Caffeine Deadline, Peak Strength Window, Melatonin Wind-Down) and real-time environmental factors (Indian AQI, Heat Index, UV Index).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 / Phase 3 / Phase 15, §P2, §P3, §P15 Circadian & Environmental Intelligence)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/circadian_environmental_engine.dart`: Pure Dart calculation engine integrating circadian milestones (SCN light synchronization, afternoon peak strength, melatonin onset) with Rothfusz Heat Index and Indian CPCB AQI thresholds.
- `lib/features/environmental_health/domain/environmental_health_engine.dart`: Core environmental calculation engine.
- `lib/features/recovery_os/presentation/circadian_environmental_screen.dart`: Interactive circadian timeline dashboard with live environmental factor gauges (AQI, Heat Index, Extra Water Needed).

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.environment`
  - Fields: `aqi`, `temperatureCelsius`, `relativeHumidityPercent`, `uvIndex`, `extraHydrationMl`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart calculations for circadian milestone phase boundaries, thermal heat stress indices, and hydration adjustments.
- **AI Logic:** None in the core calculator; environmental and circadian status feed into the Health OS Brain.

## 6. Deviations from Spec
- None. Fully adheres to Circadian & Environmental Intelligence specifications.
