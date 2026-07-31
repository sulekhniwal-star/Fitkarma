---
name: fitkarma-dev
description: Institutional knowledge and working goals for developing FitKarma, an AI-powered offline-first health and wellness Flutter app (com.sulekhniwal.fitkarma) targeting the Indian market, plus its companion admin platform FitKarma Hub. Use this skill whenever working in the FitKarma codebase — for feature implementation against Fitkarma_documentation.md/TODO.md, Gradle/build fixes, Drift/SQLCipher schema or sync work, Riverpod state management, Cloudflare (Workers/D1/R2) backend or Groq LLM integration, Health Connect / MediaPipe pose estimation work, RevenueCat billing, CI/CD (GitHub Actions, dev/staging/production environments), or debugging JVM/NDK/CMake build errors. Trigger on any mention of FitKarma, FitKarma Hub, "the app", Drift, Riverpod, Cloudflare, Workers, D1, R2, Health Connect, TODO.md, or Flutter build errors in this project — even if the user doesn't say "FitKarma" explicitly.
---

# FitKarma Development Skill

Institutional context and working goals for the FitKarma codebase — an offline-first,
AI-adaptive health and wellness platform for India. Load this before touching the codebase so
you don't relearn architecture decisions, re-trip build issues that are already solved, or
lose sight of what "done" actually means for a given piece of work.

## 0. What Success Looks Like Here

FitKarma's differentiator is **one orchestrated intelligence layer, not a pile of AI
features**. Every goal below traces back to this:

- **Goal: the app never makes a redundant AI call.** One Daily Intelligence Package (DIP) is
  generated per user per day; every screen (coach, nutrition, workout, dashboard) reads from
  it instead of independently calling an LLM. If you're adding a feature and reaching for the
  AI Router more than once per user session for the same underlying question, stop — you're
  probably duplicating the DIP's job.
- **Goal: the app works with zero connectivity, indefinitely.** Not "handles brief offline
  gaps" — a user should be able to log workouts, meals, and recovery data for days with no
  network and have it all sync correctly once they reconnect. This is the actual product bet
  (India has patchy connectivity outside metros), not a resilience nice-to-have.
- **Goal: nothing critical depends on a single foreign SaaS domain.** This isn't paranoia —
  India blocked Supabase outright in Feb 2026 under IT Act Section 69A with no warning. Every
  infra decision documented below (Cloudflare over Azure/Appwrite, self-rolled auth over
  Clerk/Firebase) exists to keep FitKarma's critical path off any single external domain India
  could plausibly block. When evaluating a new dependency, ask this question before ease-of-
  integration.
- **Goal: deterministic logic stays deterministic.** The master doc tags dozens of engines
  "Pure Dart", "Rule-Based", or "No AI" specifically because AI calls cost money, add latency,
  and are non-reproducible — none of which are acceptable for things like BMI calculation,
  progressive overload, or protein-threshold alerts. Treat these tags as hard constraints, not
  suggestions.

## 1. Project Overview

| | |
|---|---|
| **Product** | FitKarma — India's Intelligent Health Operating System (offline-first, AI-adaptive) |
| **Companion product** | FitKarma Hub — admin/ops platform (5 workspaces) |
| **Package ID** | `com.sulekhniwal.fitkarma` |
| **Platforms** | Android (primary), iOS |
| **Owner** | Sulekh (Founder & CEO) |

### The three governing documents — know which one to open

- **`Fitkarma_documentation.md`** — the master spec. Every algorithm, formula, wireframe,
  Drift/D1 schema field, and Worker's code lives here. **This is the only source of truth for
  *how* to build something.** ~250 named subsections across 16 phases plus DB schema, Worker
  definitions, glossary, and ADRs.
- **`TODO.md`** — the task graph. Every checkbox maps 1:1 to a §-coded section of the master
  doc (e.g. `§P5-G`) and tells you what order to build in. It does not contain implementation
  detail — it points at where that detail lives.
- **`AGENT_PROMPT.md`** — the standing instruction for how an AI agent should move through
  `TODO.md` against the master doc: read the §-section first, implement exactly what it says,
  ask rather than guess on ambiguity (especially §P10, the clinical/medical-adjacent surface),
  write tests, check the box, PR into `develop`, never commit straight to `develop`/`main`.

If you're an agent working in this repo and you haven't read `AGENT_PROMPT.md` yet this
session, read it before starting a task — it's short and it's the actual operating procedure.

## 2. Tech Stack

- **Framework:** Flutter 3.x
- **State management:** Riverpod 2.x
- **Local DB:** Drift (SQLite) + SQLCipher for encryption at rest, key via `Random.secure()`
- **Backend:** Cloudflare — Workers (compute/API), D1 (SQLite-at-the-edge), R2 (object storage)
- **Fan-out/orchestration:** Cloudflare Workflows (daily DIP generation, per-user error isolation)
- **LLM provider:** Groq, called only from Workers via the AI Router (multi-model tiered
  routing — never a single hardcoded model call, and never called from the Flutter client)
- **Auth:** Self-rolled, in a Worker — JWT sessions (jose, HS256), email OTP + Google/Apple
  Sign-In, users table in D1
- **Billing:** RevenueCat
- **Pose estimation:** MediaPipe (on-device)
- **Monitoring:** Sentry
- **CI/CD:** GitHub Actions, dev/staging/production split (see §5)

### Why the backend looks like this — the actual decision chain

1. **Originally Azure.** Migrated off it.
2. **Evaluated Appwrite (self-hosted)** as an Azure replacement.
3. **India blocked Supabase in Feb 2026** (Section 69A, no warning) — this is the event that
   reframed the whole decision. It proved that depending on a single foreign SaaS domain for a
   critical path is a real, not theoretical, risk for an India-only product.
4. **Settled on Cloudflare** (Workers/D1/R2) — deeply embedded in India's own internet
   infrastructure, making it a far less plausible single-service block target than a niche
   BaaS, plus a genuinely free-forever tier rather than a capped trial.
5. **Chose self-rolled JWT auth over Clerk/Firebase Auth** for the same reason, applied to the
   most critical path of all: if auth goes down, nobody can log in, which is strictly worse
   than a DB outage. Adding a managed third-party auth SaaS would have reintroduced the exact
   risk class the whole migration was meant to eliminate.

**If you're evaluating any new third-party dependency for FitKarma, run it through step 5's
logic before adding it** — "is this a single foreign domain something critical would break
without" is now a standing design constraint, not a one-time decision.

Offline-first is not optional per feature — every data-writing feature degrades gracefully
without connectivity and reconciles with D1 via the sync layer when back online.

## 3. Architecture Concepts (product-level — map new work onto these, don't invent parallels)

- **Health OS Brain** (§P0-E) — the central intelligence layer. Everything else reads from it.
- **Daily Intelligence Package (DIP)** — the single daily bundle assembled once per user; every
  screen reads from this instead of calling AI independently. **Goal: Daily Briefing opens in
  under 100ms from a cold DB read** — if a screen open is triggering an AI call, that's a bug,
  not a feature.
- **AI Router** (§P0-F) — tiered model routing by task cost/complexity. New AI features plug
  into this, never call Groq directly.
- **Decision Hierarchy** (§P0-E) — resolves conflicting signals (e.g. high strain + planned
  hard workout) into one coherent recommendation.
- **Program Evolution Engine** (§P0-G) — adapts user programs over time as they progress.
- **Life Events Engine** (§P12-B) — reacts to real-world events (travel, illness, festivals,
  schedule changes) across every module, not just one.
- **Transformation Memory** (§P8-A) — longitudinal memory of user progress, updated monthly.
- **Three-tier readiness confidence model** (§P2-A) — Basic/Enhanced/Premium, gated on data
  availability, not subscription tier. Confidence label shown must always match the tier
  actually used — don't show "Premium confidence" on Basic-tier data.

The full spec for all of the above — 16 development phases, ~250 named subsections — lives in
`Fitkarma_documentation.md`. Consult it before redesigning any of these concepts rather than
re-deriving them from scratch; they're already load-bearing across multiple phases.

## 4. Feature Surface (what's actually being built — see `TODO.md` for the full breakdown)

Offline-first core · Health OS Brain + AI Router · Adaptive Metabolism Engine · Environmental
Health Layer (AQI/UV/heat) · Onboarding + Women's Health Layer · Readiness + Recovery
Operating System (sleep, strain, circadian) · AI Adaptive Coach + Escalation Layer · Health
tracking (steps/sleep/BP/glucose) + Preventive Intelligence · Smart Indian Nutrition System
(11 sub-engines: periodization, protein timing, micronutrients, festival adaptation, cravings,
CGM-personalized scoring, grocery optimization, satiety prediction, family planning,
substitution) · Workout + Movement Intelligence (5-level platform, ACVL camera pipeline with
thermal-aware downsampling) · Gamification/Karma · Transformation Journey + Habit Identity ·
Social/Squad/Family/Geolocation Clubs/Leaderboards · Predictive Health (injury risk, stress
detection, clinical report parsing, longevity score, CGM sync, medication interactions, doctor
sharing) · Visual Body Analytics · Festival + Life Events + Wedding Mode + Travel Intelligence
· Premium/Marketplace/Creator Affiliate · India Growth Layer (WhatsApp logging, vernacular
voice, ABHA Health ID, corporate wellness, grocery vendor checkout).

**This list exists so nothing gets silently dropped when planning work — if a request touches
any of these areas, check `TODO.md` for the exact §-codes before scoping the task.**

## 5. Environments — Development, Staging, Production (P0 constraint, not a nice-to-have)

One repo, two live Cloudflare environments plus local dev, via `wrangler.toml`'s `[env.*]`
blocks:

| | Local dev | Staging | Production |
|---|---|---|---|
| Branch | any feature branch | `develop` | `main` |
| Worker | `wrangler dev` | `fitkarma-api-staging` | `fitkarma-api` |
| D1 database | `fitkarma-db-dev` | `fitkarma-db-staging` | `fitkarma-db-production` |
| JWT secret | local `.dev.vars` | unique per-env secret | unique per-env secret |
| Deploy trigger | manual | automatic on push to `develop` | automatic on push to `main`, gated behind CI passing **and** required-reviewer approval |

**Goal: a feature branch can go PR → `develop` → staging → PR → `main` → (approval) →
production with zero manual `wrangler deploy` commands.** Never share a JWT signing secret
across environments — a staging-issued token must never authenticate against production.

## 6. Build System — Known Failure Modes & Fixes (check here before re-diagnosing)

- **JVM target mismatches across plugins** (seen with `health`, `msal_flutter`, similar) —
  align `jvmTarget`/`sourceCompatibility` across all Gradle modules, not just `app/build.gradle`.
- **KGP (Kotlin Gradle Plugin) self-application warnings** — check for duplicate/implicit
  plugin application across included builds.
- **NDK/CMake ABI filter issues (x86 ABI)** — verify `abiFilters` are consistent between
  `build.gradle` and any native plugin's own CMake config.
- **Gradle lifecycle constraint errors** — usually a plugin registering tasks outside the
  expected `afterEvaluate`/configuration lifecycle; check plugin apply order first.
- **iOS CI build failures:** `device_info_plus` ARC issue — requires a build-time patch step
  in the workflow; vanilla `flutter build ios` will not succeed in CI without it.
- **Drift bug — `isSmallerThanValue`:** verify comparison operators explicitly in any Drift
  query used for sync filtering rather than trusting Drift's generated SQL. This predates the
  Cloudflare migration but the underlying Drift usage pattern is unchanged — re-check it
  against the D1 sync layer.
- **D1 write limits:** free tier caps at 100K row writes/day. FitKarma's workout/nutrition/
  Health-Connect logging is write-heavy — model expected daily writes per active user before
  assuming the free tier holds at scale; budget for Workers Paid ($5/mo base) once it doesn't.
- **D1 is SQLite, not Postgres/document-store** — schema and query patterns should mirror the
  local Drift/SQLite schema closely. This is a genuine advantage of the Cloudflare choice;
  don't fight it by modeling D1 as if it were a document store.
- **ACVL thermal throttling (§P6-F):** the pose-estimation pipeline is the single most likely
  feature to cause real-device thermal shutdowns. **Goal: 20+ minutes of camera-based form
  tracking on a mid-tier Android device with no thermal shutdown or frame-rate collapse** —
  test this on physical hardware, not an emulator, before considering ACVL work done.

## 7. Dev Environment

- Windows + Android Studio, Flutter toolchain.
- AVD: Pixel 7, API 34, Google Play image.
- Known issue: **Vulkan driver problems on Intel Iris Xe** — if emulator rendering is
  broken/crashing, check Vulkan/ANGLE settings before assuming it's an app bug.
- Physical device testing: Pixel 6a over **ADB wireless debugging** (reconfirm current IP if
  stale — DHCP leases drift).
- Hot reload configured in Android Studio.

## 8. Best Practices for This Codebase

- Route new AI-driven features through the existing multi-model AI Router — never call the
  Groq API directly from feature code, and never from the Flutter client — Groq calls belong
  in a Worker.
- Before writing a new "engine," check whether the master doc already tags it Pure Dart/Rule-
  Based/No AI — if so, that's a hard constraint on the implementation, not a starting point for
  discussion.
- Treat every data-writing feature as offline-first: write to Drift first, let the sync layer
  reconcile with D1.
- SQLCipher-encrypted fields are encrypted at rest already — don't add a second application-
  layer encryption pass without checking the existing schema.
- Design D1 schema to mirror the local Drift/SQLite schema — minimize translation logic by
  keeping table shapes aligned.
- Use R2 for user-generated media (progress photos, cached pose-estimation frames) — never
  store binary blobs in D1.
- Match Gradle config changes across all modules/plugins, not just `app/`.
- Instrument new flows with Sentry consistently with existing flows.
- Watch D1 write volume as a first-class metric — it's the free-tier constraint most likely to
  bite FitKarma given how write-heavy logging is across nutrition/workout/health tracking.
- For any PR touching §P10-I, §P10-H, or §P10-J (clinical/medical content), run the
  `ClinicalCopyLinter` and satisfy the Clinical Copy Change Checklist before merging — this is
  a compliance requirement, not a style preference.
- Every new feature should answer "which existing concept does this belong to" (§3) before
  answering "how do I build it" — architecture drift compounds fast across a 16-phase spec.

## 9. Common Mistakes to Avoid

- Editing `app/build.gradle` JVM target without checking plugin-level `build.gradle` files —
  reintroduces the JVM mismatch bug.
- Assuming `flutter build ios` works unmodified in CI — needs the `device_info_plus` ARC patch.
- Trusting Drift's `isSmallerThanValue` comparisons without double-checking against raw SQL.
- Building new "intelligence" features as standalone modules instead of wiring them into the
  Health OS Brain / DIP — causes architecture drift from the documented spec.
- Assuming R2 Class A operations (writes/deletes/list) are as cheap as reads — billed
  separately, add up faster than storage itself.
- Referencing the deprecated Appwrite sync worker or Azure setup in new code — if you find
  either while working in the codebase, flag for cleanup rather than extending.
- Routing a Pure-Dart/deterministic engine through the AI Router because "engine" sounds AI-
  shaped — check the master doc's tag before deciding, every time.
- Implementing an item from `TODO.md` without opening its referenced §-section first — the
  one-line description is a pointer, not the spec.
- Guessing on ambiguous clinical/medical copy or logic (§P10) instead of flagging it — this is
  the one area where a wrong guess isn't cosmetic.
- Committing directly to `develop` or `main`, or manually running `wrangler deploy` outside the
  CI/CD pipeline — bypasses the test/approval gates that exist specifically to prevent a broken
  build from reaching production.

## 10. Further Reading (in-repo)

- `Fitkarma_documentation.md` — master spec, 16 phases, ~250 named sections, full DB schema,
  all 9 Cloudflare Workers, glossary, ADRs.
- `TODO.md` — full phase-by-phase task graph with §-code references.
- `AGENT_PROMPT.md` — standing operating procedure for AI agents working this codebase.
- `README.md` — repo structure, environment setup, CI/CD pipeline explanation.
- FitKarma Hub `todo.md` — 31 sections, ~418 tasks across the 5 admin workspaces; check before
  assuming a Hub module doesn't exist yet.