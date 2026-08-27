# FitKarma — Master Documentation
### Version 2.0 — India's Intelligent Health Operating System (Fresh Build)
**Flutter 3.x · Dart · Riverpod 2.x · Firebase (Firestore, Functions, Auth, Storage, FCM) · RevenueCat · Multi-Model AI (Groq)**

> Offline-first · Privacy-centric · Built for India · AI-adaptive
> Dark mode primary · Glassmorphism · Spring physics · Bento grid

---

## Document Status: Version 2.0 — Clean Rebuild

This is a ground-up rewrite of the FitKarma documentation. The v1.0 documentation (Cloudflare D1 + Workers + Drift) has been fully retired — the codebase was deleted and this project restarts from zero on a new stack. The **feature scope and phase structure carry over from v1.0** (nothing was cut), but every architecture, data-layer, and infrastructure section has been rewritten for the new stack.

| Area | v1.0 (retired) | v2.0 
|---|---|---|
| Frontend language | Dart | Dart (unchanged) |
| Frontend framework | Flutter | Flutter (unchanged) |
| Local storage | Drift (SQLite) | Firestore offline persistence + Hive (typed local cache) |
| Cloud database | Cloudflare D1 (SQLite at edge) | Firebase Firestore (NoSQL document store) |
| Backend compute | Cloudflare Workers + Workflows | Firebase Cloud Functions (Node.js/JavaScript) |
| Auth | Custom (JWT via Workers) | Firebase Authentication |
| File/image storage | Cloudflare R2 | Firebase Cloud Storage |
| Push notifications | Custom | Firebase Cloud Messaging (FCM) |
| AI provider | Groq (multi-model) | Groq (multi-model) — unchanged, called from Cloud Functions |
| Payments | RevenueCat | RevenueCat (unchanged) |
| API pattern | REST (Workers routes) | REST (Callable Cloud Functions + HTTPS endpoints) |

**Why the switch (recorded for future reference):** Cloudflare D1/Workers required hand-building auth, sync/conflict resolution, and offline-merge logic — all of which cost real engineering time in the v1.0 build (see retired doc's "Architecture Hardening Summary" for the bugs this produced). As a solo founder rebuilding from scratch with a ~1-year timeline covering 16 feature phases, Firebase trades some infrastructure control for built-in auth, real-time sync, and offline persistence — reducing undifferentiated infra work so more time goes into the actual health/fitness intelligence layer. This is a deliberate build-speed-over-architectural-purity tradeoff; a migration to a custom backend remains possible post-validation without touching the Flutter frontend.

---

## Vision Statement

FitKarma is not a fitness tracker. It is **India's intelligent health operating system** — an adaptive system that creates and evolves a complete life plan for each user, providing the kind of personalized coaching previously only available to elite athletes.

> "Stop making it only a tracker. Make it a decision engine + life operating system."

The **Health OS Brain** is the central intelligence layer that replaces fragmented per-module AI calls with a single orchestrated daily intelligence cycle. Every feature reads from it. Nothing calls the AI twice for the same reasoning.

---

## Development Roadmap — Master Order (16 Phases, unchanged from v1.0)

| Phase | What You Build | Why First |
|---|---|---|
| **Phase 0** | Foundation — Design System, Architecture, Health OS Core | Everything else depends on this |
| **Phase 1** | Core Onboarding + User Profile | Personalization data collected before any features |
| **Phase 2** | Daily Mission + Readiness Engine | The emotional core users return to every morning |
| **Phase 3** | AI Adaptive Coach (Routed) | Multi-model coaching, not raw Groq passthrough |
| **Phase 4** | Health Tracking (Steps, Sleep, Vitals, Wearables) | Core data inputs for the Health OS Brain |
| **Phase 5** | Smart Indian Nutrition System | Strongest moat; deepest Indian food intelligence |
| **Phase 6** | Workout + Progressive Overload + Form Intelligence | Intelligent progression with movement coaching |
| **Phase 7** | Gamification + Karma + Adherence + Benchmarks + Cohorts | Retention engine that rewards results with cohort context |
| **Phase 8** | Transformation Journey + Psychology + Identity | Anti-quit system with long-term memory and identity evolution |
| **Phase 9** | Social, Squads, Family, Feed, Clubs & Sharing | Growth lever via feed sharing, geolocation circles, squad accountability |
| **Phase 10** | Predictive Health, Clinical Reports, CGM, Meds & Doctor Share | Biomarker tracking, medication interaction warnings, doctor export |
| **Phase 11** | Visual Body Analytics + Predictions + BF% Estimation | Retention through future projections |
| **Phase 12** | Festival + Life Events + Travel + Calendar Intelligence | Uniquely Indian; deeply adaptive |
| **Phase 13** | Premium, Monetisation, Creator & Coach Marketplace | Revenue via marketplace, program store, affiliate commission |
| **Phase 14** | Enterprise Hardening + CI/CD | Production readiness |
| **Phase 15** | Advanced Intelligence — Adaptive Metabolism, Longevity Score, Environmental Health | Closes gap with MacroFactor/WHOOP |
| **Phase 16** | India Growth & Trust Layer — WhatsApp Logging, Vernacular Voice, ABHA ID, Corporate Wellness, Grocery Checkout | Removes logging friction; adds trust + second monetisation channel |

---

## §P0-A. Tech Stack (Locked)

- **Frontend language:** Dart
- **Frontend framework:** Flutter 3.x (single codebase, Android + iOS)
- **State management:** Riverpod 2.x
- **UI system:** Material Design (Android-native feel) + Cupertino (iOS-native feel) + custom animation layer (spring physics, glassmorphism, bento grid — see §P0-D)
- **Local storage:** Firestore offline persistence (automatic local cache + sync) supplemented by Hive for typed, high-frequency local-only data (e.g. in-progress workout state, draft logs) that shouldn't round-trip to the cloud
- **Cloud database:** Firebase Firestore (NoSQL, document/collection model)
- **Backend compute:** Firebase Cloud Functions, written in JavaScript (Node.js)
- **Auth:** Firebase Authentication (phone/OTP primary, given the India-first market; email/Google/Apple as secondary)
- **File/image storage:** Firebase Cloud Storage (progress photos, meal photos, clinical report uploads)
- **Push notifications:** Firebase Cloud Messaging (FCM)
- **AI provider:** Groq — multi-model tiered routing (tiny → medium → large), called server-side from Cloud Functions, never directly from the client
- **Payments/subscriptions:** RevenueCat
- **API pattern:** REST — Firebase Callable Functions for client-triggered logic, HTTPS Functions for webhooks (RevenueCat, WhatsApp Business API, etc.)
- **Version control / tooling:** Git/GitHub, VS Code, Postman (for testing Cloud Functions HTTPS endpoints)

---

## §P0-B. Architecture Overview

### Core Principle: Offline-First + Health OS Brain

The app must be fully usable with no connectivity for logging (steps, meals, workouts, mood, recovery). Firestore's built-in offline persistence handles the read/write cache and sync-on-reconnect automatically for most collections. Any data that must never silently merge incorrectly (e.g. cumulative counters like daily step totals) uses Firestore transactions or increment operations server-side rather than raw last-write-wins client merges.

```
┌─────────────────────────────────────────────┐
│                Flutter Client                │
│  Riverpod state · Firestore SDK (offline     │
│  persistence on) · Hive (local-only cache)   │
└───────────────┬───────────────────────────────┘
                │ Firestore SDK (real-time sync)
                │ Callable Functions (business logic)
┌───────────────▼───────────────────────────────┐
│              Firebase Cloud Functions          │
│  Health OS Brain orchestration · AI Router     │
│  (Groq) · Scheduled jobs (Daily Intelligence   │
│  Package) · Webhooks (RevenueCat, WhatsApp)    │
└───────────────┬───────────────────────────────┘
                │
┌───────────────▼───────────────────────────────┐
│     Firestore · Cloud Storage · FCM · Auth      │
└─────────────────────────────────────────────┘
```

### Sync & Conflict Handling

- Firestore's native offline persistence covers standard read/write conflict resolution (last-write-wins at the document field level) for the vast majority of user-editable data (profile, settings, logged entries as discrete documents).
- **Cumulative/additive data** (daily step count, hydration ml, karma points) is written via Firestore's atomic `increment()` operations, not read-modify-write, to avoid double-counting on retried syncs from flaky Indian mobile networks.
- **Idempotency keys** are attached to sync-sensitive writes (e.g. a workout-completion event) as a document field, checked server-side in a Cloud Function trigger before any downstream side effect (karma award, streak update) fires — preventing duplicate rewards from retried offline queues.
- **Device clock skew** is avoided by using Firestore's `serverTimestamp()` for anything that determines ordering or "today" boundaries, rather than trusting client-reported time.

### What Is and Is NOT an AI Job

Unchanged from v1.0 principle: deterministic math (BMI, TDEE, readiness score, progressive overload, adherence score) is computed in pure Dart or in a Cloud Function with no AI call — cheap, instant, and reliable offline. AI (Groq, via Cloud Functions) is reserved for judgment calls that need language understanding or synthesis: meal photo analysis, coaching responses, weekly narrative summaries, and OCR/menu parsing.

---

## §P0-C. Firestore Data Model (replaces v1.0's D1/Drift schema)

Top-level collections (each user's data is scoped under their UID for security-rule enforcement):

```
/users/{uid}
  profile, onboarding answers, goals, demographics, subscription tier

/users/{uid}/dailyLogs/{date}
  steps, sleep, hydration, mood, recovery inputs — one doc per day

/users/{uid}/meals/{mealId}
  logged meals, photo refs (Cloud Storage), nutrition breakdown

/users/{uid}/workouts/{workoutId}
  session data, sets/reps/weight, form-check refs

/users/{uid}/healthOS/{date}
  Daily Intelligence Package output — readiness, adaptive targets, AI briefing

/users/{uid}/karma  (subcollection or fields on profile)
  points, streaks, badges, adherence score

/users/{uid}/clinicalReports/{reportId}
  parsed lab values, biomarker history (write-restricted, DPDP-compliant deletion path)

/squads/{squadId}
  members, shared missions, activity feed refs

/clubs/{clubId}
  geolocation-based interest circles

/cohortBenchmarks/{cohortKey}
  aggregated, anonymized percentile data (city/age-group) — no per-user PII

/marketplace/{programId or coachId}
  creator/coach marketplace listings (Phase 13)
```

**DPDP Act (India data protection) compliance:** every collection containing personal data supports cascading deletion from a single Cloud Function (`deleteUserData`) triggered on account-deletion request, walking all subcollections under `/users/{uid}` plus any cross-referencing docs (squad membership, cohort contribution) the user is party to.

---

## §P0-D. Design Tokens & UI System

- **Theme:** dark mode primary, glassmorphism surfaces, spring-physics animation curves, bento-grid dashboard layout (unchanged design language from v1.0).
- **Widget layer:** built with Flutter's Material widgets as the base (cross-platform default), with Cupertino-styled equivalents swapped in on iOS for platform-native feel where it matters most (navigation transitions, action sheets, date pickers).
- **Shared foundation widgets** (rebuilt fresh, same responsibilities as v1.0): `BentoCard`, `ActivityRings`, `GlowingMetric`, `BilingualLabel` (English + regional language support, part of the India Growth Layer).
- **Animation:** Flutter's implicit/explicit animation APIs plus a spring-physics package (e.g. `flutter_animate` or hand-rolled `SpringSimulation`) for the signature "alive" feel on readiness rings and karma celebrations.

---

## §P0-E. Health OS Brain

**Why it exists:** a central intelligence layer so every feature reads from one orchestrated daily cycle instead of each module independently calling AI and recomputing overlapping context.

**Implementation on the new stack:** a scheduled Cloud Function (Firebase Scheduler, per-user timezone-aware — not hardcoded to IST) runs the **Daily Intelligence Package (DIP)** generation as a fan-out job: one task per active user, dispatched via Cloud Tasks queue for isolation (so one user's failure doesn't block the batch — this replaces v1.0's Cloudflare Workflows fan-out/fan-in pattern with Firebase's equivalent, Cloud Tasks + Cloud Functions).

**Inputs:** yesterday's logs (sleep, steps, nutrition, workout, recovery, mood), rolling averages, calendar/festival context, environmental data (AQI/UV/heat where available).

**Output (written to `/users/{uid}/healthOS/{date}`):** unified health score, readiness zone, adaptive nutrition/training targets for the day, and a short AI-generated briefing (Groq, cached — not regenerated if the user re-opens the app).

**Decision hierarchy:** deterministic safety rules (e.g. "user logged illness symptoms") always override AI-suggested intensity; the AI layer adjusts within bounds set by the deterministic layer, never outside them.

---

## §P0-F. AI Routing Layer (Groq, server-side only)

- **Model tiers:** tiny (cheap, fast — used for classification/routing decisions), medium (default coaching responses), large (complex synthesis — weekly reports, clinical report parsing).
- **Router:** a Cloud Function decides tier based on request type and user subscription tier (free users biased toward tiny/medium; premium/elite unlock large-tier calls and human-coach escalation).
- **Caching:** AI responses are cached per-user in Firestore (`/users/{uid}/aiCache/{key}`), scoped for DPDP right-to-erasure compliance (cascading delete, see §P0-C).
- **Rule engine / template fallback:** if Groq is unreachable or the user is offline, deterministic template responses cover the most common coaching prompts so the app degrades gracefully rather than failing.
- **Cost budget:** enforced per subscription tier in the router before a call is made, not after — free tier requests that would exceed budget silently fall back to the template engine.

---

## §P0-G. Feature Phases — Scope Reference

The following retains the full feature breakdown from the v1.0 documentation. Scope is unchanged; only the implementation layer (Firebase instead of Cloudflare/Drift) differs. Each item below becomes its own feature folder with its own README (see TODO.md workflow).

### Phase 0 — Foundation
Design Philosophy & Anti-Patterns · Project Structure · Architecture Overview · Design Tokens · Shared Foundation Widgets · Health OS Brain · AI Routing Layer · Program Evolution Engine · Prerequisites · Adaptive Metabolism Engine · Environmental Health Layer (AQI/UV/Heat)

### Phase 1 — Onboarding
Onboarding Flow Order · Welcome Screen · Goals Screen · Demographics Screen (live BMI + adaptive targets) · AI Diet Plan Results Screen · Dosha Quiz (scoring engine) · Program Blueprint Selection · Women's Advanced Health Layer (cycle-aware training/nutrition, fertility planning, menopause tracking, PCOS calibrator)

### Phase 2 — Daily Mission + Readiness
Readiness Engine (three-tier confidence model, deterministic score formula) · Daily Briefing Screen (morning check-in ritual) · Recovery Log Screen (body soreness map) · Recovery Operating System (sleep intelligence, recovery capacity & strain, recovery behaviors, circadian intelligence, recovery age & forecasting)

### Phase 3 — AI Adaptive Coach
AI Coach Philosophy · AI Context Builder · AI Coach Screen (local chat cache, optimistic UI) · Cloud Function coach endpoint · Proactive event-driven insights · Health Coach Escalation Layer (elite tier — human coach handoff)

### Phase 4 — Health Tracking
Dashboard Screen · Steps Screen (auto-detection & sync) · Sleep Screen (stage metrics, debt modeling) · Blood Pressure Screen (biometric-gated access) · Glucose Screen (meal correlation, HbA1c estimation) · Preventive Intelligence Engine (deterministic) · Smart Wearable Comparison Layer (device confidence matrix, late-sync override/merge rules)

### Phase 5 — Smart Indian Nutrition
Food Screen Home · Meal Analysis Pipeline · "Fix My Meal" AI Photo Analysis (vision cost optimization) · Smart Indian Meal Intelligence (offline seeded food DB, local meal-quality scoring) · Indian Restaurant Intelligence (menu OCR, chain presets) · Grocery Optimization Engine (budget-optimized flow) · Nutrition Periodization Engine · Protein Distribution & Timing · Micronutrient Intelligence Core · Nutrition Adherence Engine · Festival Nutrition Adaptation · Adaptive Hunger & Cravings Engine · Glycemic Response & Personal Food Scoring · Multi-Dimensional Meal Quality Score · Nutrition Reliability Score · Satiety Prediction Engine · Family Nutrition Integration · Indian Food Substitution & Swap Engine

### Phase 6 — Workout System
Workout Screen Home · Active Workout Screen · Progressive Overload Engine (deterministic) · Dynamic Fitness Blueprint Generator · Training Operating System (movement intelligence, confidence indices, smart programming, adherence profiling, biomechanics/trajectory projections) · Adaptive Computer Vision Loop (pose estimation form-checking)

### Phase 7 — Gamification
Karma System Design · Karma Hub Screen · Habit Automation System · Adherence Score · Benchmarking Engine (fitness percentile) · Demographic Cohort Insights & Network Effects

### Phase 8 — Transformation Journey
Transformation Journey Engine · Transformation Timeline Screen · Habit Identity Layer (behavior science)

### Phase 9 — Social
Social Screen · Squad System · Accountability Communities · Family Health Hub · Activity Feed & Sharing Architecture · Local Geolocation Clubs & Interest Circles · Weekly/Monthly Leaderboards

### Phase 10 — Predictive & Clinical Health
Health Risk Prevention System · Biological Age Estimation · Monthly Health Report · Injury Risk Engine · Stress Detection Engine (inferred) · Clinical Report Intelligence (lab data) · Longevity Score · Continuous Biomarker (CGM) Sync · Medication Tracker & Interaction Warnings · Doctor Sharing Portal · Regulatory & Clinical Compliance Framework · Retrospective Glycemic Processing Pipeline

### Phase 11 — Visual Body Analytics
Body Analytics Screen · Progress Photo System · Wearable-Free Body Composition Estimation

### Phase 12 — Festival & Life Events
Festival Intelligence System · Life Events Engine · Wedding Transformation Mode · AI Roast Mode · Travel Intelligence (Travel Mode) · Smart Calendar Integration

### Phase 13 — Monetisation
Subscription Tiers · Creator & Coach Marketplace · Creator Affiliate Program

### Phase 14 — Enterprise Hardening
Security · Performance · Testing Strategy · CI/CD Pipeline

### Phase 15 — Advanced Intelligence
Adaptive Metabolism Engine (deepened) · Longevity Score (deepened) · Environmental Health Layer (deepened)

### Phase 16 — India Growth & Trust Layer
WhatsApp Business Logging · Vernacular Voice Logging · ABHA Health ID Integration · Corporate Wellness & Insurer Tier · Grocery Vendor Checkout Integration

---

## §P0-H. Security (Firebase-specific)

- **Firestore Security Rules** enforce per-user data isolation (`request.auth.uid == resource.data.ownerId` pattern) at the database layer — not just in application code.
- **Cloud Storage Security Rules** similarly gate access to progress photos, meal photos, and clinical report uploads by owner UID.
- **Sensitive health data** (clinical reports, blood pressure, glucose) additionally requires biometric re-auth (`local_auth` package) before display, even after Firebase Auth session is valid.
- **App Check** enabled to ensure only the genuine app (not scripted clients) can call Cloud Functions and read/write Firestore.
- **Secrets** (Groq API key, RevenueCat webhook secret) stored in Firebase Functions config / Secret Manager — never shipped in the client.

---

## §P0-I. Monetisation (RevenueCat, unchanged)

Subscription tiers gate features by AI/infra cost, mirroring competitor tiering (see Phase 13 for full detail). Entitlement verification is **server-side only** — a Cloud Function validates RevenueCat webhook events and writes the entitlement to the user's Firestore profile; the client never self-reports premium status.

---

*End of v2.0 master documentation. See `README.md` for setup, `TODO.md` for the phase-by-phase execution checklist (the working command file for AI-IDE-assisted development), and `SKILL.md` for the AI coding agent's operating instructions on this repo.*
