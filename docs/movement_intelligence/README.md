# Training Operating System — Movement Intelligence Platform

## 1. Feature Description
Provides biomechanical classification, structural balance diagnostic analysis, and joint safety monitoring across all scheduled workouts in FitKarma's Training OS (Phase 6):
- **7 Fundamental Movement Patterns**:
  1. *Horizontal Push* (Bench Press, Incline DB, Desi Dand).
  2. *Horizontal Pull* (Bent-over Rows, Cable Rows).
  3. *Vertical Push* (Overhead Barbell Press, Pike Pushups).
  4. *Vertical Pull* (Lat Pulldowns, Pull-ups).
  5. *Knee Dominant / Squat* (Barbell Squats, Desi Baithak).
  6. *Hip Dominant / Hinge* (Romanian Deadlifts, Conventional Deadlifts).
  7. *Rotational & Core Integrity* (Mudgar / Karlakattai 360 swings, Hanging Leg Raises).
- **Biomechanical Symmetry & Ratio Analytics**:
  - *Push-to-Pull Ratio*: Target $0.9\text{–}1.1$ to prevent anterior shoulder impingement.
  - *Quad-to-Hamstring Ratio*: Target $1.0\text{–}1.3$ to eliminate patellofemoral and ACL shear stress.
- **Indian Akhara Movement Prep & Corrective Flow**: Generates dynamic warm-up prescriptions (Mudgar rotational shoulder circles, Desi Dand thoracic openers, 90/90 hip flows) prior to heavy loading.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Training OS Movement Intelligence Platform)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/movement_intelligence_engine.dart`: Pure Dart deterministic classifier for fundamental movement patterns, push/pull ratios, structural symmetry scoring, and corrective warmup generators.
- `lib/features/workout/presentation/movement_intelligence_screen.dart`: Interactive Bento UI with overall balance score, 7-pattern set progress bars, structural diagnostics, and Akhara movement prep protocols.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{date}`
  - Writes: `/users/{uid}/movementIntelligence/{date}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic biomechanical classification, structural symmetry ratio math, and pattern set aggregations in pure Dart.
- **AI Logic:** None in core movement intelligence engine.

## 6. Deviations from Spec
- None. Fully adheres to Training Operating System — Movement Intelligence Platform specifications.
