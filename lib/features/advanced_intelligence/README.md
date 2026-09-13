# Advanced Intelligence: Adaptive Metabolism, Longevity & Environmental OS (FitKarma Phase 15)

FitKarma's Advanced Intelligence tier delivers deep physiological computation specifically adapted for South Asian metabolic phenotypes and environmental conditions.

---

## Key Capabilities

1. **Adaptive Metabolism & Dynamic TDEE Engine (`AdaptiveMetabolismEngine`)**:
   - Computes Mifflin-St Jeor / Harris-Benedict BMR tuned for Asian Indian body composition.
   - Detects progressive metabolic adaptation (downregulation of NEAT, thyroid T3, and leptin) after sustained deficits.
   - Prescribes structured carb refeeds and caloric maintenance breaks when plateaus are detected.

2. **Multi-Pillar Longevity Index (`LongevityScoreEngine`)**:
   - Comprehensive 0–100 Longevity Score across 4 foundational pillars:
     a) **Cardiometabolic Reserve** (Fasting glucose, Blood Pressure, Triglyceride ratios).
     b) **Cellular Recovery** (Resting HR, RMSSD HRV parasympathetic tone).
     c) **Functional Strength** (Desi Baithak/Dand capacity, bodyweight power).
     d) **Lifestyle & Stress Modulation** (Pranayama consistency, daily movement).
   - Generates projected healthspan years gained and prioritized daily longevity levers.

3. **Environmental Health Shield (`EnvironmentalIntelligenceEngine`)**:
   - Indian city AQI intelligence (Delhi NCR smog alerts, Mumbai humidity index, Bengaluru UV/altitude).
   - Automatic indoor workout substitutions (Air-purified Surya Namaskar and Pranayama) when AQI > 150.
   - Thermal stress hydration multipliers (Nimbu Pani & Sendha Namak replenishment).

4. **Offline-First Persistence & Synchronization**:
   - Local Drift tables: `LocalMetabolicProfiles`, `LocalLongevityScores`.
   - Outbox sync via `OutboxSyncWorker`.
   - Supabase schema: `metabolic_profiles`, `longevity_assessments` with full RLS.
