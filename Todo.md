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
- [ ] **Phase 1 — Onboarding** (profiles, dosha_scores, cycle_tracking tables)
- [ ] **Phase 2 — Daily Mission + Readiness** (readiness_scores, dip_cache)
- [ ] **Phase 3 — AI Adaptive Coach** (coach_sessions/coach_messages, Cloud Function coach endpoint → `coach-message` Edge Function)
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

- [ ] **Onboarding Flow Order**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Welcome Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Goals Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Demographics Screen (live BMI + adaptive targets)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **AI Diet Plan Results Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Dosha Quiz (scoring engine)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Program Blueprint Selection Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Women's Advanced Health Layer (cycle-aware training/nutrition, fertility planning, menopause tracking, PCOS calibrator)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 2 — Daily Mission + Readiness

- [ ] **Readiness Engine (three-tier confidence model, deterministic score formula)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Daily Briefing Screen (morning check-in ritual)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Log Screen (body soreness map)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Operating System — Sleep Intelligence Layer**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Operating System — Recovery Capacity & Strain System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Operating System — Recovery Behaviors & Prescriptions**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Operating System — Circadian & Environmental Intelligence**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Recovery Operating System — Recovery Age & Forecasting**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 3 — AI Adaptive Coach

- [ ] **AI Coach Philosophy & Context Builder**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **AI Coach Screen (local chat cache, optimistic UI)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Cloud Function coach endpoint**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Proactive event-driven insights**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Health Coach Escalation Layer (elite tier — human coach handoff)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 4 — Health Tracking

- [ ] **Dashboard Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Steps Screen (auto-detection & sync)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Sleep Screen (stage metrics, debt modeling)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Blood Pressure Screen (biometric-gated access)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Glucose Screen (meal correlation, HbA1c estimation)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Preventive Intelligence Engine (deterministic)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Smart Wearable Comparison Layer (device confidence matrix, late-sync merge rules)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 5 — Smart Indian Nutrition

- [ ] **Food Screen Home**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Meal Analysis Pipeline**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **"Fix My Meal" AI Photo Analysis (vision cost optimization)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Smart Indian Meal Intelligence (offline seeded food DB, local meal-quality scoring)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Indian Restaurant Intelligence (menu OCR, chain presets)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Grocery Optimization Engine (budget-optimized flow)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Nutrition Periodization Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Protein Distribution & Timing Intelligence**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Micronutrient Intelligence Core**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Nutrition Adherence Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Festival Nutrition Adaptation**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Adaptive Hunger & Cravings Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Glycemic Response & Personal Food Scoring**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Multi-Dimensional Meal Quality Score**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Nutrition Reliability Score & Data Confidence Shield**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Satiety Prediction Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Family Nutrition Integration**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Indian Food Substitution & Swap Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 6 — Workout System

- [ ] **Workout Screen Home**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Active Workout Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Progressive Overload Engine (deterministic)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Dynamic Fitness Blueprint Generator**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Training Operating System — Movement Intelligence Platform**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Training Operating System — Confidence Indices**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Training Operating System — Smart Programming & Overload Logic**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Training Operating System — Adherence & Athletic Profiling**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Training Operating System — Biomechanics & Trajectory Projections**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Adaptive Computer Vision Loop (pose estimation form-checking)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 7 — Gamification

- [ ] **Karma System Design**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Karma Hub Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Habit Automation System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Adherence Score**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Benchmarking Engine (fitness percentile)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Demographic Cohort Insights & Network Effects**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 8 — Transformation Journey

- [ ] **Transformation Journey Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Transformation Timeline Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Habit Identity Layer (behavior science)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 9 — Social

- [ ] **Social Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Squad System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Accountability Communities**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Family Health Hub**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Activity Feed & Sharing Architecture**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Local Geolocation Clubs & Interest Circles**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Weekly/Monthly Leaderboards**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 10 — Predictive & Clinical Health

- [ ] **Health Risk Prevention System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Biological Age Estimation (monthly, deterministic)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Monthly Health Report**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Injury Risk Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Stress Detection Engine (inferred)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Clinical Report Intelligence (lab data parsing)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Longevity Score**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Continuous Biomarker (CGM) Sync**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Medication Tracker & Interaction Warning Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Doctor Sharing Portal**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Regulatory & Clinical Compliance Framework**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Retrospective Glycemic Processing Pipeline**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 11 — Visual Body Analytics

- [ ] **Body Analytics Screen**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Progress Photo System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Wearable-Free Body Composition Estimation**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 12 — Festival & Life Events

- [ ] **Festival Intelligence System**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Life Events Engine**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Wedding Transformation Mode**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **AI Roast Mode**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Travel Intelligence (Travel Mode)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Smart Calendar Integration**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 13 — Monetisation

- [ ] **Subscription Tiers (server-side entitlement verification)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Creator & Coach Marketplace**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Creator Affiliate Program**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

## Phase 14 — Enterprise Hardening

- [ ] **Security (Firestore/Storage rules audit, App Check, secrets management)**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Performance**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **Testing Strategy**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature
- [ ] **CI/CD Pipeline**
    - [ ] Implement
    - [ ] Offline-verified
    - [ ] RLS & Storage bucket policies updated (Supabase, if new data paths)
    - [ ] `README.md` written for this feature

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
