# FitKarma — Master Documentation (v2.2)
### India's Intelligent Health Operating System
**Flutter 3.x · Dart · Riverpod 2.x · Supabase (Postgres, Auth, Storage, Edge Functions, Realtime) · RevenueCat · Multi-Model AI (Groq)**

> Offline-first · Privacy-centric · Built for India · AI-adaptive · DPDP Act 2023 Compliant
> Dark mode primary (`#0D0F12`) · Glassmorphism · Spring physics · Bento grid · Bilingual Hindi/English
> Package ID: `com.sulekhniwal.fitkarma` · Solo-founder build · Companion admin platform: **FitKarma Hub**

---

## 0. Project Context

- **Founder**: solo build, one-year timeline (started Aug 2026).
- **Status**: through Phase 9 of 16 on the previous stack; this doc governs the Supabase rebuild of the backend layer — the Flutter/Riverpod frontend and the 16-phase feature roadmap are unchanged.
- **Near-term goal**: a fully demoable build, including working monetisation, for a college major-project submission (placement team will be present) — before the broader startup launch, which will follow additional legal/medical/trainer review.
- **Companion product**: **FitKarma Hub**, an admin/ops platform (5 workspaces, ~418 tasks across 31 sections) that will read/write the same Supabase project via service-role Edge Functions rather than direct client access.
- **Dev environment**: VS Code, GitHub Actions CI/CD (Android + iOS), ADB wireless debugging (Pixel 6a), Sentry for crash/error monitoring.

---

## 1. System Overview & Vision

FitKarma is **India's intelligent health operating system** — an adaptive system that synthesizes multi-modal telemetry (continuous glucose monitors, wearable biometrics, circadian sleep metrics, nutrition, Indian macro profiles, environmental health AQI/UV, and Ayurvedic ritu-charya) into an actionable daily intelligence cycle.

### Key Moats:
1. **Health OS Brain**: Central intelligence layer orchestrating a daily intelligence package (DIP) without redundant AI calls.
2. **Deep Indian Nutrition Moat**: Seeded database of 500+ regional Indian recipes, street foods, festival adaptations, vegetarian protein optimization (Sattu, Soya, Sprouted Moong, Paneer), and quick-commerce integration.
3. **Clinical & Preventive Longevity**: Continuous biomarker CGM pipeline, biological age estimation, Thin-Fat phenotype risk mitigation, and doctor sharing dossiers.
4. **India Growth & Trust Layer**: WhatsApp Business Meta Cloud API logging, Vernacular Voice logging (Hindi, Hinglish, Tamil, Telugu), Ayushman Bharat Health Account (ABHA ID / ABDM), and Corporate Insurer Tiers.
5. **DPDP Act 2023 Compliance**: Built-in cryptographic right-to-erasure cascading deletion (`delete_user_data`) across all tables and storage assets.

---

## 2. Technical Stack & Infrastructure

| Layer | Implementation | Notes |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter 3.x / Dart | Android, iOS, Web & Desktop responsive architecture |
| **State Management** | Riverpod 2.x (`StateNotifierProvider`) | Immutable states, reactive dependency graph |
| **Local Persistence** | Drift + SQLCipher | Encrypted on-device store; now doubles as the **offline-first cache layer** in front of Supabase (see §2.1) |
| **Remote Database** | Supabase Postgres | Row Level Security (RLS) per user; `pgvector` available for future embedding search (e.g. semantic recipe/food matching) |
| **Backend Compute** | Supabase Edge Functions (Deno/TypeScript) | AI Groq routing, DIP orchestration, webhooks, cascading deletion, RevenueCat webhook verification |
| **In-DB Logic** | Postgres Functions & Triggers | Row-level validation, `updated_at` bookkeeping, fan-out to cross-referencing tables |
| **Authentication** | Supabase Auth (GoTrue) | Phone OTP, Google Sign-In (OAuth), custom JWT claim for ABHA M1 Token auth |
| **File Storage** | Supabase Storage | Progress photos, food vision snaps, clinical PDF dossiers; bucket-level RLS policies mirroring table RLS |
| **Realtime / Sync** | Supabase Realtime (Postgres logical replication, WAL) | Live squad feeds, doctor-shared dossier updates, Hub live dashboards |
| **AI Multi-Model Router** | Groq SDK, called server-side from Edge Functions | Llama-3.3-70b (complex coaching), Mixtral (fast analysis), Llama-3.2-11b (vision — food photo recognition) |
| **Computer Vision** | MediaPipe (on-device, Flutter) | Pose estimation for Phase 6 workout form-checking; landmark data synced to Supabase for progression history |
| **Wearables** | Health Connect (Android) / HealthKit (iOS) | Step counters, sleep stages, HR/HRV; ingested client-side, written to Supabase via batched upserts |
| **Monetisation** | RevenueCat SDK | Server-verified webhooks → Edge Function → Postgres `entitlements` table (fixes the prior client-side-only verification bug) |
| **Push Notifications** | Firebase Cloud Messaging (FCM), standalone | Supabase has no native push service; device tokens stored in `push_tokens` table, invoked from Edge Functions |
| **Monitoring** | Sentry (Flutter + Edge Function error capture) | Crash reporting and Edge Function exception tracking, replacing any Firebase Crashlytics dependency |
| **CI/CD** | GitHub Actions | Android + iOS build pipelines; add `supabase db push`/`supabase functions deploy` as new CI steps replacing `firebase deploy` |

### 2.1 Offline-First Strategy (new, since Firestore's cache is gone)

Firestore previously gave automatic offline persistence for free; Postgres doesn't, so this needs to be built explicitly:

- **Local source of truth**: Drift (already in the stack for SQLCipher-encrypted local storage) becomes the primary read/write surface for the UI. Riverpod providers read from Drift, not directly from Supabase.
- **Sync queue**: a lightweight outbox table in Drift (`pending_mutations`) records writes made while offline; a background worker flushes them to Supabase on reconnect, resolving conflicts with a `last-write-wins` or `updated_at`-based strategy per table (biometric/telemetry tables can safely be append-only to sidestep conflicts entirely).
- **Pull sync**: incremental pulls keyed on `updated_at > last_synced_at` per table, delivered via Edge Function or direct `select` with RLS, rather than a full Firestore-style snapshot listener.
- **Late-sync conflict resolution** (Phase 4, wearable data): append-only `wearable_samples` table keyed on `(user_id, source, timestamp)` with a unique constraint avoids most conflicts; anything needing merge logic (e.g. two devices reporting overlapping sleep stages) is resolved in a Postgres function at insert time.
- Alternative, lower-effort path if the outbox becomes a maintenance burden: adopt PowerSync or ElectricSQL, both of which layer Postgres-backed offline sync onto SQLite and would let Drift be replaced by their client rather than hand-rolling the queue.

---

## 3. Master Phase Architecture Matrix

*(Feature scope unchanged from v1.0 research — based on 2 years of market research via Google Form. Status reflects the previous stack; Phases 0–9 need their data-access layer ported to Supabase, not rebuilt.)*

### Phase 0–4: Foundations & Tracking
- **Phase 0 (Foundation)** ✅ *ported*: Glassmorphic Bento design system (`BentoCard`, `ActivityRings`, `GlowingMetric`, `BilingualLabel`), Health OS Brain, AI routing layer now calling Groq from Edge Functions instead of Cloud Functions.
- **Phase 1 (Onboarding)** ✅ *ported*: Demographics, BMI calibrator, Dosha scoring (Vata/Pitta/Kapha), Women's Health (cycle-aware training, PCOS management) — all stored in RLS-protected `profiles`/`dosha_scores`/`cycle_tracking` tables.
- **Phase 2 (Daily Mission & Readiness)** ✅ *ported*: 3-tier readiness confidence model, morning briefing, body soreness heatmaps, sleep debt modeling.
- **Phase 3 (AI Adaptive Coach)** ✅ *ported*: Multi-model prompt context builders, local (Drift) caching, proactive event-driven coaching triggered by Postgres Database Webhooks instead of Firestore `onWrite` triggers.
- **Phase 4 (Health Tracking)** ⚠️ *needs the offline-sync layer from §2.1 before porting*: Step counters, sleep stages (Health Connect/HealthKit), biometric-gated blood pressure, wearable late-sync conflict resolution.

### Phase 5–8: Nutrition, Training & Retention
- **Phase 5 (Smart Indian Nutrition)**: 18 specialized engines — Satiety prediction, Glycemic response, Indian food swaps, Grocery optimization, Restaurant OCR, Festival adaptation, Micronutrient intelligence. Recipe/food database (500+ entries) migrates to a Postgres table with `pgvector` embeddings for future semantic food-swap search.
- **Phase 6 (Workout System)**: Progressive overload engine, MediaPipe pose estimation, movement biomechanics trajectories — landmark history stored per rep/set in Postgres, keyed to the workout session row.
- **Phase 7 (Gamification)**: Karma points, habit streaks, demographic cohort percentile benchmarking (computed via Postgres materialized views, refreshed on a schedule instead of a scheduled Cloud Function aggregation job).
- **Phase 8 (Transformation Journey)**: Psychological identity shift tracking, milestone timelines.

### Phase 9–13: Social, Predictive Health & Monetisation
- **Phase 9 (Social & Squads)** ✅ *last completed phase pre-migration*: Geolocation clubs, family health hub, squad challenges, community feeds — now powered by Supabase Realtime subscriptions instead of Firestore snapshot listeners.
- **Phase 10 (Predictive Health)**: CGM retrospective glycemic pipeline, biological age engine, drug-herb interaction screener, doctor dossier export (PDF generated in an Edge Function, stored in Supabase Storage, access granted via `doctor_access_grants` RLS policy).
- **Phase 11 (Visual Body Analytics)**: Privacy-preserving photo comparison, wearable-free body composition — photos in a private Storage bucket, signed URLs issued per view.
- **Phase 12 (Festival & Travel)**: Wedding transformation mode, travel intelligence, AI Roast mode, smart calendar sync.
- **Phase 13 (Monetisation)**: Subscription tiers (Free, Karma Pro, FitKarma Elite) + Coach & Creator Marketplace. RevenueCat webhook → Edge Function verifies signature → upserts `entitlements` row (server-side, closing the earlier client-only verification gap). Current pricing plan: reduce Elite margin from ~60% to ~30% (excluding pass-through processor fees) as new tiers are introduced.

### Phase 14–16: Enterprise, Advanced Intelligence & India Trust Layer
- **Phase 14 (Enterprise Hardening)**: Security posture evaluator becomes an RLS-policy linter/audit script; Supabase project API-key rotation; performance profiler; unified test runner (145/145 passing tests) extended with `supabase test db` for policy coverage.
- **Phase 15 (Advanced Intelligence)**:
  - **Adaptive Metabolism Engine**: Dynamic TDEE tracker, adaptive thermogenesis detection, reverse dieting protocols.
  - **Longevity Score**: 7 Hallmarks of aging synthesis, VO2 max / HRV / Visceral fat multi-pillar composite.
  - **Environmental Health Layer**: Real-time AQI mitigation, Wet-Bulb Heat Index, UV index workout adjustments.
- **Phase 16 (India Growth & Trust Layer)**:
  - **WhatsApp Business Logging**: Meta Cloud API interactive templates, quick text parsing via Edge Function webhook.
  - **Vernacular Voice Logging**: Multi-lingual transcription, Hinglish code-switching, local food entity extraction (Groq vision/audio models).
  - **ABHA Health ID Integration**: ABDM compliance, 14-digit ABHA validation, FHIR clinical records sync; ABHA M1 token exchanged for a custom Supabase Auth JWT via an Edge Function.
  - **Corporate Wellness & Insurer Tier**: B2B enterprise dashboards (built against FitKarma Hub), ergonomic posture alerts, 20% health insurance rebate engine.
  - **Grocery Vendor Checkout Integration**: Multi-vendor quick-commerce price matrix (Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh, Local Kirana WhatsApp).

---

## 4. Privacy, Security & DPDP Act 2023 Compliance

### 1. User Isolation via Row Level Security
All personal telemetry tables carry a `user_id` column referencing `auth.users(id)` and are guarded by Postgres **Row Level Security (RLS)** policies (`auth.uid() = user_id`) for both table access and Storage bucket access. FitKarma Hub's admin access bypasses RLS only via the service-role key inside Edge Functions — never from a client SDK.

### 2. Cascading Right-to-Erasure (`delete_user_data`)
In compliance with Section 12 of the Indian Digital Personal Data Protection (DPDP) Act 2023:
- Triggered by a user account deletion request via a Supabase Edge Function (service-role key, never exposed client-side).
- Cascades across 23 tables (`meals`, `biomarkers`, `cgm_telemetry`, `voice_logs`, `abha_records`, etc.) — implemented via `ON DELETE CASCADE` foreign keys where possible, and an explicit RPC (`delete_user_data`) for tables needing custom handling (e.g. anonymizing rather than deleting cohort-benchmark contributions).
- Cleans cross-referencing tables (`squads`, `clubs`, `communities`, `doctor_access_grants`).
- Purges all Supabase Storage objects (`users/{uid}/*`, `meals/{uid}/*`, `clinical/{uid}/*`).
- Generates an immutable, anonymized cryptographic receipt in the `erasure_receipts` table without retaining personal data.
- Legal/medical review teams currently drafting Terms & Privacy Policy should be given this section verbatim, since it's the operative DPDP compliance mechanism.

### 3. Monitoring & Incident Response
- Sentry captures both Flutter client crashes and Edge Function exceptions, giving a single pane for backend errors that previously would have shown up only in Firebase Functions logs.
- Supabase project logs (Postgres, Auth, Storage, Edge Functions) retained per Supabase's plan-level retention; export critical auth/security events to Sentry or a log sink for longer retention if the compliance review requires it.

---

## 5. Verification & Testing

- **145/145 Automated Unit & Widget Tests Passing** (Flutter side, stack-agnostic).
- **0 Issues on `flutter analyze`**.
- RLS policies covered by `supabase test db` (pgTAP) in addition to Flutter widget/unit tests — new test category introduced by the migration; each table's policy set should get at least an "owner can read/write, non-owner cannot" pair.
- Edge Functions covered with Deno's built-in test runner; RevenueCat webhook signature verification and `delete_user_data` cascade are the two highest-priority functions to test given their compliance/billing sensitivity.
- Standalone feature documentation located in `docs/` and feature folders.

---

## 6. Open Decisions Before Continuing the Rebuild

1. **Offline sync approach** (§2.1): hand-rolled Drift outbox vs. PowerSync/ElectricSQL — affects Phase 4 timeline directly.
2. **FitKarma Hub access pattern**: confirm all five Hub workspaces go through service-role Edge Functions rather than a privileged client key, to keep RLS as the single source of truth.
3. **CI/CD**: add `supabase` CLI steps to the existing GitHub Actions pipeline (schema migrations, Edge Function deploy) alongside the existing Android/iOS build jobs.
4. **Pricing rollout**: sequence the margin reduction (60% → 30%) and new tier introduction against the `entitlements` table redesign, so RevenueCat webhook handling doesn't need a second migration.