# Health Tracking Dashboard Screen

## 1. Feature Description
Provides the central command dashboard of FitKarma with an interactive glassmorphic Bento grid synthesizing Unified Health Score, concentric Activity Rings, 2x2 biometric tiles (Steps, Sleep, Hydration, Strain), and nutrition macro targets.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Dashboard Screen)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/providers/dashboard_provider.dart`: Riverpod state notifier managing composite dashboard biometric states and optimistic tap increments.
- `lib/features/health_tracking/presentation/dashboard_screen.dart`: Main dashboard screen featuring concentric `ActivityRings`, Karma point badges, 2x2 biometric grid (Steps, Sleep, Water, Strain), and caloric progress bars.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/healthOS/{date}`, `/users/{uid}/dailyLogs/{date}`
  - Writes: Optimistic tap logs under `/users/{uid}/dailyLogs/{date}.hydration`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic layout, activity ring calculations, macro remaining math, and tap handlers in pure Dart.
- **AI Logic:** The overarching morning briefing and recommendations displayed in the hero card are precomputed by the Health OS Brain.

## 6. Deviations from Spec
- None. Fully adheres to Health Tracking Dashboard specifications.
