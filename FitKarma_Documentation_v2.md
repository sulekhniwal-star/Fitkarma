# FitKarma — Master Documentation (v2.1)
### India's Intelligent Health Operating System
**Flutter 3.x · Dart · Riverpod 2.x · Supabase (Postgres, Auth, Storage, Edge Functions, Realtime) · RevenueCat · Multi-Model AI (Groq)**

> Offline-first · Privacy-centric · Built for India · AI-adaptive · DPDP Act 2023 Compliant
> Dark mode primary (`#0D0F12`) · Glassmorphism · Spring physics · Bento grid · Bilingual Hindi/English

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
| **Database** | Supabase Postgres | Row Level Security (RLS) per user, `pgvector` available for future embedding search |
| **Backend Compute** | Supabase Edge Functions (Deno/TypeScript) | AI Groq routing, DIP orchestration, webhooks, cascading deletion; Postgres Functions/Triggers for in-DB logic |
| **Authentication** | Supabase Auth (GoTrue) | Phone OTP, Google Sign-In (OAuth), custom JWT claim for ABHA M1 Token auth |
| **File Storage** | Supabase Storage | Progress photos, food vision snaps, clinical PDF dossiers; bucket-level RLS policies |
| **Realtime / Sync** | Supabase Realtime (Postgres logical replication) | Live squad feeds, doctor-shared dossier updates |
| **AI Multi-Model Router** | Server-side Groq SDK (called from Edge Functions) | Llama-3.3-70b (Complex coaching), Mixtral (Fast analysis), Llama-3.2-11b (Vision) |
| **Monetisation** | RevenueCat SDK | Server-verified webhooks → Edge Function → Postgres entitlement table |
| **Push Notifications** | Firebase Cloud Messaging (FCM) — retained standalone | Supabase has no native push service; FCM device tokens stored in Postgres and invoked from Edge Functions |

**Migration notes (Firebase → Supabase):**
- Firestore's automatic offline cache has no direct Supabase equivalent. Offline-first behavior needs to be rebuilt explicitly — either a local Drift/SQLite cache with a sync queue, or a managed layer like PowerSync/ElectricSQL sitting on top of Postgres. This should be decided before Phase 4 (Health Tracking) work resumes, since late-sync conflict resolution depends on it.
- Firebase Security Rules become Postgres **Row Level Security policies** (one policy set per table, keyed on `auth.uid() = user_id`), rather than path-based rules.
- Cloud Functions v2 triggers (`onCreate`/`onWrite`) become **Postgres triggers** or **Database Webhooks** calling Edge Functions.
- FCM is kept as a separate, standalone service since Supabase does not provide push notifications.

---

## 3. Master Phase Architecture Matrix

### Phase 0–4: Foundations & Tracking
- **Phase 0 (Foundation)**: Glassmorphic Bento design system (`BentoCard`, `ActivityRings`, `GlowingMetric`, `BilingualLabel`), Health OS Brain, AI routing layer.
- **Phase 1 (Onboarding)**: Demographics, BMI calibrator, Dosha scoring (Vata/Pitta/Kapha), Women's Health (cycle-aware training, PCOS management).
- **Phase 2 (Daily Mission & Readiness)**: 3-tier readiness confidence model, morning briefing, body soreness heatmaps, sleep debt modeling.
- **Phase 3 (AI Adaptive Coach)**: Multi-model prompt context builders, local caching, proactive event-driven coaching.
- **Phase 4 (Health Tracking)**: Step counters, sleep stages, biometric-gated blood pressure, wearable late-sync conflict resolution (now dependent on the chosen offline-sync layer — see Migration notes above).

### Phase 5–8: Nutrition, Training & Retention
- **Phase 5 (Smart Indian Nutrition)**: 18 specialized engines: Satiety prediction, Glycemic response, Indian food swaps, Grocery optimization, Restaurant OCR, Festival adaptation, Micronutrient intelligence.
- **Phase 6 (Workout System)**: Progressive overload engine, computer vision pose estimation, movement biomechanics trajectories.
- **Phase 7 (Gamification)**: Karma points, habit streaks, demographic cohort percentile benchmarking.
- **Phase 8 (Transformation Journey)**: Psychological identity shift tracking, milestone timelines.

### Phase 9–13: Social, Predictive Health & Monetisation
- **Phase 9 (Social & Squads)**: Geolocation clubs, family health hub, squad challenges, community feeds (powered by Supabase Realtime).
- **Phase 10 (Predictive Health)**: CGM retrospective glycemic pipeline, biological age engine, drug-herb interaction screener, doctor dossier export.
- **Phase 11 (Visual Body Analytics)**: Privacy-preserving photo comparison, wearable-free body composition.
- **Phase 12 (Festival & Travel)**: Wedding transformation mode, travel intelligence, AI Roast mode, smart calendar sync.
- **Phase 13 (Monetisation)**: Subscription tiers (Free, Karma Pro, FitKarma Elite), Coach & Creator Marketplace.

### Phase 14–16: Enterprise, Advanced Intelligence & India Trust Layer
- **Phase 14 (Enterprise Hardening)**: Security posture evaluator (RLS policy audit), Supabase project-level API key rotation, performance profiler, unified test runner (145/145 passing tests).
- **Phase 15 (Advanced Intelligence)**:
  - **Adaptive Metabolism Engine**: Dynamic TDEE tracker, adaptive thermogenesis detection, reverse dieting protocols.
  - **Longevity Score**: 7 Hallmarks of aging synthesis, VO2 max / HRV / Visceral fat multi-pillar composite.
  - **Environmental Health Layer**: Real-time AQI mitigation, Wet-Bulb Heat Index, UV index workout adjustments.
- **Phase 16 (India Growth & Trust Layer)**:
  - **WhatsApp Business Logging**: Meta Cloud API interactive templates, quick text parsing (handled via Edge Function webhook).
  - **Vernacular Voice Logging**: Multi-lingual transcription, Hinglish code-switching, local food entity extraction.
  - **ABHA Health ID Integration**: ABDM compliance, 14-digit ABHA validation, FHIR clinical records sync, custom JWT issued through Supabase Auth.
  - **Corporate Wellness & Insurer Tier**: B2B enterprise dashboards, ergonomic posture alerts, 20% health insurance rebate engine.
  - **Grocery Vendor Checkout Integration**: Multi-vendor quick-commerce price matrix (Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh, Local Kirana WhatsApp).

---

## 4. Privacy, Security & DPDP Act 2023 Compliance

### 1. User Isolation via Row Level Security
All personal telemetry tables carry a `user_id` column referencing `auth.users(id)` and are guarded by Postgres **Row Level Security (RLS)** policies (`auth.uid() = user_id`) for both table access and Storage bucket access — replacing Firestore/Storage path-based security rules.

### 2. Cascading Right-to-Erasure (`delete_user_data`)
In compliance with Section 12 of the Indian Digital Personal Data Protection (DPDP) Act 2023:
- Triggered by user account deletion request via a Supabase Edge Function (service-role key, never exposed client-side).
- Cascades across 23 tables (`meals`, `biomarkers`, `cgm_telemetry`, `voice_logs`, `abha_records`, etc.) — implemented via `ON DELETE CASCADE` foreign keys where possible, and an explicit RPC (`delete_user_data`) for tables needing custom handling.
- Cleans cross-referencing tables (`squads`, `clubs`, `communities`, `doctor_access_grants`).
- Purges all Supabase Storage objects (`users/{uid}/*`, `meals/{uid}/*`, `clinical/{uid}/*`).
- Generates an immutable, anonymized cryptographic receipt in the `erasure_receipts` table without retaining personal data.

---

## 5. Verification & Testing

Every single engine and presentation layer is verified offline:
- **145/145 Automated Unit & Widget Tests Passing**.
- **0 Issues on `flutter analyze`**.
- RLS policies covered by Supabase's local Postgres test harness (`supabase test db`) in addition to Flutter widget/unit tests.
- Standalone feature documentation located in `docs/` and feature folders.