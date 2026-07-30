# FitKarma — TODO / Launch Checklist

Derived from the Master Launch Checklist in [`Fitkarma_documentation.md`](./Fitkarma_documentation.md),
reorganized with environment/CI-CD setup called out as its own tracked phase since it's a
prerequisite for shipping anything past local dev. Check items off as they land.

---

## Phase -1 — Repo, Environments & CI/CD (do this before Phase 0)

- [ ] `develop` and `main` branches created; `main` protected (require PR + passing checks)
- [ ] `production` GitHub Environment configured with required reviewers (Settings → Environments)
- [ ] `wrangler.toml` created from `wrangler.toml.example` with `[env.staging]` and `[env.production]` blocks
- [ ] `fitkarma-db-staging` and `fitkarma-db-production` D1 databases created (separate, never shared)
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

- [ ] Flutter project created with `--dart-define` multi-env setup
- [ ] Sub-directory README documentation created in `lib/core`, `lib/data`, `lib/features`, `lib/shared`, `workers`
- [ ] All design tokens in `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
- [ ] GlassCard tier-aware (blur on Mid/High, solid on Low)
- [ ] All shared components built: GlowingMetric, ActivityRings, QuickLogFab, InsightCard, ShimmerLoader, HealthScoreRing
- [ ] Health OS Brain scaffolded: `daily_intelligence_package.dart`
- [ ] AI Router implemented: rule engine, template engine, model selector
- [ ] Decision Hierarchy implemented and tested
- [ ] Drift schema v6 initialized with all tables including DIP, HealthSnapshot, TransformationMemory, LifeEvents
- [ ] SQLCipher encryption configured, key generated via `Random.secure()`, stored in keychain
- [ ] Sync worker running (priority queue, 3-retry DLQ) against **staging** D1
- [ ] GoRouter with all routes defined

## Phase 1 — Onboarding

- [x] All 7 onboarding screens functional end-to-end on fresh install
- [x] Demographics: BMI/TDEE/targets computed locally (no AI)
- [x] Diet plan preferences & Ayurvedic Dosha quiz complete, result stored
- [x] Program Blueprint with program evolution path shown upfront
- [x] Permissions screen: HealthKit (iOS) + Health Connect (Android) tested

## Phase 2 — Daily Mission + Readiness

- [ ] Three-tier readiness model implemented (Basic/Enhanced/Premium)
- [ ] Readiness score computed locally with correct tier and confidence label
- [ ] Morning check-in: 3-question ritual
- [ ] DIP loaded from Drift on Daily Briefing open — zero AI calls at open time
- [ ] Health Score computed and displayed
- [ ] Decision Hierarchy resolving conflicts correctly
- [ ] Recovery log screen functional with confidence tier displayed
- [ ] Sleep Need Calculator & Bedtime Coach schedules
- [ ] Sleep Performance Score 4-pillar calculations
- [ ] Daily Strain Score 0–21 activity tracking calculations
- [ ] Recovery Capacity bounds and Decision Engine mapping
- [ ] Recovery Prescription actionable checklists
- [ ] Circadian Score midpoint shifting penalty rules
- [ ] Illness & Sickness biometric alarm triggers
- [ ] Recovery Drivers contribution parsing

## Phase 3 — AI Coach

- [ ] `fitkarma-health-os` Cloudflare Cron Trigger deployed (per-user timezone-aware, not hardcoded 6am IST)
- [ ] DIP generation: single AI call, compressed context, stored to Drift
- [ ] `fitkarma-coach` Worker: compressed context + conversation memory
- [ ] AI Router routing to correct model tier per request
- [ ] Prompt cache operational
- [ ] Event-driven insight triggers implemented
- [ ] Conversation summary + last-5 memory implemented

## Phase 4 — Health Tracking

- [ ] Dashboard reads from DIP — no AI calls on open
- [ ] Steps auto-detection from HealthKit/Health Connect
- [ ] Sleep, BP, Glucose screens functional
- [ ] Preventive Intelligence Engine: all 6 risk patterns, rule-based
- [ ] Risk alerts feeding into Decision Hierarchy

## Phase 5 — Nutrition

- [ ] Indian food database seeded (5,000+ items at launch)
- [ ] Barcode scan tested on physical device
- [ ] Meal quality scoring (5 dimensions) per meal
- [ ] Meal analysis pipeline: macros → quality → readiness impact → goal impact → suggestions
- [ ] Meal vision: known-meal cache → Groq Vision fallback
- [ ] Protein alert rule-based (< 70% target), no AI
- [ ] Periodization Engine phase transition checks
- [ ] Protein Distribution & Timing Score calculations
- [ ] Micronutrient Tracker with dietary profile alerts
- [ ] Nutrition Adherence Score 0–100 calculations
- [ ] OCR Menu Scanner with goal-based highlight overlays
- [ ] Smart Festival Nutrition pre-compensation and post-recovery
- [ ] Adaptive Hunger & Cravings trigger alerts
- [ ] Personal food score overrides via CGM Glycemic Response
- [ ] Budget-Optimized Grocery knapsack swaps
- [ ] Nutrition Reliability Score rolling calculations and Target Lockout rules
- [ ] Satiety Prediction Engine scores and database satiety reference index
- [ ] Family Meal Planner clinical conflict prioritizing and portion scaling
- [ ] Food Substitution Engine registry overrides and satiety improvement swaps

## Phase 6 — Workout

- [ ] Program blueprint generator (AI, cached)
- [ ] Progressive overload engine (deterministic)
- [ ] Program Evolution Engine triggers tested
- [ ] Active workout screen with rest timer and set logging
- [ ] Completion outcome XP (not logging XP)
- [ ] On-device pose estimation joint angle calculations (MediaPipe integration)
- [ ] Movement Weakness Profile fault accumulation heuristics
- [ ] Mobility Diagnosis Engine cause mappings and drill prescriber
- [ ] Biomechanical Injury Risk Forecasting combining kinematic variance and sleep debt
- [ ] Movement Memory database logging and progress reporting
- [ ] Exercise Confidence Score tempo and jitter variance checks
- [ ] Movement Health Score unified synthesis
- [ ] Camera-Based Fitness Onboarding assessment for Movement Age
- [ ] Adaptive Exercise Selection smart replacement triggers
- [ ] Local Muscle Readiness upper and lower body fatigue splitting
- [ ] Recovery-Aware Overload progressive weight adjustments
- [ ] Training Reliability Score completed/skipped/rescheduled logging
- [ ] Strength Potential and Athletic Profile calculations
- [ ] Movement Asymmetry Detection left vs right joint angle offsets
- [ ] Video-based Rep-Speed Trend Analysis duration calculations
- [ ] Exercise Skill Trees & Mastery progression rules
- [ ] Camera-guided Athletic Testing Battery quarterly updates
- [ ] Performance Forecasting strength & cardiovascular projections
- [ ] Adaptive Computer Vision Loop (ACVL) state transitions
- [ ] MethodChannel native ADPF thermal monitoring hook
- [ ] Dynamic frame-dropping & isolate processing integration
- [ ] UI optimization mode active alert banner

## Phase 7 — Gamification

- [ ] All XP events are outcome-based (no logging XP)
- [ ] Level-up animation on every level change
- [ ] Habit smart triggers (not fixed-time reminders)
- [ ] Karma Hub with achievement grid
- [ ] Demographic Cohort Insights & Benchmarks opt-in and distribution charts

## Phase 8 — Transformation

- [ ] Transformation Memory persisted and updated monthly
- [ ] Consistency tracker running daily
- [ ] Relapse intervention messages (3 tiers + squad nudge)
- [ ] 90-day prediction layer on weight chart (ranges, not exact)
- [ ] Progress photo system (encrypted local, biometric lock)

## Phase 9 — Social

- [ ] Squad creation + invite code
- [ ] Squad Readiness Board implemented (tier only, not score)
- [ ] Squad Missions generated from aggregate squad data
- [ ] Squad Challenges system
- [ ] Relapse detection integrates squad nudge
- [ ] Activity Feed screen (/feed) displaying workouts, routes, milestones, and high-fives
- [ ] Geolocation Clubs and Interest Circles scanning & creation
- [ ] Regional (City) and Cohort (Age-Group) leaderboards with anonymity toggle

## Phase 10 — Predictive Health

- [ ] All 6 risk patterns in PreventiveIntelligenceEngine
- [ ] Biological age estimation (monthly, algorithm-based)
- [ ] Monthly report generation
- [ ] Continuous Glucose Monitor (CGM) integration and spike detection engine
- [ ] Medication Scheduler & Log Tracker
- [ ] Drug-Nutrient & Drug-Workout interaction warning checks
- [ ] Passcode-protected Doctor Sharing Portal PDF export
- [ ] DPDP Act & Medical Disclaimers compliance logic
- [ ] Retrospective Glycemic Processing Pipeline (RGPP) scan execution
- [ ] Retrospective Glucose Matcher baseline and peak logic
- [ ] Background sync worker for late-arriving CGM batches
- [ ] Dynamic glucose variant badge rendering on historical logs

## Phase 11 — Visual Analytics

- [ ] Body measurements logging and charting
- [ ] Lean mass estimation
- [ ] 90-day projection on charts (shown as range)

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