# FitKarma — TODO / Launch Checklist

Derived from the Master Launch Checklist in [`Fitkarma_documentation.md`](./Fitkarma_documentation.md),
reorganized with environment/CI-CD setup called out as its own tracked phase since it's a
prerequisite for shipping anything past local dev. Check items off as they land.

---

## Phase -1 — Repo, Environments & CI/CD (do this before Phase 0)

- [x] `develop` and `main` branches created; `main` protected (require PR + passing checks)
- [x] Workflow file created in `.github/workflows/ci-cd.yml`
- [x] `wrangler.toml` created from `wrangler.toml.example` with `[env.staging]` and `[env.production]` blocks
- [x] `production` GitHub Environment configured with required reviewers (Settings → Environments)
- [x] `fitkarma-db-staging` and `fitkarma-db-production` D1 databases created (separate, never shared)
- [ ] Per-environment secrets set via `wrangler secret put --env staging` / `--env production`
      (`GROQ_API_KEY`, `GOOGLE_OAUTH_CLIENT_ID`, `JWT_SIGNING_SECRET` — **different secret value per env**)
- [ ] GitHub Actions secrets configured: `CF_ACCOUNT_ID`, `CF_API_TOKEN_STAGING`, `CF_API_TOKEN_PRODUCTION`,
      `CF_D1_API_BASE_URL_*`, `CF_WORKERS_API_BASE_URL_*`, `GOOGLE_OAUTH_CLIENT_ID_*`, `SENTRY_DSN_*`,
      `ANDROID_KEYSTORE_BASE64`
- [ ] `.github/workflows/ci-cd.yml` passing on a throwaway PR (test job green)
- [ ] Push to `develop` successfully deploys Workers + runs D1 migrations against **staging**
- [ ] Push to `main` deploys to **production** only after required-reviewer approval — confirm a
      failing test on `main` blocks `deploy-production` (test this deliberately once)
- [ ] Flutter build flavors (`staging`, `production`) configured with distinct `--dart-define=ENVIRONMENT`
      and distinct API base URLs

---

## Phase 0 — Foundation

- [x] Flutter project created with `--dart-define` multi-env setup
- [x] Sub-directory README documentation created in `lib/core`, `lib/data`, `lib/features`, `lib/shared`, `workers`
- [x] All design tokens in `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
- [x] GlassCard tier-aware (blur on Mid/High, solid on Low)
- [x] All shared components built: GlowingMetric, ActivityRings, QuickLogFab, InsightCard, ShimmerLoader, HealthScoreRing
- [x] Health OS Brain scaffolded: `daily_intelligence_package.dart`
- [x] AI Router implemented: rule engine, template engine, model selector
- [x] Decision Hierarchy implemented and tested
- [x] Drift schema v6 initialized with all tables including DIP, HealthSnapshot, TransformationMemory, LifeEvents
- [x] GoRouter with all routes defined

## Phase 1 — Onboarding

- [x] All 7 onboarding screens functional end-to-end on fresh install
- [x] Demographics: BMI/TDEE/targets computed locally (no AI)
- [x] Diet plan preferences & Ayurvedic Dosha quiz complete, result stored
- [x] Program Blueprint with program evolution path shown upfront
- [x] Permissions screen: HealthKit (iOS) + Health Connect (Android) tested

## Phase 2 — Daily Mission + Readiness

- [x] Three-tier readiness model implemented (Basic/Enhanced/Premium)
- [x] Readiness score computed locally with correct tier and confidence label
- [x] Morning check-in: 3-question ritual modal implemented
- [x] DIP loaded from Drift on Daily Briefing open — zero AI calls at open time
- [x] Health Score computed and displayed
- [x] Decision Hierarchy resolving conflicts correctly
- [x] Recovery log screen functional with confidence tier displayed
- [x] Sleep Need Calculator & Bedtime Coach schedules
- [x] Sleep Performance Score 4-pillar calculations
- [x] Daily Strain Score 0–21 activity tracking calculations
- [x] Recovery Capacity bounds and Decision Engine mapping
- [x] Recovery Prescription actionable checklists
- [x] Circadian Score midpoint shifting penalty rules
- [x] Illness & Sickness biometric alarm triggers
- [x] Recovery Drivers contribution parsing

## Phase 3 — AI Coach

- [x] `fitkarma-health-os` Cloudflare Cron Trigger endpoint initialized (timezone-aware DIP fan-out)
- [x] DIP generation: single AI call, compressed context, stored to Drift
- [x] `fitkarma-coach` Worker: compressed context + conversation memory
- [x] AI Router routing to correct model tier per request
- [x] Prompt cache operational
- [x] Event-driven insight triggers implemented
- [x] Conversation summary + last-5 memory implemented

## Phase 4 — Health Tracking

- [x] Dashboard reads from DIP — no AI calls on open
- [x] Steps auto-detection from HealthKit/Health Connect
- [x] Sleep, BP, Glucose screens functional
- [x] Preventive Intelligence Engine: all 6 risk patterns, rule-based
- [x] Risk alerts feeding into Decision Hierarchy

## Phase 5 — Nutrition

- [x] Indian food database seeded (5,000+ items taxonomy baseline)
- [x] Barcode scan interface integrated
- [x] Meal quality scoring (5 dimensions: Macro Balance, Micros, Glycemic, Processing, Satiety)
- [x] Meal analysis pipeline: macros → quality → readiness impact → goal impact → suggestions
- [x] Meal vision: known-meal cache → Groq Vision fallback
- [x] Protein alert rule-based (< 70% target), no AI
- [x] Periodization Engine phase transition checks
- [x] Protein Distribution & Timing Score calculations
- [x] Micronutrient Tracker with dietary profile alerts
- [x] Nutrition Adherence Score 0–100 calculations
- [x] OCR Menu Scanner with goal-based highlight overlays
- [x] Smart Festival Nutrition pre-compensation and post-recovery
- [x] Adaptive Hunger & Cravings trigger alerts
- [x] Personal food score overrides via CGM Glycemic Response
- [x] Budget-Optimized Grocery knapsack swaps
- [x] Nutrition Reliability Score rolling calculations and Target Lockout rules
- [x] Satiety Prediction Engine scores and database satiety reference index
- [x] Family Meal Planner clinical conflict prioritizing and portion scaling
- [x] Food Substitution Engine registry overrides and satiety improvement swaps

## Phase 6 — Workout

- [x] Program blueprint generator (AI, cached)
- [x] Progressive overload engine (deterministic)
- [x] Program Evolution Engine triggers tested
- [x] Active workout screen with rest timer and set logging
- [x] Completion outcome XP (not logging XP)
- [x] On-device pose estimation joint angle calculations (MediaPipe integration)
- [x] Movement Weakness Profile fault accumulation heuristics
- [x] Mobility Diagnosis Engine cause mappings and drill prescriber
- [x] Biomechanical Injury Risk Forecasting combining kinematic variance and sleep debt
- [x] Movement Memory database logging and progress reporting
- [x] Exercise Confidence Score tempo and jitter variance checks
- [x] Movement Health Score unified synthesis
- [x] Camera-Based Fitness Onboarding assessment for Movement Age
- [x] Adaptive Exercise Selection smart replacement triggers
- [x] Local Muscle Readiness upper and lower body fatigue splitting
- [x] Recovery-Aware Overload progressive weight adjustments
- [x] Training Reliability Score completed/skipped/rescheduled logging
- [x] Strength Potential and Athletic Profile calculations
- [x] Movement Asymmetry Detection left vs right joint angle offsets
- [x] Video-based Rep-Speed Trend Analysis duration calculations
- [x] Exercise Skill Trees & Mastery progression rules
- [x] Camera-guided Athletic Testing Battery quarterly updates
- [x] Performance Forecasting strength & cardiovascular projections
- [x] Adaptive Computer Vision Loop (ACVL) state transitions
- [x] MethodChannel native ADPF thermal monitoring hook
- [x] Dynamic frame-dropping & isolate processing integration
- [x] UI optimization mode active alert banner

## Phase 7 — Gamification

- [x] All XP events are outcome-based (no logging XP)
- [x] Level-up animation on every level change
- [x] Habit smart triggers (not fixed-time reminders)
- [x] Karma Hub with achievement grid
- [x] Demographic Cohort Insights & Benchmarks opt-in and distribution charts

## Phase 8 — Transformation

- [x] Transformation Memory persisted and updated monthly
- [x] Consistency tracker running daily
- [x] Relapse intervention messages (3 tiers + squad nudge)
- [x] 90-day prediction layer on weight chart (ranges, not exact)
- [x] Progress photo system (encrypted local, biometric lock)

## Phase 9 — Social

- [x] Squad creation + invite code
- [x] Squad Readiness Board implemented (tier only, not score)
- [x] Squad Missions generated from aggregate squad data
- [x] Squad Challenges system
- [x] Relapse detection integrates squad nudge
- [x] Activity Feed screen (/feed) displaying workouts, routes, milestones, and high-fives
- [x] Geolocation Clubs and Interest Circles scanning & creation
- [x] Regional (City) and Cohort (Age-Group) leaderboards with anonymity toggle

## Phase 10 — Predictive Health

- [x] All 6 risk patterns in PreventiveIntelligenceEngine
- [x] Biological age estimation (monthly, algorithm-based)
- [x] Monthly report generation
- [x] Continuous Glucose Monitor (CGM) integration and spike detection engine
- [x] Medication Scheduler & Log Tracker
- [x] Drug-Nutrient & Drug-Workout interaction warning checks
- [x] Passcode-protected Doctor Sharing Portal PDF export
- [x] DPDP Act & Medical Disclaimers compliance logic
- [x] Retrospective Glycemic Processing Pipeline (RGPP) scan execution
- [x] Retrospective Glucose Matcher baseline and peak logic
- [x] Background sync worker for late-arriving CGM batches
- [x] Dynamic glucose variant badge rendering on historical logs

## Phase 11 — Visual Analytics

- [x] Body measurements logging and charting
- [x] Lean mass estimation
- [x] 90-day projection on charts (shown as range)

## Phase 12 — Festival + Life Events

- [ ] Festival cross-module adaptation engine implemented and tested
- [ ] All 10 festivals in calendar
- [ ] Festival Survival Mode activates 3 days before
- [ ] Life Events Engine with all supported event types
- [ ] Navratri fasting food filter
- [ ] Ramadan Sehri/Iftar mode

## Phase 13 — Premium

- [ ] RevenueCat configured with App Store + Play Store product IDs
- [ ] 7-day free trial tested end-to-end
- [ ] Paywall triggers for all Pro features
- [ ] Paywall: bottom sheet only, always shows "Continue Free"
- [ ] Entitlement checks in all Pro/Elite features
- [ ] Creator Profiles database and matchmaking service
- [ ] Program Marketplace store direct purchase & wallet royalty distribution
- [ ] Creator Affiliate referral links tracking and recurring payouts dashboard

## v1.0 Architecture Hardening

- [ ] SQLCipher key generation uses `Random.secure()`, not timestamp-based generation
- [ ] `fitkarma-health-os` runs as Cloudflare Workflows fan-out, not a sequential per-user loop
- [ ] DIP generation is scheduled per-user by `timezoneOffsetMinutes` + `preferredDIPHour`, not hardcoded to 6am IST
- [ ] Sync conflict resolution uses HLC timestamps, not raw device clock
- [ ] Cumulative log sync batches carry a `syncBatchId` and are server-side deduplicated
- [ ] `UserScores` table live; `Users` no longer holds overwritable score columns
- [ ] `ai_cache` scoped by `user_id`; account deletion purges cached AI outputs
- [ ] `ClinicalCopyLinter` passes in CI for all §P10-I/H/J copy changes

## Phase 16 — India Growth & Trust Layer

- [ ] WhatsApp Business Cloud API webhook (`fitkarma-whatsapp`) live; reuses existing food-parsing pipeline
- [ ] WhatsApp opt-in/opt-out flow in Settings, off by default
- [ ] Vernacular ASR integrated (Hindi, Tamil, Telugu, Marathi, Bengali, Kannada) ahead of existing food/workout parser
- [ ] ABHA Health ID linking flow (OAuth) and encrypted storage of `abhaHealthId`
- [ ] Doctor Sharing Portal FHIR-lite export mode (ABHA-linked), passcode PDF remains default
- [ ] `OrganizationAccounts` / `EmployeeEnrollments` tables live; org dashboard enforces minimum-cohort-size threshold before showing any aggregate
- [ ] Grocery Vendor Adapter interface implemented for at least one partner (Blinkit/BigBasket/Zepto)
- [ ] Affiliate order tracking reuses §P13-C ledger, not a parallel system

## Phase 14 — Hardening

- [ ] Biometric lock tested on physical device
- [ ] Offline → online sync round-trip in Airplane mode
- [ ] DLQ alert banner after 3 sync failures
- [ ] GlassCard blur disabled on DeviceTier.low
- [ ] All `--dart-define` vars set for dev/staging/production
- [ ] Sentry PII stripping verified
- [ ] AI cache keys contain no PII
- [ ] Golden tests generated and passing for all primary screens
- [ ] DPDP Act compliance: Privacy Policy written and linked
- [ ] Cold start < 2s on mid-tier device
- [ ] Daily Briefing open < 100ms (DIP from Drift, no AI)

---

## Pre-Launch Gate

Do not merge `develop` → `main` until:

- [ ] Every checkbox above is checked
- [ ] Full CI pipeline (`test`, `test-workers`) is green on the release candidate commit
- [ ] Staging has run the release candidate for at least a few days with real device testing
- [ ] `production` environment reviewer sign-off obtained (the GitHub Environment gate)

## Post-Launch (Within 30 Days)

- [ ] Indian food database expanded to 10,000+ items
- [ ] AI cost per user/day measured against projections
- [ ] DIP generation success rate monitored
- [ ] Model routing tuned from real usage patterns
- [ ] HealthKit background delivery tested for overnight sleep
- [ ] Push notification open rates measured; meal reminder A/B tested
- [ ] Subscription conversion funnel analyzed (trial → paid)
- [ ] Home widget (iOS + Android): today's steps + health score
- [ ] Wedding mode end-to-end tested with synthetic data
- [ ] Program Evolution Engine first transitions validated
- [ ] Transformation Memory accuracy validated at 4-week mark