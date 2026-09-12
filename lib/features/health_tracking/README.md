# Phase 4 — Health Tracking & Biomarker Intelligence

## Overview
Phase 4 implements FitKarma's comprehensive health tracking module, engineered specifically for the Asian-Indian metabolic profile. It provides local-first telemetry storage, multi-tier wearable stream reconciliation, clinical blood pressure staging (AHA/Indian consensus), continuous glucose and ADAG HbA1c estimation, and thin-fat phenotype risk evaluation.

---

## Key Architecture & Components

### 1. Domain Models (`lib/features/health_tracking/domain/models/health_models.dart`)
- `WearableSample`: Standardized cross-device telemetry metric (steps, heart rate, HRV, active calories).
- `BiomarkerReading`: Point-in-time clinical biomarkers (BP systolic/diastolic, fasting/post-meal glucose, HbA1c, lipids).
- `CgmTelemetryPoint`: Continuous glucose monitor streams with directional trend vectors.

### 2. Preventive Intelligence Engine (`PreventiveIntelligenceEngine`)
- **ADAG HbA1c Estimation**: Converts average blood glucose (mg/dL) to estimated HbA1c percentage via `(mean_glucose + 46.7) / 28.7`.
- **AHA / Indian Consensus BP Staging**: Clinical classification across Normal, Elevated, Stage 1, Stage 2, and Crisis, with automated pulse pressure calculation.
- **Thin-Fat Phenotype Evaluator**: Flags high visceral adiposity risk in individuals with normal Asian-Indian BMI (18.5–22.9 kg/m²) but elevated fasting glucose or vascular tension.

### 3. Wearable Comparison Engine (`WearableComparisonEngine`)
- **Multi-Tier Confidence Matrix**:
  - Tier 1 (1.0 weight): Apple Watch, Garmin, Pixel Watch, Polar, HealthKit, Health Connect
  - Tier 2 (0.85 weight): Fitbit, Samsung Galaxy Watch, Amazfit, Whoop, Oura
  - Tier 3 (0.65 weight): Boat, Noise, Fire-Boltt, Realme, Xiaomi
  - Tier 4 (0.50 weight): Manual entries & unknown sources
- **Conflict Resolution**: Time-bucketed (5-minute window) deduplication prioritizing high-confidence sources and weighted-average resting heart rate.

### 4. Local-First Persistence & Synchronization (`HealthTrackingRepository`)
- All samples write synchronously to local SQLite via Drift (`LocalWearableSamples`, `LocalBiomarkers`, `LocalCgmTelemetry`).
- Outbox mutations queued to `PendingMutations` table for background sync to Supabase.
- Complies with **ADR-002**: Hand-rolled Drift Outbox + append-only telemetry tables with unique constraints `(user_id, source, metric, timestamp)`.

### 5. Presentation Layer
- `HealthDashboardScreen`: Central Bento hub connecting all biometric modules.
- `StepsTrackingScreen`: Step progress, source tier badge, and Shatapadi post-meal protocol recommendation.
- `SleepTrackingScreen`: Visual sleep architecture bar (Deep, REM, Light, Awake) with Ayurvedic Kapha-time circadian alignment.
- `BloodPressureScreen`: Real-time interactive AHA/Indian clinical staging and dietary guidance.
- `GlucoseTrackingScreen`: Fasting/post-meal glucose input, ADAG HbA1c card, and Indian low-GI grain swaps.

---

## Verification & Testing
- Automated unit test suite: `test/health_tracking_test.dart` (ADAG formulas, BP staging, Thin-Fat evaluation, Device confidence tiers, Drift repository & outbox).
- All 43 tests passing cleanly across the test suite (`flutter test`).
- Zero analyzer warnings or errors (`flutter analyze`).
