# Architecture Overview (Offline-First, Health OS Brain)

## 1. Feature Description
Provides the foundational architecture, offline-first data caching strategy, conflict-resolution utilities, and Health OS Brain orchestration layer for FitKarma.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-B, §P0-C, §P0-E)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/core/services/local_storage_service.dart`: Hive-backed local storage for transient drafts and in-progress workout sessions.
- `lib/core/sync/sync_utils.dart`: Conflict-free sync utilities supporting atomic increments, idempotency key generation, and server timestamps.
- `lib/core/models/daily_intelligence_package.dart`: Domain data model for the Health OS Brain's Daily Intelligence Package (DIP), health scores, and readiness zones.
- `functions/healthOS/index.js`: Backend orchestration entry point for generating and saving daily intelligence packages.
- `docs/architecture/architecture_overview.md`: Comprehensive system architecture and offline sync documentation.

## 4. Firestore Collections & Fields
- **Data paths:**
  - `/users/{uid}/healthOS/{date}`: Stores daily readiness score, health score, adaptive macronutrient targets, safety alerts, and AI briefings.
  - `/users/{uid}/dailyLogs/{date}`: Daily step count, hydration, recovery inputs using atomic increment updates.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Readiness scores, health scores, safety overrides, and macronutrient targets are calculated purely deterministically with zero AI dependencies.
- **AI Logic:** Groq LLM synthesis generates the contextual daily briefing narrative within bounds dictated by deterministic calculations.
- **Split location:** The Health OS Brain Cloud Function runs the deterministic calculations first, then passes the structured payload to the Groq AI router for narrative generation before saving the single cached result to Firestore.

## 6. Deviations from Spec
- None. Implemented exactly per the v2.0 offline-first + Health OS Brain specifications.
