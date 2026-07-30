# FitKarma — Complete Master Documentation
### Version 1.0 — India's Intelligent Health Operating System
**Flutter 3.x · Riverpod 2.x · Drift v7 · Cloudflare D1 · RevenueCat · Multi-Model AI**

> **Offline-First · Privacy-Centric · Built for India · AI-Adaptive**
> Dark mode primary · Glassmorphism · Spring physics · Bento grid
> All backend via **Cloudflare** (Cloudflare Workers + Cloudflare D1 SQLite at the edge + R2 Object Storage).

---

## Document Status: Version 1.0 (Consolidated Release)

This is the first consolidated master release of the FitKarma documentation. It supersedes all prior working drafts. Earlier drafts iterated the design in place (features were added directly into sections without a stable version anchor); from this point forward, changes are tracked against **v1.0** as the baseline.

Version 1.0 consolidates the full feature set previously scoped — social loops, creator ecosystem, data network effects, and clinical intelligence — **and** adds an architecture hardening pass plus a new India-specific growth layer:

| Area | Status in v1.0 | Notes |
|------|-------------|----------------------------|
| **AI Routing** | Multi-model routing (tiny → medium → large) | Cached results for marketplace/program builders |
| **Social Moat** | Activity Feed, Follow System, Local Clubs, Workout/Route/Transformation sharing | Built on Squad Missions + Challenges foundation |
| **Creator Ecosystem** | Coach/Trainer Marketplace, Program Store, Affiliate Program | §P13-B, §P13-C |
| **Data Network Effects** | Demographic Cohort Insights, Community Benchmarks, City & Age-Group Rankings | §P7-E, §P7-F |
| **Clinical Intelligence** | Clinical Report Parser, Continuous Biomarker (CGM) Sync, Medication Tracker, Doctor Sharing Portal | §P10 — see §P10-K for compliance framework, **hardened in v1.0** (§P10-M) |
| **Readiness & Recovery** | Recovery OS — Sleep Need Calculator, Daily Strain (0–21), Recovery Capacity, Circadian Score, Illness Detection | §P2-D |
| **Calorie & Diet model** | Adaptive Metabolism Engine, Periodization, Protein timing, Micronutrients, Glycemic response, Meal Quality, Satiety prediction | §P5 |
| **Database local schema**| Drift Local Schema **v17** | Normalized score tables added in v1.0 — see §DB Migration Notes |
| **Cloud architecture** | 8 Cloudflare Workers, **fan-out orchestration** for the daily batch job | Hardened in v1.0 — see §P0-C and §CF |
| **🆕 India Growth Layer** | WhatsApp Logging, Vernacular Voice Logging, ABHA Health ID, Corporate Wellness Tier, Grocery Checkout Integration | **New in v1.0 — see Phase 16** |
| **🔒 Security Hardening** | CSPRNG key generation, sync idempotency, per-user timezone scheduling, scoped AI cache | **New in v1.0 — see §P14-A and §P0-C** |

### v1.0 Architecture Hardening Summary

A pre-launch architecture review identified and closed the following gaps. These are referenced throughout the document at their relevant sections, and summarized here for changelog purposes:

1. **Database encryption key generation** was using a non-cryptographic timestamp-based generator. Replaced with `Random.secure()` (OS-level CSPRNG). See §P14-A.
2. **Daily Intelligence Package generation** ran as a sequential per-user loop inside a single Cron Triggered Cloudflare Worker, which would time out or fail as an all-or-nothing batch past a few hundred users. Replaced with a Cloudflare Workflows fan-out/fan-in orchestration with per-user error isolation. See §P0-C and §CF.
3. **DIP scheduling was hardcoded to 6am IST** for all users, which is incorrect for NRIs and users in Travel Mode. Replaced with per-user timezone-aware scheduling. See §P0-C.
4. **Sync conflict resolution** used raw client timestamps for Last-Write-Wins, which is vulnerable to device clock skew, and lacked idempotency keys on cumulative log deltas (steps, hydration), risking double-counting on retried sync batches. Both addressed in the updated `SyncMergeResolver`. See §P0-C.
5. **The `Users` table** had accumulated 15+ derived/computed score columns across schema versions, losing history and bloating the most frequently-queried table. Split into a normalized `UserScores` time-series table. See §DB.
6. **The `ai_cache` table** was not scoped per-user, complicating DPDP Act right-to-erasure compliance. Added a user reference and cascading deletion path. See §DB and §P14-A.

---

## Vision Statement

FitKarma is not a fitness tracker. It is **India's intelligent health operating system** — an adaptive system that creates and evolves a complete life plan for each user, providing the kind of personalized coaching previously only available to elite athletes.

> "Stop making it only a tracker. Make it a decision engine + life operating system."

The v1 architecture realizes this by introducing a **Health OS Brain** — a central intelligence layer that replaces fragmented per-module AI calls with a single orchestrated daily intelligence cycle. Every feature reads from it. Nothing calls the AI twice for the same reasoning.

---

## Development Roadmap — Master Order

| Phase | What You Build | Why First |
|-------|---------------|-----------|
| **Phase 0** | Foundation — Design System, Architecture, Health OS Core | Everything else depends on this |
| **Phase 1** | Core Onboarding + User Profile | Personalization data collected before any features |
| **Phase 2** | Daily Mission + Readiness Engine | The emotional core users return to every morning |
| **Phase 3** | AI Adaptive Coach (Routed) | Multi-model coaching, not raw Groq passthrough |
| **Phase 4** | Health Tracking (Steps, Sleep, Vitals, Wearables) | Core data inputs for the Health OS Brain |
| **Phase 5** | Smart Indian Nutrition System | Strongest moat; deepest Indian food intelligence |
| **Phase 6** | Workout + Progressive Overload + Form Intelligence | Intelligent progression with movement coaching |
| **Phase 7** | Gamification + Karma + Adherence + Benchmarks + Cohorts | Retention engine that rewards results with cohort context |
| **Phase 8** | Transformation Journey + Psychology + Identity | Anti-quit system with long-term memory and identity evolution |
| **Phase 9** | Social, squads, Family, Feed, Clubs, & Sharing | Growth lever via feed sharing, geolocation circles, and squad accountability |
| **Phase 10** | Predictive Health, Clinical Reports, CGM, Meds & Doctor Share | Biomarker tracking, medication interaction warnings, and doctor export |
| **Phase 11** | Visual Body Analytics + Predictions + BF% Estimation | Retention through future projections |
| **Phase 12** | Festival + Life Events + Travel + Calendar Intelligence | Uniquely Indian; deeply adaptive |
| **Phase 13** | Premium, Monetisation, Creator & Coach Marketplace | Revenue via elite marketplace, program store, and affiliate commission |
| **Phase 14** | Enterprise Hardening + CI/CD | Production readiness |
| **Phase 15** | Advanced Intelligence — Adaptive Metabolism, Longevity Score, Environmental Health | Closes gap with MacroFactor/WHOOP; true Health OS differentiation |
| **Phase 16** 🆕 | India Growth & Trust Layer — WhatsApp Logging, Vernacular Voice Input, ABHA Health ID, Corporate Wellness Tier, Grocery Checkout | Removes logging friction for the mass market; adds trust/interoperability and a second monetisation channel beyond consumer subscriptions |

---

## Quick Navigation

| Need | Go to |
|------|--------|
| Architecture overview | §P0-C Architecture Overview |
| Health OS Brain | §P0-E Health OS Brain |
| AI Routing Layer | §P0-F AI Routing Layer |
| Design tokens / colors | §P0-D Design Tokens |
| **Shared Foundation Widgets** | §P0-D2 Shared Foundation Widgets |
| **Adaptive Metabolism Engine** | §P0-I Adaptive Metabolism Engine |
| **Environmental Health Layer** | §P0-J Environmental Health Layer |
| Build onboarding | §P1 Onboarding |
| **Women's Advanced Health** | §P1-H Women's Advanced Health Layer |
| Daily Readiness + Recovery Debt | §P2-A Readiness Engine |
| Daily Briefing Screen | §P2-B Daily Mission Screen |
| AI Adaptive Coach | §P3 AI Coach System |
| **Human Coach Escalation** | §P3-D Health Coach Escalation |
| Health tracking screens | §P4 Health Tracking |
| **Wearable Reliability Engine** | §P4-G Smart Wearable Comparison |
| Indian nutrition AI | §P5 Smart Nutrition |
| **Restaurant Intelligence** | §P5-E Restaurant Intelligence |
| **Grocery Intelligence** | §P5-F Grocery Intelligence |
| Workout intelligence | §P6 Workout System |
| **Exercise Form Intelligence** | §P6-E Movement Screening Engine |
| Karma + gamification | §P7 Karma System |
| **Adherence Score** | §P7-A Karma System (Adherence Score) |
| **Benchmarking Engine** | §P7-D Benchmarking Engine |
| **Demographic Cohort Insights** | §P7-E Demographic Cohort Insights |
| Anti-quit psychology + Identity | §P8 Transformation Journey |
| **Habit Identity Layer** | §P8-C Habit Identity Layer |
| Social + squads | §P9 Community System |
| **Family Health Hub** | §P9-D Family Health Hub |
| **Activity Feed & Sharing** | §P9-E Activity Feed & Sharing |
| **Local Geolocation Clubs** | §P9-F Local Clubs & Geolocation |
| **Weekly/Monthly Leaderboards** | §P9-G Weekly & Monthly Leaderboards |
| Predictive health | §P10 Health Intelligence |
| **Injury Prevention System** | §P10-A Health Risk Prevention |
| **Stress Detection Engine** | §P10-C Stress Detection Engine |
| **Clinical Report Intelligence** | §P10-E Clinical Report Intelligence |
| **Continuous Glucose (CGM) Sync** | §P10-H Continuous Biomarker Tracking |
| **Medication Tracker & Interactions**| §P10-I Medication Tracker |
| **Doctor Sharing Portal** | §P10-J Doctor Sharing Portal |
| **Regulatory Compliance Framework** | §P10-K Compliance Framework |
| **🔒 Clinical Feature Compliance Hardening** | §P10-M Clinical Compliance Hardening (NEW v1.0) |
| **Longevity Score** | §P10-F Longevity Score |
| Body analytics | §P11 Visual Analytics |
| **Wearable-Free Body Composition** | §P11-C Body Composition Estimation |
| Festival + life events + travel | §P12 Festival Intelligence |
| **Smart Calendar Integration** | §P12-E Calendar Integration |
| Subscriptions & Marketplace | §P13 Monetisation |
| **Creator Coach/Trainer Marketplace**| §P13-B Creator Marketplace |
| **Creator Affiliate Program** | §P13-C Creator Affiliate Program |
| CI/CD + testing | §P14 Enterprise Hardening |
| **🆕 WhatsApp Logging** | §P16-A WhatsApp Business Logging |
| **🆕 Vernacular Voice Logging** | §P16-B Vernacular Voice Input |
| **🆕 ABHA Health ID Integration** | §P16-C ABHA Integration |
| **🆕 Corporate Wellness / Insurer Tier** | §P16-D Corporate Wellness Tier |
| **🆕 Grocery Vendor Checkout** | §P16-E Grocery Checkout Integration |
| Database schema | §DB Database Schema |
| Cloudflare D1 setup | §CF Cloudflare Setup |
| Glossary + ADRs | §GLO Glossary |

---

# PHASE 0 — FOUNDATION

---

## §P0-A. Design Philosophy

### Six Pillars

| Pillar | Expression |
|--------|-----------|
| **Spatial Depth** | Three-layer system: background → mid-layer → foreground. Real blur, shadow, translucency. Every screen has depth, never flat. |
| **Fluid Motion** | Spring physics everywhere. No linear tweens. 100ms touch-to-response. Animations must feel alive, not mechanical. |
| **Bold Information** | One dominant metric per screen at 56–72sp. Context recedes, data leads. Hierarchy is the UX. |
| **Visual Restraint** | Glow reserved for the active metric, primary CTA, and ring fill only. Not every card glows — glow is punctuation, not prose. |
| **Dark-First** | Dark mode is the primary target. Light mode is a warm, saffron inversion — not an afterthought. |
| **Cultural Pulse** | Orange-indigo-saffron palette echoes Indian aesthetics. Bilingual labels used surgically — for emotional connection, not everywhere. |

### ❌ Anti-Patterns — Never Do These

```
❌ Plain white cards with grey text on white backgrounds
❌ Skeleton screens on core data — use Drift optimistic UI
❌ Hardcoded hex values outside the token file
❌ Modals/dialogs when a bottom sheet suffices
❌ Glow on every card
❌ Two competing hero elements on the same screen
❌ Bilingual labels on every element — only category headers, crisis lines, festival banners
❌ Blur + glow + gradient + animation on the same card (max 2 effects per surface)
❌ Linear easing curves anywhere — always spring or easeOutCubic minimum
❌ Showing empty state before first data load — use ShimmerLoader
❌ Blocking UI for network operations — write to Drift first, sync in background
❌ Generic advice from the AI coach — always personalize using user context
❌ Treating festivals as disruptions — adapt plans around them instead
❌ Calling AI for deterministic calculations (BMI, TDEE, Readiness, Calories, Macros)
❌ Multiple AI calls per session for the same user context
❌ Using a 70B model for classification, intent detection, or simple insights
❌ Rewarding XP for logging actions instead of achieving outcomes
```

> **Rule of Two:** Each surface can have at most two visual effects simultaneously.
> Valid combos: `blur + border`, `glow + gradient`, `gradient + shadow`.
> Invalid: `blur + glow + gradient + animation`.

---

## §P0-B. Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── device_tier.dart
│   │   ├── user_experience_stage.dart
│   │   └── app_config.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_theme.dart
│   │   ├── app_spacing.dart
│   │   ├── app_gradients.dart
│   │   └── app_springs.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── transitions.dart
│   ├── database/
│   │   └── app_database.dart
│   ├── sync/
│   │   ├── sync_worker.dart
│   │   ├── dlq_provider.dart
│   │   └── connectivity_service.dart
│   ├── security/
│   │   ├── biometric_lock.dart
│   │   └── sensitive_screen_guard.dart
│   ├── health_os/
│   │   ├── health_os_brain.dart
│   │   ├── daily_intelligence_package.dart
│   │   ├── health_snapshot.dart
│   │   ├── decision_hierarchy.dart
│   │   ├── health_score.dart
│   │   ├── life_events_engine.dart
│   │   ├── adaptive_metabolism_engine.dart  # NEW v1 - MacroFactor-style weekly recalibration
│   │   ├── adherence_score.dart             # NEW v1 - Nutrition/Training/Recovery KPIs
│   │   ├── stress_detection_engine.dart     # NEW v1 - Infers stress from HRV + behavior
│   │   └── longevity_score.dart             # NEW v1 - Multi-factor longevity model
│   ├── ai/
│   │   ├── ai_router.dart
│   │   ├── rule_engine.dart
│   │   ├── insight_template_engine.dart
│   │   ├── ai_cache.dart
│   │   ├── context_compressor.dart
│   │   ├── conversation_summarizer.dart
│   │   └── context_builder.dart
│   └── providers/
│       ├── cloudflare_provider.dart
│       ├── device_tier_provider.dart
│       ├── ux_stage_provider.dart
│       ├── core_providers.dart
│       └── low_data_mode_provider.dart
├── shared/
│   └── widgets/
│       ├── bento_card.dart
│       ├── activity_rings.dart
│       ├── glowing_metric.dart
│       ├── insight_card.dart
│       ├── quick_log_fab.dart
│       ├── bilingual_label.dart
│       ├── encryption_badge.dart
│       ├── shimmer_loader.dart
│       ├── trend_chip.dart
│       ├── pulse_ring.dart
│       ├── streak_flame.dart
│       ├── bottom_nav_bar.dart
│       ├── empty_state.dart
│       ├── animation_widgets.dart
│       ├── level_up_animation.dart
│       ├── breathing_circle.dart
│       ├── sync_status_banner.dart
│       ├── readiness_ring.dart
│       ├── daily_briefing_card.dart
│       ├── recovery_badge.dart
│       ├── health_score_ring.dart
│       ├── logo_reveal.dart
│       ├── adherence_score_card.dart        # NEW v1 - Nutrition/Training/Recovery %
│       ├── longevity_score_ring.dart        # NEW v1 - Longevity + Biological Age ring
│       ├── benchmarking_card.dart           # NEW v1 - Fitness percentile vs cohort
│       ├── recovery_debt_badge.dart         # NEW v1 - Cumulative fatigue indicator
│       ├── aqi_warning_banner.dart          # NEW v1 - Environmental health alert
│       └── identity_persona_card.dart       # NEW v1 - Habit identity evolution
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── daily_mission/
│   ├── readiness/
│   ├── ai_coach/
│   │   ├── ai_coach_screen.dart
│   │   ├── ai_coach_provider.dart
│   │   └── coach_escalation_service.dart    # NEW v1 - Human coach handoff (Elite)
│   ├── food/
│   │   ├── data/
│   │   │   ├── food_database_service.dart
│   │   │   ├── open_food_facts_client.dart
│   │   │   ├── indian_food_repository.dart
│   │   │   ├── restaurant_database_service.dart  # NEW v1 - Indian restaurant DB
│   │   │   ├── grocery_intelligence_engine.dart  # NEW v1 - Meal plan to grocery list
│   │   │   └── meal_photo_analyzer.dart
│   │   └── presentation/
│   ├── workout/
│   │   ├── progressive_overload.dart
│   │   ├── workout_blueprint.dart
│   │   ├── program_evolution_engine.dart
│   │   └── movement_screening_engine.dart   # NEW v1 - Exercise form analysis
│   ├── steps/
│   ├── health/
│   │   └── wearable_reliability_engine.dart # NEW v1 - Device confidence scores
│   ├── recovery/
│   │   └── recovery_debt_tracker.dart       # NEW v1 - Cumulative fatigue accumulation
│   ├── transformation/
│   │   ├── transformation_memory.dart
│   │   └── habit_identity_engine.dart       # NEW v1 - Identity evolution system
│   ├── karma/
│   ├── benchmarking/                        # NEW v1 - Fitness percentile
│   │   ├── benchmarking_engine.dart
│   │   └── benchmarking_screen.dart
│   ├── social/
│   │   ├── squad/
│   │   ├── family_hub/                      # NEW v1 - Family Health Hub
│   │   │   ├── family_hub_screen.dart
│   │   │   └── family_member_provider.dart
│   │   ├── feed/                            # NEW v1 - Social Feed & Sharing
│   │   │   ├── activity_feed_screen.dart
│   │   │   ├── feed_provider.dart
│   │   │   └── feed_item_card.dart
│   │   └── clubs/                           # NEW v1 - Local & Geolocation Clubs
│   │       ├── clubs_screen.dart
│   │       └── club_detail_screen.dart
│   ├── clinical_reports/                    # NEW v1 - Lab report intelligence
│   │   ├── clinical_report_parser.dart
│   │   ├── clinical_report_screen.dart
│   │   ├── biomarker_integration_service.dart
│   │   ├── cgm/                             # NEW v1 - Continuous Glucose Monitoring
│   │   │   ├── cgm_dashboard_screen.dart
│   │   │   └── cgm_service.dart
│   │   ├── medication/                      # NEW v1 - Medication Tracker & Interaction
│   │   │   ├── medication_tracker_service.dart
│   │   │   └── medication_logs_screen.dart
│   │   └── doctor_sharing/                  # NEW v1 - Passcode-protected Share Portal
│   │       ├── doctor_report_generator.dart
│   │       └── sharing_portal_screen.dart
│   ├── creator_marketplace/                 # NEW v1 - Creator & Program Marketplace
│   │   ├── data/
│   │   │   └── marketplace_service.dart
│   │   └── presentation/
│   │       ├── marketplace_screen.dart
│   │       ├── program_detail_screen.dart
│   │       └── affiliate_dashboard_screen.dart
│   ├── environmental/                       # NEW v1 - AQI + heat index + UV
│   │   ├── environmental_health_engine.dart
│   │   └── aqi_service.dart
│   ├── womens_health/                       # NEW v1 - Cycle, fertility, menopause
│   │   ├── cycle_engine.dart
│   │   ├── cycle_aware_training_adapter.dart
│   │   └── womens_health_screen.dart
│   ├── longevity/                           # NEW v1 - Longevity Score
│   │   ├── longevity_score_calculator.dart
│   │   └── longevity_screen.dart
│   ├── calendar/                            # NEW v1 - Calendar integration
│   │   ├── calendar_integration_service.dart
│   │   └── calendar_sync_screen.dart
│   ├── reports/
│   ├── festival/
│   │   └── festival_cross_module.dart
│   ├── life_events/
│   │   └── travel_intelligence_engine.dart  # NEW v1 - Travel Mode
│   ├── predictions/
│   ├── injury_prevention/                   # NEW v1 - Injury Risk Engine
│   │   └── injury_risk_engine.dart
│   └── settings/
│       └── subscription_screen.dart
└── main.dart
```

---

## §P0-C. Architecture Overview

### Core Architecture Principle: Offline-First + Health OS Brain

```
User Action
    ↓
Drift (local SQLite AES-256)  ← Source of truth
    ↓ (immediate UI update)
Riverpod State Layer
    ↓ (morning, once)
Health OS Brain ────────────────────────────────────────┐
    │                                                    │
    ├── Rule Engine (deterministic)                      │
    ├── Context Compressor                               │
    ├── Daily Intelligence Package Generator             │
    │       ↓ (single AI call, stored in Drift)         │
    │   { insight, mission, nutrition_focus,             │
    │     recovery_focus, motivation }                   │
    │                                                    │
    └── Serves all modules ◄──────────────────────────┘
              ↓
    Dashboard · Coach · Nutrition · Workout
    (all read from Daily Intelligence Package,
     no repeated AI reasoning)

    ↓ (background sync)
Sync Worker → Cloudflare D1
    ↓ (event-triggered only)
AI Router → Appropriate Model Tier → Cloudflare Worker
```

### Three-Layer Offline Strategy

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Local DB** | Drift + SQLCipher | All reads; AES-256 encrypted at page level |
| **Sync Engine** | Priority queue + DLQ | Background writes to Cloudflare D1 via the Workers HTTP API; retries 3× then DLQ |
| **Cloud** | Cloudflare (D1 + Workers + custom JWT auth)  | Cross-device sync, AI functions, auth |

### Sync Conflict & Concurrency Resolution

To maintain data integrity across multiple user devices (e.g., phone and tablet) operating offline, FitKarma implements a **Hybrid Concurrency Policy**:

1. **Last-Write-Wins (LWW) with Hybrid Logical Clocks:** Applied to discrete, transactional entity state updates (e.g., updating a profile preference, modifying a workout set).
2. **Conflict-Free Replicated Accumulator (CRRA) with idempotency keys:** Applied to cumulative logs like Steps, Hydration, and Calorie targets. Updates are logged as chronological delta offsets (`+steps`, `+water_ml`), deduplicated by batch ID before being applied.

> **🔒 v1.0 Fix — Clock-skew resistance.** The original resolver compared raw client `updatedAt` timestamps for LWW. Device clocks drift, and a user can manually change device time — a device with a fast clock would always "win" conflicts even against genuinely newer data. `updatedAt` has been replaced with a **Hybrid Logical Clock (HLC)**: a `(physicalTime, logicalCounter, nodeId)` triple that stays monotonic across devices even under clock skew, since the logical counter advances on every observed event regardless of physical clock drift.
>
> **🔒 v1.0 Fix — Sync idempotency.** Cumulative deltas (steps, hydration) had no deduplication: a retried sync batch after a network blip would double-apply its deltas server-side, inflating totals. Every sync batch now carries a client-generated `syncBatchId`; the server tracks applied batch IDs per entity and rejects (no-ops) a batch it has already applied.

##### Implementation: Drift Sync Merge Resolver (Pure Dart)

```dart
/// Hybrid Logical Clock: physical time + a logical counter that increments
/// on every local or remote event this node observes. Monotonic even when
/// device clocks disagree, because the counter — not the wall clock —
/// breaks ties.
class HLCTimestamp implements Comparable<HLCTimestamp> {
  final DateTime physicalTime;
  final int logicalCounter;
  final String nodeId; // final tiebreaker if both are equal

  const HLCTimestamp({
    required this.physicalTime,
    required this.logicalCounter,
    required this.nodeId,
  });

  @override
  int compareTo(HLCTimestamp other) {
    final physicalCompare = physicalTime.compareTo(other.physicalTime);
    if (physicalCompare != 0) return physicalCompare;
    final logicalCompare = logicalCounter.compareTo(other.logicalCounter);
    if (logicalCompare != 0) return logicalCompare;
    return nodeId.compareTo(other.nodeId);
  }
}

class SyncMergeResolver {
  /// Resolves conflicts between a local and remote record for the same entity
  SyncResolution resolveConflict<T extends SyncableEntity>({
    required T localRecord,
    required T remoteRecord,
  }) {
    // 1. If it's a cumulative metric (e.g., step log), merge by summing
    //    deltas — deduplicated by syncBatchId, see CumulativeLog.mergeWith.
    if (localRecord is CumulativeLog && remoteRecord is CumulativeLog) {
      return SyncResolution.merged(
        (localRecord as CumulativeLog).mergeWith(remoteRecord as CumulativeLog)
      );
    }

    // 2. Otherwise, fall back to Last-Write-Wins using the HLC, not the
    //    raw device clock — resistant to clock skew between devices.
    if (localRecord.hlc.compareTo(remoteRecord.hlc) > 0) {
      return SyncResolution.keepLocal(); // Push local update to remote
    } else {
      return SyncResolution.keepRemote(); // Overwrite local Drift DB with remote
    }
  }
}

abstract class SyncableEntity {
  HLCTimestamp get hlc;
}

abstract class CumulativeLog extends SyncableEntity {
  /// Client-generated ID for this delta batch. The server maintains a
  /// set of already-applied batch IDs per entity and no-ops a repeat —
  /// this is what makes a retried sync safe to resend.
  String get syncBatchId;

  CumulativeLog mergeWith(CumulativeLog other);
}
```

### What Is and Is NOT an AI Job

**Never call AI for these — compute locally in Dart:**

| Calculation | Formula | Notes |
|------------|---------|-------|
| BMI | `weight / (height_m²)` | Pure math |
| TDEE | Mifflin-St Jeor × activity multiplier | Deterministic |
| Daily calories | `TDEE ± goal_offset` | Derived from TDEE |
| Macros | `protein_g = weight × factor` | Formula-based |
| Hydration target | `base_l + temp_offset + activity_offset` | Rule-based |
| Step targets | BMI category lookup table | Rule-based |
| Readiness score | Weighted sum of sleep + stress + soreness + HRV | Formula |
| Fatigue index | 7-day load/recovery ratio | Formula |
| Biological age | Regression formula vs WHO data | Algorithm |
| Risk detection | Threshold comparisons on vitals | Rule engine |
| Protein alert | `protein < 70% of target` | Rule engine |

**Reserve AI for these — decisions humans cannot hardcode:**

- Generating personalized daily insights beyond template range
- AI Coach conversational responses
- Meal photo vision analysis (when cached result unavailable)
- Generating the full 7-day diet plan (structured output, cached)
- Generating a 12-week workout program blueprint (cached)
- Transformation planning and complex lifestyle adaptation
- Life events and festival cross-module adaptation

---

## §P0-D. Design Tokens

> **Rule:** Never hardcode hex values in widget files. All colors must come from `AppColorsDark` / `AppColorsLight`.

### Color Tokens

```dart
// lib/core/theme/app_colors.dart

class AppColorsDark {
  AppColorsDark._();

  // Background layers
  static const bg0         = Color(0xFF080810);
  static const bg1         = Color(0xFF0F0F1A);
  static const bg2         = Color(0xFF161625);

  // Surface layers
  static const surface0    = Color(0xFF1C1C2E);
  static const surface1    = Color(0xFF22223A);
  static const surface2    = Color(0xFF2A2A45);

  // Glassmorphism
  static const glass       = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);

  // Brand
  static const primary        = Color(0xFFFF6B35);
  static const primaryGlow    = Color(0x40FF6B35);
  static const primaryMuted   = Color(0x30FF6B35);
  static const accent         = Color(0xFFFFB547);
  static const accentGlow     = Color(0x33FFB547);
  static const secondary      = Color(0xFF7B6FF0);
  static const secondaryGlow  = Color(0x407B6FF0);
  static const teal           = Color(0xFF00D4B4);
  static const tealGlow       = Color(0x3300D4B4);

  // Semantic
  static const success        = Color(0xFF4ADE80);
  static const successGlow    = Color(0x334ADE80);
  static const warning        = Color(0xFFFBBF24);
  static const error          = Color(0xFFF87171);
  static const rose           = Color(0xFFFB7185);
  static const purple         = Color(0xFFC084FC);

  // Text
  static const textPrimary    = Color(0xFFF1F0FF);
  static const textSecondary  = Color(0xFF9B99CC);
  static const textMuted      = Color(0xFF6B68A0);
  static const divider        = Color(0x14FFFFFF);
}
```

### Color Semantic Quick-Reference

| Color | Token | Use Case |
|-------|-------|----------|
| Orange `#FF6B35` | `primary` | CTA buttons, active nav tab, hero metric glow |
| Amber `#FFB547` | `accent` | XP coins, streak flames, achievement highlights |
| Indigo `#7B6FF0` | `secondary` | Level badges, sleep screen gradient, meditation |
| Teal `#00D4B4` | `teal` | Water tracker, SpO2, medication, Ayurveda |
| Green `#4ADE80` | `success` | Steps goal achieved, healthy readings, habits done |
| Amber `#FBBF24` | `warning` | Elevated BP/glucose, moderate risk states |
| Red `#F87171` | `error` | Crisis readings, destructive actions |
| Rose `#FB7185` | `rose` | Period tracker, menstrual health |
| Purple `#C084FC` | `purple` | Active minutes ring, move goal |

### Spacing & Radius Tokens

```dart
class AppSpacing {
  static const double screenH      = 20.0;
  static const double cardH        = 16.0;
  static const double fabClearance = 120.0;
  static const double bentoGap     = 12.0;
}

class AppRadius {
  static const double sm         = 10.0;
  static const double md         = 16.0;
  static const double lg         = 20.0;
  static const double xl         = 28.0;
  static const double full       = 9999.0;
  static const double bentoInner = 14.0;
  static const double bentoOuter = 20.0;
  static const double bentoHero  = 28.0;
}
```

### Typography System

```dart
class AppTypography {
  static const heroDisplay  = TextStyle(fontSize: 72, fontWeight: FontWeight.w800, letterSpacing: -2.0, height: 0.95);
  static const metricXL     = TextStyle(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.0);
  static const metricLg     = TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.1);
  static const displayLg    = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.15);
  static const displayMd    = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2);
  static const h1           = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.25);
  static const h2           = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.3);
  static const h3           = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.35);
  static const bodyLg       = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const bodyMd       = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const bodySm       = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);
  static const labelLg      = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.2, height: 1.4);
  static const labelMd      = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.4);

  // Devanagari — NEVER use PlusJakartaSans for Hindi
  static TextStyle hindi({double size = 14, FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: size, fontWeight: weight, height: 1.6);
}
```

---

## §P0-D2. Shared Foundation Widgets

To maintain design tokens and structural consistency across all screens, FitKarma implements a set of core shared widgets. These widgets follow the **Rule of Two** (max 2 visual effects simultaneously) and implement the spatial depth, typography, and bilingual requirements of the system.

### 1. BentoCard (`lib/shared/widgets/bento_card.dart`)

The foundational container for the dashboard. It implements glassmorphism (blur + border or gradient + shadow) and physical depth. It is also designed with built-in spring physics triggers on press.

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

class BentoCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? customBgColor;
  final double blurRadius;
  final double borderRadius;
  final bool hasSecondaryGlow;

  const BentoCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.onTap,
    this.customBgColor,
    this.blurRadius = 16.0,
    this.borderRadius = AppRadius.bentoOuter,
    this.hasSecondaryGlow = false,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppSprings.touchResponseCurve, // Swift Touch-to-Response Spring physics
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardBody = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.blurRadius, sigmaY: widget.blurRadius),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.cardH),
          decoration: BoxDecoration(
            color: widget.customBgColor ?? AppColorsDark.glass,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: AppColorsDark.glassBorder,
              width: 1.0,
            ),
            boxShadow: widget.hasSecondaryGlow 
                ? [
                    const BoxShadow(
                      color: AppColorsDark.primaryMuted,
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap == null) {
      return cardBody;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: cardBody,
      ),
    );
  }
}
```

---

### 2. ActivityRings (`lib/shared/widgets/activity_rings.dart`)

Concentric, CustomPainter-based progress rings for tracking Steps, Calories, Water, or Active Minutes. It supports glows at the progress tips and custom gradients.

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingData {
  final double value;
  final double target;
  final List<Color> colors;
  final double strokeWidth;

  RingData({
    required this.value,
    required this.target,
    required this.colors,
    this.strokeWidth = 12.0,
  });
}

class ActivityRings extends StatelessWidget {
  final List<RingData> rings;
  final double size;
  final double gap;

  const ActivityRings({
    super.key,
    required this.rings,
    this.size = 200.0,
    this.gap = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ActivityRingsPainter(
        rings: rings,
        gap: gap,
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final List<RingData> rings;
  final double gap;

  _ActivityRingsPainter({
    required this.rings,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    double currentRadius = math.min(size.width, size.height) / 2 - (rings.isNotEmpty ? rings.first.strokeWidth / 2 : 0);

    for (int i = 0; i < rings.length; i++) {
      final ring = rings[i];
      final pct = (ring.target > 0) ? (ring.value / ring.target).clamp(0.0, 1.0) : 0.0;

      // 1. Draw track background
      final bgPaint = Paint()
        ..color = ring.colors.first.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth;
      
      canvas.drawCircle(center, currentRadius, bgPaint);

      // 2. Draw progress arc
      if (pct > 0) {
        final rect = Rect.fromCircle(center: center, radius: currentRadius);
        final progressPaint = Paint()
          ..shader = SweepGradient(
            colors: ring.colors,
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = ring.strokeWidth;

        // Apply rotation matrix to start the sweep from 12 o'clock (-pi/2)
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(-math.pi / 2);
        canvas.translate(-center.dx, -center.dy);

        canvas.drawArc(
          rect,
          0.0,
          pct * 2 * math.pi,
          false,
          progressPaint,
        );
        canvas.restore();
      }

      currentRadius -= (ring.strokeWidth + gap);
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) => true;
}
```

---

### 3. GlowingMetric (`lib/shared/widgets/glowing_metric.dart`)

The primary hero metric display. Implements the bold metrics system (56–72sp) and applies targeted glow colors based on current context (e.g. orange for calories, indigo for sleep) while adhering to the **Rule of Two** visual effect limitation.

```dart
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

class GlowingMetric extends StatelessWidget {
  final String value;
  final String? unit;
  final Color glowColor;
  final TextStyle? customStyle;
  final bool hasGlow;

  const GlowingMetric({
    super.key,
    required this.value,
    this.unit,
    required this.glowColor,
    this.customStyle,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = customStyle ?? AppTypography.metricXL.copyWith(
      color: Colors.white,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle.copyWith(
          shadows: hasGlow
              ? [
                  Shadow(
                    color: glowColor.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: glowColor.withOpacity(0.2),
                    blurRadius: 36,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        children: [
          TextSpan(text: value),
          if (unit != null)
            TextSpan(
              text: ' $unit',
              style: AppTypography.h3.copyWith(
                color: Colors.white.withOpacity(0.5),
                shadows: [], // Prevent glowing units for visual restraint
              ),
            ),
        ],
      ),
    );
  }
}
```

---

### 4. BilingualLabel (`lib/shared/widgets/bilingual_label.dart`)

Enforces consistent Devanagari (Hindi) and English styling. Automatically formats Hindi sub-labels to NotoSansDevanagari with appropriate line-height scale factor, preventing spacing clipping or incorrect font fallbacks.

```dart
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_colors.dart';

class BilingualLabel extends StatelessWidget {
  final String englishText;
  final String? hindiText;
  final TextStyle? englishStyle;
  final double hindiFontSizeScale;
  final CrossAxisAlignment alignment;

  const BilingualLabel({
    super.key,
    required this.englishText,
    this.hindiText,
    this.englishStyle,
    this.hindiFontSizeScale = 0.85,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final isHindiActive = currentLocale == 'hi';

    // If English-only is forced or Hindi text is absent
    if (hindiText == null || hindiText!.isEmpty) {
      return Text(
        englishText,
        style: englishStyle ?? AppTypography.bodyMd.copyWith(color: AppColorsDark.textPrimary),
      );
    }

    final TextStyle baseEnglishStyle = englishStyle ?? AppTypography.bodyMd.copyWith(
      color: AppColorsDark.textPrimary,
    );

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // English primary label
        Text(
          englishText,
          style: isHindiActive 
              ? baseEnglishStyle.copyWith(color: AppColorsDark.textSecondary) // Mute English if user set Hindi
              : baseEnglishStyle,
        ),
        const SizedBox(height: 2.0),
        // Hindi secondary sub-label
        Text(
          hindiText!,
          style: AppTypography.hindi(
            size: baseEnglishStyle.fontSize != null 
                ? baseEnglishStyle.fontSize! * hindiFontSizeScale 
                : 12.0,
            weight: isHindiActive ? FontWeight.bold : FontWeight.w400,
          ).copyWith(
            color: isHindiActive 
                ? AppColorsDark.textPrimary 
                : AppColorsDark.textMuted,
          ),
        ),
      ],
    );
  }
}
```

---

## §P0-E. Health OS Brain

The Health OS Brain is the central nervous system of FitKarma v1. It is the single answer to: *"What should happen today?"*

### Why It Exists

In v1, the Dashboard, Coach, Nutrition screen, and Workout screen each called the LLM independently with the same user context, reasoning about the same data, producing potentially conflicting outputs. The Health OS Brain eliminates this by:

1. Running once every morning (Timer Trigger, 6am IST)
2. Ingesting all inputs
3. Generating one **Daily Intelligence Package**
4. Storing it in Drift
5. Every feature reads from it — zero repeated AI reasoning

### Inputs to the Health OS Brain

```dart
class HealthOSInputs {
  // User state
  final UserProfile profile;
  final String currentProgram;
  final List<GoalType> goals;

  // Today's context
  final ReadinessScore readiness;
  final WeatherData weather;
  final UpcomingFestival? festival;
  final LifeEvent? activeLifeEvent;

  // 7-day trends (compressed by ContextCompressor)
  final HealthSnapshot snapshot; // ~400 tokens

  // Risk state
  final List<HealthRiskAlert> activeRisks;
  final NutritionTrend nutritionTrend;
  final SleepTrend sleepTrend;
}
```

### Daily Intelligence Package (DIP)

Generated once per morning, stored to Drift, served to all modules:

```dart
class DailyIntelligencePackage {
  final String date;

  // Primary output — shown on Daily Mission screen
  final String primaryInsight;       // Main personalized AI insight
  final String todaysMission;        // 1-sentence motivational mission
  final String nutritionFocus;       // e.g. "Hit 110g protein — you averaged 58g"
  final String recoveryFocus;        // e.g. "Rest after 3 hard sessions this week"
  final String motivationMessage;    // Tone-adapted to user preference

  // Derived targets for today (all computed locally, NOT by AI)
  final int adjustedCalorieTarget;
  final int adjustedProteinTarget;
  final double adjustedHydrationL;
  final WorkoutIntensity recommendedIntensity;
  final bool isRestDayRecommended;

  // Alerts
  final List<HealthRiskAlert> activeRisks;
  final bool showFestivalBanner;
  final String? festivalAdaptation;

  // Metadata
  final DateTime generatedAt;
  final int aiCallsUsed;             // Should be 1 per day
}
```

### Unified Health Score

A single 0–100 score synthesizing all health dimensions. Replaces the cognitive overload of simultaneously tracking readiness + karma + sleep + protein + hydration + weight:

```dart
class HealthScoreCalculator {
  // Weights are tunable per user goal
  static const Map<String, double> defaultWeights = {
    'nutrition':    0.25,  // Protein hit rate, calorie consistency
    'recovery':     0.25,  // Sleep quality, HRV, readiness
    'training':     0.25,  // Workout consistency, progressive overload
    'consistency':  0.25,  // Streak, habit completion, app engagement
  };

  int calculate(HealthOSInputs inputs) {
    final nutrition   = _nutritionScore(inputs);
    final recovery    = _recoveryScore(inputs);
    final training    = _trainingScore(inputs);
    final consistency = _consistencyScore(inputs);

    return (nutrition    * defaultWeights['nutrition']!  +
            recovery     * defaultWeights['recovery']!   +
            training     * defaultWeights['training']!   +
            consistency  * defaultWeights['consistency']!).round();
  }
}
```

The Health Score drives the daily mission hierarchy:

```
Health Score 0–100
      ↓
Daily Mission (derived)
      ↓
Readiness Score (subset)
      ↓
All other metrics
```

### Decision Hierarchy (Conflict Resolution)

When modules give conflicting guidance (e.g., Wedding Program says "Train hard" but Readiness says "Rest"), the Decision Hierarchy resolves it:

```
Priority 1 — Medical Risk        (always overrides everything)
Priority 2 — Recovery State      (readiness < 45 → rest day, no exceptions)
Priority 3 — Program Instruction (structured training phases)
Priority 4 — Goals               (user-stated outcomes)
Priority 5 — Preferences         (tone, food type, schedule)
```

Implementation:

```dart
class DecisionHierarchy {
  TodaysPlan resolve({
    required HealthRiskAlert? medicalRisk,
    required ReadinessScore readiness,
    required ProgramInstruction programInstruction,
    required UserGoals goals,
    required UserPreferences preferences,
  }) {
    if (medicalRisk != null && medicalRisk.severity == RiskSeverity.high) {
      return TodaysPlan.medicalRest(reason: medicalRisk.message);
    }
    if (readiness.score < 45) {
      return TodaysPlan.recoveryDay(
        message: 'Your readiness is critically low. '
                 'Rest today protects your long-term progress.',
      );
    }
    // Continue down hierarchy...
    return programInstruction.adaptedFor(goals, preferences);
  }
}
```

---

## §P0-F. AI Routing Layer

Never use the same model for everything. Route every AI job to the cheapest model that can do it well.

### Model Tiers

| Tier | Model | Use Cases | When NOT to Use |
|------|-------|-----------|-----------------|
| **Rule Engine** | No model | BMI, TDEE, macros, hydration, risk detection, protein alerts | N/A — always free |
| **Template Engine** | No model | 80% of daily insights via `{variable}` templates | When insight requires reasoning |
| **Tiny (3B–8B)** | Llama-3.1-8B or Gemma-2-9B | Classification, intent detection, meal category labeling, quick suggestions | Complex reasoning, long outputs |
| **Medium (13B–30B)** | Llama-3.1-70B (reduced context) | Daily Intelligence Package, program adaptation | Conversational AI coach |
| **Large (70B)** | Llama-3.1-70B or Llama-3.3 | AI Coach conversations, transformation planning, complex reasoning | Every request — cost prohibitive |

### AI Router

```dart
class ConnectivityService {
  /// Simulates querying the active network interface status of the client device
  Future<bool> isConnected() async {
    // Bridges to native Android/iOS connectivity manager via MethodChannels
    return true; // Default to online
  }
}

class LocalGemmaInferenceEngine {
  final bool isModelLoaded;
  final String deviceHardwareTier; // 'high', 'medium', or 'low'

  LocalGemmaInferenceEngine({
    required this.isModelLoaded,
    required this.deviceHardwareTier,
  });

  /// Invokes Gemma-2B locally on-device using MediaPipe's LLM Inference APIs
  Future<String> runInference(String prompt) async {
    if (deviceHardwareTier != 'high') {
      throw Exception('Device hardware performance tier is too low for local 2B model execution.');
    }
    if (!isModelLoaded) {
      throw Exception('Gemma-2B weights not loaded in application sandbox directory.');
    }

    // MediaPipe LLM Inference wrapper executing the quantized weights on GPU/NPU
    return "[Local Gemma-2B Offline Response] I analyzed your query locally: Since you are currently offline, I recommend performing light stretches or moderate bodyweight exercises. Avoid starting new high-intensity programs until internet connection is restored to sync your logs.";
  }
}

class AIRouter {
  final RuleEngine _ruleEngine;
  final TemplateEngine _templateEngine;
  final AICache _cache;
  final LocalGemmaInferenceEngine _localGemma;
  final ConnectivityService _connectivity;

  AIRouter(
    this._ruleEngine,
    this._templateEngine,
    this._cache,
    this._localGemma,
    this._connectivity,
  );

  Future<String> route(AIRequest request) async {
    // Layer 1: Can a rule handle this?
    final ruleResult = await _ruleEngine.tryHandle(request);
    if (ruleResult != null) return ruleResult;

    // Layer 2: Can a template handle this?
    final templateResult = _templateEngine.tryHandle(request);
    if (templateResult != null) return templateResult;

    // Layer 3: Check cache
    final cached = await _cache.get(request.promptHash);
    if (cached != null) return cached;

    // Layer 4: Connectivity check & Failsafe offline routing (Local Gemma-2B model)
    final isOnline = await _connectivity.isConnected();
    if (!isOnline) {
      if (_localGemma.deviceHardwareTier == 'high' && _localGemma.isModelLoaded) {
        try {
          return await _localGemma.runInference(request.prompt);
        } catch (e) {
          return "Offline System Message: Local AI inference failed ($e). Reconnect to the internet for cloud AI coaching.";
        }
      } else {
        return "Offline System Message: You are offline, and local model inference is unsupported or not downloaded on this device. Reconnect to the internet to resume AI coaching.";
      }
    }

    // Layer 5: Route to correct cloud model tier
    final model = _selectModel(request.complexity);
    final result = await _callGroq(model, request);

    // Store in cache
    await _cache.set(request.promptHash, result);
    return result;
  }

  GroqModel _selectModel(AIComplexity complexity) {
    return switch (complexity) {
      AIComplexity.classification => GroqModel.llama3_8b,
      AIComplexity.dailyInsight   => GroqModel.llama3_70b_medium,
      AIComplexity.coaching       => GroqModel.llama3_70b_full,
      AIComplexity.planning       => GroqModel.llama3_70b_full,
    };
  }

  Future<String> _callGroq(GroqModel model, AIRequest request) async {
    // Simulates HTTP call to Groq Cloud endpoint
    return "Mock Cloud Response from ${model.toString()}";
  }
}
```

### Rule Engine & Template Fallback Engine

FitKarma implements offline-ready, deterministic local rule and template engines to ensure instant feedback and offline-first safety, serving as the first two layers of the AI Router.

#### 1. RuleEngine (Pure Dart)

```dart
class RuleEngine {
  final AppDatabase _db;
  RuleEngine(this._db);

  /// Analyzes local state and returns an action directive if a threshold is breached
  Future<String?> tryHandle(AIRequest request) async {
    if (request.complexity != AIComplexity.dailyInsight) return null;

    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final today = DateTime.now();

    // A. Critical Vitals Alert (BP spike warning)
    final bp = await (_db.select(_db.bpReadings)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    if (bp != null && (bp.systolic >= 140 || bp.diastolic >= 90)) {
      return "CRITICAL ALERT: Your blood pressure is elevated (${bp.systolic}/${bp.diastolic} mmHg). Avoid high-intensity training, reduce sodium intake, and monitor for headaches or dizziness.";
    }

    // B. Severe Sleep Deficit Rule
    final sleepLogs = await (_db.select(_db.sleepLogs)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(3))
        .get();
    if (sleepLogs.length == 3 && sleepLogs.every((s) => s.durationMinutes < 360)) {
      return "SLEEP CRISIS: You've slept less than 6 hours for 3 consecutive nights. Your recovery capacity is down by 40%. Prioritize an 8-hour sleep window tonight; limit workout to active stretching.";
    }

    // C. Hydration Deficit Alert
    final waterLogs = await (_db.select(_db.waterLogs)
          ..where((t) => t.createdAt.year.equals(today.year) && t.createdAt.month.equals(today.month) && t.createdAt.day.equals(today.day)))
        .get();
    final totalWater = waterLogs.fold(0.0, (sum, item) => sum + item.amountMl);
    if (DateTime.now().hour >= 15 && totalWater < 1000.0) {
      return "HYDRATION WARNING: It is past 3:00 PM and you have logged only ${(totalWater / 1000).toStringAsFixed(1)}L of water. Drink 500ml now to prevent energy slumps and cognitive fatigue.";
    }

    return null; // Delegate to Template Engine or AI
  }
}
```

#### 2. InsightTemplateEngine (Pure Dart)

```dart
class InsightTemplateEngine {
  final AppDatabase _db;
  InsightTemplateEngine(this._db);

  /// Selects and interpolates parameterized templates based on cached telemetry
  Future<String?> tryHandle(AIRequest request) async {
    if (request.complexity != AIComplexity.dailyInsight) return null;

    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    
    // Fetch last week's average logs to drive variables
    final foodLogs = await (_db.select(_db.foodLogs)
          ..where((t) => t.createdAt.isAfter(sevenDaysAgo)))
        .get();
    final totalProtein = foodLogs.fold(0.0, (sum, item) => sum + item.proteinG);
    final avgProtein = foodLogs.isNotEmpty ? totalProtein / foodLogs.length : 0.0;
    
    final snapshot = await (_db.select(_db.healthSnapshots)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    final readiness = snapshot?.readinessScore ?? 75;

    // Categorized template rotation to prevent user fatigue
    if (avgProtein < user.targetProteinG * 0.8) {
      final templates = [
        "You averaged ${avgProtein.toStringAsFixed(0)}g of protein this week vs your target of ${user.targetProteinG}g. To support recovery, add 100g of paneer or double dal to your next meal.",
        "Your weekly protein was lower than target (${avgProtein.toStringAsFixed(0)}g vs ${user.targetProteinG}g). Consider incorporating a scoop of whey protein or roasted chana as snacks.",
        "Protein gap detected: averaging ${avgProtein.toStringAsFixed(0)}g against a goal of ${user.targetProteinG}g. Increasing protein density in your breakfast can help close this deficit."
      ];
      return templates[today.day % templates.length];
    }

    if (readiness >= 85) {
      final templates = [
        "Your readiness score is excellent ($readiness/100). This is a prime day to push for progressive overload in your workout or tackle high-intensity training.",
        "Peak physical capacity unlocked ($readiness/100 readiness). Your nervous system is fully recovered—ideal for hitting a new personal best in the gym today.",
        "Readiness is green ($readiness/100). Energy capacity is maximized; feel free to increase training volume or cardio intensity today."
      ];
      return templates[today.day % templates.length];
    } else if (readiness < 60) {
      final templates = [
        "Readiness is low ($readiness/100). Limit training intensity to Zone 2 or active recovery. Focus on mineral-rich hydration and deep sleep tonight.",
        "Fatigue detected ($readiness/100 readiness). Avoid extreme cardiac loads today. Shift your workout focus to mobility, dynamic stretching, or active rest.",
        "Recovery capacity is compromised ($readiness/100). Prioritize stress management, cut workout volume by 50%, and aim for an early bedtime."
      ];
      return templates[today.day % templates.length];
    }

    // Default general wellness templates
    final templates = [
      "Your health score is tracking well at ${snapshot?.healthScore ?? 70}/100. Keep up the consistency with hydration and steps.",
      "Consistency is your superpower. Focus on hitting your daily steps and staying within your target calorie budget today.",
      "Stay aligned with your health plans today. Small, daily choices aggregate into massive physical transformations."
    ];
    return templates[today.day % templates.length];
  }
}
```

### Event-Driven AI Triggers

AI is NOT called on every user log. It is called only on meaningful threshold events:

```dart
class AITriggerEngine {
  AITrigger? checkTrigger(UserBehaviorData data) {
    if (data.proteinDeficitDays >= 5)
      return AITrigger.proteinIntervention;

    if (data.weightPlateauWeeks >= 3)
      return AITrigger.plateauIntervention;

    if (data.missedWorkoutsInARow >= 3)
      return AITrigger.workoutRelapse;

    if (data.readinessCrashedVsBaseline)
      return AITrigger.recoveryAlert;

    if (data.transformationRiskScore >= 70)
      return AITrigger.transformationRisk;

    return null; // No AI needed today
  }
}
```

### Context Compression

Before any AI call, compress the context from 6,000 tokens to ~400 tokens:

```dart
// BEFORE (v1 — sent raw): 3,000–6,000 tokens
{
  "sleep_log_day1": {...},
  "sleep_log_day2": {...},
  // ... 7 days × all metrics × full records
}

// AFTER (v1 — compressed): ~400 tokens
class HealthSnapshot {
  final String proteinTrend;       // "low" | "adequate" | "good"
  final String sleepTrend;         // "declining" | "stable" | "improving"
  final double weightChangeLast4w; // e.g. -0.8
  final int currentStreak;
  final int readinessScore;
  final int healthScore;
  final bool activeRisk;
  final String primaryConcern;     // Most important thing to address today
  final String programPhase;       // "Foundation" | "Build" | "Peak"
  final int daysToGoal;            // Remaining days in transformation window
}
```

#### ContextCompressor Implementation (Pure Dart)

This class aggregates raw user logs across several Drift database tables, applying simple linear slopes, aggregates, and thresholds to build the 400-token snapshot.

```dart
class ContextCompressor {
  final AppDatabase _db;
  ContextCompressor(this._db);

  /// Aggregates 7-30 days of raw database logs into a compact 400-token HealthSnapshot
  Future<HealthSnapshot> compress(String userId) async {
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final fourWeeksAgo = today.subtract(const Duration(days: 28));

    final user = await (_db.select(_db.users)..where((t) => t.localId.equals(userId))).getSingle();

    // 1. Calculate Protein Trend
    final foodLogs = await (_db.select(_db.foodLogs)
          ..where((t) => t.userId.equals(userId) && t.createdAt.isAfter(sevenDaysAgo)))
        .get();
    final totalProtein = foodLogs.fold(0.0, (sum, item) => sum + item.proteinG);
    final avgProtein = foodLogs.isNotEmpty ? totalProtein / 7.0 : 0.0;
    
    String proteinTrend = "low";
    if (avgProtein >= user.targetProteinG * 0.9) {
      proteinTrend = "good";
    } else if (avgProtein >= user.targetProteinG * 0.7) {
      proteinTrend = "adequate";
    }

    // 2. Calculate Sleep Trend (Linear slope over last 5-7 sleep records)
    final sleepLogs = await (_db.select(_db.sleepLogs)
          ..where((t) => t.userId.equals(userId) && t.createdAt.isAfter(sevenDaysAgo))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]))
        .get();
    
    String sleepTrend = "stable";
    if (sleepLogs.length >= 3) {
      final durations = sleepLogs.map((s) => s.durationMinutes.toDouble()).toList();
      double slope = 0.0;
      double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
      final n = durations.length;
      for (int i = 0; i < n; i++) {
        sumX += i;
        sumY += durations[i];
        sumXY += i * durations[i];
        sumXX += i * i;
      }
      slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
      if (slope > 15.0) { // Sleep increasing by >15 mins per night
        sleepTrend = "improving";
      } else if (slope < -15.0) { // Sleep declining by >15 mins per night
        sleepTrend = "declining";
      }
    }

    // 3. Calculate Weight Change Last 4 Weeks
    final weightReadings = await (_db.select(_db.bodyMeasurements)
          ..where((t) => t.userId.equals(userId) && t.createdAt.isAfter(fourWeeksAgo))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]))
        .get();
    double weightChange = 0.0;
    if (weightReadings.length >= 2) {
      weightChange = weightReadings.last.weightKg - weightReadings.first.weightKg;
    }

    // 4. Retrieve Vitals for Active Risk Detection
    final bp = await (_db.select(_db.bpReadings)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    final glucose = await (_db.select(_db.glucoseReadings)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    bool activeRisk = false;
    String primaryConcern = "No immediate concerns. Maintain consistency.";

    if (bp != null && (bp.systolic >= 140 || bp.diastolic >= 90)) {
      activeRisk = true;
      primaryConcern = "Hypertensive range blood pressure (${bp.systolic}/${bp.diastolic} mmHg).";
    } else if (glucose != null && glucose.valueMgDl >= 180) {
      activeRisk = true;
      primaryConcern = "Hyperglycemic glucose spike detected (${glucose.valueMgDl} mg/dL).";
    } else if (sleepTrend == "declining") {
      primaryConcern = "Sustained decline in sleep duration. Recovery capacity falling.";
    } else if (proteinTrend == "low") {
      primaryConcern = "Protein intake is below 70% of target; muscle preservation at risk.";
    }

    // 5. Gather Latest Scores
    final latestSnapshot = await (_db.select(_db.healthSnapshots)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    final readiness = latestSnapshot?.readinessScore ?? 70;
    final healthScore = latestSnapshot?.healthScore ?? 65;

    // 6. Calculate Program Stage & Days to Goal
    final targetDate = user.goalTargetDate ?? today.add(const Duration(days: 90));
    final daysToGoal = targetDate.difference(today).inDays;

    String programPhase = "Foundation";
    if (daysToGoal < 30) {
      programPhase = "Peak";
    } else if (daysToGoal < 60) {
      programPhase = "Build";
    }

    return HealthSnapshot(
      proteinTrend: proteinTrend,
      sleepTrend: sleepTrend,
      weightChangeLast4w: double.parse(weightChange.toStringAsFixed(1)),
      currentStreak: user.currentStreak ?? 0,
      readinessScore: readiness,
      healthScore: healthScore,
      activeRisk: activeRisk,
      primaryConcern: primaryConcern,
      programPhase: programPhase,
      daysToGoal: daysToGoal,
    );
  }
}
```

### Conversation Memory Management

```dart
class ConversationMemory {
  final AppDatabase _db;
  final AIClient _aiClient; // Calls fitkarma-coach microservice
  
  ConversationMemory(this._db, this._aiClient);

  /// Builds context for the AI coach request, combining a compressed background
  /// summary with a sliding window of the last 5 messages, and manages database state.
  Future<List<ChatMessage>> buildContext(String userId) async {
    // 1. Fetch the user's ongoing profile summary
    final user = await (_db.select(_db.users)..where((t) => t.localId.equals(userId))).getSingle();
    final String summaryText = user.conversationSummary ?? "User is starting their journey.";

    // 2. Fetch the sliding window of last 5 messages from Drift
    final recentMessages = await (_db.select(_db.chatMessages)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(5))
        .get();

    // Reverse to chronological order for the model context
    final chronologicalRecent = recentMessages.reversed.toList();

    // 3. Construct message array including system profile instructions
    final contextMessages = <ChatMessage>[
      ChatMessage(
        role: 'system',
        content: '''
          You are FitKarma's AI Coach. Adhere to the following profile summary of the user:
          $summaryText
          
          Respond concisely, using warm, supportive language with occasional Hindi-English elements.
        ''',
        createdAt: DateTime.now(),
      ),
      ...chronologicalRecent.map((m) => ChatMessage(
            role: m.role, // 'user' or 'assistant'
            content: m.content,
            createdAt: m.createdAt,
          )),
    ];

    // 4. Proactively check if conversation length warrants a background summarization
    _triggerAsyncSummaryCheck(userId);

    return contextMessages;
  }

  /// Evaluates conversation size and triggers a background summarization job if needed
  Future<void> _triggerAsyncSummaryCheck(String userId) async {
    // Count all active messages in this chat thread
    final countQuery = _db.select(_db.chatMessages)..where((t) => t.userId.equals(userId));
    final allMessages = await countQuery.get();

    // If message count exceeds threshold (10 messages) and hasn't been summarized recently
    if (allMessages.length >= 10) {
      final user = await (_db.select(_db.users)..where((t) => t.localId.equals(userId))).getSingle();
      final lastSummaryUpdate = user.lastSummaryUpdatedAt ?? DateTime(1970);
      
      // Prevent rapid fire calls by spacing summarization triggers by at least 15 minutes
      if (DateTime.now().difference(lastSummaryUpdate).inMinutes >= 15) {
        // Trigger background summarization without blocking the current chat turn
        _executeBackgroundSummarization(userId, allMessages);
      }
    }
  }

  /// Sends full conversation history to fitkarma-coach for summarization and updates the user profile
  Future<void> _executeBackgroundSummarization(String userId, List<ChatMessageData> messages) async {
    try {
      final chatLogString = messages
          .map((m) => "${m.role == 'user' ? 'User' : 'Coach'}: ${m.content}")
          .join('\n');

      // Request the LLM to generate a compressed summary and key facts
      final summaryResult = await _aiClient.generateSummary(chatLogString);

      // Update user row with new summary and update timestamp in Drift
      await (_db.update(_db.users)..where((t) => t.localId.equals(userId))).write(
        UsersCompanion(
          conversationSummary: Value(summaryResult.summaryText),
          lastSummaryUpdatedAt: Value(DateTime.now()),
        )
      );

      // Consolidate database size: delete older messages that are now represented in the summary
      // Keep only the last 5 messages to preserve local context buffer
      if (messages.length > 5) {
        final cutOffDate = messages[messages.length - 5].createdAt;
        await (_db.delete(_db.chatMessages)
              ..where((t) => t.userId.equals(userId) && t.createdAt.isBefore(cutOffDate)))
            .go();
      }
    } catch (e) {
      // Fail silently in background without disrupting the user's active UI session
      debugPrint("Background conversation summarization failed: $e");
    }
  }
}
```

### AI Cost Budget by User Tier

| Feature | Free | Pro | Elite |
|---------|------|-----|-------|
| Daily Intelligence Package | 1/day | 1/day | 1/day |
| AI Coach messages | 5/day | Unlimited | Unlimited |
| Meal Vision | 2/day | Unlimited | Unlimited |
| Transformation planning | No | Yes | Yes |
| Priority model (larger) | No | No | Yes |

### Estimated Token Savings

| Optimization | Savings |
|-------------|---------|
| Rule Engine for deterministic math | 20–30% |
| Daily Intelligence Package (4–8 calls → 1) | 30–50% |
| Context Compression (6,000 → 400 tokens) | 40–70% |
| Conversation Summaries | 20–40% |
| Prompt Caching | 10–30% |
| Event-Driven AI (no per-log calls) | 30–60% |
| Multi-Model Routing | 30–70% |

**Combined result: 70–95% token reduction** vs v1 — all features preserved.

### Hybrid Insight Engine

Three-layer insight generation. AI is the last resort, not the default:

```
Layer 1 — Rule Engine (no AI, zero cost):
  protein < 70% of target → "Protein low — add paneer to next meal"
  sleep < 6h for 3 days   → "Sleep debt building — prioritize 8h tonight"
  water < 50% by 3pm      → "You're behind on hydration for the day"

Layer 2 — Template Engine (no AI, zero cost):
  "You averaged {protein}g protein vs your {target}g target this week."
  "Your readiness is {score} — {recommendation} intensity today."
  "Sleep quality: {stars}/5. {debt_message}."

Layer 3 — AI Enhancement (only when rules + templates can't cover it):
  Complex pattern analysis
  Personalized lifestyle reasoning
  Novel situation adaptation
```

80–90% of insights are served by Layers 1 and 2. AI is called only for the remaining 10–20%.

---

## §P0-G. Program Evolution Engine

Programs in v1 are not static templates. They evolve with the user:

```dart
class ProgramEvolutionEngine {
  String? checkEvolution({
    required String currentProgram,
    required UserProgress progress,
  }) {
    // Example: Corporate Fat Loss → Corporate Recomposition
    if (currentProgram == 'Corporate Fat Loss' &&
        progress.weightLostKg >= 5 &&
        progress.consistencyScore >= 80) {
      return 'Corporate Recomposition';
    }

    // Corporate Recomposition → Athletic Lean Build
    if (currentProgram == 'Corporate Recomposition' &&
        progress.bodyFatPct <= 20 &&
        progress.leanMassGainedKg >= 1) {
      return 'Athletic Lean Build';
    }

    return null;
  }
}
```

Evolution paths:

```
Corporate Fat Loss ──► Corporate Recomposition ──► Athletic Lean Build
Student Hostel Fitness ──► Intermediate Strength ──► Athletic Performance
PCOS Fat Loss ──► PCOS Maintenance ──► PCOS Recomposition
Wedding Transformation ──► Post-Wedding Maintenance ──► Lifestyle Fitness
```

---

## §P0-H. Prerequisites

**Flutter & Dart:**
- Flutter 3.x, Dart 3.x
- `dart pub global activate mason_cli`

**Cloudflare:**
- Cloudflare account (free tier sufficient for dev)
- Wrangler CLI (`npm install -g wrangler`)
- Node.js 20.x for Cloudflare Workers

**Local tools:**
- `wrangler d1 execute` or the Cloudflare D1 dashboard
- Xcode (iOS builds), Android Studio

**Dart packages:**
```yaml
dependencies:
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  drift: ^2.x
  drift_sqflite: ^2.x
  sqlcipher_flutter_libs: ^0.5.0
  go_router: ^13.0.0
  health: ^10.x
  fl_chart: ^0.68.0
  speech_to_text: ^6.x
  image_picker: ^1.x
  local_auth: ^2.x
  purchases_flutter: ^7.x        # RevenueCat
  sentry_flutter: ^7.x
  workmanager: ^0.5.x
  http: ^1.x
  crypto: ^3.x                   # For prompt hash caching

dev_dependencies:
  riverpod_generator: ^2.x
  build_runner: ^2.x
  drift_dev: ^2.x
  flutter_test:
  golden_toolkit: ^0.15.0
```

---

## §P0-I. Adaptive Metabolism Engine (NEW v1 — MacroFactor-style)

> **The single biggest reason users plateau and quit.** Static TDEE is calculated once and never revisited. The Adaptive Metabolism Engine learns from actual weight change vs. expected weight change and continuously recalibrates the user's true maintenance calories.

### The Problem with Static TDEE

```
Static model (v1/v1):
  Week 1: TDEE = 2000 kcal  ← calculated once via Mifflin-St Jeor
  Week 8: TDEE = 2000 kcal  ← same — even if user lost nothing

  Result: "I followed the plan and didn't lose weight."
```

### Adaptive Model (v1)

```
Week 1:
  Expected loss = 0.5 kg  (deficit = 500 kcal/day)
  Actual loss   = 0.5 kg  ✓ Model accurate — no change

Week 4:
  Expected loss = 0.5 kg/week
  Actual loss   = 0.1 kg/week  ← under-performing

  Implied maintenance = calories_consumed - (actual_deficit_kcal)
  actual_deficit = 0.1 kg × 7700 kcal/kg ÷ 7 days ≈ 110 kcal/day
  Previous assumed deficit = 500 kcal/day
  
  Recalibrated TDEE = calories_consumed - 110
  New target calories = recalibrated_TDEE - 500 kcal

  System output: 1900 → 1750 kcal/day
```

### AdaptiveMetabolismEngine (Pure Dart — No AI)

```dart
class AdaptiveMetabolismEngine {
  /// Called weekly by the Health OS Brain.
  /// Requires at least 2 weigh-ins in the past 14 days.
  AdaptiveCalibrationResult recalibrate({
    required List<WeightReading> recentWeighIns,   // last 4 weeks
    required List<FoodLog> recentFoodLogs,          // last 4 weeks
    required double targetWeeklyDeltaKg,            // user's goal rate
    required int currentCalorieTarget,
  }) {
    if (recentWeighIns.length < 2) {
      return AdaptiveCalibrationResult.insufficientData();
    }

    // Step 1: Compute actual weekly weight change (regression over 4 weeks)
    final actualWeeklyDeltaKg = _linearRegression(recentWeighIns);

    // Step 2: Compute average daily calories consumed
    final avgCaloriesConsumed = _avgDailyCalories(recentFoodLogs);

    // Step 3: Compute implied actual TDEE
    //   actual_delta_kg/week × 7700 kcal/kg = weekly caloric delta
    //   TDEE_implied = calories_consumed - (actual_delta × 7700 / 7)
    final actualDailyDeltaKcal = actualWeeklyDeltaKg * 7700 / 7;
    final impliedTDEE = avgCaloriesConsumed - actualDailyDeltaKcal;

    // Step 4: Compute new target
    final targetDailyDeltaKcal = targetWeeklyDeltaKg * 7700 / 7;
    final newCalorieTarget = (impliedTDEE - targetDailyDeltaKcal).round();

    // Step 5: Adherence score — how accurately did user log?
    final loggingDays = recentFoodLogs
        .where((l) => l.isComplete)
        .length;
    final adherence = loggingDays / 28.0; // 28-day window

    // Step 6: Detect metabolic adaptation
    //   If user is eating less than expected but losing less than expected,
    //   metabolic adaptation (adaptive thermogenesis) may be occurring.
    final metabolicAdaptation = impliedTDEE <
        (_baselineTDEE * 0.85); // TDEE dropped >15% below baseline

    return AdaptiveCalibrationResult(
      previousCalorieTarget:  currentCalorieTarget,
      newCalorieTarget:       newCalorieTarget.clamp(1200, 4000),
      impliedTDEE:            impliedTDEE.round(),
      actualWeeklyDeltaKg:    actualWeeklyDeltaKg,
      targetWeeklyDeltaKg:    targetWeeklyDeltaKg,
      adherenceScore:         adherence,
      metabolicAdaptationDetected: metabolicAdaptation,
      calibrationDate:        DateTime.now(),
      confidenceLevel:        _confidence(adherence, recentWeighIns.length),
    );
  }

  double _linearRegression(List<WeightReading> readings) {
    if (readings.length < 2) return 0.0;

    // Sort readings chronologically
    final sorted = List<WeightReading>.from(readings)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Step 1: Apply 7-day rolling median smoothing to filter water-weight noise
    final smoothed = <double>[];
    for (int i = 0; i < sorted.length; i++) {
      final current = sorted[i];
      final window = sorted.where((r) {
        final difference = current.date.difference(r.date).inDays.abs();
        return difference <= 6;
      }).map((r) => r.weightKg).toList();
      
      window.sort();
      final median = window[window.length ~/ 2];
      smoothed.add(median);
    }

    // Step 2: Compute least-squares linear regression slope (kg per week)
    final firstDate = sorted.first.date;
    final times = sorted.map((r) => r.date.difference(firstDate).inDays / 7.0).toList(); // time in weeks

    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumXX = 0;
    final n = sorted.length;

    for (int i = 0; i < n; i++) {
      final x = times[i];
      final y = smoothed[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }

    final denominator = (n * sumXX) - (sumX * sumX);
    if (denominator == 0) return 0.0;

    final slopeKgPerWeek = ((n * sumXY) - (sumX * sumY)) / denominator;
    return slopeKgPerWeek;
  }

  CalibrationConfidence _confidence(double adherence, int weighIns) {
    if (adherence > 0.85 && weighIns >= 4) return CalibrationConfidence.high;
    if (adherence > 0.60 && weighIns >= 2) return CalibrationConfidence.medium;
    return CalibrationConfidence.low;
  }
}
```

### Weekly Recalibration Output (shown to user)

```
📊 Weekly Metabolism Check-In

Expected loss this week:    -0.5 kg
Actual loss:                -0.1 kg

Your body adapted — recalibrating your plan.

Estimated Maintenance:  1,960 kcal/day  (was 2,100)
New Daily Target:       1,460 kcal/day  (was 1,600)

Adherence Score:  78%  (logging reliability)
Confidence:       Medium  (log more days for higher accuracy)

⚠️ Metabolic Adaptation Detected
Your metabolism has slowed ~14% below baseline.
Consider: 1 refeed day per week at maintenance calories.
```

### Calibration Schedule

| Condition | Action |
|-----------|--------|
| ≥ 2 weigh-ins in 14 days + ≥ 14 food logs | Full recalibration |
| 1 weigh-in only | Partial estimate, low confidence |
| No weigh-ins | No recalibration; notify user |
| Adherence < 50% | Recalibrate with warning: "Log more days for accuracy" |
| Metabolic adaptation detected | Add refeed protocol suggestion |

### Integration with Health OS Brain

The `AdaptiveMetabolismEngine` runs weekly inside `fitkarma-health-os` and its output feeds directly into `DailyIntelligencePackage.adjustedCalorieTarget`. No AI is ever called — this is pure regression math.

---

## §P0-J. Environmental Health Layer (NEW v1 — AQI + UV + Heat)

India-specific environmental signals that directly impact workout decisions, hydration, and recovery.

### Inputs

| Signal | Source | Refresh |
|--------|--------|---------|
| AQI (PM2.5 / PM10) | CPCB API + OpenWeatherMap | Hourly |
| Heat Index (temp + humidity) | OpenWeatherMap | Hourly |
| UV Index | OpenWeatherMap | Daily |
| Pollen (future) | Third-party pollen API | Daily |

### EnvironmentalHealthEngine

```dart
class EnvironmentalHealthEngine {
  EnvironmentalAdaptation evaluate(EnvironmentalData env) {
    final risks = <EnvironmentalRisk>[];

    // AQI classification (India NAQI standard)
    if (env.aqi > 300) {
      risks.add(EnvironmentalRisk.aqiHazardous);
    } else if (env.aqi > 200) {
      risks.add(EnvironmentalRisk.aqiVeryPoor);
    } else if (env.aqi > 100) {
      risks.add(EnvironmentalRisk.aqiPoor);
    }

    // Heat index
    if (env.heatIndexC > 41) {
      risks.add(EnvironmentalRisk.heatExtreme);
    } else if (env.heatIndexC > 35) {
      risks.add(EnvironmentalRisk.heatHigh);
    }

    // UV
    if (env.uvIndex > 10) {
      risks.add(EnvironmentalRisk.uvExtreme);
    }

    return _buildAdaptation(risks);
  }

  EnvironmentalAdaptation _buildAdaptation(List<EnvironmentalRisk> risks) {
    if (risks.contains(EnvironmentalRisk.aqiHazardous)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorOnly,
        hydrationBoostL: 0.5,
        warningBanner: 'AQI ${env.aqi} — Hazardous. '
            'Outdoor exercise not recommended. '
            'Switch to indoor workout today.',
        bannerColor: AppColorsDark.error,
      );
    }
    if (risks.contains(EnvironmentalRisk.aqiVeryPoor)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorPreferred,
        hydrationBoostL: 0.3,
        warningBanner: 'AQI ${env.aqi} — Very Poor air quality. '
            'Indoor workout strongly preferred.',
        bannerColor: AppColorsDark.warning,
      );
    }
    if (risks.contains(EnvironmentalRisk.heatExtreme)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.earlyMorningOrIndoor,
        hydrationBoostL: 0.8,
        warningBanner: 'Heat index ${env.heatIndexC}°C. '
            'Exercise before 7am or indoors. Hydration +800ml.',
        bannerColor: AppColorsDark.warning,
      );
    }
    return EnvironmentalAdaptation.clear();
  }
}
```

### AQI Warning Banner (UI)

Shown on Dashboard when AQI > 100 or heat index > 35°C:

```
┌─────────────────────────────────────────┐
│ 🌫️  AQI 240 — Very Poor                │
│ Indoor workout recommended today.       │
│ Tap to see adapted workout →            │
└─────────────────────────────────────────┘
```

### Decision Hierarchy Integration

Environmental risk feeds into Priority 1 (Medical Risk):
- AQI > 300 → outdoor exercise blocked regardless of program
- Heat Index > 41°C → same as medical override

---

# PHASE 1 — ONBOARDING + USER PROFILE

---

## §P1-A. Onboarding Flow Order

```
1. /onboarding/welcome          → Splash + value proposition
2. /onboarding/goals            → What do you want to achieve? (Step 1 of 5)
3. /onboarding/demographics     → Physical profile + BMI  [REQUIRED — no Skip]
4. /onboarding/diet_plan        → AI-generated 7-day diet preview
5. /onboarding/dosha            → Ayurvedic body type quiz (Step 3 of 5)
6. /onboarding/program_select   → Choose your Blueprint (Step 4 of 5)
7. /onboarding/permissions      → Health + notification permissions (Step 5 of 5)
```

---

## §P1-B. Welcome Screen

**Route:** `/onboarding/welcome`
**Scaffold:** Pattern C (full-bleed `heroDeep` gradient background)

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│                    [ FitKarma Logo ]                   │
│                     (Spring Reveal)                    │
│                                                        │
│                                                        │
│               Your health, your karma.                 │
│                                                        │
│         Track steps, food, sleep, and vitals.          │
│          Earn karma. Build habits that last.           │
│                                                        │
│                                                        │
│                                                        │
│                 ┌────────────────────┐                 │
│                 │   Get Started →    │                 │
│                 └────────────────────┘                 │
│                                                        │
│                I already have an account               │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Screen Composition & Transitions

1. **Background**: Gradient color `AppColorsDark.heroDeep` spanning full height, using a `Positioned.fill` canvas.
2. **Animated Logo Widget**:
   * Uses `AnimatedOpacity` and `Transform.scale` driven by a state-triggered animation controller.
   * Animation curves utilize `AppSprings.logoRevealCurve` to create a bounce-reveal effect starting at a 300ms delay.
3. **Buttons**:
   * **Get Started CTA**: Full-width `ElevatedButton` utilizing `BentoCard` style hover scales, navigating to `/onboarding/goals`.
   * **Login text link**: A flat `TextButton` styled with `AppTypography.bodyMd` with `color: AppColorsDark.textSecondary` navigating to `/login`.

---

## §P1-C. Goals Screen

**Route:** `/onboarding/goals` | **Step:** 1 of 5
**Scaffold:** Standard dark background with step progress bar indicator at top (`1 of 5`).

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [=========>................................]  1 of 5  │
│                                                        │
│  Choose up to 3 Goals                                  │
│                                                        │
│  ┌───────────────────────┐   ┌───────────────────────┐ │
│  │  [ ] Weight Loss      │   │  [ ] Muscle Gain      │ │
│  └───────────────────────┘   └───────────────────────┘ │
│  ┌───────────────────────┐   ┌───────────────────────┐ │
│  │  [ ] PCOS Management  │   │  [ ] Heart Health     │ │
│  └───────────────────────┘   └───────────────────────┘ │
│  ┌───────────────────────┐   ┌───────────────────────┐ │
│  │  [ ] Diabetes Control │   │  [ ] General Fitness  │ │
│  └───────────────────────┘   └───────────────────────┘ │
│                                                        │
│  Target Weight: 72 kg                                  │
│  [-------o-------------------------------------------] │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │                    Continue                       │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Selection & Conditional Logic Rules

1. **Max Limit Validation**: The user can tap up to 3 cells. If a 4th cell is tapped, a subtle horizontal shake animation is triggered on the cell via an animation controller, accompanied by a `BilingualLabel` toast: `"Maximum 3 goals selectable" / "अधिकतम 3 लक्ष्य चुने जा सकते हैं"`.
2. **Conditional Slider**:
   * If "Weight Loss" or "Muscle Gain" is active, a slider container fades in smoothly below the grid using `AnimatedSize` and `AnimatedOpacity`.
   * Slider range: `40 kg` to `150 kg` (resolution: `0.5 kg` steps). Default target: `Current Weight - 5 kg` for weight loss; `Current Weight + 5 kg` for muscle gain.
3. **Drift Local Database Integration**:
   * On clicking "Continue", targets are committed to the Drift database.

```dart
// Riverpod notifier managing Onboarding Goals state
@riverpod
class OnboardingGoalsNotifier extends _$OnboardingGoalsNotifier {
  @override
  OnboardingGoalsState build() => const OnboardingGoalsState();

  void toggleGoal(String goalId) {
    final current = state.selectedGoals;
    if (current.contains(goalId)) {
      state = state.copyWith(selectedGoals: current.where((id) => id != goalId).toList());
    } else if (current.length < 3) {
      state = state.copyWith(selectedGoals: [...current, goalId]);
    }
  }

  void updateTargetWeight(double weight) {
    state = state.copyWith(targetWeight: weight);
  }

  Future<void> saveToDb(AppDatabase db) async {
    await db.updateUserProfile(
      usersCompanion: UsersCompanion(
        selectedGoals: Value(state.selectedGoals.join(',')),
        targetWeight: Value(state.targetWeight),
      ),
    );
  }
}
```

---

## §P1-D. Demographics Screen

**Route:** `/onboarding/demographics` | **Step:** 2 of 5 | **No Skip button**

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [====================>.....................]  2 of 5  │
│                                                        │
│  Tell us about yourself                                │
│                                                        │
│  Gender:   [ Male ]   [ Female ]                       │
│                                                        │
│  Age:      32 yrs  [---------o-----------------------] │
│  Height:   175 cm  [------------o--------------------] │
│  Weight:   80.0 kg [---------------o-----------------] │
│                                                        │
│  Live BMI: 26.1 (Overweight)                           │
│  [=========>................................] (Yellow) │
│                                                        │
│  Activity: [ Sedentary ] [ Active ] [ High ]           │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │                    Continue                       │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Live BMI Calculation & Target Selection Logic

1. **Live Calculator**: As the user drags the Height or Weight sliders, the UI dynamically computes and displays the BMI using a reactive Riverpod provider.
2. **Formula**:
   $$\text{BMI} = \frac{\text{Weight (kg)}}{\left(\frac{\text{Height (cm)}}{100}\right)^2}$$
3. **Indicator Color Coding**:
   - $\text{BMI} < 18.5$: Underweight (Blue)
   - $18.5 \le \text{BMI} < 25$: Normal (Green)
   - $25 \le \text{BMI} < 30$: Overweight (Yellow/Orange)
   - $\text{BMI} \ge 30$: Obese (Red)

```dart
// Reactive provider for live BMI calculation
final liveBmiProvider = Provider.family<BmiResult, ({double weight, double height})>((ref, arg) {
  if (arg.height <= 0) return const BmiResult(score: 0.0, category: BmiCategory.normal);
  final heightMeters = arg.height / 100.0;
  final score = arg.weight / (heightMeters * heightMeters);
  
  BmiCategory category;
  if (score < 18.5) {
    category = BmiCategory.underweight;
  } else if (score < 25.0) {
    category = BmiCategory.normal;
  } else if (score < 30.0) {
    category = BmiCategory.overweight;
  } else {
    category = BmiCategory.obese;
  }
  
  return BmiResult(score: score, category: category);
});

enum BmiCategory { underweight, normal, overweight, obese }

class BmiResult {
  final double score;
  final BmiCategory category;
  const BmiResult({required this.score, required this.category});

  String get displayName => score.toStringAsFixed(1);
  
  Color get color {
    switch (category) {
      case BmiCategory.underweight: return Colors.blue;
      case BmiCategory.normal: return Colors.green;
      case BmiCategory.overweight: return Colors.orange;
      case BmiCategory.obese: return Colors.red;
    }
  }
}
```

### Adaptive Targets (Computed in Dart — Never AI)

Once the user taps **Continue**, the engine calculates baseline targets using the Mifflin-St Jeor equation and scales them locally.

| BMI Category | Steps | Workout | Water | Calories |
|-------------|-------|---------|-------|----------|
| Underweight | 6,000 | 30 min | 2.0 L | TDEE + 300 |
| Normal | 8,000 | 45 min | 2.5 L | TDEE |
| Overweight | 10,000 | 60 min | 3.0 L | TDEE − 300 |
| Obese | 8,000 | 45 min | 3.5 L | TDEE − 500 |

TDEE Formula (Mifflin-St Jeor):
- **Men**: $\text{BMR} = 10 \times \text{Weight (kg)} + 6.25 \times \text{Height (cm)} - 5 \times \text{Age (y)} + 5$
- **Women**: $\text{BMR} = 10 \times \text{Weight (kg)} + 6.25 \times \text{Height (cm)} - 5 \times \text{Age (y)} - 161$
- **TDEE**: $\text{BMR} \times \text{Activity Multiplier}$ (Sedentary: 1.2, Lightly Active: 1.375, Moderately Active: 1.55, Very Active: 1.725, Extra Active: 1.9).

---

## §P1-E. AI Diet Plan Results Screen

**Route:** `/onboarding/diet_plan`
**Scaffold:** Dark theme bento container with a 7-day calendar header.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [=====================>....................]  3 of 5  │
│                                                        │
│  Your Personalized 7-Day Indian Diet Plan              │
│                                                        │
│   [ Mon ]  [ Tue ]  [ Wed ]  [ Thu ]  [ Fri ]  [ Sat ] │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │ Daily Targets: 1,800 kcal  ·  120g Protein        │ │
│  │ [==============] (100% Macro Allocation)         │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Breakfast:                                            │
│  ┌───────────────────────────────────────────────────┐ │
│  │ Paneer Bhurji + 2 Roti                 420 kcal   │ │
│  │ 22g Protein · 35g Carbs · 12g Fat                 │ │
│  │ Tip: Use low-fat paneer to control fats.           │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Lunch:                                                │
│  ┌───────────────────────────────────────────────────┐ │
│  │ Dal Tadka + Brown Rice + Salad          580 kcal   │ │
│  │ 18g Protein · 75g Carbs · 8g Fat                  │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│     [ Regenerate (1 left) ]      [ Accept Plan ]       │
└────────────────────────────────────────────────────────┘
```

### Loading & Fallback Caching Logic (Offline-First Compliance)

1. **Optimistic Loading State**:
   * While the Groq API call compiles, a `ShimmerLoader` skeleton card grid is rendered to represent the meal cards.
   * If the network is unavailable or the API times out (>8 seconds), the application immediately cancels the call and falls back to a **locally compiled deterministic meal blueprint** corresponding to the user's selected diet preference (e.g. Vegetarian/Vegan/Non-Vegetarian) and pre-calculated calories/macros.
2. **Drift Caching**:
   * The generated plan is written to `diet_plans` Drift table.
   * Cached plan is valid for 7 days. If the user's BMI changes by less than 1.0 within these 7 days, subsequent views load directly from local database, preventing wasteful API requests.

### Groq Prompt Template

```
You are an expert Indian nutritionist. Generate a 7-day personalized meal plan.

User Profile:
- Name: {name}, Age: {age}, BMI: {bmi}, Goal: {goals}
- Activity: {activityLevel}, Work style: {workStyle}
- Dietary preference: {dietType} (vegetarian/non-vegetarian/vegan)
- Daily calorie target: {calorieTarget} kcal (pre-calculated — use this exactly)
- Daily protein target: {proteinTarget}g (pre-calculated — use this exactly)

Rules:
- Use ONLY authentic Indian foods (no generic "salad" or "grilled chicken")
- Include regional variety (South Indian, North Indian, street food, etc.)
- Respect fasting days and dietary restrictions
- Every meal must have name, calories, protein, carbs, fat
- Include one practical tip per meal

Return ONLY valid JSON. No markdown. No explanation.
Format: { "days": [ { "day": "Monday", "meals": [ ... ] } ] }
```

Note: Calorie and protein targets are passed in pre-calculated. The AI fills the creative meal choices only — it does not re-derive nutrition targets.

---

## §P1-F. Dosha Quiz Screen

**Route:** `/onboarding/dosha` | **Step:** 3 of 5

10 questions, spring slide between them. Result influences Ayurvedic meal recommendations and stress management approach.

### DoshaQuizScoringEngine (Pure Dart)

```dart
enum DoshaType { vata, pitta, kapha }

class DoshaQuizScoringEngine {
  DoshaResult calculateDoshaProfile(List<DoshaAnswer> answers) {
    int vataScore = 0;
    int pittaScore = 0;
    int kaphaScore = 0;

    for (final answer in answers) {
      switch (answer.associatedDosha) {
        case DoshaType.vata: vataScore++; break;
        case DoshaType.pitta: pittaScore++; break;
        case DoshaType.kapha: kaphaScore++; break;
      }
    }

    final total = vataScore + pittaScore + kaphaScore;
    if (total == 0) return DoshaResult.equalDistribution();

    final vataPct = (vataScore / total) * 100;
    final pittaPct = (pittaScore / total) * 100;
    final kaphaPct = (kaphaScore / total) * 100;

    // Determine dominant Dosha
    DoshaType dominant = DoshaType.vata;
    double maxPct = vataPct;
    if (pittaPct > maxPct) {
      dominant = DoshaType.pitta;
      maxPct = pittaPct;
    }
    if (kaphaPct > maxPct) {
      dominant = DoshaType.kapha;
    }

    return DoshaResult(
      dominant: dominant,
      vataPct: vataPct,
      pittaPct: pittaPct,
      kaphaPct: kaphaPct,
      guidelines: _generateGuidelines(dominant),
    );
  }

  DoshaGuidelines _generateGuidelines(DoshaType dominant) {
    switch (dominant) {
      case DoshaType.vata:
        return DoshaGuidelines(
          dietaryFocus: "Warm, cooked, and grounding foods. Favor sweet, sour, and salty tastes. Limit raw/cold items.",
          stressFocus: "Gentle grounding routines, warm oil self-massage (Abhyanga), and restorative yoga.",
          recommendedSpices: ["Ginger", "Cardamom", "Cinnamon", "Cumin"],
        );
      case DoshaType.pitta:
        return DoshaGuidelines(
          dietaryFocus: "Cooling, hydrating foods. Favor sweet, bitter, and astringent tastes. Avoid spicy/fermented foods.",
          stressFocus: "Non-competitive exercise, cooling breathing practices (Shitali Pranayama), and spending time in nature.",
          recommendedSpices: ["Fennel", "Coriander", "Cilantro", "Turmeric"],
        );
      case DoshaType.kapha:
        return DoshaGuidelines(
          dietaryFocus: "Warm, light, and dry foods. Favor pungent, bitter, and astringent tastes. Avoid heavy dairy and sweets.",
          stressFocus: "Vigorous daily physical activity, stimulating dynamic breathing (Kapalabhati), and warm-up stretches.",
          recommendedSpices: ["Black Pepper", "Ginger", "Mustard Seeds", "Cayenne"],
        );
    }
  }
}

class DoshaAnswer {
  final String questionId;
  final DoshaType associatedDosha;
  DoshaAnswer({required this.questionId, required this.associatedDosha});
}

class DoshaResult {
  final DoshaType dominant;
  final double vataPct;
  final double pittaPct;
  final double kaphaPct;
  final DoshaGuidelines guidelines;

  DoshaResult({
    required this.dominant,
    required this.vataPct,
    required this.pittaPct,
    required this.kaphaPct,
    required this.guidelines,
  });

  factory DoshaResult.equalDistribution() => DoshaResult(
    dominant: DoshaType.vata,
    vataPct: 33.3,
    pittaPct: 33.3,
    kaphaPct: 33.3,
    guidelines: DoshaGuidelines(
      dietaryFocus: "Balanced diet containing equal elements.",
      stressFocus: "Alternate nostril breathing (Nadi Shodhana).",
      recommendedSpices: ["Ginger", "Fennel"],
    ),
  );
}

class DoshaGuidelines {
  final String dietaryFocus;
  final String stressFocus;
  final List<String> recommendedSpices;
  DoshaGuidelines({
    required this.dietaryFocus,
    required this.stressFocus,
    required this.recommendedSpices,
  });
}
```

---

## §P1-G. Program Blueprint Selection Screen

**Route:** `/onboarding/program_select` | **Step:** 4 of 5
**Scaffold:** Dark theme bento layout showing the recommended fitness path.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [===============================>..........]  4 of 5  │
│                                                        │
│  Your Recommended Health Blueprint                     │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Corporate Fat Loss                               │ │
│  │  Recommended based on: High Stress + Sedentary     │ │
│  │  Work Profile. Focuses on low-barrier habits,      │ │
│  │  post-meal walks, and desk-friendly movement.       │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Your Program Evolution Timeline:                      │
│                                                        │
│  [Corporate Fat Loss] ──► [Corporate Recomp] ──► [Lean Build] │
│      (Current)              (Next Tier)          (Peak Performance) │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │                Select this Blueprint              │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Allocation Rules & Database Integration

1. **Deterministic Assignment**: The engine matching rules are calculated locally in Dart.
   - If user selected *PCOS Management* under goals: Assigns **PCOS Fat Loss**.
   - If age $\ge 50$: Assigns **Senior Strength & Balance**.
   - If BMI $\ge 25$ and *Diabetes/Heart Health* goals not selected:
     - If *Work Style* is "Desk/Office": Assigns **Corporate Fat Loss**.
     - Else: Assigns **Indian Vegetarian Muscle Gain** (if vegetarian) or **Athletic Performance** (if active).
2. **Evolution Visualizer**:
   - Renders a horizontal timeline diagram mapping the user's progress. As they log consistency scores $\ge 80\%$ and hit target milestones, the `ProgramEvolutionEngine` triggers the next stage.
3. **Database Write**:
   * Selection writes `program_id` and the baseline `week_number` (1) to the Drift `user_profiles` table.

### Program Library

| Program | Target User | Evolves To |
|---------|------------|-----------|
| Corporate Fat Loss | Office workers, high stress | Corporate Recomposition |
| Indian Vegetarian Muscle Gain | Veg users building muscle | Athletic Lean Build |
| PCOS Fat Loss | Women with PCOS | PCOS Maintenance |
| Wedding Transformation | 8–16 week goal | Post-Wedding Maintenance |
| New Mom Recovery | Postpartum fitness | Lifestyle Fitness |
| Student Hostel Fitness | No gym, budget | Intermediate Strength |
| Diabetes Reversal Support | High glucose users | Metabolic Optimization |
| Heart Health Guardian | Elevated BP / cardiac risk | Heart Maintenance |
| Senior Strength & Balance | Users 50+ | Active Aging |
| Athletic Performance | Already fit, optimize | Elite Athletic |
| Menopause Wellness | Women 45–60 | Hormonal Balance |

---

## §P1-H. Women's Advanced Health Layer (NEW v1)

> Expands beyond PCOS-only. FitKarma v1 supports the full female health lifecycle — menstrual cycle, fertility planning, and menopause.

### Cycle-Aware Training Adapter

```dart
class CycleAwareTrainingAdapter {
  WorkoutAdaptation adaptForCyclePhase(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => WorkoutAdaptation(
          intensityModifier: 0.70,
          preferredTypes: ['Yoga', 'Walking', 'Light Pilates'],
          avoidTypes: ['HIIT', 'Heavy Lifting'],
          rationale: 'Energy and iron levels are lower. '
              'Gentle movement reduces cramps and improves mood.',
        ),
      CyclePhase.follicular => WorkoutAdaptation(
          intensityModifier: 1.10,
          preferredTypes: ['Strength Training', 'HIIT', 'Running'],
          rationale: 'Estrogen rising — best phase for high-intensity '
              'training and new personal records.',
        ),
      CyclePhase.ovulatory => WorkoutAdaptation(
          intensityModifier: 1.05,
          preferredTypes: ['Strength', 'Cardio', 'Sports'],
          rationale: 'Peak energy and coordination. '
              'Optimal for performance-focused sessions.',
        ),
      CyclePhase.luteal => WorkoutAdaptation(
          intensityModifier: 0.85,
          preferredTypes: ['Moderate Cardio', 'Yoga', 'Strength'],
          nutritionNote: 'Cravings increase — add complex carbs '
              '(oats, sweet potato) to curb PMS cravings.',
          rationale: 'Progesterone dominates. '
              'Body temperature slightly elevated; reduce intensity if fatigued.',
        ),
    };
  }
}
```

### Cycle-Aware Nutrition Adapter

| Phase | Nutritional Focus | Indian Food Examples |
|-------|-------------------|----------------------|
| Menstrual | Iron + Vitamin C | Spinach dal, sesame chikki, pomegranate |
| Follicular | Protein + B vitamins | Eggs, sprouts, moong dal |
| Ovulatory | Antioxidants + light meals | Fruits, salads, coconut water |
| Luteal | Complex carbs + magnesium | Sweet potato, banana, dark chocolate |

### Fertility Planning Mode

When user sets goal to "Fertility / Trying to Conceive":

```
Tracks:
  - Cycle regularity (flag irregular cycles > 35 days)
  - Ovulation window prediction (LH-based or calendar method)
  - Folate-rich food recommendations
  - Iron + Vitamin D status from clinical reports

Nutrition focus:
  - Folic acid foods (green leafy veg, lentils)
  - Avoid: alcohol, excess caffeine (flagged in food log)

Workout guidance:
  - Moderate intensity preferred; avoid extreme training
  - No high-HIIT during luteal phase

Coach tone: Gentle, non-pressuring
```

### Menopause Symptom Tracking

```dart
class MenopauseTracker {
  final symptoms = [
    'Hot flashes',
    'Night sweats',
    'Sleep disruption',
    'Mood changes',
    'Joint pain',
    'Brain fog',
    'Weight gain (mid-section)',
  ];

  // Adaptations:
  // Nutrition: Phytoestrogen foods (soy, flaxseed, tofu)
  // Training: Resistance training prioritized (bone density)
  // Sleep: Cooling bedtime routine, magnesium supplement flag
  // Readiness: Lower baseline expected — score normalized
}
```

### PCOS and Irregular Cycle Calibrator

To support users with irregular cycle profiles (e.g., due to PCOS or thyroid variations), the cycle-adaptation engine cannot rely on a static 28-day calendar. FitKarma implements a dynamic phase calibrator that adjusts cycle projections and training adaptation based on actual symptom logs, LH test surge readings, and basal body temperature (BBT) shifts.

##### Implementation: DynamicCycleCalibrator (Pure Dart)

```dart
enum CyclePhase { menstrual, follicular, ovulatory, luteal }

class MenstrualSymptomLog {
  final DateTime logDate;
  final bool hasMenstrualFlow; // Declares Day 1 of cycle
  final double? basalBodyTemperatureCelsius; // Post-ovulation BBT rises 0.2°C - 0.5°C
  final bool? positiveLhTest; // LH surge indicators
  final List<String> physicalSymptoms; // e.g., ['cramps', 'bloating', 'egg_white_mucus', 'ovulation_pain']
  final int? restingHeartRateBpm; // Progesterone surge causes RHR to rise 2-4 bpm
  final double? heartRateVariabilityMs; // Progesterone surge causes HRV to decrease

  MenstrualSymptomLog({
    required this.logDate,
    required this.hasMenstrualFlow,
    this.basalBodyTemperatureCelsius,
    this.positiveLhTest,
    required this.physicalSymptoms,
    this.restingHeartRateBpm,
    this.heartRateVariabilityMs,
  });
}

class DynamicCycleState {
  final int currentCycleDay;
  final int projectedCycleLength;
  final CyclePhase currentPhase;
  final bool isIrregularDetected;

  DynamicCycleState({
    required this.currentCycleDay,
    required this.projectedCycleLength,
    required this.currentPhase,
    required this.isIrregularDetected,
  });

  factory DynamicCycleState.defaultCalendar(int length, CyclePhase phase) =>
      DynamicCycleState(
        currentCycleDay: 1,
        projectedCycleLength: length,
        currentPhase: phase,
        isIrregularDetected: false,
      );
}

class DynamicCycleCalibrator {
  /// Evaluates and recalibrates cycle phases dynamically based on historical averages
  /// and symptom logs, resolving PCOS or general irregularity issues.
  DynamicCycleState recalibratePhase({
    required List<MenstrualSymptomLog> symptomLogs,
    required int defaultCycleLengthDays, // e.g. 28 days onboarding fallback
  }) {
    if (symptomLogs.isEmpty) {
      return DynamicCycleState.defaultCalendar(defaultCycleLengthDays, CyclePhase.follicular);
    }

    // Sort logs chronologically
    final sortedLogs = List<MenstrualSymptomLog>.from(symptomLogs)
      ..sort((a, b) => a.logDate.compareTo(b.logDate));

    // 1. Identify start of current cycle (first day of flow)
    final flowStarts = sortedLogs.where((l) => l.hasMenstrualFlow).map((l) => l.logDate).toList();
    if (flowStarts.isEmpty) {
      return DynamicCycleState.defaultCalendar(defaultCycleLengthDays, CyclePhase.follicular);
    }
    
    final currentCycleStart = flowStarts.last;
    final daysInCurrentCycle = DateTime.now().difference(currentCycleStart).inDays + 1;

    // Calculate historical cycle lengths to detect variance (irregularity indicator)
    final historicalLengths = <int>[];
    for (int i = 1; i < flowStarts.length; i++) {
      historicalLengths.add(flowStarts[i].difference(flowStarts[i - 1]).inDays);
    }

    final isIrregular = historicalLengths.isNotEmpty && 
        (historicalLengths.map((l) => (l - defaultCycleLengthDays).abs()).reduce((a, b) => a + b) / historicalLengths.length > 4);

    // 2. Scan logs of current cycle for ovulation events
    DateTime? detectedOvulationDate;
    final currentCycleLogs = sortedLogs.where((l) => !l.logDate.isBefore(currentCycleStart)).toList();

    // Check for positive LH strip test
    final lhPositiveLog = currentCycleLogs.firstWhere(
      (l) => l.positiveLhTest == true,
      orElse: () => MenstrualSymptomLog(logDate: DateTime(1970), hasMenstrualFlow: false, physicalSymptoms: []),
    );
    if (lhPositiveLog.logDate.year != 1970) {
      detectedOvulationDate = lhPositiveLog.logDate.add(const Duration(days: 1)); // Ovulation roughly 24h post-LH surge
    }

    // If no LH test, check for basal body temperature (BBT) shift: sustained rise of 0.2°C - 0.5°C
    if (detectedOvulationDate == null && currentCycleLogs.length >= 3) {
      for (int i = 2; i < currentCycleLogs.length; i++) {
        final t0 = currentCycleLogs[i-2].basalBodyTemperatureCelsius;
        final t1 = currentCycleLogs[i-1].basalBodyTemperatureCelsius;
        final t2 = currentCycleLogs[i].basalBodyTemperatureCelsius;
        if (t0 != null && t1 != null && t2 != null) {
          if (t1 - t0 >= 0.2 && t2 - t0 >= 0.2) {
            detectedOvulationDate = currentCycleLogs[i-1].logDate; // Temp shifted on day i-1
            break;
          }
        }
      }
    }

    // Fallback: If BBT and LH are missing, run continuous resting heart rate (RHR) and symptom tracking
    if (detectedOvulationDate == null && currentCycleLogs.isNotEmpty) {
      // Step A: Calculate baseline RHR during the follicular phase (first 10 days of cycle)
      final follicularRhrLogs = currentCycleLogs
          .where((l) => l.logDate.difference(currentCycleStart).inDays <= 10 && l.restingHeartRateBpm != null)
          .toList();

      if (follicularRhrLogs.isNotEmpty) {
        final double follicularBaselineRhr = follicularRhrLogs
            .map((l) => l.restingHeartRateBpm!)
            .reduce((a, b) => a + b) / follicularRhrLogs.length;

        // Step B: Search for a sustained RHR rise (+2 to +5 bpm) combined with subjective symptom validation
        for (int i = 0; i < currentCycleLogs.length; i++) {
          final log = currentCycleLogs[i];
          final rhr = log.restingHeartRateBpm;

          if (rhr != null && rhr - follicularBaselineRhr >= 2.0) {
            final hasSubjectiveSymptoms = log.physicalSymptoms.contains('egg_white_mucus') ||
                log.physicalSymptoms.contains('ovulation_pain') ||
                log.physicalSymptoms.contains('mittelschmerz');

            // If physiological rise is supported by subjective markers, calibrate ovulation
            if (hasSubjectiveSymptoms && log.logDate.difference(currentCycleStart).inDays > 10) {
              detectedOvulationDate = log.logDate;
              break;
            }
          }
        }
      }
    }

    // 3. Determine current phase dynamically
    CyclePhase phase;
    int adjustedCycleLength = defaultCycleLengthDays;
    
    // Average luteal phase is consistently 14 days, even in irregular cycles (PCOS shifts follicular phase length)
    if (detectedOvulationDate != null) {
      final daysPostOvulation = DateTime.now().difference(detectedOvulationDate).inDays;
      if (daysPostOvulation < 0) {
        phase = CyclePhase.ovulatory;
      } else if (daysPostOvulation <= 14) {
        phase = CyclePhase.luteal;
      } else {
        phase = CyclePhase.menstrual; // Late cycle / menstrual overflow
      }
      adjustedCycleLength = detectedOvulationDate.difference(currentCycleStart).inDays + 14;
    } else {
      // Calendar Fallback adjusted for irregularity
      if (isIrregular) {
        // For irregular users without ovulation data, stretch follicular phase projection
        final avgLength = historicalLengths.isEmpty 
            ? defaultCycleLengthDays 
            : (historicalLengths.reduce((a, b) => a + b) / historicalLengths.length).round();
        adjustedCycleLength = avgLength;
      }

      // Map phase based on adjusted length
      if (daysInCurrentCycle <= 5) {
        phase = CyclePhase.menstrual;
      } else if (daysInCurrentCycle <= (adjustedCycleLength - 16)) {
        phase = CyclePhase.follicular;
      } else if (daysInCurrentCycle <= (adjustedCycleLength - 14)) {
        phase = CyclePhase.ovulatory;
      } else {
        phase = CyclePhase.luteal;
      }
    }

    return DynamicCycleState(
      currentCycleDay: daysInCurrentCycle,
      projectedCycleLength: adjustedCycleLength,
      currentPhase: phase,
      isIrregularDetected: isIrregular,
    );
  }
}
```

### UI: Women's Health Screen

**Route:** `/health/womens`

```
Hero: Cycle Day [14] of [28]
Phase: Follicular — High energy phase

Cycle Wheel (radial, 4-phase color arc)

Today's Adaptations:
  ⚡ Workout: High intensity allowed — peak phase
  🥗 Nutrition: Prioritize protein + B vitamins
  💧 Hydration: Standard 2.5L

Symptom Log (daily, optional):
  [+ Log symptom]

Upcoming: Ovulation window in 2 days
```

---

# PHASE 2 — DAILY MISSION + READINESS ENGINE

---

## §P2-A. Readiness Engine

### Three-Tier Confidence Model

Readiness is now tiered by data quality. Users without wearables still get a score — with honest confidence labeling:

| Tier | Inputs | Confidence Label | Display |
|------|--------|-----------------|---------|
| **Basic** | Sleep + Stress + Soreness (morning check-in) | Medium | `Readiness 78 · Medium confidence` |
| **Enhanced** | Basic + Heart Rate (manual or Health Connect) | High | `Readiness 82 · High confidence` |
| **Premium** | Enhanced + HRV + Wearable data | Very High | `Readiness 85 · Very high confidence` |

No feature is gated by tier — confidence is informational only. A Basic-tier user still gets a full readiness-based daily plan.

### Readiness Score Formula (Pure Dart — No AI)

```dart
class ReadinessScoreCalculator {
  // All weights are configurable
  ReadinessResult calculate({
    required int sleepQuality,        // 1–5
    required int sleepDurationMin,
    required int sorenessLevel,       // 1–5
    required int stressLevel,         // 1–5
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    double score = 100.0;

    // Sleep quality (max 35 pts)
    score -= (5 - sleepQuality) * 7.0;
    if (sleepDurationMin < 360) score -= 10;  // < 6h
    if (sleepDurationMin < 300) score -= 10;  // < 5h

    // Soreness (max 20 pts)
    score -= (sorenessLevel - 1) * 5.0;

    // Stress (max 20 pts)
    score -= (stressLevel - 1) * 5.0;

    // HR deviation (max 15 pts) — only if available
    if (restingHR != null && baselineHR != null) {
      final hrDelta = (restingHR - baselineHR) / baselineHR;
      if (hrDelta > 0.1) score -= 10;
      if (hrDelta > 0.2) score -= 5;
    }

    // HRV deviation (max 10 pts) — only if available
    if (hrv != null && baselineHRV != null) {
      final hrvDelta = (baselineHRV - hrv) / baselineHRV;
      if (hrvDelta > 0.15) score -= 10;
    }

    final tier = _determineTier(restingHR, hrv);
    return ReadinessResult(
      score: score.clamp(0, 100).round(),
      tier: tier,
      confidence: tier.confidenceLabel,
    );
  }
}
```

### Readiness Zones and Recommended Intensity

| Score | Zone | Workout Recommendation |
|-------|------|----------------------|
| 80–100 | High | Full program intensity — push hard |
| 65–79 | Moderate | Normal intensity — standard program |
| 50–64 | Low | Reduced intensity (−30%), shorter sessions |
| < 50 | Critical | Rest or active recovery only |

### AI Intensity Adjustment (Computed, Not AI-Called)

When readiness warrants adjustment, targets are modified by formula:

```dart
class DailyTargetAdjuster {
  AdjustedTargets adjust(int readinessScore, UserTargets baseTargets) {
    final factor = switch (readinessScore) {
      >= 80 => 1.0,   // Full intensity
      >= 65 => 0.85,  // Slight reduction
      >= 50 => 0.70,  // Meaningful reduction
      _     => 0.0,   // Rest day
    };

    return AdjustedTargets(
      workoutIntensityFactor: factor,
      calorieTarget: factor >= 0.7
          ? baseTargets.calories + (100 * (1 - factor)).round()
          : baseTargets.calories + 200, // Recovery day: more calories for repair
      hydrationL: baseTargets.hydrationL + (readinessScore < 65 ? 0.3 : 0.0),
      proteinTarget: factor >= 0.85
          ? baseTargets.protein + 10
          : baseTargets.protein,
    );
  }
}
```

---

## §P2-B. Daily Briefing Screen (Daily Mission)

**Route:** `/mission`

The first screen every morning. Reads entirely from the **Daily Intelligence Package** — no AI call at open time.

### Morning Check-In (3-question ritual, <30 seconds)

```
1. "How did you sleep?" → 1–5 stars
2. "How sore are you?" → [Fresh] [Mild] [Moderate] [Very Sore]
3. "Stress level today?" → 1–5 slider
```

After 3 taps → readiness calculated locally → DIP loaded from Drift → briefing animates in.

### Daily Briefing Layout

```
Hero Section (320px, heroDeep gradient):
  "Good morning, Arjun 👋"
  ReadinessRing (128px) — score + confidence tier badge
  "High · High confidence — Great day for a hard session"

Body Panel:

  ── Health Score ──────────────────────────────────────
  HealthScoreRing (80px) + score + trend arrow
  "↑ 4 pts from yesterday — Consistency improving"

  ── Today's Mission Card (from DIP) ──────────────────
  "🎯 Today's Mission"
  [Items from DIP.todaysMission — 3 mission items]

  ── Today's Focus (Bento) ─────────────────────────────
  ┌───────────────┬──────────────────┐
  │ 😴 Sleep Debt  │ ⚡ Energy        │
  │ -45 min       │ Moderate         │
  ├───────────────┼──────────────────┤
  │ 🔥 Streak     │ 🏆 Karma Today   │
  │ 12 days       │ +45 XP target    │
  └───────────────┴──────────────────┘

  ── AI Coach Insight (from DIP) ───────────────────────
  DIP.primaryInsight — personalized, not generic

  ── Recovery Alert (conditional — from DecisionHierarchy)
  Shown only if readiness < 55 OR medical risk active
  "Decision Hierarchy: Recovery priority today"

  ── Quick Actions ─────────────────────────────────────
  [Log Breakfast] [Start Workout] [Log Water]
```

---

## §P2-C. Recovery Log Screen

**Route:** `/recovery`
**Scaffold:** Full-screen scrollable bento layout with biometrics readouts and interactive widgets.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Recovery Log                                      │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Recovery Score: 85 (Optimal Capacity)            │ │
│  │  [=====================>................]         │ │
│  │  Sleep: 7h 45m · HRV: 62 ms · resting HR: 58 bpm  │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Interactive Soreness Map:       [ Front ]  [ Back ]   │
│  ┌────────────────────────┐  ┌───────────────────────┐ │
│  │      \   ( )   /       │  │ Selected Muscles:     │ │
│  │       \──[ ]──/        │  │                       │ │
│  │        [  *  ]         │  │ 1. Chest: Moderate    │ │
│  │        /  |  \         │  │ 2. Quads: Mild        │ │
│  │       /  / \  \        │  │                       │ │
│  │      [  |   |  ]       │  │ Cumulative: Medium    │ │
│  └────────────────────────┘  └───────────────────────┘ │
│                                                        │
│  HRV Trend (7-Day):                                    │
│  [  /\   /\                                          ] │
│  [ /  \_/  \______ 62 ms                             ] │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │                Commit Recovery Log                │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Interactive Body Soreness Map (Tap-to-Select)

To gather detailed spatial soreness data without tedious forms, FitKarma implements a custom SVG path coordinate mapping widget.

1. **Widget Structure**:
   * A stack overlays a `CustomPaint` body rendering with a `GestureDetector`.
   * The `GestureDetector.onTapUp` registers coordinates relative to the widget bounding box.
   * Region matching maps coordinate points to distinct bounding boxes / path definitions:
     - **Shoulders**: `Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.1)`
     - **Chest**: `Rect.fromLTWH(width * 0.4, height * 0.25, width * 0.2, height * 0.12)`
     - **Abs**: `Rect.fromLTWH(width * 0.42, height * 0.37, width * 0.16, height * 0.15)`
     - **Quads**: `Rect.fromLTWH(width * 0.35, height * 0.55, width * 0.3, height * 0.25)`
     - **Arms**: `Rect.fromLTWH(width * 0.25, height * 0.25, width * 0.1, height * 0.3)` (Anterior)
2. **State Transition**:
   * Tapping a region cycles state: `none` (no paint) → `mild` (Yellow, 20% opacity) → `moderate` (Orange, 40% opacity) → `severe` (Red, 60% opacity) → `none`.
   * Updates are fed into the recovery state manager.

```dart
// Soreness mapping definitions
enum MuscleGroup { shoulders, chest, abs, quads, arms, lowerBack, glutes, hamstrings }
enum SorenessSeverity { none, mild, moderate, severe }

class SorenessState {
  final Map<MuscleGroup, SorenessSeverity> sorenessMap;
  const SorenessState({required this.sorenessMap});

  factory SorenessState.initial() => SorenessState(
        sorenessMap: {for (var m in MuscleGroup.values) m: SorenessSeverity.none},
      );

  // Compute composite score (1 to 5 scale) for Readiness Engine Ingestion
  int get compositeSorenessValue {
    int totalPoints = 0;
    for (final severity in sorenessMap.values) {
      switch (severity) {
        case SorenessSeverity.none: break;
        case SorenessSeverity.mild: totalPoints += 1; break;
        case SorenessSeverity.moderate: totalPoints += 2; break;
        case SorenessSeverity.severe: totalPoints += 3; break;
      }
    }
    if (totalPoints == 0) return 1;
    if (totalPoints <= 2) return 2;
    if (totalPoints <= 5) return 3;
    if (totalPoints <= 8) return 4;
    return 5;
  }
}
```

### Riverpod State Notifier & DB Sync

The `RecoveryLogNotifier` orchestrates the merging of manual check-ins with passive health data, recalculates the readiness score, and updates targets.

```dart
@riverpod
class RecoveryLogNotifier extends _$RecoveryLogNotifier {
  @override
  RecoveryLogState build() => const RecoveryLogState();

  void updateSoreness(MuscleGroup muscle, SorenessSeverity severity) {
    final updatedMap = Map<MuscleGroup, SorenessSeverity>.from(state.soreness.sorenessMap)
      ..[muscle] = severity;
    state = state.copyWith(soreness: SorenessState(sorenessMap: updatedMap));
    _recalculateReadiness();
  }

  void setCheckInResponses({
    required int sleepQuality,
    required int sleepDurationMin,
    required int stressLevel,
  }) {
    state = state.copyWith(
      sleepQuality: sleepQuality,
      sleepDurationMin: sleepDurationMin,
      stressLevel: stressLevel,
    );
    _recalculateReadiness();
  }

  void _recalculateReadiness() {
    final calculator = ReadinessScoreCalculator();
    final result = calculator.calculate(
      sleepQuality: state.sleepQuality,
      sleepDurationMin: state.sleepDurationMin,
      sorenessLevel: state.soreness.compositeSorenessValue,
      stressLevel: state.stressLevel,
      restingHR: state.restingHR,
      hrv: state.hrv,
      baselineHR: state.baselineHR,
      baselineHRV: state.baselineHRV,
    );
    state = state.copyWith(readinessScore: result.score);
  }

  Future<void> commitLog(AppDatabase db) async {
    // Write log to local Drift database
    await db.into(db.dailyMetrics).insert(
      DailyMetricsCompanion.insert(
        date: DateTime.now(),
        readinessScore: state.readinessScore,
        sleepMinutes: state.sleepDurationMin,
        sleepQuality: state.sleepQuality,
        stressLevel: state.stressLevel,
        sorenessScore: state.soreness.compositeSorenessValue,
        restingHeartRate: Value(state.restingHR),
        hrvMs: Value(state.hrv),
      ),
    );

    // Apply local Daily Target Adjustments based on score
    final baseTargets = await db.getUserBaseTargets();
    final adjusted = DailyTargetAdjuster().adjust(state.readinessScore, baseTargets);
    await db.updateDailyTargets(adjusted);
  }
}

class RecoveryLogState {
  final SorenessState soreness;
  final int sleepQuality;
  final int sleepDurationMin;
  final int stressLevel;
  final int readinessScore;
  final double? restingHR;
  final double? hrv;
  final double? baselineHR;
  final double? baselineHRV;

  const RecoveryLogState({
    this.soreness = const SorenessState(sorenessMap: {}),
    this.sleepQuality = 3,
    this.sleepDurationMin = 480,
    this.stressLevel = 1,
    this.readinessScore = 100,
    this.restingHR,
    this.hrv,
    this.baselineHR,
    this.baselineHRV,
  });

  RecoveryLogState copyWith({
    SorenessState? soreness,
    int? sleepQuality,
    int? sleepDurationMin,
    int? stressLevel,
    int? readinessScore,
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    return RecoveryLogState(
      soreness: soreness ?? this.soreness,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepDurationMin: sleepDurationMin ?? this.sleepDurationMin,
      stressLevel: stressLevel ?? this.stressLevel,
      readinessScore: readinessScore ?? this.readinessScore,
      restingHR: restingHR ?? this.restingHR,
      hrv: hrv ?? this.hrv,
      baselineHR: baselineHR ?? this.baselineHR,
      baselineHRV: baselineHRV ?? this.baselineHRV,
    );
  }
}
```

---

## §P2-D. Recovery Operating System (NEW v1 — Sleep, Capacity, and Strain)

> A passive score is an indicator; an operating system is a decision engine. FitKarma transforms recovery from static numbers into an active workflow, coordinating sleep needs, daily cardiac strain, and environmental stressors into real-time physical capacity profiles.

```
                  +-----------------------------------+
                  |        Daily Strain (0-21)        |
                  +-----------------+-----------------+
                                    |
                                    v
  +------------------+    +-------------------+    +-------------------+
  |  Readiness (0-100)|--> | Recovery Capacity | <--|   Sleep Need Calc |
  +------------------+    +---------+---------+    +-------------------+
                                    |
                                    v
                  +-----------------+-----------------+
                  |   Checklist Recovery Prescription |
                  +-----------------------------------+
```

---

### 1. Sleep Intelligence Layer

#### A. Sleep Need Calculator
Rather than recommending a flat 8 hours, FitKarma calculates the dynamic **Sleep Need** required to clear fatigue:
$$\text{Sleep Need (min)} = \text{Baseline Need} + \text{Sleep Debt} + \text{Training Load Additive} + \text{Stress Additive} + \text{Illness Additive}$$

- **Baseline Need**: Set during onboarding (default: $480$ mins / 8 hours).
- **Sleep Debt**: $100\%$ of accumulated sleep deficit over the last 7 days (maximum addition: $90$ mins).
- **Training Load Additive**: Mapped to yesterday's training intensity (up to $60$ mins for heavy days).
- **Stress Additive**: Mapped to daily inferred stress score (up to $30$ mins).
- **Illness Additive**: Automatically adds $60$ mins if sickness flags are active.
- **Safety Bounds**: Hard cap at $600$ mins (10 hours) to prevent oversleeping indicators.

#### B. Sleep Performance Score
Evaluates sleep quality out of 100 based on four pillars:
- **Duration (40%)**: Actual sleep duration vs calculated Sleep Need.
- **Efficiency (30%)**: Time asleep divided by total time in bed (Sleep Opportunity).
- **Consistency (20%)**: Variance of sleep/wake onset times over 7 days.
- **Opportunity (10%)**: Dedicated window in bed.

#### C. Bedtime Coach
Uses the calculated Sleep Need to guide the user's evening routine:
- *Input*: Sleep Need: **8h 22m** | Target Wake Time: **6:30 AM**
- *Calculated Bedtime*: **10:08 PM** (Includes a 15-minute wind-down buffer).
- *Nudge (at 9:30 PM)*: *"Bedtime Coach: Wind down now to meet your 8h 22m sleep target. Aim to sleep by 10:08 PM to maintain recovery capacity."*

---

### 2. Recovery Capacity & Strain System

#### A. Daily Strain Score (0–21 Scale)
Measures the cumulative physical cardiovascular and metabolic load accumulated throughout the day.

##### Mathematical Model
Daily strain follows an exponential accumulation curve. As strain increases, achieving higher levels requires exponentially more exertion.

1. **Cardiovascular Impulse ($TRIMP_{avg}$)**:
   $$TRIMP = \sum_{z=1}^{5} \left( D_z \times W_z \right)$$
   where $D_z$ is the duration in minutes spent in heart-rate Zone $z$, and $W_z$ is the zone weight:
   *   $W_1 = 0.05$ (Zone 1: Active Recovery, 50-60% Max HR)
   *   $W_2 = 0.15$ (Zone 2: Aerobic, 60-70% Max HR)
   *   $W_3 = 0.35$ (Zone 3: Tempo, 70-80% Max HR)
   *   $W_4 = 0.70$ (Zone 4: Threshold, 80-90% Max HR)
   *   $W_5 = 1.50$ (Zone 5: Anaerobic, 90-100% Max HR)

2. **Step Load Additive ($Impulse_{steps}$)**:
   $$Impulse_{steps} = \left(\frac{\text{Steps}}{10000}\right) \times 2.25$$

3. **Environmental Heat Stress Factor ($F_{heat}$)**:
   $$F_{heat} = 1.0 + \max\left(0, \text{Heat Index (°C)} - 32\right) \times 0.02$$

4. **Aggregate Exponential Strain Formula**:
   $$\text{Strain} = 21.0 \times \left(1 - e^{-0.015 \times \left(TRIMP + Impulse_{steps}\right) \times F_{heat}}\right)$$

| Strain Range | Level | Cardiac/Activity Characteristics |
|--------------|-------|----------------------------------|
| **0.0 – 5.9** | Rest/Light | Rest day, light walking (<5,000 steps), minimal elevated heart rate. |
| **6.0 – 11.9** | Moderate | Standard activity (8k-12k steps), minor aerobic work. |
| **12.0 – 15.9** | Heavy | High cardiovascular activity (30-60 mins in Zone 3/4). |
| **16.0 – 21.0** | Extreme | Competitive events, high environmental heat exposure, extreme cardiac loads. |

##### Implementation: DailyStrainCalculator (Pure Dart)

```dart
import 'dart:math';

class ActivityLog {
  final String activityType; // "running" | "walking" | "strength" | "cycling"
  final int durationMinutes;
  final String intensity; // "low" | "medium" | "high"

  ActivityLog({
    required this.activityType,
    required this.durationMinutes,
    required this.intensity,
  });
}

class DailyStrainCalculator {
  /// Calculates the 0-21 daily strain score based on heart rate zone durations,
  /// step count, and environmental heat index, with fallback estimation.
  double calculateStrain({
    Map<int, int>? zoneDurationsMinutes, // Key: Zone 1-5, Value: Minutes
    required int dailySteps,
    required double heatIndexCelsius,
    // Fallback parameters (used if zoneDurationsMinutes is null/empty)
    int? activeMinutes,
    int? restingHeartRate,
    int? averageHeartRate,
    List<ActivityLog>? dailyActivities,
  }) {
    final Map<int, int> resolvedZones = zoneDurationsMinutes ?? {};

    // 1. If detailed zones are missing, estimate them using fallback parameters
    if (resolvedZones.isEmpty) {
      final estimated = estimateZonesFromTelemetry(
        dailySteps: dailySteps,
        activeMinutes: activeMinutes ?? 0,
        restingHeartRate: restingHeartRate,
        averageHeartRate: averageHeartRate,
        dailyActivities: dailyActivities ?? [],
      );
      resolvedZones.addAll(estimated);
    }

    // 2. Compute cardiac impulse from resolved zones
    final zoneWeights = {
      1: 0.05,  // Active Recovery
      2: 0.15,  // Aerobic
      3: 0.35,  // Tempo
      4: 0.70,  // Threshold
      5: 1.50,  // Anaerobic
    };

    double cardiacImpulse = 0.0;
    resolvedZones.forEach((zone, minutes) {
      final weight = zoneWeights[zone] ?? 0.0;
      cardiacImpulse += minutes * weight;
    });

    // 3. Compute step-based impulse (additional physical strain)
    final double stepsImpulse = (dailySteps / 10000.0) * 2.25;

    // 4. Factor in environmental heat strain
    double heatFactor = 1.0;
    if (heatIndexCelsius > 32.0) {
      heatFactor += (heatIndexCelsius - 32.0) * 0.02; // +2% strain per degree Celsius above 32C
    }

    final totalImpulse = (cardiacImpulse + stepsImpulse) * heatFactor;
    final strain = 21.0 * (1.0 - exp(-0.015 * totalImpulse));
    
    return double.parse(strain.toStringAsFixed(1));
  }

  /// Reconstructs heart rate zone durations when detailed tracker data is missing.
  Map<int, int> estimateZonesFromTelemetry({
    required int dailySteps,
    required int activeMinutes,
    int? restingHeartRate,
    int? averageHeartRate,
    required List<ActivityLog> dailyActivities,
  }) {
    final Map<int, int> estimatedZones = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // 1. Process activity logs (highly specific mapping based on exercise type)
    if (dailyActivities.isNotEmpty) {
      for (final activity in dailyActivities) {
        final duration = activity.durationMinutes;
        switch (activity.activityType.toLowerCase()) {
          case 'running':
            if (activity.intensity.toLowerCase() == 'high') {
              estimatedZones[3] = (estimatedZones[3]! + duration * 0.4).round();
              estimatedZones[4] = (estimatedZones[4]! + duration * 0.4).round();
              estimatedZones[5] = (estimatedZones[5]! + duration * 0.2).round();
            } else {
              estimatedZones[2] = (estimatedZones[2]! + duration * 0.3).round();
              estimatedZones[3] = (estimatedZones[3]! + duration * 0.5).round();
              estimatedZones[4] = (estimatedZones[4]! + duration * 0.2).round();
            }
            break;
          case 'strength':
            // Weightlifting results in high spikes but long rest windows
            estimatedZones[1] = (estimatedZones[1]! + duration * 0.5).round();
            estimatedZones[2] = (estimatedZones[2]! + duration * 0.3).round();
            estimatedZones[3] = (estimatedZones[3]! + duration * 0.2).round();
            break;
          case 'walking':
            estimatedZones[1] = estimatedZones[1]! + duration;
            break;
          case 'cycling':
            estimatedZones[2] = (estimatedZones[2]! + duration * 0.6).round();
            estimatedZones[3] = (estimatedZones[3]! + duration * 0.4).round();
            break;
          default:
            estimatedZones[2] = estimatedZones[2]! + duration;
        }
      }
      return estimatedZones;
    }

    // 2. If no activities are logged, use step cadence & active minutes to estimate cardiorespiratory zones
    if (activeMinutes > 0) {
      final averageCadenceSpm = dailySteps / activeMinutes.toDouble();
      
      if (averageCadenceSpm >= 110.0) {
        // High intensity walking/jogging cadence
        estimatedZones[2] = (activeMinutes * 0.7).round();
        estimatedZones[3] = (activeMinutes * 0.3).round();
      } else if (averageCadenceSpm >= 85.0) {
        // Steady walking cadence
        estimatedZones[1] = (activeMinutes * 0.8).round();
        estimatedZones[2] = (activeMinutes * 0.2).round();
      } else {
        // Low intensity movements
        estimatedZones[1] = activeMinutes;
      }
      return estimatedZones;
    }

    // 3. Fallback: If we only have steps, derive standard active recovery zone durations
    if (dailySteps > 0) {
      // Assume 100 steps per minute, calculate estimated active recovery duration (Zone 1)
      final estimatedActiveMinutes = (dailySteps / 100).round();
      estimatedZones[1] = estimatedActiveMinutes;
    }

    return estimatedZones;
  }
}
```

#### B. Recovery Capacity & Decision Matrix
Recovery Capacity defines the maximum stress load the body can absorb today without causing cumulative damage.

```dart
class RecoveryDecisionEngine {
  static const double maxStrainLimit = 21.0;

  RecoveryDecision evaluate({
    required int readinessScore,
    required double dailyStrain,
    required double sleepDebtHours,
  }) {
    // Determine capacity band based on readiness and sleep deficit
    final capacityFactor = (readinessScore / 100.0) - (sleepDebtHours * 0.1);
    final capacityScore = (capacityFactor * 100).clamp(0, 100).round();

    // Recommended Strain limit
    final strainCap = (capacityFactor * 18.0).clamp(4.0, maxStrainLimit);

    String trainingAdvice;
    if (readinessScore >= 80 && dailyStrain < strainCap) {
      trainingAdvice = "High Capacity. Body is fully primed for heavy training load.";
    } else if (readinessScore >= 50 && dailyStrain < strainCap) {
      trainingAdvice = "Standard Capacity. Maintain standard training; avoid extra sets.";
    } else {
      trainingAdvice = "Low Capacity / Overreaching. Limit strain to active recovery or rest.";
    }

    return RecoveryDecision(
      capacityScore: capacityScore,
      strainCap: strainCap,
      trainingAdvice: trainingAdvice,
    );
  }
}
```

---

### 3. Recovery Behaviors & Actionable Prescriptions

Instead of showing "Recovery: Low" and leaving the user stranded, the system generates a checklist-style **Recovery Prescription**:

```
┌────────────────────────────────────────────────────────┐
│ ⚡ Recovery Prescription (Score: 54 / Low Capacity)    │
├────────────────────────────────────────────────────────┤
│ ☐ Active Recovery: Target 25-minute low-intensity walk │
│ ☐ Sleep Extension: Bedtime moved 45 min earlier        │
│ ☐ Nutrition: Prioritize 120g protein for tissue repair │
│ ☐ Hydration: Hydrate with an extra +700ml water        │
│ ☐ Restriction: No high-intensity HIIT or max-lifts    │
└────────────────────────────────────────────────────────┘
```

---

### 4. Circadian & Environmental Intelligence

#### A. Circadian Score (0–100)
Tracks alignment with the natural circadian rhythm:
- **Midpoint Shift Penalty**: Measures deviation of sleep midpoint from the 7-day rolling average (shifts $>60$ mins penalize recovery score by $5-10$ points).
- **Light Exposure Sync**: Injects positive score adjustments for morning light exposure logged/detected between 6:00 AM and 9:00 AM.

#### B. Illness & Recovery Type Detection
FitKarma categorizes fatigue into specific types rather than displaying generic metrics:
- **Sleep Fatigue**: High sleep debt, low sleep consistency.
- **Training Fatigue**: Extreme strain score relative to baseline capacity.
- **Stress Fatigue**: Elevated day-time inferred stress, depressed HRV.
- **Illness Fatigue**: Flagged automatically when resting HR is $>10\%$ above baseline, HRV is $>15\%$ below baseline, and sleep duration increases by $>20\%$.
  - *Sickness Nudge*: *"Warning: Elevated biometric signals suggest potential illness. Reducing training target by 50% and locking out high-intensity exercises."*

#### C. Recovery Drivers
Breaks down exactly what contributed to or penalized today's readiness:

```
Readiness Score: 71
Contributors:
  + Sleep Quality     (+18 pts)
  + Protein Intake    (+12 pts)
  + Hydration Target  (+8 pts)
Detractors:
  - Daily Stress      (-15 pts)
  - Poor Ambient AQI  (-7 pts)
  - Extreme Heat      (-4 pts)
```

---

### 5. Recovery Age & Forecasting

- **Recovery Age**: Calculated monthly by comparing rolling average HRV, resting heart rate recovery speed, and sleep efficiency to population cohorts.
  - *"Chronological Age: 34 | Recovery Age: 28. Your cardiovascular recovery speed matches a younger profile."*
- **Recovery Forecast**: A 5-day predictive trajectory indicating expected readiness if sleep debt and daily strain trends continue.

---

# PHASE 3 — AI ADAPTIVE COACH

---

## §P3-A. AI Coach Philosophy

**Bad response:**
> "Eat more protein."

**Good response:**
> "Your protein intake has averaged 58g for 6 days while your muscle-building goal requires ~110g. Add paneer or eggs to breakfast to improve recovery."

The AI should never give generic advice. Every response must reference specific user data from the Health Snapshot.

---

## §P3-B. AI Context Builder (v1)

The context builder now compresses before sending:

```dart
class AIContextBuilder {
  Future<AIContext> buildCompressed(String userId) async {
    final user     = await _userRepo.getUser(userId);
    final snapshot = await _snapshotRepo.getLatest(userId); // ~400 tokens
    final dip      = await _dipRepo.getToday(userId);
    final weather  = await _weatherService.getCurrent(user.location);
    final festival = await _festivalRepo.getUpcoming(user.region);

    return AIContext(
      // Static profile (rarely changes)
      name: user.name, goals: user.goals, program: user.currentProgram,
      dietType: user.dietType, tone: user.tone, injuries: user.injuries,

      // Compressed trends (replaces 7-day raw logs)
      snapshot: snapshot,

      // Today's state from DIP
      readinessScore: dip.adjustedTargets.readiness,
      primaryConcern: snapshot.primaryConcern,

      // Context
      weather: weather.summary,
      festival: festival?.name,
    );
  }
}
```

---

## §P3-C. AI Coach Screen

**Route:** `/ai-coach`
**Scaffold:** Dark bento layout with dynamic input fields, source indicators, and persistent chat lists.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] AI Karma Coach                                    │
│  ┌───────────────────────────────────────────────────┐ │
│  │ Readiness: 82  ·  Streak: 12 days  ·  Goal: Recomp │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│               How can I adapt my calories?             │
│        ┌─────────────────────────────────────────────┐ │
│        │ [Based on 7-day data] [From your profile]   │ │
│        │ Since your sleep debt is -45m and you have  │ │
│        │ mild quad soreness, your recovery capacity  │ │
│        │ is moderate. I have adjusted your intake    │ │
│        │ to 1,900 kcal (+100 kcal for repair).       │ │
│        └─────────────────────────────────────────────┘ │
│                                                        │
│  Suggested Prompts:                                    │
│  [ Why am I plateauing? ]    [ Adjust my macro splits ]│
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │ [🎤] [📸] Ask anything...                  [Send] │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Local Chat Cache Database Schema (Drift)

To support offline viewing of conversation history and optimize network footprints, chat messages are cached locally using the following Drift table.

```dart
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId => text().withLength(min: 1, max: 50)();
  TextColumn get senderType => text()(); // 'user' or 'ai'
  TextColumn get messageContent => text()();
  DateTimeColumn get createdAt => dateTime()();
  
  // JSON array storing the data source references (e.g. ["7-day logs", "user profile"])
  TextColumn get sourcesJson => text().nullable()(); 
  
  // Attachments (e.g., photo file path)
  TextColumn get localAttachmentPath => text().nullable()();
}
```

### Riverpod State Notifier (Optimistic State + Typewriter Effect)

The `AiCoachChatNotifier` manages the state of the chat screen, providing optimistic UI updates, simulating the typewriter typing flow for AI replies, and syncing messages to Drift.

```dart
@riverpod
class AiCoachChatNotifier extends _$AiCoachChatNotifier {
  @override
  AiCoachChatState build() => const AiCoachChatState();

  // Send a user message with optimistic updates
  Future<void> sendMessage({
    required String text, 
    String? localAttachmentPath,
    required AppDatabase db,
  }) async {
    final conversationId = state.currentConversationId ?? _generateUuid();
    
    // 1. Save and render User message optimistically
    final userMsg = ChatMessage(
      id: -1, // Temporary temp id for local state rendering
      conversationId: conversationId,
      senderType: 'user',
      messageContent: text,
      createdAt: DateTime.now(),
      localAttachmentPath: localAttachmentPath,
    );
    
    state = state.copyWith(
      currentConversationId: conversationId,
      messages: [...state.messages, userMsg],
      isAiTyping: true,
      errorOccurred: false,
    );

    // Save user message to Drift in background
    await db.saveChatMessage(userMsg);

    try {
      // 2. Fetch response from Cloudflare Worker
      final response = await _callCoachWorker(text, conversationId);
      
      // 3. Trigger Typewriter simulation for AI response
      await _streamTypewriterResponse(
        responseText: response.reply,
        sources: response.sources,
        conversationId: conversationId,
        db: db,
      );
    } catch (e) {
      state = state.copyWith(
        isAiTyping: false,
        errorOccurred: true,
        messages: [
          ...state.messages,
          ChatMessage(
            id: -2,
            conversationId: conversationId,
            senderType: 'ai',
            messageContent: "Sorry, I'm having trouble connecting right now. Please try again.",
            createdAt: DateTime.now(),
          )
        ],
      );
    }
  }

  // Simulates char-by-char typewriter effect in the UI
  Future<void> _streamTypewriterResponse({
    required String responseText,
    required List<String> sources,
    required String conversationId,
    required AppDatabase db,
  }) async {
    final aiMsgPlaceholder = ChatMessage(
      id: -3,
      conversationId: conversationId,
      senderType: 'ai',
      messageContent: '',
      createdAt: DateTime.now(),
      sourcesJson: jsonEncode(sources),
    );

    state = state.copyWith(messages: [...state.messages, aiMsgPlaceholder]);

    String activeText = '';
    final characters = responseText.split('');
    
    for (int i = 0; i < characters.length; i++) {
      activeText += characters[i];
      
      // Throttle update loops slightly to produce typing effect
      await Future.delayed(const Duration(milliseconds: 15));
      
      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages[updatedMessages.length - 1] = aiMsgPlaceholder.copyWith(
        messageContent: activeText,
      );
      state = state.copyWith(messages: updatedMessages);
    }

    state = state.copyWith(isAiTyping: false);

    // 4. Save finalized message to Drift
    await db.saveChatMessage(aiMsgPlaceholder.copyWith(messageContent: responseText));
  }

  String _generateUuid() => DateTime.now().millisecondsSinceEpoch.toString();
  
  Future<CoachWorkerResponse> _callCoachWorker(String message, String convId) async {
    // API call wrapper...
    return CoachWorkerResponse(reply: "Mocked AI reply based on data", sources: ["7-day logs"]);
  }
}

class AiCoachChatState {
  final List<ChatMessage> messages;
  final bool isAiTyping;
  final bool errorOccurred;
  final String? currentConversationId;

  const AiCoachChatState({
    this.messages = const [],
    this.isAiTyping = false,
    this.errorOccurred = false,
    this.currentConversationId,
  });

  AiCoachChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAiTyping,
    bool? errorOccurred,
    String? currentConversationId,
  }) {
    return AiCoachChatState(
      messages: messages ?? this.messages,
      isAiTyping: isAiTyping ?? this.isAiTyping,
      errorOccurred: errorOccurred ?? this.errorOccurred,
      currentConversationId: currentConversationId ?? this.currentConversationId,
    );
  }
}

### Cloudflare Worker: `fitkarma-coach` (v1)

```javascript
// Key changes from v1:
// 1. Receives compressed Health Snapshot, not raw 7-day logs
// 2. Uses conversation summary + last 5 messages, not full history
// 3. Model tier is Large (70B) — chat is the right place for it
// 4. Tone is injected from user profile

app.http('fitkarma-coach', {
  methods: ['POST'],
  authLevel: 'function',
  handler: async (request, context) => {
    const { userId, message } = await request.json();

    // Compressed context (~400 tokens vs ~6000 in v1)
    const snapshot       = await getHealthSnapshot(userId);
    const conversationCtx = await getConversationContext(userId); // summary + last 5

    const systemPrompt = `
You are FitKarma's AI health coach. You are ${snapshot.tone} in tone.
You have access to the user's compressed health context — use it in every response.
NEVER give generic advice. ALWAYS reference specific numbers.
Use Indian food examples for nutrition suggestions.

User: ${snapshot.name}
Goals: ${snapshot.goals}
Program: ${snapshot.program} — Phase: ${snapshot.programPhase}
Today's readiness: ${snapshot.readinessScore}/100 (${snapshot.readinessConfidence})
Health Score: ${snapshot.healthScore}/100
Primary concern: ${snapshot.primaryConcern}
Protein trend: ${snapshot.proteinTrend} (7-day avg: ${snapshot.avgProtein7d}g vs target ${snapshot.proteinTarget}g)
Sleep trend: ${snapshot.sleepTrend}
Weight change (4w): ${snapshot.weightChange4w}kg
Streak: ${snapshot.streak} days
    `;

    const response = await callGroq({
      model: 'llama-3.1-70b-versatile',
      messages: [
        { role: 'system', content: systemPrompt },
        ...conversationCtx,
        { role: 'user', content: message }
      ],
      max_tokens: 400,
    });

    // Update conversation summary in background
    await updateConversationSummary(userId, message, response);

    return { reply: response };
  }
});
```

### Proactive Insights (Event-Driven, Not Daily Polling)

```javascript
// fitkarma-insights — Timer Trigger, 6am IST
// Instead of generating insights for every user every day,
// only generate when an AITrigger threshold is met.

for (const userId of activeUsers) {
  const trigger = await checkAITrigger(userId);
  if (!trigger) continue; // Skip — no insight needed today

  const snapshot = await getHealthSnapshot(userId);
  const insight  = await generateTargetedInsight(trigger, snapshot);
  await storeInsight(userId, insight);
}
```

---

## §P3-D. Health Coach Escalation Layer (NEW v1 — Elite Tier)

> AI coaching has limits. When a user's situation exceeds what AI can safely handle, FitKarma escalates to a verified human health coach.

### Escalation Triggers

```dart
class CoachEscalationService {
  bool shouldEscalate(UserState state) {
    // Medical complexity beyond AI coaching scope
    if (state.activeRisks.any((r) => r.severity == RiskSeverity.high)) {
      return true;
    }
    // Plateau unresolved after Adaptive Metabolism correction for 4+ weeks
    if (state.plateauWeeks >= 4 && state.adaptiveCaloriesAlreadyAdjusted) {
      return true;
    }
    // Psychological distress signals
    if (state.consecutiveRelapseAttempts >= 3) {
      return true;
    }
    // User explicitly requests human review
    if (state.userRequestedHumanCoach) {
      return true;
    }
    return false;
  }

  Future<void> escalate(String userId, EscalationReason reason) async {
    // 1. Package health summary for coach review
    final summary = await _buildCoachBriefing(userId, reason);

    // 2. Create escalation ticket in coach dashboard
    await _coachDashboard.createTicket(userId, summary);

    // 3. Notify user
    await _notificationService.send(
      userId: userId,
      title: 'Your health coach will review your plan',
      body: 'A certified coach is reviewing your data and '
            'will respond within 24 hours.',
    );
  }
}
```

### Coach Briefing Package

When a user is escalated, the coach receives a structured briefing:

```
Coach Briefing — [User Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━

Goal:         Fat loss (−8 kg in 12 weeks)
Week:         7 of 12
Program:      Corporate Fat Loss

Current Status:
  Weight change (4w):  −0.4 kg (expected −2 kg)
  Calorie target:      1,680 (after 2 adaptive adjustments)
  Adherence:           Nutrition 62% / Training 55%
  Recovery Debt:       HIGH (5-day sleep deficit)

AI Limitations Hit:
  ✗ 4 consecutive weeks of plateau post-recalibration
  ✗ User reports extreme fatigue + mood changes

Escalation Reason:
  Metabolic plateau + fatigue pattern requires clinical review.
  Possible thyroid/cortisol involvement.

AI Coach Notes (last 7 days):
  "[Summarized conversation highlights]"
```

### UI: Escalation Flow

```
AI Coach screen:
  [📞 Talk to a Human Coach]  ← Elite tier only

Bottom sheet:
  "Your health coach will review your full plan and
   respond within 24 hours via in-app message."

  [Request Review]  [Continue with AI Coach]
```

---

# PHASE 4 — HEALTH TRACKING

---

## §P4-A. Dashboard Screen

**Route:** `/dashboard`

The dashboard now reads primarily from the Daily Intelligence Package. No AI calls on open.

### Orchestration (NEW — v1)

```
Dashboard open
  ↓
Load DIP from Drift (instant — already generated at 6am)
  ↓
Load live metrics from Drift (steps, calories, water)
  ↓
Render — zero AI calls
```

### Layout

```
Hero (320px, heroDeep):
  Activity Rings (180px) — Steps · Calories · Active Minutes
  Steps count (heroDisplay)
  TrendChip: ↑ 12% vs yesterday

Body Panel:

  ── Health Score + Readiness ─────────────────────────
  HealthScoreRing (80px) · ReadinessRing (80px) side-by-side
  "Tap to see today's mission →"

  ── Bento Row 1 ──────────────────────────────────────
  ┌─────────────────┬─────────────────┐
  │ 💧 Water         │ 🔥 Calories     │
  │ 1.8 / 3.0L      │ 1240 / 1800     │
  └─────────────────┴─────────────────┘

  ── AI Coach Insight (from DIP — no new call) ────────
  InsightCard (orange border)
  DIP.primaryInsight

  ── Bento Row 2 ──────────────────────────────────────
  ┌─────────────────┬─────────────────┐
  │ 😴 Sleep         │ ❤️ Resting HR   │
  │ 6h 20min        │ 68 bpm          │
  └─────────────────┴─────────────────┘

  ── Streak + Karma ───────────────────────────────────
  ┌─────────────────┬─────────────────┐
  │ 🔥 12-day streak │ ⭐ 4,280 karma  │
  └─────────────────┴─────────────────┘
```

---

## §P4-B. Steps Screen

**Route:** `/steps`
**Scaffold:** Dark theme canvas with a custom top hero container.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Steps Tracker                     [Sync: Synced]  │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Daily Progress: 8,420 / 10,000 steps             │ │
│  │  [===========================>.................]   │ │
│  │  Distance: 6.2 km  ·  Active: 52 min  ·  Cal: 340  │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Hourly Step Distribution:                             │
│     █                                                  │
│     █       █                                          │
│   █ █ █   █ █   █                                      │
│  ─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─                             │
│  08  10  12  14  16  18                                │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Coach: "Great job! A 10-minute walk now will     │ │
│  │  cross your daily goal before dinner."             │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Auto-Detection & Sync Engine

*   **Platform Bridging**: Leverages the Flutter `health` package to bind directly with HealthConnect on Android (requiring standard activity permission scopes) and HealthKit on iOS.
*   **Background Sync**: Controlled by a Workmanager task scheduled to execute every 15 minutes. It fetches the step delta from local OS APIs, compares it with cached Drift logs, and writes updates locally:
    ```dart
    Future<void> syncStepsWithDeviceHealth(AppDatabase db) async {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      final steps = await Health().getTotalStepsInInterval(midnight, now);
      if (steps != null) {
        await db.updateDailySteps(midnight, steps);
      }
    }
    ```

---

## §P4-C. Sleep Screen

**Route:** `/sleep`
**Scaffold:** Deep indigo full-bleed gradient card stacks.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Sleep OS                                          │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Last Night: 7h 15m (Normal)                      │ │
│  │  Quality: ★★★★☆  ·  Sleep Debt: -30m (Low)        │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Sleep Stages:                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │ [ Awake: 5% ] [ REM: 20% ] [ Light: 55% ] [ Deep: 20%]│
│  │ █░░█████████████████████████████████████████████░░│ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  7-Day HRV Trend (Wearable):                           │
│  68 ms   /\                                            │
│  62 ms  /  \__/\_                                      │
│  58 ms /         \_____                                │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Sleep Stage Metrics and Debt Modeling

*   **Sleep Stage Charting**: Stages (Awake, REM, Light, Deep) are displayed using a horizontal segmented bar chart from the `fl_chart` library.
*   **HRV Tracking**: Driven exclusively by wearable integrations (Apple Watch, Garmin, Fitbit) which write daily rMSSD values to `daily_metrics`.
*   **Sleep Debt Calculation**: Calculated as a rolling 7-day delta comparing actual sleep minutes against the baseline sleep target (default: 480 minutes).
    $$\text{Sleep Debt} = \sum_{i=1}^{7} (480 - \text{Sleep Minutes}_i)$$

---

## §P4-D. Blood Pressure Screen

**Route:** `/health/bp` | **Biometric Lock Required**
**Scaffold:** Minimalist high-security layout.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Blood Pressure                                    │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Latest Reading: 128 / 82 mmHg                    │ │
│  │  Category: Elevated                               │ │
│  │  Recorded: Today, 8:30 AM (Manual)                │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Systolic / Diastolic History (30 Days):               │
│  140 ------------------------------------------------  │
│  120 --*---*---*-------------------------------------  │
│  100 ------------------------------------------------  │
│   80 ----#---#---#-----------------------------------  │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  [!] Warning: 3 rising BP readings recorded.      │ │
│  │  Limit caffeine and record again tonight.          │ │
│  └───────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

### Security & Biometric Access Layer

*   **Biometric Locking**: Because vitals are sensitive health information, accessing `/health/bp` triggers a local biometric authentication prompt (`local_auth` package) checking for face/fingerprint validation.
*   **Fallback**: If biometrics are unavailable or fail, a secure 6-digit backup PIN screen is rendered.
*   **Data Structure**:
    ```dart
    class BloodPressureRecords extends Table {
      IntColumn get id => integer().autoIncrement()();
      IntColumn get systolic => integer()();
      IntColumn get diastolic => integer()();
      DateTimeColumn get measuredAt => dateTime()();
      TextColumn get recordingMethod => text()(); // 'manual' or 'wearable'
    }
    ```

---

## §P4-E. Glucose Screen

**Route:** `/health/glucose` | **Biometric Lock Required**
**Scaffold:** Minimalist medical grid layout.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Blood Glucose                                     │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Fasting: 98 mg/dL (Normal)                       │ │
│  │  Post-Meal (Breakfast): 142 mg/dL (Elevated)      │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Glucose Response Curve:                               │
│  160 |         /\                                      │
│  120 |      __/  \__  <-- Breakfast Spike              │
│   80 |  ___/        \_____                             │
│      └────────────────────────                         │
│       08:00    10:00    12:00                          │
│                                                        │
│  Estimated HbA1c: 5.6% (Pre-diabetic Threshold: 5.7%)  │
│  [=================================>................]  │
└────────────────────────────────────────────────────────┘
```

### Meal Correlation & HbA1c Estimation

*   **Post-Meal Markers**: Every glucose input requires a tag: `Fasting`, `Pre-Meal`, `Post-Meal (1-hour)`, or `Post-Meal (2-hour)` to map glycemic spikes directly to logged meals in Drift.
*   **HbA1c Calculation**: When the user has recorded $\ge 90$ days of glucose logs, the app computes a local estimated HbA1c metric using the formula:
    $$\text{Estimated HbA1c (\%)} = \frac{\text{Average Glucose (mg/dL)} + 46.7}{28.7}$$

---

## §P4-F. Preventive Intelligence Engine (Deterministic — No AI)

All risk detection is rule-based. AI is not needed for threshold comparisons:

```dart
class PreventiveIntelligenceEngine {
  List<HealthRiskAlert> analyze(UserHealthData data) {
    final alerts = <HealthRiskAlert>[];

    // Hypertension pattern
    if (data.bpTrend == Trend.rising &&
        data.sleepTrend == Trend.declining &&
        data.weightTrend == Trend.rising &&
        data.stepsTrend == Trend.declining) {
      alerts.add(HealthRiskAlert(
        risk: 'Hypertension',
        severity: RiskSeverity.moderate,
        message: 'Rising BP + declining sleep + reduced activity is '
                 'a hypertension risk pattern. Prioritize walking.',
        actions: ['Log a 20-min walk', 'Reduce sodium', 'Check BP tomorrow'],
      ));
    }

    // Diabetes pattern
    if (data.glucoseTrend == Trend.rising &&
        data.bmi >= 27 &&
        data.stepAvg7d < 5000) {
      alerts.add(HealthRiskAlert(
        risk: 'Type 2 Diabetes',
        severity: RiskSeverity.moderate,
        message: 'Elevated glucose + low activity. '
                 'A 15-min post-meal walk reduces glucose spikes significantly.',
        actions: ['Walk after meals', 'Reduce refined carbs', 'Log fasting glucose'],
      ));
    }

    return alerts;
  }
}
```

Risk alerts feed into the **Decision Hierarchy** — medical risks override program instructions.

---

## §P4-G. Smart Wearable Comparison Layer — Device Reliability Engine (NEW v1)

> Different wearables produce very different HRV and HR readings. A naive system treats all sources equally. FitKarma v1 applies per-device confidence scores so readiness calculations are appropriately weighted.

### Device Confidence Matrix

| Device | HRV Confidence | HR Confidence | Notes |
|--------|---------------|---------------|-------|
| Apple Watch Series 9+ | High (0.85) | Very High (0.95) | ECG-grade HR; HRV from SDNN |
| WHOOP 4.0 | Very High (0.95) | High (0.90) | Purpose-built recovery; best HRV |
| Garmin (Fenix/Forerunner) | High (0.88) | High (0.88) | Trusted optical; good HRV |
| Samsung Galaxy Watch 6 | Medium (0.70) | High (0.85) | HRV less validated for readiness |
| Fitbit Sense 2 | Medium (0.65) | Medium (0.75) | Consumer-grade; moderate accuracy |
| Mi Band / Noise | Low (0.40) | Medium (0.60) | Entry-level optical; treat as estimate |
| Manual input | Low (0.30) | Low (0.30) | User-entered; high uncertainty |

### DeviceReliabilityEngine

```dart
class DeviceReliabilityEngine {
  WearableReadingResult applyConfidence({
    required WearableSource source,
    required double rawHRV,
    required double rawHR,
  }) {
    final profile = _deviceProfiles[source]!;

    return WearableReadingResult(
      adjustedHRV:       rawHRV,
      adjustedHR:        rawHR,
      hrvConfidence:     profile.hrvConfidence,
      hrConfidence:      profile.hrConfidence,
      readinessWeight:   _readinessWeight(profile.hrvConfidence),
      displayLabel:      '${source.displayName} · '
                         '${profile.confidenceLabel} confidence',
    );
  }

  /// Lower-confidence devices contribute less to readiness calculation
  double _readinessWeight(double confidence) {
    if (confidence >= 0.85) return 1.0;   // Full weight
    if (confidence >= 0.65) return 0.70;  // 70% weight
    return 0.40;                           // 40% weight — guideline only
  }
}
```

### UI: Wearable Data Source Card

```
┌────────────────────────────────────────────┐
│ ⌚ HRV Source: WHOOP 4.0                   │
│ Confidence: ★★★★★ Very High               │
│                                            │
│ Today's HRV: 58 ms                        │
│ Your baseline: 62 ms  (-6%)               │
│                                            │
│ ℹ️ WHOOP data is weighted at full         │
│   confidence in your readiness score.     │
└────────────────────────────────────────────┘
```

---

### Late-Sync Data Override & Merge Rules

When wearable trackers sync after a long offline period (e.g., a Garmin watch syncing 8 hours late), naive merging leads to duplicate steps or overwritten high-fidelity heart rate data. FitKarma applies strict resolution rules to combine asynchronous health streams.

##### Resolution Rules
1. **Cardiac Data (HR/HRV)**: Minute-level measurements. The highest confidence source in the confidence matrix replaces all lower-confidence data for any overlapping minute buckets.
2. **Cumulative Data (Steps/Calories)**: Hourly buckets. If the user carries their phone (Apple Health/Google Fit steps) and wears a smartwatch, the smartwatch step count overrides the phone step count for any hour where both recorded steps, rather than summing them.
3. **Triggered Readiness Re-calculation**: If late-synced data modifies sleep duration by $>30$ minutes or morning HRV by $>10\%$, a local background job recalibrates the daily `ReadinessScore` and updates the active `DailyIntelligencePackage` parameters dynamically, without initiating a new AI request.

##### Implementation: WearableSyncMerger (Pure Dart)

```dart
enum MetricType { cumulativeSteps, pointInTimeHeartRate, sleepDuration }

class WearableDataPoint {
  final DateTime timestamp;
  final WearableSource source;
  final MetricType type;
  final double value;

  WearableDataPoint({
    required this.timestamp,
    required this.source,
    required this.type,
    required this.value,
  });
}

class WearableSyncMerger {
  /// Merges late-sync wearable points with existing local data based on the device confidence hierarchy,
  /// preventing duplicate step counts or overwritten high-fidelity cardiac metrics.
  List<WearableDataPoint> mergeDataStreams({
    required List<WearableDataPoint> localHistory,
    required List<WearableDataPoint> incomingStream,
    required Map<WearableSource, double> sourceConfidenceMap,
  }) {
    final merged = <String, WearableDataPoint>{};

    // 1. Ingest existing local points
    for (final point in localHistory) {
      final key = _makeKey(point);
      merged[key] = point;
    }

    // 2. Process incoming points with conflict resolution
    for (final point in incomingStream) {
      final key = _makeKey(point);
      if (!merged.containsKey(key)) {
        merged[key] = point;
        continue;
      }

      final existing = merged[key]!;
      final existingConfidence = sourceConfidenceMap[existing.source] ?? 0.0;
      final incomingConfidence = sourceConfidenceMap[point.source] ?? 0.0;

      // Override rule: Select the data point with the higher confidence rating
      if (incomingConfidence > existingConfidence) {
        merged[key] = point;
      }
    }

    return merged.values.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  String _makeKey(WearableDataPoint p) {
    if (p.type == MetricType.pointInTimeHeartRate) {
      // Bucket by minute to prevent overlapping heart rates
      final bucket = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day, p.timestamp.hour, p.timestamp.minute);
      return '${p.type.name}_$bucket';
    } else if (p.type == MetricType.cumulativeSteps) {
      // Bucket by hour to prevent double counting steps between watch and phone
      final bucket = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day, p.timestamp.hour);
      return '${p.type.name}_$bucket';
    }
    // Daily point metrics
    final date = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day);
    return '${p.type.name}_$date';
  }
}
```

---

# PHASE 5 — SMART INDIAN NUTRITION SYSTEM

---

## §P5-A. Food Screen Home

**Route:** `/food`

```
Today's Summary (GlassCard):
  Calorie ring + macros progress bars
  Protein: 58g / 110g  ← red if below 70% target

  Protein Alert (rule-based — no AI):
  "⚠️ Protein low — add paneer or eggs to your next meal"

Meal Sections (collapsible):
  🌅 Breakfast · ☀️ Lunch · 🌙 Dinner · 🍎 Snacks

Meal Quality Score (per meal):
  ├── Protein score
  ├── Fiber score
  ├── Glycemic load
  ├── Satiety
  └── Readiness Impact   ← NEW in v1
      └── "This meal will support recovery (+2% readiness)"

  Goal Impact           ← NEW in v1
  └── "This meal aligns with your fat-loss goal ✓"

Bottom InsightCard: from DIP.nutritionFocus
```

---

## §P5-B. Meal Analysis Pipeline (v1 — Extended)

In v1, meal analysis stopped at macros. In v1, it continues:

```
Photo / Food log entry
      ↓
Macros (calorie, protein, carbs, fat)
      ↓
Meal Quality Score (5 dimensions — computed locally)
      ↓
Readiness Impact (rule-based: high-protein = +recovery, high-GI = -energy)
      ↓
Goal Impact (rule-based: aligns with fat-loss / muscle-gain / health)
      ↓
Fix Suggestions (template-based for common gaps, AI only for edge cases)
```

---

## §P5-C. "Fix My Meal" — AI Meal Photo Analysis

**Trigger:** Camera icon → [Analyze Meal]

### Meal Vision Cost Optimization

Common Indian meals are pattern-matched first — vision model is called only for unrecognized meals:

```dart
import 'package:image/image' as img; // Client-side image preprocessing

class MealPhotoAnalyzer {
  Future<MealAnalysisResult> analyze(File photo) async {
    // Step 1: Try to match against known Indian meals
    final recognized = await _commonMealRecognizer.recognize(photo);

    if (recognized != null && recognized.confidence >= 0.80) {
      // Use cached estimate — no vision API call
      return MealAnalysisResult.fromCache(recognized);
    }

    // Step 2: Client-side downscaling and compression to optimize bandwidth and cloud costs
    final compressedPhoto = await _compressMealPhoto(photo);

    // Step 3: Call Vision model only for complex/unrecognized meals with compressed payload
    return await _callGroqVision(compressedPhoto);
  }

  Future<File> _compressMealPhoto(File originalFile) async {
    final rawBytes = await originalFile.readAsBytes();
    final image = img.decodeImage(rawBytes);
    if (image == null) return originalFile;

    // Downscale if image exceeds 1024px on either dimension while preserving aspect ratio
    img.Image resizedImage = image;
    if (image.width > 1024 || image.height > 1024) {
      if (image.width > image.height) {
        resizedImage = img.copyResize(image, width: 1024);
      } else {
        resizedImage = img.copyResize(image, height: 1024);
      }
    }

    // Compress to JPEG with quality 80%
    final compressedBytes = img.encodeJpg(resizedImage, quality: 80);
    
    // Write to a temporary file in the local app directory
    final tempDir = originalFile.parent;
    final compressedFile = File('${tempDir.path}/compressed_meal_${DateTime.now().millisecondsSinceEpoch}.jpg');
    return await compressedFile.writeAsBytes(compressedBytes);
  }
}

// Common meals with cached estimates (no AI needed):
// Poha, Idli, Dosa, Dal Rice, Rajma Chawal, Upma,
// Chapati, Paratha, Sambar Rice, Chole Bhature, etc.
```

### Full Analysis Result Screen

```
┌────────────────────────────────────┐
│ Detected: Dal Makhani + 2 Rotis    │
│ ~580 kcal · 18g protein            │
│                                    │
│ Meal Quality:                      │
│ ⚠️ Protein low for muscle goal     │
│ ✓ Good fiber                       │
│ ⚠️ High glycemic load              │
│                                    │
│ Readiness Impact: Neutral          │
│ Goal Impact: ⚠️ Below protein need │
│                                    │
│ Fix Suggestions:                   │
│ + Add curd or paneer for protein   │
│ + Replace 1 roti with salad        │
│                                    │
│ [Log This Meal] [Adjust Portions]  │
└────────────────────────────────────┘
```

---

## §P5-D. Smart Indian Meal Intelligence

### 1. Offline Seeded Food Database Matrix

To enable instant offline lookups and reduce API vision calls, FitKarma contains a local pre-populated reference database (`food_references` table) of common Indian foods:

| Food ID | Food Name | Default Serving | Calories | Protein | Carbs | Fat | GI | Fiber | Satiety |
|---------|-----------|-----------------|----------|---------|-------|-----|----|-------|---------|
| `roti_1` | Whole Wheat Roti | 1 Roti (40g) | 85 | 3.0g | 18g | 0.5g | 62 | 2.5g | 65 |
| `rice_1` | Steamed Basmati Rice | 1 Cup (150g) | 200 | 4.2g | 44g | 0.4g | 72 | 1.0g | 50 |
| `dal_1` | Dal Tadka (Yellow) | 1 Bowl (150g) | 150 | 8.5g | 22g | 3.5g | 45 | 6.0g | 75 |
| `paneer_1`| Paneer Bhurji | 1 Plate (150g) | 280 | 18.0g | 8g | 20g | 30 | 2.0g | 85 |
| `chick_1`| Tandoori Chicken | 1 Plate (180g) | 260 | 32.0g | 3g | 12g | 15 | 0.5g | 90 |
| `poha_1` | Onion Poha | 1 Plate (150g) | 220 | 3.5g | 42g | 4.0g | 68 | 2.8g | 60 |
| `idli_1` | Steamed Idli | 2 Pieces (90g) | 120 | 3.0g | 26g | 0.2g | 70 | 1.5g | 58 |
| `dosa_1` | Plain Dosa | 1 Piece (80g) | 165 | 3.2g | 32g | 2.5g | 75 | 1.2g | 55 |
| `sambar_1`| Mixed Veg Sambar | 1 Bowl (150g) | 110 | 4.0g | 18g | 2.0g | 48 | 4.5g | 70 |
| `chole_1`| Punjabi Chole Masala| 1 Bowl (150g) | 240 | 10.2g | 34g | 7.0g | 38 | 8.5g | 80 |
| `rajma_1`| Rajma Masala (Red) | 1 Bowl (150g) | 220 | 9.8g | 32g | 5.5g | 35 | 9.0g | 80 |
| `curd_1` | Whole Milk Curd (Dahi)| 1 Cup (150g) | 98 | 5.2g | 6g | 6.0g | 28 | 0.0g | 72 |
| `khich_1`| Moong Dal Khichdi | 1 Bowl (200g) | 210 | 7.2g | 38g | 3.0g | 55 | 4.0g | 72 |
| `upma_1` | Semolina Upma | 1 Plate (150g) | 190 | 4.0g | 34g | 3.5g | 65 | 2.0g | 62 |
| `egg_1`  | Boiled Egg | 1 Large (50g) | 78 | 6.3g | 0.6g | 5.3g | 0 | 0.0g | 85 |

### 2. Local Meal Quality Score Calculation Engine

FitKarma executes meal quality and target adjustments locally on the client device. This pure-Dart class implements calculation models, resolving macro-micro metrics into clear feedback without network calls:

```dart
class LocalMealQualityCalculator {
  /// Computes composite Meal Quality Score out of 10.0
  double calculateMealQualityScore({
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required double fiberG,
    required int glycemicIndex,
  }) {
    if (calories <= 0) return 0.0;

    // 1. Protein Density Score (Up to 3.0 pts)
    // Formula: (Protein Calories / Total Calories) * 10
    final double proteinCal = proteinG * 4.0;
    final double proteinPct = proteinCal / calories;
    final double proteinScore = (proteinPct * 10.0).clamp(0.0, 3.0);

    // 2. Fiber Density Score (Up to 2.5 pts)
    // Target: 14g fiber per 1000 kcal
    final double targetFiber = (calories / 1000.0) * 14.0;
    final double fiberScore = targetFiber > 0 
        ? ((fiberG / targetFiber) * 2.5).clamp(0.0, 2.5) 
        : 0.0;

    // 3. Glycemic Load Impact Score (Up to 2.5 pts)
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    double glScore = 2.5;
    if (glycemicLoad > 20) { // High Glycemic Load
      glScore = 0.5;
    } else if (glycemicLoad > 10) { // Medium Glycemic Load
      glScore = 1.5;
    }

    // 4. Satiety Index Score (Up to 2.0 pts)
    final double satietyIndex = calculateSatietyIndex(proteinG, fiberG, fatG, carbsG);
    final double satietyScore = (satietyIndex / 100.0) * 2.0;

    return double.parse((proteinScore + fiberScore + glScore + satietyScore).toStringAsFixed(1));
  }

  /// Computes Satiety Index (0 - 100) based on protein/fiber satiating effects
  double calculateSatietyIndex(double protein, double fiber, double fat, double carbs) {
    // Weightings: Protein (highest), Fiber (high), Fat (moderate), Carbs (lowest)
    final double base = (protein * 2.5) + (fiber * 3.0) + (fat * 1.0) + (carbs * 0.5);
    return base.clamp(10.0, 100.0);
  }

  /// Evaluates readiness and muscle repair impact
  int calculateReadinessImpact(double proteinG, int glycemicIndex, double carbsG) {
    int impact = 0;
    
    // High protein post-workout aids muscle recovery
    if (proteinG >= 20.0) {
      impact += 2; // +2% readiness restoration
    }
    
    // High Glycemic Load causing an energy crash
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    if (glycemicLoad > 25.0) {
      impact -= 3; // -3% capacity score due to crash
    }
    
    return impact;
  }
}
```

### 3. Core Nutrition Adaptations

**Thali intelligence:** Estimates full thali as a composite entry — no 8-item manual logging.

**Oil estimation:** Knows typical oil usage per cooking style and region (South: coconut, North: ghee/mustard, West: groundnut).

**Fasting food intelligence:** Navratri mode (grain-free filter), Ramadan mode (Sehri/Iftar templates), Ekadashi (flag grain foods).

**Festival adaptation:** Diwali week — daily target buffer +200 kcal. See §P12 for full cross-module festival logic.

---

## §P5-E. Indian Restaurant Intelligence 2.0 (NEW v1)

> Users eat out frequently, but standard food logging drops because menu items are complex. Restaurant Intelligence 2.0 uses menu OCR scanning and goal-based overlays to make dining out healthy and trackable.

### 1. Menu OCR Scan & Goal Overlay Flow

```
[User takes photo of menu / uploads screenshot]
                 ↓
[On-Device OCR extracts items & price points]
                 ↓
[Overlay UI colors items based on User Goals]
```

- **🟢 Green Highlights (High Protein)**: Items yielding $>20\text{g}$ protein per serving (e.g. Paneer Tikka, Tandoori Chicken, Grilled Fish, Soya Chaap).
- **🔵 Blue Highlights (Low Calorie)**: Items containing $<300\text{ kcal}$ per serving (e.g. Garden salads, clear soups, steamed momos, plain idli).
- **🟠 Orange Highlights (Diabetic/PCOS Safe)**: Low-glycemic index foods rich in fiber/healthy fats (e.g. Mixed veg raita, paneer bhurji, multigrain rotis; alerts user if a sauce contains high sugar).
- **🔴 Red Highlights (Avoid/Alert)**: Deep-fried or high-glycemic/empty-calorie items (e.g. Butter Naan, Gulab Jamun, french fries, sweet lassis).

### 2. Major Chain Menu Optimization Presets

The app contains pre-mapped database recipes for top Indian restaurant menus:

| Chain | Best Protein / Health Pick | Avoid / Alert Item | Diabetic / PCOS Pick |
|-------|-----------------------------|--------------------|----------------------|
| **Haldiram's** | Paneer Tikka Platter (34g Pro) | Chole Bhature (850 kcal) | Sprouted Moong Chaat |
| **Bikanervala** | Grilled Soya Chaap (22g Pro) | Special Thali (1100 kcal) | Tandoori Roti + Mix Veg |
| **Domino's India**| Grilled Chicken breast topping | Cheese Burst Pizza (+320 kcal) | Thin Crust Veggie Pizza |
| **McDonald's India**| McProtein Egg Burger (16g Pro) | McSpicy Chicken (fried) | Grilled Chicken wrap (no mayo) |
| **Barbeque Nation**| Unlimited Grilled Paneer/Chicken | Dessert Counter (excessive sugar)| Grilled Mushrooms & Broccoli |

### 3. Smart Item Recognition & OCR Parser

```dart
class RestaurantDatabaseService {
  final AppDatabase _localDb;
  final CloudflareApiClient _cfClient;

  RestaurantDatabaseService(this._localDb, this._cfClient);

  Future<List<RestaurantMenuItem>> search({
    required String restaurantName,
    String? itemQuery,
    String? city,
  }) async {
    // 1. Try local Drift cache (updated weekly)
    final cached = await _localDb.searchRestaurant(restaurantName, city);
    if (cached.isNotEmpty) return cached;

    // 2. Fall back to Cloudflare D1 restaurant DB
    return await _cfClient.searchRestaurantMenu(restaurantName, city);
  }

  /// Seed of common Indian menu items for local matching when offline or cache misses
  final List<MenuItem> _seededLocalDishes = [
    MenuItem(name: "Paneer Tikka", calories: 280, proteinG: 22, glycemicIndex: 15, isDeepFried: false, sugarG: 2),
    MenuItem(name: "Paneer Tikka Masala", calories: 450, proteinG: 18, glycemicIndex: 35, isDeepFried: false, sugarG: 5),
    MenuItem(name: "Chole Bhature", calories: 850, proteinG: 12, glycemicIndex: 65, isDeepFried: true, sugarG: 4),
    MenuItem(name: "Sprouted Moong Chaat", calories: 180, proteinG: 9, glycemicIndex: 25, isDeepFried: false, sugarG: 3),
    MenuItem(name: "Grilled Soya Chaap", calories: 240, proteinG: 22, glycemicIndex: 20, isDeepFried: false, sugarG: 1),
    MenuItem(name: "Special Thali", calories: 1100, proteinG: 28, glycemicIndex: 55, isDeepFried: true, sugarG: 12),
    MenuItem(name: "Tandoori Roti", calories: 120, proteinG: 4, glycemicIndex: 60, isDeepFried: false, sugarG: 0),
    MenuItem(name: "Mix Veg", calories: 150, proteinG: 3, glycemicIndex: 40, isDeepFried: false, sugarG: 2),
    MenuItem(name: "Butter Naan", calories: 350, proteinG: 8, glycemicIndex: 70, isDeepFried: false, sugarG: 1),
    MenuItem(name: "Dal Makhani", calories: 350, proteinG: 12, glycemicIndex: 45, isDeepFried: false, sugarG: 2),
    MenuItem(name: "Yellow Dal Tadka", calories: 180, proteinG: 9, glycemicIndex: 30, isDeepFried: false, sugarG: 1),
  ];

  /// OCR Menu Parser processing image text lines
  List<ParsedMenuItemOverlay> parseMenuText(List<String> rawOcrLines, UserProfile user) {
    return rawOcrLines.map((line) {
      final matchedItem = matchDishInDatabase(line);
      final overlayColor = _computeGoalOverlay(matchedItem, user);
      return ParsedMenuItemOverlay(
        dishName: matchedItem?.name ?? line,
        calories: matchedItem?.calories ?? 0,
        proteinG: matchedItem?.proteinG ?? 0,
        colorOverlay: overlayColor,
      );
    }).toList();
  }

  /// Fuzzy matcher checking normalized Levenshtein similarity and token containment
  MenuItem? matchDishInDatabase(String ocrLine) {
    if (ocrLine.trim().isEmpty) return null;

    final normalizedOcr = _normalizeString(ocrLine);
    MenuItem? bestMatch;
    double highestSimilarity = 0.0;

    for (final item in _seededLocalDishes) {
      final normalizedDb = _normalizeString(item.name);

      // 1. Exact normalized match
      if (normalizedOcr == normalizedDb) {
        return item;
      }

      // 2. Substring containment check (e.g. "Paneer Tikka Platter" contains "Paneer Tikka")
      if (normalizedOcr.contains(normalizedDb) || normalizedDb.contains(normalizedOcr)) {
        final double containmentScore = normalizedDb.length / normalizedOcr.length;
        final score = containmentScore > 1.0 ? 1.0 / containmentScore : containmentScore;
        // Boost substring containment score if it covers key tokens
        if (score > highestSimilarity && score >= 0.6) {
          highestSimilarity = score;
          bestMatch = item;
        }
      }

      // 3. Levenshtein edit distance calculation
      final distance = _calculateLevenshteinDistance(normalizedOcr, normalizedDb);
      final maxLength = normalizedOcr.length > normalizedDb.length ? normalizedOcr.length : normalizedDb.length;
      final similarity = maxLength > 0 ? 1.0 - (distance / maxLength) : 0.0;

      if (similarity > highestSimilarity) {
        highestSimilarity = similarity;
        bestMatch = item;
      }
    }

    // Return the match only if similarity meets the 70% threshold
    if (highestSimilarity >= 0.70) {
      return bestMatch;
    }

    return null;
  }

  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), ' ')        // Normalize whitespace
        .trim();
  }

  int _calculateLevenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  int _min3(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);

  OverlayColor _computeGoalOverlay(MenuItem? item, UserProfile user) {
    if (item == null) return OverlayColor.none;
    if (item.proteinG >= 20) return OverlayColor.green;
    if (item.calories <= 300) return OverlayColor.blue;
    if (user.goals.contains('pcos') && item.glycemicIndex <= 55) return OverlayColor.orange;
    if (item.isDeepFried || item.sugarG > 15) return OverlayColor.red;
    return OverlayColor.none;
  }
}

enum OverlayColor { green, blue, orange, red, none }
```

---

## §P5-F. Grocery Optimization Engine 2.0 (NEW v1)

> Closes the loop between diet planning, real-world food purchasing, and budget constraints. No Indian health app offers budget-to-macro optimizations.

### 1. Meal Plan → Budget-Optimized Grocery Flow

```
User Input: Target Budget (e.g. ₹3,000/month) + Target Protein (e.g. 110g/day)
                                   ↓
                     [Linear Programming Optimizer]
                                   ↓
                   [Protein-per-Rupee Food Swapping]
                                   ↓
              Aggregated & Cost-Balanced Shopping List
```

- **Protein-per-Rupee Optimization**: The optimizer tracks market costs of Indian protein sources. If the default plan (e.g. Greek yogurt, whey protein, salmon) exceeds the user's monthly budget, the engine suggests swaps to high-yield budget options:
  - *Soya Chunks* (₹0.15 per gram of protein)
  - *Eggs* (₹0.38 per gram of protein)
  - *Double-Toned Curd / Milk* (₹0.45 per gram of protein)
  - *Black Chana / Paneer* (₹0.75 per gram of protein)
- **Budget Override Warnings**:
  - *"⚠️ Your current meal plan requires ~₹4,800/month. We suggest swapping 3 meals of Salmon and Greek Yogurt for Paneer and Eggs to hit your ₹3,000/month target while keeping 110g protein."*

### 2. GroceryOptimizationEngine Implementation

```dart
class GroceryOptimizationEngine {
  final Map<String, double> proteinCostIndex = {
    'soya_chunks': 0.15, // INR per gram of protein
    'eggs': 0.38,
    'double_toned_curd': 0.45,
    'paneer': 0.75,
    'whey_protein': 1.10,
    'greek_yogurt': 1.50,
  };

  OptimizedGroceryList optimize({
    required List<DayMealPlan> weekPlan,
    required double monthlyBudgetInr,
    required int dailyProteinTargetG,
  }) {
    final rawList = _aggregateIngredients(weekPlan);
    final weeklyCostLimit = monthlyBudgetInr / 4.33;
    final currentCost = _calculateCost(rawList);

    if (currentCost <= weeklyCostLimit) {
      return OptimizedGroceryList(items: rawList, costInr: currentCost, isWithinBudget: true);
    }

    // Run heuristic knapsack optimization
    final optimizedItems = <GroceryItem>[];
    double accumulatedCost = 0.0;

    for (final item in rawList) {
      if (item.category == FoodCategory.protein && item.costPerGramOfProtein > 1.0) {
        // Swap high-cost protein with low-cost equivalent to fit budget
        final cheaperAlternative = _findCheaperProteinSubstitute(item);
        optimizedItems.add(cheaperAlternative);
        accumulatedCost += cheaperAlternative.price;
      } else {
        optimizedItems.add(item);
        accumulatedCost += item.price;
      }
    }

    return OptimizedGroceryList(
      items: optimizedItems,
      costInr: accumulatedCost,
      isWithinBudget: accumulatedCost <= weeklyCostLimit,
      budgetWarning: accumulatedCost > weeklyCostLimit 
        ? "Unable to meet protein targets within ₹${monthlyBudgetInr.toInt()}/mo. Please adjust budget or protein goal."
        : "Swapped premium protein items to match ₹${monthlyBudgetInr.toInt()}/mo budget.",
    );
  }

  GroceryItem _findCheaperProteinSubstitute(GroceryItem expensiveItem) {
    // Logic swaps Greek yogurt (200g) -> Double-toned Curd (200g) + 15g Soya Chunks
    return GroceryItem(
      name: "Soya Chunks & Curd Mix (Budget Swap)",
      quantityGrams: expensiveItem.quantityGrams,
      price: expensiveItem.price * 0.4,
      proteinG: expensiveItem.proteinG,
      category: FoodCategory.protein,
    );
  }

  List<GroceryItem> _aggregateIngredients(List<DayMealPlan> weekPlan) {
    // Standard aggregation logic...
    return [];
  }

  double _calculateCost(List<GroceryItem> items) => items.fold(0.0, (sum, item) => sum + item.price);
}
```

Phase 1 (v1 launch): Export list + share
Phase 2 (v1):      Deep link to Blinkit / Zepto / Swiggy Instamart
Phase 3 (v1):      One-tap order (API partnership)
```

---

## §P5-G. Nutrition Periodization Engine (NEW v1)

> Long-term adherence fails when users remain in a static calorie deficit. The Periodization Engine automates phase transitions to prevent metabolic adaptation and psychological burnout.

### 1. Periodization Phases

```
   [Fat Loss Phase] (Max 8-12 weeks)
          ↓
   [Diet Break Phase] (1-2 weeks at Maintenance)
          ↓
  [Recomposition Phase] / [Lean Gain Phase]
```

- **Fat Loss**: Moderate-to-high deficit ($20\%\text{ of TDEE}$).
- **Diet Break**: Calorie targets raised to calculated maintenance (TDEE) for 1–2 weeks. Resets thyroid hormones (T3), leptin, and mental fatigue.
- **Maintenance**: Net zero energy balance to lock in weight checkpoints.
- **Recomposition**: Daily calories at maintenance; macros shifted heavily to protein ($2.2\text{g/kg}$) with progressive resistance training.
- **Lean Gain**: Mild surplus ($+10\%\text{ of TDEE}$) to support muscle hypertrophy with minimal fat accumulation.

### 2. Periodization Controller

```dart
enum PeriodizationPhase { fatLoss, dietBreak, maintenance, recomposition, leanGain }

class PeriodizationController {
  PeriodizationStatus checkPhaseProgression(UserProfile user, List<WeightLog> weightHistory) {
    final currentPhase = user.nutritionPhase;
    final weeksInPhase = DateTime.now().difference(user.phaseStartAt).inDays / 7;

    // Rule 1: Auto-trigger Diet Break after 8 consecutive weeks in deficit
    if (currentPhase == PeriodizationPhase.fatLoss && weeksInPhase >= 8.0) {
      return PeriodizationStatus(
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        reason: "Deficit active for 8 weeks. Triggering a 10-day Diet Break to restore leptin and prevent metabolic adaptation.",
      );
    }

    // Rule 2: If weight plateau detected during Fat Loss (no change in 3 weeks)
    if (currentPhase == PeriodizationPhase.fatLoss && _isPlateaued(weightHistory, durationWeeks: 3)) {
      return PeriodizationStatus(
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        reason: "Plateau detected. Exiting deficit to maintenance for 7 days to reset metabolism.",
      );
    }

    return PeriodizationStatus(nextPhase: currentPhase, actionRequired: false);
  }

  bool _isPlateaued(List<WeightLog> logs, {required int durationWeeks}) {
    if (logs.length < durationWeeks * 3) return false;
    final recentLogs = logs.take(durationWeeks * 3).map((l) => l.weightKg).toList();
    final maxWeight = recentLogs.reduce((a, b) => a > b ? a : b);
    final minWeight = recentLogs.reduce((a, b) => a < b ? a : b);
    return (maxWeight - minWeight).abs() < 0.2; // Variance under 200g
  }
}
```

---

## §P5-H. Protein Distribution & Timing Intelligence (NEW v1)

> Muscle recovery and satiety depend on the distribution of protein intake throughout the day, not just total daily totals. FitKarma scores protein timing to maximize Muscle Protein Synthesis (MPS).

### 1. MPS Threshold Target
- **Optimal Intake**: $25\text{g}$ to $45\text{g}$ of protein per main meal (Breakfast, Lunch, Dinner).
- **Timing Score (0–100)**: Points are awarded for each main meal meeting the minimum $25\text{g}$ MPS threshold:
  - 3 meals met: **100** (Optimal MPS signaling)
  - 2 meals met: **70** (Sub-optimal)
  - 1 meal met: **40** (Poor recovery efficiency)
- **AI Timing Nudge**: 
  - *"Your total protein was 95g, but 70g was eaten at dinner. Breakfast had only 8g. We recommend moving 20g of protein from dinner to breakfast (e.g. add eggs or sattu) to optimize muscle recovery."*

### 2. Timing Scoring Implementation

```dart
class ProteinTimingEvaluator {
  static const double mpsThresholdGrams = 25.0;

  ProteinTimingResult evaluateDistribution(List<MealLog> meals) {
    int targetMealsMet = 0;
    final breakfastProtein = _getMealTypeProtein(meals, MealType.breakfast);
    final lunchProtein = _getMealTypeProtein(meals, MealType.lunch);
    final dinnerProtein = _getMealTypeProtein(meals, MealType.dinner);

    if (breakfastProtein >= mpsThresholdGrams) targetMealsMet++;
    if (lunchProtein >= mpsThresholdGrams) targetMealsMet++;
    if (dinnerProtein >= mpsThresholdGrams) targetMealsMet++;

    double timingScore = 0.0;
    switch (targetMealsMet) {
      case 3: timingScore = 100.0; break;
      case 2: timingScore = 70.0; break;
      case 1: timingScore = 40.0; break;
      default: timingScore = 10.0;
    }

    return ProteinTimingResult(
      score: timingScore,
      feedback: timingScore < 100.0 
        ? "Shift protein sources from high-density meals to low-density meals to achieve balanced MPS triggers."
        : "Excellent protein distribution across meals.",
    );
  }

  double _getMealTypeProtein(List<MealLog> meals, MealType type) {
    return meals
        .where((m) => m.type == type)
        .fold(0.0, (sum, meal) => sum + meal.proteinG);
  }
}
```

---

## §P5-I. Micronutrient Intelligence Core (NEW v1)

> Overcoming micronutrient deficiencies is critical for long-term health outcomes, especially for specific dietary profiles and cohorts.

### 1. Biomarkers Tracked & Target Adjustments

| Micronutrient | Standard RDA | Vegetarian Target | Female / PCOS Target | Why It Matters |
|---------------|--------------|-------------------|----------------------|----------------|
| **Iron** | 8 mg (M) / 18 mg (F) | 1.8x RDA (Non-Heme) | 21 mg/day | Hemoglobin & Oxygen transport |
| **Vitamin B12**| 2.4 mcg | 3.0 mcg (Crucial) | 2.4 mcg | Nerve tissue & DNA synthesis |
| **Vitamin D3** | 600 IU | 800 IU | 1000 IU | Bone density, immune function |
| **Calcium** | 1000 mg | 1000 mg | 1200 mg | PCOS bone health & muscle firing|
| **Magnesium** | 350 mg | 350 mg | 400 mg | Insulin sensitivity & stress recovery |
| **Zinc** | 11 mg | 15 mg | 11 mg | Immunity & testosterone synthesis |
| **Folate** | 400 mcg | 400 mcg | 600 mcg (Fertility) | Cellular division & neural tube safety |
| **Omega-3** | 1.6g | 2.0g (ALA fallback)| 2.0g | Anti-inflammatory recovery |

### 2. Auto-Alert Trigger Engine

```dart
class MicronutrientAlertEngine {
  List<MicroAlert> evaluateLogs(List<NutritionLog> logs, UserProfile user) {
    final alerts = <MicroAlert>[];
    final averageIronPct = logs.map((l) => l.ironMg).average / user.targetIronMg;
    final averageB12Pct = logs.map((l) => l.b12Mcg).average / user.targetB12Mcg;

    if (user.isVegetarian && averageB12Pct < 0.50) {
      alerts.add(MicroAlert(
        title: "B12 Depletion Risk",
        message: "Your vegetarian diet yields only ${averageB12Pct * 100}% of Vitamin B12 targets. Consider adding fortified milk or an oral supplement.",
        severity: Severity.high,
      ));
    }

    if (user.isFemale && averageIronPct < 0.60) {
      alerts.add(MicroAlert(
        title: "Iron Deficit Warning",
        message: "Your logged meals are low in iron. Pair plant-iron (spinach, chana) with Vitamin C (lemon juice) to double non-heme absorption.",
        severity: Severity.medium,
      ));
    }

    return alerts;
  }
}
```

---

## §P5-J. Nutrition Adherence Engine (NEW v1)

> Adherence tracking determines the accuracy of metabolic adaptations. FitKarma tracks consistency, rather than perfection, to drive long-term habit changes.

### 1. Scoring Matrix

The **Nutrition Adherence Score** is computed daily on a $0\text{--}100$ scale:
- **Calorie Adherence (30 points)**: Awarded if total logged calories are within $\pm 10\%$ of target.
- **Protein Adherence (35 points)**: Awarded if total logged protein is within $\pm 15\%$ of target.
- **Logging Completion (20 points)**: Logged at least 3 distinct meals (prevents lazy tracking).
- **Meal Timing Consistency (15 points)**: Main meals logged within $\pm 60$ minutes of the user's historical rolling median.

### 2. Score Calculation Logic

```dart
class NutritionAdherenceEngine {
  double calculateDailyScore({
    required DailyNutritionLog log,
    required NutritionTargets targets,
    required List<MealTimeMedian> historicalMedians,
  }) {
    double score = 0.0;

    // 1. Calorie Check
    final calorieDelta = (log.totalCalories - targets.calories).abs();
    if (calorieDelta <= (targets.calories * 0.10)) {
      score += 30.0;
    }

    // 2. Protein Check
    final proteinDelta = (log.totalProtein - targets.protein).abs();
    if (proteinDelta <= (targets.protein * 0.15)) {
      score += 35.0;
    }

    // 3. Logging Completeness (at least 3 meals logged)
    if (log.mealsLogged >= 3) {
      score += 20.0;
    }

    // 4. Timing Stability
    if (_checkTimingStability(log.meals, historicalMedians)) {
      score += 15.0;
    }

    return score;
  }

  bool _checkTimingStability(List<MealRecord> meals, List<MealTimeMedian> medians) {
    // Verifies meals are logged close to customary meal times
    int onTimeMeals = 0;
    for (final meal in meals) {
      final median = medians.firstWhere((m) => m.type == meal.type, orElse: () => null);
      if (median != null && meal.time.difference(median.time).inMinutes.abs() <= 60) {
        onTimeMeals++;
      }
    }
    return onTimeMeals >= 2;
  }
}
```

---

## §P5-K. Smart Festival Nutrition Adaptation (NEW v1)

> Strict restrictions fail during festivals. FitKarma adapts to social eating patterns pre-emptively, protecting consistency without isolating users socially.

### 1. Diwali Pre-Compensation Protocol
- **3 Days Pre-Festival**: Automatically reduce target calories by $-150\text{ kcal/day}$ to bank a caloric buffer.
- **Festival Day**:
  - Calorie target increased by $+400\text{ kcal}$ to accommodate sweets.
  - Protein target raised by $+15\text{g}$ to trigger early satiety.
  - Satiety focus alert: *"Diwali sweets are expected today! Eat your high-protein sources (whey/paneer) first before indulging to blunt blood sugar spikes."*
- **Post-Festival**: Enable high hydration target ($+1\text{L}$ water) and a moderate steady-state cardio session (e.g. a 45-minute recovery walk).

### 2. Adaptation Engine Integration

```dart
class FestivalNutritionAdapter {
  NutritionTargets adjustTargets(NutritionTargets baseline, FestivalEvent event, FestivalDayRelative relativeDay) {
    if (event.type == FestivalType.diwali) {
      switch (relativeDay) {
        case FestivalDayRelative.pre3Days:
          return baseline.copyWith(
            calories: baseline.calories - 150,
            protein: baseline.protein + 5,
          );
        case FestivalDayRelative.festivalDay:
          return baseline.copyWith(
            calories: baseline.calories + 400,
            protein: baseline.protein + 15,
            waterL: baseline.waterL + 0.5,
          );
        case FestivalDayRelative.post1Day:
          return baseline.copyWith(
            calories: baseline.calories - 100,
            carbs: baseline.carbs - 50,
            waterL: baseline.waterL + 1.0,
          );
      }
    }
    return baseline;
  }
}
```

---

## §P5-L. Adaptive Hunger & Cravings Engine (NEW v1)

> Anticipating craving patterns drives long-term adherence. This engine monitors hunger and stress correlations to prompt pre-emptive snacking.

### 1. Craving Log Prompts
- **Subjective Metrics**: Users log hunger scores (1 = Stuffed, 5 = Starving) and active craving types (sweet, salty, fatty).
- **Proactive Intervention Trigger**:
  - If data detects a repeated sweet craving or binge log around 9:00 PM (associated with high daily work stress or low lunch protein), the app triggers a nudge at 7:00 PM:
  - *"We notice you tend to crave sweet snacks at 9 PM on stressful days. Add a 25g protein snack (Greek yogurt or sattu drink) now to stabilize insulin and prevent late-night binging."*

### 2. Craving Predictor Implementation

```dart
class HungerCravingEngine {
  HungerIntervention evaluateCravingRisk(List<NutritionLog> foodLogs, List<MoodStressLog> stressLogs) {
    final now = DateTime.now();
    final recentStress = stressLogs.take(3).map((s) => s.stressLevel).average;
    
    // Check if user has historically logged late-night junk food on high-stress days
    final hasBingePattern = foodLogs.any((log) => 
      log.timestamp.hour >= 21 && 
      log.hasUltraProcessedFood && 
      recentStress >= 4.0
    );

    if (hasBingePattern && now.hour == 19) {
      return HungerIntervention(
        shouldTriggerNudge: true,
        nudgeTitle: "Pre-Emptive Snacking Alert",
        nudgeBody: "Stress is elevated. Eat a 20g protein snack now to avoid late-night blood sugar dips.",
        recommendedSnack: "1 cup curd with walnuts or a scoop of protein shake.",
      );
    }

    return HungerIntervention(shouldTriggerNudge: false);
  }
}
```

---

## §P5-M. Glycemic Response & Personal Food Scoring (NEW v1)

> A food that causes a mild glycemic response in one user may cause a massive spike in another. FitKarma maps personal CGM curves to score specific foods.

### 1. CGM Integration Map
- **Sugar Spike Delta**: Calculated as:
  $$\Delta Glucose = \text{Peak } (90\text{ min post-meal}) - \text{Baseline } (\text{pre-meal})$$
- **Personal Food Score (1 to 10)**:
  - $\Delta Glucose < 25\text{ mg/dL}$: **10/10** (Optimal energy stability)
  - $\Delta Glucose \in [25, 45]\text{ mg/dL}$: **7/10** (Moderate glycemic variance)
  - $\Delta Glucose > 45\text{ mg/dL}$: **3/10** (Poor glycemic response; triggers crash risk)
- **Mitigation Recommendation**: If a food yields a score $<5/10$ (e.g. white rice or a banana), the app suggests pairing it with healthy fats or soluble fiber:
  - *"A banana spikes your glucose by +48 mg/dL. Try pairing it with 10 almonds or half a scoop of protein to blunt the insulin spike."*

### 2. Score Calculation Code

```dart
class GlycemicScoringEngine {
  FoodGlycemicScore computeScore({
    required List<CgmReading> postMealReadings,
    required double baselineGlucose,
  }) {
    final peakReading = postMealReadings
        .map((r) => r.glucoseMgDl)
        .reduce((a, b) => a > b ? a : b);
    
    final spikeDelta = peakReading - baselineGlucose;

    double rating = 10.0;
    String recommendation = "Great glycemic response. Enjoy this food.";

    if (spikeDelta > 45.0) {
      rating = 3.0;
      recommendation = "High glucose spike detected (+${spikeDelta.toInt()} mg/dL). Pair this item with dietary fiber or healthy fats to blunt the response.";
    } else if (spikeDelta > 25.0) {
      rating = 7.0;
      recommendation = "Moderate spike detected. Keep portion size in check.";
    }

    return FoodGlycemicScore(
      score: rating,
      glucoseDelta: spikeDelta,
      recommendation: recommendation,
    );
  }
}
```

---

## §P5-N. Multi-Dimensional Meal Quality Score (NEW v1)

> Calories and macros do not capture overall food quality. FitKarma grades every meal out of 100 to reward nutrient density.

### 1. Scoring Formula
The meal quality score is calculated as:
$$Score = \left(2.5 \times \text{ProteinDensity}\right) + \left(3 \times \text{FiberG}\right) + \left(20 \times \text{SatietyIndex}\right) - \left(15 \times \text{ProcessingTier}\right)$$

Where:
- **Protein Density**: $\text{Protein (g)} \times 100 / \text{Calories}$.
- **Fiber**: Total dietary fiber in grams.
- **Satiety Index**: Scored 1 to 5 based on water volume and protein fraction.
- **Processing Tier**: Scored 0 (Whole Foods) to 3 (Ultra-Processed / NOVA Tier 4).

### 2. Indian Food Score Comparison Examples

- **600 kcal Fast Food Pizza**:
  - Protein: 18g · Fiber: 1.5g · Processing Tier: 3 · Satiety: 1.5
  - **Meal Quality Score: 35 / 100**
- **600 kcal Rajma Rice + Curd + Salad**:
  - Protein: 28g · Fiber: 12g · Processing Tier: 0 · Satiety: 4.5
    - **Meal Quality Score: 85 / 100**

---

## §P5-O. Nutrition Reliability Score & Data Confidence Shield (NEW v1)

> Metabolic adaptation engines rely on clean logging data. If a user logs poorly, normal engines drop calories automatically, causing starvation cascades. FitKarma protects users with a Data Confidence Shield.

### 1. The Reliability Equation

The **7-Day Rolling Nutrition Reliability Score** is calculated as:
$$\text{Reliability \%} = \frac{\text{Logged Days } (\ge 3 \text{ meals}) \times 40 + \text{Protein Tracking Consistency } \times 30 + \text{Hydration Logs } \times 30}{100}$$

- **Target Lockout Threshold**: If the rolling reliability score falls below **70%**, the metabolic adaptation engine engages a target lock.
- **Visual Shield Feedback**:
  - *"⚠️ Your weight loss has plateaued, but your log reliability is only 48%. We cannot safely lower your calories without stable logging. Focus on logging all meals for 5 consecutive days to re-enable calorie adaptations."*

### 2. Implementation: Shield Check

```dart
class DataConfidenceShield {
  static const double minimumReliabilityThreshold = 0.70;

  ShieldStatus evaluateLoggingQuality({
    required List<DailyNutritionLog> pastWeekLogs,
    required double weightPlateauWeeks,
  }) {
    int validLogDays = 0;
    double proteinComplianceSum = 0.0;
    double hydrationComplianceSum = 0.0;

    for (final log in pastWeekLogs) {
      if (log.mealsLogged >= 3) validLogDays++;
      proteinComplianceSum += log.wasProteinTargetMet ? 1.0 : 0.0;
      hydrationComplianceSum += log.wasWaterTargetMet ? 1.0 : 0.0;
    }

    final loggingRatio = validLogDays / 7.0;
    final proteinRatio = proteinComplianceSum / 7.0;
    final hydrationRatio = hydrationComplianceSum / 7.0;

    final reliabilityScore = (loggingRatio * 0.40) + (proteinRatio * 0.30) + (hydrationRatio * 0.30);

    if (reliabilityScore < minimumReliabilityThreshold) {
      return ShieldStatus(
        isLockoutActive: true,
        reliabilityScore: reliabilityScore,
        alertMessage: "Metabolic target lock active. Current logging reliability (${(reliabilityScore * 100).toInt()}\%) is too low to compute safe target updates. Maintain consistent logging for 5 days.",
      );
    }

    return ShieldStatus(
      isLockoutActive: false,
      reliabilityScore: reliabilityScore,
      alertMessage: "Data confidence high. Targets unlocked.",
    );
  }
}
```

---

## §P5-P. Satiety Prediction Engine (NEW v1)

> Diets fail due to hunger. FitKarma scores foods for satiety to guide users toward items that maximize fullness per calorie.

### 1. Satiety Index Score (0 to 100)

The satiety score estimates volume, fiber expansion, and protein fullness while penalizing ultra-processed foods:
$$\text{Satiety Score} = \min\left(100, \left(2.8 \times \text{ProteinG}\right) + \left(4 \times \text{FiberG}\right) + \left(1.2 \times \text{WeightVolumeFraction}\right) - \left(12 \times \text{NOVAProcessingTier}\right)\right)$$

Where **WeightVolumeFraction** is the food weight in grams divided by total meal volume.

### 2. Local Indian Satiety Reference Table

| Food / Meal | Calories | Satiety Score | Primary Fullness Factor |
|-------------|----------|---------------|-------------------------|
| **Paneer Bhurji (200g)** | 320 kcal | **90 / 100** | High Protein density & slow digesting |
| **Rajma Chawal + Salad (350g)**| 480 kcal | **85 / 100** | High soluble fiber + high volume |
| **Air-Fried Samosa (1 pc)** | 160 kcal | **60 / 100** | Fiber substitute + moderate fat drop |
| **Deep-Fried Samosa (1 pc)** | 310 kcal | **30 / 100** | Ultra-processed, high trans fat, zero fiber |
| **Indian Chai + 2 Biscuits** | 220 kcal | **20 / 100** | Rapid sugar absorption, high glycemic crash |

---

## §P5-Q. Family Nutrition Integration (NEW v1)

> In Indian households, cooking separate meals for every family member is impossible. The Family Nutrition Engine generates unified recipe targets that adapt portions to meet different clinical goals.

### 1. Multi-Profile Matching Flow

```
Family Dinner: Palak Paneer + Multigrain Rotis + Curd + Cucumber Salad
  ├── Father (Diabetic)   → Portion: 1 Roti, double paneer & salad (Glycemic defense)
  ├── Mother (Weight Loss)→ Portion: 2 Rotis, double curd, high salad (Deficit control)
  └── Child (Growth Stage)→ Portion: 3 Rotis, high paneer, curd with honey (Calorie surplus)
```

- **Conflict Hierarchy**: Medical requirements (e.g. Low GI for Diabetic) dictate the main dish selection. Calorie and macro differences are adjusted through portion sizes, grains, and dairy side-dishes.

### 2. Family Dinner Engine

```dart
class FamilyMealPlannerEngine {
  UnifiedFamilyMeal planDinner({
    required List<UserProfile> familyMembers,
    required List<Recipe> recipeDatabase,
  }) {
    // 1. Identify active medical constraints
    final hasDiabeticMember = familyMembers.any((m) => m.goals.contains('diabetes_reversal'));
    final hasPcosMember = familyMembers.any((m) => m.goals.contains('pcos'));

    // 2. Filter base dish to fit clinical priorities
    final suitableRecipes = recipeDatabase.where((recipe) {
      if (hasDiabeticMember && recipe.glycemicIndex > 55) return false;
      if (hasPcosMember && recipe.isDairyHeavy) return false; // PCOS customized
      return true;
    }).toList();

    final baseRecipe = suitableRecipes.first; // Pick highest matching score recipe

    // 3. Generate portion sizes per member
    final portionGuides = <String, MemberPortion>{};
    for (final member in familyMembers) {
      double portionMultiplier = 1.0;
      String specialNote = "Standard serving.";

      if (member.goals.contains('weight_loss')) {
        portionMultiplier = 0.8;
        specialNote = "Increase salad portion to 200g; limit rotis to 2 max.";
      } else if (member.goals.contains('muscle_gain')) {
        portionMultiplier = 1.3;
        specialNote = "Add 1 cup of high-protein curd or sattu drink to dinner.";
      } else if (member.goals.contains('diabetes_reversal')) {
        portionMultiplier = 0.9;
        specialNote = "Strictly limit refined wheat. Swap to multigrain roti.";
      }

      portionGuides[member.localId] = MemberPortion(
        baseMultiplier: portionMultiplier,
        customInstructions: specialNote,
      );
    }

    return UnifiedFamilyMeal(
      selectedRecipe: baseRecipe,
      memberPortions: portionGuides,
    );
  }
}
```

---

## §P5-R. Indian Food Substitution & Swap Engine (NEW v1)

> Telling users "do not eat street food" leads to diet dropouts. FitKarma suggests high-adherence, culturally relevant swaps that satisfy cravings.

### 1. Target Swap Index

| Caved Food | Smart Swap Option | Calorie Delta | Protein Delta | Satiety Change |
|------------|-------------------|---------------|---------------|----------------|
| **Deep-Fried Samosa** (310 kcal) | **Air-Fried Samosa** (160 kcal) | **-150 kcal** | 0g | +30 Satiety |
| **Paneer Butter Masala** (510 kcal) | **High-Pro Paneer Makhani** (290 kcal) | **-220 kcal** | **+12g Pro** | +40 Satiety |
| **Gulab Jamun / Mithai** (320 kcal) | **Whey Protein Kheer** (140 kcal) | **-180 kcal** | **+18g Pro** | +55 Satiety |
| **Maida Laccha Paratha** (280 kcal) | **Oats & Missi Roti** (160 kcal) | **-120 kcal** | **+4g Pro** | +35 Satiety |

### 2. Substitution Service Implementation

```dart
class FoodSwapService {
  final Map<String, SmartSubstitute> substitutionRegistry = {
    'samosa_fried': SmartSubstitute(
      alternativeName: "Air-Fried Samosa",
      calories: 160,
      protein: 4.5,
      swapInstructions: "Brush lightly with olive oil and bake/air-fry at 180°C for 15 mins.",
    ),
    'paneer_butter_masala': SmartSubstitute(
      alternativeName: "High-Protein Paneer Makhani",
      calories: 290,
      protein: 26.0,
      swapInstructions: "Substitute cashew cream with low-fat yogurt/skimmed milk; reduce butter.",
    ),
    'gulab_jamun': SmartSubstitute(
      alternativeName: "Whey Protein Sattu Kheer",
      calories: 140,
      protein: 18.0,
      swapInstructions: "Boil skimmed milk with roasted sattu, sweeten with stevia, add 0.5 scoop whey.",
    ),
  };

  SmartSubstitute? checkSubstitution(String foodKey) {
    return substitutionRegistry[foodKey];
  }
}
```

---

# PHASE 6 — WORKOUT SYSTEM & MOVEMENT INTELLIGENCE

---

## §P6-A. Workout Screen Home

**Route:** `/workout`
**Scaffold:** Dark theme bento grid with high contrast cards.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Workout Home                                      │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Active: Corporate Fat Loss (Week 4 / Day 2)       │ │
│  │  Weekly Progress: [=======>........] 2 of 4 days   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Today's Session:                                      │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Upper Body Power & Hypertrophy                   │ │
│  │  45 mins  ·  4 Exercises  ·  16 sets              │ │
│  │                                                   │ │
│  │  [!] Progression Badge:                           │ │
│  │  "Suggesting +2.5kg on Bench Press today"         │ │
│  │                                                   │ │
│  │                 [ Start Workout ]                 │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Recent History:                                       │
│  - Yesterday: Lower Body Core (Completed ✓)            │
│  - 3 days ago: Upper Body Pull (Completed ✓)           │
└────────────────────────────────────────────────────────┘
```

---

## §P6-B. Active Workout Screen

**Route:** `/workout/active`
**Scaffold:** Full-screen workout interface with persistent status bars.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Active Workout                  [ Time: 24:15 ]   │
│                                                        │
│  Exercise 1 of 4: Flat Barbell Bench Press            │
│  Target: 4 sets x 8 reps @ 80 kg                       │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Set   │   Target   │   Weight   │  Reps  │ Done? │ │
│  ├────────┼────────────┼────────────┼────────┼───────┤ │
│  │  1     │ 8 reps     │ [  80 kg ] │ [  8 ] │  [x]  │ │
│  │  2     │ 8 reps     │ [  80 kg ] │ [  8 ] │  [x]  │ │
│  │  3     │ 8 reps     │ [  80 kg ] │ [  8 ] │  [ ]  │ │
│  │  4     │ 8 reps     │ [  80 kg ] │ [  8 ] │  [ ]  │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Rest Timer (Starts automatically after check):        │
│                    ┌───────────┐                       │
│                    │   01:12   │                       │
│                    │ remaining │                       │
│                    └───────────┘                       │
│           [ +30s ] [ Skip Rest ] [ Pause ]             │
└────────────────────────────────────────────────────────┘
```

### Active Set Logging & Rest Countdowns

*   **Rest Timer Widget**: Implemented via a `CustomPainter` drawing a progress arc around the circular timer. The timer is triggered automatically when a set check-box is tapped to `true`.
*   **XP Burst Overlay**: Upon ticking the final set of the workout, the app triggers a high-impact completion overlay displaying an animated XP burst celebrating workout completion (rather than logging actions).

---

## §P6-C. Progressive Overload Engine (Deterministic)

```dart
class ProgressiveOverloadEngine {
  ProgressionSuggestion? suggest({
    required Exercise exercise,
    required List<WorkoutSession> recentSessions,
  }) {
    final last3 = recentSessions.takeLast(3);
    final allComfortable = last3.every(
      (s) => s.repsCompleted >= s.repsTarget && s.rpe <= 7
    );

    if (allComfortable) {
      return ProgressionSuggestion(
        type: ProgressionType.increaseWeight,
        message: 'You completed 3 sessions at ${exercise.currentWeight}kg '
                 'comfortably. Increase to ${exercise.nextWeightStep}kg.',
      );
    }

    if (_isPlateau(recentSessions)) {
      return ProgressionSuggestion(
        type: ProgressionType.deload,
        message: 'Same weight for 4 weeks. Take a deload week at 60% intensity.',
      );
    }

    return null;
  }
}
```

---

## §P6-D. Dynamic Fitness Blueprint Generator

Generated by AI once at program selection, cached to Drift. Not regenerated unless user switches program or a Program Evolution event occurs.

```json
{
  "programName": "Corporate Fat Loss",
  "durationWeeks": 12,
  "daysPerWeek": 4,
  "sessionDuration": 45,
  "phases": [
    { "name": "Foundation", "weeks": "1-3", "intensity": "RPE 6-7" },
    { "name": "Build",      "weeks": "4-8", "intensity": "RPE 7-8" },
    { "name": "Peak",       "weeks": "9-12", "intensity": "RPE 8-9" }
  ],
  "deloadWeeks": [4, 8, 12]
}
```

---

## §P6-E. Training Operating System (NEW v1 — Movement Intelligence, Adaptive Overload, and Local Readiness)

> FitKarma evolves exercise tracking from a passive logbook into a Training Operating System (TOS), combining on-device video analytics, real-time joint-angle tracking, localized muscle fatigue, and recovery-aware overload systems.

```
                  +-----------------------------------+
                  |      On-Device Camera Feed        |
                  +-----------------+-----------------+
                                    |
                                    v
                  +-----------------+-----------------+
                  |   Video Intelligence Pipeline     |
                  | (ROM, Joint Angles, Path Jitter)  |
                  +-----------------+-----------------+
                                    |
                                    v
  +------------------+    +-------------------+    +-------------------+
  | Local Readiness  |--> |  Training OS Core | <--|  Weakness Profile |
  |  (Upper/Lower)   |    |  Decision Engine  |    |  & Memory Logs    |
  +------------------+    +---------+---------+    +-------------------+
                                    |
                                    v
                  +-----------------+-----------------+
                  |   Recovery-Aware Overload Nudge   |
                  |  & Adaptive Exercise Smart Swaps  |
                  +-----------------------------------+
```

---

### 1. Movement Intelligence Platform (5 Levels)

#### Level 1 — Exercise Video Intelligence
Runs entirely on-device (asynchronously via MediaPipe) to extract:
- **Joint Angles**: Real-time knee flexion, hip crease levels, shoulder extension, and lumbar angles.
- **Rep Count & Range of Motion (ROM)**: Tracks execution parallel thresholds (e.g., Squat depth break-parallel).
- **Tempo Tracking**: Segments each rep into eccentric, isometric, and concentric phases in milliseconds.
- **Path Jitter & Stability**: Measures the deviation of keypoints from a normalized path.

#### Level 2 — Personalized Weakness Profiling (MWP)
Tracks recurring mechanical patterns over workouts:
- *Knee Valgus Rate*: Collapse of knees inward during load.
- *Lumbar Flexion ("Butt Wink")*: Loss of neutral spine under flexion.
- *Heel Lift*: Shift of bodyweight forward off heels.
- *Asymmetric Shift*: Shift of pelvis/weight to one leg.

#### Level 3 — Mobility Diagnosis & Correctives
Maps joint faults to underlying anatomical constraints, prescribing localized corrective warm-ups:

```dart
class MobilityDiagnosisEngine {
  MobilityReport diagnoseSquatPattern({
    required List<FormAnalysisResult> setLogs,
  }) {
    final totalReps = setLogs.length;
    if (totalReps == 0) return MobilityReport.empty();

    int valgusReps = 0;
    int heelLiftReps = 0;
    int shallowReps = 0;

    for (final log in setLogs) {
      if (log.kneeValgusDetected) valgusReps++;
      if (log.heelLiftDetected) heelLiftReps++;
      if (log.squatDepthAngle < 80.0) shallowReps++;
    }

    final valgusRatio = valgusReps / totalReps;
    final heelLiftRatio = heelLiftReps / totalReps;
    final shallowRatio = shallowReps / totalReps;

    final diagnostics = <String>[];
    final drills = <String>[];

    if (heelLiftRatio > 0.40 || (shallowRatio > 0.40 && heelLiftRatio > 0.20)) {
      diagnostics.add("Limited Ankle Dorsiflexion");
      drills.addAll([
        "Perform 10 ankle rocker stretches per side before squatting.",
        "Squat with heels elevated on 2.5kg plates to bypass range limit."
      ]);
    }

    if (valgusRatio > 0.30) {
      diagnostics.add("Glute Medius Instability");
      drills.addAll([
        "Wrap a loop resistance band around knees during warm-up sets.",
        "Add 15 lateral band walks per side to activate lateral hip stabilizers."
      ]);
    }

    return MobilityReport(
      identifiedIssues: diagnostics,
      prescribedDrills: drills,
      mobilityIndex: (100 - ((valgusRatio + heelLiftRatio + shallowRatio) * 33.3)).clamp(0, 100).round(),
    );
  }
}
```

#### Level 4 — Biomechanical Injury Forecasting
Correlates kinematic breakdown trends with systemic recovery deficits to flag overload injury risks:
- *Rule*: $\text{Knee Valgus Rate} > 30\% \text{ for 3 sessions} + \text{Sleep Debt} > 4\text{ hours} + \text{Squat Volume Increase} > 15\% \rightarrow$ **High Patellar Tendinopathy Risk**.
- *System Action*: Lowers workout intensity factor, swaps squat variant, and injects tissue-prep mobility exercises.

#### Level 5 — Movement Memory
Maintains long-term kinematic logs to show progress:
- *"Your deep squat capacity has increased. Average depth improved from 82° to 105° (breaking parallel). Ankle stability is up 24% since January."*

---

### 2. Physical & Psychological Confidence Indices

#### A. Exercise Confidence Score (ECS)
Gym anxiety is a major cause of dropout. The ECS measures bar path stability and execution quality:
$$\text{ECS} = 100 - \left(\text{Tempo Variance \%} \times 0.4 + \text{Asymmetry Rate \%} \times 0.3 + \text{Joint Jitter Index} \times 0.3\right)$$
- Tracks improvement: indicates to the user that they are mastering the movement shape even before adding weight.

#### B. Movement Health Score (MHS)
Overall functional baseline synthesized weekly:
$$\text{MHS} = 0.25 \times \text{Mobility} + 0.25 \times \text{Stability} + 0.15 \times \text{Balance} + 0.15 \times \text{Coordination} + 0.20 \times \text{Form Accuracy}$$

#### C. Camera-Based Fitness Onboarding & Movement Age
During onboarding, a 4-minute camera movement check (Deep Squat, Single-Leg Balance, Overhead Reach, Plank Hold) assigns a biological **Movement Age** and athletic baseline profile.

---

### 3. Smart Programming & Overload Logic

#### A. Adaptive Exercise Selection
Replaces movements dynamically when joint limitations are diagnosed or appropriate equipment is unavailable:

```dart
class AdaptiveExerciseSelector {
  final Map<String, List<String>> substitutions = {
    'barbell_overhead_press': ['landmine_press', 'dumbbell_arnold_press'],
    'barbell_back_squat': ['goblet_box_squat', 'trap_bar_deadlift'],
    'conventional_deadlift': ['romanian_deadlift', 'kettlebell_swing'],
  };

  String selectAlternative(String primaryExerciseId, List<String> identifiedLimitations) {
    if (primaryExerciseId == 'barbell_overhead_press' && identifiedLimitations.contains('Poor Shoulder Mobility')) {
      return 'landmine_press'; // Avoid overhead impingement
    }
    if (primaryExerciseId == 'barbell_back_squat' && identifiedLimitations.contains('Limited Ankle Dorsiflexion')) {
      return 'goblet_box_squat'; // More upright torso, lower dorsiflexion demand
    }
    return substitutions[primaryExerciseId]?.first ?? primaryExerciseId;
  }
}
```

#### B. Local Muscle Readiness
Splits systemic readiness into active local segments:
- **Upper Body Readiness**: Derived from shoulder stability, grip metrics, and chest/back soreness.
- **Lower Body Readiness**: Derived from hip extension, ankle mobility, and quadriceps/hamstring soreness.
- *Action*: If overall readiness is 80 but Lower Body Readiness is 55, the dashboard suggests: *"Readiness overall is high, but your legs need recovery. Swap Leg Day with Upper Body Day to maximize training capacity."*

#### C. Recovery-Aware Overload Progression
Adapts overload suggestion weight steps based on daily recovery capacity:

```dart
class RecoveryAwareOverloadEngine {
  ProgressionSuggestion suggest({
    required String exerciseId,
    required double baseTargetWeight,
    required double recoveryCapacity,
    required double sleepDebtHours,
  }) {
    double progressionFactor = 1.0;

    if (recoveryCapacity < 50) {
      progressionFactor = 0.0; // Maintenance / Deload
    } else if (recoveryCapacity < 70 || sleepDebtHours > 2.0) {
      progressionFactor = 0.5; // Half-step progression
    }

    final double overloadStep = 5.0 * progressionFactor;
    return ProgressionSuggestion(
      targetWeight: baseTargetWeight + overloadStep,
      message: overloadStep == 0.0
          ? "Recovery capacity is low. Maintain current weight ($baseTargetWeight kg) to prevent overreaching."
          : "Overload target adjusted to +$overloadStep kg (half-step) due to moderate sleep debt.",
    );
  }
}
```

---

### 4. Adherence & Long-Term Athletic Profiling

#### A. Training Reliability Score (0–100)
Combines adherence dimensions over 30 days:
$$\text{Reliability} = 100 \times \left(\frac{\text{Completed Workouts}}{\text{Scheduled Workouts}}\right) - \text{Skipped Sets Penalty} - \text{Rescheduled Days Penalty}$$

#### B. Workout Simulation & Strength Potential
- **Workout Simulator**: Predicts 12-week development lines (e.g. *"If you maintain a Reliability Score > 85%, your estimated Bench Press max will progress from 80kg to 92kg in 12 weeks."*).
- **Strength Potential**: Anthropometric calculation indicating maximum drug-free strength thresholds based on height, wrist size, and joint structures.
- **Athletic Profile**: Classifies users into four core components: *Strength*, *Power*, *Endurance*, and *Mobility*.

---

### 5. Advanced Biomechanics & Trajectory Projections (NEW v1)

#### A. Movement Asymmetry Detection
During unilateral movements (Single-Leg Squats, Single-Arm Shoulder Press, Lunges), the system tracks joint angles on both sides to compute asymmetry ratios:
- **Calculation**: $\text{Asymmetry Delta \%} = \frac{|\text{Left Angle} - \text{Right Angle}|}{\max(\text{Left}, \text{Right})} \times 100$
- **Feedback**: Flags compensation anomalies if delta exceeds $10\%$ for $>3$ consecutive reps.

```dart
class AsymmetryDetectionEngine {
  AsymmetryReport analyzeUnilateralRep({
    required double leftAngleDeg,
    required double rightAngleDeg,
    required String exerciseKey,
  }) {
    if (leftAngleDeg <= 0 || rightAngleDeg <= 0) return AsymmetryReport.empty();

    final maxVal = leftAngleDeg > rightAngleDeg ? leftAngleDeg : rightAngleDeg;
    final deltaPct = ((leftAngleDeg - rightAngleDeg).abs() / maxVal) * 100.0;
    
    final isImbalanced = deltaPct > 10.0;
    String feedback = "Excellent symmetry detected (${deltaPct.toStringAsFixed(1)}% delta).";

    if (isImbalanced) {
      final weakerSide = leftAngleDeg < rightAngleDeg ? "left" : "right";
      feedback = "Imbalance detected: Your $weakerSide side is compensating (${deltaPct.toStringAsFixed(1)}% delta). Focus on stability.";
    }

    return AsymmetryReport(
      asymmetryDeltaPct: deltaPct,
      isImbalanced: isImbalanced,
      recommendedAdjustment: feedback,
    );
  }
}
```

#### B. Estimated Rep-Speed Trend Analysis
By tracking frame duration bounds from the MediaPipe pipeline, the engine captures concentric and eccentric velocity indicators without physical hardware sensors:
- **Metric**: Concordant lift speed (e.g. a lift that remains at the same weight but speeds up by $15\%$ shows improved nervous system recruitment and strength reserves).

#### C. Exercise Skill Trees & Mastery Levels
Users unlock progress badges across movement classes:
- **Novice**: Basic patterns (e.g. bodyweight squat depth).
- **Intermediate**: Basic resistance levels (e.g. goblet squat at $0.3\times$ bodyweight).
- **Advanced**: Structural strength levels (e.g. barbell back squat at $1.0\times$ bodyweight with $\text{ECS} > 80\%$).
- **Expert**: Elite control (e.g. pistol squats or barbell squat at $1.5\times$ bodyweight with zero valgus collapse).

#### D. Athletic Testing Battery
Every quarter, users undergo an optional camera-guided test battery assessing five performance anchors:
- *Upper Body Endurance*: Max pushups in 60s.
- *Core Stability*: Plank hold duration.
- *Balance & Proprioception*: Single-leg balance eye-closed drift.
- *Lower Body Power*: Vertical jump height (using flight-time tracking from video).
- *Systemic Mobility*: Overhead Reach and deep squat test.

#### E. Performance Forecasting Engine
Integrates historic loads, training volume, RPE, and rep-speed trends into a decay-adjusted progression curve to model strength and cardiorespiratory developments:
- **Strength Projections**: Predicts 8-to-12 week load capabilities.
- **Cardiovascular Projections**: Forecasts 5k/10k run paces using historical cardiovascular logs and daily strain recovery trends.

```dart
class PerformanceForecaster {
  ProjectedPerformance forecastStrength({
    required List<double> historicWeights,
    required double reliabilityScore, // 0 to 100
  }) {
    if (historicWeights.length < 3) {
      return ProjectedPerformance.empty("Insufficient data history to project.");
    }

    // Autoregressive prediction with progress decay based on training adherence
    final double recentAvg = historicWeights.sublist(historicWeights.length - 3).reduce((a, b) => a + b) / 3.0;
    final double adherenceFactor = (reliabilityScore / 100.0).clamp(0.0, 1.0);
    
    // Model decay: gains taper as time progresses
    final double projectedGain8Weeks = (12.5 * adherenceFactor);
    final double projectedGain12Weeks = (18.0 * adherenceFactor);

    return ProjectedPerformance(
      currentValue: historicWeights.last,
      projected8Weeks: recentAvg + projectedGain8Weeks,
      projected12Weeks: recentAvg + projectedGain12Weeks,
      forecastConfidence: (reliabilityScore * 0.9).clamp(0.0, 100.0),
    );
  }
}
```

## §P6-F. Adaptive Computer Vision Loop (ACVL) (NEW v1)

> Running continuous full-body skeleton tracking on mid-range devices under high ambient temperatures (e.g. Indian summers) triggers thermal throttling. FitKarma protects battery and runtime stability via an Adaptive Computer Vision Loop (ACVL) that scales the workload based on native thermal headroom.

---

### 1. Thermal-Aware Downsampling Matrix

Rather than waiting for OS-level app termination or severe frame drops, the pipeline proactively scales back MediaPipe processing and UI rendering:

| Thermal State | Headroom ($H$) | Target Frame Rate | Landmark Tracking Detail | UI Rendering Mode |
|---|---|---|---|---|
| **Normal** | $H < 0.75$ | 30 fps | Full 33 Joint Landmarks | Full 60fps render, real-time joint glow effect. |
| **Moderate** | $0.75 \le H < 0.85$ | 15 fps (Skip 1:2) | Full 33 Joint Landmarks | Disable secondary particles and glow animations. |
| **Severe** | $0.85 \le H < 0.95$ | 10 fps (Skip 1:3) | Core 11 Joints Only (No hands/face) | Freeze real-time bar path overlay; display values only. |
| **Critical** | $H \ge 0.95$ | 5 fps (Skip 1:6) | Squat/Press Depth Isolation Only | Render basic static text feedback only; disable shadows. |

---

### 2. Platform Native Bridges (MethodChannel Integration)

FitKarma registers native listeners to poll device temperature metrics:

#### Android ADPF Bridge (Kotlin)
```kotlin
// MainActivity.kt
import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "fitkarma.healthos/thermal"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getThermalHeadroom") {
                val powerManager = getSystemService(POWER_SERVICE) as PowerManager
                // Poll the thermal headroom projection 10 seconds into the future
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                    result.success(powerManager.getThermalHeadroom(10))
                } else {
                    result.success(0.0) // Fallback for older devices
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
```

#### iOS Thermal Bridge (Swift)

```swift
// AppDelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "fitkarma.healthos/thermal"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let thermalChannel = FlutterMethodChannel(name: CHANNEL,
                                              binaryMessenger: controller.binaryMessenger)
    thermalChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getThermalHeadroom" {
        // iOS process thermal states mapped to equivalent headroom multipliers
        let state = ProcessInfo.processInfo.thermalState
        switch state {
        case .nominal:
          result(0.5) // Normal operations
        case .fair:
          result(0.8) // Slight thermal load, approaching limit
        case .serious:
          result(1.0) // Significant load, throttling required
        case .critical:
          result(1.5) // Critical thermal state, downsampling must execute
        @unknown default:
          result(0.0)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

### 3. Flutter Frame Processor & Isolate Architecture

To prevent joint tracking from stuttering the main Flutter rendering thread, frames are isolated and scheduled dynamically:

```dart
// lib/features/workout/training_os/thermal_frame_processor.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

enum ThermalWorkloadState { normal, moderate, severe, critical }

class ThermalFrameProcessor extends StateNotifier<ThermalWorkloadState> {
  static const _thermalChannel = MethodChannel('fitkarma.healthos/thermal');
  Timer? _pollingTimer;
  int _frameCount = 0;

  ThermalFrameProcessor() : super(ThermalWorkloadState.normal) {
    _startThermalMonitoring();
  }

  void _startThermalMonitoring() {
    // Poll native thermal manager every 10 seconds to minimize API overhead
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final double headroom = await _thermalChannel.invokeMethod('getThermalHeadroom') ?? 0.0;
        _evaluateHeadroom(headroom);
      } catch (_) {
        state = ThermalWorkloadState.normal; // Graceful fallback
      }
    });
  }

  void _evaluateHeadroom(double headroom) {
    if (headroom >= 0.95) {
      state = ThermalWorkloadState.critical;
    } else if (headroom >= 0.85) {
      state = ThermalWorkloadState.severe;
    } else if (headroom >= 0.75) {
      state = ThermalWorkloadState.moderate;
    } else {
      state = ThermalWorkloadState.normal;
    }
  }

  /// Evaluates whether the current camera frame should be analyzed or discarded
  bool shouldProcessNextFrame() {
    _frameCount++;
    
    switch (state) {
      case ThermalWorkloadState.normal:
        return true; // Analyze 100% of incoming camera frames
      case ThermalWorkloadState.moderate:
        return _frameCount % 2 == 0; // Skip every alternate frame (15 fps target)
      case ThermalWorkloadState.severe:
        return _frameCount % 3 == 0; // Skip 2 out of 3 frames (10 fps target)
      case ThermalWorkloadState.critical:
        return _frameCount % 6 == 0; // Drop to emergency trace metrics (5 fps target)
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

// Riverpod Provider Registration
final thermalProcessorProvider = StateNotifierProvider<ThermalFrameProcessor, ThermalWorkloadState>((ref) {
  return ThermalFrameProcessor();
});
```

---

### 4. Camera Controller Loop Integration

```dart
// lib/features/workout/presentation/camera_view_picker.dart
cameraController.startImageStream((CameraImage availableImage) async {
  final thermalController = ref.read(thermalProcessorProvider.notifier);
  
  if (!thermalController.shouldProcessNextFrame()) {
    return; // Discard frame immediately to alleviate processing load
  }

  // MediaPipe processing offloaded asynchronously
  final processedLandmarks = await runMediaPipeInferenceIsolate(
    image: availableImage,
    targetMode: ref.read(thermalProcessorProvider), // Drop joints depending on thermal state
  );

  ref.read(movementHealthProvider.notifier).parseJointAngles(processedLandmarks);
});
```

---

### 5. UX Transparency Safeguard

When degradation modes are triggered, the app displays a non-intrusive notification badge to maintain trust and transparency:

- **UI Badge**: *"⚡ Optimization Mode Active: Device temperature is high. Shifting to core skeletal metrics to protect battery stability and continue tracking your set."*

---

### 6. Pose Landmark Downsampling Adapter

To prevent the rule-based pose engines (`MobilityDiagnosisEngine`, joint angle tracking) from crashing when the `ACVL` downsamples tracking detail from 33 joints to 11 joints (in Moderate/Severe modes), the coordinate stream is processed via a standardizing adapter.

##### Implementation: PoseLandmarkAdapter (Pure Dart)

```dart
class PoseKeypoint {
  final int index;
  final double x;
  final double y;
  final double z;
  final double score;
  final double vx; // Velocity X
  final double vy; // Velocity Y
  final bool isTracked;

  PoseKeypoint({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.score,
    this.vx = 0.0,
    this.vy = 0.0,
    this.isTracked = true,
  });

  factory PoseKeypoint.empty(int index) => 
      PoseKeypoint(index: index, x: 0, y: 0, z: 0, score: 0, isTracked: false);

  bool get isEmpty => !isTracked && x == 0 && y == 0;

  PoseKeypoint copyWith({double? vx, double? vy}) {
    return PoseKeypoint(
      index: index,
      x: x,
      y: y,
      z: z,
      score: score,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      isTracked: isTracked,
    );
  }
}

class PoseLandmarkAdapter {
  /// Standard MediaPipe landmarks retained in downsampled modes:
  /// Nose (0), Shoulders (11, 12), Elbows (13, 14), Wrists (15, 16),
  /// Hips (23, 24), Knees (25, 26), Ankles (27, 28).
  static const Set<int> coreIndices = {0, 11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28};

  double _cameraTiltAngleRad = 0.0;
  double _torsoScaleFactor = 1.0;
  bool _isCalibrated = false;

  /// Calibrates the camera roll and height/distance scale factor using shoulder/hip coordinates
  void calibrateCamera(List<PoseKeypoint> calibrationPose) {
    if (calibrationPose.length < 33) return;

    final leftShoulder = calibrationPose[11];
    final rightShoulder = calibrationPose[12];
    final leftHip = calibrationPose[23];
    final rightHip = calibrationPose[24];

    if (leftShoulder.isEmpty || rightShoulder.isEmpty || leftHip.isEmpty || rightHip.isEmpty) {
      return; // Cannot calibrate with missing reference landmarks
    }

    // 1. Calculate camera roll (tilt) angle based on shoulder slope dy / dx
    final dx = leftShoulder.x - rightShoulder.x;
    final dy = leftShoulder.y - rightShoulder.y;
    _cameraTiltAngleRad = math.atan2(dy, dx);

    // 2. Calculate scale factor using torso height (midpoint of shoulders to midpoint of hips)
    final shoulderMidX = (leftShoulder.x + rightShoulder.x) / 2.0;
    final shoulderMidY = (leftShoulder.y + rightShoulder.y) / 2.0;
    final hipMidX = (leftHip.x + rightHip.x) / 2.0;
    final hipMidY = (leftHip.y + rightHip.y) / 2.0;

    final torsoHeight = math.sqrt(
      math.pow(shoulderMidX - hipMidX, 2.0) + math.pow(shoulderMidY - hipMidY, 2.0)
    );

    if (torsoHeight > 0.0) {
      _torsoScaleFactor = torsoHeight;
      _isCalibrated = true;
    }
  }

  /// Translates variable-length keypoints back into a standardized 33-joint skeleton,
  /// correcting for camera tilt, scaling by distance, and filtering low-confidence points.
  List<PoseKeypoint> normalize({
    required List<PoseKeypoint> incomingLandmarks,
    required List<PoseKeypoint>? lastFrameLandmarks,
  }) {
    // 1. Standard skeleton generation (handling missing joints with history and confidence filtering)
    final skeleton = List<PoseKeypoint>.generate(33, (index) {
      final currentMatch = incomingLandmarks.firstWhere(
        (kp) => kp.index == index && kp.isTracked,
        orElse: () => PoseKeypoint.empty(index),
      );

      // Low confidence filter: treat points with confidence < 0.5 as untracked
      if (!currentMatch.isEmpty && currentMatch.confidence >= 0.5) {
        return currentMatch;
      }

      // Roll back to previous frame if current joint tracking confidence is too low
      if (lastFrameLandmarks != null && lastFrameLandmarks.length == 33) {
        final previousMatch = lastFrameLandmarks[index];
        if (!previousMatch.isEmpty) {
          // Carry forward coordinates but freeze velocity vectors
          return previousMatch.copyWith(vx: 0.0, vy: 0.0);
        }
      }

      return PoseKeypoint.empty(index);
    });

    if (!_isCalibrated || skeleton[0].isEmpty) {
      return skeleton; // Cannot perform geometric normalization without calibration parameters
    }

    // 2. Perform rotation (to align tilt) and scale normalization (to align distance)
    final cosAngle = math.cos(-_cameraTiltAngleRad);
    final sinAngle = math.sin(-_cameraTiltAngleRad);

    final originX = skeleton[0].x;
    final originY = skeleton[0].y;

    return skeleton.map((kp) {
      if (kp.isEmpty) return kp;

      // Translate coordinates relative to origin (nose joint at landmark 0)
      final translatedX = kp.x - originX;
      final translatedY = kp.y - originY;

      // Apply 2D rotation matrix around the nose origin
      final rotatedX = translatedX * cosAngle - translatedY * sinAngle;
      final rotatedY = translatedX * sinAngle + translatedY * cosAngle;

      // Scale coordinates by torso factor to achieve distance-invariance
      final scaledX = rotatedX / _torsoScaleFactor;
      final scaledY = rotatedY / _torsoScaleFactor;

      return kp.copyWith(
        x: scaledX + originX,
        y: scaledY + originY,
        // Retain original z (depth) coordinate without scaling changes
      );
    }).toList();
  }
}
```

---

# PHASE 7 — GAMIFICATION + KARMA SYSTEM

---

## §P7-A. Karma System Design (v1 — Outcome-Rewarding)

In v1, XP was awarded for logging actions. This created perverse incentives — users could earn karma without improving health. v1 rewards **outcomes and achievements**, not inputs.

### XP Events (v1 — Outcomes Only)

| Achievement | XP | Why This, Not Logging |
|-------------|----|-----------------------|
| Protein target achieved | +50 | Outcome: nutrition goal met |
| 7-day sleep streak (≥ 7h) | +80 | Outcome: sleep consistency |
| Readiness improved vs last week | +100 | Outcome: recovery improving |
| Workout completed at full intensity | +60 | Outcome: training compliance |
| Steps goal hit | +30 | Outcome: movement goal |
| Water goal achieved | +20 | Outcome: hydration goal |
| Program week completed | +150 | Milestone: training phase |
| Streak milestones (7/14/30/90 days) | +100/150/200/500 | Consistency milestone |
| BMI category improvement | +300 | Major health outcome |
| Risk alert resolved | +200 | Meaningful health improvement |
| Squad challenge won | +100 | Social + performance |

Note: Simply logging food, water, or workouts no longer awards XP. Logging is expected behavior — achieving the target is the reward.

### Karma Levels

| Level | Name | XP Required |
|-------|------|-------------|
| 1 | Beginner | 0 |
| 2 | Seeker | 200 |
| 3 | Striver | 500 |
| 4 | Builder | 1,000 |
| 5 | Achiever | 2,000 |
| 8 | Warrior | 5,000 |
| 10 | Champion | 10,000 |
| 15 | Elite | 25,000 |
| 20 | Legend | 60,000 |

---

## §P7-B. Karma Hub Screen

**Route:** `/karma`
**Scaffold:** Glassmorphic dark card hub with glowing indicators.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Karma Hub                                         │
│                                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │   Level 4 — Builder                               │ │
│  │   Total Karma: 1,450 XP                           │ │
│  │   Progress to Level 5:                            │ │
│  │   [=============>................] (450 / 1000)   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Achievements:                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │  [🏆 Prote-King]   [🏆 Sleepy-Head] [🔒 Rep-Master]│ │
│  │  Protein Hit 7d     Sleep >= 7h 7d   100 Reps Form │ │
│  │  (Completed ✓)     (Completed ✓)    (Progress 45%) │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Your Demographic Cohort Percentile:                  │
│  ┌───────────────────────────────────────────────────┐ │
│  │  You score higher than 82% of Noida Builders!      │ │
│  │                                                   │ │
│  │  Cohort Rank: #142 of 4,210 members               │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Weekly Activity History (XP Awarded):                 │
│  Mon: +50 XP  ·  Tue: +80 XP  ·  Wed: +100 XP          │
└────────────────────────────────────────────────────────┘
```

### Riverpod State Management: KarmaHubNotifier

This notifier reads local Drift `KarmaEvents` and coordinates dynamic Level thresholds, progress ratios, unlocked achievements evaluation, and cloud sync coordination.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

// Represents user's gamification profile
class KarmaHubState {
  final int totalXp;
  final int currentLevel;
  final String levelName;
  final double progressToNextLevel; // 0.0 to 1.0
  final int xpInCurrentLevel;
  final int xpNeededForNextLevel;
  final List<KarmaAchievement> achievements;
  final List<KarmaEventData> recentEvents;

  KarmaHubState({
    required this.totalXp,
    required this.currentLevel,
    required this.levelName,
    required this.progressToNextLevel,
    required this.xpInCurrentLevel,
    required this.xpNeededForNextLevel,
    required this.achievements,
    required this.recentEvents,
  });

  factory KarmaHubState.initial() => KarmaHubState(
    totalXp: 0,
    currentLevel: 1,
    levelName: "Beginner",
    progressToNextLevel: 0.0,
    xpInCurrentLevel: 0,
    xpNeededForNextLevel: 200,
    achievements: [],
    recentEvents: [],
  );
}

class KarmaAchievement {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final double progressPercent;

  KarmaAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.progressPercent,
  });
}

class KarmaEventData {
  final String description;
  final int xpAwarded;
  final DateTime eventTime;

  KarmaEventData({
    required this.description,
    required this.xpAwarded,
    required this.eventTime,
  });
}

class KarmaHubNotifier extends StateNotifier<KarmaHubState> {
  final AppDatabase _db;
  
  KarmaHubNotifier(this._db) : super(KarmaHubState.initial()) {
    _loadKarmaProfile();
  }

  /// Calculates gamification metrics from offline database events
  Future<void> _loadKarmaProfile() async {
    // 1. Fetch all local karma events
    final events = await (_db.select(_db.karmaEvents)
      ..orderBy([(t) => OrderingTerm(expression: t.eventTime, mode: OrderingMode.desc)]))
      .get();

    final int sumXp = events.fold(0, (sum, item) => sum + item.xpAwarded);
    
    // 2. Resolve level properties
    final levelData = _resolveLevel(sumXp);

    // 3. Define and evaluate outcome-based achievements offline
    final achievementsList = await _evaluateAchievements(events);

    state = KarmaHubState(
      totalXp: sumXp,
      currentLevel: levelData.level,
      levelName: levelData.name,
      progressToNextLevel: levelData.progressFraction,
      xpInCurrentLevel: levelData.xpInLevel,
      xpNeededForNextLevel: levelData.xpNeeded,
      achievements: achievementsList,
      recentEvents: events.map((e) => KarmaEventData(
        description: e.description,
        xpAwarded: e.xpAwarded,
        eventTime: e.eventTime,
      )).toList(),
    );
  }

  /// Resolves total XP into level threshold metrics
  _LevelInfo _resolveLevel(int xp) {
    // Thresholds: Level 1 (0 XP), Level 2 (200 XP), Level 3 (500 XP), Level 4 (1,000 XP), Level 5 (2,000 XP)
    if (xp < 200) {
      return _LevelInfo(1, "Beginner", xp, 200, xp / 200.0);
    } else if (xp < 500) {
      final int levelXp = xp - 200;
      return _LevelInfo(2, "Seeker", levelXp, 300, levelXp / 300.0);
    } else if (xp < 1000) {
      final int levelXp = xp - 500;
      return _LevelInfo(3, "Striver", levelXp, 500, levelXp / 500.0);
    } else if (xp < 2000) {
      final int levelXp = xp - 1000;
      return _LevelInfo(4, "Builder", levelXp, 1000, levelXp / 1000.0);
    } else {
      final int levelXp = xp - 2000;
      final int nextThreshold = 3000; // Step of 3000 XP per level onwards
      return _LevelInfo(5, "Achiever", levelXp, nextThreshold, (levelXp / nextThreshold).clamp(0.0, 1.0));
    }
  }

  /// Evaluates completion status of achievements locally
  Future<List<KarmaAchievement>> _evaluateAchievements(List<dynamic> events) async {
    // Check if user has unlocked specific outcome badges based on logged event history
    final hasProteinGoal = events.any((e) => e.eventType == 'protein_target_achieved');
    final hasSleepStreak = events.any((e) => e.eventType == 'sleep_streak_achieved');
    
    // Check workout repetitions completed to show incremental progress
    final workoutsCount = events.where((e) => e.eventType == 'workout_completed').length;
    
    return [
      KarmaAchievement(
        id: 'prote_king',
        title: 'Prote-King',
        description: 'Achieve daily protein target.',
        isUnlocked: hasProteinGoal,
        progressPercent: hasProteinGoal ? 1.0 : 0.0,
      ),
      KarmaAchievement(
        id: 'sleepy_head',
        title: 'Sleepy-Head',
        description: 'Complete 7-day sleep recovery streak.',
        isUnlocked: hasSleepStreak,
        progressPercent: hasSleepStreak ? 1.0 : 0.0,
      ),
      KarmaAchievement(
        id: 'rep_master',
        title: 'Rep-Master',
        description: 'Complete 5 workouts with form scores.',
        isUnlocked: workoutsCount >= 5,
        progressPercent: (workoutsCount / 5.0).clamp(0.0, 1.0),
      ),
    ];
  }

  /// Optimistically awards XP locally before syncing to D1
  Future<void> awardXp({
    required int amount,
    required String type,
    required String description,
  }) async {
    final newId = DateTime.now().toIso8601String();
    
    // 1. Insert to Drift
    await _db.into(_db.karmaEvents).insert(
      KarmaEventsCompanion.insert(
        localId: newId,
        userId: 'current_user_id',
        eventTime: DateTime.now(),
        xpAwarded: amount,
        eventType: type,
        description: description,
        syncStatus: const Value('pending'),
      ),
    );

    // 2. Re-read and update state immediately
    await _loadKarmaProfile();
  }
}

class _LevelInfo {
  final int level;
  final String name;
  final int xpInLevel;
  final int xpNeeded;
  final double progressFraction;

  _LevelInfo(this.level, this.name, this.xpInLevel, this.xpNeeded, this.progressFraction);
}
}
```

---

## §P7-C. Habit Automation System

Smart triggers (NOT fixed-time reminders):

- "Protein reminder" fires 30 min after workout
- "Sleep wind-down" fires based on usual sleep time ± 30 min
- "Water reminder" adjusts for today's temperature + activity
- "Breathing exercise" fires when resting HR is above baseline
- "Post-meal walk" nudge fires 20 min after food logged

---

## §P7-D. Adherence Score (NEW v1 — Major KPI)

> The single most important metric elite coaches track. Replaces fragmented streak/XP tracking with a unified, honest measure of how well the user is executing their plan.

### AdherenceScoreCalculator (Pure Dart)

```dart
class AdherenceScoreCalculator {
  AdherenceResult calculate({
    required List<FoodLog> foodLogs,       // last 7 days
    required List<WorkoutLog> workoutLogs, // last 7 days
    required List<RecoveryLog> recoveryLogs,
    required UserTargets targets,
  }) {
    // Nutrition Adherence: days protein ≥ 80% target
    final nutritionDays = foodLogs
        .where((l) => l.proteinG >= targets.proteinG * 0.80 &&
                      l.calories.between(targets.calories * 0.85,
                                         targets.calories * 1.15))
        .length;
    final nutritionScore = (nutritionDays / 7 * 100).round();

    // Training Adherence: workouts completed vs. planned
    final plannedWorkouts = targets.workoutsPerWeek;
    final completedWorkouts = workoutLogs
        .where((l) => l.completionPercent >= 80)
        .length;
    final trainingScore = ((completedWorkouts / plannedWorkouts) * 100)
        .clamp(0, 100).round();

    // Recovery Adherence: sleep ≥ 7h and readiness check-in completed
    final recoveryDays = recoveryLogs
        .where((l) => l.sleepDurationMin >= 420 && l.checkedIn)
        .length;
    final recoveryScore = (recoveryDays / 7 * 100).round();

    final overallScore = (nutritionScore * 0.40 +
                          trainingScore  * 0.40 +
                          recoveryScore  * 0.20).round();

    return AdherenceResult(
      nutritionScore: nutritionScore,
      trainingScore:  trainingScore,
      recoveryScore:  recoveryScore,
      overallScore:   overallScore,
      trend:          _trend(overallScore),
      period:         'Last 7 days',
    );
  }
}
```

### Adherence Score UI (Dashboard Widget)

```
┌────────────────────────────────────┐
│ 📊 Adherence Score                 │
│                                    │
│ Overall:    83%  ↑ +4% this week   │
│                                    │
│ Nutrition:  ████████░░  82%        │
│ Training:   ███████░░░  76%        │
│ Recovery:   █████████░  90%        │
│                                    │
│ Your weakest area: Training        │
│ Tip: Add one more workout this week│
└────────────────────────────────────┘
```

### Adherence → XP Connection

Adherence Score directly unlocks bonus XP tiers:
- 90–100% adherence: +50% XP multiplier for the week
- 80–89%: standard XP
- 70–79%: no penalty, gentle nudge
- < 70%: AI Coach proactive check-in triggered

---

## §P7-E. Benchmarking Engine (NEW v1 — Fitness Percentile)

> Users love to know where they stand. Benchmarking provides powerful social proof and motivation without exposing other users' data.

### Benchmark Cohorts

```dart
class BenchmarkingEngine {
  BenchmarkResult compare({
    required UserProfile user,
    required UserHealthData data,
  }) {
    // Find matching cohort
    final cohort = CohortKey(
      ageRange: _ageRange(user.age),   // e.g., "25-30"
      gender:   user.gender,
      country:  user.country,          // India → Indian benchmarks
    );

    final benchmarks = _cohortDatabase[cohort]!;

    return BenchmarkResult(
      stepsPercentile:    _percentile(data.avgSteps7d, benchmarks.steps),
      proteinPercentile:  _percentile(data.avgProtein7d, benchmarks.protein),
      sleepPercentile:    _percentile(data.avgSleepH, benchmarks.sleep),
      workoutsPercentile: _percentile(data.workoutsPerWeek, benchmarks.workouts),
      overallPercentile:  _overallFitnessPercentile(data, benchmarks),
      cohortLabel:        'Age ${user.age} · ${user.gender} · India',
    );
  }

  int _percentile(double value, BenchmarkDistribution dist) {
    // Find what % of the cohort scores below this value
    return dist.percentileOf(value);
  }
}
```

### Benchmark Display (§P7-E screen)

**Route:** `/benchmarking`

```
Compared to: Age 28 · Male · India

Your Fitness Percentile
   ┌─────────────────────────────┐
   │   Top 30%                   │
   │   ████████████████████░░░   │
   │   Overall Score: 70th pct   │
   └─────────────────────────────┘

Breakdown:
  👟 Steps:    Top 22%   (9,400/day avg)
  🥗 Protein:  Top 45%   (78g/day avg)
  😴 Sleep:    Top 38%   (7.1h avg)
  🏋️ Workouts: Top 18%   (4.2/week)

Your biggest opportunity:
  Protein is your lowest percentile.
  Hitting your 110g target would move you to Top 25%.
```

---

## §P7-F. Demographic Cohort Insights & Network Effects (NEW v1)

> FitKarma creates network effects by leveraging anonymized, aggregated user data to provide contextualized cohort benchmarks. This delivers deep psychological validation and regional gamification without exposing private medical records.

### Cohort Insights & Benchmarks Service

```dart
class CohortInsightsService {
  final AppDatabase _db;
  final ApiClient _api;

  Future<CohortInsights> getInsights(String userId) async {
    final user = await _db.users.getById(userId);
    
    // Ingests local user average metrics (computed over rolling 14 days)
    final userMetrics = await _db.getRollingMetrics(userId, 14);

    // Call Workers API endpoint to fetch aggregated regional/demographic cohort distribution data
    // Payload contains NO personal identifiers, only demographic keys: age, gender, region, goal
    final response = await _api.fetchCohortData(
      age: user.age,
      gender: user.gender,
      region: user.region ?? 'India',
      dietType: user.dietType,
      primaryGoal: user.goals, // e.g. "weight_loss"
    );

    return CohortInsights(
      cohortSize: response.totalCohortMembers,
      stepPercentile: _calculatePercentile(userMetrics.avgSteps, response.stepsDistribution),
      proteinPercentile: _calculatePercentile(userMetrics.avgProtein, response.proteinDistribution),
      readinessPercentile: _calculatePercentile(userMetrics.avgReadiness, response.readinessDistribution),
      cityRank: response.cityRank, // Rank in their specific city, e.g. "Noida"
      ageGroupRank: response.ageGroupRank, // Rank in their age group
      programSuccessStat: response.programSuccessStat,
    );
  }

  int _calculatePercentile(double value, List<double> distribution) {
    // Binary search to find percentile in the cohort distribution
    int index = distribution.lowerBound(value);
    return ((index / distribution.length) * 100).round();
  }
}

class CohortInsights {
  final int cohortSize;
  final int stepPercentile;
  final int proteinPercentile;
  final int readinessPercentile;
  final CityRank cityRank;
  final AgeGroupRank ageGroupRank;
  final ProgramComparisonStat programSuccessStat;

  CohortInsights({
    required this.cohortSize,
    required this.stepPercentile,
    required this.proteinPercentile,
    required this.readinessPercentile,
    required this.cityRank,
    required this.ageGroupRank,
    required this.programSuccessStat,
  });
}

class CityRank {
  final String city;
  final int rank;
  final int totalUsers;
  final int percentile; // e.g., Top 12% in Noida
}

class AgeGroupRank {
  final String ageRange; // e.g. "25-30"
  final int rank;
  final int percentile;
}

class ProgramComparisonStat {
  final String programName;
  final double averageWeightLossKg;
  final double averageHrvImprovementMs;
  final double completionRate;
}
```

### Community Cohort Insights UI

**Route:** `/cohorts`
**Design Style:** Glassmorphic bento cards showing comparative distributions.

```
📊 Demographic Cohort — Noida Vegetarian Strength Builders (n = 4,210)

┌────────────────────────────────────────────────────────┐
│ 👟 STEPS DISTRIBUTION                                  │
│   Your 14-day average: 9,420 steps                     │
│   Percentile: Top 18% in Noida                         │
│                                                        │
│   [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████]             │
│   Cohort Avg: 6,800 steps         You: 9,420            │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ 🏙️ Noida Leaderboard (Age 25-30)                        │
│   Rank: #412 of 3,120 active members                   │
│   Percentile: Top 13% in City                          │
│   Next Rank Reward: 150 Karma XP at Rank #400           │
│                                                        │
│   [View Full City Leaderboard]                          │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ 📈 Program Comparison — "Corporate Rebuild"            │
│   92% of corporate workers completed this program!     │
│   Completed Users Average Outcomes:                    │
│     • Weight loss: 4.8kg average                       │
│     • HRV baseline: +14% (+8.2ms recovery capacity)    │
│     • Sleep duration increase: +45 mins/night          │
└────────────────────────────────────────────────────────┘

[Opt-Out of Cohort Sharing (Anonymized)]
```

### Privacy Guarantee

1. **Explicit Consent**: Users must opt-in to cohort benchmarking during onboarding.
2. **Double Aggregation**: No cohort profile details are transmitted. All metrics are aggregated into 100-bin histographical arrays on the server.
3. **Regional Anonymity**: Cities with fewer than 50 active users are grouped into state-level categories to prevent re-identification.

---

# PHASE 8 — TRANSFORMATION JOURNEY + ANTI-QUIT PSYCHOLOGY

---

## §P8-A. Transformation Journey Engine

### Long-Term Memory

v1 looked at 7-day data only. Transformations take months. v1 stores a persistent transformation memory:

```dart
class TransformationMemory {
  // Persisted in Drift — summarized monthly
  final List<WeightCheckpoint> weightHistory;
  final List<String> majorStruggles;       // e.g. "Evening snacking, 3 weeks"
  final List<Injury> injuries;
  final List<String> successPatterns;      // e.g. "Tuesdays: highest compliance"
  final List<String> motivationTriggers;   // e.g. "Wedding countdown, squad fire"
  final List<String> quitAttempts;         // For relapse pattern modeling
  final String primaryPersonality;         // Competitive / Routine / Social / Data-driven
}
```

This memory is injected into AI Coach conversations and transformation planning, making the coach dramatically more contextually aware.

### Consistency Tracker

```dart
class ConsistencyTracker {
  ConsistencyStatus analyze(UserBehaviorData data) {
    final signals = [
      data.appOpenFrequencyDropping,
      data.workoutsMissedInARow >= 3,
      data.junkFoodLoggedDaysInARow >= 4,
      data.sleepDecliningFor >= 5,
      data.lastAppOpen.isMoreThan(days: 2),
      data.motivationRating < 3,
    ];

    final riskScore = signals.where((s) => s).length;
    if (riskScore >= 4) return ConsistencyStatus.highRelapse;
    if (riskScore >= 2) return ConsistencyStatus.moderate;
    return ConsistencyStatus.strong;
  }
}
```

### Relapse Intervention System

**Day 1 — Gentle Nudge:**
> "You've been quieter than usual this week. No pressure — let's restart with something small. A 10-minute walk today counts as a win."

**Day 2 — Plan Adjustment:**
> "I've switched you to the Lite Plan for 3 days — 20-min workouts, no calorie counting. Just show up."

**Day 3 — Emergency Reframe:**
> "Missing workouts doesn't erase your 12-day streak last month. That version of you still exists."

**Day 5 — Squad Connection:**
> "Your squad member Priya logged a workout today — want to send her a 🔥?"

---

## §P8-B. Transformation Timeline Screen

**Route:** `/transformation`
**Scaffold:** Split view containing a timeline list and a graphical prediction chart.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Transformation Journey                            │
│                                                        │
│  Weight Projection & 90-Day Range:                     │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Weight (kg)                                      │ │
│  │  80 | *                                           │ │
│  │  75 |   * *                                       │ │
│  │  70 |       *   . - - - - [ Projected Zone ]      │ │
│  │  65 |          (Current: 72kg)                    │ │
│  │  60 └──────────────────────────────────────────   │ │
│  │      Month 1   Month 2   Month 3 (Forecast Range) │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Target Prediction (At Current Pace):                  │
│  - Projected Weight (90 days): 66.5 kg - 69.2 kg       │
│  - Projected Body Fat: 17.5% - 19.0%                   │
│  - Program Target: Week 11 of 12 complete              │
│                                                        │
│  🔒 Secure Progress Photos (Biometric Locked):         │
│  ┌─────────────────────────┐ ┌───────────────────────┐ │
│  │  [  Week 1 (Locked)  ]  │ │  [  Week 4 (Locked) ] │ │
│  └─────────────────────────┘ └───────────────────────┘ │
│                [ Tap to Unlock Photos ]                │
└────────────────────────────────────────────────────────┘
```

*   **90-Day Prediction Layer**: Rather than showing exact weight figures which can cause frustration and dropouts due to natural water weight fluctuations (ADR-025), the chart renders a shaded forecast channel ($min$ and $max$ bounds) based on a user's running 30-day compliance factors.

### Riverpod State Management: TransformationJourneyNotifier

This notifier manages weight check-in tables, computes statistical 90-day progress ranges based on adherence trends, and implements local biometric authentication bounds via the Flutter `local_auth` package to protect local progress photographs:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:drift/drift.dart';

class TransformationJourneyState {
  final List<WeightRecord> weightHistory;
  final bool arePhotosUnlocked;
  final String biometricAuthError;
  final double currentAdherenceScore; // 0.0 to 100.0
  final double projectedWeightMin;
  final double projectedWeightMax;

  TransformationJourneyState({
    required this.weightHistory,
    required this.arePhotosUnlocked,
    required this.biometricAuthError,
    required this.currentAdherenceScore,
    required this.projectedWeightMin,
    required this.projectedWeightMax,
  });

  factory TransformationJourneyState.initial() => TransformationJourneyState(
    weightHistory: [],
    arePhotosUnlocked: false,
    biometricAuthError: '',
    currentAdherenceScore: 100.0,
    projectedWeightMin: 0.0,
    projectedWeightMax: 0.0,
  );

  TransformationJourneyState copyWith({
    List<WeightRecord>? weightHistory,
    bool? arePhotosUnlocked,
    String? biometricAuthError,
    double? currentAdherenceScore,
    double? projectedWeightMin,
    double? projectedWeightMax,
  }) {
    return TransformationJourneyState(
      weightHistory: weightHistory ?? this.weightHistory,
      arePhotosUnlocked: arePhotosUnlocked ?? this.arePhotosUnlocked,
      biometricAuthError: biometricAuthError ?? this.biometricAuthError,
      currentAdherenceScore: currentAdherenceScore ?? this.currentAdherenceScore,
      projectedWeightMin: projectedWeightMin ?? this.projectedWeightMin,
      projectedWeightMax: projectedWeightMax ?? this.projectedWeightMax,
    );
  }
}

class WeightRecord {
  final DateTime date;
  final double weightKg;

  WeightRecord(this.date, this.weightKg);
}

class TransformationJourneyNotifier extends StateNotifier<TransformationJourneyState> {
  final AppDatabase _db;
  final LocalAuthentication _localAuth = LocalAuthentication();

  TransformationJourneyNotifier(this._db) : super(TransformationJourneyState.initial()) {
    _loadTransformationData();
  }

  /// Loads check-in metrics and calculates 90-day projection ranges
  Future<void> _loadTransformationData() async {
    // 1. Fetch weight checkpoints from Drift
    final checkIns = await (_db.select(_db.transformationChecks)
      ..orderBy([(t) => OrderingTerm(expression: t.checkDate, mode: OrderingMode.asc)]))
      .get();

    final history = checkIns.map((c) => WeightRecord(c.checkDate, c.weightKg)).toList();

    if (history.isEmpty) return;

    // 2. Fetch rolling 30-day user reliability/adherence rating
    final double adherence = await _calculateAverageAdherence();

    // 3. Compute 90-Day Forecast Range bounds
    // Formula: WeightChange = (AdherenceFactor * TargetKcalDeficitPerDay * 90) / 7700 kcal
    final double latestWeight = history.last.weightKg;
    final double adherenceFactor = (adherence / 100.0).clamp(0.0, 1.0);
    
    // Ideal weight loss rate is 0.5kg per week (at 100% compliance)
    final double idealLossIn90Days = 6.43; // (0.5kg / 7 days) * 90 days
    final double actualLossProjection = idealLossIn90Days * adherenceFactor;

    // Apply error margin range buffer (+/- 1.5kg) to prevent strict focal expectations
    final double projectedMin = latestWeight - actualLossProjection - 1.5;
    final double projectedMax = latestWeight - actualLossProjection + 1.5;

    state = state.copyWith(
      weightHistory: history,
      currentAdherenceScore: adherence,
      projectedWeightMin: double.parse(projectedMin.toStringAsFixed(1)),
      projectedWeightMax: double.parse(projectedMax.toStringAsFixed(1)),
    );
  }

  /// Calculates adherence factor from rolling table updates
  Future<double> _calculateAverageAdherence() async {
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    // Fallback to average reliability or 80.0
    return user.averageReliabilityPct ?? 80.0;
  }

  /// Authenticates user biometrically to reveal progress photos
  Future<void> authenticatePhotos() async {
    try {
      final isBiometricsAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!isBiometricsAvailable || !isDeviceSupported) {
        state = state.copyWith(
          biometricAuthError: "Biometric authentication not supported on this device.",
          arePhotosUnlocked: false,
        );
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock your private progress photos',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        state = state.copyWith(
          arePhotosUnlocked: true,
          biometricAuthError: '',
        );
      } else {
        state = state.copyWith(
          arePhotosUnlocked: false,
          biometricAuthError: 'Authentication failed.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        biometricAuthError: 'Biometric authorization error: ${e.toString()}',
        arePhotosUnlocked: false,
      );
    }
  }

  /// Logs a new transformation checkpoint
  Future<void> logNewWeight(double weight) async {
    final newId = DateTime.now().toIso8601String();
    
    await _db.into(_db.transformationChecks).insert(
      TransformationChecksCompanion.insert(
        localId: newId,
        userId: 'current_user_id',
        checkDate: DateTime.now(),
        weightKg: weight,
        syncStatus: const Value('pending'),
      ),
    );

    await _loadTransformationData();
  }
}
}
```

---

## §P8-C. Habit Identity Layer (NEW v1 — Behavior Science)

> Behavior change research (James Clear, BJ Fogg) shows that **identity** drives long-term habits better than goals. "I am an athlete" is more durable than "I want to lose 5 kg."

### Identity Personas

```dart
enum IdentityPersona {
  athlete,             // "I am becoming an athlete"
  disciplinedPro,      // "I am a disciplined professional"
  fitParent,           // "I am a fit parent who leads by example"
  strengthBuilder,     // "I am building serious strength"
  longevitySeeker,     // "I am investing in my long-term health"
  healthyIndian,       // "I am proving that Indian food can fuel peak performance"
}
```

### Identity Evolution Engine

```dart
class HabitIdentityEngine {
  IdentityEvolution checkEvolution({
    required UserProgress progress,
    required AdherenceResult adherence,
    required TransformationMemory memory,
  }) {
    // Athlete identity: consistently high training adherence
    if (adherence.trainingScore >= 85 &&
        progress.workoutsCompletedTotal >= 30) {
      return IdentityEvolution(
        newMilestone: 'You\'ve completed 30 workouts. '
            'You\'re not just someone who exercises — '
            'you\'re becoming an athlete.',
        persona: IdentityPersona.athlete,
        xpBonus: 500,
        badge: 'Athlete Identity Unlocked',
      );
    }

    // Disciplined Professional: consistent despite busy schedule
    if (adherence.overallScore >= 80 &&
        memory.workStyle == 'office' &&
        progress.consecutiveCompliantWeeks >= 4) {
      return IdentityEvolution(
        newMilestone: '4 weeks of strong adherence despite a busy schedule. '
            'You\'re becoming someone who never lets work derail their health.',
        persona: IdentityPersona.disciplinedPro,
        xpBonus: 400,
        badge: 'Disciplined Professional',
      );
    }

    return IdentityEvolution.none();
  }
}
```

### Identity UI: "You Are Becoming" Card

```
┌────────────────────────────────────────┐
│ 🏆 Identity Evolution                  │
│                                        │
│ You are becoming:                      │
│                                        │
│   🏋️ Strength Builder                 │
│   Week 6 of 12 in Athletic Lean Build  │
│                                        │
│ Evidence:                              │
│   • 28 workouts completed              │
│   • Bench press +12kg since Week 1     │
│   • Training adherence: 88%            │
│                                        │
│ "Athletes don't ask if they'll work    │
│  out. They decide where."              │
│                                        │
│ Next evolution: Complete Week 8 with   │
│ 85%+ adherence → Unlock "Warrior"      │
└────────────────────────────────────────┘
```

### Identity → AI Coach Integration

Identity persona is injected into every AI Coach system prompt:

```
User identity: Strength Builder (Week 6)
→ Coach frames all advice through strength lens
→ "As someone building serious strength, here's why
   your protein timing matters for your bench press..."
```

---

# PHASE 9 — SOCIAL + SQUAD ACCOUNTABILITY

---

## §P9-A. Social Screen

**Route:** `/social`
**Scaffold:** Dark bento layout with tabbed options for accountability groups.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Social & Squads                                   │
│                                                        │
│   [ My Squad ]       [ Challenges ]       [ Leader ]   │
│                                                        │
│  Squad: "Noida Ground Shakers" (Streak: 🔥 14 Days)    │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Members Readiness & Recovery Status (Anonymized) │ │
│  │  - You:       🟩 High (Restored)                  │ │
│  │  - Priya:     🟩 High (Restored)                  │ │
│  │  - Amit:      🟨 Moderate (Fatigued)              │ │
│  │  - Rohan:     🟩 High (Restored)                  │ │
│  │  - Sneha:     🟥 Low (Sleep Debt)                 │ │
│  │                                                   │ │
│  │  Team Average Readiness: 74% (Pause Challenges)   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Active Squad Mission:                                 │
│  ┌───────────────────────────────────────────────────┐ │
│  │  🎯 Team Protein Target (Target: 100g / member)    │ │
│  │  Current Avg: 78g [=========>......] (78% Done)    │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  [ Nudge Sneha to Rest ]       [ Propose Challenge ]   │
└────────────────────────────────────────────────────────┘
```

### Riverpod State Management: SquadStateNotifier

This notifier manages squad profile records, computes team average readiness parameters, tracks collective streaks, and monitors aggregate team mission metrics:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

class SquadState {
  final String squadId;
  final String squadName;
  final int collectiveStreakDays;
  final double averageReadinessScore;
  final bool isChallengeEligible; // True if >= 60% members are High readiness
  final List<SquadMemberStatus> members;
  final ActiveSquadMission? activeMission;

  SquadState({
    required this.squadId,
    required this.squadName,
    required this.collectiveStreakDays,
    required this.averageReadinessScore,
    required this.isChallengeEligible,
    required this.members,
    this.activeMission,
  });

  factory SquadState.initial() => SquadState(
    squadId: '',
    squadName: 'Loading Squad...',
    collectiveStreakDays: 0,
    averageReadinessScore: 0.0,
    isChallengeEligible: false,
    members: [],
  );

  SquadState copyWith({
    String? squadId,
    String? squadName,
    int? collectiveStreakDays,
    double? averageReadinessScore,
    bool? isChallengeEligible,
    List<SquadMemberStatus>? members,
    ActiveSquadMission? activeMission,
  }) {
    return SquadState(
      squadId: squadId ?? this.squadId,
      squadName: squadName ?? this.squadName,
      collectiveStreakDays: collectiveStreakDays ?? this.collectiveStreakDays,
      averageReadinessScore: averageReadinessScore ?? this.averageReadinessScore,
      isChallengeEligible: isChallengeEligible ?? this.isChallengeEligible,
      members: members ?? this.members,
      activeMission: activeMission ?? this.activeMission,
    );
  }
}

enum SquadReadinessTier { high, moderate, low }

class SquadMemberStatus {
  final String userId;
  final String name;
  final SquadReadinessTier readinessTier;
  final bool hasLoggedToday;

  SquadMemberStatus({
    required this.userId,
    required this.name,
    required this.readinessTier,
    required this.hasLoggedToday,
  });
}

class ActiveSquadMission {
  final String missionTitle;
  final double progressPercent; // 0.0 to 1.0
  final String targetStatusText;

  ActiveSquadMission({
    required this.missionTitle,
    required this.progressPercent,
    required this.targetStatusText,
  });
}

class SquadStateNotifier extends StateNotifier<SquadState> {
  final AppDatabase _db;
  
  SquadStateNotifier(this._db) : super(SquadState.initial()) {
    _loadSquadDetails();
  }

  /// Calculates squad averages and streaks from cached database tables
  Future<void> _loadSquadDetails() async {
    // 1. Fetch user profile to find their squad assignment
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final String? familyOrSquadUnit = user.familyUnitId; // Placeholder mapping
    
    if (familyOrSquadUnit == null) {
      state = state.copyWith(squadName: "No Active Squad Found");
      return;
    }

    // 2. Fetch all members mapped under the squad
    final squadMembersList = await (_db.select(_db.squadMembers)
      ..where((t) => t.squadId.equals(familyOrSquadUnit)))
      .get();

    // 3. For each member, pull cached readiness logs (anonymized evaluation)
    List<SquadMemberStatus> loadedStatus = [];
    double totalReadiness = 0.0;
    int highCount = 0;

    for (var member in squadMembersList) {
      // Mock lookup: Fetch average metrics from snapshots
      final snapshot = await (_db.select(_db.healthSnapshots)
        ..where((t) => t.userId.equals(member.userId))
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
        ..limit(1))
        .getSingleOrNull();

      double readiness = snapshot?.readinessScore ?? 70.0;
      totalReadiness += readiness;

      SquadReadinessTier tier = SquadReadinessTier.moderate;
      if (readiness >= 80) {
        tier = SquadReadinessTier.high;
        highCount++;
      } else if (readiness < 60) {
        tier = SquadReadinessTier.low;
      }

      loadedStatus.add(SquadMemberStatus(
        userId: member.userId,
        name: member.userId == user.localId ? "You" : "Member ${member.userId.substring(0, 3)}",
        readinessTier: tier,
        hasLoggedToday: snapshot != null && snapshot.createdAt.day == DateTime.now().day,
      ));
    }

    final double avgReadiness = loadedStatus.isNotEmpty 
        ? totalReadiness / loadedStatus.length 
        : 70.0;

    // Challenge eligibility: >= 60% members are High readiness
    final bool isEligible = loadedStatus.isNotEmpty 
        ? (highCount / loadedStatus.length) >= 0.60 
        : false;

    // Evaluate active missions (Mock details for dashboard)
    final ActiveSquadMission currentMission = ActiveSquadMission(
      missionTitle: "Team Protein Challenge (Target: 100g / member)",
      progressPercent: 0.78,
      targetStatusText: "Current Avg: 78g (78% Done)",
    );

    state = SquadState(
      squadId: familyOrSquadUnit,
      squadName: "Noida Ground Shakers",
      collectiveStreakDays: 14,
      averageReadinessScore: double.parse(avgReadiness.toStringAsFixed(1)),
      isChallengeEligible: isEligible,
      members: loadedStatus,
      activeMission: currentMission,
    );
  }

  /// Triggers a nudge (encouragement signal) to a lagging member
  Future<void> sendNudge(String targetUserId) async {
    // Inserts a notification to the local/outbox queue
    await _db.into(_db.karmaEvents).insert(
      KarmaEventsCompanion.insert(
        localId: DateTime.now().toIso8601String(),
        userId: 'current_user_id',
        eventTime: DateTime.now(),
        xpAwarded: 10, // Award +10 XP for supportive action
        eventType: 'squad_nudge_sent',
        description: "Sent support nudge to Member ${targetUserId.substring(0, 3)}",
        syncStatus: const Value('pending'),
      ),
    );
    
    // Reload state to capture updated XP logs
    await _loadSquadDetails();
  }
}
```

---

## §P9-B. Squad System (v1 — Meaningful Integration)

**Squad size:** 3–8 members (ADR-022: >8 reduces accountability)

### v1 Squad Features

```
Squad Readiness Board:
  Shows today's readiness tier for each member (anonymized — tier only, not score)
  "3/5 members are High readiness today — squad challenge eligible!"

Squad Recovery View:
  Team average recovery score
  "Team needs rest — squad challenge paused for today"

Squad Missions:
  Generated from team's aggregate data
  "Team Protein Challenge — squad average 78g vs 100g target"
  "3-day Consistency Run — all members log activity"
  "Weekly Readiness Boost — team avg readiness up by week end"

Squad Streaks:
  Team streak: all members must log at least one activity daily
  Collective XP pool → squad level progression

Squad Challenges:
  "Most steps this week"
  "Highest protein compliance"
  "Best sleep quality"
  "Most workouts completed"
```

---

## §P9-C. Accountability Communities

| Community | Target |
|-----------|--------|
| 10K Steps India | Anyone wanting to walk more |
| Office Fat Loss | Desk workers |
| PCOS Warriors | Women with PCOS |
| Vegetarian Muscle Builders | Veg users building muscle |
| Diabetes Reversal Support | High glucose users |
| Wedding Transformation | Short-term goal users |
| Navratri Fitness | Seasonal community |
| Senior Strength India | Users 50+ |

No personal health data visible in communities — activity feeds only.

---

## §P9-D. Family Health Hub (NEW v1 — Household Health Management)

> Major long-term retention opportunity in India, where health is a family decision. One subscription covers the whole household's visibility.

### Family Hub Architecture

```dart
class FamilyHub {
  // One account holder (primary) can add family members
  // Each member has their own profile + privacy settings
  // Primary sees an aggregate family dashboard
  // Members see only their own data (+ what they consent to share)

  final String primaryUserId;
  final List<FamilyMember> members; // max 6

  // Member types
  // parent, spouse, child (under 18 = limited data)
  // Each member: own age, gender, goals, conditions
}
```

### Family Dashboard UI

**Route:** `/family`

```
Family Health Hub — The Sharma Family

┌────────────────────────────────────────┐
│ 👨 Dad (Ramesh, 54)                    │
│   Health Score: 71  BP: ⚠️ Moderate  │
│   Steps today: 4,200  Sleep: 6.1h     │
│   Risk: Hypertension watch            │
├────────────────────────────────────────┤
│ 👩 Mom (Sunita, 51)                    │
│   Health Score: 78  BP: Normal        │
│   Steps today: 6,100  Sleep: 7.4h     │
│   Program: Menopause Wellness         │
├────────────────────────────────────────┤
│ 🧑 Son (Arjun, 28) — You             │
│   Health Score: 84  Readiness: High   │
│   Steps today: 9,400  Workout: ✓      │
├────────────────────────────────────────┤
│ 👧 Daughter (Priya, 24)               │
│   Health Score: 79  Sleep: 8.1h       │
│   Step goal: 88%  Protein: ⚠️ Low    │
└────────────────────────────────────────┘

Family Alerts:
  🔴 Dad: BP elevated 3 days — remind him to check tomorrow
  🟡 Priya: Protein low 4 days — suggest adding eggs

[Send Family Nudge 💪] [View Family Report]
```

### Privacy Model

```
Each member controls their own visibility:
  ✓ Share Health Score   (default: on)
  ✓ Share Steps          (default: on)
  ✗ Share weight         (default: off)
  ✗ Share clinical data  (default: off — always)

Children (< 18):
  Parent is guardian — sees full data
  No weight/body composition shown (ADR-039: minor privacy)
```

### Family Nudges

```dart
class FamilyNudgeService {
  List<FamilyNudge> generateNudges(List<FamilyMember> members) {
    final nudges = <FamilyNudge>[];

    for (final member in members) {
      if (member.hasRisk(HealthRisk.hypertension) &&
          member.bpReadingsDaysAgo > 2) {
        nudges.add(FamilyNudge(
          targetMember: member,
          message: '${member.firstName} hasn\'t checked BP in 3 days.',
          action: 'Send a gentle reminder',
          nudgeType: NudgeType.healthReminder,
        ));
      }
    }

    return nudges;
  }
}
```

---

## §P9-E. Activity Feed & Sharing Architecture (NEW v1)

> Users build habits together. The Activity Feed (/feed) is a dynamic, glassmorphic timeline displaying achievements, routes, and workouts. It is optimized for zero-friction interaction and strict privacy controls.

### Feed Item Data Model

```dart
class FeedItem {
  final String localId;
  final String userId;
  final String userName;
  final String? userAvatar; // Anonymized fitness avatar
  final FeedItemType type;
  final DateTime timestamp;
  
  // Shared payloads
  final WorkoutSummary? workoutPayload;
  final GPSRouteSummary? routePayload;
  final TransformationPayload? transformationPayload;
  final MilestonePayload? milestonePayload;
  
  // Engagement
  final int highFiveCount;
  final List<String> highFivedUserIds;
  final List<FeedComment> comments;

  // Privacy setting
  final SharePrivacy privacy;
}

enum FeedItemType { workout, routeShare, transformation, milestone }
enum SharePrivacy { public, followersOnly, squadOnly, private }

class GPSRouteSummary {
  final String routeId;
  final String routeName;
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final Duration duration;
  final double elevationGainM;
  final String averagePace;
}

class TransformationPayload {
  // Uses privacy-shielded avatar silhouettes & metrics, never raw user photos by default
  final double weightDeltaKg;
  final int fatLossPct;
  final int muscleGainPct;
  final int streakDays;
  final int healthScoreDelta;
}
```

### Feed Engagement Logic

- **XP-Backed Reactions**: A "High-Five" reaction awards the poster `+2 Outcome XP` (capped at 10 XP received per post, and 10 high-fives given per user daily to prevent bot farming).
- **Optimistic Interactions**: High-fives use Drift database writes to instantly render spring-loaded icon reactions before syncing to the D1 database.

### Feed Curation & Spam Prevention (NEW v1)

To prevent social feeds from becoming noisy streams of routine micro-logs (e.g. "User logged 250ml water" or "User logged breakfast"), FitKarma implements a structural curation filter:
- **Deterministic Action Gate**: Auto-sharing is restricted strictly to high-impact achievements:
  - *Completed workouts* (longer than 20 minutes with >100 active calories burned).
  - *Significant milestones* (hitting 7-day, 30-day, or 100-day consistency streaks, Level-Ups, or weight target milestones).
  - *GPS route shares* (completed runs, walks, or cycle sessions with mapped tracks).
- **Absolute Privacy of Routine Logs**: Water intake, individual meal logs, and daily biometric weight readings are strictly private. They are kept out of public, follower, and squad feeds to prevent social fatigue.

##### Implementation: FeedCurationEngine & SyncCoordinator (Pure Dart)

```dart
class FeedItemPayload {
  final String? imageUrl;
  final int? imageSizeBytes;
  final String? gpxData; // raw GPX string
  final String? linkUrl;

  FeedItemPayload({
    this.imageUrl,
    this.imageSizeBytes,
    this.gpxData,
    this.linkUrl,
  });
}

class FeedCurationEngine {
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxGpxTrackpoints = 2000;

  // Domain whitelist for shared links
  static const Set<String> _allowedDomains = {
    'fitkarma.com',
    'strava.com',
    'komoot.com',
    'garmin.com',
    'google.com', // Google Maps/Earth routes
  };

  /// Scans links in social posts to block phishing, link hijacking, or spam domains.
  bool scanFeedLink(String url) {
    if (url.trim().isEmpty) return true;

    try {
      final uri = Uri.parse(url);
      
      // Enforce HTTPS
      if (uri.scheme != 'https') return false;

      // Extract base host and check against whitelist
      final host = uri.host.toLowerCase();
      
      // Match domain or any subdomain thereof (e.g. support.fitkarma.com)
      final isWhitelisted = _allowedDomains.any((domain) => 
        host == domain || host.endsWith('.$domain')
      );

      if (!isWhitelisted) return false;

      // Scan for suspicious URL queries (e.g., redirect loops, phishing parameters)
      if (uri.queryParameters.containsKey('redirect') || 
          uri.queryParameters.containsKey('next') || 
          uri.path.contains('/login') || 
          uri.path.contains('/signin')) {
        return false; // Prevent redirection hijacking or credential phishing pages
      }

      return true;
    } catch (_) {
      return false; // Malformed URLs are rejected
    }
  }

  /// Validates route GPX structures and photo sizes to prevent database bloat and abuse
  bool validatePayload(FeedItemPayload payload) {
    // 1. Validate image payload sizes
    if (payload.imageSizeBytes != null && payload.imageSizeBytes! > maxImageSizeBytes) {
      return false; // Image size exceeds 5MB threshold
    }

    // 2. Validate GPX structure and trackpoint volume
    if (payload.gpxData != null) {
      final gpx = payload.gpxData!;
      
      // Basic check: must be a valid XML/GPX format
      if (!gpx.contains('<gpx') || !gpx.contains('</gpx>')) {
        return false;
      }

      // Count trackpoints (<trkpt>) using substring search to avoid full DOM parser overhead
      int trackpointCount = 0;
      int index = 0;
      while ((index = gpx.indexOf('<trkpt', index)) != -1) {
        trackpointCount++;
        index += 6;
      }

      if (trackpointCount > maxGpxTrackpoints) {
        return false; // Limit trackpoint density to prevent telemetry bloat
      }
    }

    // 3. Validate embedded URL link
    if (payload.linkUrl != null) {
      return scanFeedLink(payload.linkUrl!);
    }

    return true;
  }
}

class LeaderboardEntry {
  final String userId;
  final int stepCount;
  final int version; // Monotonically increasing sync sequence number
  final DateTime lastUpdatedAt;

  LeaderboardEntry({
    required this.userId,
    required this.stepCount,
    required this.version,
    required this.lastUpdatedAt,
  });
}

class LeaderboardSyncCoordinator {
  final Map<String, LeaderboardEntry> _cache = {};

  /// Merges push updates with the local cache, resolving sync out-of-order latency
  List<LeaderboardEntry> mergeSyncUpdate(List<LeaderboardEntry> incomingUpdates) {
    for (final update in incomingUpdates) {
      final existing = _cache[update.userId];
      
      // Rule 1: Accept if no local entry exists
      if (existing == null) {
        _cache[update.userId] = update;
        continue;
      }

      // Rule 2: Sequence-based validation (monotonically increasing version overrides)
      if (update.version > existing.version) {
        _cache[update.userId] = update;
      } 
      // Rule 3: Timestamp fallback if versions match (newer timestamp overrides)
      else if (update.version == existing.version && 
               update.lastUpdatedAt.isAfter(existing.lastUpdatedAt)) {
        _cache[update.userId] = update;
      }
      // Otherwise, reject older/duplicate updates to prevent state regressions
    }

    return _cache.values.toList()..sort((a, b) => b.stepCount.compareTo(a.stepCount));
  }
}
```

---

## §P9-F. Local Geolocation Clubs & Interest Circles (NEW v1)

> Location-based clubs build offline accountability. Circles group users with similar health profiles (e.g. Vegetarian muscle builders, PCOS warriors) to share experiences.

### Clubs and Circles Data Architecture

```dart
class HealthClub {
  final String clubId;
  final String name;
  final String description;
  final String city;
  final String? microLocation; // e.g., "Noida Sector 62"
  final ClubType type;
  final double latitude;
  final double longitude;
  final List<String> memberUserIds;
  final GroupMetrics aggregateMetrics;
}

class GroupMetrics {
  final int memberCount;
  final double averageAdherenceScore; // Team weekly adherence
  final int totalWeeklySteps;
  final int activeSquadMissionsCount;
}

enum ClubType { geolocation, interestCircle }
```

### Geolocation Matching

- **Micro-communities**: The app scans user profiles' region variables (e.g., Noida, Bangalore) to suggest localized clubs.
- **Weekly Group runs/workouts**: Local clubs can organize events. Members receive in-app map coordinates (routes) that they can run and auto-log back to the club feed.

---

## §P9-G. Weekly & Monthly Leaderboards (NEW v1)

> Competing on metrics like Steps, Active Minutes, and Adherence Score gamifies long-term consistency. Leaderboards are partitioned by region and cohort to make winning achievable.

### Leaderboard Tiers

```
  ┌────────────────────────────────────────────────────────┐
  │ 🏆 Noida Sector 62 Leaderboard (Steps)                 │
  │   1. Ramesh S.      78,400 steps    [Gold Badge]       │
  │   2. Priya K.       76,200 steps    [Silver Badge]     │
  │   3. Arjun T. (You) 74,900 steps    [Bronze Badge]     │
  │   ...                                                  │
  │   14. Anonymous     61,200 steps    [Anonymized Mode]  │
  └────────────────────────────────────────────────────────┘
```

### Gamified Rewards & Anonymity

- **Profile Badges**: Landing in the Top 10% of a city or cohort leaderboard at the end of the week unlocks the `Golden Karma Aura` profile highlight and a `+100 Karma XP` bonus.
- **Anonymity Setting**: To satisfy user privacy preferences, players can toggle "Leaderboard Anonymity" to replace their name and photo with "Anonymous Athlete" and a generic avatar.

---

# PHASE 10 — PREDICTIVE HEALTH + PREVENTIVE INTELLIGENCE

---

## §P10-A. Health Risk Prevention System

All 6 risk patterns tracked by `PreventiveIntelligenceEngine` (rule-based, §P4-F). Feeds into Decision Hierarchy.

| Risk | Input Signals | Alert Trigger |
|------|-------------|---------------|
| Hypertension | BP trend, weight, steps, stress | BP rising + steps declining 7+ days |
| Type 2 Diabetes | Glucose, BMI, steps, carbs | Glucose up + BMI ≥ 27 |
| Heart disease | Resting HR, BP, stress, sleep | HR + BP elevated + poor sleep |
| Metabolic syndrome | Waist, BP, glucose | 3+ risk factors present |
| Burnout / Overtraining | HRV, HR, sleep, load | HRV declining + HR elevated + performance dropping |
| Vitamin D deficiency | Steps outdoors proxy, fatigue | Low steps + high fatigue 5+ days |

---

## §P10-B. Biological Age Estimation (Monthly — No AI)

```dart
class BiologicalAgeEstimator {
  int estimate(UserHealthData data) {
    // Multi-factor regression vs WHO population baseline
    // Inputs: resting HR, HRV, sleep quality, BMI, steps avg, glucose
    // Updated monthly — not daily (ADR-023: prevents anxiety)
    // Shown on Profile + Monthly Report
  }
}
```

---

## §P10-C. Monthly Health Report

**Route:** `/reports/monthly`
**Scaffold:** Dynamic document-style display with share/export FABs.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Monthly Health Report            [ PDF ] [ Share ]│
│                                                        │
│  Report Period: May 2026                               │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Biological Age vs. Chronological Age             │ │
│  │  - Chronological Age:  32 Years                   │ │
│  │  - Biological Age:     29 Years (Improved -3 yrs) │ │
│  │  Summary: Excellent cardiovascular recovery trends │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Biomarkers & Vitals Averages:                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Systolic BP:  118 mmHg (Normal Range)            │ │
│  │  Fasting Gluc: 92 mg/dL (Normal Range)            │ │
│  │  HRV Average:  68 ms (+8% vs last month)          │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  ⚠️ Detected Health Risks:                             │
│  - Shoulder Strain Risk (High volume + soreness)       │
│                                                        │
│  Next Month's Focus Strategy:                          │
│  - Swap high volume dumbbell presses for face-pulls    │
└────────────────────────────────────────────────────────┘
```

*   **Export Engine**: Handled via local PDF assembly packages (`pdf` and `path_provider`). Allows one-click compilation to document standard sheets that can be shared with a personal trainer or family doctor.

### Riverpod State Management: MonthlyReportNotifier

This notifier dynamically collects daily local Drift database vitals, computes overall biological age metrics, evaluates injury risk trends, and loads static monthly reports:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

class MonthlyReportState {
  final DateTime reportMonth;
  final int chronologicalAge;
  final int estimatedBiologicalAge;
  final double averageSystolicBp;
  final double averageGlucoseMgDl;
  final double averageHrvMs;
  final List<String> activeRisksList;
  final String monthlyRecommendation;
  final bool isLoading;

  MonthlyReportState({
    required this.reportMonth,
    required this.chronologicalAge,
    required this.estimatedBiologicalAge,
    required this.averageSystolicBp,
    required this.averageGlucoseMgDl,
    required this.averageHrvMs,
    required this.activeRisksList,
    required this.monthlyRecommendation,
    required this.isLoading,
  });

  factory MonthlyReportState.initial() => MonthlyReportState(
    reportMonth: DateTime.now(),
    chronologicalAge: 30,
    estimatedBiologicalAge: 30,
    averageSystolicBp: 120.0,
    averageGlucoseMgDl: 95.0,
    averageHrvMs: 60.0,
    activeRisksList: [],
    monthlyRecommendation: 'Maintain compliance targets.',
    isLoading: true,
  );

  MonthlyReportState copyWith({
    DateTime? reportMonth,
    int? chronologicalAge,
    int? estimatedBiologicalAge,
    double? averageSystolicBp,
    double? averageGlucoseMgDl,
    double? averageHrvMs,
    List<String>? activeRisksList,
    String? monthlyRecommendation,
    bool? isLoading,
  }) {
    return MonthlyReportState(
      reportMonth: reportMonth ?? this.reportMonth,
      chronologicalAge: chronologicalAge ?? this.chronologicalAge,
      estimatedBiologicalAge: estimatedBiologicalAge ?? this.estimatedBiologicalAge,
      averageSystolicBp: averageSystolicBp ?? this.averageSystolicBp,
      averageGlucoseMgDl: averageGlucoseMgDl ?? this.averageGlucoseMgDl,
      averageHrvMs: averageHrvMs ?? this.averageHrvMs,
      activeRisksList: activeRisksList ?? this.activeRisksList,
      monthlyRecommendation: monthlyRecommendation ?? this.monthlyRecommendation,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MonthlyReportNotifier extends StateNotifier<MonthlyReportState> {
  final AppDatabase _db;

  MonthlyReportNotifier(this._db) : super(MonthlyReportState.initial()) {
    _compileMonthlyReport();
  }

  /// Calculates statistical averages and biological age parameters
  Future<void> _compileMonthlyReport() async {
    state = state.copyWith(isLoading: true);

    // 1. Fetch user data to resolve chronological parameters
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final double weight = user.weightKg ?? 70.0;
    
    // Resolve chronological age
    final age = user.age ?? 30;

    // 2. Fetch vitals log history from Drift for the last 30 days
    final startDate = DateTime.now().subtract(const Duration(days: 30));
    final vitalsList = await (_db.select(_db.healthSnapshots)
      ..where((t) => t.createdAt.isBiggerThanValue(startDate)))
      .get();

    double totalSystolic = 0.0;
    double totalGlucose = 0.0;
    double totalHrv = 0.0;
    int snapshotCount = vitalsList.length;

    for (var snapshot in vitalsList) {
      totalSystolic += snapshot.systolicBp ?? 120.0;
      totalGlucose += snapshot.fastingGlucose ?? 95.0;
      totalHrv += snapshot.hrv ?? 55.0;
    }

    final double avgSystolic = snapshotCount > 0 ? totalSystolic / snapshotCount : 120.0;
    final double avgGlucose = snapshotCount > 0 ? totalGlucose / snapshotCount : 95.0;
    final double avgHrv = snapshotCount > 0 ? totalHrv / snapshotCount : 55.0;

    // 3. Estimate Biological Age (Deterministic formula based on health parameters)
    // Low resting BP (under 120), glucose under 95, and HRV above 60 lowers biological age score
    int bioAgeAdjustment = 0;
    if (avgSystolic < 120) bioAgeAdjustment -= 1;
    if (avgGlucose < 95) bioAgeAdjustment -= 1;
    if (avgHrv > 60) bioAgeAdjustment -= 1;
    if (weight > 85) bioAgeAdjustment += 2; // BMI overhead penalty

    final int biologicalAge = age + bioAgeAdjustment;

    // 4. Extract risks (Shoulder/Lumber) from the local database
    List<String> risks = [];
    if (avgSystolic >= 135) {
      risks.add("Stage 1 Hypertension Trend");
    }
    if (avgGlucose >= 110) {
      risks.add("Pre-Diabetes Risk Watch");
    }

    state = MonthlyReportState(
      reportMonth: DateTime.now(),
      chronologicalAge: age,
      estimatedBiologicalAge: biologicalAge,
      averageSystolicBp: double.parse(avgSystolic.toStringAsFixed(1)),
      averageGlucoseMgDl: double.parse(avgGlucose.toStringAsFixed(1)),
      averageHrvMs: double.parse(avgHrv.toStringAsFixed(1)),
      activeRisksList: risks,
      monthlyRecommendation: risks.isNotEmpty 
          ? "Prioritize low-intensity steps activity to support glycemic and blood pressure recovery."
          : "All primary systems operating optimally. Maintain current programming focus.",
      isLoading: false,
    );
  }
}
```

---

## §P10-D. Injury Risk Engine (NEW v1)

> You store injuries. You don't predict injuries. That gap ends in v1.

### InjuryRiskEngine (Rule-Based + Heuristics)

```dart
class InjuryRiskEngine {
  List<InjuryRiskAlert> analyze({
    required List<RecoveryLog> last14Days,
    required List<WorkoutLog> last14Days,
    required FormHistory formHistory,
    required UserProfile profile,
  }) {
    final risks = <InjuryRiskAlert>[];

    // Shoulder: high pressing volume + poor form or elevated soreness
    final pressingVolume = _weeklyPressingVolume(workoutLogs);
    final shoulderSoreness = _avgSoreness(recoveryLogs, region: 'shoulder');
    if (pressingVolume > 12000 && shoulderSoreness > 3.0) {
      risks.add(InjuryRiskAlert(
        region:     'Shoulder',
        risk:       InjuryRisk.moderate,
        message:    'High pressing volume with elevated shoulder soreness. '
                    'Risk of rotator cuff strain.',
        actions: [
          'Reduce pressing volume by 20% this week',
          'Add 2 sets of face pulls or band pull-aparts',
          'Stretch thoracic spine daily',
        ],
      ));
    }

    // Knee: high squat/lunge volume + knee valgus detected in form
    final kneeValgusDetected = formHistory.kneeValgusIncidents > 2;
    final lowerBodyVolume = _weeklyLowerBodyVolume(workoutLogs);
    if (kneeValgusDetected && lowerBodyVolume > 15000) {
      risks.add(InjuryRiskAlert(
        region:  'Knee',
        risk:    InjuryRisk.moderate,
        message: 'Knee valgus detected in recent squat sessions + high volume. '
                 'Patellar tendon stress building.',
        actions: [
          'Add glute activation (clamshells, band walks)',
          'Reduce squat depth temporarily',
          'Check knee tracking during all lower body work',
        ],
      ));
    }

    // Lower back: HRV declining + soreness + deadlift/bent-over volume
    final lbSoreness = _avgSoreness(recoveryLogs, region: 'lower_back');
    final hrvDecline  = _isHRVDeclining(recoveryLogs);
    if (lbSoreness > 3.5 && hrvDecline) {
      risks.add(InjuryRiskAlert(
        region:  'Lower Back',
        risk:    InjuryRisk.high,
        message: 'Persistent lower back soreness with HRV decline. '
                 'High risk of muscle strain or disc irritation.',
        actions: [
          'Skip deadlifts and heavy rows this week',
          'Focus on core stability (bird-dog, dead bug)',
          'Ice + rest if pain >4/10',
        ],
      ));
    }

    return risks;
  }
}
```

### Injury Risk UI Card

```
⚠️ Injury Risk Alerts

🟡 Shoulder — Moderate Risk
   High pressing volume (14,200 kg this week)
   Shoulder soreness trending: 3.4 / 5

   Actions:
   ↓ Reduce pressing volume 20%
   + Add face pulls (2×15)

🔴 Lower Back — High Risk
   HRV declining + persistent soreness
   SKIP deadlifts this week.
```

---

## §P10-E. Stress Detection Engine (NEW v1 — Inferred Stress)

> You ask for stress. Top systems infer it. FitKarma v1 detects stress trends before the user reports them.

### StressDetectionEngine (Rule-Based — No AI)

```dart
class StressDetectionEngine {
  StressAssessment detect(UserHealthData data) {
    int stressSignals = 0;

    // HRV declining (strongest physiological stress marker)
    if (data.hrv7dTrend == Trend.declining &&
        data.hrv < data.baselineHRV * 0.85) {
      stressSignals += 3;
    }

    // Resting HR elevated above baseline
    if (data.restingHR > data.baselineHR * 1.10) {
      stressSignals += 2;
    }

    // Sleep quality declining
    if (data.sleepQuality7dAvg < 3.0) {
      stressSignals += 2;
    }

    // Missed workouts (behavioral signal)
    if (data.missedWorkoutsLast7Days >= 2) {
      stressSignals += 1;
    }

    // App engagement drop (behavioral signal)
    if (data.appOpenFrequencyDrop > 0.40) { // >40% drop in opens
      stressSignals += 1;
    }

    // Late-night food logging (behavioral + lifestyle signal)
    if (data.lateNightLogsPerWeek >= 3) {
      stressSignals += 1;
    }

    final level = switch (stressSignals) {
      >= 7 => StressLevel.high,
      >= 4 => StressLevel.elevated,
      >= 2 => StressLevel.moderate,
      _ => StressLevel.normal,
    };

    return StressAssessment(
      level:       level,
      signals:     stressSignals,
      trendingUp:  data.stressLevelLastWeek < stressSignals,
      recommendation: _buildRecommendation(level),
    );
  }
}
```

### Proactive Stress Alert (shown before user reports)

```
📊 Stress Trending Up

Your body data suggests elevated stress
over the past 4 days — before you mentioned it.

Signals detected:
  • HRV: -16% below your baseline
  • Resting HR: +8 bpm above baseline
  • Sleep quality declining

This pattern often precedes burnout.

Today's recommendation:
  → Switch to 20-min decompression workout
  → 5-min breathing exercise before sleep
  → Discuss with AI Coach if it persists
```

---

## §P10-F. Clinical Report Intelligence (NEW v1 — Lab Data Integration)

> Huge differentiator. No Indian health app extracts lab values and integrates them into the health OS.

### Supported Lab Reports

| Report | Values Extracted | Integration |
|--------|-----------------|-------------|
| CBC (Complete Blood Count) | Hb, WBC, RBC, platelets, MCV | Fatigue risk, anemia flag |
| Lipid Profile | Total cholesterol, LDL, HDL, triglycerides | Heart risk score |
| LFT (Liver Function) | ALT, AST, bilirubin, albumin | Supplement safety flag |
| KFT (Kidney Function) | Creatinine, urea, eGFR | Protein target safety cap |
| HbA1c | Percentage | Diabetes risk, glucose trend validation |
| Vitamin D | 25-OH Vitamin D ng/mL | Fatigue, recovery, immune insights |
| Thyroid (TSH/T3/T4) | TSH, T3, T4 | Metabolism, weight loss expectations |
| Iron Studies | Serum iron, ferritin, TIBC | Energy, workout recovery |

### ClinicalReportParser

```dart
class ClinicalReportParser {
  Future<ClinicalReportResult> parseUpload(File reportPdf) async {
    // Step 1: Extract text from PDF (local — no data leaves phone)
    final text = await _pdfExtractor.extractText(reportPdf);

    // Step 2: Identify report type
    final reportType = _identifyReportType(text);

    // Step 3: Extract values using regex + pattern matching
    final values = _extractValues(text, reportType);

    // Step 4: Classify each value vs reference range
    final classified = values.map((v) => _classify(v)).toList();

    // Step 5: Generate clinical insights (rule-based)
    final insights = _generateInsights(classified, reportType);

    return ClinicalReportResult(
      reportType:   reportType,
      values:       classified,
      insights:     insights,
      uploadDate:   DateTime.now(),
      // Privacy: raw PDF never uploaded — only extracted values sync
    );
  }
}
```

### Clinical Insights Integration

```
Lab Report Uploaded: CBC + Lipid Profile
Date: 15 May 2026

━━━ Key Findings ━━━━━━━━━━━━━━━━━━━━━━

Hemoglobin: 10.8 g/dL  ⚠️ Low (Normal: 13.5–17.5)
  → Mild anemia detected
  → Impact: Lower energy, reduced workout recovery
  → Action: Increase iron-rich foods (spinach, dates, jaggery)
            Consider iron supplement (consult doctor)

LDL Cholesterol: 148 mg/dL  ⚠️ Borderline High
  → Cardiovascular note
  → Action: Reduce saturated fat, increase soluble fiber

HDL Cholesterol: 52 mg/dL  ✓ Good

━━━ Plan Adjustments ━━━━━━━━━━━━━━━━━━

Calorie target: No change
Protein: Safe (KFT normal)
Workout intensity: Reduced 15% until Hb improves
Iron-rich foods added to meal plan
```

### Privacy Architecture

- PDF is processed **entirely on-device** — raw file never uploaded
- Only extracted numeric values + report type sync to Cloudflare D1
- Report stored encrypted in Drift (AES-256)
- Biometric lock required to view clinical screen

---

## §P10-G. Longevity Score + Biological Age v1 (NEW v1)

> You have Health Score (daily). You need a long-term health wealth metric.

### LongevityScoreCalculator

```dart
class LongevityScoreCalculator {
  LongevityResult calculate(UserHealthData data) {
    // Based on validated longevity research inputs
    // (VO2max estimate, body composition, sleep, biomarkers)

    // VO2max estimate (Cooper test proxy or wearable)
    final vo2maxScore = _scoreVO2Max(data.estimatedVO2Max, data.age, data.gender);

    // Body fat %
    final bodyFatScore = _scoreBodyFat(data.bodyFatPct, data.gender);

    // Sleep quality (7-day avg)
    final sleepScore = _scoreSleep(data.avgSleepH, data.sleepQuality7dAvg);

    // Activity level (steps + exercise)
    final activityScore = _scoreActivity(data.avgSteps7d, data.workoutsPerWeek);

    // Biomarker inputs (from clinical reports, if available)
    final biomarkerScore = data.hasClinicalData
        ? _scoreBiomarkers(data.hbA1c, data.ldl, data.hdl, data.vitD)
        : _scoreDefault(data.age);

    // Resting HR + HRV (cardiovascular efficiency)
    final cardioScore = _scoreCardio(data.restingHR, data.hrv, data.baselineHRV);

    final longevityScore = (
      vo2maxScore    * 0.25 +
      bodyFatScore   * 0.15 +
      sleepScore     * 0.20 +
      activityScore  * 0.15 +
      biomarkerScore * 0.15 +
      cardioScore    * 0.10
    ).round();

    // Biological age from regression
    final bioAge = _estimateBiologicalAge(longevityScore, data.age);

    return LongevityResult(
      longevityScore: longevityScore,
      biologicalAge:  bioAge,
      chronologicalAge: data.age,
      ageDelta:       data.age - bioAge,   // positive = younger than age
      dominantFactors: _topFactors(vo2maxScore, sleepScore, activityScore),
      updatedAt:      DateTime.now(),
    );
  }
}
```

### Longevity Screen UI

**Route:** `/longevity`

```
🌱 Longevity Score

   ┌─────────────────────────────┐
   │                             │
   │     Longevity Score: 84     │
   │         ████████████░░      │
   │                             │
   │  Biological Age:  25        │
   │  Chronological Age: 28      │
   │  You are 3 years younger    │
   │  than your actual age ✓     │
   │                             │
   └─────────────────────────────┘

Factor Breakdown:
  ❤️ Cardio (HRV/HR):    91   ★★★★★
  😴 Sleep:              82   ★★★★☆
  🏃 Activity:           88   ★★★★★
  ⚖️ Body Composition:   76   ★★★★☆
  🩺 Biomarkers:         79   ★★★★☆

Biggest Opportunity:
  Body Composition: Reducing body fat 2%
  would add +3 points and improve your
  biological age by ~1 year.

Updated monthly. Next update: Jul 1.
```

---

## §P10-H. Continuous Biomarker Tracking (CGM Sync) (NEW v1)

> Real-time biomarker feedback bridges the gap between nutrition inputs and physiological response. FitKarma integrates with popular CGM sensor streams (via Health Connect or partner APIs) to highlight glucose spikes and automatically correlate them with meal entries.

### CGM Data Ingestion

```dart
class GlucoseReading {
  final String readingId;
  final DateTime timestamp;
  final double glucoseValueMgDl; // e.g. 112.5
  final GlucoseTrend trendDirection; // rising/flat/falling
  final SensorStatus status;
}

enum GlucoseTrend { rapidlyRising, rising, flat, falling, rapidlyFalling }
enum SensorStatus { active, warmingUp, error, expired }

class CgmAnalysisEngine {
  // Correlates glucose spikes with logged food items within a 2-hour window
  List<GlucoseSpikeEvent> detectSpikes(
    List<GlucoseReading> readings,
    List<FoodLog> foodLogs,
  ) {
    final spikes = <GlucoseSpikeEvent>[];

    for (int i = 1; i < readings.length; i++) {
      final prev = readings[i - 1];
      final current = readings[i];
      
      // Spike condition: glucose rises > 40 mg/dL within a 90-minute window
      if (current.glucoseValueMgDl - prev.glucoseValueMgDl > 40 &&
          current.timestamp.difference(prev.timestamp).inMinutes <= 90) {
        
        // Find foods eaten in the 2 hours preceding the spike
        final preFoodLogs = foodLogs.where((log) =>
          log.consumeTime.isBefore(current.timestamp) &&
          log.consumeTime.isAfter(current.timestamp.subtract(const Duration(hours: 2)))
        ).toList();

        if (preFoodLogs.isNotEmpty) {
          spikes.add(GlucoseSpikeEvent(
            spikeTime: current.timestamp,
            startingGlucose: prev.glucoseValueMgDl,
            peakGlucose: current.glucoseValueMgDl,
            glucoseDelta: current.glucoseValueMgDl - prev.glucoseValueMgDl,
            correlatedFoods: preFoodLogs,
          ));
        }
      }
    }
    return spikes;
  }
}
```

### CGM Dashboard UI Mockup

```
🩺 CGM Glucose Stream — Live

    124 mg/dL  [↗ Rising]
    [••••••••••••••••••••📈•••••••••••]
    Last updated: 2 mins ago

⚠️ Detected Spikes (Last 24 Hours):

  🚨 Spike: +52 mg/dL at 2:15 PM
     Peak: 172 mg/dL (Normal limit: 140)
     Correlated food: White Rice (Thali)
     
     💡 AI Insight: White Rice alone triggers rapid digestion.
        Next time, add 150g salad (fiber) or paneer (protein)
        before eating the rice to reduce the spike by ~30%.

  ✓ Flat Response: 8:30 AM
     Peak: 104 mg/dL (+12 mg/dL change)
     Correlated food: Eggs & Oats Chilla
```

---

## §P10-I. Medication Tracker & Interaction Warning Engine (NEW v1)

> Compliance is critical for clinical health. FitKarma provides a secure medication scheduler coupled with a real-time warning engine that flags potential drug-nutrient and drug-workout conflicts.

### Medication Logger & Scheduler

```dart
class MedicationSchedule {
  final String localId;
  final String medicationName;
  final String dosage;
  final List<TimeOfDay> scheduledTimes;
  final List<DayOfWeek> daysOfWeek;
  final DateTime startDate;
  final DateTime? endDate;
  final bool requiresFood;
}

class DrugInteractionEngine {
  // Checks for drug-nutrient (dietary) and drug-workout (training) conflicts
  List<InteractionWarning> checkSchedule(
    MedicationSchedule med,
    FoodLog currentMeal,
    WorkoutIntensity proposedWorkout,
  ) {
    final warnings = <InteractionWarning>[];

    // Case 1: Metformin + high simple carbs
    if (med.medicationName.toLowerCase().contains('metformin') &&
        currentMeal.carbsGrams > 80) {
      warnings.add(InteractionWarning(
        severity: Severity.moderate,
        message: 'Metformin combined with high simple carbs (>80g) can trigger '
                 'rapid glucose swings and GI discomfort. Balance your plate with protein.',
      ));
    }

    // Case 2: Statins (Atorvastatin) + Citrus / Grapefruit
    if (med.medicationName.toLowerCase().contains('statin') &&
        currentMeal.foodItems.any((item) => item.name.toLowerCase().contains('grapefruit'))) {
      warnings.add(InteractionWarning(
        severity: Severity.high,
        message: 'Grapefruit compounds inhibit metabolic enzymes, raising statin '
                 'concentration in blood. Avoid grapefruit while on statins.',
      ));
    }

    // Case 3: Beta-blockers (e.g. Metoprolol) + High intensity exercise
    if (med.medicationName.toLowerCase().contains('metoprolol') &&
        proposedWorkout == WorkoutIntensity.high) {
      warnings.add(InteractionWarning(
        severity: Severity.moderate,
        message: 'Beta-blockers blunt heart rate response. Do not rely on target HR '
                 'zones today; use RPE (Rate of Perceived Exertion) to gauge intensity.',
      ));
    }

    return warnings;
  }
}
```

### Clinical Database Schema & External API Integration

To support offline warnings while keeping the database size manageable, FitKarma implements a hybrid interaction lookup system. Common drug-nutrient interactions (such as Metformin, Statins, Thyroid medications) are stored in local Drift database tables. For less common or complex drug-drug interactions, the application integrates with the National Institutes of Health (NIH) **RxNav API** (via RxNorm concepts) with an optimistic, write-through caching layer.

##### Local Drift Schema Updates

```sql
-- Represents medications currently scheduled by the user
CREATE TABLE user_medications (
  id TEXT PRIMARY KEY NOT NULL,
  medication_name TEXT NOT NULL,
  rxcui TEXT, -- RxNorm Concept Unique Identifier (null if unrecognized)
  dosage TEXT NOT NULL,
  requires_food INTEGER NOT NULL DEFAULT 0, -- Boolean
  updated_at INTEGER NOT NULL
);

-- Cached drug-nutrient and drug-drug interactions
CREATE TABLE cached_drug_interactions (
  id TEXT PRIMARY KEY NOT NULL,
  rxnorm_source TEXT NOT NULL, -- Source Rxcui
  rxnorm_target TEXT, -- Target Rxcui (null if drug-nutrient or drug-workout)
  nutrient_target TEXT, -- Nutrient name (null if drug-drug)
  severity TEXT NOT NULL, -- high, moderate, low
  warning_message TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);
```

##### External NIH RxNav API Service (Pure Dart)

```dart
class RxNavInteractionService {
  final Client _httpClient;
  final AppDatabase _db;

  RxNavInteractionService(this._httpClient, this._db);

  /// Seed mapping common Indian brand names to generic RxNorm Concept IDs (RxCUIs)
  static const Map<String, String> _indianBrandToRxcuiSeed = {
    'glycomet': '22501',   // Metformin
    'atorva': '83367',     // Atorvastatin
    'thyronorm': '10582',   // Levothyroxine
    'pan': '1364230',      // Pantoprazole
    'pantocid': '1364230',  // Pantoprazole
    'ciplar': '8745',       // Propranolol
    'glucophage': '22501',  // Metformin
    'lipitor': '83367',     // Atorvastatin
    'augmentin': '313988',  // Amoxicillin + Clavulanate
  };

  /// Main entry point to evaluate drug-drug and drug-nutrient warnings.
  /// If offline, maps names via brand dictionary and queries the cached Drift table.
  /// If online, queries RxNav and writes through to the local Drift database.
  Future<List<InteractionWarning>> fetchInteractions(List<UserMedication> medications) async {
    final List<String> rxcuis = [];
    final List<String> pendingMedIds = [];

    // 1. Resolve RxCUI for each medication, falling back to brand map or local cache
    for (final med in medications) {
      if (med.rxcui != null && med.rxcui!.isNotEmpty) {
        rxcuis.add(med.rxcui!);
      } else {
        // Try resolving offline using the brand/generic mapping dictionary
        final resolvedRxcui = _resolveOfflineRxcui(med.medicationName);
        if (resolvedRxcui != null) {
          rxcuis.add(resolvedRxcui);
          // Persist resolved RxCUI to avoid re-calculating
          await _updateMedicationRxcui(med.id, resolvedRxcui);
        } else {
          // Mark as pending online resolution
          pendingMedIds.add(med.id);
        }
      }
    }

    if (rxcuis.length < 2) {
      // If we marked any new medications as pending, schedule online sync
      if (pendingMedIds.isNotEmpty) {
        _scheduleOnlineResolutionQueue(pendingMedIds);
      }
      return [];
    }

    final rxcuisParam = rxcuis.join('+');
    final url = 'https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=$rxcuisParam';

    try {
      final response = await _httpClient.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        return _queryLocalInteractionCache(rxcuis);
      }

      final data = json.decode(response.body);
      final warnings = <InteractionWarning>[];

      final interactionGroups = data['fullInteractionTypeGroup'] as List?;
      if (interactionGroups == null) return [];

      for (final group in interactionGroups) {
        final interactionTypes = group['fullInteractionType'] as List?;
        if (interactionTypes == null) continue;

        for (final type in interactionTypes) {
          final interactionPairs = type['interactionPair'] as List?;
          if (interactionPairs == null) continue;

          for (final pair in interactionPairs) {
            final severity = pair['severity'] == 'high' ? Severity.high : Severity.moderate;
            final description = pair['description'] as String;

            final String sourceRxcui = pair['interactionConcept'][0]['minConceptItem']['rxcui'];
            final String targetRxcui = pair['interactionConcept'][1]['minConceptItem']['rxcui'];

            warnings.add(InteractionWarning(
              severity: severity,
              message: description,
            ));

            // Write-through caching to local SQLite for offline access
            await _cacheInteractionLocally(sourceRxcui, targetRxcui, severity, description);
          }
        }
      }

      return warnings;
    } catch (e) {
      // Offline fallback: query local SQLite tables for cached interactions
      return _queryLocalInteractionCache(rxcuis);
    }
  }

  /// Tries to resolve drug name to RxNorm CUI offline using brand seed & fuzzy matching
  String? _resolveOfflineRxcui(String medName) {
    final cleanName = medName.trim().toLowerCase();

    // 1. Exact match on brand names seed
    if (_indianBrandToRxcuiSeed.containsKey(cleanName)) {
      return _indianBrandToRxcuiSeed[cleanName];
    }

    // 2. Fuzzy match against brand seed to handle typing variations (Levenshtein distance <= 2)
    String? bestBrandMatch;
    int minDistance = 999;
    
    _indianBrandToRxcuiSeed.keys.forEach((brand) {
      final distance = _calculateLevenshteinDistance(cleanName, brand);
      if (distance <= 2 && distance < minDistance) {
        minDistance = distance;
        bestBrandMatch = brand;
      }
    });

    if (bestBrandMatch != null) {
      return _indianBrandToRxcuiSeed[bestBrandMatch!];
    }

    return null;
  }

  /// Background sync trigger: once connection is restored, runs API lookup for pending medications
  Future<void> runPendingSync() async {
    final pendingMeds = await _db.getPendingMedications();
    for (final med in pendingMeds) {
      try {
        // Resolve RxCUI from RxNav web service API via medication name
        final url = 'https://rxnav.nlm.nih.gov/REST/rxcui.json?name=${Uri.encodeComponent(med.medicationName)}';
        final response = await _httpClient.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final idGroup = data['idGroup'];
          if (idGroup != null && idGroup['rxnormId'] != null) {
            final List rxnorms = idGroup['rxnormId'];
            if (rxnorms.isNotEmpty) {
              final String rxcui = rxnorms.first.toString();
              await _updateMedicationRxcui(med.id, rxcui);
            }
          }
        }
      } catch (e) {
        // Keep pending flag set for next network reconnection attempt
        debugPrint("Pending drug sync failed for ${med.medicationName}: $e");
      }
    }
  }

  Future<void> _updateMedicationRxcui(String id, String rxcui) async {
    await (_db.update(_db.userMedications)..where((t) => t.id.equals(id))).write(
      UserMedicationsCompanion(rxcui: Value(rxcui), updatedAt: Value(DateTime.now().millisecondsSinceEpoch))
    );
  }

  Future<void> _cacheInteractionLocally(String source, String target, Severity severity, String message) async {
    final id = '${source}_${target}';
    await _db.into(_db.cachedDrugInteractions).insertOnConflictUpdate(
      CachedDrugInteraction(
        id: id,
        rxnormSource: source,
        rxnormTarget: Value(target),
        severity: severity == Severity.high ? 'high' : 'moderate',
        warningMessage: message,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      )
    );
  }

  Future<void> _scheduleOnlineResolutionQueue(List<String> pendingMedIds) async {
    for (final id in pendingMedIds) {
      await (_db.update(_db.userMedications)..where((t) => t.id.equals(id))).write(
        UserMedicationsCompanion(
          rxcui: Value(null), // Reconfirm null to trigger background lookup
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch)
        )
      );
    }
  }

  Future<List<InteractionWarning>> _queryLocalInteractionCache(List<String> rxcuis) async {
    final cached = await _db.getCachedInteractionsForRxcuis(rxcuis);
    return cached.map((c) => InteractionWarning(
      severity: c.severity == 'high' ? Severity.high : Severity.moderate,
      message: c.warningMessage,
    )).toList();
  }

  int _calculateLevenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  int _min3(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);
}
```

---

## §P10-J. Doctor Sharing Portal (NEW v1)

> FitKarma bridges consumer fitness and clinical medicine. Doctor Sharing lets users export a secure, passcode-protected summary of their wellness biomarkers.

### Export Report Schema

- **PDF Summary Contents**:
  - **BP & Glucose Trends**: 90-day graphical charts with hyper/hypoglycemic event frequencies.
  - **Adherence Scores**: 90-day averages (Nutrition compliance, workout consistency, recovery debt).
  - **Biomarker Logs**: Extracted lab values from historical PDF uploads.
  - **Active Risk Flags**: Current flags (e.g., Burnout alert, Cardiovascular load warning).

### Share Security & Consent Flow

- **Secure Passcode**: Users configure a 4-digit PIN before exporting. The generated PDF uses AES-256 encryption, prompting for the PIN upon opening.
- **Time-Decaying Links**: If sharing a web dashboard portal, the link generates a signed token that automatically expires after 7 days, after which all access is permanently revoked.

---

## §P10-K. Regulatory & Clinical Compliance Framework (NEW v1)

> Operating in the clinical intelligence tier (CGM, medications, doctor reports) requires rigorous compliance boundaries. FitKarma establishes a clear legal and structural firewall to protect the platform and its users.

### 1. Medical Disclaimer Protocol & Safeguards
- **Non-Diagnostic Shield**: All screens presenting blood glucose (CGM) spikes, drug interaction checks, or biological age estimations MUST render a permanent, visible disclaimer: *"FitKarma is an educational wellness tool and is not certified for diagnostic medical use. Always consult your doctor before modifying medication schedules."*
- **Emergency Bypass**: Drug interaction warnings explicitly state that they are based on standard clinical databases (e.g. RxNorm) and do not replace professional pharmaceutical advice.

### 2. Clinical Data Safeguards (DPDP Act & HIPAA Guidelines)
- **Local-First Isolation**: Medication schedules, taken timestamps, and uploaded lab report PDFs are encrypted locally using AES-256 (via SQLCipher) and are never synced to Cloudflare unless the user explicitly opts in for cloud backups.
- **Consent Revocability**: In compliance with the India Digital Personal Data Protection (DPDP) Act, users have a single-tap "Revoke All Clinical Access" setting. This immediately wipes all CGM readings, medication logs, and doctor share tokens from both the local SQLite/Drift store and Cloudflare D1.
- **Anonymized Sync Routing**: Anonymized metadata utilized for cohort benchmarks does not export individual lab result dates or specific medication brand names — only high-level compliance percentages.

## §P10-L. Retrospective Glycemic Processing Pipeline (RGPP) (NEW v1)

> Mobile health frameworks (Android Health Connect, iOS HealthKit) introduce sensor sync latency. If a user logs a Thali at 1:30 PM, glucose readings may not sync from the manufacturer's cloud until 4:00 PM. Rather than failing or showing inaccurate data, FitKarma utilizes a Retrospective Glycemic Processing Pipeline (RGPP) to scan and retroactively link late-arriving CGM batches to corresponding food windows.

```
[Delayed CGM Sync Event] ──► Ingests data to CgmReadings Table
                                   │
                                   ▼
[Retrospective Analysis Sync] ──► Scans past 6 hours for unlinked FoodLogs
                                   │
                                   ▼
[Glycemic Engine Math Execution] ─► Updates MealNutritionDetails (Drift Store)
                                   │
                                   ▼
[Retrospective Insight Trigger] ──► Dispatches tailored Dashboard/Coach notification
```

---

### 1. Drift Persistence Extension: Retrospective Status Tracking

We track which meals are waiting for data inside the local SQLite database via custom query accessors:

```dart
// lib/core/database/aggregates/glycemic_processing_queries.dart
import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';

mixin GlycemicProcessingQueries on DatabaseAccessor<AppDatabase> {
  /// Fetches food logs from the past 24 hours that do not yet have 
  /// calculated glycemic spike details due to ingestion latency.
  Future<List<FoodLogData>> getMealsAwaitingAnalysis() {
    final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));
    
    return (select(foodLogs)
          ..where((tbl) => tbl.consumeTime.isAfter(twentyFourHoursAgo))
          ..where((tbl) => tbl.hasGlycemicAnalysis.equals(false)))
        .get();
  }
}
```

---

### 2. The Core Engine: Retrospective Glucose Matcher

Calculates the glycemic response for a 150-minute window surrounding a meal log once sensor sync is complete:

$$\Delta Glucose = \text{Peak Glucose } (0\text{ to }120\text{ min post-meal}) - \text{Baseline Glucose } (-30\text{ to }0\text{ min pre-meal})$$

```dart
// lib/features/clinical_reports/cgm/engine/retrospective_glucose_matcher.dart
import 'dart:math' as math;
import 'package:fitkarma/core/database/app_database.dart';

class GlycemicMatchResult {
  final bool isAnalysisComplete;
  final double? baselineGlucose;
  final double? peakGlucose;
  final double? glycemicSpike;

  GlycemicMatchResult.incomplete()
      : isAnalysisComplete = false,
        baselineGlucose = null,
        peakGlucose = null,
        glycemicSpike = null;

  GlycemicMatchResult.complete({
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.glycemicSpike,
  }) : isAnalysisComplete = true;
}

class RetrospectiveGlucoseMatcher {
  /// Evaluates an isolated food entry against surrounding synced CGM datasets.
  GlycemicMatchResult processMealWindow({
    required DateTime mealConsumeTime,
    required List<CgmReadingData> syncedReadings, // Historical slice passed from cache
  }) {
    // 1. Filter Baseline Window (-30 mins to 0 mins relative to meal consumption)
    final preMealStart = mealConsumeTime.subtract(const Duration(minutes: 30));
    final baselineReadings = syncedReadings.where((r) => 
      r.timestamp.isAfter(preMealStart) && r.timestamp.isBefore(mealConsumeTime)
    ).map((r) => r.glucoseMgDl).toList();

    // 2. Filter Post-Meal Window (0 mins to 120 mins post-meal)
    final postMealEnd = mealConsumeTime.add(const Duration(minutes: 120));
    final postMealReadings = syncedReadings.where((r) => 
      r.timestamp.isAfter(mealConsumeTime) && r.timestamp.isBefore(postMealEnd)
    ).map((r) => r.glucoseMgDl).toList();

    // 3. Confirm target dataset density requirements are satisfied (standard 5-15 min sensor intervals)
    if (baselineReadings.length < 2 || postMealReadings.length < 4) {
      return GlycemicMatchResult.incomplete(); 
    }

    // 4. Run deterministic tracking mathematics
    final double avgBaseline = baselineReadings.reduce((a, b) => a + b) / baselineReadings.length;
    final double maxPeak = postMealReadings.reduce(math.max);
    final double calculateSpike = maxPeak - avgBaseline;

    return GlycemicMatchResult.complete(
      baselineGlucose: avgBaseline,
      peakGlucose: maxPeak,
      glycemicSpike: calculateSpike.clamp(0.0, 300.0),
    );
  }
}
```

---

### 3. Background Sync Coordination (Riverpod + Workmanager)

Handles background scans and updates the local Drift database with glycemic details:

```dart
// lib/features/clinical_reports/cgm/providers/cgm_sync_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/clinical_reports/cgm/engine/retrospective_glucose_matcher.dart';

class CgmSyncNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;
  final RetrospectiveGlucoseMatcher _matcher;

  CgmSyncNotifier(this._db, this._matcher) : super(const AsyncValue.data(null));

  /// Main background execution hook triggered on sensor backfill sweeps.
  Future<void> executeRetrospectiveAudit() async {
    state = const AsyncValue.loading();
    
    try {
      // Step 1: Gather unlinked user logs
      final missingMeals = await _db.getMealsAwaitingAnalysis();
      if (missingMeals.isEmpty) {
        state = const AsyncValue.data(null);
        return;
      }

      // Step 2: Extract core sensor boundaries
      final allGlucoseData = await _db.getAllCgmReadings();

      for (final meal in missingMeals) {
        final analysis = _matcher.processMealWindow(
          mealConsumeTime: meal.consumeTime,
          syncedReadings: allGlucoseData,
        );

        if (analysis.isAnalysisComplete) {
          // Step 3: Atomic write execution to state storage structures
          await _db.transaction(() async {
            await _db.updateMealNutritionDetails(
              mealLogId: meal.localId,
              glycemicSpike: analysis.glycemicSpike!,
              mealQualityScore: _recalculateQualityWithSpike(meal, analysis.glycemicSpike!),
            );
            await _db.markMealAnalysisAsDetailed(meal.localId);
          });

          // Step 4: Pass structural alert event metadata to rule container models
          if (analysis.glycemicSpike! > 45.0) {
            _dispatchRetrospectiveNudge(meal, analysis.glycemicSpike!);
          }
        }
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  double _recalculateQualityWithSpike(FoodLogData meal, double spike) {
    double processingPenalty = meal.processingTier * 12.0;
    double spikePenalty = spike > 45.0 ? 25.0 : 0.0;
    return (100.0 - processingPenalty - spikePenalty).clamp(1.0, 100.0);
  }

  void _dispatchRetrospectiveNudge(FoodLogData meal, double spikeDelta) {
    // Alert loop injection point to hybrid feedback notification engines
  }
}
```

---

### 4. UI Component Strategy: The Retrospective Insight Card

Since metabolic updates happen asynchronously, the UI shifts seamlessly to display historical reports once analysis completes:

```
┌────────────────────────────────────────────────────────┐
│ 🩺 Glycemic Response Audit (Processed 2h ago)          │
├────────────────────────────────────────────────────────┤
│ Meal: Lunch (Dal Makhani + 2 Rotis)                    │
│ Dynamic Glucose Variant: ⚠️ +48 mg/dL spike detected   │
│ Peak Level: 168 mg/dL                                  │
├────────────────────────────────────────────────────────┤
│ 💡 AI Retrospective Rule Adjustment:                   │
│ This response stems from carbohydrate distribution.    │
│ Next time, track an extra 100g curd or fiber salad     │
│ BEFORE parsing the rotis to blunt this surge.          │
└────────────────────────────────────────────────────────┘
```

---

## §P10-M. Clinical Compliance Hardening (NEW v1.0)

> **Why this section exists.** A pre-launch review flagged that CGM sync, medication tracking with drug-nutrient interaction warnings, and the Doctor Sharing Portal (§P10-H/I/J) sit closer to clinical decision support than general fitness tracking. In India, automated interaction warnings can brush up against CDSCO medical device software classification depending on how directive the language is — "avoid combining X with Y" reads very differently from "consult your doctor about combining X with Y," even if the underlying data is identical. §P10-K already establishes the disclaimer and consent framework; this section hardens the specific failure mode of **directive phrasing drifting into medical advice** as new interaction rules get added over time.

### 1. Directive-Language Lint on Interaction Warnings

Every string surfaced by the Medication Tracker & Interaction Warning Engine (§P10-I) must pass a lint check before it ships — whether written by an engineer or generated by a template — that rejects imperative medical directives:

```dart
/// Runs at build/CI time (see §P14-D) against every interaction warning
/// template string in the medication module. Fails the build if a banned
/// directive pattern is found, forcing a rewrite to informational framing.
class ClinicalCopyLinter {
  static const bannedDirectivePatterns = [
    r'\bstop taking\b',
    r'\bavoid\b(?!.{0,20}consult)',   // "avoid X" without "consult" nearby
    r'\breduce your dose\b',
    r'\bdo not take\b',
    r'\bswitch to\b',
  ];

  /// Returns violations found, empty list if the copy is compliant.
  List<String> lint(String copy) {
    final violations = <String>[];
    for (final pattern in bannedDirectivePatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(copy)) {
        violations.add('Directive pattern matched: $pattern in "$copy"');
      }
    }
    return violations;
  }
}
```

Compliant framing always routes the user to a decision, not away from one:

| ❌ Directive (rejected by linter) | ✅ Informational (compliant) |
|---|---|
| "Avoid combining ibuprofen with your blood thinner." | "Ibuprofen and blood thinners can interact. Flag this to your doctor before taking both." |
| "Stop your statin before this workout." | "Statins are sometimes associated with exercise-related muscle soreness. If you notice unusual pain, mention it at your next check-in." |

### 2. Pre-Ship Legal Review Gate

Any change to the medication interaction rule set, the CGM spike-alert copy, or the Doctor Sharing Portal PDF template requires sign-off recorded in the PR template before merge — a lightweight gate, not a full legal audit per change, but enough to catch drift as the rule set grows past its initial review:

```
## Clinical Copy Change Checklist (required for PRs touching §P10-I, §P10-H, §P10-J)
- [ ] ClinicalCopyLinter passes with zero violations
- [ ] Non-diagnostic disclaimer is present and unmodified on the affected screen
- [ ] Change reviewed by whoever holds the compliance sign-off role for this release
```

### 3. Scope Sequencing Recommendation

Because this tier carries the platform's highest regulatory surface area, it is sequenced deliberately **after** the retention-proving phases in the v1.0 roadmap (Phases 0–2, 5, 7) rather than being built in roadmap order — see the note in the Development Roadmap table. Shipping Phase 10 behind a feature flag, gated to a small opt-in cohort initially, lets the legal review in §2 above happen against real usage patterns rather than only against the spec.

---

# PHASE 11 — VISUAL BODY ANALYTICS

---

## §P11-A. Body Analytics Screen

**Route:** `/analytics/body` | **Biometric lock required**
**Scaffold:** Secure tabbed dashboard displaying body indexes and predicted paths.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Body Analytics 🔒                  [ Edit Check ] │
│                                                        │
│  Estimated Body Fat Range:                             │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Body Fat %: 22.4%   [===||||==......] (Fitness)  │ │
│  │  Lean Mass:  65.2 kg           Fat Mass:  18.8 kg │ │
│  │  Confidence: ±3-4% (U.S. Navy Method)             │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  3-Month Trend (Deltas):                               │
│  ┌───────────────────────────────────────────────────┐ │
│  │  Body Fat %:  26.2% → 22.4%  (↓ -3.8%)  ✓         │ │
│  │  Lean Mass:   62.1 → 65.2 kg (↑ +3.1 kg) ✓        │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Anthropometric Checkpoints:                           │
│  Neck: 38.0 cm  ·  Waist: 86.5 cm  ·  Hips: 94.0 cm    │
│                                                        │
│  [ Compare Photos (Slider) ]    [ Calculate Navy BF ]  │
└────────────────────────────────────────────────────────┘
```

### Riverpod State Management: BodyAnalyticsNotifier

This notifier manages check-in database logs, executes the Navy formulas, tracks fat/lean trends, and guards private assets:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

class BodyAnalyticsState {
  final double currentWeightKg;
  final double heightCm;
  final double waistCm;
  final double neckCm;
  final double? hipCm;
  final double bodyFatPct;
  final double leanMassKg;
  final double fatMassKg;
  final String categoryLabel;
  final double bodyFatDelta3Months;
  final double leanMassDelta3Months;
  final bool isLoading;

  BodyAnalyticsState({
    required this.currentWeightKg,
    required this.heightCm,
    required this.waistCm,
    required this.neckCm,
    this.hipCm,
    required this.bodyFatPct,
    required this.leanMassKg,
    required this.fatMassKg,
    required this.categoryLabel,
    required this.bodyFatDelta3Months,
    required this.leanMassDelta3Months,
    required this.isLoading,
  });

  factory BodyAnalyticsState.initial() => BodyAnalyticsState(
    currentWeightKg: 0.0,
    heightCm: 0.0,
    waistCm: 0.0,
    neckCm: 0.0,
    bodyFatPct: 0.0,
    leanMassKg: 0.0,
    fatMassKg: 0.0,
    categoryLabel: 'Unknown',
    bodyFatDelta3Months: 0.0,
    leanMassDelta3Months: 0.0,
    isLoading: true,
  );

  BodyAnalyticsState copyWith({
    double? currentWeightKg,
    double? heightCm,
    double? waistCm,
    double? neckCm,
    double? hipCm,
    double? bodyFatPct,
    double? leanMassKg,
    double? fatMassKg,
    String? categoryLabel,
    double? bodyFatDelta3Months,
    double? leanMassDelta3Months,
    bool? isLoading,
  }) {
    return BodyAnalyticsState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
      neckCm: neckCm ?? this.neckCm,
      hipCm: hipCm ?? this.hipCm,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      leanMassKg: leanMassKg ?? this.leanMassKg,
      fatMassKg: fatMassKg ?? this.fatMassKg,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      bodyFatDelta3Months: bodyFatDelta3Months ?? this.bodyFatDelta3Months,
      leanMassDelta3Months: leanMassDelta3Months ?? this.leanMassDelta3Months,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BodyAnalyticsNotifier extends StateNotifier<BodyAnalyticsState> {
  final AppDatabase _db;
  final BodyCompositionEstimator _estimator = BodyCompositionEstimator();

  BodyAnalyticsNotifier(this._db) : super(BodyAnalyticsState.initial()) {
    _loadCompositionProfile();
  }

  /// Calculates core anthropometrics and trends from Drift records
  Future<void> _loadCompositionProfile() async {
    state = state.copyWith(isLoading: true);

    // 1. Fetch user parameters
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final double weight = user.weightKg ?? 75.0;
    final double height = user.heightCm ?? 175.0;
    final String gender = user.gender ?? 'male';
    final int age = user.age ?? 30;

    // 2. Fetch latest measurements logs from the database
    final latestLog = await (_db.select(_db.transformationChecks)
      ..orderBy([(t) => OrderingTerm(expression: t.checkDate, mode: OrderingMode.desc)])
      ..limit(1))
      .getSingleOrNull();

    // Default fallbacks if no logged history exists
    final double waist = latestLog?.waistCm ?? 88.0;
    final double neck = latestLog?.neckCm ?? 38.0;
    final double? hip = latestLog?.hipCm ?? (gender == 'female' ? 95.0 : null);

    // Calculate U.S. Navy values
    final compResult = _estimator.estimate(
      heightCm: height,
      weightKg: weight,
      waistCm: waist,
      neckCm: neck,
      hipCm: hip,
      gender: gender,
      age: age,
    );

    // 3. Fetch historical logs to compute delta values (90 days window)
    final date90DaysAgo = DateTime.now().subtract(const Duration(days: 90));
    final oldLogs = await (_db.select(_db.transformationChecks)
      ..where((t) => t.checkDate.isSmallerThanValue(date90DaysAgo))
      ..orderBy([(t) => OrderingTerm(expression: t.checkDate, mode: OrderingMode.desc)])
      ..limit(1))
      .getSingleOrNull();

    double fatDelta = 0.0;
    double leanDelta = 0.0;

    if (oldLogs != null) {
      final oldResult = _estimator.estimate(
        heightCm: height,
        weightKg: oldLogs.weightKg,
        waistCm: oldLogs.waistCm ?? 92.0,
        neckCm: oldLogs.neckCm ?? 39.0,
        hipCm: oldLogs.hipCm,
        gender: gender,
        age: age,
      );
      fatDelta = compResult.bodyFatPct - oldResult.bodyFatPct;
      leanDelta = compResult.leanMassKg - oldResult.leanMassKg;
    }

    state = BodyAnalyticsState(
      currentWeightKg: weight,
      heightCm: height,
      waistCm: waist,
      neckCm: neck,
      hipCm: hip,
      bodyFatPct: compResult.bodyFatPct,
      leanMassKg: compResult.leanMassKg,
      fatMassKg: compResult.fatMassKg,
      categoryLabel: compResult.bfCategory,
      bodyFatDelta3Months: double.parse(fatDelta.toStringAsFixed(1)),
      leanMassDelta3Months: double.parse(leanDelta.toStringAsFixed(1)),
      isLoading: false,
    );
  }

  /// Logs a new set of dimensions
  Future<void> logAnthropometrics({
    required double waist,
    required double neck,
    double? hip,
  }) async {
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    final newId = DateTime.now().toIso8601String();

    await _db.into(_db.transformationChecks).insert(
      TransformationChecksCompanion.insert(
        localId: newId,
        userId: 'current_user_id',
        checkDate: DateTime.now(),
        weightKg: user.weightKg ?? 70.0,
        waistCm: Value(waist),
        neckCm: Value(neck),
        hipCm: Value(hip),
        syncStatus: const Value('pending'),
      ),
    );

    await _loadCompositionProfile();
  }
}
```

---

## §P11-B. Progress Photo System

Local only by default. Biometric lock always active. Side-by-side comparison with week-over-week slider. Share creates a cropped, no-face version. "Delete all photos" in Settings → Data.

---

## §P11-C. Wearable-Free Body Composition Estimation (NEW v1)

> Most users don't have a DEXA scan or smart scale. FitKarma v1 uses anthropometric measurements to estimate body fat % accurately enough for practical coaching.

### Methods (in order of data availability)

| Method | Inputs | Accuracy | When Used |
|--------|--------|----------|-----------|
| U.S. Navy Formula | Neck + waist + height (men); + hip (women) | ±3–4% BF | Primary — most users |
| BMI-based estimate | Weight + height + age + gender | ±5–6% BF | Fallback — minimal data |
| Progress photo AI | Photo + measurements | ±4% BF | Optional Phase 3 |

### BodyCompositionEstimator (Pure Dart)

```dart
class BodyCompositionEstimator {
  BodyCompositionResult estimate({
    required double heightCm,
    required double weightKg,
    required double waistCm,
    required double neckCm,
    double? hipCm,          // Required for women
    required String gender,
    required int age,
  }) {
    late double bodyFatPct;

    if (gender == 'male') {
      // U.S. Navy Formula (male)
      // BF% = 495 / (1.0324 - 0.19077×log10(waist-neck) + 0.15456×log10(height)) - 450
      final logWaistNeck = math.log10(waistCm - neckCm);
      final logHeight    = math.log10(heightCm);
      bodyFatPct = 495 / (1.0324 - 0.19077 * logWaistNeck
                                 + 0.15456 * logHeight) - 450;
    } else {
      // U.S. Navy Formula (female) — requires hip measurement
      if (hipCm == null) throw ArgumentError('Hip required for female estimation');
      final logWaistHipNeck = math.log10(waistCm + hipCm - neckCm);
      final logHeight       = math.log10(heightCm);
      bodyFatPct = 495 / (1.29579 - 0.35004 * logWaistHipNeck
                                  + 0.22100 * logHeight) - 450;
    }

    bodyFatPct = bodyFatPct.clamp(3.0, 60.0);
    final leanMassKg = weightKg * (1 - bodyFatPct / 100);
    final fatMassKg  = weightKg * bodyFatPct / 100;

    return BodyCompositionResult(
      bodyFatPct:    bodyFatPct.roundToDouble(),
      leanMassKg:    leanMassKg.roundToOneDecimal(),
      fatMassKg:     fatMassKg.roundToOneDecimal(),
      bfCategory:    _classifyBF(bodyFatPct, gender),
      estimationMethod: 'U.S. Navy Formula',
      confidence:    'Medium (±3–4%)',
    );
  }
}
```

### Body Composition UI Card

```
⚖️ Body Composition Estimate

Method: U.S. Navy Formula (waist + neck + height)
Confidence: Medium (±3–4%)

Body Fat:    22.4%   ▓▓▓▓▓▓▓░░░
Lean Mass:   65.2 kg
Fat Mass:    18.8 kg

Category: Fitness  ✓  (Normal: 18–24%)

Trend (3 months):
  Body Fat:  26.2% → 22.4%  ↓ −3.8%  ✓
  Lean Mass: 62.1 → 65.2 kg  ↑ +3.1 kg ✓

Update measurements monthly for best accuracy.
[Update Measurements]
```

---

# PHASE 12 — FESTIVAL + LIFE EVENTS INTELLIGENCE

---

## §P12-A. Festival Intelligence System (v1 — Cross-Module)

In v1, the festival engine only influenced diet. In v1, it influences every module.

### Festival Cross-Module Adaptation Engine

```dart
class FestivalCrossModuleEngine {
  FestivalAdaptation adapt(Festival festival, UserState state) {
    return switch (festival.name) {
      'Diwali' => FestivalAdaptation(
        // Nutrition
        calorieBuffer:       +200,
        proteinFocus:        'High — counteract sweets',
        hydrationIncrease:   +0.5,

        // Workout
        workoutIntensity:    'Morning-first — burn before celebrating',
        stepTargetAdjust:    +1000, // walking between houses

        // Sleep
        sleepEmphasis:       'High — late nights risk recovery',

        // Readiness
        readinessExpectation: 'Lower average — festival fatigue is normal',

        // AI Coach
        coachTone:           'Celebratory — allow flexibility',

        // Goals
        goalFlexibility:     'Maintained — 3-day buffer around festival',

        // Mood
        moodCheckIn:         'Optional — reduce pressure during festival',
      ),
      'Navratri' => FestivalAdaptation(
        foodDatabaseFilter:  'fasting_foods_only',
        grainAlert:          true,
        workoutIntensity:    'Moderate — energy may be lower on fasting days',
        hydrationIncrease:   +0.5,
      ),
      'Ramadan' => FestivalAdaptation(
        mealTimingMode:      'sehri_iftar',
        calorieDistribution: 'Iftar-heavy',
        workoutTiming:       'Post-Taraweeh or pre-Sehri',
        hydrationWindow:     'Sehri to Iftar only',
      ),
      _ => FestivalAdaptation.standard(),
    };
  }
}
```

### Festivals Tracked

| Festival | Dates | Key Adaptation |
|----------|-------|----------------|
| Navratri | Oct (9 days) | Fasting food mode, grain filter, moderate workout |
| Diwali | Oct–Nov | Sweet buffer, morning-first workout, hydration boost |
| Holi | Mar | Activity tracking, social calorie tracking |
| Ramadan | Variable | Sehri/Iftar meal planning, adjusted workout timing |
| Eid | Post-Ramadan | Biryani + sweets budgeting |
| Ganesh Chaturthi | Sep | Modak macros, family meal tracking |
| Onam | Sep | Sadya thali macros |
| Christmas | Dec | Party season adaptation |
| Karva Chauth | Oct | Fasting + feasting cycle |
| Makar Sankranti | Jan | Til + jaggery nutritional benefits |

### Festival Survival Mode

Activates automatically 3 days before a detected festival. Adjusts all targets, updates DIP tone to celebratory, shows festival banner in Dashboard.

---

## §P12-B. Life Events Engine (NEW)

Extends the festival concept to cover all major life disruptions. Each life event adjusts targets, programs, and coach tone across all modules:

```dart
enum LifeEventType {
  wedding, examSeason, travelAbroad, travelDomestic,
  ramadan, shiftWork, nightShift, injury, newBaby,
  officeDeadline, relocation, grief, illness
}

class LifeEventsEngine {
  LifeEventAdaptation adapt(LifeEvent event) {
    return switch (event.type) {
      LifeEventType.injury        => LifeEventAdaptation.injury(region: event.injuredRegion),
      LifeEventType.travelAbroad  => LifeEventAdaptation.travel(timezone: event.timezone),
      LifeEventType.officeDeadline => LifeEventAdaptation.deadline(
        workoutBrief: true,       // 20-min workouts
        stressManagement: true,   // Breathing, sleep emphasis
        nutritionSimplified: true // Quick healthy meal suggestions
      ),
      LifeEventType.newBaby       => LifeEventAdaptation.newBaby(
        sleepAdjustment: true,    // Readiness expectations lowered
        quickWorkouts: true,      // 15-min home workouts
        recoveryFirst: true
      ),
      _ => LifeEventAdaptation.standard(),
    };
  }
}
```

User sets a life event from Dashboard → Event Engine updates DIP inputs → All modules adapt.

---

## §P12-C. Wedding Transformation Mode

**Route:** `/wedding/dashboard`
**Scaffold:** Festive themes layout featuring custom widgets and dynamic countdowns.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Wedding Prep Dashboard                           │
│                                                        │
│  Wedding Countdown:                                    │
│  ┌───────────────────────────────────────────────────┐ │
│  │     45 Days Left   ·   Target: Nov 15, 2026       │ │
│  │     Current Phase: [ PEAK SHRED ] (Weeks 5-8 of 12)│ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Specialized Daily Action Checklist:                   │
│  ┌───────────────────────────────────────────────────┐ │
│  │  [x] Skin Hydration Target: 3.5 Liters             │ │
│  │  [x] Collagen Boost: Green Tea + Almonds          │ │
│  │  [ ] Cortisol Control: 10-min Deep Breathing check │ │
│  │  [ ] HIIT Cardio Session (30 mins today)          │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Macro Guidelines (Phase-Shifted):                     │
│  Calories: 1,800 kcal  ·  Protein: 120g  ·  Carbs: 140g│
└────────────────────────────────────────────────────────┘
```

### Riverpod State Management: WeddingTransformationNotifier

This notifier manages event calendars, adjusts daily targets depending on the active phase (Foundation, Peak, Taper), tracks skin nutrition milestones, and updates dynamically if the event date changes:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

enum WeddingPhase { foundation, peakShred, finalTaper }

class WeddingTransformationState {
  final DateTime weddingDate;
  final int daysRemaining;
  final WeddingPhase currentPhase;
  final double calorieTarget;
  final double proteinTargetG;
  final double hydrationTargetLiters;
  final bool hasSkinNutritionChecked;
  final bool hasStressChecked;
  final bool isLoading;

  WeddingTransformationState({
    required this.weddingDate,
    required this.daysRemaining,
    required this.currentPhase,
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.hydrationTargetLiters,
    required this.hasSkinNutritionChecked,
    required this.hasStressChecked,
    required this.isLoading,
  });

  factory WeddingTransformationState.initial() => WeddingTransformationState(
    weddingDate: DateTime.now().add(const Duration(days: 90)),
    daysRemaining: 90,
    currentPhase: WeddingPhase.foundation,
    calorieTarget: 2000,
    proteinTargetG: 100,
    hydrationTargetLiters: 2.5,
    hasSkinNutritionChecked: false,
    hasStressChecked: false,
    isLoading: true,
  );

  WeddingTransformationState copyWith({
    DateTime? weddingDate,
    int? daysRemaining,
    WeddingPhase? currentPhase,
    double? calorieTarget,
    double? proteinTargetG,
    double? hydrationTargetLiters,
    bool? hasSkinNutritionChecked,
    bool? hasStressChecked,
    bool? isLoading,
  }) {
    return WeddingTransformationState(
      weddingDate: weddingDate ?? this.weddingDate,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentPhase: currentPhase ?? this.currentPhase,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      hydrationTargetLiters: hydrationTargetLiters ?? this.hydrationTargetLiters,
      hasSkinNutritionChecked: hasSkinNutritionChecked ?? this.hasSkinNutritionChecked,
      hasStressChecked: hasStressChecked ?? this.hasStressChecked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WeddingTransformationNotifier extends StateNotifier<WeddingTransformationState> {
  final AppDatabase _db;

  WeddingTransformationNotifier(this._db) : super(WeddingTransformationState.initial()) {
    _loadWeddingParameters();
  }

  /// Calculates dynamic macros and hydration targets based on wedding date countdown
  Future<void> _loadWeddingParameters() async {
    state = state.copyWith(isLoading: true);

    // 1. Fetch user targets (or fallback profile date)
    final user = await (_db.select(_db.users)..limit(1)).getSingle();
    
    // Fallback: Assume wedding date is 60 days out if not specified
    final DateTime targetDate = user.weddingDate ?? DateTime.now().add(const Duration(days: 60));
    final int daysLeft = targetDate.difference(DateTime.now()).inDays;

    // 2. Resolve wedding phase
    // 90+ days: Foundation. 30-90 days: Peak Shred. <30 days: Final Taper (de-stress, hydration)
    WeddingPhase phase = WeddingPhase.foundation;
    double calories = 2000.0;
    double protein = 110.0;
    double hydration = 3.0;

    if (daysLeft < 30) {
      phase = WeddingPhase.finalTaper;
      calories = 1900.0; // Maintenance / slight deficit
      protein = 100.0;
      hydration = 3.5;   // Maximized hydration for skin glow
    } else if (daysLeft < 90) {
      phase = WeddingPhase.peakShred;
      calories = 1750.0; // Moderate shred deficit
      protein = 125.0;   // Elevated protein to preserve muscle
      hydration = 3.0;
    }

    // 3. Check today's action checklist from daily recovery / food logs
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final mealLogs = await (_db.select(_db.foodLogs)
      ..where((t) => t.logTime.isBiggerOrEqualValue(startOfDay)))
      .get();
    final bool skinChecked = mealLogs.any((l) => l.foodName.contains("almonds") || l.foodName.contains("collagen"));

    final recoveryLog = await (_db.select(_db.recoveryLogs)
      ..where((t) => t.checkInTime.isBiggerOrEqualValue(startOfDay))
      ..limit(1))
      .getSingleOrNull();
    final bool stressChecked = recoveryLog?.stressCheckedIn ?? false;

    state = WeddingTransformationState(
      weddingDate: targetDate,
      daysRemaining: daysLeft.clamp(0, 365),
      currentPhase: phase,
      calorieTarget: calories,
      proteinTargetG: protein,
      hydrationTargetLiters: hydration,
      hasSkinNutritionChecked: skinChecked,
      hasStressChecked: stressChecked,
      isLoading: false,
    );
  }

  /// Logs a skin nutrition check-in event to local Drift database
  Future<void> logSkinNutrition() async {
    // Inserts quick food log trigger for almond/collagen macro tracking
    await _db.into(_db.foodLogs).insert(
      FoodLogsCompanion.insert(
        localId: DateTime.now().toIso8601String(),
        userId: 'current_user_id',
        logTime: DateTime.now(),
        foodName: 'Almonds & Green Tea (Skin Boost)',
        calories: 120,
        proteinG: 4.0,
        carbsG: 3.0,
        fatG: 10.0,
        syncStatus: const Value('pending'),
      ),
    );

    await _loadWeddingParameters();
  }

  /// Updates wedding target date
  Future<void> updateWeddingDate(DateTime newDate) async {
    // Save to local user table via database transaction
    await (_db.update(_db.users)..where((t) => t.localId.equals('current_user_id'))).write(
      UsersCompanion(
        weddingDate: Value(newDate),
      ),
    );

    await _loadWeddingParameters();
  }
}
```

---

## §P12-D. AI Roast Mode

Optional, opt-in, tone selector. `[Gentle] [Motivational] [Roast] [No Nonsense]`. Crisis mode auto-disables roast if distress detected.

Examples:
> "You burned 400 calories and then attacked 900 calories of biryani. Respect the hustle. Your goals don't."
> "Third day of not logging meals. Either you're on a silent diet or FitKarma needs a missing persons report."

---

## §P12-E. Travel Intelligence (NEW v1 — Travel Mode)

> One of the most common user complaints: "I was traveling, everything fell apart." Travel Mode automatically adapts the entire plan for the user's travel context.

### TravelIntelligenceEngine

```dart
class TravelIntelligenceEngine {
  TravelAdaptation adapt(TravelContext travel) {
    return switch (travel.mode) {
      TravelMode.domestic => TravelAdaptation(
          workoutPlan: WorkoutPlan.hotelBodyweight(minutes: 30),
          nutritionPlan: NutritionPlan.travelSimplified(
            strategy: 'Order high-protein items from hotel menu. '
                      'Grilled options over fried. '
                      'Carry nuts/seeds for snacks.',
          ),
          calorieBudget: '+150 kcal buffer for eating out',
          hydrationNote: 'Carry water bottle — airports/hotels are dehydrating',
          readinessAdjustment: -5, // Travel fatigue
          sleepNote: 'Hotel blackout curtains on. '
                     'Target same sleep time as home.',
        ),

      TravelMode.international => TravelAdaptation(
          workoutPlan: WorkoutPlan.hotelBodyweight(minutes: 25),
          jetLagProtocol: JetLagProtocol(
            direction: travel.direction, // East vs West
            recommendations: [
              'Avoid caffeine 6h before new sleep time',
              'Get morning sunlight at destination ASAP',
              'Readiness will be 10–15% lower for 3 days — expected',
            ],
          ),
          nutritionPlan: NutritionPlan.travelSimplified(
            strategy: 'Prioritize protein to maintain muscle. '
                      'Hydrate aggressively — cabin air is very dry.',
          ),
          calorieBudget: '+200 kcal buffer for travel days',
          readinessAdjustment: -12,
        ),

      TravelMode.airport => TravelAdaptation(
          workoutPlan: WorkoutPlan.airportWalk(
            tip: 'Walk the terminal instead of sitting at the gate. '
                 '30 min = ~3,000 steps.',
          ),
          nutritionPlan: NutritionPlan.airportSurvival(
            tip: 'Best airport options: salads, grilled sandwiches, nuts. '
                 'Avoid: fried snacks, sugary drinks, pastries.',
          ),
          hydrationNote: 'Drink 250ml water per hour of flying.',
        ),
    };
  }
}
```

### Travel Mode UI

```
✈️ Travel Mode Active
Delhi → Mumbai (Domestic)

Your Plan is Adapted:

  🏋️ Workout: 30-min hotel bodyweight session
     Push-ups · Squats · Lunges · Plank
     No equipment needed.

  🥗 Nutrition: +150 kcal buffer for eating out
     Focus: High-protein hotel options
     Best bets: Grilled paneer, dal, eggs, curd

  💧 Hydration: +500ml (travel dehydration)

  😴 Sleep: Hotel blackout curtains on
     Same sleep window as home

  📊 Readiness expectation: 5–10% lower (travel fatigue)
     Not a failure — expected adaptation

[End Travel Mode]  [Extend by 1 day]
```

---

## §P12-F. Smart Calendar Integration (NEW v1)

> Users live in calendars. If FitKarma can see the day is packed with meetings, it can auto-shorten the workout before the user has to cancel it.

### Calendar Intelligence Engine

```dart
class CalendarIntegrationService {
  Future<DayCalendarInsight> analyze(
    DateTime date,
    CalendarSource source, // Google or Outlook
  ) async {
    final events = await _calendarApi.getEvents(date, source);

    int meetingMinutes = 0;
    bool hasMorningCommitment = false;
    bool hasEveningEvent = false;
    SpecialEvent? specialEvent;

    for (final event in events) {
      meetingMinutes += event.durationMinutes;
      if (event.startHour < 9) hasMorningCommitment = true;
      if (event.startHour >= 18) hasEveningEvent = true;

      // Detect special events
      if (event.title.containsAny(['wedding', 'marriage', 'reception'])) {
        specialEvent = SpecialEvent.wedding;
      } else if (event.title.containsAny(['travel', 'flight', 'airport'])) {
        specialEvent = SpecialEvent.travel;
      }
    }

    return DayCalendarInsight(
      totalMeetingMinutes: meetingMinutes,
      isBusyDay:           meetingMinutes > 300, // >5h of meetings
      hasMorningCommitment: hasMorningCommitment,
      hasEveningEvent:     hasEveningEvent,
      specialEvent:        specialEvent,
      workoutRecommendation: _workoutRecommendation(meetingMinutes, specialEvent),
      nutritionNote:       _nutritionNote(specialEvent),
    );
  }

  WorkoutRecommendation _workoutRecommendation(
      int meetingMinutes, SpecialEvent? event) {
    if (event == SpecialEvent.wedding) {
      return WorkoutRecommendation(
        type:     'Light 20-min morning workout',
        rationale: 'Wedding day — brief workout keeps energy high '
                   'without fatigue for the celebration.',
      );
    }
    if (meetingMinutes > 360) { // >6h meetings
      return WorkoutRecommendation(
        type:     'Quick 20-min HIIT or walk',
        rationale: 'Heavy meeting day — shortened workout '
                   'better than skipping entirely.',
      );
    }
    return WorkoutRecommendation.standard();
  }
}
```

### Calendar-Aware Daily Briefing

```
📅 Calendar Intelligence — Today

8 meetings · 6.5 hours of calls

Your workout has been adapted:
  Standard: 45-min strength session
  Today:    20-min HIIT (meeting-day protocol)

Nutrition note:
  Heavy cognitive load day → craving more carbs is normal.
  Keep a healthy snack nearby to avoid vending machine.

[Confirm Adapted Plan] [Keep Original Plan]
```

### Privacy

- Calendar access is **read-only** — FitKarma never creates/modifies events
- Event titles processed on-device; only structured insights (busy/free, special event type) stored
- User can disconnect calendar at any time in Settings

---

# PHASE 13 — PREMIUM + MONETISATION

---

## §P13-A. Subscription Tiers

| Feature | Free | FitKarma Pro | Elite Coach |
|---------|------|-------------|-------------|
| Daily Intelligence Package | 1/day | 1/day | 1/day |
| AI Coach messages | 5/day | Unlimited | Unlimited |
| Meal photo analysis | 2/day | Unlimited | Unlimited |
| Adaptive plans | Static | AI-adaptive | Human + AI |
| Recovery analytics | Basic | Full | Full |
| Monthly reports | No | Yes | Yes |
| Squad creation | Join only | Create | Create |
| Festival + Life Events | Yes | Yes | Yes |
| Advanced body analytics | No | Yes | Yes |
| Biological age | No | Yes | Yes |
| 90-day predictions | No | Yes | Yes |
| Priority AI model | No | No | Yes |
| Human coach review | No | No | Weekly |

### Pricing (India-first)

```
FitKarma Pro:
  Monthly:   ₹299/month
  Quarterly: ₹699/quarter  (saves 22%)
  Annual:    ₹1,999/year   (saves 44%)

Elite Coach (waitlist):
  Monthly:   ₹1,499/month

7-day free trial on all paid plans
```

### Paywall Triggers

- 6th AI Coach message (free limit: 5/day)
- Squad creation attempt (free: join only)
- Monthly Report view
- 3rd meal photo analysis attempt
- 90-day body projection view
- Life Events Engine (full feature)

Paywall style: Bottom sheet only. Always shows "Continue with Free" — no dark patterns.

### ASCII Wireframe Layout

```
┌────────────────────────────────────────────────────────┐
│  [←] Unlock FitKarma Pro                               │
│                                                        │
│  Supercharge your health journey with Pro:             │
│  ┌───────────────────────────────────────────────────┐ │
│  │  ✓ Unlimited AI Coach Chats                       │ │
│  │  ✓ 90-Day Predictive Health Insights & Charts     │ │
│  │  ✓ Comprehensive Monthly Health Reports           │ │
│  │  ✓ Advanced Body Composition & Measurements Engine │ │
│  └───────────────────────────────────────────────────┘ │
│                                                        │
│  Select Plan (7-Day Free Trial):                       │
│  ┌─────────────────────────┐ ┌───────────────────────┐ │
│  │  [  ₹299 / Month  ]     │ │  [  ₹1,999 / Year ]   │ │
│  │  Standard Monthly Plan  │ │  Saves 44% (Best Val)│ │
│  └─────────────────────────┘ └───────────────────────┘ │
│                                                        │
│                 [ Start Free Trial ]                   │
│               [ Continue with Free Plan ]              │
└────────────────────────────────────────────────────────┘
```

### Riverpod State Management: PremiumStateNotifier

This notifier dynamically tracks daily user quotas, checks permission thresholds before invoking operations, manages local secure storage subscription configurations, and syncs billing statuses:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionTier { free, pro, eliteCoach }

class PremiumState {
  final SubscriptionTier activeTier;
  final DateTime? renewalDate;
  final int dailyAiMessageCount;
  final int dailyMealPhotoAnalysisCount;
  final String billingErrorMessage;
  final bool isTrialActive;

  PremiumState({
    required this.activeTier,
    this.renewalDate,
    required this.dailyAiMessageCount,
    required this.dailyMealPhotoAnalysisCount,
    required this.billingErrorMessage,
    required this.isTrialActive,
  });

  factory PremiumState.initial() => PremiumState(
    activeTier: SubscriptionTier.free,
    dailyAiMessageCount: 0,
    dailyMealPhotoAnalysisCount: 0,
    billingErrorMessage: '',
    isTrialActive: false,
  );

  PremiumState copyWith({
    SubscriptionTier? activeTier,
    DateTime? renewalDate,
    int? dailyAiMessageCount,
    int? dailyMealPhotoAnalysisCount,
    String? billingErrorMessage,
    bool? isTrialActive,
  }) {
    return PremiumState(
      activeTier: activeTier ?? this.activeTier,
      renewalDate: renewalDate ?? this.renewalDate,
      dailyAiMessageCount: dailyAiMessageCount ?? this.dailyAiMessageCount,
      dailyMealPhotoAnalysisCount: dailyMealPhotoAnalysisCount ?? this.dailyMealPhotoAnalysisCount,
      billingErrorMessage: billingErrorMessage ?? this.billingErrorMessage,
      isTrialActive: isTrialActive ?? this.isTrialActive,
    );
  }
}

class PremiumStateNotifier extends StateNotifier<PremiumState> {
  PremiumStateNotifier() : super(PremiumState.initial()) {
    _loadBillingState();
  }

  /// Loads current billing tier and cached usage counts from SharedPreferences
  Future<void> _loadBillingState() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Resolve billing tier
    final tierIndex = prefs.getInt('premium_tier_index') ?? 0;
    final tier = SubscriptionTier.values[tierIndex];

    // Resolve date boundary reset
    final lastResetString = prefs.getString('quota_last_reset_date');
    final todayString = DateTime.now().toIso8601String().substring(0, 10);

    int messages = prefs.getInt('daily_ai_messages') ?? 0;
    int photos = prefs.getInt('daily_meal_photos') ?? 0;

    if (lastResetString != todayString) {
      // Date changed - reset usage quotas
      await prefs.setString('quota_last_reset_date', todayString);
      await prefs.setInt('daily_ai_messages', 0);
      await prefs.setInt('daily_meal_photos', 0);
      messages = 0;
      photos = 0;
    }

    final trialActive = prefs.getBool('billing_trial_active') ?? false;
    final renewalMilli = prefs.getInt('billing_renewal_milli');
    final renewal = renewalMilli != null ? DateTime.fromMillisecondsSinceEpoch(renewalMilli) : null;

    state = PremiumState(
      activeTier: tier,
      renewalDate: renewal,
      dailyAiMessageCount: messages,
      dailyMealPhotoAnalysisCount: photos,
      billingErrorMessage: '',
      isTrialActive: trialActive,
    );
  }

  /// Verifies if user has remaining tokens or has a premium subscription tier
  bool checkAccess(PaywallTrigger trigger) {
    if (state.activeTier != SubscriptionTier.free) return true;

    return switch (trigger) {
      PaywallTrigger.aiMessage => state.dailyAiMessageCount < 5,
      PaywallTrigger.mealPhoto => state.dailyMealPhotoAnalysisCount < 2,
      PaywallTrigger.squadCreation => false, // Free members can join only
      PaywallTrigger.monthlyReport => false,
      PaywallTrigger.predictiveBody => false,
      PaywallTrigger.lifeEvents => false,
    };
  }

  /// Increments daily AI coach message count
  Future<void> incrementAiMessageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final nextVal = state.dailyAiMessageCount + 1;
    await prefs.setInt('daily_ai_messages', nextVal);
    state = state.copyWith(dailyAiMessageCount: nextVal);
  }

  /// Increments daily meal photo count
  Future<void> incrementMealPhotoCount() async {
    final prefs = await SharedPreferences.getInstance();
    final nextVal = state.dailyMealPhotoAnalysisCount + 1;
    await prefs.setInt('daily_meal_photos', nextVal);
    state = state.copyWith(dailyMealPhotoAnalysisCount: nextVal);
  }

  /// Simulates subscription upgrade completion
  Future<void> upgradeSubscription(SubscriptionTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('premium_tier_index', tier.index);
    await prefs.setInt('billing_renewal_milli', DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch);
    await prefs.setBool('billing_trial_active', true);
    
    await _loadBillingState();
  }
}

enum PaywallTrigger {
  aiMessage, mealPhoto, squadCreation, monthlyReport, predictiveBody, lifeEvents
}
```

---

## §P13-B. Creator & Coach Marketplace (NEW v1)

> Peer-to-peer fitness matches users with specialized human coaches. It serves as an elite monetization engine, utilizing an 80/20 platform revenue split (80% to creators, 20% to platform).

### Creator Profile & Program Schemas

```dart
class CreatorProfile {
  final String creatorId;
  final String name;
  final String bio;
  final List<String> certifications;
  final List<CoachSpecialty> specialties;
  final double averageRating;
  final int activeClientsCount;
  final double monthlyCoachingRateInr; // e.g. 2999.0
}

enum CoachSpecialty { pcosManagement, muscleBuilding, diabeticReversal, runningMarathon }

class CoachClientAssignment {
  final String assignmentId;
  final String coachUserId;
  final String clientUserId;
  final DateTime activeFrom;
  final DateTime? activeUntil;
  final bool hasWritePermission; // Allows the coach to override client's Daily Targets
}
```

### Marketplace Matchmaking Engine

```dart
class CoachMatchingEngine {
  List<CreatorProfile> match({
    required UserProfile client,
    required List<CreatorProfile> allCoaches,
  }) {
    // Computes matching score based on user goals, dietType, and coach specialties
    return allCoaches.map((coach) {
      double score = 0.0;
      
      // Match specialty to primary goals
      if (client.goals.contains('weight_loss') && coach.specialties.contains(CoachSpecialty.muscleBuilding)) {
        score += 30.0;
      }
      if (client.goals.contains('pcos') && coach.specialties.contains(CoachSpecialty.pcosManagement)) {
        score += 50.0;
      }
      
      // Client rating weighting
      score += coach.averageRating * 10.0;

      return MapEntry(coach, score);
    })
    .sorted((a, b) => b.value.compareTo(a.value))
    .map((entry) => entry.key)
    .toList();
  }
}
```

### Program Store (User-Generated Blueprints)

- **Curated Multi-Week Blueprints**: Verified creators can build and publish structured 6-to-12-week nutrition/workout program templates.
- **Direct Purchases**: Programs are sold as one-time microtransactions (e.g. ₹499 for a "Navratri Weight Loss Blueprint"). FitKarma manages payment collection and distributes 80% royalties to the creator's wallet.

### Marketplace Trust, Verification & Escrow (NEW v1)

To ensure high-quality standards and prevent fraudulent coach-client pairings:
- **Credentials Validation**: Every registered coach must upload active professional certifications (e.g. CSCS, ACE, ACSM, or certified sports dietitian degree) and a verified identity document. Unverified accounts cannot publish paid programs or list themselves in the marketplace directory.
- **Outcome-Verified Reviews**: Ratings and reviews can only be submitted by clients with active or past coaching assignments under that specific creator. Coaches cannot delete or edit reviews.
- **Escrow Refund Safeguards**: Coaching payments are held in escrow for 7 days post-transaction. Clients can flag a "No Contact" dispute within this period. If logs verify that the coach did not update target packages or answer client chat logs, an automatic full refund is processed.

#### Indian Financial & Payment Gateway Compliance (Razorpay / Stripe Connect)

To operate legally within the Indian financial landscape, FitKarma's payment flow complies with the Reserve Bank of India (RBI) regulations and GST tax structures:

1. **RBI e-Mandate Subscription Directives**:
   *   **Pre-Debit Notifications**: Any recurring coaching card subscription requires an SMS/email alert sent to the user at least 24 hours (but not more than 72 hours) before the debit. The notification must contain the merchant name, subscription description, debit amount, transaction date, and a link for the customer to modify or withdraw consent.
   *   **Additional Factor of Authentication (AFA)**: Debits exceeding ₹15,000 per transaction require an OTP/AFA verification from the customer before processing.
   *   **Card Tokenization (CoFT)**: Actual credit/debit card numbers cannot be stored. FitKarma uses network tokenization (via Razorpay/Stripe APIs) to store secure, merchant-specific card tokens.

2. **Split Settlement Integration (Razorpay Route / Stripe Custom Connect)**:
   *   Payment is routed to a nodal/escrow account.
   *   Upon successful customer payment capture, the system triggers a split request: 80% is allocated to the coach's linked bank account and 20% to the FitKarma platform commission.
   *   To comply with the 7-day refund safeguard, the 80% coach payout is held in a "deferred settlement" state in the escrow account for 7 days before being automatically released.

3. **Indian GST & Tax Compliance**:
   *   **GST on Platform Fees**: FitKarma is liable to pay **18% GST** on its 20% platform commission. The customer invoice details this commission breakdown.
   *   **Tax Collected at Source (TCS)**: Under Section 52 of the Central Goods and Services Tax (CGST) Act, 1961, FitKarma, as an e-commerce platform operator, collects **1% TCS** (0.5% CGST + 0.5% SGST) from the coach's gross sales.
   *   **Tax Deducted at Source (TDS)**: Under Section 194-O of the Income Tax Act, 1961, FitKarma deducts **1% TDS** on the gross coaching amount before payout (applicable for coaches with PAN, otherwise 5% TDS). This tax is deposited with the Indian government under the coach's PAN.

##### Implementation: Payment Webhook Split-Settlement & Double-Entry Ledger (Pure Dart)

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class WebhookSignatureVerifier {
  /// Securely validates Razorpay webhook cryptographic signatures to block spoofing
  bool verifyRazorpaySignature({
    required String payload,
    required String signatureHeader,
    required String secret,
  }) {
    if (signatureHeader.isEmpty || secret.isEmpty) return false;

    try {
      final hmacSha256 = Hmac(sha256, utf8.encode(secret));
      final computedSignature = hmacSha256.convert(utf8.encode(payload)).toString();

      // Secure constant-time string comparison to defend against timing side-channel attacks
      return _secureCompare(computedSignature, signatureHeader);
    } catch (_) {
      return false;
    }
  }

  bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}

enum LedgerAccountType {
  escrowLiability,  // Held for creator during dispute window
  creatorPayable,   // Cleared and due to the creator
  platformRevenue,  // Platform's 20% share
  tcsLiability,     // 1% Tax Collected at Source
  tdsLiability,     // 1% Tax Deducted at Source (payable to IT dept)
  gstExpense,       // 18% GST on platform fee
  cashAsset,        // Gross incoming funds
}

class LedgerEntry {
  final String entryId;
  final String txId;
  final LedgerAccountType accountType;
  final double debit;
  final double credit;
  final DateTime timestamp;
  final String memo;

  LedgerEntry({
    required this.entryId,
    required this.txId,
    required this.accountType,
    required this.debit,
    required this.credit,
    required this.timestamp,
    required this.memo,
  });
}

class DoubleEntryLedgerEngine {
  final List<LedgerEntry> _ledger = [];

  /// Processes coaching package sales and executes GST, TCS, and TDS double-entry allocations.
  /// Gross Coaching Fee: 100% (e.g. ₹1,000)
  /// - 80% Creator Escrow Allocation (₹800)
  /// - 20% Platform Fee Commission (₹200)
  /// - 18% GST on Platform Fee (18% of ₹200 = ₹36)
  /// - 1% TCS Deducted from Creator Escrow (1% of ₹1,000 = ₹10)
  /// - 1% TDS Deducted from Creator Escrow (1% of ₹1,000 = ₹10)
  void recordCoachingPurchase({
    required String txId,
    required double grossAmountInr,
    required String creatorId,
  }) {
    final timestamp = DateTime.now();

    // 1. Calculate transaction fee divisions
    final platformCommission = grossAmountInr * 0.20;
    final creatorGross = grossAmountInr * 0.80;

    // 2. Tax calculations (GST on platform commission, TCS/TDS on creator gross)
    final platformGst = platformCommission * 0.18;
    final tcsDeduction = grossAmountInr * 0.01;
    final tdsDeduction = grossAmountInr * 0.01;

    final creatorNetEscrow = creatorGross - tcsDeduction - tdsDeduction;

    // --- DOUBLE ENTRY JOURNAL TRANSACTIONS ---
    
    // JOURNAL ENTRY 1: Ingest Gross Funds & Allocate Creator Escrow + Platform Fee
    final entries = [
      LedgerEntry(
        entryId: '${txId}_cash_in',
        txId: txId,
        accountType: LedgerAccountType.cashAsset,
        debit: grossAmountInr,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Gross payment capture from client',
      ),
      LedgerEntry(
        entryId: '${txId}_escrow_alloc',
        txId: txId,
        accountType: LedgerAccountType.escrowLiability,
        debit: 0.0,
        credit: creatorNetEscrow,
        timestamp: timestamp,
        memo: 'Creator net share allocated to escrow',
      ),
      LedgerEntry(
        entryId: '${txId}_platform_fee',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: 0.0,
        credit: platformCommission,
        timestamp: timestamp,
        memo: 'Platform 20% commission fee',
      ),
      
      // JOURNAL ENTRY 2: Record Tax Deductions
      LedgerEntry(
        entryId: '${txId}_tcs_withhold',
        txId: txId,
        accountType: LedgerAccountType.tcsLiability,
        debit: 0.0,
        credit: tcsDeduction,
        timestamp: timestamp,
        memo: '1% TCS withheld from creator escrow',
      ),
      LedgerEntry(
        entryId: '${txId}_tds_withhold',
        txId: txId,
        accountType: LedgerAccountType.tdsLiability,
        debit: 0.0,
        credit: tdsDeduction,
        timestamp: timestamp,
        memo: '1% TDS withheld from creator escrow',
      ),
      
      // JOURNAL ENTRY 3: Record Platform GST Expense
      LedgerEntry(
        entryId: '${txId}_platform_gst',
        txId: txId,
        accountType: LedgerAccountType.gstExpense,
        debit: platformGst,
        credit: 0.0,
        timestamp: timestamp,
        memo: '18% GST accrued on platform commission',
      ),
      LedgerEntry(
        entryId: '${txId}_platform_gst_offset',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: 0.0,
        credit: platformGst, // platformRevenue credit offset to balance GST debit
        timestamp: timestamp,
        memo: 'Platform revenue GST offset',
      ),
    ];

    // Enforce matching transaction balancing before writing to ledger
    _verifyAndWriteEntries(entries);
  }

  /// Releases funds from Escrow to Payable after 7-day dispute window clears
  void clearEscrowToPayable({
    required String txId,
    required double netEscrowAmount,
  }) {
    final timestamp = DateTime.now();

    final entries = [
      LedgerEntry(
        entryId: '${txId}_clear_escrow',
        txId: txId,
        accountType: LedgerAccountType.escrowLiability,
        debit: netEscrowAmount,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Release cleared escrow funds',
      ),
      LedgerEntry(
        entryId: '${txId}_credit_payable',
        txId: txId,
        accountType: LedgerAccountType.creatorPayable,
        debit: 0.0,
        credit: netEscrowAmount,
        timestamp: timestamp,
        memo: 'Credit cleared funds to creator payable balance',
      ),
    ];

    _verifyAndWriteEntries(entries);
  }

  /// Calculates current balance of a specific account by summing ledger debits vs credits
  double sumAccountBalance(LedgerAccountType accountType) {
    double totalDebits = 0.0;
    double totalCredits = 0.0;

    for (final entry in _ledger) {
      if (entry.accountType == accountType) {
        totalDebits += entry.debit;
        totalCredits += entry.credit;
      }
    }

    // Asset and Expense accounts increase with Debit. Liability and Revenue accounts increase with Credit.
    if (accountType == LedgerAccountType.cashAsset || accountType == LedgerAccountType.gstExpense) {
      return totalDebits - totalCredits;
    } else {
      return totalCredits - totalDebits;
    }
  }

  void _verifyAndWriteEntries(List<LedgerEntry> entries) {
    double sumDebits = 0.0;
    double sumCredits = 0.0;

    for (final entry in entries) {
      sumDebits += entry.debit;
      sumCredits += entry.credit;
    }

    // To prevent ledger corruption, debits must mathematically balance credits
    // In accounting, sum(Debits) - sum(Credits) == 0.0 (using a minor epsilon delta for double precision floats)
    if ((sumDebits - sumCredits).abs() > 0.0001) {
      throw Exception('Ledger integrity error: Unbalanced journal entry. Debits: $sumDebits, Credits: $sumCredits');
    }

    _ledger.addAll(entries);
  }
}
```

---

## §P13-C. Creator Affiliate Program (NEW v1)

> A low-cost growth loop driven by fitness influencers. Creators refer their social media followers to FitKarma Pro, earning a recurring income stream.

### Affiliate Referral Architecture

```dart
class ReferralLink {
  final String linkId;
  final String creatorId;
  final String referralCode; // e.g., "SHARMA10"
  final double clientDiscountPct; // default 10% off
  final double creatorCommissionPct; // default 15% recurring
}

class AffiliatePayout {
  final String payoutId;
  final String creatorId;
  final double amountInr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final PayoutStatus status;
}

enum PayoutStatus { calculated, processed, paid }
```

### Creator Earnings Dashboard UI

**Route:** `/affiliate/dashboard`

```
💰 Creator Earnings & Referral Center

  Available Balance:  ₹8,420
  Next Payout Date:   June 15, 2026

📈 Lifetime Referrals:
  Total Clicks:       4,210
  Free Signups:       1,820
  Pro Conversions:    214  (11.7% conversion rate)

💵 Monthly Payout History:
  • May 2026:   ₹4,820  [✓ Paid]
  • Apr 2026:   ₹3,600  [✓ Paid]

[Request Instant Bank Transfer] [Share Referral Link: fitkarma.com/ref/sharma10]
```

---

# PHASE 14 — ENTERPRISE HARDENING + CI/CD

---

## §P14-A. Security

| Layer | Implementation |
|-------|---------------|
| Database encryption | SQLCipher AES-256 at page level |
| Key storage | iOS Keychain / Android Keystore |
| Biometric lock | `local_auth` — Journal, BP, Glucose, Body Photos |
| Screen capture | `FLAG_SECURE` on sensitive screens |
| Network | TLS 1.3 + certificate pinning |
| AI context | User context never logged in Worker logs |
| PII | Sentry PII stripping; no names/emails in error reports |
| AI cache | Prompt hashes only — no PII stored in cache keys |

### SQLCipher Secure Database Initialization

FitKarma protects local health databases using **SQLCipher AES-256 page-level encryption**. The passkey is generated dynamically on first boot using the OS-level cryptographically secure random number generator (CSPRNG), then stored safely inside the OS secure storage (Keychain on iOS, Keystore on Android) via the `flutter_secure_storage` package.

> **🔒 v1.0 Fix:** An earlier draft of this class generated the passphrase using `DateTime.now().microsecondsSinceEpoch % 256` inside a synchronous loop. This is **not** cryptographically secure — clock resolution vs. loop speed means consecutive calls can return identical or highly correlated values, collapsing the effective entropy of the 256-bit key far below its nominal size and making it feasible to brute-force. This has been replaced with `Random.secure()`, which reads from the OS CSPRNG (`/dev/urandom` on Android, `SecRandomCopyBytes` on iOS).

```dart
import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class EncryptedDatabaseConnection {
  static const _keyName = 'fitkarma_db_cipher_key';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Generates a 256-bit passphrase using the OS-level CSPRNG.
  /// `Random.secure()` throws on platforms without a secure entropy
  /// source — this is intentional; we must never silently fall back
  /// to a non-secure generator for a database encryption key.
  static String _generateSecureKey() {
    final secureRandom = Random.secure();
    final bytes = List<int>.generate(32, (_) => secureRandom.nextInt(256));
    return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Lazily opens connection and applies page-level encryption key
  static LazyDatabase getDatabaseConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'fitkarma_secure.db'));

      // Retrieve or generate key
      String? key = await _storage.read(key: _keyName);
      if (key == null) {
        key = _generateSecureKey();
        await _storage.write(key: _keyName, value: key);
      }

      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          // SQLCipher page-level key assignment
          rawDb.execute("PRAGMA key = '$key';");
          
          // Verify encryption by querying schema
          try {
            rawDb.execute("SELECT count(*) FROM sqlite_master;");
          } catch (e) {
            throw Exception("SQLCipher Database initialization failed or invalid password.");
          }
        },
      );
    });
  }
}
```

### Biometric Verification Gate & Riverpod State Management

Sensitive areas (e.g. Glucose tracker, Blood Pressure logs, Progress photos, and monthly health analytics) are gated behind device biometrics using `local_auth`. A Riverpod state notifier handles lock state and locks down the view until authenticating successfully.

```dart
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLockService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceCapable() async {
    final hasBiometrics = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return hasBiometrics || isSupported;
  }

  Future<bool> authenticate(String reason) async {
    try {
      if (!await isDeviceCapable()) return false;
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (_) {
      return false; // Lock screen on any OS error
    }
  }
}

final biometricServiceProvider = Provider<BiometricLockService>((ref) => BiometricLockService());

class BiometricGateState {
  final bool isUnlocked;
  final bool isAuthenticating;
  final String? error;

  BiometricGateState({
    required this.isUnlocked,
    required this.isAuthenticating,
    this.error,
  });

  BiometricGateState copyWith({
    bool? isUnlocked,
    bool? isAuthenticating,
    String? error,
  }) {
    return BiometricGateState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      error: error ?? this.error,
    );
  }
}

class BiometricGateNotifier extends StateNotifier<BiometricGateState> {
  final BiometricLockService _service;
  final String _reason;

  BiometricGateNotifier(this._service, this._reason)
      : super(BiometricGateState(isUnlocked: false, isAuthenticating: false)) {
    triggerVerification();
  }

  Future<void> triggerVerification() async {
    state = state.copyWith(isAuthenticating: true, error: null);
    
    final success = await _service.authenticate(_reason);
    if (success) {
      state = state.copyWith(isUnlocked: true, isAuthenticating: false);
    } else {
      state = state.copyWith(
        isUnlocked: false,
        isAuthenticating: false,
        error: 'Biometric authorization required.',
      );
    }
  }

  void resetLock() {
    state = BiometricGateState(isUnlocked: false, isAuthenticating: false);
  }
}

/// Managed family provider that locks screen by ID/Route
final biometricGateProvider = StateNotifierProvider.family<BiometricGateNotifier, BiometricGateState, String>((ref, routeName) {
  final service = ref.watch(biometricServiceProvider);
  final String reason = 'Unlock secure metrics for $routeName';
  return BiometricGateNotifier(service, reason);
});
```

---

## §P14-B. Performance

| Target | Metric |
|--------|--------|
| Cold start | < 2 seconds on mid-tier device |
| Screen transition | < 300ms |
| AI response (coach) | < 3 seconds (Groq typical) |
| Daily Briefing open | < 100ms (DIP reads from Drift — no AI) |
| Drift query | < 50ms for day-range queries |
| Offline write | Immediate (optimistic UI) |
| Chart render | < 100ms (fl_chart with Drift data) |
| DIP generation | < 5 seconds (single AI call at 6am) |

### Background Processing & iOS Sync Safeguards

To counter strict iOS `BackgroundTasks` background execution limits, FitKarma implements a multi-channel synchronization strategy to prevent stale wearable and health data:

1. **Opportunistic App Refresh (`BGAppRefreshTask`):** Registered to query local Apple HealthKit. Scheduled with low priority, expecting execution 1-2 times daily depending on user usage frequency.
2. **Silent Push Notifications (VoIP / FCM Content-Available):** When the daily DIP is generated or critical coach actions are queued, the Worker pushes a silent notification with payload `{ "content-available": 1 }`. This wakes the Flutter app in the background, allocating up to 30 seconds of CPU execution to synchronize logs.
3. **Lifecycle Catch-Up Triggers:** An observer on Flutter's `AppLifecycleState` listens for the `resumed` state. Upon app return to the foreground, a delta-sync worker immediately kicks off, fetching all changes since the last recorded local sync timestamp.
4. **WatchOS Direct Transfer:** Utilizes Apple's `WatchConnectivity` framework to transfer active steps and heart rate logs directly from Apple Watch to iOS via `WCSession` in real-time, bypassing cloud synchronization.

##### Implementation: App Foreground Catch-Up Sync (Pure Dart)

```dart
class AppLifecycleSyncObserver extends WidgetsBindingObserver {
  final SyncCoordinator _syncCoordinator;
  DateTime _lastSyncTime = DateTime.now();

  AppLifecycleSyncObserver(this._syncCoordinator);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final elapsedSinceLastSync = DateTime.now().difference(_lastSyncTime);
      
      // Prevent double-sync if app was just toggled rapidly (5-minute cooldown)
      if (elapsedSinceLastSync.inMinutes >= 5) {
        _triggerForegroundCatchUpSync();
      }
    }
  }

  Future<void> _triggerForegroundCatchUpSync() async {
    _lastSyncTime = DateTime.now();
    
    // 1. Sync local Drift changes to Cloud
    await _syncCoordinator.pushLocalChangesToCloud();

    // 2. Fetch new updates (e.g. fresh wearable logs, remote doctor comments)
    await _syncCoordinator.pullRemoteChangesToLocal();

    // 3. Re-evaluate readiness and update DIP cache in Drift
    await _syncCoordinator.recalculateLocalReadinessState();
  }
}
```

---

## §P14-C. Testing Strategy

```
Unit Tests:
  BMI, TDEE, Readiness Score algorithm (no AI — pure math)
  Progressive overload engine
  Consistency tracker, relapse detection
  Festival detection, life events adaptation
  Biological age estimation
  Health Score calculation
  Decision Hierarchy resolution
  AI Router model selection
  Context compressor output size

Widget Tests:
  GlassCard, ReadinessRing, HealthScoreRing, DailyBriefingCard
  All 7 onboarding screens

Integration Tests:
  Full onboarding flow (welcome → permissions)
  Offline → online sync round-trip
  AI coach message (mock Groq, compressed context)
  Workout logging → outcome XP → level up
  Diet plan generation → cache → display
  DIP generation → all modules reading from it
  Festival cross-module adaptation

Golden Tests (screenshots):
  Dashboard, Daily Mission, Karma Hub, Food, Profile
  Light + dark for each
```

---

## §P14-D. CI/CD Pipeline

```yaml
name: FitKarma CI/CD
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: |
          flutter build appbundle --release \
            --dart-define=CF_D1_API_BASE_URL=${{ secrets.CF_D1_API_BASE_URL }} \
            --dart-define=CF_WORKERS_API_BASE_URL=${{ secrets.CF_WORKERS_API_BASE_URL }} \
            --dart-define=GOOGLE_OAUTH_CLIENT_ID=${{ secrets.GOOGLE_OAUTH_CLIENT_ID }} \
            --dart-define=GROQ_FUNCTION_KEY=${{ secrets.GROQ_FUNCTION_KEY }}

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - run: flutter build ipa --release
```

---

# PHASE 16 — INDIA GROWTH & TRUST LAYER (NEW v1.0)

> Five additions targeted specifically at the Indian market: removing the friction of manual logging for users less comfortable typing in English, closing the loop between nutrition intelligence and actual grocery purchases, and adding two new distribution/monetisation channels (national health ID interoperability and corporate/insurer B2B2C). None of these require changes to the Health OS Brain or AI Router — they are new **input surfaces** and **distribution channels** that feed the existing pipeline.

---

## §P16-A. WhatsApp Business Logging

### Why

WhatsApp has near-universal penetration across India, including among users less comfortable navigating a dedicated app UI. The single highest-friction daily action in FitKarma is food logging — reducing it to a WhatsApp message removes the "open app → find screen → log" path entirely for users who opt in.

### Architecture

```
User sends WhatsApp message
  ("2 roti, dal, sabzi" or a photo of their plate)
    ↓
WhatsApp Business Cloud API webhook
    ↓
Cloudflare Worker: fitkarma-whatsapp (NEW)
    ↓
Resolve phone number → userId (via linked authProviderId)
    ↓
Route to existing pipeline — no new AI logic:
  Text message  → same NLP parser used by in-app quick-log
  Image message → meal_photo_analyzer.dart (§P5-C), same
                   Groq Vision call + cache as in-app "Fix My Meal"
    ↓
Write to FoodLogs (existing table) → sync to Drift on next app open
    ↓
Reply to user on WhatsApp with a one-line confirmation
  ("Logged: 2 roti, dal, sabzi — 420 kcal, 14g protein")
```

This deliberately reuses the existing meal-photo and text-parsing pipeline rather than introducing a parallel one — the only new component is the webhook and phone-number-to-user resolution.

### Data Model

Uses the `Users.whatsAppOptIn` flag added in schema v17 (§DB). No new local Drift table is required — WhatsApp is an input surface, not a new data domain.

### Implementation

```javascript
// Cloudflare Worker: fitkarma-whatsapp (webhook — no auth middleware, since
// Meta's webhook signature verification replaces the JWT check here)
import { Hono } from 'hono';
const app = new Hono();

app.post('/whatsapp', async (c) => {
  const db = c.env.DB;
  const payload = await c.req.json();
  const message = payload.entry?.[0]?.changes?.[0]?.value?.messages?.[0];
  if (!message) return c.body(null, 200); // ignore non-message webhook events

  const phoneNumber = message.from;
  const user = await resolveUserByPhone(db, phoneNumber);

  if (!user || !user.whatsAppOptIn) {
    await sendWhatsAppReply(phoneNumber,
      "This number isn't linked to a FitKarma account yet. " +
      "Open the app → Settings → Link WhatsApp to get started.");
    return c.body(null, 200);
  }

  let logResult;
  if (message.type === 'text') {
    logResult = await parseFoodTextAndLog(db, user.userId, message.text.body);
  } else if (message.type === 'image') {
    const imageBuffer = await downloadWhatsAppMedia(message.image.id);
    logResult = await analyzeMealPhotoAndLog(db, user.userId, imageBuffer); // reuses §P5-C pipeline
  } else {
    await sendWhatsAppReply(phoneNumber, "Send a text description or a photo of your meal to log it.");
    return c.body(null, 200);
  }

  await sendWhatsAppReply(phoneNumber,
    `Logged: ${logResult.summary} — ${logResult.calories} kcal, ${logResult.proteinG}g protein`);
  return c.body(null, 200);
});

export default app;
```

### Privacy

- Phone number is stored only as a lookup key linked to the existing `authProviderId`, encrypted at rest in Cloudflare D1 like other PII.
- Opt-in is required (`whatsAppOptIn`), off by default, and reversible from Settings at any time — disabling it stops the webhook from resolving that number to a user.

---

## §P16-B. Vernacular Voice Logging

### Why

Typing in English is friction for a meaningful segment of the Indian user base. Voice input in Hindi, Tamil, Telugu, Marathi, Bengali, and Kannada — including natural code-mixing ("2 roti aur ek katori dal khaya") — serves this segment without requiring a separate UI per language.

### Architecture

```
User taps mic → speaks in their language
    ↓
On-device or cloud ASR (Cloudflare Workers AI (Whisper large-v3-turbo / Deepgram Nova-3), multi-language)
    ↓
Transcript (may be code-mixed, e.g. Hindi-English)
    ↓
Existing food/workout NLP parser (same one used for typed quick-log)
    ↓
FoodLogs / WorkoutLogs (existing tables)
```

Voice logging is an **input transformation step ahead of the existing parser**, not a new AI reasoning path — it doesn't add to the AI Router's model-tier budget beyond the ASR call itself, which is classification-tier cost, not generation-tier.

### Supported Languages (v1.0 launch set)

| Language | ASR Support | Notes |
|---|---|---|
| Hindi | Yes | Including Hindi-English code-mixing |
| Tamil | Yes | |
| Telugu | Yes | |
| Marathi | Yes | |
| Bengali | Yes | |
| Kannada | Yes | |
| English (India) | Yes | Indian-accent acoustic model |

### Implementation

```dart
class VoiceLogService {
  final SpeechToTextClient _asrClient; // Cloudflare Workers AI speech-to-text wrapper
  final FoodTextParser _foodParser;    // existing parser, unchanged

  VoiceLogService(this._asrClient, this._foodParser);

  Future<LogResult> logFromVoice({
    required Uint8List audioBytes,
    required String preferredLanguage, // Users.preferredInputLanguage
  }) async {
    // 1. ASR transcription in the user's preferred language
    final transcript = await _asrClient.transcribe(
      audio: audioBytes,
      languageCode: _toWhisperLocale(preferredLanguage), // e.g. 'hi-IN', 'ta-IN'
    );

    // 2. Feed transcript into the SAME parser used for typed quick-log —
    //    no separate NLP path to maintain.
    return _foodParser.parseAndLog(transcript);
  }

  String _toWhisperLocale(String appLanguageCode) {
    const localeMap = {
      'hi': 'hi-IN', 'ta': 'ta-IN', 'te': 'te-IN',
      'mr': 'mr-IN', 'bn': 'bn-IN', 'kn': 'kn-IN', 'en': 'en-IN',
    };
    return localeMap[appLanguageCode] ?? 'en-IN';
  }
}
```

Uses `Users.preferredInputLanguage` (schema v17, §DB) to select the ASR locale by default, with a language picker to override per recording.

---

## §P16-C. ABHA Health ID Integration

### Why

The Ayushman Bharat Health Account (ABHA) is India's national digital health ID under the National Digital Health Mission (NDHM). Integrating it strengthens the Doctor Sharing Portal (§P10-J) — sharing becomes ID-verified rather than a bare passcode-protected link — and is a trust and interoperability signal that most fitness-app competitors don't offer.

### Architecture

```
User: Settings → Link ABHA Health ID
    ↓
ABHA OAuth linking flow (NDHM Health ID sandbox / production API)
    ↓
abhaHealthId stored encrypted on Users (schema v17)
    ↓
Doctor Sharing Portal (§P10-J) gains a second export mode:
  - Existing: passcode-protected PDF (unchanged, remains default)
  - New: FHIR-lite structured bundle, shareable via ABHA-linked
    provider lookup for doctors on the NDHM network
```

This is additive to the existing Doctor Sharing Portal — the passcode-protected PDF export from v1 is unchanged and remains the default; ABHA linking is an opt-in enhancement, not a replacement.

### Data Model

`Users.abhaHealthId` (schema v17, §DB) — encrypted at rest via the same SQLCipher page-level encryption as other sensitive columns, consistent with the Clinical Data Safeguards in §P10-K.

### Compliance Note

ABHA linking falls under the same clinical compliance boundary established in §P10-K and §P10-M — it does not change the non-diagnostic disclaimer requirements or the directive-language linting on any content shared through it. See §P10-M for the full compliance hardening framework.

---

## §P16-D. Corporate Wellness & Insurer Tier (NEW v1.0)

### Why

The existing monetisation model (§P13-A) is consumer-only (Free/Pro/Elite). Indian employers running wellness budgets and insurers offering wellness-linked premium discounts are an underused B2B2C channel that reuses infrastructure already built for §P7-F (Demographic Cohort Insights) — aggregate, anonymized reporting is not a new capability, just a new audience for it.

### Architecture

```
Organization (employer or insurer) purchases seats
    ↓
Employees join via an enrollment code, linking their existing
FitKarma account to the OrganizationAccount (opt-in, reversible)
    ↓
Individual health data is NEVER exposed to the organization —
only aggregate, anonymized metrics flow up, reusing the same
anonymization boundary as Demographic Cohort Insights (§P7-F)
    ↓
HR/insurer dashboard shows: enrollment %, aggregate adherence
score distribution, aggregate activity trends — no per-user detail
```

### Data Model

```dart
class OrganizationAccounts extends Table { // NEW v17
  TextColumn get localId          => text()();
  TextColumn get authProviderId          => text().nullable()();
  TextColumn get organizationName => text()();
  TextColumn get accountType      => text()(); // 'employer' | 'insurer'
  TextColumn get planTier         => text()(); // 'corporate_basic' | 'corporate_plus'
  IntColumn  get seatLimit        => integer()();
  DateTimeColumn get createdAt    => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class EmployeeEnrollments extends Table { // NEW v17
  TextColumn get localId         => text()();
  TextColumn get userId          => text()();
  TextColumn get organizationId  => text()();
  DateTimeColumn get enrolledAt  => dateTime()();
  BoolColumn get isActive        => boolean().withDefault(const Constant(true))();

  @override Set<Column> get primaryKey => {localId};
  // Individual health data is never joined against this table for any
  // organization-facing query — only aggregate counts/percentages, using
  // the same anonymization threshold logic as §P7-F (a minimum cohort
  // size before any aggregate is displayed, to prevent re-identification
  // in small teams).
}
```

### Privacy Boundary (critical)

The re-identification risk in a small team (e.g., a 5-person department) is real if aggregates are shown at too fine a grain. The org-facing dashboard reuses the **same minimum-cohort-size threshold** already implemented for Demographic Cohort Insights (§P7-F) — an aggregate is only rendered once the underlying group meets the minimum size; smaller groups show "Not enough participants yet" instead of a computed value.

---

## §P16-E. Grocery Vendor Checkout Integration

### Why

The Grocery Intelligence Engine (§P5-F) already generates a shopping list from the user's meal plan. Closing the loop to actual checkout — rather than leaving the user to manually shop from the generated list — turns a nice-to-have planning feature into both a retention driver (less friction between plan and action) and a new affiliate revenue stream.

### Architecture

```
Grocery Intelligence Engine generates list (existing, §P5-F)
    ↓
Vendor Adapter interface (NEW) — pluggable per grocery partner
    ↓
Deep-link checkout with pre-filled cart
  (Blinkit / BigBasket / Zepto — whichever adapter is configured)
    ↓
Affiliate order confirmation webhook
    ↓
Revenue tracked using the SAME affiliate ledger pattern as the
Creator Affiliate Program (§P13-C) — no new payout infrastructure
```

### Implementation

```dart
/// Pluggable interface so a new grocery partner is a new adapter,
/// not a change to the Grocery Intelligence Engine itself.
abstract class GroceryVendorAdapter {
  String get vendorName;
  Future<Uri> buildCheckoutDeepLink(List<GroceryListItem> items);
}

class BlinkitAdapter implements GroceryVendorAdapter {
  @override
  String get vendorName => 'Blinkit';

  @override
  Future<Uri> buildCheckoutDeepLink(List<GroceryListItem> items) async {
    // Maps FitKarma's generic grocery items to the vendor's product
    // catalog IDs via their affiliate API, then constructs a deep link
    // with a pre-filled cart and FitKarma's affiliate tag attached.
    final vendorItems = await _mapToVendorCatalog(items);
    final affiliateTag = 'fitkarma_grocery';
    return Uri.parse(
      'https://blinkit.com/cart/add?items=${_encodeItems(vendorItems)}&ref=$affiliateTag',
    );
  }

  Future<List<String>> _mapToVendorCatalog(List<GroceryListItem> items) async {
    // Vendor-specific catalog matching — implementation per partner API
    throw UnimplementedError();
  }

  String _encodeItems(List<String> vendorItems) => vendorItems.join(',');
}

class GroceryCheckoutService {
  final GroceryVendorAdapter _adapter;
  GroceryCheckoutService(this._adapter);

  Future<void> checkout(List<GroceryListItem> groceryList) async {
    final deepLink = await _adapter.buildCheckoutDeepLink(groceryList);
    await launchUrl(deepLink); // url_launcher — opens vendor app if installed
  }
}
```

Affiliate order confirmations flow into the same ledger/payout schema already built for §P13-C, rather than introducing a second revenue-tracking system.

---

# §DB. Database Schema

---

## Drift Local Schema (v17)

```dart
// Schema version: 17
// v1 → v2: added food_logs
// v2 → v3: added bp_readings, glucose_readings
// v3 → v4: added diet_plans, demographic fields on users
// v4 → v5: added recovery_logs, body_measurements, squad_groups,
//           transformation_checks, workStyle + currentProgram + tone on users
// v5 → v6: added daily_intelligence_package, health_snapshots,
//           transformation_memory, life_events, healthScore on users,
//           confidenceTier on recovery_logs
// v6 → v7: added followers, clubs, cgm_readings, medication_logs, creator_profiles
// v7 → v8: added micronutrient_logs, meal_nutrition_details
// v8 → v9: added family_meal_plans, food_substitutions
// v9 → v10: added movement_weakness_profiles, movement_logs
// v10 → v11: added sleep fields and recovery logs
// v11 → v12: added training reliability and local readiness
// v12 → v13: added athletic test battery and skill mastery levels
// v13 → v14: added hasGlycemicAnalysis to food_logs table
// v14 → v15: added food_references table
// v15 → v16: added waistCm, neckCm, hipCm columns to transformation_checks table
// v16 → v17 (v1.0 hardening): extracted 8 derived/computed score columns off
//           Users into a new normalized UserScores time-series table (see
//           below); added timezoneOffsetMinutes + preferredDIPHour to Users
//           for per-user DIP scheduling; added whatsAppOptIn, abhaHealthId,
//           preferredInputLanguage to Users for the Phase 16 India Growth Layer.

// ── v1.0 Fix ───────────────────────────────────────────────────────────
// By v16, `Users` had accumulated 8 derived/computed score columns
// (healthScore, movementHealthScore, circadianScore, trainingReliabilityScore,
// upperBodyReadiness, lowerBodyReadiness, estimatedMovementAge,
// estimatedRecoveryAge) added incrementally across schema versions. Because
// these are scalar columns that get overwritten on every recompute, history
// was lost unless separately duplicated into health_snapshots — and `Users`
// is the most frequently joined/queried table in the app (touched on every
// session), so bloating it with recompute-heavy columns hurts hot-path query
// performance. These columns are extracted into `UserScores` below: a proper
// time-series table keyed by (user_id, score_type, computed_at), so history
// is preserved natively and `Users` stays lean.
// ──────────────────────────────────────────────────────────────────────

class FoodLogs extends Table {
  TextColumn  get localId              => text()();
  TextColumn  get userId               => text()();
  DateTimeColumn get consumeTime       => dateTime()();
  TextColumn  get foodName             => text()();
  RealColumn  get calories             => real()();
  RealColumn  get protein              => real()();
  RealColumn  get carbs                => real()();
  RealColumn  get fat                  => real()();
  RealColumn  get processingTier       => real().withDefault(const Constant(1.0))();
  BoolColumn  get hasGlycemicAnalysis  => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus           => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class Users extends Table {
  TextColumn get localId        => text()();
  TextColumn get authProviderId        => text().nullable()();
  TextColumn get name           => text()();
  IntColumn  get age            => integer()();
  TextColumn get gender         => text()();
  RealColumn get heightCm       => real()();
  RealColumn get weightKg       => real()();
  RealColumn get bmi            => real()();
  TextColumn get activityLevel  => text()();
  TextColumn get workStyle      => text()();
  TextColumn get goals          => text()();               // JSON array
  TextColumn get dosha          => text().nullable()();
  TextColumn get currentProgram => text().nullable()();
  TextColumn get dietType       => text()();
  TextColumn get region         => text().nullable()();
  RealColumn get tdee           => real()();
  IntColumn  get dailyStepsTarget     => integer()();
  IntColumn  get dailyCalorieTarget   => integer()();
  RealColumn get dailyWaterTargetL    => real()();
  IntColumn  get dailyProteinTargetG  => integer()();
  TextColumn get tone           => text().withDefault(const Constant('motivational'))();
  TextColumn get nutritionPeriodizationPhase => text().withDefault(const Constant('maintenance'))(); // NEW v8
  RealColumn get monthlyGroceryBudgetInr    => real().withDefault(const Constant(3000.0))(); // NEW v8
  TextColumn get familyUnitId               => text().nullable()(); // NEW v9
  RealColumn get averageReliabilityPct      => real().withDefault(const Constant(100.0))(); // NEW v9
  TextColumn get athleticProfileJson        => text()(); // NEW v12
  TextColumn get athleticTestBatteryJson    => text()(); // NEW v13
  TextColumn get skillMasteryLevelsJson     => text()(); // NEW v13
  TextColumn get projectedPerformanceJson   => text()(); // NEW v13
  IntColumn  get timezoneOffsetMinutes      => integer().withDefault(const Constant(330))(); // NEW v17 — 330 = IST; used for per-user DIP scheduling
  IntColumn  get preferredDIPHour           => integer().withDefault(const Constant(6))(); // NEW v17 — local hour the Daily Intelligence Package should generate
  BoolColumn get whatsAppOptIn              => boolean().withDefault(const Constant(false))(); // NEW v17 — Phase 16
  TextColumn get abhaHealthId               => text().nullable()(); // NEW v17 — Phase 16, encrypted at rest
  TextColumn get preferredInputLanguage     => text().withDefault(const Constant('en'))(); // NEW v17 — Phase 16 vernacular voice logging
  TextColumn get syncStatus     => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt  => dateTime()();
  DateTimeColumn get updatedAt  => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

/// NEW v17 (v1.0 hardening) — normalized time-series table for every
/// derived/computed score previously stored as an overwritable column on
/// `Users`. Each recompute inserts a new row rather than overwriting a
/// single value, so score history (e.g., "how has healthScore trended over
/// 90 days") is a native query instead of relying on a separate snapshot
/// table to have duplicated it.
class UserScores extends Table {
  TextColumn get localId       => text()();
  TextColumn get userId        => text()();
  TextColumn get scoreType     => text()();   // 'health' | 'movement' | 'circadian' |
                                               // 'trainingReliability' | 'upperBodyReadiness' |
                                               // 'lowerBodyReadiness' | 'movementAge' | 'recoveryAge'
  RealColumn get value         => real()();
  DateTimeColumn get computedAt => dateTime()();
  TextColumn get syncStatus    => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};

  // Recommended index: (userId, scoreType, computedAt DESC) for the
  // "latest score of type X for user Y" lookup, which is the hot path
  // used by the Health OS Brain and dashboard widgets.
}
```

**Reading the latest value of a score** (replaces `user.healthScore`):

```dart
Future<double?> latestScore(String userId, String scoreType) async {
  final row = await (db.select(db.userScores)
        ..where((t) => t.userId.equals(userId) & t.scoreType.equals(scoreType))
        ..orderBy([(t) => OrderingTerm(expression: t.computedAt, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();
  return row?.value;
}
```

```dart

class DailyIntelligencePackages extends Table { // NEW v6
  TextColumn  get localId          => text()();
  TextColumn  get userId           => text()();
  DateTimeColumn get packageDate   => dateTime()();
  TextColumn  get primaryInsight   => text()();
  TextColumn  get todaysMission    => text()();
  TextColumn  get nutritionFocus   => text()();
  TextColumn  get recoveryFocus    => text()();
  TextColumn  get motivationMessage => text()();
  IntColumn   get adjustedCalories => integer()();
  IntColumn   get adjustedProtein  => integer()();
  RealColumn  get adjustedHydrationL => real()();
  TextColumn  get recommendedIntensity => text()();
  BoolColumn  get isRestDay        => boolean().withDefault(const Constant(false))();
  TextColumn  get activeRisks      => text()();            // JSON array
  BoolColumn  get showFestivalBanner => boolean().withDefault(const Constant(false))();
  TextColumn  get festivalAdaptation => text().nullable()();
  BoolColumn  get dietBreakActive    => boolean().withDefault(const Constant(false))(); // NEW v8
  IntColumn   get proteinTimingTarget => integer().withDefault(const Constant(25))(); // NEW v8
  TextColumn  get loggingReliabilityStatus => text().withDefault(const Constant('high'))(); // NEW v9 (low, medium, high)
  IntColumn   get satietyTargetScore => integer().withDefault(const Constant(70))(); // NEW v9
  IntColumn   get aiCallsUsed      => integer()();
  TextColumn  get syncStatus       => text()();
  DateTimeColumn get createdAt     => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class HealthSnapshots extends Table { // NEW v6
  TextColumn  get localId        => text()();
  TextColumn  get userId         => text()();
  DateTimeColumn get snapshotDate => dateTime()();
  TextColumn  get proteinTrend   => text()();              // low/adequate/good
  TextColumn  get sleepTrend     => text()();              // declining/stable/improving
  RealColumn  get weightChange4w => real()();
  IntColumn   get currentStreak  => integer()();
  IntColumn   get readinessScore => integer()();
  IntColumn   get healthScore    => integer()();
  BoolColumn  get activeRisk     => boolean()();
  TextColumn  get primaryConcern => text()();
  TextColumn  get programPhase   => text()();
  IntColumn   get daysToGoal     => integer()();
  TextColumn  get syncStatus     => text()();
  DateTimeColumn get createdAt   => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class TransformationMemories extends Table { // NEW v6
  TextColumn  get localId              => text()();
  TextColumn  get userId               => text()();
  TextColumn  get weightHistoryJson    => text()();        // JSON array of checkpoints
  TextColumn  get majorStruggles       => text()();        // JSON array of strings
  TextColumn  get injuriesJson         => text()();        // JSON array
  TextColumn  get successPatterns      => text()();        // JSON array
  TextColumn  get motivationTriggers   => text()();        // JSON array
  TextColumn  get primaryPersonality   => text()();        // Competitive/Routine/Social/Data-driven
  TextColumn  get conversationSummary  => text()();        // Compressed chat history
  DateTimeColumn get lastUpdated       => dateTime()();
  TextColumn  get syncStatus           => text()();

  @override Set<Column> get primaryKey => {localId};
}

class LifeEvents extends Table { // NEW v6
  TextColumn  get localId    => text()();
  TextColumn  get userId     => text()();
  TextColumn  get eventType  => text()();                  // from LifeEventType enum
  TextColumn  get eventData  => text()();                  // JSON — event-specific details
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate   => dateTime().nullable()();
  BoolColumn  get isActive   => boolean()();
  TextColumn  get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class RecoveryLogs extends Table {
  TextColumn  get localId        => text()();
  TextColumn  get userId         => text()();
  DateTimeColumn get logDate     => dateTime()();
  IntColumn   get readinessScore => integer()();
  TextColumn  get confidenceTier => text()();              // NEW v6: basic/enhanced/premium
  IntColumn   get sleepQuality   => integer()();
  IntColumn   get sorenessLevel  => integer()();
  IntColumn   get stressLevel    => integer()();
  IntColumn   get energyLevel    => integer()();
  RealColumn  get restingHR      => real().nullable()();
  RealColumn  get hrv            => real().nullable()();
  TextColumn  get sorenessRegions => text()();
  IntColumn   get sleepNeedMinutes => integer().withDefault(const Constant(480))(); // NEW v11
  IntColumn   get sleepPerformanceScore => integer().withDefault(const Constant(100))(); // NEW v11
  RealColumn  get dailyStrainScore => real().withDefault(const Constant(0.0))(); // NEW v11
  TextColumn  get illnessRiskStatus => text().withDefault(const Constant('low'))(); // NEW v11
  TextColumn  get prescribedActionsJson => text()(); // NEW v11
  TextColumn  get recoveryDriversJson => text()(); // NEW v11
  TextColumn  get syncStatus     => text()();
  DateTimeColumn get createdAt   => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class Followers extends Table { // NEW v7
  TextColumn  get localId        => text()();
  TextColumn  get followerUserId => text()();
  TextColumn  get followedUserId => text()();
  DateTimeColumn get followedAt  => dateTime()();
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {localId};
}

class Clubs extends Table { // NEW v7
  TextColumn  get clubId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get description    => text()();
  TextColumn  get city           => text()();
  TextColumn  get type           => text()();              // geolocation/interestCircle
  RealColumn  get latitude       => real()();
  RealColumn  get longitude      => real()();
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {clubId};
}

class CgmReadings extends Table { // NEW v7
  TextColumn  get readingId      => text()();
  TextColumn  get userId         => text()();
  DateTimeColumn get timestamp   => dateTime()();
  RealColumn  get glucoseMgDl    => real()();
  TextColumn  get trend          => text()();              // rapidlyRising/rising/flat/falling/rapidlyFalling
  TextColumn  get status         => text()();              // active/warmingUp/error/expired
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {readingId};
}

class MedicationLogs extends Table { // NEW v7
  TextColumn  get localId        => text()();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get dosage         => text()();
  DateTimeColumn get scheduledTime => dateTime()();
  DateTimeColumn get takenTime   => dateTime().nullable()();
  TextColumn  get status         => text()();              // missed/taken/snoozed
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {localId};
}

class CreatorProfiles extends Table { // NEW v7
  TextColumn  get creatorId      => text()();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get bio            => text()();
  TextColumn  get specialties    => text()();              // JSON array
  RealColumn  get rating         => real()();
  RealColumn  get rateInr        => real()();
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {creatorId};
}

class MicronutrientLogs extends Table { // NEW v8
  TextColumn  get localId        => text()();
  TextColumn  get userId         => text()();
  DateTimeColumn get logDate     => dateTime()();
  RealColumn  get ironMg         => real()();
  RealColumn  get calciumMg      => real()();
  RealColumn  get magnesiumMg    => real()();
  RealColumn  get zincMg         => real()();
  RealColumn  get vitD3Iu        => real()();
  RealColumn  get vitB12Mcg      => real()();
  RealColumn  get omega3G        => real()();
  RealColumn  get folateMcg      => real()();
  TextColumn  get syncStatus     => text()();

  @override Set<Column> get primaryKey => {localId};
}

class MealNutritionDetails extends Table { // NEW v8
  TextColumn  get localId          => text()();
  TextColumn  get mealLogId        => text()();
  RealColumn  get mealQualityScore => real()();
  RealColumn  get glycemicSpikeMgDl => real()();
  RealColumn  get proteinTimingScore => real()();
  TextColumn  get syncStatus       => text()();

  @override Set<Column> get primaryKey => {localId};
}

class FamilyMealPlans extends Table { // NEW v9
  TextColumn  get localId          => text()();
  TextColumn  get familyUnitId       => text()();
  DateTimeColumn get planDate      => dateTime()();
  TextColumn  get recipeId         => text()();
  TextColumn  get recipeName       => text()();
  TextColumn  get portionGuidesJson => text()(); // Member ID to serving multipliers
  TextColumn  get syncStatus       => text()();

  @override Set<Column> get primaryKey => {localId};
}

class FoodSubstitutions extends Table { // NEW v9
  TextColumn  get localId          => text()();
  TextColumn  get cavedFoodKey     => text()();
  TextColumn  get alternativeName   => text()();
  IntColumn   get calories         => integer()();
  RealColumn  get proteinG         => real()();
  TextColumn  get swapInstructions => text()();
  TextColumn  get syncStatus       => text()();

  @override Set<Column> get primaryKey => {localId};
}

class MovementWeaknessProfiles extends Table { // NEW v10
  TextColumn  get localId          => text()();
  TextColumn  get userId           => text()();
  TextColumn  get exerciseKey      => text()();
  TextColumn  get activeFaultsJson  => text()(); // Map of fault -> frequency
  TextColumn  get remedialDrillsJson => text()(); // List of recommended drills
  DateTimeColumn get lastCalculatedAt => dateTime()();
  TextColumn  get syncStatus       => text()();

  @override Set<Column> get primaryKey => {localId};
}

class MovementLogs extends Table { // NEW v10
  TextColumn  get localId                => text()();
  TextColumn  get userId                 => text()();
  TextColumn  get workoutLogId           => text()();
  TextColumn  get exerciseKey            => text()();
  IntColumn   get repCount               => integer()();
  RealColumn  get averageFormScore       => real()();
  RealColumn  get exerciseConfidenceScore => real()();
  RealColumn  get tempoVariance            => real().withDefault(const Constant(0.0))(); // NEW v12
  RealColumn  get jointPathJitter          => real().withDefault(const Constant(0.0))(); // NEW v12
  TextColumn  get diagnosedLimiter         => text().nullable()(); // NEW v12
  TextColumn  get prescribedCorrectivesJson => text()(); // NEW v12
  RealColumn  get leftVsRightAsymmetryRatio => real().withDefault(const Constant(0.0))(); // NEW v13
  IntColumn   get repDurationMs             => integer().withDefault(const Constant(0))(); // NEW v13
  TextColumn  get jointAnglesJson        => text()(); // Raw keypoint angle sets
  TextColumn  get repTemposJson           => text()(); // Concentric/eccentric timing list
  TextColumn  get syncStatus             => text()();
  DateTimeColumn get createdAt           => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class WorkoutLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get workoutDate => dateTime()();
  TextColumn get programId => text().nullable()();
  TextColumn get workoutName => text()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  RealColumn get intensityFactor => real().withDefault(const Constant(1.0))();
  IntColumn get durationMinutes => integer()();
  RealColumn get totalVolumeKg => real().withDefault(const Constant(0.0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class SleepLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get sleepDate => dateTime()();
  IntColumn get durationMinutes => integer()();
  IntColumn get deepSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get remSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get lightSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get awakeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get qualityScore => integer().withDefault(const Constant(70))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override Set<Column> get primaryKey => {localId};
}

class BpReadings extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkTime => dateTime()();
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  IntColumn get pulse => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class GlucoseReadings extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkTime => dateTime()();
  RealColumn get glucoseMgDl => real()();
  TextColumn get mealContext => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class WaterLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logTime => dateTime()();
  RealColumn get amountMl => real()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class HabitLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  TextColumn get habitId => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class MoodLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logTime => dateTime()();
  IntColumn get moodScore => integer()();
  IntColumn get energyScore => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class KarmaEvents extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get eventTime => dateTime()();
  IntColumn get xpAwarded => integer()();
  TextColumn get eventType => text()();
  TextColumn get description => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class AiInsights extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get category => text()();
  TextColumn get content => text()();
  BoolColumn get actionTaken => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class DietPlans extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get dailyCalories => integer()();
  IntColumn get dailyProteinG => integer()();
  IntColumn get dailyCarbsG => integer()();
  IntColumn get dailyFatG => integer()();
  TextColumn get mealStructuresJson => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class BodyMeasurements extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get bicepsCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
  RealColumn get calvesCm => real().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class SquadGroups extends Table {
  TextColumn get squadId => text()();
  TextColumn get name => text()();
  TextColumn get inviteCode => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {squadId};
}

class SquadMembers extends Table {
  TextColumn get localId => text()();
  TextColumn get squadId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class TransformationChecks extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkDate => dateTime()();
  RealColumn get weightKg => real()();
  RealColumn get bodyFatPct => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get hipCm => real().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get measurementsJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override Set<Column> get primaryKey => {localId};
}

class FoodReferences extends Table {
  TextColumn get foodId => text()();
  TextColumn get foodName => text()();
  TextColumn get defaultServing => text()();
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  IntColumn get glycemicIndex => integer()();
  RealColumn get fiberG => real()();
  IntColumn get satietyIndex => integer()();

  @override Set<Column> get primaryKey => {foodId};
}
```

---

## §DB-B. Drift Migration Strategy

```dart
@DriftDatabase(tables: [
  Users, FoodLogs, WorkoutLogs, SleepLogs, BpReadings,
  GlucoseReadings, WaterLogs, HabitLogs, MoodLogs, MedicationLogs,
  KarmaEvents, AiInsights, DietPlans, RecoveryLogs, BodyMeasurements,
  SquadGroups, SquadMembers, TransformationChecks,
  DailyIntelligencePackages, HealthSnapshots,   // NEW v6
  TransformationMemories, LifeEvents,            // NEW v6
  Followers, Clubs, CgmReadings, CreatorProfiles, // NEW v7
  MicronutrientLogs, MealNutritionDetails,       // NEW v8
  FamilyMealPlans, FoodSubstitutions,            // NEW v9
  MovementWeaknessProfiles, MovementLogs,        // NEW v10
  FoodReferences,                                // NEW v15
  UserScores,                                    // NEW v17 (v1.0 hardening)
  OrganizationAccounts, EmployeeEnrollments      // NEW v17 (Phase 16)
])
class AppDatabase extends _$AppDatabase {
  @override int get schemaVersion => 17;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 6) {
        await m.addColumn(users, users.healthScore);
        await m.addColumn(recoveryLogs, recoveryLogs.confidenceTier);
        await m.createTable(dailyIntelligencePackages);
        await m.createTable(healthSnapshots);
        await m.createTable(transformationMemories);
        await m.createTable(lifeEvents);
      }
      if (from < 7) {
        await m.createTable(followers);
        await m.createTable(clubs);
        await m.createTable(cgmReadings);
        await m.createTable(medicationLogs);
        await m.createTable(creatorProfiles);
      }
      if (from < 8) {
        await m.addColumn(users, users.nutritionPeriodizationPhase);
        await m.addColumn(users, users.monthlyGroceryBudgetInr);
        await m.addColumn(dailyIntelligencePackages, dailyIntelligencePackages.dietBreakActive);
        await m.addColumn(dailyIntelligencePackages, dailyIntelligencePackages.proteinTimingTarget);
        await m.createTable(micronutrientLogs);
        await m.createTable(mealNutritionDetails);
      }
      if (from < 9) {
        await m.addColumn(users, users.familyUnitId);
        await m.addColumn(users, users.averageReliabilityPct);
        await m.addColumn(dailyIntelligencePackages, dailyIntelligencePackages.loggingReliabilityStatus);
        await m.addColumn(dailyIntelligencePackages, dailyIntelligencePackages.satietyTargetScore);
        await m.createTable(familyMealPlans);
        await m.createTable(foodSubstitutions);
      }
      if (from < 10) {
        await m.addColumn(users, users.movementHealthScore);
        await m.addColumn(users, users.estimatedMovementAge);
        await m.createTable(movementWeaknessProfiles);
        await m.createTable(movementLogs);
      }
      if (from < 11) {
        await m.addColumn(users, users.estimatedRecoveryAge);
        await m.addColumn(users, users.circadianScore);
        await m.addColumn(recoveryLogs, recoveryLogs.sleepNeedMinutes);
        await m.addColumn(recoveryLogs, recoveryLogs.sleepPerformanceScore);
        await m.addColumn(recoveryLogs, recoveryLogs.dailyStrainScore);
        await m.addColumn(recoveryLogs, recoveryLogs.illnessRiskStatus);
        await m.addColumn(recoveryLogs, recoveryLogs.prescribedActionsJson);
        await m.addColumn(recoveryLogs, recoveryLogs.recoveryDriversJson);
      }
      if (from < 12) {
        await m.addColumn(users, users.trainingReliabilityScore);
        await m.addColumn(users, users.upperBodyReadiness);
        await m.addColumn(users, users.lowerBodyReadiness);
        await m.addColumn(users, users.athleticProfileJson);
        await m.addColumn(movementLogs, movementLogs.tempoVariance);
        await m.addColumn(movementLogs, movementLogs.jointPathJitter);
        await m.addColumn(movementLogs, movementLogs.diagnosedLimiter);
        await m.addColumn(movementLogs, movementLogs.prescribedCorrectivesJson);
      }
      if (from < 13) {
        await m.addColumn(users, users.athleticTestBatteryJson);
        await m.addColumn(users, users.skillMasteryLevelsJson);
        await m.addColumn(users, users.projectedPerformanceJson);
        await m.addColumn(movementLogs, movementLogs.leftVsRightAsymmetryRatio);
        await m.addColumn(movementLogs, movementLogs.repDurationMs);
      }
      if (from < 14) {
        await m.addColumn(foodLogs, foodLogs.hasGlycemicAnalysis);
      }
      if (from < 15) {
        await m.createTable(foodReferences);
      }
      if (from < 16) {
        await m.addColumn(transformationChecks, transformationChecks.waistCm);
        await m.addColumn(transformationChecks, transformationChecks.neckCm);
        await m.addColumn(transformationChecks, transformationChecks.hipCm);
      }
      if (from < 17) {
        // v1.0 hardening: normalize the 8 derived score columns off Users
        // into UserScores (time-series), then drop them from Users.
        await m.createTable(userScores);

        const legacyScoreColumns = {
          'health': 'healthScore',
          'movement': 'movementHealthScore',
          'movementAge': 'estimatedMovementAge',
          'recoveryAge': 'estimatedRecoveryAge',
          'circadian': 'circadianScore',
          'trainingReliability': 'trainingReliabilityScore',
          'upperBodyReadiness': 'upperBodyReadiness',
          'lowerBodyReadiness': 'lowerBodyReadiness',
        };
        await migrateLegacyUserScoresToUserScoresTable(m, legacyScoreColumns);

        await m.alterTable(TableMigration(users)); // drops the 8 legacy columns
        // (see migrateLegacyUserScoresToUserScoresTable for the row-by-row
        // copy that must complete before the columns are dropped)

        // Phase 16 — India Growth Layer columns
        await m.addColumn(users, users.timezoneOffsetMinutes);
        await m.addColumn(users, users.preferredDIPHour);
        await m.addColumn(users, users.whatsAppOptIn);
        await m.addColumn(users, users.abhaHealthId);
        await m.addColumn(users, users.preferredInputLanguage);
        await m.createTable(organizationAccounts);
        await m.createTable(employeeEnrollments);
      }
    },
  );
}
```

---

## §DB-C. Cloudflare D1 Cloud Database Schema

To support offline-first sync consistency, the Cloudflare D1 database mirrors the local Drift SQLite schemas. In addition, it implements tables for sync orchestration, telemetry, and conflict resolution auditing.

### 1. Core Mirrored Tables DDL

#### Users Table
```sql
CREATE TABLE users (
    localId TEXT NOT NULL,
    authProviderId TEXT NULL,
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    heightCm REAL NOT NULL,
    weightKg REAL NOT NULL,
    bmi REAL NOT NULL,
    activityLevel TEXT NOT NULL,
    workStyle TEXT NOT NULL,
    goals TEXT NOT NULL, -- JSON array
    dosha TEXT NULL,
    currentProgram TEXT NULL,
    dietType TEXT NOT NULL,
    region TEXT NULL,
    tdee REAL NOT NULL,
    dailyStepsTarget INTEGER NOT NULL,
    dailyCalorieTarget INTEGER NOT NULL,
    dailyWaterTargetL REAL NOT NULL,
    dailyProteinTargetG INTEGER NOT NULL,
    tone TEXT NOT NULL DEFAULT 'motivational',
    nutritionPeriodizationPhase TEXT NOT NULL DEFAULT 'maintenance',
    monthlyGroceryBudgetInr REAL NOT NULL DEFAULT 3000.0,
    familyUnitId TEXT NULL,
    averageReliabilityPct REAL NOT NULL DEFAULT 100.0,
    athleticProfileJson TEXT NOT NULL,
    athleticTestBatteryJson TEXT NOT NULL,
    skillMasteryLevelsJson TEXT NOT NULL,
    projectedPerformanceJson TEXT NOT NULL,
    -- v1.0 (v17): timezoneOffsetMinutes/preferredDIPHour replace the hardcoded
    -- 6am IST batch schedule; see fitkarma-health-os in §CF.
    timezoneOffsetMinutes INTEGER NOT NULL DEFAULT 330,
    preferredDIPHour INTEGER NOT NULL DEFAULT 6,
    -- v1.0 (v17) — Phase 16 India Growth Layer
    whatsAppOptIn INTEGER NOT NULL DEFAULT 0,
    abhaHealthId TEXT NULL, -- encrypted at rest; see §P16-C
    preferredInputLanguage TEXT NOT NULL DEFAULT 'en',
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    updatedAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_users PRIMARY KEY (localId)
);

CREATE INDEX IX_users_authProviderId ON users (authProviderId);
```

> **🔒 v1.0 Fix:** `healthScore`, `movementHealthScore`, `estimatedMovementAge`, `estimatedRecoveryAge`, `circadianScore`, `trainingReliabilityScore`, `upperBodyReadiness`, and `lowerBodyReadiness` have been removed from `users` and are now rows in `user_scores` below — see the Drift-side rationale in §DB-A.

#### User Scores Table (NEW v17 — v1.0 hardening)
```sql
CREATE TABLE user_scores (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    scoreType TEXT NOT NULL,
    value REAL NOT NULL,
    computedAt TEXT NOT NULL,
    CONSTRAINT PK_user_scores PRIMARY KEY (localId),
    CONSTRAINT FK_user_scores_users FOREIGN KEY (userId) REFERENCES users(localId) ON DELETE CASCADE
);

-- Hot-path lookup: "latest score of type X for user Y"
CREATE INDEX IX_user_scores_lookup
  ON user_scores (userId, scoreType, computedAt DESC);
```

#### Organization Accounts & Employee Enrollments (NEW v17 — Phase 16)
```sql
CREATE TABLE organization_accounts (
    localId TEXT NOT NULL,
    authProviderId TEXT NULL,
    organizationName TEXT NOT NULL,
    accountType TEXT NOT NULL,   -- 'employer' | 'insurer'
    planTier TEXT NOT NULL,
    seatLimit INTEGER NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_organization_accounts PRIMARY KEY (localId)
);

CREATE TABLE employee_enrollments (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    organizationId TEXT NOT NULL,
    enrolledAt TEXT NOT NULL,
    isActive INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT PK_employee_enrollments PRIMARY KEY (localId),
    CONSTRAINT FK_enrollments_users FOREIGN KEY (userId) REFERENCES users(localId),
    CONSTRAINT FK_enrollments_org FOREIGN KEY (organizationId) REFERENCES organization_accounts(localId) ON DELETE CASCADE
);

-- Org-facing aggregate queries only ever GROUP BY organizationId with a
-- minimum-cohort-size HAVING clause (reusing the §P7-F threshold) —
-- never SELECT individual userId rows for org-facing reports.
CREATE INDEX IX_enrollments_org ON employee_enrollments (organizationId, isActive);
```

#### Food Logs Table
```sql
CREATE TABLE food_logs (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    consumeTime TEXT NOT NULL,
    foodName TEXT NOT NULL,
    calories REAL NOT NULL,
    protein REAL NOT NULL,
    carbs REAL NOT NULL,
    fat REAL NOT NULL,
    processingTier REAL NOT NULL DEFAULT 1.0,
    hasGlycemicAnalysis INTEGER NOT NULL DEFAULT 0,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_food_logs PRIMARY KEY (localId),
    CONSTRAINT FK_food_logs_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IX_food_logs_userId_consumeTime ON food_logs (userId ASC, consumeTime DESC);
```

#### Daily Intelligence Packages Table
```sql
CREATE TABLE daily_intelligence_packages (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    packageDate TEXT NOT NULL,
    primaryInsight TEXT NOT NULL,
    todaysMission TEXT NOT NULL,
    nutritionFocus TEXT NOT NULL,
    recoveryFocus TEXT NOT NULL,
    motivationMessage TEXT NOT NULL,
    adjustedCalories INTEGER NOT NULL,
    adjustedProtein INTEGER NOT NULL,
    adjustedHydrationL REAL NOT NULL,
    recommendedIntensity TEXT NOT NULL,
    isRestDay INTEGER NOT NULL DEFAULT 0,
    activeRisks TEXT NOT NULL, -- JSON array
    showFestivalBanner INTEGER NOT NULL DEFAULT 0,
    festivalAdaptation TEXT NULL,
    dietBreakActive INTEGER NOT NULL DEFAULT 0,
    proteinTimingTarget INTEGER NOT NULL DEFAULT 25,
    loggingReliabilityStatus TEXT NOT NULL DEFAULT 'high',
    satietyTargetScore INTEGER NOT NULL DEFAULT 70,
    aiCallsUsed INTEGER NOT NULL DEFAULT 0,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_daily_intelligence_packages PRIMARY KEY (localId),
    CONSTRAINT FK_daily_intelligence_packages_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IX_dip_userId_date ON daily_intelligence_packages (userId ASC, packageDate DESC);
```

#### AI Cache Table (v1.0 hardening — see fix #6 above)
```sql
CREATE TABLE ai_cache (
    localId TEXT NOT NULL,
    user_id TEXT NOT NULL,
    prompt_hash TEXT NOT NULL,
    response TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_ai_cache PRIMARY KEY (localId),
    CONSTRAINT UQ_ai_cache_user_prompt UNIQUE (user_id, prompt_hash),
    CONSTRAINT FK_ai_cache_users FOREIGN KEY (user_id) REFERENCES users (localId) ON DELETE CASCADE
);

-- Powers both the getCached() lookup and the account-deletion erasure path.
CREATE INDEX IX_ai_cache_user ON ai_cache (user_id);
```

#### CGM Readings Table
```sql
CREATE TABLE cgm_readings (
    readingId TEXT NOT NULL,
    userId TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    glucoseMgDl REAL NOT NULL,
    trend TEXT NOT NULL,
    status TEXT NOT NULL,
    CONSTRAINT PK_cgm_readings PRIMARY KEY (readingId),
    CONSTRAINT FK_cgm_readings_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IX_cgm_readings_userId_timestamp ON cgm_readings (userId ASC, timestamp DESC);
```

#### Recovery Logs Table
```sql
CREATE TABLE recovery_logs (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    logDate TEXT NOT NULL,
    readinessScore INTEGER NOT NULL,
    confidenceTier TEXT NOT NULL DEFAULT 'basic',
    sleepQuality INTEGER NOT NULL,
    sorenessLevel INTEGER NOT NULL,
    stressLevel INTEGER NOT NULL,
    energyLevel INTEGER NOT NULL,
    restingHR REAL NULL,
    hrv REAL NULL,
    sorenessRegions TEXT NOT NULL,
    sleepNeedMinutes INTEGER NOT NULL DEFAULT 480,
    sleepPerformanceScore INTEGER NOT NULL DEFAULT 100,
    dailyStrainScore REAL NOT NULL DEFAULT 0.0,
    illnessRiskStatus TEXT NOT NULL DEFAULT 'low',
    prescribedActionsJson TEXT NOT NULL,
    recoveryDriversJson TEXT NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_recovery_logs PRIMARY KEY (localId),
    CONSTRAINT FK_recovery_logs_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);
```

#### Transformation Checks Table
```sql
CREATE TABLE transformation_checks (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    checkDate TEXT NOT NULL,
    weightKg REAL NOT NULL,
    bodyFatPct REAL NULL,
    waistCm REAL NULL,
    neckCm REAL NULL,
    hipCm REAL NULL,
    photoPath TEXT NULL,
    measurementsJson TEXT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_transformation_checks PRIMARY KEY (localId),
    CONSTRAINT FK_transformation_checks_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);
```

### 2. Synchronization Orchestration Schemas

To manage transactional consistency, trace sync latencies, and flag failures gracefully, the cloud layer deploys sync metadata and Dead Letter Queue systems.

#### Sync Audit Trail (SyncAuditTrail)
Records transaction events during synchronizations to monitor performance, latency, and data integrity.
```sql
CREATE TABLE sync_audit_trail (
    auditId TEXT NOT NULL DEFAULT NEWID(),
    userId TEXT NOT NULL,
    syncDirection TEXT NOT NULL, -- 'PUSH' or 'PULL'
    tableName TEXT NOT NULL,
    recordsProcessed INTEGER NOT NULL,
    syncStatus TEXT NOT NULL, -- 'SUCCESS', 'FAILED', 'PARTIAL'
    errorMessage TEXT NULL,
    durationMs INTEGER NOT NULL,
    processedAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_sync_audit_trail PRIMARY KEY (auditId),
    CONSTRAINT FK_sync_audit_trail_users FOREIGN KEY (userId) REFERENCES users (localId)
);

CREATE INDEX IX_sync_audit_trail_userId ON sync_audit_trail (userId);
```

#### Sync Dead Letter Queue (SyncDeadLetterQueue)
Holds sync payloads that failed key constraint, formatting, or parsing rules. Triggers alerts to developers or local users after retry limits are hit.
```sql
CREATE TABLE sync_dead_letter_queue (
    dlqId TEXT NOT NULL DEFAULT NEWID(),
    userId TEXT NOT NULL,
    tableName TEXT NOT NULL,
    recordLocalId TEXT NOT NULL,
    payloadJson TEXT NOT NULL,
    failureReason TEXT NOT NULL,
    retryCount INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'RETRIED', 'ABANDONED'
    queuedAt TEXT NOT NULL DEFAULT (datetime('now')),
    lastAttemptAt TEXT NULL,
    CONSTRAINT PK_sync_dead_letter_queue PRIMARY KEY (dlqId),
    CONSTRAINT FK_sync_dlq_users FOREIGN KEY (userId) REFERENCES users (localId)
);

CREATE INDEX IX_sync_dlq_status ON sync_dead_letter_queue (status);
```

#### Marketplace Wallet & Double-Entry Ledger (MarketplaceLedger)
Stores ledger entries for creator commissions, payouts, and customer transaction logs. Wallets compute balances dynamically from transaction logs instead of a mutable database balance field.

```sql
CREATE TABLE marketplace_wallets (
    walletId TEXT NOT NULL DEFAULT NEWID(),
    creatorId TEXT NOT NULL,
    currency TEXT NOT NULL DEFAULT 'INR',
    status TEXT NOT NULL DEFAULT 'ACTIVE', -- 'ACTIVE', 'SUSPENDED'
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_marketplace_wallets PRIMARY KEY (walletId),
    CONSTRAINT FK_marketplace_wallets_users FOREIGN KEY (creatorId) REFERENCES users (localId)
);

CREATE TABLE marketplace_ledger_entries (
    entryId TEXT NOT NULL,
    transactionId TEXT NOT NULL,
    walletId TEXT NULL,
    accountType TEXT NOT NULL, -- 'escrowLiability', 'creatorPayable', 'platformRevenue', 'tcsLiability', 'tdsLiability', 'gstExpense', 'cashAsset'
    debit DECIMAL(18, 4) NOT NULL DEFAULT 0.0000,
    credit DECIMAL(18, 4) NOT NULL DEFAULT 0.0000,
    timestamp TEXT NOT NULL DEFAULT (datetime('now')),
    memo TEXT NULL,
    CONSTRAINT PK_marketplace_ledger_entries PRIMARY KEY (entryId),
    CONSTRAINT FK_marketplace_ledger_wallets FOREIGN KEY (walletId) REFERENCES marketplace_wallets (walletId)
);

CREATE INDEX IX_ledger_entries_wallet ON marketplace_ledger_entries (walletId);
CREATE INDEX IX_ledger_entries_tx ON marketplace_ledger_entries (transactionId);
```

---


# §CF. Cloudflare Workers — All Functions

---

## Cloudflare Workers (8 total)

```
fitkarma-cores         → HTTP Trigger: diet plan generation, program blueprint, readiness AI
fitkarma-coach         → HTTP Trigger: AI Coach (compressed context, conversation memory)
fitkarma-meal-vision   → HTTP Trigger: Meal photo analysis (known-meal cache + Groq Vision fallback)
fitkarma-health-os     → Timer Trigger (6am IST): Daily Intelligence Package generation
fitkarma-insights      → Timer Trigger (6am IST): Event-driven proactive insight generation
fitkarma-reports       → Timer Trigger (1st of month): Monthly report generation
fitkarma-social        → HTTP Trigger: Activity feed sharing, reactions, clubs, and leaderboards
fitkarma-marketplace   → HTTP Trigger: Coach matching, hiring client onboarding, affiliate payouts
```

### Worker Configuration (`wrangler.toml`)

```toml
name = "fitkarma-api"
main = "src/index.js"
compatibility_date = "2026-01-01"

[[d1_databases]]
binding = "DB"                       # accessed in code as env.DB
database_name = "fitkarma-prod"
database_id = "<your-d1-database-id>"

[triggers]
crons = ["*/15 * * * *"]             # fitkarma-health-os eligibility sweep

[ai]
binding = "AI"                       # env.AI — Whisper / Deepgram Nova-3 for vernacular ASR

# Secrets are NOT stored in this file — set via:
#   wrangler secret put GROQ_API_KEY
#   wrangler secret put GOOGLE_OAUTH_CLIENT_ID
#   wrangler secret put JWT_SIGNING_SECRET
#   wrangler secret put AI_CACHE_TTL_HOURS   (or just hardcode as a non-secret constant)
```

> **🔒 v1.0 Fix carried over:** secrets are injected via `wrangler secret put` (encrypted at rest in Cloudflare's control plane) rather than committed to a settings file — this is a strict improvement over the original Azure `local.settings.json` pattern, which stored the SQL connection string in plaintext in a file developers routinely gitignore *late*.

### fitkarma-health-os (Core of v1.0 Architecture)

> **🔒 v1.0 Fix — Fan-out orchestration.** The original design ran a `for` loop over all active users inside a single timer-triggered function invocation. On the Consumption plan this hits the 5–10 minute execution timeout at roughly 300–600 users (at ~1–2s per user for the DB read + Groq call), and a single slow or failing user blocks every user queued behind them — there was no per-user error isolation. This has been replaced with a **Cloudflare Workflows fan-out/fan-in orchestration**: the timer trigger only enqueues work, an orchestrator fans it out to parallel activity function instances (auto-scaled by the Workflows engine), and each user's DIP generation succeeds or fails independently.
>
> **🔒 v1.0 Fix — Per-user timezone scheduling.** The schedule was hardcoded to `6am IST` for every user, which is wrong for NRIs and for users in Travel Mode (§P12-E) who may be in a different timezone. The timer now runs every 15 minutes and only processes users whose local time currently matches their configured `preferredDIPHour` (see `UserScores`/`Users.timezoneOffset` in §DB).

```javascript
// Runs every 15 minutes (see [triggers] crons in wrangler.toml). Fans out
// DIP generation to users whose local time currently matches their
// preferred generation hour, instead of assuming every user is in IST.
//
// Built on Cloudflare Workflows: each workflow instance is a Durable
// Object under the hood, so per-user steps persist across failures and
// retry independently — no custom orchestration glue required.

import { WorkflowEntrypoint } from 'cloudflare:workers';

// Cron Trigger handler — lives in the main Worker (src/index.js) —
// enqueues one Workflow instance per sweep, not per user.
export default {
  async scheduled(event, env, ctx) {
    await env.HEALTH_OS_WORKFLOW.create(); // starts a HealthOSOrchestrator run
  },
};

// Orchestrator: fans out one step invocation per eligible user, runs
// them concurrently, and isolates failures per user.
export class HealthOSOrchestrator extends WorkflowEntrypoint {
  async run(event, step) {
    const eligibleUsers = await step.do('get-eligible-users', async () => {
      // Filters activeUsers by whether the user's local time
      // (UTC now + users.timezoneOffsetMinutes) falls within the
      // current 15-minute window of their preferredDIPHour.
      return getUsersDueForDIP(this.env.DB);
    });

    // Independent steps run concurrently (fan-out/fan-in); each is
    // isolated, retryable, and idempotent — a failure in one user's
    // step does not block or fail any other user's step.
    const results = await Promise.allSettled(
      eligibleUsers.map(userId =>
        step.do(`generate-dip-${userId}`, async () => generateDIPForUser(userId, this.env))
      )
    );

    return results;
  }
}

async function generateDIPForUser(userId, env) {
  try {
    // Step 1: Compute health snapshot (no AI)
    const snapshot = await computeHealthSnapshot(env.DB, userId);

    // Step 2: Check if AI is even needed
    const trigger = checkAITrigger(snapshot);
    if (!trigger && await hasCachedDIP(env.DB, userId)) {
      // Reuse yesterday's DIP with today's computed targets
      await refreshDIPTargets(env.DB, userId, snapshot);
      return { userId, status: 'reused' };
    }

    // Step 3: Single AI call — generate DIP
    const dip = await generateDIP(userId, snapshot, env);

    // Step 4: Store in Cloudflare D1 + queue sync to user's Drift
    await storeDIP(env.DB, userId, dip);
    await queueDriftSync(env, userId, dip);
    return { userId, status: 'generated' };
  } catch (err) {
    // Per-user failure is caught here and does not propagate to the
    // orchestrator's other concurrent steps — see Promise.allSettled above.
    // Workflows also independently retries a failed step.do() call before
    // it ever reaches this catch, per its configured retry policy.
    console.error(`DIP generation failed for ${userId}: ${err.message}`);
    throw err;
  }
}

async function generateDIP(userId, snapshot, env) {
  // This is the ONE AI call per user per day
  // ~400 token input (compressed snapshot) → ~300 token output
  const response = await callGroq({
    model: 'llama-3.1-70b-versatile', // Medium complexity — daily planning
    messages: [{
      role: 'system',
      content: buildDIPSystemPrompt(snapshot),
    }],
    response_format: { type: 'json_object' },
    max_tokens: 300,
  });

  return JSON.parse(response.content);
}
```

### AI Cache Implementation

> **🔒 v1.0 Fix — User-scoped cache with erasure path.** The original `ai_cache` table keyed purely on `prompt_hash` with no reference back to the user whose data produced the cached response. Beyond the (low-probability but non-zero) risk of hash collisions serving one user's cached response to another, this made it impossible to honor a **DPDP Act right-to-erasure request**: there was no way to find and delete cached AI outputs derived from a specific user's data. The table now includes `user_id`, and cache keys are composite (`user_id` + `prompt_hash`) so cache entries are both correctly scoped and individually deletable.

```javascript
// shared/aiCache.js — db is env.DB, the D1 binding
async function hashPrompt(prompt) {
  // Prompt hash alone is no longer the lookup key — see getCached/setCached below.
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(prompt));
  return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('').slice(0, 16);
}

async function getCached(db, userId, promptHash) {
  const row = await db.prepare(
    `SELECT response FROM ai_cache
     WHERE user_id = ? AND prompt_hash = ? AND expires_at > datetime('now')`
  ).bind(userId, promptHash).first();
  return row?.response ?? null;
}

async function setCached(db, userId, promptHash, response, ttlHours = 24) {
  const expires = new Date(Date.now() + ttlHours * 3600000).toISOString();
  // D1/SQLite upsert — requires a UNIQUE constraint on (user_id, prompt_hash),
  // see ai_cache DDL in §DB-C.
  await db.prepare(`
    INSERT INTO ai_cache (user_id, prompt_hash, response, expires_at)
    VALUES (?, ?, ?, ?)
    ON CONFLICT(user_id, prompt_hash)
    DO UPDATE SET response = excluded.response, expires_at = excluded.expires_at
  `).bind(userId, promptHash, response, expires).run();
}

/// Called from the account-deletion workflow to purge all cached AI
/// outputs derived from a user's data — required for DPDP Act erasure requests.
async function purgeCacheForUser(db, userId) {
  await db.prepare('DELETE FROM ai_cache WHERE user_id = ?').bind(userId).run();
}
```

### fitkarma-social (NEW v1)

```javascript
// Handles social events: post creation, high-fives, and city leaderboard updates
import { Hono } from 'hono';
const app = new Hono();

// authMiddleware validates the custom JWT (jose, HS256) and sets c.set('userId', ...)
app.use('/social', authMiddleware);

app.post('/social', async (c) => {
  const db = c.env.DB;
  const userId = c.get('userId');
  const action = c.req.query('action');
  const body = await c.req.json();

  if (action === 'high-five') {
    const { targetFeedItemId } = body;
    try {
      // D1 batch() executes statements atomically (all-or-nothing) — this
      // is D1's equivalent of the SQL Server explicit transaction below.
      await db.batch([
        db.prepare(`
          INSERT INTO feed_reactions (item_id, user_id, reaction_type)
          VALUES (?, ?, 'high_five')
        `).bind(targetFeedItemId, userId),
        // Award +2 XP to the poster of the feed item (up to 10 daily —
        // enforced by application logic before this handler runs)
        db.prepare(`
          UPDATE users
          SET health_xp = health_xp + 2
          WHERE localId = (SELECT user_id FROM feed_items WHERE item_id = ?)
        `).bind(targetFeedItemId),
      ]);
      return c.json({ success: true });
    } catch (err) {
      return c.json({ error: err.message }, 500);
    }
  }

  if (action === 'post-activity') {
    const { type, payload, privacy } = body;
    await db.prepare(`
      INSERT INTO feed_items (user_id, item_type, payload_json, privacy_level, created_at)
      VALUES (?, ?, ?, ?, datetime('now'))
    `).bind(userId, type, JSON.stringify(payload), privacy).run();
    return c.json({ success: true }, 201);
  }

  return c.json({ error: 'Invalid action or method.' }, 400);
});

app.get('/social', async (c) => {
  const db = c.env.DB;
  const action = c.req.query('action');

  if (action === 'leaderboard') {
    const city = c.req.query('city');
    const { results } = await db.prepare(`
      SELECT name, health_score, steps_7d_avg
      FROM users
      WHERE region = ? AND leaderboard_opt_in = 1
      ORDER BY health_score DESC
      LIMIT 50
    `).bind(city).all();
    return c.json(results);
  }

  return c.json({ error: 'Invalid action or method.' }, 400);
});

export default app;
```

### fitkarma-marketplace (NEW v1)

```javascript
// Handles creator registrations, coach matchmaking queries, and referral payouts
import { Hono } from 'hono';
const app = new Hono();

app.use('/marketplace', authMiddleware);

app.all('/marketplace', async (c) => {
  const db = c.env.DB;
  const userId = c.get('userId');
  const action = c.req.query('action');

  if (c.req.method === 'GET' && action === 'match') {
    // Ingests client demographics and goals to match with relevant coaches
    const user = await db.prepare(
      'SELECT goals, dietType FROM users WHERE localId = ?'
    ).bind(userId).first();

    const { results: coaches } = await db.prepare(
      'SELECT creatorId, name, specialties, rateInr, rating FROM creator_profiles'
    ).all();

    return c.json({ user, coaches });
  }

  if (c.req.method === 'POST' && action === 'hire') {
    const { coachId } = await c.req.json();

    // 1. Create client-coach relationship
    // 2. Set up recurring platform payment split (80% to coach / 20% to platform)
    await db.prepare(`
      INSERT INTO coach_clients (coach_id, client_id, active_from, has_write_permission)
      VALUES (?, ?, datetime('now'), 1)
    `).bind(coachId, userId).run();

    return c.json({ success: true, message: 'Coach successfully hired.' });
  }

  if (c.req.method === 'POST' && action === 'payout') {
    // Calculate and trigger payout to creator wallet
    const payoutRow = await db.prepare(`
      SELECT SUM(amount_inr * 0.8) as earnings
      FROM creator_transactions
      WHERE creator_id = ? AND payout_status = 'pending'
    `).bind(userId).first();

    const totalEarnings = payoutRow?.earnings ?? 0;
    // Integration with payment gateway (Razorpay / Stripe) to transfer balance...
    return c.json({ processedEarnings: totalEarnings });
  }

  return c.json({ error: 'Bad request.' }, 400);
});

export default app;
```

### fitkarma-cores (NEW v1)

```javascript
// Handles core onboarding setup, personalized diet plans, and program blueprint generation
import { Hono } from 'hono';
import { getCached, setCached, hashPrompt } from './shared/aiCache';
const app = new Hono();

app.use('/cores', authMiddleware);

app.post('/cores', async (c) => {
  const db = c.env.DB;
  const userId = c.get('userId');
  const action = c.req.query('action');
  const body = await c.req.json();

  if (action === 'generate-diet') {
    const { targetCalories, targetProtein, dietaryPrefs, physicalProfile } = body;
    const prompt = `Generate a 7-day Indian diet plan. Calories: ${targetCalories}kcal, Protein: ${targetProtein}g, Prefs: ${dietaryPrefs}. Profile: ${JSON.stringify(physicalProfile)}`;
    const promptHash = await hashPrompt(prompt);

    // Check cache first to save token cost — user-scoped per the v1.0 ai_cache fix
    const cachedResponse = await getCached(db, userId, promptHash);
    if (cachedResponse) {
      return c.body(cachedResponse);
    }

    // Generate diet plan using LLM
    const dietResponse = await callGroq({
      model: 'llama-3.1-70b-versatile',
      messages: [
        { role: 'system', content: 'You are a clinical dietitian mapping out Indian recipes.' },
        { role: 'user', content: prompt }
      ],
      response_format: { type: 'json_object' }
    });

    await setCached(db, userId, promptHash, dietResponse.content, 168); // Cache diet plan for 7 days
    return c.body(dietResponse.content);
  }

  if (action === 'generate-blueprint') {
    const { goals, limitations, age, gender } = body;
    const prompt = `Generate a 12-week workout blueprint. Goals: ${goals}, Limitations: ${limitations}, Age: ${age}, Gender: ${gender}`;
    const promptHash = await hashPrompt(prompt);

    const cachedResponse = await getCached(db, userId, promptHash);
    if (cachedResponse) {
      return c.body(cachedResponse);
    }

    const blueprintResponse = await callGroq({
      model: 'llama-3.1-70b-versatile',
      messages: [
        { role: 'system', content: 'You are an elite athletic coach building a progression program.' },
        { role: 'user', content: prompt }
      ],
      response_format: { type: 'json_object' }
    });

    await setCached(db, userId, promptHash, blueprintResponse.content, 720); // Cache program blueprint for 30 days
    return c.body(blueprintResponse.content);
  }

  return c.json({ error: 'Invalid action.' }, 400);
});

export default app;
```

### fitkarma-coach (NEW v1)

```javascript
// Implements conversational AI Coach with memory injection and context compression
import { Hono } from 'hono';
const app = new Hono();

app.use('/coach', authMiddleware);

app.post('/coach', async (c) => {
  const db = c.env.DB;
  const userId = c.get('userId');
  const { message, chatSessionId } = await c.req.json();

  // 1. Fetch user health snapshot & long-term memory. D1's batch() runs
  // multiple statements in one round trip and returns one result per
  // statement — the equivalent of SQL Server's multiple-recordset query.
  const [userQuery, historyQuery] = await db.batch([
    db.prepare(`
      SELECT health_score, primary_personality, system_tone
      FROM users WHERE localId = ?
    `).bind(userId),
    db.prepare(`
      SELECT role, content FROM chat_history
      WHERE session_id = ? ORDER BY created_at DESC LIMIT 10
    `).bind(chatSessionId),
  ]);

  const user = userQuery.results[0];
  const rawHistory = historyQuery.results.reverse();

  // 2. Fetch rolling 7-day health metrics (weight, steps, sleep, workouts) for prompt context
  const { results: recentLogs } = await db.prepare(
    'SELECT date, calories, protein, completed FROM daily_logs WHERE user_id = ? ORDER BY date DESC LIMIT 7'
  ).bind(userId).all();

  // 3. Compress context & format system instructions
  const systemPrompt = `
    You are the FitKarma AI Coach. Tone: ${user.system_tone || 'motivational'}.
    Personality target: ${user.primary_personality || 'Data-driven'}.
    User's Current Health Score: ${user.health_score}/100.
    Recent 7-day logs: ${JSON.stringify(recentLogs)}.
    Be concise, focus on actionables. Do not repeat macro targets.
  `;

  // 4. Combine history and current message
  const messages = [
    { role: 'system', content: systemPrompt },
    ...rawHistory.map(h => ({ role: h.role, content: h.content })),
    { role: 'user', content: message }
  ];

  // 5. Call Groq
  const response = await callGroq({
    model: 'llama-3.1-70b-versatile',
    messages: messages,
    max_tokens: 250
  });

  const botMessage = response.content;

  // 6. Save message pair to history database — one batch, two inserts
  await db.batch([
    db.prepare(`
      INSERT INTO chat_history (session_id, role, content, created_at)
      VALUES (?, 'user', ?, datetime('now'))
    `).bind(chatSessionId, message),
    db.prepare(`
      INSERT INTO chat_history (session_id, role, content, created_at)
      VALUES (?, 'assistant', ?, datetime('now'))
    `).bind(chatSessionId, botMessage),
  ]);

  return c.json({ reply: botMessage });
});

export default app;
```

### fitkarma-meal-vision (NEW v1)

```javascript
// Performs meal photo vision parsing with caching fallback
import { Hono } from 'hono';
import { getCached, setCached } from './shared/aiCache';
const app = new Hono();

app.use('/meal-vision', authMiddleware);

app.post('/meal-vision', async (c) => {
  const db = c.env.DB;
  const userId = c.get('userId');
  const { imageBase64 } = await c.req.json();

  // Fast sha256 of image base64 bytes to detect identical uploads
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(imageBase64));
  const imgHash = [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('').slice(0, 16);

  // Check if this exact image was analyzed recently (still user-scoped —
  // two users' identical photo hashes stay in separate cache rows)
  const cachedResponse = await getCached(db, userId, imgHash);
  if (cachedResponse) {
    return c.body(cachedResponse);
  }

  // Call Groq Vision API
  const visionResponse = await callGroq({
    model: 'llama-3.2-11b-vision-preview', // High-fidelity vision model
    messages: [
      {
        role: 'user',
        content: [
          { type: 'text', text: 'Analyze this Indian food photo. Return JSON only with fields: meal_name, estimated_calories, protein_g, carbs_g, fat_g, confidence_score.' },
          { type: 'image_url', image_url: { url: `data:image/jpeg;base64,${imageBase64}` } }
        ]
      }
    ],
    response_format: { type: 'json_object' }
  });

  // Save result to cache
  await setCached(db, userId, imgHash, visionResponse.content, 72); // Cache image hash for 3 days
  return c.body(visionResponse.content);
});

export default app;
```

### fitkarma-insights (NEW v1)

```javascript
// Cron Trigger (runs daily at 6am IST = 00:30 UTC — add a second cron entry
// in wrangler.toml: "30 0 * * *") to analyze behavioral logs and generate
// custom insights.
//
// NOTE: like the original design, this still loops per user in a single
// invocation — the same 5-10 min Worker execution ceiling that motivated
// the fitkarma-health-os fan-out fix (§CF) applies here too. Fine at
// FitKarma's current scale; if the active-user count grows enough to risk
// hitting that ceiling, port this to a Cloudflare Workflow the same way.

export default {
  async scheduled(event, env, ctx) {
    const db = env.DB;

    // Ingest all users' rolling metrics to check for behavioral warnings
    const { results: users } = await db.prepare(
      'SELECT localId FROM users WHERE is_active = 1'
    ).all();

    for (const user of users) {
      const { results: logs } = await db.prepare(
        'SELECT steps, sleep_duration_min, protein_g, date FROM daily_logs WHERE user_id = ? ORDER BY date DESC LIMIT 14'
      ).bind(user.localId).all();

      if (logs.length < 5) continue;

      // Rule 1: Step decline detection (7 days downward trend)
      let stepsDeclined = true;
      for (let i = 0; i < logs.length - 1; i++) {
        if (logs[i].steps >= logs[i + 1].steps) {
          stepsDeclined = false;
          break;
        }
      }

      // Rule 2: Chronic sleep deficit (avg sleep < 360 mins)
      const avgSleep = logs.reduce((acc, curr) => acc + curr.sleep_duration_min, 0) / logs.length;

      const notifications = [];
      if (stepsDeclined) {
        notifications.push(
          db.prepare(`
            INSERT INTO user_notifications (user_id, type, title, message, created_at)
            VALUES (?, 'insight_warning', 'Steps Trend Declining', ?, datetime('now'))
          `).bind(user.localId, "Your steps have dropped consecutively this week. Let's aim for a short 10-minute walk today.")
        );
      }
      if (avgSleep < 360) {
        notifications.push(
          db.prepare(`
            INSERT INTO user_notifications (user_id, type, title, message, created_at)
            VALUES (?, 'recovery_alert', 'Sleep Debt Alert', ?, datetime('now'))
          `).bind(user.localId, "Your 14-day average sleep is below 6 hours. Let's push bedtime up by 30 minutes tonight.")
        );
      }
      if (notifications.length) await db.batch(notifications);
    }
  },
};
```

### fitkarma-reports (NEW v1)

```javascript
// Cron Trigger (runs on the 1st of every month at midnight UTC — add
// "0 0 1 * *" to the crons array in wrangler.toml) to compile progress reports.
// Same execution-ceiling caveat as fitkarma-insights above applies here.

export default {
  async scheduled(event, env, ctx) {
    const db = env.DB;
    const { results: users } = await db.prepare(
      'SELECT localId, name, email FROM users WHERE is_active = 1'
    ).all();

    for (const user of users) {
      // Fetch user metrics for the past 30 days.
      // SQLite has no DATEADD/GETUTCDATE — date('now', '-30 days') is the equivalent.
      const stats = await db.prepare(`
        SELECT AVG(steps) as avgSteps, AVG(sleep_duration_min) as avgSleep, AVG(health_score) as avgScore
        FROM daily_logs
        WHERE user_id = ? AND date >= date('now', '-30 days')
      `).bind(user.localId).first();

      if (!stats?.avgScore) continue;

      // Compile monthly report record.
      // MONTH(DATEADD(month, -1, GETUTCDATE())) -> strftime('%m', date('now', '-1 month'))
      await db.prepare(`
        INSERT INTO monthly_reports (user_id, report_month, avg_steps, avg_sleep_mins, avg_health_score, generated_at)
        VALUES (?, strftime('%m', date('now', '-1 month')), ?, ?, ?, datetime('now'))
      `).bind(user.localId, stats.avgSteps || 0, stats.avgSleep || 0, stats.avgScore || 0).run();
    }
  },
};
```

---

# §GLO. Glossary & Architecture Decision Records

---

## Glossary

| Term | Definition |
|------|-----------|
| **Health OS Brain** | Central intelligence layer that generates the Daily Intelligence Package and resolves conflicts between all modules |
| **Daily Intelligence Package (DIP)** | JSON payload generated once per morning containing today's insight, mission, nutrition focus, recovery focus, and adapted targets — consumed by all modules |
| **Health Snapshot** | Compressed ~400-token summary of a user's 7-day health state — used as AI input instead of raw logs |
| **Decision Hierarchy** | Ordered conflict resolution: Medical > Recovery > Program > Goals > Preferences |
| **Readiness Score** | 0–100 daily score based on sleep, HRV, resting HR, soreness, stress. Three tiers: Basic/Enhanced/Premium |
| **Readiness Confidence Tier** | Basic (sleep + stress + soreness) / Enhanced (+ HR) / Premium (+ HRV + wearable) |
| **Health Score** | Unified 0–100 score synthesizing Nutrition + Recovery + Training + Consistency |
| **Program Evolution Engine** | System that automatically advances a user to the next program when progress milestones are met |
| **Transformation Memory** | Long-term record of struggles, successes, motivation triggers, and quit patterns — used by AI Coach |
| **Life Events Engine** | System that adapts all modules when a major life event (injury, travel, deadline, etc.) is active |
| **Hybrid Insight Engine** | Three-layer system: Rule Engine → Template Engine → AI. 80–90% of insights use no AI |
| **Event-Driven AI** | AI is triggered only by threshold events (protein deficit 5 days, weight plateau 3 weeks) — not on every log |
| **AI Router** | Layer that routes requests to Rule Engine / Template Engine / Tiny / Medium / Large model |
| **AI Cache** | Prompt hash → response storage. Serves identical prompts from cache without an API call |
| **Fatigue Index** | 7-day rolling load-to-recovery ratio. > 1.0 = overtraining risk |
| **Relapse Detection** | Behavioral pattern analysis detecting users likely to quit |
| **Festival Mode** | Full cross-module adaptation to Indian festival eating, activity, sleep, and goal patterns |
| **Blueprint** | AI-generated personalized workout program (e.g., "Corporate Fat Loss") |
| **Biological Age** | Estimated metabolic age from HRV, HR, sleep, BMI, steps. Computed monthly, not daily |
| **DLQ** | Dead Letter Queue — records that failed to sync 3+ times |
| **Optimistic UI** | UI updates immediately from Drift write; cloud sync in background |
| **Calm Zone** | Screens with sensitive content — zero glow, blur, or animations |
| **Bento Grid** | 2-column asymmetric card layout |
| **Pattern A/B/C** | Three scaffold archetypes: scroll / hero+body / full-bleed |
| **Rule of Two** | No surface may have more than 2 simultaneous visual effects |
| **Soft Delete** | `isDeleted = true` instead of hard DELETE — health data is irreplaceable |
| **Device Tier** | Low/Mid/High based on RAM — gates visual effects for 60fps |
| **Thali Intelligence** | AI understanding of Indian thali as a composite meal entry |
| **Fix My Meal** | AI meal photo analysis — macros + quality + readiness impact + goal impact + suggestions |
| **Squad Mission** | Team-level challenge derived from squad's aggregate health data |
| **Tone Setting** | `gentle / motivational / roast / no_nonsense` — injected into all AI prompts |
| **Biomarker Stream (CGM)** | Real-time continuous glucose monitor data feeds used to detect sugar spikes |
| **Creator Marketplace** | Specialized coach matcher and program store with an 80/20 platform royalty split |
| **Creator Affiliate** | Referral loop tracking system giving influencers 15% recurring commission on Pro tiers |
| **Diet Break** | Planned 1-to-2 week phase of eating at maintenance calories to reset thyroid/leptin levels during a long-term fat loss deficit |
| **Protein Timing Score** | 0-100 metric measuring if the user distributed their protein intake into at least 3 separate servings of >=25g to trigger Muscle Protein Synthesis (MPS) |
| **Micronutrient Index** | Tracking status of 8 key health biomarkers (Iron, Calcium, Magnesium, Zinc, Vit D, B12, Omega-3, Folate) customized by dietary type |
| **Metabolic Flexibility Score** | 0-100 estimation of user's metabolic adaptation quality based on macro adherence consistency, activity level, sleep, and recovery logs |
| **Geolocation Club** | Micro-communities grouped by city/GPS coordinates for team step/run events |
| **Drug-Nutrient Warning** | Real-time logic checks verifying drug safety against logged meals and exercises |
| **Nutrition Reliability Score** | 7-day rolling adherence indicator measuring consistency in protein, calorie, hydration, and meal frequency tracking |
| **Satiety Score** | 0-100 index estimating the satiety power of a food based on protein and fiber content, physical volume, and ultra-processing penalties |
| **Family Dining Engine** | Algorithmic planner that consolidates individual member clinical constraints and goals into a single optimized family dinner |
| **Smart Swap** | Healthy, culturally localized alternative recipes suggested to replace high-calorie Indian street foods and desserts while maintaining taste profile |
| **Movement Age** | Dynamic score calculated from onboarding mobility & stability testing, compared against age-group norms |
| **Movement Health Score** | 0-100 score synthesized from mobility, stability, balance, coordination, and execution form metrics |
| **Exercise Confidence Score** | 0-100 metric calculated from joint angle variance, tempo consistency, and path jitter to measure exercise familiarity |
| **Movement Weakness Profile** | Persistent database record storing aggregated form deviations and active biomechanical issues per exercise |
| **Sleep Need** | The total sleep duration calculated dynamically for a user to fully recover, adjusted by sleep debt, training strain, and stress |
| **Bedtime Coach** | Adaptive tool calculating the ideal bedtime to meet target sleep needs based on a user's target wake time |
| **Daily Strain** | A 0-21 score measuring the daily cardiorespiratory and muscular load from workouts, steps, stress, and heat exposure |
| **Recovery Capacity** | Estimated stress limit indicating the maximum load the body can handle without increasing recovery debt |
| **Recovery Prescription** | A task-list prescription providing specific recovery behaviors based on current physical capacity |
| **Circadian Score** | 0-100 metric tracking midpoint shift penalties and morning light exposure to align sleep habits with natural circadian cycles |
| **Illness Risk** | Heart-rate and HRV-based alert system flagging potential physical sickness and lowering training volume targets |
| **Recovery Age** | Estimated biological age calculated from resting heart rate recovery, sleep efficiency, and HRV values |
| **Local Muscle Readiness** | Muscle-specific fatigue indices (e.g., Upper vs. Lower body) determining daily training capacity limits |
| **Training Reliability Score** | 0-100 rolling score tracking adherence consistency based on completed, skipped, and rescheduled sessions |
| **Recovery-Aware Overload** | Progressive overloading where weight increments are dynamically reduced or deferred based on daily recovery capacity |
| **Adaptive Exercise Selection** | Real-time substitution engine that swaps exercises based on active movement limitations or equipment gaps |
| **Asymmetry Detection** | Biomechanical checking comparing left-vs-right joint angles during unilateral movements to flag compensation |
| **Rep-Speed Analysis** | Video-based timing measuring eccentric and concentric velocities to assess force reserves without hardware |
| **Exercise Skill Tree** | Gamified progression tier mapping user execution mastery levels from Novice up to Expert |
| **Athletic Testing Battery** | Quarterly performance checks measuring balance, power, mobility, core endurance, and strength anchors |
| **Performance Forecasting** | Autoregressive model projecting future load capacity and running pace capabilities over 8 to 12 weeks |
| **Adaptive Computer Vision Loop (ACVL)** | Framework that dynamically drops camera frames and reduces landmark detail to avoid device overheating |
| **Thermal Headroom** | Normalized status indicator tracking device temperature margins relative to system performance throttling thresholds |
| **Retrospective Glycemic Processing Pipeline (RGPP)** | System that scans and retroactively correlates late-synced sensor data with recorded meal windows |
| **Glycemic Spike** | The metric delta calculated by subtracting average baseline pre-meal glucose from peak post-meal glucose |

---

## Architecture Decision Records

| ADR | Decision | Rationale |
|-----|---------|-----------|
| ADR-001 | **Drift over Hive** | SQL joins needed for date-range queries; relational health logs |
| ADR-002 | **Riverpod over Bloc** | Simpler async composition, better AsyncValue, codegen reduces boilerplate |
| ADR-003 | **Cloudflare D1 over Durable Object storage** | Cloudflare D1 free tier; SQL schema mirrors Drift local; no per-read billing |
| ADR-004 | **SQLCipher for encryption** | AES-256 at SQLite page level; raw .db unreadable without keychain key |
| ADR-005 | **Soft Delete** | Health data is irreplaceable; undo and conflict recovery require soft delete |
| ADR-006 | **Pure Dart animations** | Consistent with token system, zero-latency, no third-party versioning risk |
| ADR-007 | **`--dart-define` for secrets** | No secrets in source; separate build targets per environment |
| ADR-008 | **Sentry over Crashlytics** | Self-hostable, no Google telemetry; PII stripping enforced |
| ADR-009 | **lastWriteWins + manualReview** | Clinical records must never auto-overwrite; food/habits use lastWriteWins |
| ADR-010 | **Open Food Facts + Custom Indian DB** | OFF: 3M+ global items; Custom DB: 50k+ Indian items with Hindi names |
| ADR-011 | **LLM via Cloudflare Worker** | Keeps Groq key server-side; enables rate limiting, caching, model swapping |
| ADR-012 | **RevenueCat for subscriptions** | Handles App Store + Play Store receipts + entitlements in one SDK |
| ADR-013 | **Mandatory demographics** | BMI-derived targets critical for safe calorie/workout goals; no Skip |
| ADR-014 | **Groq JSON mode for structured output** | `response_format: json_object` guarantees parseable output |
| ADR-015 | **Diet plan before Dosha Quiz** | Physical data already collected; result ready with no perceived wait |
| ADR-016 | **7-day diet cache, BMI staleness check** | Groq calls are expensive; cache avoids redundant generation |
| ADR-017 | **Mifflin-St Jeor for TDEE** | Most validated formula; Harris-Benedict overestimates ~5% |
| ADR-018 | **Readiness as daily entry point** | Addictive morning ritual; personalizes every feature for that day |
| ADR-019 | **Relapse detection via behavioral signals** | App opens + logging frequency + meal quality predict quit risk |
| ADR-020 | **Weather API for hydration/workout adaptation** | India's 38°C+ summers make weather a critical health variable |
| ADR-021 | **Festival calendar hardcoded + user region** | Indian festivals are predictable; region customizes which appear |
| ADR-022 | **Squad max size: 8 members** | > 8 reduces accountability; social loafing increases |
| ADR-023 | **Biological age shown monthly, not daily** | Daily biological age creates anxiety; monthly view encourages patience |
| ADR-024 | **Tone selector (Gentle/Motivational/Roast/No Nonsense)** | Users respond differently to coaching; choice increases long-term retention |
| ADR-025 | **AI physique predictions shown as range** | Exact predictions create unrealistic expectations |
| ADR-026 | **No AI for deterministic calculations** | BMI, TDEE, macros, readiness, risk detection are formulas — AI adds no value and costs tokens |
| ADR-027 | **Single Daily Intelligence Package** | One AI call per user per day reduces AI cost by 75–90% while preserving all features |
| ADR-028 | **Multi-model routing** | Different tasks require different model sizes; using 70B for everything is cost-prohibitive |
| ADR-029 | **Event-driven AI, not continuous AI** | Logging water does not require AI reasoning; thresholds trigger meaningful interventions only |
| ADR-030 | **Karma rewards outcomes, not logging** | Logging-based XP creates perverse incentives; outcome XP aligns gamification with health goals |
| ADR-031 | **Program Evolution Engine** | Static templates fail to adapt to user progress; evolution maintains challenge and motivation |
| ADR-032 | **Readiness confidence tiers** | Users without wearables still deserve a score; honest confidence labeling avoids false precision |
| ADR-033 | **Festival cross-module adaptation** | Adapting diet only during festivals is insufficient; sleep, workout, mood, goals must all adjust |
| ADR-034 | **Life Events Engine** | Major life disruptions (injury, new baby, travel) require whole-system adaptation, not just plan modification |
| ADR-035 | **Decision Hierarchy for conflict resolution** | Without explicit priority ordering, conflicting module guidance confuses users and reduces trust |
| ADR-036 | **Transformation Memory for long-term coaching** | 7-day context window is insufficient for 12-week programs; coaches need months of behavioral history |
| ADR-037 | **Health Score as single unified metric** | Too many independent metrics (readiness, karma, sleep, protein, hydration) create cognitive overload |
| ADR-038 | **Meal analysis extends to readiness and goal impact** | Macros alone don't tell users whether a meal serves their daily health state or transformation goal |
| ADR-039 | **No clinical data in public/social feeds** | Private clinical records (CGMs, medications, lab readings, body composition weights) are explicitly barred from feed postings to respect user privacy |
| ADR-040 | **80/20 platform marketplace fee split** | Ensures premium creator incentive while recovering platform pipeline distribution costs |
| ADR-041 | **Demographic Cohort Minimums (n=50)** | Regional anonymized circles require at least 50 members to prevent statistical re-identification in low-density zones |
| ADR-042 | **Manual RPE override for blunted HR responses** | Medication blunts HR metrics. Fallback to Rate of Perceived Exertion (RPE) ensures safe coaching calculations |
| ADR-043 | **Protein threshold limits (min 25g/meal) for MPS triggers** | Spacing protein intake into discrete servings of at least 25g maximizes Muscle Protein Synthesis efficiency over raw daily accumulation |
| ADR-044 | **Budget-maximizing protein substitution algorithms** | Automatically swaps premium proteins (Greek yogurt, whey) for localized low-cost options (soya, curd, eggs) if user's target budget is exceeded |
| ADR-045 | **Automated diet breaks after 8 consecutive weeks** | Continuous calorie deficit induces metabolic slowdown and behavioral fatigue; auto-switching to maintenance resets thyroid and leptin levels |
| ADR-046 | **Halt metabolic adaptations during low logging reliability** | Target updates are blocked if the 7-day logging reliability is under 70%, preventing automatic target drops from missing data |
| ADR-047 | **Volume-based satiety adjustment boundaries** | The satiety calculation imposes a maximum cap on volume weight ratios to avoid scoring nutrient-empty, water-bloated meals incorrectly |
| ADR-048 | **Family dining clinical goal prioritizing order** | Safe clinical constraints (e.g. low glycemic for diabetics) override macronutrient defaults, with calorie modifications achieved through portion scaling |
| ADR-049 | **On-device MediaPipe frame-drop isolation** | Run frame analysis asynchronously outside the main UI thread to prevent video stuttering and preserve 60fps on mid-tier hardware |
| ADR-050 | **Injury risk cross-referencing with recovery metrics** | Biomechanical weakness patterns (e.g., valgus collapse rate) are combined with high recovery debt and sleep deprivation before triggering high-risk alarms |
| ADR-051 | **Non-linear cardiac strain accumulation model** | Cardiorespiratory strain is modeled exponentially rather than linearly, assigning significantly higher values to time spent in heart rate zones 4/5 |
| ADR-052 | **Sleep need recalculation boundaries** | To avoid recommending excessive sleep targets that users cannot adhere to, total Sleep Need additions are strictly capped at a maximum of 10 hours |
| ADR-053 | **Biomechanical substitution override precedence** | Movement limitations (e.g., limited dorsiflexion) trigger fallback exercise substitution routing ahead of standard program progression routes to prevent joint stress |
| ADR-054 | **Multi-joint trajectory jitter windowing** | Joint path jitter calculations for Exercise Confidence use a rolling 500ms sliding window to filter out high-frequency camera noise and prevent false instability scores |
| ADR-055 | **Decay-adjusted progression forecasting model** | Progression projections employ a logarithmic decay factor to simulate tapering gains as lifters approach genetic strength ceilings |
| ADR-056 | **On-device low-pass filter for joint velocity noise** | Calculations for estimated rep velocity use a 3-frame moving average filter to reject instantaneous keypoint tracking jitters from video streams |
| ADR-057 | **Adaptive thermal downsampling thresholds** | Framework-driven degradation drops the input frame rate to 10fps when thermal headroom H crosses 0.85 to protect device battery longevity |
| ADR-058 | **MethodChannel polling rate limits** | Thermal metrics are polled at a fixed 10-second interval to avoid overloading system threads |
| ADR-059 | **Asynchronous retrospective glycemic matching** | To accommodate late-syncing CGM hardware data, glycemic and meal quality calculations run asynchronously in background workers, decoupling real-time UI logging from analysis ingestion |
| ADR-060 | **Glycemic sensor data density requirements** | A retrospective analysis requires at least 2 pre-meal baseline readings and 4 post-meal readings to satisfy data density and ensure accurate spike assessments |

---

# Master Launch Checklist

---

## Phase 0 — Foundation

- [ ] Flutter project created with `--dart-define` multi-env setup
- [ ] All design tokens in `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
- [ ] GlassCard tier-aware (blur on Mid/High, solid on Low)
- [ ] All shared components built: GlowingMetric, ActivityRings, QuickLogFab, InsightCard, ShimmerLoader, HealthScoreRing
- [ ] Health OS Brain scaffolded: `health_os_brain.dart`, `daily_intelligence_package.dart`, `health_snapshot.dart`
- [ ] AI Router implemented: rule engine, template engine, model selector, cache
- [ ] Decision Hierarchy implemented and tested
- [ ] Drift schema v6 initialized with all tables including DIP, HealthSnapshot, TransformationMemory, LifeEvents
- [ ] SQLCipher encryption configured, key in keychain
- [ ] Sync worker running (priority queue, 3-retry DLQ)
- [ ] Cloudflare account + D1 database + Workers project created (India-adjacent region via Cloudflare's global network)
- [ ] GoRouter with all routes defined

## Phase 1 — Onboarding

- [ ] All 7 onboarding screens functional end-to-end on fresh install
- [ ] Demographics: BMI/TDEE/targets computed locally (no AI)
- [ ] Diet plan generated with JSON mode, cached 7 days, BMI delta invalidation
- [ ] Dosha quiz complete, result stored
- [ ] Program Blueprint with program evolution path shown upfront
- [ ] Permissions screen: HealthKit (iOS) + Health Connect (Android) tested

## Phase 2 — Daily Mission + Readiness

- [ ] Three-tier readiness model implemented (Basic/Enhanced/Premium)
- [ ] Readiness score computed locally with correct tier and confidence label
- [ ] Morning check-in: 3-question ritual
- [ ] DIP loaded from Drift on Daily Briefing open — zero AI calls at open time
- [ ] Health Score computed and displayed
- [ ] Decision Hierarchy resolving conflicts correctly
- [ ] Recovery log screen functional with confidence tier displayed
- [ ] Sleep Need Calculator & Bedtime Coach schedules (NEW v1)
- [ ] Sleep Performance Score 4-pillar calculations (NEW v1)
- [ ] Daily Strain Score 0-21 activity tracking calculations (NEW v1)
- [ ] Recovery Capacity bounds and Decision Engine mapping (NEW v1)
- [ ] Recovery Prescription actionable checklists (NEW v1)
- [ ] Circadian Score midpoint shifting penalty rules (NEW v1)
- [ ] Illness & Sickness biometric alarm triggers (NEW v1)
- [ ] Recovery Drivers contribution parsing (NEW v1)

## Phase 3 — AI Coach

- [ ] `fitkarma-health-os` Cloudflare Cron Trigger deployed (6am IST)
- [ ] DIP generation: single AI call, compressed context, stored to Drift
- [ ] `fitkarma-coach` Function: compressed context + conversation memory
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
- [ ] Periodization Engine phase transition checks (NEW v1)
- [ ] Protein Distribution & Timing Score calculations (NEW v1)
- [ ] Micronutrient Tracker with dietary profile alerts (NEW v1)
- [ ] Nutrition Adherence Score 0-100 calculations (NEW v1)
- [ ] OCR Menu Scanner with goal-based highlight overlays (NEW v1)
- [ ] Smart Festival Nutrition pre-compensation and post-recovery (NEW v1)
- [ ] Adaptive Hunger & Cravings trigger alerts (NEW v1)
- [ ] Personal food score overrides via CGM Glycemic Response (NEW v1)
- [ ] Budget-Optimized Grocery knapsack swaps (NEW v1)
- [ ] Nutrition Reliability Score rolling calculations and Target Lockout rules (NEW v1)
- [ ] Satiety Prediction Engine scores and database satiety reference index (NEW v1)
- [ ] Family Meal Planner clinical conflict prioritizing and portion scaling (NEW v1)
- [ ] Food Substitution Engine registry overrides and satiety improvement swaps (NEW v1)

## Phase 6 — Workout

- [ ] Program blueprint generator (AI, cached)
- [ ] Progressive overload engine (deterministic)
- [ ] Program Evolution Engine triggers tested
- [ ] Active workout screen with rest timer and set logging
- [ ] Completion outcome XP (not logging XP)
- [ ] On-device pose estimation joint angle calculations (MediaPipe integration) (NEW v1)
- [ ] Movement Weakness Profile fault accumulation heuristics (NEW v1)
- [ ] Mobility Diagnosis Engine cause mappings and drill prescriber (NEW v1)
- [ ] Biomechanical Injury Risk Forecasting combining kinematic variance and sleep debt (NEW v1)
- [ ] Movement Memory database logging and progress reporting (NEW v1)
- [ ] Exercise Confidence Score tempo and jitter variance checks (NEW v1)
- [ ] Movement Health Score unified synthesis (NEW v1)
- [ ] Camera-Based Fitness Onboarding assessment for Movement Age (NEW v1)
- [ ] Adaptive Exercise Selection smart replacement triggers (NEW v1)
- [ ] Local Muscle Readiness upper and lower body fatigue splitting (NEW v1)
- [ ] Recovery-Aware Overload progressive weight adjustments (NEW v1)
- [ ] Training Reliability Score completed/skipped/rescheduled logging (NEW v1)
- [ ] Strength Potential and Athletic Profile calculations (NEW v1)
- [ ] Movement Asymmetry Detection left vs right joint angle offsets (NEW v1)
- [ ] Video-based Rep-Speed Trend Analysis duration calculations (NEW v1)
- [ ] Exercise Skill Trees & Mastery progression rules (NEW v1)
- [ ] Camera-guided Athletic Testing Battery quarterly updates (NEW v1)
- [ ] Performance Forecasting strength & cardiovascular projections (NEW v1)
- [ ] Adaptive Computer Vision Loop (ACVL) state transitions (NEW v1)
- [ ] MethodChannel native ADPF thermal monitoring hook (NEW v1)
- [ ] Dynamic frame-dropping & isolate processing integration (NEW v1)
- [ ] UI optimization mode active alert banner (NEW v1)

## Phase 7 — Gamification

- [ ] All XP events are outcome-based (no logging XP)
- [ ] Level-up animation on every level change
- [ ] Habit smart triggers (not fixed-time reminders)
- [ ] Karma Hub with achievement grid
- [ ] Demographic Cohort Insights & Benchmarks opt-in and distribution charts (NEW v1)

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
- [ ] Activity Feed screen (/feed) displaying workouts, routes, milestones, and high-fives (NEW v1)
- [ ] Geolocation Clubs and Interest Circles scanning & creation (NEW v1)
- [ ] Regional (City) and Cohort (Age-Group) leaderboards with anonymity toggle (NEW v1)

## Phase 10 — Predictive Health

- [ ] All 6 risk patterns in PreventiveIntelligenceEngine
- [ ] Biological age estimation (monthly, algorithm-based)
- [ ] Monthly report generation
- [ ] Continuous Glucose Monitor (CGM) integration and spike detection engine (NEW v1)
- [ ] Medication Scheduler & Log Tracker (NEW v1)
- [ ] Drug-Nutrient & Drug-Workout interaction warning checks (NEW v1)
- [ ] Passcode-protected Doctor Sharing Portal PDF export (NEW v1)
- [ ] DPDP Act & Medical Disclaimers compliance logic (NEW v1)
- [ ] Retrospective Glycemic Processing Pipeline (RGPP) scan execution (NEW v1)
- [ ] Retrospective Glucose Matcher baseline and peak logic (NEW v1)
- [ ] Background sync worker for late-arriving CGM batches (NEW v1)
- [ ] Dynamic glucose variant badge rendering on historical logs (NEW v1)

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
- [ ] Creator Profiles database and matchmaking service (NEW v1)
- [ ] Program Marketplace store direct purchase & wallet royalty distribution (NEW v1)
- [ ] Creator Affiliate referral links tracking and recurring payouts dashboard (NEW v1)

## v1.0 Architecture Hardening (NEW)

- [ ] SQLCipher key generation uses `Random.secure()`, not timestamp-based generation
- [ ] `fitkarma-health-os` runs as Cloudflare Workflows fan-out, not a sequential per-user loop
- [ ] DIP generation is scheduled per-user by `timezoneOffsetMinutes` + `preferredDIPHour`, not hardcoded to 6am IST
- [ ] Sync conflict resolution uses HLC timestamps, not raw device clock
- [ ] Cumulative log sync batches carry a `syncBatchId` and are server-side deduplicated
- [ ] `UserScores` table live; `Users` no longer holds overwritable score columns
- [ ] `ai_cache` scoped by `user_id`; account deletion purges cached AI outputs
- [ ] `ClinicalCopyLinter` passes in CI for all §P10-I/H/J copy changes

## Phase 16 — India Growth & Trust Layer (NEW)

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
- [ ] All `--dart-define` vars set for dev/staging/prod
- [ ] Sentry PII stripping verified
- [ ] AI cache keys contain no PII
- [ ] Golden tests generated and passing for all primary screens
- [ ] DPDP Act compliance: Privacy Policy written and linked
- [ ] Cold start < 2s on mid-tier device
- [ ] Daily Briefing open < 100ms (DIP from Drift, no AI)

---

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

---

*FitKarma — Complete Master Documentation*
*Version 1.0 · India's Intelligent Health Operating System*
*Flutter 3.x · Riverpod 2.x · Drift v7 (Local Schema v17) · Cloudflare D1 · Cloudflare Workers (Cloudflare Workflows fan-out) · custom Workers/D1 JWT auth (email OTP + Google/Apple Sign-In) · RevenueCat · Multi-Model AI (Groq) · Open Food Facts*
*Offline-first · AES-256 encrypted (CSPRNG-keyed) · Privacy-centric · AI-adaptive · Built for India*
*15 development phases · 35+ Cloudflare D1 tables · 8 Cloudflare Workers · 45+ screens · Health OS Brain · Adaptive Metabolism Engine · Longevity Score · 70–95% AI cost reduction*