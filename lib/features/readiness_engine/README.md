# Feature: Phase 2 — Daily Mission + Readiness Engine

## Overview
Phase 2 implements FitKarma's Readiness Engine and Recovery Operating System: a deterministic 3-tier confidence model that computes an objective daily readiness score (0–100), models rolling sleep debt and sleep architecture efficiency, balances day strain capacity budgets (Bannister impulse model), maps anatomical body soreness, and prescribes customized Indian recovery protocols.

## Spec Sections Implemented
- **Architecture & Data Model**: [architechture.md](file:///f:/fitkarma/Brain/architechture.md) §1–§3; [data_model.md](file:///f:/fitkarma/Brain/data_model.md) (`readiness_scores`, `dip_cache`).
- **PRD**: [prd.md](file:///f:/fitkarma/Brain/prd.md) §4 (Daily Intelligence Package synthesis, morning check-in ritual).
- **UI Spec**: [ui_spec.md](file:///f:/fitkarma/Brain/ui_spec.md) §4 (Home/Daily Mission screens, readiness hero `GlowingMetric`, soreness heatmap).

## Key Files & Responsibilities
- [lib/features/readiness_engine/domain/models/readiness_input.dart](file:///f:/fitkarma/lib/features/readiness_engine/domain/models/readiness_input.dart): Multi-tier input payload (Tier 1 biometrics, Tier 2 sleep duration, Tier 3 manual check-in).
- [lib/features/readiness_engine/domain/models/readiness_result.dart](file:///f:/fitkarma/lib/features/readiness_engine/domain/models/readiness_result.dart): Synthesized score, confidence tier, state (`prime`, `steady`, `recovery`), recovery age, and strain capacity budget.
- [lib/features/readiness_engine/domain/services/readiness_calculation_engine.dart](file:///f:/fitkarma/lib/features/readiness_engine/domain/services/readiness_calculation_engine.dart): Pure Dart deterministic formula across all 3 tiers.
- [lib/features/readiness_engine/domain/services/sleep_intelligence_engine.dart](file:///f:/fitkarma/lib/features/readiness_engine/domain/services/sleep_intelligence_engine.dart): Sleep debt accumulator and deep/REM restorative quotient evaluator.
- [lib/features/readiness_engine/domain/services/recovery_os_engine.dart](file:///f:/fitkarma/lib/features/readiness_engine/domain/services/recovery_os_engine.dart): Tailored Ayurvedic (Pranayama, Ashwagandha) and physiological (contrast showers, Epsom salt) recovery protocols.
- [lib/features/readiness_engine/presentation/widgets/body_soreness_map.dart](file:///f:/fitkarma/lib/features/readiness_engine/presentation/widgets/body_soreness_map.dart): Visual interactive muscle group heatmap selector with multi-level severity badges.
- [lib/features/readiness_engine/presentation/screens/recovery_log_screen.dart](file:///f:/fitkarma/lib/features/readiness_engine/presentation/screens/recovery_log_screen.dart): Morning check-in ritual screen for logging sleep, energy, and muscle soreness.
- [lib/features/readiness_engine/presentation/screens/daily_briefing_screen.dart](file:///f:/fitkarma/lib/features/readiness_engine/presentation/screens/daily_briefing_screen.dart): Daily mission hub displaying readiness hero score, strain budget, recovery age, and activity rings.
- [lib/features/readiness_engine/data/readiness_repository.dart](file:///f:/fitkarma/lib/features/readiness_engine/data/readiness_repository.dart): Local Drift persistence + FIFO outbox queueing for Supabase `readiness_scores`.

## Supabase Tables & RLS Status
- `readiness_scores`: RLS enabled (`auth.uid() = user_id`).
- `dip_cache`: RLS enabled (`auth.uid() = user_id`).

## Deterministic vs. AI Split
- **Pure Dart Deterministic (Client-Side & Offline)**:
  - Three-tier readiness score calculation (`ReadinessCalculationEngine`).
  - Sleep debt and sleep efficiency evaluation (`SleepIntelligenceEngine`).
  - Day strain capacity budget and recovery age estimation (`ReadinessResult.fromScore`).
  - Algorithmic recovery protocol generation (`RecoveryOSEngine`).
- **AI-Backed**:
  - Daily Intelligence Package morning narrative synthesis in backend Edge Function (with deterministic offline fallback in `HealthOSBrain`).

## Deviations from Spec
- None.
