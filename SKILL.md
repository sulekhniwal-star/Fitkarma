---
name: fitkarma-dev
description: Institutional knowledge for developing FitKarma, an AI-powered health and wellness Flutter app (com.sulekhniwal.fitkarma) targeting the Indian market, plus its companion admin platform FitKarma Hub. Use this skill whenever working in the FitKarma codebase (F:\fitkarma) — for feature implementation, Gradle/build fixes, Drift/SQLCipher schema or sync work, Riverpod state management, Cloudflare (Workers/D1/R2) backend or Groq LLM integration, Health Connect / MediaPipe pose estimation work, RevenueCat billing, CI/CD (GitHub Actions), or debugging JVM/NDK/CMake build errors. Trigger on any mention of FitKarma, FitKarma Hub, "the app", Drift, Riverpod, Cloudflare, Workers, D1, R2, Health Connect, or Flutter build errors in this project — even if the user doesn't say "FitKarma" explicitly.
---

# FitKarma Development Skill

Institutional context for `F:\fitkarma` — an offline-first, AI-powered health and
wellness platform. Load this before touching the codebase so you don't
relearn architecture decisions or re-trip build issues that are already solved.

## 1. Project Overview

| | |
|---|---|
| **Product** | FitKarma — AI health/wellness app for the Indian market |
| **Companion product** | FitKarma Hub — admin/ops platform (5 workspaces) |
| **Package ID** | `com.sulekhniwal.fitkarma` |
| **Platforms** | Android (primary), iOS |
| **Local path** | `F:\fitkarma` |
| **Owner** | Sulekh (Founder & CEO) |

**Why it exists:** a tiered, offline-first fitness/nutrition/wellness app with
AI coaching at its core, not a bolt-on chatbot — the AI routing and "Health OS
Brain" concept is the product's differentiator, not a feature.

## 2. Tech Stack

- **Framework:** Flutter 3.x
- **State management:** Riverpod 2.x
- **Local DB:** Drift (SQLite) + SQLCipher for encryption at rest
- **Backend:** Cloudflare — Workers (compute/API), D1 (SQLite-at-the-edge), R2 (object storage)
- **LLM provider:** Groq, called from Workers (multi-model tiered routing — not a single-model call)
- **Billing:** RevenueCat
- **Pose estimation:** MediaPipe
- **Monitoring:** Sentry
- **Sync:** Custom sync layer between local Drift store and D1 (replaces the old Appwrite worker)
- **CI/CD:** GitHub Actions (Android + iOS)

**Backend history:** originally Azure, then evaluated Appwrite (self-hosted)
after India's Feb 2026 Section 69A block of Supabase raised concerns about
foreign-SaaS dependency risk. Settled on **Cloudflare** — Workers/D1/R2 have
a metered-but-effectively-free tier and Cloudflare's footprint in India's
internet infrastructure makes it a much less plausible single-service
blocking target than a niche BaaS.

Assume offline-first: every feature should degrade gracefully without
connectivity and reconcile with D1 when back online, rather than assuming a
live network for core flows.

## 3. Architecture Concepts (product-level, not just code)

When implementing features, map them to the existing conceptual architecture
rather than inventing parallel structures:

- **Health OS Brain** — the central intelligence layer that reasons over user
  state.
- **Daily Intelligence Package** — the daily bundle of context assembled for
  the AI layer.
- **Multi-model AI routing** — tiered routing across models by task
  cost/complexity, not a single hardcoded model call. New AI features should
  plug into this router, not call Groq directly.
- **Program Evolution Engine** — adapts user programs over time.
- **Life Events Engine** — reacts to real-world events affecting the user's
  plan (travel, illness, schedule changes).
- **Transformation Memory** — longitudinal memory of user progress.
- **Three-tier readiness confidence model** — used to gate how aggressively
  the app recommends changes.

Full spec lives in the FitKarma v2 documentation rewrite (14 development
phases) — consult it before redesigning any of the above rather than
re-deriving them from scratch.

## 4. Key Feature Areas

- Offline-first architecture (Drift/SQLCipher local store + Appwrite sync)
- AI routing (multi-model tiered system via Groq)
- Health Connect integration (Android health data)
- Nutrition intelligence
- Gamification
- Pose estimation via MediaPipe
- Geolocation-based clubs
- Subscription billing via RevenueCat

## 5. Build System — Known Failure Modes & Fixes

These have already been debugged once; check here before re-diagnosing from
scratch:

- **JVM target mismatches across plugins** (seen with `health`,
  `msal_flutter`, and similar plugins) — align `jvmTarget` /
  `sourceCompatibility` across all Gradle modules, not just `app/build.gradle`.
- **KGP (Kotlin Gradle Plugin) self-application warnings** — check for
  duplicate/implicit plugin application across included builds.
- **NDK/CMake ABI filter issues (x86 ABI)** — verify `abiFilters` are
  consistent between `build.gradle` and any native plugin's own CMake config;
  x86 mismatches are the recurring culprit.
- **Gradle lifecycle constraint errors** — usually from a plugin registering
  tasks outside the expected `afterEvaluate`/configuration lifecycle; check
  plugin apply order first.
- **iOS CI build failures (GitHub Actions):** `device_info_plus` ARC issue —
  requires a build-time patch step in the workflow; don't assume vanilla
  `flutter build ios` will succeed in CI without it.
- **Drift bug:** `isSmallerThanValue` — has a known bug that previously
  affected the Appwrite sync worker; verify comparison operators explicitly
  in any Drift query used for sync filtering rather than assuming Drift's
  generated SQL is correct. Re-check this against the new D1 sync layer too.
- **D1 write limits:** free tier caps at 100K row writes/day. FitKarma's
  workout/nutrition/Health-Connect logging is write-heavy — model expected
  daily writes per active user before assuming the free tier holds at scale,
  and budget for the Workers Paid plan ($5/mo base) once it doesn't.
- **D1 is SQLite, not Postgres/document-store:** schema and query patterns
  should mirror the local Drift/SQLite schema closely — this is a genuine
  advantage of the Cloudflare choice, don't fight it by modeling D1 as if it
  were a document store.

## 6. Dev Environment

- Windows + Android Studio, Flutter toolchain.
- AVD: Pixel 7, API 34, Google Play image.
- Known issue: **Vulkan driver problems on Intel Iris Xe** — if emulator
  rendering is broken/crashing, check Vulkan/ANGLE settings before assuming
  it's an app bug.
- Physical device testing: Pixel 6a over **ADB wireless debugging**
  (`192.168.31.56:41515` — reconfirm current IP if stale).
- Hot reload configured in Android Studio.

## 7. Best Practices for This Codebase

- Route new AI-driven features through the existing multi-model router —
  never call the Groq API directly from feature code, and never call it from
  the Flutter client — Groq calls belong in a Worker, not on-device.
- Treat every data-writing feature as offline-first: write to Drift first,
  let the sync layer reconcile with D1 when connectivity returns.
- SQLCipher-encrypted fields are encrypted at rest already — don't add a
  second application-layer encryption pass without checking existing schema.
- Design D1 schema to mirror the local Drift/SQLite schema — minimize
  translation logic between the two by keeping table shapes aligned.
- Use R2 for any user-generated media (progress photos, pose-estimation
  frames if cached) — never store binary blobs in D1.
- Match Gradle config changes across all modules/plugins, not just `app/` —
  most build breakage here has come from partial config changes.
- Instrument new flows with Sentry the same way existing flows are, so
  dashboards stay consistent.
- Watch D1 write volume as a first-class metric, not an afterthought — it's
  the free-tier constraint most likely to bite FitKarma given how
  write-heavy logging is.

## 8. Common Mistakes to Avoid

- Editing `app/build.gradle` JVM target without checking plugin-level
  `build.gradle` files — reintroduces the JVM mismatch bug.
- Assuming `flutter build ios` works unmodified in CI — it needs the
  `device_info_plus` ARC patch step.
- Trusting Drift's `isSmallerThanValue` comparisons in sync filtering
  without double-checking against raw SQL — this bug predates the Cloudflare
  migration but the underlying Drift usage pattern is unchanged.
- Building new "intelligence" features as standalone modules instead of
  wiring them into the Health OS Brain / Daily Intelligence Package concepts —
  causes architecture drift from the documented v2 spec.
- Assuming R2 Class A operations (writes/deletes/list) are as cheap as
  reads — they're billed separately and add up faster than storage itself.
- Referencing the old Appwrite sync worker or Azure setup in new code —
  both are deprecated; if you find references to either while working in the
  codebase, flag them for cleanup rather than extending them.

## 9. Further Reading (in-repo/local, not public docs)

- FitKarma documentation rewrite — canonical spec for Health OS Brain,
  Daily Intelligence Package, Program Evolution Engine, Life Events Engine,
  Transformation Memory, and the 14-phase development roadmap.
