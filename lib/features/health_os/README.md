# Health OS Brain (Daily Intelligence Package Orchestration)

## 1. Feature Description
Orchestrates a unified daily intelligence cycle for each user, deterministically computing health scores, readiness zones, and adaptive nutrition/training targets, enriched with a cached Groq AI morning briefing.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-B, §P0-C, §P0-E Health OS Brain)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `functions/healthOS/index.js`: Backend orchestration Cloud Function that computes deterministic scoring, dispatches AI narrative synthesis, and writes the cached DIP to Firestore.
- `lib/core/models/daily_intelligence_package.dart`: Domain model defining `DailyIntelligencePackage`, readiness zones, scores, and safety alert payloads.
- `lib/features/health_os/domain/health_os_calculator.dart`: Pure Dart deterministic scoring engine for zero-latency, 100% offline fallback calculations.
- `lib/features/health_os/data/health_os_repository.dart`: Firestore repository with offline caching and automatic fallback.
- `lib/features/health_os/providers/health_os_provider.dart`: Riverpod state provider managing DIP data and date selection.
- `lib/features/health_os/presentation/health_os_briefing_card.dart`: Glassmorphic UI dashboard widget with animated activity rings, glowing metrics, and morning briefings.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/healthOS/{date}`
  - Fields: `healthScore`, `readinessScore`, `readinessZone`, `targetCalories`, `targetProteinGrams`, `targetSteps`, `workoutRecommendation`, `aiBriefing`, `safetyAlerts`, `generatedAt`.
- **Security rules:** Enforced under `/users/{userId}/**` allowing access strictly to the authenticated owner (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Readiness score (0-100), health score (0-100), readiness zone mapping, adaptive calorie/protein/step targets, and safety override rules are computed purely deterministically in pure Dart and Node.js.
- **AI Logic:** Groq multi-model LLM creates the personalized morning briefing copy based on the precomputed deterministic numbers.
- **Split location:** The backend Cloud Function computes all deterministic metrics first, prompts Groq for the briefing narrative, and writes the unified package once to Firestore. The Flutter client reads this cached package (or computes pure Dart fallback when offline).

## 6. Deviations from Spec
- None. Fully adheres to §P0-E specifications.
