# FitKarma — Complete Development TODO (AI-IDE Build Spec)

**How to use this file:** every checkbox below maps 1:1 to a named section, engine, screen,
worker, or schema in [`Fitkarma_documentation.md`](./Fitkarma_documentation.md) — the §-code
in parentheses is the literal section to read for the exact algorithm, formula, wireframe, or
schema before implementing that item. **This file is the task graph; the master doc is the
spec.** If you're an AI coding agent working through this: open the referenced § section
first, implement exactly what it specifies, then check the box — don't invent behavior that
isn't in the referenced section, and don't skip an item because its description here looks
short (short description ≠ small task; some §-sections are 100+ lines of algorithm).

**Priority:** `P0` = blocks everything downstream · `P1` = required for launch · `P2` = safe post-launch
**Rule reinforced throughout the doc and worth repeating here:** anything marked "Pure Dart",
"Deterministic", "Rule-Based", or "No AI" must **never** make an LLM call. If you're tempted to
route one of these through the AI Router, stop — that's a spec violation, not an optimization.

---

## Phase -1 — Repo, Environments & CI/CD (P0)

*(Cross-reference: §P14-D "CI/CD Pipeline" in the master doc — this phase implements that
section's intent using Cloudflare instead of the doc's original target, plus the dev/staging/
production split.)*

### Branching & repo protection
- [x] `develop` and `main` branches created
- [x] Branch protection on `main`: require PR, require `test` + `test-workers` status checks
- [x] Branch protection on `develop`: require PR, require `test` status check
- [x] `production` GitHub Environment with ≥1 required reviewer
- [x] `staging` GitHub Environment, no reviewer required

### Cloudflare setup
- [x] `wrangler.toml` created from `workers/wrangler.toml.example`
- [x] `fitkarma-db-staging` and `fitkarma-db-production` D1 databases created, IDs pasted in
- [x] Local dev D1 database created for `wrangler dev`
- [x] Separate scoped Cloudflare API tokens for staging vs. production deploys

### Secrets (staging AND production, independently — never shared)
- [x] `GROQ_API_KEY` — both envs
- [x] `GOOGLE_OAUTH_CLIENT_ID` — both envs
- [x] `JWT_SIGNING_SECRET` — both envs, independently generated
- [x] `APPLE_SIGNIN_CLIENT_ID` — both envs

### GitHub Actions secrets
- [x] `CF_ACCOUNT_ID`, `CF_API_TOKEN_STAGING`, `CF_API_TOKEN_PRODUCTION`
- [x] `CF_D1_API_BASE_URL_*`, `CF_WORKERS_API_BASE_URL_*` (staging + production)
- [x] `GOOGLE_OAUTH_CLIENT_ID_*`, `SENTRY_DSN_*` (staging + production)
- [x] `ANDROID_KEYSTORE_BASE64` + password secrets

### Pipeline validation
- [x] PR triggers `test` + `test-workers` only, never a deploy
- [x] Push to `develop` auto-deploys Workers + D1 migrations to staging
- [x] Failing test on `main` confirmed to block `deploy-production` (fail-closed test)
- [x] Passing `main` push waits for required-reviewer approval before deploying to production
- [x] Staging-issued JWT confirmed rejected by production Worker

---

## Phase 0 — Foundation (P0)

- [x] **§P0-A Design Philosophy** — Six Pillars and Anti-Patterns encoded as team/agent guidelines (consider a lint rule or PR template checklist for the Anti-Patterns list)
- [x] **§P0-B Project Structure** — repo scaffolded exactly to the documented folder layout
- [x] **§P0-C Architecture Overview** — Offline-First + Health OS Brain principle implemented; Three-Layer Offline Strategy in place; **Drift Sync Merge Resolver** (Pure Dart) implemented per the documented conflict/concurrency rules; "What Is and Is NOT an AI Job" boundary respected everywhere (audit every AI Router call site against this list)
- [x] **§P0-D Design Tokens** — Color Tokens, Color Semantic Quick-Reference, Spacing & Radius Tokens, Typography System all implemented as a single source-of-truth token file
- [x] **§P0-D2 Shared Foundation Widgets** — `BentoCard` (`lib/shared/widgets/bento_card.dart`), `ActivityRings` (`lib/shared/widgets/activity_rings.dart`), `GlowingMetric` (`lib/shared/widgets/glowing_metric.dart`), `BilingualLabel` (`lib/shared/widgets/bilingual_label.dart`) — each with a golden test
- [x] **§P0-E Health OS Brain** — inputs pipeline wired; **Daily Intelligence Package (DIP)** model + generation implemented; Unified Health Score formula implemented; **Decision Hierarchy** conflict-resolution logic implemented and unit tested
- [x] **§P0-F AI Routing Layer** — Model Tiers defined; **AI Router** implemented; **RuleEngine** (Pure Dart) implemented; **InsightTemplateEngine** (Pure Dart) implemented; Event-Driven AI Triggers wired (not polling); **ContextCompressor** implemented per spec; Conversation Memory Management implemented; AI Cost Budget per user tier enforced in code (not just documented); Hybrid Insight Engine implemented
- [x] **§P0-G Program Evolution Engine** implemented
- [x] **§P0-H Prerequisites** — dev environment matches documented prerequisites (Flutter SDK version, Wrangler, Node)
- [x] **§P0-I Adaptive Metabolism Engine** (NEW v1) — **AdaptiveMetabolismEngine** (Pure Dart, no AI) implemented; Weekly Recalibration Output implemented; Calibration Schedule implemented; integration with Health OS Brain wired
- [x] **§P0-J Environmental Health Layer** (NEW v1) — **EnvironmentalHealthEngine** implemented (AQI + UV + Heat inputs); AQI Warning Banner UI built; Decision Hierarchy integration wired

## Phase 1 — Onboarding + User Profile (P0)

- [x] **§P1-A Onboarding Flow Order** implemented as the canonical navigation sequence
- [x] **§P1-B Welcome Screen** built per wireframe
- [x] **§P1-C Goals Screen** built with all documented selection & conditional logic rules
- [x] **§P1-D Demographics Screen** — Live BMI Calculation & Target Selection Logic implemented; Adaptive Targets computed **in Dart, never AI**
- [x] **§P1-E AI Diet Plan Results Screen** — Loading & Fallback Caching Logic implemented (offline-first compliant); Groq Prompt Template implemented exactly as documented
- [x] **§P1-F Dosha Quiz Screen** — **DoshaQuizScoringEngine** (Pure Dart) implemented and unit tested against known quiz combinations
- [x] **§P1-G Program Blueprint Selection Screen** — Allocation Rules & Database Integration implemented; full Program Library seeded
- [x] **§P1-H Women's Advanced Health Layer** (NEW v1) — Cycle-Aware Training Adapter, Cycle-Aware Nutrition Adapter, Fertility Planning Mode, Menopause Symptom Tracking, and **DynamicCycleCalibrator** (PCOS/irregular cycle, Pure Dart) all implemented; Women's Health Screen UI built

## Phase 2 — Daily Mission + Readiness Engine (P1)

- [x] **§P2-A Readiness Engine** — Three-Tier Confidence Model implemented; Readiness Score Formula (Pure Dart, no AI) implemented; Readiness Zones + recommended intensity mapping implemented; AI Intensity Adjustment confirmed **computed, not AI-called**
- [x] **§P2-B Daily Briefing Screen** — Morning Check-In (3-question, <30s) built; full Daily Briefing layout built, reading from DIP only
- [x] **§P2-C Recovery Log Screen** — Interactive Body Soreness Map (tap-to-select) built; Riverpod State Notifier + DB sync implemented
- [x] **§P2-D Recovery Operating System** (NEW v1):
  - [x] Sleep Need Calculator implemented
  - [x] Sleep Performance Score implemented
  - [x] Bedtime Coach implemented
  - [x] **DailyStrainCalculator** (Pure Dart, 0–21 scale) implemented per the documented mathematical model
  - [x] Recovery Capacity & Decision Matrix implemented
  - [x] Recovery Behaviors & Actionable Prescriptions implemented
  - [x] Circadian Score (0–100) implemented with midpoint-shift penalty
  - [x] Illness & Recovery Type Detection implemented
  - [x] Recovery Drivers breakdown implemented
  - [x] Recovery Age & Forecasting implemented

## Phase 3 — AI Adaptive Coach (P1)

- [x] **§P3-A AI Coach Philosophy** encoded as prompt/response guardrails
- [x] **§P3-B AI Context Builder** implemented
- [x] **§P3-C AI Coach Screen** — Local Chat Cache DB Schema (Drift) implemented; Riverpod State Notifier with optimistic state + typewriter effect implemented; **Cloudflare Worker `fitkarma-coach`** deployed; Proactive Insights implemented as event-driven (confirmed not daily polling)
- [x] **§P3-D Health Coach Escalation Layer** (NEW v1, Elite Tier) — Escalation Triggers implemented; Coach Briefing Package generation implemented; Escalation Flow UI built

## Phase 4 — Health Tracking (P1)

- [x] **§P4-A Dashboard Screen** — Orchestration layer + full layout built, DIP-only reads
- [x] **§P4-B Steps Screen** — Auto-Detection & Sync Engine implemented
- [x] **§P4-C Sleep Screen** — Sleep Stage Metrics and Debt Modeling implemented
- [x] **§P4-D Blood Pressure Screen** — Security & Biometric Access Layer implemented
- [x] **§P4-E Glucose Screen** — Meal Correlation & HbA1c Estimation implemented
- [x] **§P4-F Preventive Intelligence Engine** — all 6 risk patterns implemented, confirmed deterministic (no AI)
- [x] **§P4-G Smart Wearable Comparison Layer** (NEW v1) — Device Confidence Matrix implemented; **DeviceReliabilityEngine** implemented; Wearable Data Source Card UI built; **WearableSyncMerger** (Pure Dart, late-sync override & merge rules) implemented

## Phase 5 — Smart Indian Nutrition System (P1)

- [x] **§P5-A Food Screen Home** built
- [x] **§P5-B Meal Analysis Pipeline** implemented end-to-end
- [x] **§P5-C "Fix My Meal" — AI Meal Photo Analysis** — Meal Vision Cost Optimization (cache-first) implemented; Full Analysis Result Screen built
- [x] **§P5-D Smart Indian Meal Intelligence** — Offline Seeded Food Database Matrix (5,000+ items) seeded; Local Meal Quality Score Calculation Engine implemented; Core Nutrition Adaptations implemented
- [x] **§P5-E Indian Restaurant Intelligence 2.0** (NEW v1) — Menu OCR Scan & Goal Overlay flow implemented; Major Chain Menu Optimization Presets seeded; Smart Item Recognition & OCR Parser implemented
- [x] **§P5-F Grocery Optimization Engine 2.0** (NEW v1) — Meal Plan → Budget-Optimized Grocery flow implemented; **GroceryOptimizationEngine** (knapsack-based) implemented and edge-case tested
- [x] **§P5-G Nutrition Periodization Engine** (NEW v1) — Periodization Phases defined; Periodization Controller implemented
- [x] **§P5-H Protein Distribution & Timing Intelligence** (NEW v1) — MPS Threshold Target implemented; Timing Scoring implemented
- [x] **§P5-I Micronutrient Intelligence Core** (NEW v1) — Biomarkers Tracked list implemented with target adjustments; Auto-Alert Trigger Engine implemented
- [x] **§P5-J Nutrition Adherence Engine** (NEW v1) — Scoring Matrix implemented; Score Calculation Logic implemented
- [x] **§P5-K Smart Festival Nutrition Adaptation** (NEW v1) — Diwali Pre-Compensation Protocol implemented; Adaptation Engine Integration wired
- [x] **§P5-L Adaptive Hunger & Cravings Engine** (NEW v1) — Craving Log Prompts implemented; Craving Predictor implemented
- [x] **§P5-M Glycemic Response & Personal Food Scoring** (NEW v1) — CGM Integration Map implemented; Score Calculation implemented
- [x] **§P5-N Multi-Dimensional Meal Quality Score** (NEW v1) — Scoring Formula implemented; validated against Indian Food Score Comparison Examples in the doc
- [x] **§P5-O Nutrition Reliability Score & Data Confidence Shield** (NEW v1) — Reliability Equation implemented; Shield Check implemented
- [x] **§P5-P Satiety Prediction Engine** (NEW v1) — Satiety Index Score (0–100) implemented; Local Indian Satiety Reference Table seeded
- [x] **§P5-Q Family Nutrition Integration** (NEW v1) — Multi-Profile Matching Flow implemented; Family Dinner Engine implemented
- [x] **§P5-R Indian Food Substitution & Swap Engine** (NEW v1) — Target Swap Index implemented; Substitution Service implemented

## Phase 6 — Workout System & Movement Intelligence (P1)

- [x] **§P6-A Workout Screen Home** built
- [x] **§P6-B Active Workout Screen** — Active Set Logging & Rest Countdowns implemented, survives backgrounding
- [x] **§P6-C Progressive Overload Engine** implemented as fully deterministic (no AI)
- [x] **§P6-D Dynamic Fitness Blueprint Generator** implemented
- [x] **§P6-E Training Operating System** (NEW v1) — Movement Intelligence Platform, 5 levels:
  - [x] Level 1 — Exercise Video Intelligence
  - [x] Level 2 — Personalized Weakness Profiling (**MWP**)
  - [x] Level 3 — Mobility Diagnosis & Correctives
  - [x] Level 4 — Biomechanical Injury Forecasting
  - [x] Level 5 — Movement Memory
  - [x] Exercise Confidence Score (**ECS**) implemented
  - [x] Movement Health Score (**MHS**) implemented
  - [x] Camera-Based Fitness Onboarding & Movement Age implemented
  - [x] Adaptive Exercise Selection implemented
  - [x] Local Muscle Readiness implemented
  - [x] Recovery-Aware Overload Progression implemented
  - [x] Training Reliability Score (0–100) implemented
  - [x] Workout Simulation & Strength Potential implemented
  - [x] Movement Asymmetry Detection implemented
  - [x] Estimated Rep-Speed Trend Analysis implemented
  - [x] Exercise Skill Trees & Mastery Levels implemented
  - [x] Athletic Testing Battery implemented
  - [x] Performance Forecasting Engine implemented
- [x] **§P6-F Adaptive Computer Vision Loop (ACVL)** (NEW v1):
  - [x] Thermal-Aware Downsampling Matrix implemented
  - [x] Android ADPF Bridge (Kotlin, `MethodChannel`) implemented
  - [x] iOS Thermal Bridge (Swift, `MethodChannel`) implemented
  - [x] Flutter Frame Processor & Isolate Architecture implemented
  - [x] Camera Controller Loop Integration implemented
  - [x] UX Transparency Safeguard (throttling banner) implemented
  - [x] **PoseLandmarkAdapter** (Pure Dart, downsampling) implemented

## Phase 7 — Gamification + Karma System (P1/P2)

- [x] **§P7-A Karma System Design** — XP Events audited as outcome-only (not logging-based); Karma Levels implemented
- [x] **§P7-B Karma Hub Screen** — **KarmaHubNotifier** (Riverpod) implemented
- [x] **§P7-C Habit Automation System** implemented
- [x] **§P7-D Adherence Score** (NEW v1) — **AdherenceScoreCalculator** (Pure Dart) implemented; Dashboard widget built; Adherence → XP connection wired
- [x] **§P7-E Benchmarking Engine** (NEW v1) — Benchmark Cohorts defined; Benchmark Display screen built
- [x] **§P7-F Demographic Cohort Insights & Network Effects** (NEW v1) — Cohort Insights & Benchmarks Service implemented; Community Cohort Insights UI built; Privacy Guarantee (minimum cohort size) enforced and tested

## Phase 8 — Transformation Journey + Anti-Quit Psychology (P1)

- [x] **§P8-A Transformation Journey Engine** — Long-Term Memory implemented; Consistency Tracker implemented; Relapse Intervention System (all tiers) implemented
- [x] **§P8-B Transformation Timeline Screen** — **TransformationJourneyNotifier** implemented
- [x] **§P8-C Habit Identity Layer** (NEW v1) — Identity Personas defined; Identity Evolution Engine implemented; "You Are Becoming" Card UI built; Identity → AI Coach integration wired

## Phase 9 — Social + Squad Accountability (P1)

- [x] **§P9-A Social Screen** — **SquadStateNotifier** implemented
- [x] **§P9-B Squad System** (v1 features) implemented
- [x] **§P9-C Accountability Communities** implemented
- [x] **§P9-D Family Health Hub** (NEW v1) — Family Hub Architecture, Dashboard UI, Privacy Model, and Family Nudges all implemented
- [x] **§P9-E Activity Feed & Sharing Architecture** (NEW v1) — Feed Item Data Model implemented; Feed Engagement Logic implemented; **FeedCurationEngine & SyncCoordinator** (Pure Dart, spam prevention) implemented
- [x] **§P9-F Local Geolocation Clubs & Interest Circles** (NEW v1) — Data Architecture implemented; Geolocation Matching implemented
- [x] **§P9-G Weekly & Monthly Leaderboards** (NEW v1) — Leaderboard Tiers implemented; Gamified Rewards & Anonymity toggle implemented

## Phase 10 — Predictive Health + Preventive Intelligence (P1)

- [x] **§P10-A Health Risk Prevention System** implemented
- [x] **§P10-B Biological Age Estimation** (Monthly, No AI) implemented
- [x] **§P10-C Monthly Health Report** — **MonthlyReportNotifier** implemented
- [x] **§P10-D Injury Risk Engine** (NEW v1) — **InjuryRiskEngine** (rule-based + heuristics) implemented; Injury Risk UI Card built
- [x] **§P10-E Stress Detection Engine** (NEW v1) — **StressDetectionEngine** (rule-based, no AI) implemented; Proactive Stress Alert implemented
- [x] **§P10-F Clinical Report Intelligence** (NEW v1) — Supported Lab Reports list implemented; **ClinicalReportParser** implemented; Clinical Insights Integration wired; Privacy Architecture implemented
- [x] **§P10-G Longevity Score + Biological Age v1** (NEW v1) — **LongevityScoreCalculator** implemented; Longevity Screen UI built
- [x] **§P10-H Continuous Biomarker Tracking (CGM Sync)** (NEW v1) — CGM Data Ingestion implemented; CGM Dashboard UI built
- [x] **§P10-I Medication Tracker & Interaction Warning Engine** (NEW v1) — Medication Logger & Scheduler implemented; Local Drift Schema updates applied; **External NIH RxNav API Service** (Pure Dart) implemented
- [x] **§P10-J Doctor Sharing Portal** (NEW v1) — Export Report Schema implemented; Share Security & Consent Flow implemented
- [x] **§P10-K Regulatory & Clinical Compliance Framework** (NEW v1) — Medical Disclaimer Protocol & Safeguards implemented; Clinical Data Safeguards (DPDP Act & HIPAA guidelines) implemented
- [x] **§P10-L Retrospective Glycemic Processing Pipeline (RGPP)** (NEW v1) — Drift Persistence Extension (retrospective status tracking) implemented; **Retrospective Glucose Matcher** implemented; Background Sync Coordination (Riverpod + Workmanager) implemented; Retrospective Insight Card UI built
- [x] **§P10-M Clinical Compliance Hardening** (NEW v1.0) — Directive-Language Lint on Interaction Warnings implemented as an automated check; Pre-Ship Legal Review Gate process documented; **Clinical Copy Change Checklist enforced as a required PR template/CI check for any PR touching §P10-I, §P10-H, or §P10-J**

## Phase 11 — Visual Body Analytics (P1/P2)

- [x] **§P11-A Body Analytics Screen** — **BodyAnalyticsNotifier** implemented
- [x] **§P11-B Progress Photo System** — encrypted local storage + biometric lock implemented
- [x] **§P11-C Wearable-Free Body Composition Estimation** (NEW v1) — all documented estimation methods implemented in priority order; **BodyCompositionEstimator** (Pure Dart) implemented; UI card built

## Phase 12 — Festival + Life Events Intelligence (P1)

- [x] **§P12-A Festival Intelligence System** (v1) — Festival Cross-Module Adaptation Engine implemented; all documented Festivals Tracked seeded with correct dates; Festival Survival Mode implemented
- [x] **§P12-B Life Events Engine** (NEW) implemented, covering every documented event type
- [x] **§P12-C Wedding Transformation Mode** — **WeddingTransformationNotifier** implemented
- [x] **§P12-D AI Roast Mode** implemented
- [x] **§P12-E Travel Intelligence** (NEW v1) — **TravelIntelligenceEngine** implemented; Travel Mode UI built
- [x] **§P12-F Smart Calendar Integration** (NEW v1) — Calendar Intelligence Engine implemented; Calendar-Aware Daily Briefing wired; Privacy boundaries implemented

## Phase 13 — Premium + Monetisation (P0 for revenue)

- [x] **§P13-A Subscription Tiers** — India-first pricing implemented; Paywall Triggers implemented on every documented gate; **PremiumStateNotifier** implemented; bottom-sheet-only paywall confirmed, "Continue Free" always present
- [x] **§P13-B Creator & Coach Marketplace** (NEW v1) — Creator Profile & Program Schemas implemented; Marketplace Matchmaking Engine implemented; Program Store (user-generated blueprints) implemented; Marketplace Trust/Verification/Escrow implemented; Razorpay/Stripe Connect compliance implemented; **Payment Webhook Split-Settlement & Double-Entry Ledger** (Pure Dart) implemented and tested against a sandboxed real payout
- [x] **§P13-C Creator Affiliate Program** (NEW v1) — Affiliate Referral Architecture implemented; Creator Earnings Dashboard UI built

## Phase 14 — Enterprise Hardening + CI/CD (P0)

- [x] **§P14-A Security** — SQLCipher Secure Database Initialization implemented (`Random.secure()` key gen, verified by code review); Biometric Verification Gate + Riverpod state implemented
- [x] **§P14-B Performance** — Background Processing & iOS Sync Safeguards implemented; **App Foreground Catch-Up Sync** (Pure Dart) implemented
- [x] **§P14-C Testing Strategy** — implemented exactly as documented (unit/widget/integration/golden test layers)
- [x] **§P14-D CI/CD Pipeline** — see Phase -1 above (implemented on Cloudflare instead of the doc's original target, with the dev/staging/production split)

## Phase 16 — India Growth & Trust Layer (P1)

- [x] **§P16-A WhatsApp Business Logging** — Architecture implemented; Data Model implemented; full Implementation built (reusing the existing food-parsing pipeline); Privacy (opt-in/opt-out, off by default) implemented
- [x] **§P16-B Vernacular Voice Logging** — Architecture implemented; all Supported Languages (v1.0 launch set: Hindi, Tamil, Telugu, Marathi, Bengali, Kannada) implemented and tested with native-speaker audio; Implementation built ahead of the existing food/workout parser
- [x] **§P16-C ABHA Health ID Integration** — Architecture implemented; Data Model implemented (`abhaHealthId` encrypted at rest); Compliance Note requirements met
- [x] **§P16-D Corporate Wellness & Insurer Tier** (NEW v1.0) — Architecture implemented; Data Model implemented (`OrganizationAccounts`, `EmployeeEnrollments`); Privacy Boundary (minimum-cohort-size aggregate threshold) implemented and tested with a below-threshold cohort
- [x] **§P16-E Grocery Vendor Checkout Integration** — Architecture implemented; Implementation built for at least one partner (Blinkit/BigBasket/Zepto); affiliate order tracking confirmed reusing the §P13-C ledger

---

## §DB — Database Schema (P0, underlies everything above)

- [x] **Drift Local Schema (v17)** — every table implemented exactly as documented
- [x] **§DB-B Drift Migration Strategy** — migration path implemented and tested from a v16 (or earliest supported) install forward
- [x] **§DB-C Cloudflare D1 Cloud Database Schema** (SQLite dialect, not the doc's original T-SQL):
  - [x] `Users` table
  - [x] `UserScores` table (NEW v17 — v1.0 hardening; confirm `Users` no longer holds overwritable score columns)
  - [x] `OrganizationAccounts` + `EmployeeEnrollments` tables (NEW v17 — Phase 16)
  - [x] `FoodLogs` table
  - [x] `DailyIntelligencePackages` table
  - [x] `AICache` table (v1.0 hardening — scoped by `user_id`, purged on account deletion)
  - [x] `CGMReadings` table
  - [x] `RecoveryLogs` table
  - [x] `TransformationChecks` table
  - [x] `SyncAuditTrail` table
  - [x] `SyncDeadLetterQueue` table
  - [x] `MarketplaceLedger` table (double-entry)

## §CF — Cloudflare Workers (8 total) (P0)

- [ ] `fitkarma-health-os` — core v1.0 architecture Worker; deployed as **Cloudflare Workflows fan-out** (not a sequential loop), per-user error isolation confirmed; AI Cache Implementation wired
- [ ] `fitkarma-social`
- [ ] `fitkarma-marketplace`
- [ ] `fitkarma-cores`
- [ ] `fitkarma-coach`
- [ ] `fitkarma-meal-vision`
- [ ] `fitkarma-insights`
- [ ] `fitkarma-reports`
- [ ] `fitkarma-whatsapp` (Phase 16 — not in the original 8, added by §P16-A; confirm `wrangler.toml` routes/bindings cover it too)

## §GLO — Glossary & Architecture Decision Records (P1)

- [ ] Every term in the **Glossary** used consistently in code identifiers and comments — spot-check for drift (e.g. don't call it "Readiness Index" in code if the doc says "Readiness Score")
- [ ] Every **Architecture Decision Record (ADR)** cross-checked against the actual implementation; any deviation gets a new ADR explaining why, not a silent divergence

---

## v1.0 Architecture Hardening (P0 — cuts across every phase above, verify explicitly)

- [ ] SQLCipher key generation confirmed `Random.secure()`-based (code review, not spec-reading)
- [ ] `fitkarma-health-os` confirmed running as Cloudflare Workflows fan-out with per-user error isolation
- [ ] DIP generation scheduling confirmed per-user via `timezoneOffsetMinutes` + `preferredDIPHour` (test a non-IST user)
- [ ] Sync conflict resolution confirmed HLC-based (test two devices editing offline simultaneously)
- [ ] Cumulative log sync batches carry `syncBatchId`, server-side dedup verified
- [ ] `UserScores` table live; `Users` confirmed to no longer hold overwritable score columns
- [ ] `AICache` scoped by `user_id`; account deletion verified to purge it
- [ ] `ClinicalCopyLinter` passing in CI for every §P10-I/H/J copy change

---

## Pre-Launch Gate

- [ ] Every checkbox in every phase above is checked
- [ ] Full CI pipeline (`test`, `test-workers`) green on the exact release-candidate commit
- [ ] Release candidate soaked on staging for multiple days with real device testing
- [ ] `production` GitHub Environment reviewer sign-off obtained
- [ ] Rollback plan (Worker rollback + D1 migration revert) documented and rehearsed once, not just written down

## Post-Launch (Within 30 Days)

- [ ] Indian food database expanded to 10,000+ items
- [ ] AI cost per user/day measured against §P0-F budget projections; router tuned if off-target
- [ ] DIP generation success rate monitored via Cloudflare Workflows dashboard
- [ ] Model routing tuned from real usage patterns
- [ ] HealthKit background delivery verified specifically for overnight sleep data
- [ ] Push notification open rates measured; meal-reminder copy A/B tested
- [ ] Subscription conversion funnel analyzed (trial → paid)
- [ ] Home widget (iOS + Android) shipped and verified on lock screen
- [ ] Wedding mode tested end-to-end with synthetic data
- [ ] Program Evolution Engine's first real transitions validated against real user data
- [ ] Transformation Memory accuracy validated at the 4-week mark