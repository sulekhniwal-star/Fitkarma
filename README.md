# FitKarma — India's Intelligent Health Operating System 🇮🇳🧘‍♂️

FitKarma is an offline-first, intelligent health operating system that unifies fitness, nutrition, sleep, biomarkers, and Ayurvedic wisdom into a daily actionable plan built specifically for Indian food, languages, and digital health rails.

---

## 🏗️ Architecture & Technology Stack

- **Client**: Flutter 3.24.x (cross-platform iOS & Android)
- **State Management**: Riverpod 2.x
- **Local Persistence & Offline Cache**: Drift (SQLite) with encrypted `SQLCipher` support & Outbox Mutation Sync (`OutboxSyncWorker`).
- **Backend & Database**: Supabase (PostgreSQL with Row Level Security, Storage Buckets, and Deno Edge Functions).
- **AI Intelligence**: Groq Server-Side LLM routing via Edge Functions (`coach-message`, `parse-voice`, etc.) with strict privacy scoping.
- **Design System**: Glassmorphic Bento Card UI, concentric Activity Rings, bilingual labels (English + Hindi), HSL neon accents (`#00E5FF` Cyan, `#00E676` Emerald, `#FFB300` Amber, `#FF5252` Coral).

---

## 🚀 Implemented Phases & Features (All 16 Phases Complete)

1. **Phase 0 — Foundation & Design System**:
   - BentoCard glassmorphism layout, concentric ActivityRings, GlowingMetric, BilingualLabel.
   - Drift schema base + OutboxSyncWorker for offline write-ahead queuing.

2. **Phase 1 — Onboarding & Cultural Baseline**:
   - Asian-Indian BMI classifications (Overweight >= 23.0, Obese >= 25.0).
   - 3-Dosha scoring engine (Vata, Pitta, Kapha).
   - Women's cyclical hormonal phase engine (Follicular, Ovulatory, Luteal, Menstrual).

3. **Phase 2 — Daily Mission & Readiness Operating System**:
   - 3-tier confidence readiness engine (Wearable biometrics -> Sleep duration -> Subjective check-in).
   - Sleep debt intelligence & recovery prescription engine (4-7-8 Pranayama, targeted foam rolling).
   - Interactive muscle soreness map with compensatory workout substitutions.

4. **Phase 3 — AI Adaptive Coach (Sharma Ji's AI)**:
   - Dynamic coach context builder (Dosha + Readiness + Calorie budget + Cultural diet).
   - Supabase Edge Function `coach-message` with Groq routing.
   - Escalation layer for 1-on-1 certified human functional medicine coaches.

5. **Phase 4 — Health & Wearable Telemetry**:
   - Wearable comparative engine (Apple Health, Health Connect, Garmin, Fitbit, WHOOP, Oura).
   - Preventive cardiometabolic screening (TG/HDL ratio, atherogenic index).
   - Real-time CGM spike telemetry and post-meal walking intervention alerts.

6. **Phase 5 — Smart Indian Nutrition Engine**:
   - 50+ regional Indian dishes (Roti, Dal, Paneer, Dosa, Idli, Khichdi, Biryani).
   - Native serving units (Katori, Roti, Piece, Grams).
   - Diabetic & PCOS food swapper (e.g. White rice -> Cauliflower/Foxtail Millet).
   - Festival feast damage control & sattvic grocery optimizer.

7. **Phase 6 — Progressive Workout Engine**:
   - Desi Strength Database (Desi Dand, Baithak, Akhada Gada/Jori swings, Surya Namaskar).
   - Progressive overload calculator & fatigue monitoring.
   - Movement intelligence & warm-up sequencing.

8. **Phase 7 — Gamification & Social Sangha**:
   - KarmaEngine with streak multipliers (1.0x to 1.5x) and Yogi tiers (Novice to Guru).
   - 4-Pillar daily adherence index (Nutrition, Workout, Recovery, Mind).
   - Cohort benchmarking against Indian age-matched demographics.

9. **Phase 8 — Transformation Journey & Habit Identity**:
   - 5-stage habit transformation journey (Novice to Transformed Master).
   - Automatic milestone unlocks (5kg lost, 4-week streak, 100k steps).
   - Visual transformation timeline with milestone badge cards.

10. **Phase 9 — Social & Family Health Hub**:
    - Squad accountability with bilingual nudges.
    - Family health monitoring for elderly parents (BP/glucose critical alerts, Pranam/Ashirwad blessings).
    - City clubs & community feed.

11. **Phase 10 — Predictive & Clinical Health**:
    - Multi-parametric biological age engine (chronological vs cellular age delta).
    - South Asian cardiometabolic risk scoring (MetSyn criteria).
    - Acute:Chronic Workload Ratio (ACWR) injury risk engine.
    - Clinical lab report intelligence & medication food-interaction safety shield.

12. **Phase 11 — Visual Body Analytics**:
    - Wearable-free U.S. Navy body composition adapted for Indian anthropometry.
    - Waist-to-Height Ratio (WHtR) central adiposity risk index (<0.50 threshold).
    - Fat-Free Mass Index (FFMI) & before/after visual delta analytics.

13. **Phase 12 — Festival & Life Events**:
    - Navratri, Ramadan, Diwali, and Karwa Chauth fasting/feasting intelligence.
    - 12-week Shaadi transformation mode (garment-fit waist sculpting & peak week anti-bloat protocol).
    - Sharma Ji AI roast generator with redemption missions.
    - Hotel room HIIT & business travel digestion shield.

14. **Phase 13 — Monetisation & Coach Marketplace**:
    - Multi-tiered memberships (Yogi Free, FitKarma Pro ₹199/mo, FitKarma Elite ₹999/mo).
    - Verified Indian functional medicine and fitness coach marketplace.
    - Creator & Yogi affiliate referral network (`YOGI-XXXX` codes with Karma & UPI commissions).

15. **Phase 14 — Enterprise Hardening & CI/CD**:
    - Digital Personal Data Protection (DPDP) Act 2023 right-to-erasure Edge Function (`delete-user-data`).
    - Automated Sentry PII scrubber for phone numbers, ABHA IDs, and credentials.
    - Performance latency monitoring (<1.2s cold start, 60fps frame budget, <100ms DB queries).
    - Complete GitHub Actions CI/CD workflows (`flutter-ci.yml`, `supabase-migrate.yml`, `rls-test.yml`, `release.yml`).

16. **Phase 15 — Advanced Intelligence (Metabolism, Longevity & Environment)**:
    - Dynamic TDEE adaptation engine with metabolic slowdown detection and carb refeed prescriptions.
    - 4-Pillar Longevity Score (0-100) and healthspan projection.
    - Indian city AQI intelligence (Delhi smog defense, Mumbai humidity index) with indoor workout substitutions.

17. **Phase 16 — India Growth & Trust Layer**:
    - Ayushman Bharat Digital Mission (ABDM) 14-digit ABHA Health ID integration with HL7 FHIR export.
    - WhatsApp Business natural language & voice note logging (`whatsapp-webhook`).
    - Vernacular voice NLP supporting Hinglish, Hindi, and English meal/workout extraction.
    - Corporate wellness team scoring with group health insurer premium discounts.
    - Quick-Commerce comparative grocery shopping (Blinkit, Zepto, Instamart) with 1-click cart export.

---

## 🧪 Verification & Quality Assurance

- **Unit & Integration Tests**: 159/159 automated tests passing (`flutter test`).
- **Static Analysis**: 0 issues, 0 warnings (`flutter analyze`).
- **Data Integrity**: Complete Drift SQL schema (43 tables) with Supabase Row Level Security (RLS) migrations for every table.

---

## 🛠️ Running Locally

```bash
# 1. Install dependencies
flutter pub get

# 2. Run code generation (Drift & Riverpod)
dart run build_runner build

# 3. Run all tests
flutter test

# 4. Start the application
flutter run
```
