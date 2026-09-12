# Feature: Phase 3 — AI Adaptive Coach

## Overview
Phase 3 implements FitKarma's culturally attuned, multi-modal AI Adaptive Coach. It combines real-time Readiness scores, Ayurvedic Dosha Prakriti, sleep debt, remaining metabolic budget, muscle soreness maps, and menstrual cycle phases into prompt context without PII exposure, while providing optimistic local Drift chat persistence and fallback offline coaching.

## Spec Sections Implemented
- **Architecture & API Contract**: [architechture.md](file:///f:/fitkarma/Brain/architechture.md) §1–§3, §5; [api_contract.md](file:///f:/fitkarma/Brain/api_contract.md) §2 (`POST /functions/v1/coach-message`); [data_model.md](file:///f:/fitkarma/Brain/data_model.md) (`coach_sessions`, `coach_messages`).
- **Master Rules & Security**: [master_rules.md](file:///f:/fitkarma/Brain/master_rules.md) §3 (Non-negotiables: No AI keys on client, all Groq calls mediated by Supabase Edge Functions).
- **UI Spec**: [ui_spec.md](file:///f:/fitkarma/Brain/ui_spec.md) §4 (Coach chat screen).

## Key Files & Responsibilities
- [lib/features/coach/domain/models/coach_message.dart](file:///f:/fitkarma/lib/features/coach/domain/models/coach_message.dart): Message entity with sender roles (`user`, `coach`, `system`), timestamp, and model attribution.
- [lib/features/coach/domain/services/coach_context_builder.dart](file:///f:/fitkarma/lib/features/coach/domain/services/coach_context_builder.dart): Multi-modal context assembler integrating Dosha, Readiness, Macros, and Soreness without PII leakage.
- [lib/features/coach/domain/services/proactive_insights_engine.dart](file:///f:/fitkarma/lib/features/coach/domain/services/proactive_insights_engine.dart): Evaluates acute physiological triggers (readiness drops, sleep debt, DOMS) and Elite tier human coach escalation triggers.
- [supabase/functions/coach-message/index.ts](file:///f:/fitkarma/supabase/functions/coach-message/index.ts): Deno/TypeScript Edge Function routing prompt context to Groq (Llama-3.3-70b / Mixtral) with server-side API key protection.
- [lib/features/coach/data/coach_service.dart](file:///f:/fitkarma/lib/features/coach/data/coach_service.dart): Client HTTP layer invoking `coach-message` with offline deterministic fallback.
- [lib/features/coach/data/coach_repository.dart](file:///f:/fitkarma/lib/features/coach/data/coach_repository.dart): Optimistic Drift caching in `local_coach_sessions` & `local_coach_messages` with outbox sync.
- [lib/features/coach/presentation/screens/ai_coach_screen.dart](file:///f:/fitkarma/lib/features/coach/presentation/screens/ai_coach_screen.dart): Bento-styled dark glassmorphic chat interface with quick prompt chips, proactive banners, and auto-scroll.
- [supabase/migrations/20260912000003_phase3_coach_schema.sql](file:///f:/fitkarma/supabase/migrations/20260912000003_phase3_coach_schema.sql): Postgres schema & RLS policies (`auth.uid() = user_id`) for `coach_sessions` and `coach_messages`.

## Supabase Tables & RLS Status
- `coach_sessions`: RLS enabled (`auth.uid() = user_id` for select, insert, update, delete).
- `coach_messages`: RLS enabled (`auth.uid() = user_id` for select, insert).

## Deterministic vs. AI Split
- **Pure Dart Deterministic (Client-Side & Offline)**:
  - Context sanitization and prompt construction (`CoachContextBuilder`).
  - Proactive health alert trigger evaluation (`ProactiveInsightsEngine`).
  - Offline fallback responses for nutrition, workout, and recovery queries (`CoachService`).
  - Local chat history indexing (`CoachRepository`).
- **AI-Backed (Server-Side via Supabase Edge Function `coach-message`)**:
  - Complex conversational synthesis, dynamic question answering, and empathetic personalized coaching via Groq (Llama-3.3-70b / Mixtral). Zero AI API keys on the client binary.

## Deviations from Spec
- None.
