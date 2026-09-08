# Training Operating System — Smart Programming & Overload Logic

## 1. Feature Description
Provides automated periodization pacing, volume landmark tracking (MEV, MAV, MRV), and intra-workout RPE/RIR auto-regulation for FitKarma's Training OS (Phase 6):
- **6-Week Mesocycle Periodization Waves**:
  - *Weeks 1–3 (Volume Accumulation)*: Systematic set and load ramp ($100\%$ volume modifier, RPE $7.5\text{–}8.5$).
  - *Weeks 4–5 (Strength Intensification)*: Lower rep peaking with maximal mechanical tension ($85\%$ volume, RPE $8.5\text{–}9.5$).
  - *Week 6 (Active Resensitization Deload)*: Volume reduction to $60\%$ to eliminate systemic fatigue and restore connective tissue.
- **Volume Landmark Intelligence**:
  - *MEV (Minimum Effective Volume)*: Baseline sets required to maintain/trigger muscle protein synthesis.
  - *MAV (Maximum Adaptive Volume)*: Hyper-productive sweet spot for maximal muscle growth.
  - *MRV (Maximum Recoverable Volume)*: Threshold beyond which fatigue outpaces adaptation.
- **Auto-Regulated RPE/RIR Load Calibration**:
  - Automatically recommends mid-workout load jumps ($+5\%$) when RPE is $<7.0$ ($3+\text{ RIR}$) or warns to hold load when RPE reaches $10.0$ ($0\text{ RIR}$).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Training OS Smart Programming & Overload Logic)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/smart_programming_engine.dart`: Pure Dart mathematical calculator for MEV/MAV/MRV landmarks, mesocycle phase transitions, and RPE auto-regulation rules.
- `lib/features/workout/presentation/smart_programming_screen.dart`: Interactive Bento UI with mesocycle timeline cards, MEV/MAV/MRV volume landmark gauges, and real-time RPE auto-regulation simulators.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}`
  - Writes: `/users/{uid}/programmingMesocycle/{cycleId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic periodization algorithms, volume landmark thresholds, and RPE calibration mathematics in pure Dart.
- **AI Logic:** None in core programming & overload engine.

## 6. Deviations from Spec
- None. Fully adheres to Training Operating System — Smart Programming & Overload Logic specifications.
