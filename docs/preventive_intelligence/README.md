# Preventive Intelligence Engine (Deterministic)

## 1. Feature Description
Evaluates multi-stream health metrics (Blood Pressure, Fasting Glucose, Asian-Indian BMI, 7-Day Sleep Debt, HRV/RHR trends) to synthesize a composite Cardiometabolic Risk Score (CMR) and autonomic balance status with actionable lifestyle prescriptions.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Preventive Intelligence Engine)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/domain/preventive_intelligence_engine.dart`: Pure Dart calculation engine determining Cardiometabolic Risk points across BP (30 pts), Glucose (30 pts), Asian-Indian BMI cutoff (25 pts), and Sleep Debt (15 pts), alongside autonomic HRV homeostasis classification.
- `lib/features/health_tracking/presentation/preventive_intelligence_screen.dart`: Preventive dashboard screen displaying risk score hero bento gauge, biomarker attribution bars, and preventive lifestyle action protocols.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyLogs/{date}`, `/users/{uid}/bloodPressureLogs`, `/users/{uid}/glucoseLogs`
  - Writes: Optional persistence to `/users/{uid}/preventiveIntelligence/{date}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic clinical risk point aggregation, Asian-Indian BMI risk stratification, and rule-based lifestyle protocols in pure Dart.
- **AI Logic:** None in core preventive risk engine.

## 6. Deviations from Spec
- None. Fully adheres to Preventive Intelligence specifications.
