# Feature: Phase 1 — Onboarding

## Overview
Phase 1 implements FitKarma's comprehensive onboarding flow: 7-step guided journey capturing user goals, body metrics with Asian-Indian specific BMI calibration, Ayurvedic Prakriti evaluation (Vata/Pitta/Kapha), Women's Advanced Health & PCOS cycle synchronization, and dynamic workout blueprint selection.

## Spec Sections Implemented
- **Architecture & Data Model**: [architechture.md](file:///f:/fitkarma/Brain/architechture.md) §1–§3; [data_model.md](file:///f:/fitkarma/Brain/data_model.md) (Core identity: `profiles`, `dosha_scores`, `cycle_tracking`).
- **PRD**: [prd.md](file:///f:/fitkarma/Brain/prd.md) §4 (Ayurvedic framing, Indian nutrition moat, Asian-Indian Thin-Fat phenotype mitigation).
- **UI Spec**: [ui_spec.md](file:///f:/fitkarma/Brain/ui_spec.md) §4 (Onboarding flow).

## Key Files & Responsibilities
- [lib/features/onboarding/presentation/screens/onboarding_flow_screen.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/onboarding_flow_screen.dart): Step coordinator with spring physics, progress header, and offline database persistence trigger.
- [lib/features/onboarding/presentation/screens/welcome_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/welcome_step.dart): Brand introduction and core value proposition bento card.
- [lib/features/onboarding/presentation/screens/goals_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/goals_step.dart): Primary health goal selection.
- [lib/features/onboarding/presentation/screens/demographics_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/demographics_step.dart): Height/weight inputs with live Asian-Indian BMI calculation badge.
- [lib/features/onboarding/presentation/screens/dosha_quiz_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/dosha_quiz_step.dart): Interactive Ayurvedic assessment scoring.
- [lib/features/onboarding/presentation/screens/womens_health_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/womens_health_step.dart): Menstrual cycle sync and PCOS insulin sensitivity mode.
- [lib/features/onboarding/presentation/screens/blueprint_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/blueprint_step.dart): Training blueprint selector (Hypertrophy, Strength, Conditioning, Mobility).
- [lib/features/onboarding/presentation/screens/diet_plan_results_step.dart](file:///f:/fitkarma/lib/features/onboarding/presentation/screens/diet_plan_results_step.dart): Personalized Indian macro split, Dosha food guidance, and app transition.
- [lib/features/onboarding/domain/services/bmi_calculator.dart](file:///f:/fitkarma/lib/features/onboarding/domain/services/bmi_calculator.dart): Deterministic Asian-Indian BMI calculator (Normal: 18.5–22.9).
- [lib/features/onboarding/domain/services/dosha_scoring_engine.dart](file:///f:/fitkarma/lib/features/onboarding/domain/services/dosha_scoring_engine.dart): Ayurvedic Prakriti calculation and dietary guidance.
- [lib/features/onboarding/domain/services/womens_health_engine.dart](file:///f:/fitkarma/lib/features/onboarding/domain/services/womens_health_engine.dart): Cycle phase evaluation and workout intensity modifiers.
- [lib/features/onboarding/data/onboarding_repository.dart](file:///f:/fitkarma/lib/features/onboarding/data/onboarding_repository.dart): Local Drift persistence + FIFO outbox queueing for Supabase.
- [supabase/migrations/20260912000002_phase1_onboarding_schema.sql](file:///f:/fitkarma/supabase/migrations/20260912000002_phase1_onboarding_schema.sql): Postgres schema & RLS policies for `dosha_scores` and `cycle_tracking`.

## Supabase Tables & RLS Status
- `profiles`: RLS enabled (`auth.uid() = user_id`).
- `dosha_scores`: RLS enabled (`auth.uid() = user_id`).
- `cycle_tracking`: RLS enabled (`auth.uid() = user_id`).

## Deterministic vs. AI Split
- **Pure Dart Deterministic (Client-Side & Offline)**:
  - Asian-Indian BMI and healthy weight range calculation (`BMICalculator`).
  - Ayurvedic Dosha scoring, percentage breakdown, and dietary recommendations (`DoshaScoringEngine`).
  - Menstrual cycle phase classification and PCOS recommendations (`WomensHealthEngine`).
  - Caloric budget and macronutrient split computation (`MetabolismEngine`).
- **AI-Backed**:
  - Narrative daily briefing and AI coach context hydration in later phases uses the profile and dosha tags generated during onboarding.

## Deviations from Spec
- None.
