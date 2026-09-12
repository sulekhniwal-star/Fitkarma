# FitKarma — TODO.md

**This file is the sole working command list for AI-IDE-assisted development on this repo.** Work top to bottom, phase by phase. Do not skip ahead. Before starting any item, read `skil.md` for the required workflow and the doc suite (`architechture.md`, `data_model.md`, `api_contract.md`, `ui_spec.md`, etc.) for that feature's spec detail — see `master_rules.md` §1 for the full lookup order.

**Every feature item below expands to the same 5-step checklist (per `skil.md` §4 / `master_rules.md` §5):**
1. Implement per spec section
2. Verify offline behavior where required
3. Add/update Supabase RLS & Storage bucket policies for any new data paths
4. **Write the feature's own `README.md`** (mandatory — see `skil.md` §3)
5. Check this box off

> **Stack note**: every phase below (0–16) was built and checked off against the **Firebase** stack (Firestore/Cloud Functions/Auth/Storage). The backend has since moved to **Supabase** (see `decisions.md` ADR-001). These checkboxes are left checked as a historical record that the feature/UI/logic is implemented — they are **not** a claim that the data-access layer is already Supabase-backed. The actual outstanding work is tracked in the new **Migration — Firebase → Supabase Port** section below, which is the real "top of the list" right now; treat it as inserted before continuing to any net-new phase work, per `microtasks.md`.

---

## Migration — Firebase → Supabase Port (current priority, see `microtasks.md` for the granular breakdown)

Work this section phase-by-phase, in order, same discipline as everything below it — don't port Phase 5 before Phase 4 is done. Each phase's port expands to:
1. Re-point the feature's repository layer from Firestore calls to Supabase client calls
2. Add/verify RLS policies for every table the feature touches (`data_model.md`)
3. Port any Cloud Function used by the feature to an Edge Function (`api_contract.md`)
4. Re-verify offline behavior against the new Drift outbox/sync layer (`architechture.md` §4) — do not assume Firestore's old offline cache behavior still holds
5. Update the feature's `README.md` to reflect the Supabase-backed implementation
6. Check this box off

- [x] **Phase 0 — Foundation** (Health OS Brain, AI routing layer → Groq via Edge Functions)
- [x] **Phase 1 — Onboarding** (profiles, dosha_scores, cycle_tracking tables)
- [x] **Phase 2 — Daily Mission + Readiness** (readiness_scores, dip_cache)
- [x] **Phase 3 — AI Adaptive Coach** (coach_sessions/coach_messages, Cloud Function coach endpoint → `coach-message` Edge Function)
- [ ] **Phase 4 — Health Tracking** (wearable_samples/biomarkers/cgm_telemetry — **blocked on the offline-sync decision in `decisions.md` ADR-002** before porting late-sync conflict resolution)
- [ ] **Phase 5 — Smart Indian Nutrition** (recipes with pgvector, meals, grocery_price_matrix)
- [ ] **Phase 6 — Workout System** (workout_sessions/workout_sets, MediaPipe landmark storage)
- [ ] **Phase 7 — Gamification** (karma_points ledger, habit_streaks, cohort_benchmarks materialized view)
- [ ] **Phase 8 — Transformation Journey**
- [ ] **Phase 9 — Social** (squads/clubs/communities → Supabase Realtime instead of Firestore snapshot listeners)
- [ ] **Phase 10 — Predictive & Clinical Health** (doctor_access_grants RLS, CGM pipeline)
- [ ] **Phase 11 — Visual Body Analytics** (progress_photos → private Storage bucket + signed URLs)
- [ ] **Phase 12 — Festival & Life Events**
- [ ] **Phase 13 — Monetisation** (entitlements table + server-verified RevenueCat webhook Edge Function — closes the client-side-only verification gap, `decisions.md` ADR-003)
- [ ] **Phase 14 — Enterprise Hardening** (RLS policy audit replaces the old Firestore/Storage rules audit; App Check has no direct Supabase equivalent — re-evaluate what replaces it, log the decision)
- [ ] **Phase 15 — Advanced Intelligence**
- [ ] **Phase 16 — India Growth & Trust Layer** (ABHA M1 → custom Supabase JWT claim, WhatsApp webhook → Edge Function)

---

## Phase 0 — Foundation

- [x] **Design Philosophy & Anti-Patterns**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Project Structure**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Architecture Overview (offline-first, Health OS Brain)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Design Tokens**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Shared Foundation Widgets (BentoCard, ActivityRings, GlowingMetric, BilingualLabel)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Health OS Brain (Daily Intelligence Package orchestration)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **AI Routing Layer (Groq multi-model router)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Program Evolution Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Prerequisites setup**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Adaptive Metabolism Engine (base version)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Environmental Health Layer (AQI/UV/Heat, base version)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 1 — Onboarding

- [x] **Onboarding Flow Order**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Welcome Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Goals Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Demographics Screen (live BMI + adaptive targets)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **AI Diet Plan Results Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Dosha Quiz (scoring engine)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Program Blueprint Selection Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Women's Advanced Health Layer (cycle-aware training/nutrition, fertility planning, menopause tracking, PCOS calibrator)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 2 — Daily Mission + Readiness

- [x] **Readiness Engine (three-tier confidence model, deterministic score formula)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Daily Briefing Screen (morning check-in ritual)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Log Screen (body soreness map)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Operating System — Sleep Intelligence Layer**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Operating System — Recovery Capacity & Strain System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Operating System — Recovery Behaviors & Prescriptions**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Operating System — Circadian & Environmental Intelligence**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Recovery Operating System — Recovery Age & Forecasting**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 3 — AI Adaptive Coach

- [x] **AI Coach Philosophy & Context Builder**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **AI Coach Screen (local chat cache, optimistic UI)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Cloud Function coach endpoint**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Proactive event-driven insights**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Health Coach Escalation Layer (elite tier — human coach handoff)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 4 — Health Tracking

- [x] **Dashboard Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Steps Screen (auto-detection & sync)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Sleep Screen (stage metrics, debt modeling)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Blood Pressure Screen (biometric-gated access)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Glucose Screen (meal correlation, HbA1c estimation)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Preventive Intelligence Engine (deterministic)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Smart Wearable Comparison Layer (device confidence matrix, late-sync merge rules)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 5 — Smart Indian Nutrition

- [x] **Food Screen Home**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Meal Analysis Pipeline**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **"Fix My Meal" AI Photo Analysis (vision cost optimization)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Smart Indian Meal Intelligence (offline seeded food DB, local meal-quality scoring)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Indian Restaurant Intelligence (menu OCR, chain presets)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Grocery Optimization Engine (budget-optimized flow)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Nutrition Periodization Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Protein Distribution & Timing Intelligence**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Micronutrient Intelligence Core**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Nutrition Adherence Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Festival Nutrition Adaptation**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Adaptive Hunger & Cravings Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Glycemic Response & Personal Food Scoring**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Multi-Dimensional Meal Quality Score**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Nutrition Reliability Score & Data Confidence Shield**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Satiety Prediction Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Family Nutrition Integration**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Indian Food Substitution & Swap Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 6 — Workout System

- [x] **Workout Screen Home**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Active Workout Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Progressive Overload Engine (deterministic)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Dynamic Fitness Blueprint Generator**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Training Operating System — Movement Intelligence Platform**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Training Operating System — Confidence Indices**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Training Operating System — Smart Programming & Overload Logic**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Training Operating System — Adherence & Athletic Profiling**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Training Operating System — Biomechanics & Trajectory Projections**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Adaptive Computer Vision Loop (pose estimation form-checking)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 7 — Gamification

- [x] **Karma System Design**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Karma Hub Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Habit Automation System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Adherence Score**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Benchmarking Engine (fitness percentile)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Demographic Cohort Insights & Network Effects**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 8 — Transformation Journey

- [x] **Transformation Journey Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Transformation Timeline Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Habit Identity Layer (behavior science)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 9 — Social

- [x] **Social Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Squad System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Accountability Communities**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Family Health Hub**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Activity Feed & Sharing Architecture**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Local Geolocation Clubs & Interest Circles**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Weekly/Monthly Leaderboards**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 10 — Predictive & Clinical Health

- [x] **Health Risk Prevention System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Biological Age Estimation (monthly, deterministic)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Monthly Health Report**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Injury Risk Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Stress Detection Engine (inferred)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Clinical Report Intelligence (lab data parsing)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Longevity Score**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Continuous Biomarker (CGM) Sync**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Medication Tracker & Interaction Warning Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Doctor Sharing Portal**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Regulatory & Clinical Compliance Framework**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Retrospective Glycemic Processing Pipeline**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 11 — Visual Body Analytics

- [x] **Body Analytics Screen**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Progress Photo System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Wearable-Free Body Composition Estimation**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 12 — Festival & Life Events

- [x] **Festival Intelligence System**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Life Events Engine**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Wedding Transformation Mode**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **AI Roast Mode**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Travel Intelligence (Travel Mode)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Smart Calendar Integration**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 13 — Monetisation

- [x] **Subscription Tiers (server-side entitlement verification)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Creator & Coach Marketplace**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Creator Affiliate Program**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 14 — Enterprise Hardening

- [x] **Security (Firestore/Storage rules audit, App Check, secrets management)**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Performance**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **Testing Strategy**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature
- [x] **CI/CD Pipeline**
    - [x] Implement
    - [x] Offline-verified
    - [x] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [x] `README.md` written for this feature

## Phase 15 — Advanced Intelligence

- [ ] **Adaptive Metabolism Engine (deepened)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Longevity Score (deepened)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Environmental Health Layer (deepened)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 16 — India Growth & Trust Layer

- [ ] **WhatsApp Business Logging**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Vernacular Voice Logging**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **ABHA Health ID Integration**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Corporate Wellness & Insurer Tier**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Grocery Vendor Checkout Integration**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

---

## Cross-cutting (ongoing, not a phase)

- [ ] Keep `README.md` (project root) in sync as features land
- [ ] Keep the doc suite (`architechture.md`, `data_model.md`, etc.) updated if a feature's implementation deviates from spec — log the deviation in `decisions.md` too
- [ ] DPDP-compliant cascading deletion — **port `deleteUserData` Cloud Function to the `delete_user_data` Edge Function** (see `api_contract.md` §5, `security.md` §5) and confirm it covers every table in `data_model.md`, not just the original Firestore collection list
- [ ] Add RLS pgTAP coverage for every table as it's ported (see `tedting.md` §1.3) — not previously required under Firestore rules, now part of "done"
- [ ] Update `github_actions.md`-defined CI workflows in the actual repo (`supabase-migrate.yml`, `edge-functions-deploy.yml`, `rls-test.yml`) as each phase is ported, retiring the equivalent `firebase deploy` steps once nothing depends on them
