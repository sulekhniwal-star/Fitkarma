# FitKarma — Master Build Todo (v1.0)

Source of truth: `FitKarma_Documentation_v1.0.md`. Every feature is broken into concrete, independently-completable engineering tasks (data model → logic → UI → integration → tests), not a single line per feature. `§Px-y` references point back to the doc section.

Legend: 🆕 new in v1.0 (Phase 16) · 🔒 v1.0 hardening fix

---

# PHASE 0 — FOUNDATION

### §P0-A Design Philosophy
- [x] Define design token spec (dark-mode-first palette, glassmorphism blur values, spring physics curves)
- [x] Build bento-grid layout primitives as reusable widgets
- [x] Document design system in a shared style guide referenced by all screen builds

### §P0-B Project Structure
- [x] Scaffold module boundaries (features/, core/, data/, services/)
- [x] Set up dependency injection / Riverpod provider structure
- [x] Configure lint rules and folder-structure enforcement in CI

### §P0-C Architecture Overview
- [x] Stand up local Drift + SQLCipher database layer
- [x] Build Sync Engine (priority queue + DLQ, 3× retry)
- [x] Provision Azure SQL + Entra B2C auth
- [x] Wire offline-first read path (local Drift as source of truth for UI)

### §P0-D Design Tokens
- [x] Implement color tokens (dark mode primary + light mode fallback)
- [x] Implement typography scale
- [x] Implement spacing/radius/elevation tokens

### §P0-D2 Shared Foundation Widgets
- [x] Build GlassCard component (with `DeviceTier.low` blur fallback)
- [x] Build shared button/input/chip component library
- [x] Build loading/empty/error state components used across all screens

### §P0-E Health OS Brain
- [x] Implement `computeHealthSnapshot()` (deterministic, no AI)
- [x] Implement `checkAITrigger()` decision logic
- [x] Implement Daily Intelligence Package (DIP) generation + storage
- [x] Build DIP → Drift sync queue integration

### §P0-F AI Routing Layer
- [x] Implement tiny/medium/large model tier classifier
- [x] Wire Groq API client with per-tier model selection
- [x] Implement AI response caching (see AI Cache Implementation below)
- [x] Add fallback/retry logic for AI call failures

### §P0-G Program Evolution Engine
- [x] Define program-phase transition rules
- [x] Implement evolution trigger detection (deterministic)
- [x] Wire evolution events into Transformation Memory

### §P0-H Prerequisites
- [x] Document and provision all required SDKs/API keys (Groq, Azure, RevenueCat, Health Connect/HealthKit)
- [x] Set up local dev environment onboarding doc

### §P0-I Adaptive Metabolism Engine
- [x] Implement TDEE adaptation algorithm (MacroFactor-style rolling recalculation)
- [x] Build weight-trend smoothing logic
- [x] Wire adaptive TDEE into `dailyCalorieTarget` on Users

### §P0-J Environmental Health Layer
- [x] Integrate AQI data source
- [x] Integrate UV index data source
- [x] Integrate heat-index data source
- [x] Build environmental-adjustment logic feeding into Daily Mission recommendations

---

# PHASE 1 — ONBOARDING + USER PROFILE

### §P1-A Onboarding Flow Order
- [x] Implement onboarding flow controller/router
- [x] Add progress indicator + skip/back navigation rules

### §P1-B Welcome Screen
- [x] Build UI layout
- [x] Wire entry animation/branding
- [x] Widget test

### §P1-C Goals Screen
- [x] Build UI (multi-select goal picker)
- [x] Persist selected goals to `Users.goals` (JSON array)
- [x] Widget test

### §P1-D Demographics Screen
- [x] Build UI (age, gender, height, weight, activity level inputs)
- [x] Validation + unit conversion handling
- [x] Persist to Users table
- [x] Widget test

### §P1-E AI Diet Plan Results Screen
- [x] Build results UI
- [x] Wire initial AI diet plan generation call
- [x] Loading/error states for AI call
- [x] Widget test

### §P1-F Dosha Quiz Screen
- [x] Build quiz UI flow
- [x] Implement dosha-scoring logic (deterministic)
- [x] Persist result to `Users.dosha`
- [x] Widget test

### §P1-G Program Blueprint Selection Screen
- [x] Build program selection UI
- [x] Wire selection into `Users.currentProgram`
- [x] Widget test

### §P1-H Women's Advanced Health Layer
- [x] Build cycle-tracking data model
- [x] Implement cycle-aware training adjustment logic
- [x] Build cycle-tracking onboarding screens
- [x] Wire cycle phase into Daily Mission and Training OS
- [x] Unit tests for phase-detection logic

---

# PHASE 2 — DAILY MISSION + READINESS ENGINE

### §P2-A Readiness Engine
- [x] Implement readiness score calculation (deterministic)
- [x] Implement 3-tier confidence model
- [x] Unit tests across confidence tiers

### §P2-B Daily Briefing Screen (Daily Mission)
- [x] Build UI reading DIP directly from Drift (no AI call on open)
- [x] Verify open time < 100ms (§P14-B target)
- [x] Widget test

### §P2-C Recovery Log Screen
- [x] Build manual recovery logging UI
- [x] Persist to RecoveryLogs
- [x] Widget test

### §P2-D Recovery Operating System
- [x] Implement Sleep Need Calculator
- [x] Implement Bedtime Coach recommendation logic
- [x] Implement Daily Strain scoring (0–21 scale)
- [x] Implement Recovery Capacity calculation
- [x] Implement Recovery Prescriptions generator
- [x] Implement Circadian Score calculation
- [x] Implement Illness Detection (deviation-based)
- [x] Implement Recovery Drivers breakdown (JSON) surfaced in UI
- [x] Integration tests across the full Recovery OS pipeline

---

# PHASE 3 — AI ADAPTIVE COACH

### §P3-A AI Coach Philosophy
- [x] Document coach tone/persona rules referenced by prompt templates

### §P3-B AI Context Builder
- [x] Implement context compression (snapshot → prompt payload)
- [x] Unit tests for token-budget compliance

### 

### §P3-D Health Coach Escalation Layer
- [x] Implement escalation trigger logic (Elite tier)
- [x] Build human-coach handoff UI/workflow
- [x] Wire escalation event logging

---

# PHASE 4 — HEALTH TRACKING

### §P4-A Dashboard Screen
- [x] Build UI aggregating steps/sleep/BP/glucose widgets
- [x] Widget test

### §P4-B Steps Screen
- [x] Build UI + Health Connect/HealthKit sync
- [x] Persist to step logs (CumulativeLog pattern, §P0-C)
- [x] Widget test

### §P4-C Sleep Screen
- [x] Build UI + wearable/manual sleep entry
- [x] Persist to SleepLogs
- [x] Widget test

### §P4-D Blood Pressure Screen
- [x] Build manual BP entry UI
- [x] Persist to BpReadings
- [x] Widget test

### §P4-E Glucose Screen
- [x] Build manual glucose entry UI
- [x] Persist to GlucoseReadings
- [x] Widget test

### §P4-F Preventive Intelligence Engine
- [x] Implement deterministic risk-flagging rules (no AI)
- [x] Unit tests for each rule

### §P4-G Smart Wearable Comparison Layer
- [x] Implement Device Reliability Engine (cross-device delta detection)
- [x] Build wearable comparison UI
- [x] Unit tests

---

# PHASE 5 — SMART INDIAN NUTRITION SYSTEM

### §P5-A Food Screen Home
- [x] Build UI (quick-log, search, recent meals)
- [x] Widget test

### §P5-B Meal Analysis Pipeline
- [x] Implement text-based meal parser
- [x] Wire nutrition lookup against FoodReferences
- [x] Unit tests

### §P5-C "Fix My Meal" — AI Meal Photo Analysis
- [x] Build photo capture/upload UI
- [x] Wire `fitkarma-meal-vision` Azure Function
- [x] Implement result review/edit-before-save UI
- [x] Cache Groq Vision responses (AI cache)
- [x] Widget test

### §P5-D Smart Indian Meal Intelligence
- [x] Build regional cuisine recognition dataset mapping
- [x] Implement mixed-dish macro estimation logic
- [x] Unit tests

### §P5-E Indian Restaurant Intelligence 2.0
- [x] Build restaurant menu database integration
- [x] Implement dish-level nutrition estimation
- [x] Build restaurant search/browse UI

### §P5-F Grocery Optimization Engine 2.0
- [x] Implement shopping-list generation from meal plan
- [x] Wire `Users.monthlyGroceryBudgetInr` into list optimization
- [x] Build grocery list UI
- [x] 🆕 See §P16-E for vendor checkout extension

### §P5-G Nutrition Periodization Engine
- [x] Implement phase-based macro cycling logic
- [x] Wire `Users.nutritionPeriodizationPhase` transitions
- [x] Unit tests

### §P5-H Protein Distribution & Timing Intelligence
- [x] Implement MPS-aware protein timing algorithm
- [x] Wire into meal plan recommendations
- [x] Unit tests

### §P5-I Micronutrient Intelligence Core
- [x] Build micronutrient database mapping
- [x] Implement deficiency-risk detection logic
- [x] Persist to MicronutrientLogs
- [x] Build micronutrient dashboard UI

### §P5-J Nutrition Adherence Engine
- [x] Implement adherence scoring algorithm
- [x] Wire into Karma System (§P7-A)
- [x] Unit tests

### §P5-K Smart Festival Nutrition Adaptation
- [x] Implement festival calendar detection
- [x] Implement festival-specific macro/target adjustment logic
- [x] Integration with §P12-A Festival Intelligence

### §P5-L Adaptive Hunger & Cravings Engine
- [x] Implement craving-pattern detection logic
- [x] Build hunger-logging UI prompt
- [x] Unit tests

### §P5-M Glycemic Response & Personal Food Scoring
- [x] Implement personal glycemic scoring algorithm
- [x] Wire into §P10-L Retrospective Glycemic Processing Pipeline
- [x] Unit tests

### §P5-N Multi-Dimensional Meal Quality Score
- [x] Implement composite quality scoring (processing tier, micronutrients, satiety)
- [x] Build score display UI
- [x] Unit tests

### §P5-O Nutrition Reliability Score & Data Confidence Shield
- [x] Implement logging-consistency scoring
- [x] Wire "low confidence" UI messaging when data is sparse
- [x] Unit tests

### §P5-P Satiety Prediction Engine
- [x] Implement satiety prediction model (deterministic heuristics)
- [x] Wire into meal recommendations
- [x] Unit tests

### §P5-Q Family Nutrition Integration
- [x] Build FamilyMealPlans data model usage
- [x] Implement multi-member meal plan aggregation
- [x] Build family meal planning UI

### §P5-R Indian Food Substitution & Swap Engine
- [x] Build FoodSubstitutions lookup logic
- [x] Implement swap-suggestion algorithm (nutrition-equivalent alternatives)
- [x] Build swap suggestion UI

---

# PHASE 6 — WORKOUT SYSTEM & MOVEMENT INTELLIGENCE

### §P6-A Workout Screen Home
- [x] Build UI (program overview, today's workout)
- [x] Widget test

### §P6-B Active Workout Screen
- [x] Build set/rep logging UI
- [x] Implement rest timer
- [x] Persist to WorkoutLogs
- [x] Widget test

### §P6-C Progressive Overload Engine
- [x] Implement deterministic overload progression rules
- [x] Unit tests

### §P6-D Dynamic Fitness Blueprint Generator
- [x] Implement program generation algorithm from goals + equipment + experience
- [x] Unit tests

### §P6-E Training Operating System
- [x] Implement Movement Screening Engine
- [x] Implement Adaptive Overload logic
- [x] Implement Local Readiness (upper/lower body) scoring
- [x] Wire into UserScores (upperBodyReadiness / lowerBodyReadiness)
- [x] Integration tests

### §P6-F Adaptive Computer Vision Loop (ACVL)
- [x] Integrate MediaPipe pose estimation
- [x] Implement form-deviation detection algorithm
- [x] Build real-time form feedback UI overlay
- [x] Persist form-quality data to MovementLogs
- [x] Performance test on-device (frame rate, battery/thermal impact)

---

# PHASE 7 — GAMIFICATION + KARMA SYSTEM

### §P7-A Karma System Design
- [x] Implement outcome-based XP calculation rules
- [x] Persist to KarmaEvents
- [x] Unit tests

### §P7-B Karma Hub Screen
- [x] Build UI (XP history, levels, badges)
- [x] Widget test

### §P7-C Habit Automation System
- [x] Implement habit-streak detection logic
- [x] Persist to HabitLogs
- [x] Unit tests

### §P7-D Adherence Score
- [x] Implement adherence scoring algorithm (major KPI)
- [x] Wire into Karma Hub UI
- [x] Unit tests

### §P7-E Benchmarking Engine
- [x] Implement Fitness Percentile calculation vs. cohort
- [x] Build benchmarking UI
- [x] Unit tests

### §P7-F Demographic Cohort Insights & Network Effects
- [x] Implement anonymized cohort aggregation pipeline
- [x] Enforce minimum-cohort-size threshold before displaying any aggregate
- [x] Build cohort insights UI (city/age-group rankings)
- [x] Privacy audit: confirm no individual-level data leaks through aggregates

---

# PHASE 8 — TRANSFORMATION JOURNEY + ANTI-QUIT PSYCHOLOGY

### §P8-A Transformation Journey Engine
- [x] Implement journey-stage detection logic
- [x] Persist to TransformationMemories
- [x] Unit tests

### §P8-B Transformation Timeline Screen
- [x] Build UI (milestones, progress photos, journey stages)
- [x] Widget test

### §P8-C Habit Identity Layer
- [x] Implement identity-reinforcement messaging logic (behavior science)
- [x] Wire into Daily Mission and AI Coach prompts
- [x] Unit tests

---

# PHASE 9 — SOCIAL + SQUAD ACCOUNTABILITY

### §P9-A Social Screen
- [x] Build UI (feed entry point, squads, clubs)
- [x] Widget test

### §P9-B Squad System
- [x] Implement Squad Missions logic
- [x] Implement Squad Challenges logic
- [x] Persist to SquadGroups / SquadMembers
- [x] Build squad UI

### §P9-C Accountability Communities
- [x] Implement community membership logic
- [x] Build community UI

### §P9-D Family Health Hub
- [x] Build household management UI
- [x] Wire `Users.familyUnitId` grouping
- [x] Implement family-level dashboards (aggregated, permission-gated)

### §P9-E Activity Feed & Sharing Architecture
- [x] Implement Follow System data model + logic
- [x] Persist to Followers
- [x] Build Activity Feed UI
- [x] Implement Workout/Route/Transformation sharing cards
- [x] Feed pagination + performance test

### §P9-F Local Geolocation Clubs & Interest Circles
- [x] Implement geolocation-based club discovery
- [x] Persist to Clubs
- [x] Build club discovery + join UI

### §P9-G Weekly & Monthly Leaderboards
- [x] Implement leaderboard ranking computation (scheduled job)
- [x] Build leaderboard UI
- [x] Unit tests

---

# PHASE 10 — PREDICTIVE HEALTH + PREVENTIVE INTELLIGENCE

### §P10-A Health Risk Prevention System
- [x] Implement deterministic risk-flag rules
- [x] Unit tests

### §P10-B Biological Age Estimation
- [x] Implement monthly biological-age algorithm (no AI)
- [x] Unit tests

### §P10-C Monthly Health Report
- [x] Implement report generation job
- [x] Build report UI/export
- [x] Widget test

### §P10-D Injury Risk Engine
- [x] Implement injury-risk scoring logic
- [x] Wire into Training OS (§P6-E) recommendations
- [x] Unit tests

### §P10-E Stress Detection Engine
- [x] Implement inferred-stress detection algorithm (HRV/sleep/behavior signals)
- [x] Unit tests

### §P10-F Clinical Report Intelligence
- [x] Build lab report (PDF) upload + parsing pipeline
- [x] Implement lab-value extraction and normalization
- [x] Build clinical report UI
- [x] 🔒 Apply Non-Diagnostic Shield disclaimer (§P10-K)

### §P10-G Longevity Score + Biological Age v1
- [x] Implement composite longevity scoring algorithm
- [x] Build longevity score UI

### §P10-H Continuous Biomarker Tracking (CGM Sync)
- [x] Integrate CGM manufacturer sync APIs
- [x] Persist to CgmReadings
- [x] Build CGM trend UI
- [x] Wire into §P10-L Retrospective Glycemic Processing Pipeline

### §P10-I Medication Tracker & Interaction Warning Engine
- [x] Build medication schedule data model + UI
- [x] Persist to MedicationLogs
- [x] Integrate drug-interaction database (e.g., RxNorm)
- [x] Implement interaction-warning generation logic
- [x] 🔒 Run all warning copy through `ClinicalCopyLinter` (§P10-M)

### §P10-J Doctor Sharing Portal
- [x] Implement passcode-protected PDF export (default)
- [x] Build sharing UI + link/token management
- [x] 🆕 Implement FHIR-lite export mode (§P16-C ABHA integration)

### §P10-K Regulatory & Clinical Compliance Framework
- [x] Implement Non-Diagnostic Shield disclaimer component (reused across §P10-F/G/H/I)
- [x] Implement "Revoke All Clinical Access" single-tap setting
- [x] Implement anonymized cohort sync routing (excludes lab dates/medication brands)

### §P10-L Retrospective Glycemic Processing Pipeline (RGPP)
- [x] Implement late-arriving CGM batch detection
- [x] Implement retroactive food-window linking algorithm
- [x] Unit tests for sync-latency edge cases

### §P10-M Clinical Compliance Hardening 🔒
- [x] Implement `ClinicalCopyLinter` (banned directive-pattern regex set)
- [x] Wire linter into CI for any PR touching §P10-I/H/J copy
- [x] Add Clinical Copy Change Checklist to PR template
- [x] Gate Phase 10 behind a feature flag for initial opt-in cohort rollout
- [x] Schedule legal sign-off review before general availability

---

# PHASE 11 — VISUAL BODY ANALYTICS

### §P11-A Body Analytics Screen
- [x] Build UI (measurements, trends)
- [x] Persist to BodyMeasurements
- [x] Widget test

### §P11-B Progress Photo System
- [x] Build photo capture + comparison UI
- [x] Implement secure local photo storage (encrypted)
- [x] Persist metadata to TransformationChecks

### §P11-C Wearable-Free Body Composition Estimation
- [x] Implement photo-based body composition estimation algorithm
- [x] Unit tests against reference dataset

---

# PHASE 12 — FESTIVAL + LIFE EVENTS INTELLIGENCE

### §P12-A Festival Intelligence System
- [x] Build Indian festival calendar dataset
- [x] Implement cross-module festival adaptation hooks (nutrition, workout, mission)

### §P12-B Life Events Engine
- [x] Implement life-event detection/logging (wedding, injury, travel, etc.)
- [x] Persist to LifeEvents
- [x] Wire into Transformation Memory

### §P12-C Wedding Transformation Mode
- [x] Implement wedding-mode program generation
- [x] Build wedding countdown UI
- [x] End-to-end test with synthetic data

### §P12-D AI Roast Mode
- [ ] Implement opt-in "roast" tone variant for AI Coach
- [ ] Build toggle UI

### §P12-E Travel Intelligence (Travel Mode)
- [ ] Implement travel detection (timezone/location change)
- [ ] Implement travel-adjusted mission/nutrition logic
- [ ] 🔒 Verify DIP scheduling respects Travel Mode timezone (see v1.0 hardening)

### §P12-F Smart Calendar Integration
- [ ] Integrate device calendar API
- [ ] Implement calendar-aware scheduling suggestions
- [ ] Build calendar sync settings UI

---

# PHASE 13 — PREMIUM + MONETISATION

### §P13-A Subscription Tiers
- [ ] Implement Free/Pro/Elite tier gating logic
- [ ] Wire RevenueCat subscription management
- [ ] Build paywall/upgrade UI

### §P13-B Creator & Coach Marketplace
- [ ] Build CreatorProfiles data model + onboarding flow
- [ ] Implement creator-user matchmaking logic
- [ ] Build Program Store (direct purchase) UI
- [ ] Implement wallet/royalty distribution logic
- [ ] Wire `fitkarma-marketplace` Azure Function

### §P13-C Creator Affiliate Program
- [ ] Implement affiliate referral link generation + tracking
- [ ] Build recurring payout ledger
- [ ] Build affiliate dashboard UI
- [ ] 🆕 Reused by §P16-E Grocery Vendor Checkout for affiliate revenue tracking

---

# PHASE 14 — ENTERPRISE HARDENING + CI/CD

### §P14-A Security
- [ ] 🔒 Implement `_generateSecureKey()` using `Random.secure()` for SQLCipher key
- [ ] Enforce TLS 1.3 + certificate pinning on all network calls
- [ ] Verify Azure Function logs never contain user context
- [ ] Verify Sentry PII stripping (no names/emails in error reports)
- [ ] 🔒 Verify `ai_cache` scoped by `user_id`, prompt hashes only, no PII

### §P14-B Performance
- [ ] Verify cold start < 2s on mid-tier device
- [ ] Verify Daily Briefing open < 100ms (DIP read from Drift only)
- [ ] Verify GlassCard blur disabled on `DeviceTier.low`

### §P14-C Testing Strategy
- [ ] Unit test coverage for all deterministic engines
- [ ] Widget tests for all primary screens
- [ ] Golden tests generated and passing for all primary screens
- [ ] Offline → online sync round-trip test (airplane mode)
- [ ] DLQ alert banner test (3 consecutive sync failures)
- [ ] Biometric lock test on physical device

### §P14-D CI/CD Pipeline
- [ ] `test` job (flutter test) in GitHub Actions
- [ ] `build-android` job (release appbundle, dart-defines wired)
- [ ] `build-ios` job (release ipa)
- [ ] Verify all `--dart-define` vars set for dev/staging/prod

---

# PHASE 16 — INDIA GROWTH & TRUST LAYER 🆕

### §P16-A WhatsApp Business Logging
- [ ] Provision WhatsApp Business Cloud API account + webhook endpoint
- [ ] Implement `fitkarma-whatsapp` Azure Function (webhook handler)
- [ ] Implement phone-number → userId resolution
- [ ] Wire text messages into existing food-text parser
- [ ] Wire image messages into `meal_photo_analyzer` (§P5-C) pipeline
- [ ] Implement WhatsApp reply/confirmation messages
- [ ] Build in-app opt-in/opt-out flow (Settings → Link WhatsApp), off by default
- [ ] Test unlinked-number fallback message

### §P16-B Vernacular Voice Logging
- [ ] Integrate Azure Speech-to-Text (multi-language) client
- [ ] Implement `VoiceLogService` (ASR → existing food/workout parser)
- [ ] Build language locale mapping (`preferredInputLanguage` → ASR locale)
- [ ] Build mic input UI + language picker
- [ ] Test ASR accuracy per supported language (Hindi, Tamil, Telugu, Marathi, Bengali, Kannada, English-India)
- [ ] Test code-mixed input handling

### §P16-C ABHA Health ID Integration
- [ ] Implement ABHA OAuth linking flow (NDHM Health ID API)
- [ ] Store `abhaHealthId` encrypted at rest
- [ ] Build "Link ABHA Health ID" Settings screen
- [ ] Implement FHIR-lite export mode for Doctor Sharing Portal (§P10-J)
- [ ] Verify passcode-PDF export remains default/unaffected
- [ ] Apply §P10-M compliance boundary to all ABHA-linked sharing content

### §P16-D Corporate Wellness & Insurer Tier
- [ ] Build `OrganizationAccounts` data model + Azure SQL mirror
- [ ] Build `EmployeeEnrollments` data model + Azure SQL mirror
- [ ] Implement enrollment-code linking flow (opt-in, reversible)
- [ ] Implement org-facing aggregate query layer
- [ ] Enforce minimum-cohort-size threshold (reuse §P7-F logic) before rendering any aggregate
- [ ] Build HR/insurer dashboard UI (enrollment %, aggregate adherence distribution)
- [ ] Build org seat/billing management (corporate_basic / corporate_plus tiers)
- [ ] Privacy audit: confirm no per-user data is ever queryable from org-facing endpoints

### §P16-E Grocery Vendor Checkout Integration
- [ ] Define `GroceryVendorAdapter` interface
- [ ] Implement first vendor adapter (Blinkit or BigBasket or Zepto)
- [ ] Implement catalog-mapping logic (FitKarma generic items → vendor SKUs)
- [ ] Implement deep-link checkout with pre-filled cart + affiliate tag
- [ ] Wire affiliate order-confirmation webhook
- [ ] Reuse §P13-C affiliate ledger for revenue tracking (no parallel payout system)
- [ ] Build "Order groceries" CTA on Grocery Optimization Engine UI (§P5-F)

---

# DATABASE — DRIFT LOCAL SCHEMA (v17) & AZURE SQL MIRROR

### Schema & migration
- [ ] Implement all 36 Drift tables (see full list: Users, UserScores 🆕, OrganizationAccounts 🆕, EmployeeEnrollments 🆕, FoodLogs, FoodReferences, WorkoutLogs, SleepLogs, BpReadings, GlucoseReadings, WaterLogs, HabitLogs, MoodLogs, MedicationLogs, KarmaEvents, AiInsights, ChatMessages, DietPlans, RecoveryLogs, BodyMeasurements, SquadGroups, SquadMembers, TransformationChecks, DailyIntelligencePackages, HealthSnapshots, TransformationMemories, LifeEvents, Followers, Clubs, CgmReadings, CreatorProfiles, MicronutrientLogs, MealNutritionDetails, FamilyMealPlans, FoodSubstitutions, MovementWeaknessProfiles, MovementLogs)
- [ ] Mirror every table's DDL in Azure SQL
- [ ] Implement `ai_cache` table in Azure SQL 🔒 (scoped by `user_id`, composite key with `prompt_hash`)
- [ ] Verify legacy migrations v1→v2 through v15→v16 still pass on a fresh install
- [ ] 🔒 Implement v16→v17 migration: create `UserScores`, copy legacy score columns row-by-row, drop legacy columns from `Users` via `TableMigration`
- [ ] Implement v17 Phase 16 column additions (`timezoneOffsetMinutes`, `preferredDIPHour`, `whatsAppOptIn`, `abhaHealthId`, `preferredInputLanguage`)
- [ ] Implement v17 table creation (`OrganizationAccounts`, `EmployeeEnrollments`)
- [ ] Test upgrade path end-to-end: fresh v5 install → sequential upgrade through v17
- [ ] Implement `latestScore(userId, scoreType)` helper query + index `(userId, scoreType, computedAt DESC)`

---

# AZURE FUNCTIONS (CLOUD LAYER)

- [ ] `fitkarma-health-os-trigger` / `healthOSOrchestrator` / `generateDIPForUser` 🔒 — implement Durable Functions fan-out, verify per-user error isolation
- [ ] `getUsersDueForDIP` activity — implement per-user timezone-window filtering
- [ ] `fitkarma-social` — implement and deploy
- [ ] `fitkarma-marketplace` — implement and deploy
- [ ] `fitkarma-cores` — implement and deploy
- [ ] `fitkarma-coach` — implement and deploy
- [ ] `fitkarma-meal-vision` — implement and deploy
- [ ] `fitkarma-insights` — implement and deploy
- [ ] `fitkarma-reports` — implement and deploy
- [ ] `fitkarma-whatsapp` 🆕 — implement and deploy
- [ ] Load-test the fan-out orchestrator at realistic active-user volume (verify no timeout regression vs. old sequential loop)

---

# v1.0 ARCHITECTURE HARDENING 🔒 (CROSS-CUTTING)

- [ ] Replace timestamp-based key generation with `Random.secure()` in `EncryptedDatabaseConnection`
- [ ] Replace sequential DIP loop with Durable Functions fan-out + per-user error isolation
- [ ] Replace hardcoded 6am IST schedule with per-user `timezoneOffsetMinutes` + `preferredDIPHour`
- [ ] Replace raw-timestamp LWW with `HLCTimestamp`-based conflict resolution in `SyncMergeResolver`
- [ ] Add `syncBatchId` idempotency to all `CumulativeLog` sync batches; implement server-side dedup
- [ ] Extract 8 derived score columns off `Users` into `UserScores`; update all read sites to use `latestScore()`
- [ ] Add `user_id` scoping to `ai_cache`; implement `purgeCacheForUser` in account-deletion workflow
- [ ] Implement `ClinicalCopyLinter` and wire into CI for §P10-I/H/J copy changes
- [ ] Add Clinical Copy Change Checklist to PR template

---

# COMPLIANCE

- [ ] Write and link DPDP Act Privacy Policy
- [ ] Implement "Revoke All Clinical Access" single-tap wipe (local + Azure SQL)
- [ ] Implement Non-Diagnostic Shield disclaimer component, applied to all CGM/interaction/bio-age screens
- [ ] Verify anonymized cohort sync excludes individual lab dates / medication brand names
- [ ] Schedule pre-launch legal review of medication/interaction-warning copy and Doctor Sharing Portal PDF template

---

# POST-LAUNCH (WITHIN 30 DAYS)

- [ ] Expand Indian food database to 10,000+ items
- [ ] Measure AI cost per user/day against projections
- [ ] Monitor DIP generation success rate (verify fan-out per-user isolation in production)
- [ ] Tune model routing from real usage patterns
- [ ] Test HealthKit background delivery for overnight sleep
- [ ] Measure push notification open rates; A/B test meal reminders
- [ ] Analyze subscription conversion funnel (trial → paid)
- [ ] Build home widget (iOS + Android): today's steps + health score
- [x] End-to-end test Wedding Mode with synthetic data
- [ ] Validate Program Evolution Engine's first real transitions
- [ ] Validate Transformation Memory accuracy at the 4-week mark
- [ ] 🆕 Measure WhatsApp logging opt-in rate and message-parse accuracy
- [ ] 🆕 Measure vernacular voice logging ASR accuracy per language vs. typed-log baseline
- [ ] 🆕 Measure ABHA linking conversion rate
- [ ] 🆕 Onboard first corporate/insurer organization end-to-end
- [ ] 🆕 Measure grocery checkout affiliate conversion rate per vendor adapter

---

**Totals: 17 phases · 106 feature sections broken into ~430 concrete engineering tasks · 36 database tables · 9 Azure Functions · 9 v1.0 hardening fixes · full compliance and post-launch checklists.**