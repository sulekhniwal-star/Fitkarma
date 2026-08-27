# Recovery Log Screen (Body Soreness Map)

## 1. Feature Description
Provides an interactive somatic body soreness logging interface across 10 anatomical muscle groups, calculating cumulative recovery strain (0-100) and prescribing targeted relief mobility protocols.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 — Daily Mission + Readiness, §P2 Recovery Log Screen)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/body_soreness_map.dart`: Domain model defining 10 muscle groups (Neck/Traps, Shoulders, Chest, Upper Back, Lower Back, Arms, Core, Quads, Hamstrings/Glutes, Calves), 4 severity levels (0 None to 3 Severe), cumulative score calculations, and targeted relief protocols.
- `lib/features/recovery_os/data/recovery_repository.dart`: Firestore repository with offline caching.
- `lib/features/recovery_os/providers/recovery_provider.dart`: Riverpod `StateNotifier` for instantaneous muscle soreness updates.
- `lib/features/recovery_os/presentation/recovery_log_screen.dart`: Interactive soreness dashboard featuring concentric `ActivityRings` recovery gauge, muscle group selection cards, and targeted relief protocol cards.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.sorenessMap`
  - Fields: `muscleStates`, `cumulativeScore`, `loggedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart mathematical calculation of the cumulative soreness score and mapping of evidence-based somatic relief drills.
- **AI Logic:** None in this module; cumulative soreness feeds directly into the deterministic `ReadinessEngine`.

## 6. Deviations from Spec
- None. Fully adheres to Phase 2 Recovery Log specifications.
