# FitKarma Architecture Overview — Offline-First & Health OS Brain

## 1. System Architecture

FitKarma v2.0 is built as a reactive, offline-first health operating system connecting Flutter clients with Firebase Cloud Functions, Firestore, and Groq multi-tier AI models.

```
┌────────────────────────────────────────────────────────┐
│                     Flutter Client                     │
│  - Riverpod State Management                           │
│  - Firestore SDK (Offline Persistence Enabled)         │
│  - Hive Local Cache (Transient & High-Frequency Drafts)│
│  - Pure Dart Deterministic Engines (Readiness, Math)   │
└───────────────────────────┬────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              │ Firestore Sync            │ Callable Functions
              │ (Atomic Increment/Writes) │ (HTTPS Request/Response)
              ▼                           ▼
┌───────────────────────────┬────────────────────────────┐
│      Firebase Storage     │  Firebase Cloud Functions  │
│  - Firestore NoSQL Store  │  - Health OS Orchestration │
│  - Cloud Storage (Photos) │  - AI Router (Groq Tiers)  │
│  - Firebase Auth          │  - Webhook Handlers        │
│  - FCM Notifications      │  - Scheduled Fan-Out DIP   │
└───────────────────────────┴─────────────┬──────────────┘
                                          │
                                          ▼
                               ┌─────────────────────┐
                               │ Groq Multi-Model AI │
                               │  - Tiny (Llama 8B)  │
                               │  - Medium (70B)     │
                               │  - Large (70B/Synth)│
                               └─────────────────────┘
```

---

## 2. Core Pillars

### 2.1 Offline-First Data Strategy
1. **Reads & Writes**: Firestore SDK offline persistence caches user documents locally. When offline, queries return cached data immediately and writes are queued locally.
2. **High-Frequency & Draft Data**: Active workout sessions and unsaved form states use Hive local storage (`LocalStorageService`) to avoid excessive cloud sync rounds while guaranteeing zero data loss during app restart.
3. **Cumulative Counters**: Daily steps, hydration volumes (ml), and Karma points are synced using atomic `FieldValue.increment()` operations. This prevents race conditions and overwrite anomalies when syncing across intermittent networks.
4. **Idempotent Actions**: Discrete events (e.g. workout completion, challenge milestones) carry an `idempotencyKey` to ensure backend Cloud Functions do not double-award badges or Karma points.
5. **Server Clock Reliance**: Critical event sequences utilize `FieldValue.serverTimestamp()` to eliminate device clock skew vulnerabilities.

---

### 2.2 Health OS Brain Orchestration
1. **Centralized Daily Intelligence Package (DIP)**:
   - Generated once daily per active user via Cloud Function (`generateDailyIntelligencePackage`).
   - Reads previous day's nutrition, workouts, sleep stages, recovery soreness, and environmental parameters (AQI, UV, heat).
   - Writes the computed bundle to `/users/{uid}/healthOS/{date}`.
2. **Deterministic-First Safety Hierarchy**:
   - Deterministic algorithms calculate exact health score, readiness score, and adaptive macronutrient targets in pure Dart/JS.
   - Deterministic safety overrides (illness, excessive training load, high heat index) strictly bound AI suggestions.
3. **Groq AI Layer**:
   - Cloud Functions synthesize human-like coaching briefings based on the precomputed deterministic numbers.
   - The briefing is cached in the DIP document, ensuring fast sub-50ms screen opens with zero repetitive LLM billing costs.
