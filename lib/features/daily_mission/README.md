# Daily Briefing Screen & Daily Missions

## 1. Feature Description
Provides the primary morning check-in ritual, synthesized Health OS briefing, readiness gauge, and daily micro-missions checklist with Karma point rewards.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 — Daily Mission + Readiness, §P2 Daily Briefing Screen)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/daily_mission/domain/daily_mission.dart`: Domain model defining `DailyMissionItem` across categories (steps, workout, nutrition, hydration, recovery) and Karma point rewards.
- `lib/features/daily_mission/data/daily_mission_repository.dart`: Firestore repository with offline caching.
- `lib/features/daily_mission/providers/daily_mission_provider.dart`: Riverpod `StateNotifier` managing mission completion toggles and Firestore sync.
- `lib/features/daily_mission/presentation/daily_briefing_screen.dart`: Primary morning dashboard with subjective check-in ritual (Sleep/Energy/Soreness), Health OS briefing card, readiness gauge, and animated daily mission checklist.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyMissions/{date}` and `/users/{uid}/dailyLogs/{date}`
  - Fields: `missions` (`id`, `title`, `regionalTitle`, `targetSubtitle`, `karmaReward`, `category`, `isCompleted`), `updatedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Morning check-in scoring, mission generation, Karma points attribution, and completion state toggling are 100% deterministic in pure Dart.
- **AI Logic:** The morning briefing narrative displayed on this screen is precomputed and cached by the backend Health OS Brain.

## 6. Deviations from Spec
- None. Fully adheres to Phase 2 Daily Briefing Screen specifications.
