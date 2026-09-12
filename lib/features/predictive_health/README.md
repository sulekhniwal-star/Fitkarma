# Predictive & Clinical Health Operating System (`lib/features/predictive_health`)

## Overview
The **Predictive & Clinical Health Operating System** transitions FitKarma from retrospective fitness tracking into proactive, multi-decade longevity intelligence. It computes personalized biological age, monitors Indian cardiometabolic risk trajectories, prevents athletic injuries via workload monitoring, analyzes clinical lab panels, and facilitates doctor sharing.

---

## Core Engines & Components

### 1. `BiologicalAgeEngine`
- **Location**: `lib/features/predictive_health/domain/services/biological_age_engine.dart`
- **Multi-Parametric Deterministic Model**:
  - Resting Heart Rate efficiency (<60 bpm saves up to -2.5 yrs).
  - Autonomic HRV balance (>65 ms saves up to -2.0 yrs).
  - Asian-Indian BMI classification (18.5–22.9 saves -1.5 yrs; >=25.0 adds +2.8 yrs).
  - Blood Pressure staging (<120 mmHg saves -1.2 yrs; >=140 mmHg adds +3.2 yrs).
  - Daily step volume & sleep architecture modifiers.
  - Dynamically computes itemized biomarker contributors and top action items.

### 2. `CardiometabolicRiskEngine`
- **Location**: `lib/features/predictive_health/domain/services/cardiometabolic_risk_engine.dart`
- **South Asian Consensus & ATP III Standards**:
  - Asian-Indian central adiposity cutoffs: Men $\ge 90\text{ cm}$, Women $\ge 80\text{ cm}$.
  - 5-point Metabolic Syndrome criteria detection.
  - 10-year cardiovascular risk % and prediabetes trajectory score.

### 3. `InjuryRiskEngine`
- **Location**: `lib/features/predictive_health/domain/services/injury_risk_engine.dart`
- **Acute:Chronic Workload Ratio (ACWR)**:
  - Acute Load (7-day total) vs Chronic Load (28-day weekly average).
  - Sweet spot ($0.8 \le \text{ACWR} \le 1.3$) vs Danger zone ($\text{ACWR} > 1.5$).

### 4. `StressDetectionEngine`
- **Location**: `lib/features/predictive_health/domain/services/stress_detection_engine.dart`
- **Physiological Autonomic Monitoring**:
  - HRV suppression ($>25\%$ drop below baseline).
  - Resting HR elevation ($>4\text{ bpm}$ above baseline).
  - Four recovery states: *Restored*, *Mild*, *Moderate*, *High*.

### 5. `ClinicalLabIntelligenceEngine`
- **Location**: `lib/features/predictive_health/domain/services/clinical_lab_intelligence_engine.dart`
- **Diagnostic Panel Analysis**:
  - HbA1c, Fasting Glucose, Lipid Profiles (Total, LDL, HDL, Triglycerides), Vitamin D3, and Vitamin B12.
  - Produces bilingual executive summaries with dietary and lifestyle recommendations.

### 6. `MedicationSafetyEngine`
- **Location**: `lib/features/predictive_health/domain/services/medication_safety_engine.dart`
- **Chrononutrition Safety**:
  - Food-drug timing alerts (e.g. *Metformin with food*, *Levothyroxine empty stomach 30-60 mins before morning tea*).

### 7. `PredictiveHealthRepository`
- **Location**: `lib/features/predictive_health/data/predictive_health_repository.dart`
- **Drift Database Tables**:
  - `LocalBiologicalAgeRecords`
  - `LocalClinicalLabReports`
  - `LocalMedications`
  - `LocalDoctorGrants`
- **Outbox Sync**: Queues offline mutations to Supabase with Row Level Security.

---

## Verification
- Unit Tests: `test/predictive_health_test.dart`
- Supabase Migration: `supabase/migrations/20260912000010_phase10_predictive_health_schema.sql`
