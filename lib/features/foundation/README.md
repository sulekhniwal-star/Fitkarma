# Feature: Phase 0 — Foundation

## Overview
Phase 0 establishes FitKarma's core offline-first architecture, glassmorphic design token system, Riverpod state management infrastructure, local Drift/SQLCipher persistence with outbox synchronization, and deterministic base intelligence engines (Health OS Brain, Adaptive Metabolism, Environmental Health, Program Evolution).

## Spec Sections Implemented
- **Architecture**: [architechture.md](file:///f:/fitkarma/Brain/architechture.md) §1 (High-level shape), §2 (Client architecture), §4 (Offline-first sync), §5 (Health OS Brain).
- **Data Model**: [data_model.md](file:///f:/fitkarma/Brain/data_model.md) (Core identity, readiness scores, dip cache, entitlements, pending mutations).
- **UI Spec**: [ui_spec.md](file:///f:/fitkarma/Brain/ui_spec.md) §1 (Design language), §2 (Core reusable components: `BentoCard`, `ActivityRings`, `GlowingMetric`, `BilingualLabel`).
- **Master Rules & Security**: [master_rules.md](file:///f:/fitkarma/Brain/master_rules.md) §2 (Locked stack), §3 (Non-negotiables: no client AI keys, Drift-first offline writes, server-verified entitlements).

## Key Files & Responsibilities
- [lib/main.dart](file:///f:/fitkarma/lib/main.dart): App entry point, Riverpod `ProviderScope`, and Foundation dashboard demo.
- [lib/core/theme/](file:///f:/fitkarma/lib/core/theme/): `app_colors.dart`, `app_typography.dart`, `app_theme.dart` (dark mode `#0D0F12`, glassmorphism, glowing accents).
- [lib/core/widgets/](file:///f:/fitkarma/lib/core/widgets/):
  - `bento_card.dart`: Glass container with adaptive glow and tap physics.
  - `activity_rings.dart`: Multi-metric concentric custom-painted progress rings.
  - `glowing_metric.dart`: Hero metric with radial glow treatment.
  - `bilingual_label.dart`: Bilingual English/Hindi typography display.
- [lib/core/database/app_database.dart](file:///f:/fitkarma/lib/core/database/app_database.dart): Drift local SQLite/SQLCipher database with `PendingMutations`, `LocalProfiles`, `LocalReadinessScores`, `LocalDipCache`.
- [lib/core/sync/outbox_sync_worker.dart](file:///f:/fitkarma/lib/core/sync/outbox_sync_worker.dart): Background outbox worker executing FIFO offline mutations to Supabase with exponential backoff.
- [lib/features/health_os/services/health_os_brain.dart](file:///f:/fitkarma/lib/features/health_os/services/health_os_brain.dart): Central DIP orchestrator.
- [lib/features/health_os/services/ai_routing_service.dart](file:///f:/fitkarma/lib/features/health_os/services/ai_routing_service.dart): Secure client interface to backend Edge Functions.
- [lib/features/metabolism/services/metabolism_engine.dart](file:///f:/fitkarma/lib/features/metabolism/services/metabolism_engine.dart): Deterministic BMR, TDEE, and macronutrient balance calculator.
- [lib/features/environmental/services/environmental_health_engine.dart](file:///f:/fitkarma/lib/features/environmental/services/environmental_health_engine.dart): Deterministic AQI, UV, and Rothfusz Heat Index safety assessor.
- [lib/features/program_evolution/services/program_evolution_engine.dart](file:///f:/fitkarma/lib/features/program_evolution/services/program_evolution_engine.dart): Deterministic weekly progressive overload and deload recommender.
- [supabase/migrations/20260912000001_phase0_foundation_schema.sql](file:///f:/fitkarma/supabase/migrations/20260912000001_phase0_foundation_schema.sql): Initial Postgres schema with RLS policies for `profiles`, `readiness_scores`, `dip_cache`, `entitlements`.

## Supabase Tables & RLS Status
- `profiles`: RLS enabled (`auth.uid() = user_id` for select, insert, update, delete).
- `readiness_scores`: RLS enabled (`auth.uid() = user_id`).
- `dip_cache`: RLS enabled (`auth.uid() = user_id`).
- `entitlements`: RLS enabled (Select allowed for owner `auth.uid() = user_id`; Insert/Update restricted to service-role).

## Deterministic vs. AI Split
- **Pure Dart Deterministic (Client-Side & Offline)**:
  - BMR / TDEE / Macro split calculations in `MetabolismEngine`.
  - AQI / Heat Index / Safety modifier calculations in `EnvironmentalHealthEngine`.
  - Weekly progressive overload logic in `ProgramEvolutionEngine`.
  - Fallback DIP briefing generation in `HealthOSBrain`.
- **AI-Backed (Server-Side via Supabase Edge Functions)**:
  - Daily Intelligence Package natural language narrative synthesis in `health-os-brain` Edge Function. No AI API keys exist on the client.

## Deviations from Spec
- None. Implementation strictly conforms to [master_rules.md](file:///f:/fitkarma/Brain/master_rules.md).
