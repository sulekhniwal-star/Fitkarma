# FitKarma — Master Documentation (v2.0)
### India's Intelligent Health Operating System
**Flutter 3.x · Dart · Riverpod 2.x · Firebase (Firestore, Cloud Functions v2, Auth, Storage, FCM) · RevenueCat · Multi-Model AI (Groq)**

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
5. **DPDP Act 2023 Compliance**: Built-in cryptographic right-to-erasure cascading deletion (`deleteUserData`) across all collections and storage assets.

---

## 2. Technical Stack & Infrastructure

| Layer | Implementation | Notes |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter 3.x / Dart | Android, iOS, Web & Desktop responsive architecture |
| **State Management** | Riverpod 2.x (`StateNotifierProvider`) | Immutable states, reactive dependency graph |
| **Database** | Firebase Cloud Firestore | User data isolation, offline caching enabled |
| **Backend Compute** | Firebase Cloud Functions v2 (Node.js) | AI Groq routing, DIP orchestration, webhooks, cascading deletion |
| **Authentication** | Firebase Authentication | Phone OTP, Google Sign-In, ABHA M1 Token auth |
| **File Storage** | Firebase Cloud Storage | Progress photos, food vision snaps, clinical PDF dossiers |
| **AI Multi-Model Router** | Server-side Groq SDK | Llama-3.3-70b (Complex coaching), Mixtral (Fast analysis), Llama-3.2-11b (Vision) |
| **Monetisation** | RevenueCat SDK | Server-verified webhooks, entitlement management |

---

## 3. Master Phase Architecture Matrix

### Phase 0–4: Foundations & Tracking
- **Phase 0 (Foundation)**: Glassmorphic Bento design system (`BentoCard`, `ActivityRings`, `GlowingMetric`, `BilingualLabel`), Health OS Brain, AI routing layer.
- **Phase 1 (Onboarding)**: Demographics, BMI calibrator, Dosha scoring (Vata/Pitta/Kapha), Women's Health (cycle-aware training, PCOS management).
- **Phase 2 (Daily Mission & Readiness)**: 3-tier readiness confidence model, morning briefing, body soreness heatmaps, sleep debt modeling.
- **Phase 3 (AI Adaptive Coach)**: Multi-model prompt context builders, local caching, proactive event-driven coaching.
- **Phase 4 (Health Tracking)**: Step counters, sleep stages, biometric-gated blood pressure, wearable late-sync conflict resolution.

### Phase 5–8: Nutrition, Training & Retention
- **Phase 5 (Smart Indian Nutrition)**: 18 specialized engines: Satiety prediction, Glycemic response, Indian food swaps, Grocery optimization, Restaurant OCR, Festival adaptation, Micronutrient intelligence.
- **Phase 6 (Workout System)**: Progressive overload engine, computer vision pose estimation, movement biomechanics trajectories.
- **Phase 7 (Gamification)**: Karma points, habit streaks, demographic cohort percentile benchmarking.
- **Phase 8 (Transformation Journey)**: Psychological identity shift tracking, milestone timelines.

### Phase 9–13: Social, Predictive Health & Monetisation
- **Phase 9 (Social & Squads)**: Geolocation clubs, family health hub, squad challenges, community feeds.
- **Phase 10 (Predictive Health)**: CGM retrospective glycemic pipeline, biological age engine, drug-herb interaction screener, doctor dossier export.
- **Phase 11 (Visual Body Analytics)**: Privacy-preserving photo comparison, wearable-free body composition.
- **Phase 12 (Festival & Travel)**: Wedding transformation mode, travel intelligence, AI Roast mode, smart calendar sync.
- **Phase 13 (Monetisation)**: Subscription tiers (Free, Karma Pro, FitKarma Elite), Coach & Creator Marketplace.

### Phase 14–16: Enterprise, Advanced Intelligence & India Trust Layer
- **Phase 14 (Enterprise Hardening)**: Security posture evaluator, App Check, performance profiler, unified test runner (145/145 passing tests).
- **Phase 15 (Advanced Intelligence)**:
  - **Adaptive Metabolism Engine**: Dynamic TDEE tracker, adaptive thermogenesis detection, reverse dieting protocols.
  - **Longevity Score**: 7 Hallmarks of aging synthesis, VO2 max / HRV / Visceral fat multi-pillar composite.
  - **Environmental Health Layer**: Real-time AQI mitigation, Wet-Bulb Heat Index, UV index workout adjustments.
- **Phase 16 (India Growth & Trust Layer)**:
  - **WhatsApp Business Logging**: Meta Cloud API interactive templates, quick text parsing.
  - **Vernacular Voice Logging**: Multi-lingual transcription, Hinglish code-switching, local food entity extraction.
  - **ABHA Health ID Integration**: ABDM compliance, 14-digit ABHA validation, FHIR clinical records sync.
  - **Corporate Wellness & Insurer Tier**: B2B enterprise dashboards, ergonomic posture alerts, 20% health insurance rebate engine.
  - **Grocery Vendor Checkout Integration**: Multi-vendor quick-commerce price matrix (Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh, Local Kirana WhatsApp).

---

## 4. Privacy, Security & DPDP Act 2023 Compliance

### 1. User Isolation via Security Rules
All personal telemetry collections are nested under `/users/{userId}/*` and guarded by strict owner-only Firestore and Storage rules.

### 2. Cascading Right-to-Erasure (`deleteUserData`)
In compliance with Section 12 of the Indian Digital Personal Data Protection (DPDP) Act 2023:
- Triggered by user account deletion request via Cloud Function.
- Cascades across 23 subcollections (`meals`, `biomarkers`, `cgm_telemetry`, `voice_logs`, `abha_records`, etc.).
- Cleans cross-referencing collections (`squads`, `clubs`, `communities`, `doctor_access_grants`).
- Purges all cloud storage media (`users/{uid}/*`, `meals/{uid}/*`, `clinical/{uid}/*`).
- Generates an immutable, anonymized cryptographic receipt in `erasure_receipts/{receiptId}` without retaining personal data.

---

## 5. Verification & Testing

Every single engine and presentation layer is verified offline:
- **145/145 Automated Unit & Widget Tests Passing**.
- **0 Issues on `flutter analyze`**.
- Standalone feature documentation located in `docs/` and feature folders.
