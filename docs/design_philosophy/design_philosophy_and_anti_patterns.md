# Design Philosophy & Anti-Patterns — FitKarma

## Overview
FitKarma is India's Intelligent Health Operating System. This document and its accompanying guidelines codify the foundational design principles, architectural rules, and explicit anti-patterns that govern all development in this codebase.

---

## 1. Core Design Philosophy

### 1.1 Decision Engine & Operating System (Not a Passive Tracker)
- FitKarma does not merely log data into tables; it synthesizes daily inputs into proactive, personalized decisions.
- Every metric leads to an actionable recommendation via the **Health OS Brain**.

### 1.2 Health OS Brain — Centralized Intelligence
- Avoid fragmented, per-screen AI calls.
- The Health OS Brain runs an orchestrated **Daily Intelligence Package (DIP)** cycle that processes previous-day logs, rolling averages, circadian signals, and environmental data into a single unified health package.
- Modules and UI screens read from this cached daily intelligence package rather than re-querying or re-prompting the AI.

### 1.3 Strict Deterministic vs. AI Separation
- **Deterministic Logic (Pure Dart / Cloud Functions):**
  - All mathematical calculations, health scores, TDEE, BMI, progressive overload algorithms, habit streaks, and safety threshold checks are written in pure, unit-tested Dart or deterministic Node.js functions.
  - Zero AI hallucinations in core calculations; 100% reliable offline.
- **AI Logic (Groq Multi-Model Router via Cloud Functions):**
  - Reserved strictly for unstructured language understanding, natural language coaching, meal photo analysis, voice parsing, and personalized narrative synthesis.
  - AI operates strictly *within* deterministic boundaries and safety guardrails.

### 1.4 Offline-First Resilience
- All daily logging (meals, workouts, steps, hydration, recovery, mood) must work seamlessly without active internet connectivity.
- Firestore offline persistence provides automatic local caching.
- Hive is utilized for high-frequency, transient, or draft local state (e.g., active workout in progress).

### 1.5 Built for India
- Deep Indian nutrition taxonomy (regional cuisines, home-cooked food preparations, macro substitutions).
- Localized factors: festival adaptations, fasting modes (Navratri, Ramadan, etc.), seasonal environmental layers (AQI, UV, Heatwaves).
- Bilingual support (`BilingualLabel`) and phone/OTP-first authentication.

### 1.6 Premium Sensory UI / UX
- Dark mode primary design system.
- Bento-grid dashboard layouts with glassmorphic cards (`BentoCard`).
- Smooth spring-physics animations for biometric rings (`ActivityRings`) and metric celebrations (`GlowingMetric`).
- Platform-adaptive feel: Material 3 base with Cupertino components on iOS where native interactions matter.

---

## 2. Explicit Anti-Patterns

| Category | Anti-Pattern (DO NOT DO) | Correct Pattern (DO THIS) |
|---|---|---|
| **AI Architecture** | Direct client-side calls to Groq/OpenAI with embedded API keys | All AI calls go through Firebase Cloud Functions (`aiRouter`), keeping keys in Secret Manager. |
| **AI Redundancy** | Calling AI independently on multiple screens for the same daily context | Generate the Daily Intelligence Package once in the Health OS Brain; screens read the cached package. |
| **Computation** | Using LLMs for calculations (e.g., asking AI to calculate BMI, deficit, or 1RM) | Pure Dart deterministic functions with zero network latency and 100% precision. |
| **Data Access** | Scattered `FirebaseFirestore.instance` calls inside Flutter widgets | Dedicated feature repository classes (e.g., `NutritionRepository`) accessed via Riverpod providers. |
| **State Management** | Global mutable singletons or raw `setState` for domain data | Feature-scoped Riverpod `Notifier` / `AsyncNotifier` providers. |
| **Security** | Default-open Firestore/Storage security rules (`allow read, write: if true;`) | Strict owner-isolated rules (`request.auth.uid == userId`) accompanying every new collection/path. |
| **Offline Sync** | Read-modify-write on cumulative counters (steps, points) causing race conditions | Atomic Firestore `FieldValue.increment()` and idempotent batch syncs. |
| **Timestamps** | Relying on client device clock for streaks or mission resets | Use Firestore `FieldValue.serverTimestamp()` and per-user timezone offsets to prevent clock skew exploits. |
| **Localization** | Hardcoded English-only strings with no regional language readiness | Use localization tokens and `BilingualLabel` components for key health metrics and actions. |

---

## 3. Implementation Checklist for Every Feature

Every future feature built in FitKarma must adhere to this design philosophy:
1. **Spec Alignment:** Verified against `FitKarma_Documentation.md`.
2. **Offline Usability:** Core logging and review flows verified offline.
3. **Security:** Firestore and Cloud Storage security rules locked to authenticated owner.
4. **Clean Layering:** Clean separation between presentation (Riverpod), data (Repository), and backend (Cloud Functions).
5. **Feature Documentation:** Standalone `README.md` created in the feature directory.
