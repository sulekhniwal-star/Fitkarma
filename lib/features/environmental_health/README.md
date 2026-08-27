# Environmental Health Layer (AQI, UV, Heat Index — Base Version)

## 1. Feature Description
Monitors real-time environmental context for India (CPCB Air Quality Index, UV radiation risk, and humidity-adjusted Heat Index), automatically adjusting hydration recommendations and issuing outdoor vs. indoor training advisories.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-G Phase 0, Phase 15)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/features/environmental_health/domain/environmental_health_engine.dart`: Pure Dart deterministic calculator evaluating Indian CPCB AQI categories (good, satisfactory, moderate, poor, very poor, severe), UV risk categories, Rothfusz Heat Index (°C), and dynamic hydration additions (+300 to +1000 ml).
- `lib/features/environmental_health/data/environmental_health_repository.dart`: Firestore repository with offline caching and seamless local evaluation fallback.
- `lib/features/environmental_health/providers/environmental_health_provider.dart`: Riverpod state provider for real-time environmental health data.
- `lib/features/environmental_health/presentation/environmental_health_card.dart`: Glassmorphism bento card displaying AQI levels, Heat Index, UV indicators, hydration alerts, and bilingual badges.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/environmentalHealth/today`
  - Fields: `aqi`, `aqiCategory`, `uvIndex`, `uvCategory`, `temperatureC`, `humidityPercent`, `heatIndexC`, `heatRisk`, `outdoorWorkoutAllowed`, `extraHydrationMl`, `recommendation`, `capturedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict owner access (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% pure Dart mathematical formulas for CPCB AQI categorization, Heat Index equations, hydration adjustments, and safety clearance flags.
- **AI Logic:** None in the core calculator; the Health OS Brain incorporates environmental notices into daily morning briefing summaries.

## 6. Deviations from Spec
- None. Fully adheres to Phase 0 Foundation and Phase 15 environmental health specifications.
