# Blood Pressure Screen (Biometric-Gated Access)

## 1. Feature Description
Provides a secure cardiovascular health tracking vault with biometric lock gating (DPDP Act aligned), AHA and Indian consensus guideline classification, Mean Arterial Pressure (MAP), Pulse Pressure calculation, and clinical lifestyle recommendations.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Blood Pressure Screen)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/domain/blood_pressure_engine.dart`: Pure Dart mathematical model calculating Mean Arterial Pressure ($MAP = DBP + (SBP - DBP) / 3$), Pulse Pressure ($SBP - DBP$), and 5-tier clinical categories (Normal, Elevated, Stage 1, Stage 2, Hypertensive Crisis).
- `lib/features/health_tracking/presentation/blood_pressure_screen.dart`: Biometric-gated screen with vault lock view, hero reading bento cards, historical list, and modal input logger.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/bloodPressureLogs/{logId}`
  - Fields: `systolic`, `diastolic`, `pulseBpm`, `arm`, `posture`, `recordedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic AHA clinical staging formulas, Mean Arterial Pressure, Pulse Pressure, and biometric gating logic in pure Dart.
- **AI Logic:** None in core cardiovascular vitals engine.

## 6. Deviations from Spec
- None. Fully adheres to Blood Pressure Tracking specifications.
