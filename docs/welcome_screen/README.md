# Welcome Screen

## 1. Feature Description
Serves as the high-impact brand entry point for FitKarma, introducing the Health OS Brain, Indian nutrition intelligence, and adaptive AI coaching pillars with bilingual copy and smooth animation.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Welcome Screen)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/presentation/screens/welcome_screen.dart`: Animated presentation screen featuring the glowing concentric `ActivityRings` emblem, bilingual headlines, value proposition `BentoCard` items, and primary/secondary CTAs.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod notifier managing step transitions on "Get Started" click.

## 4. Firestore Collections & Fields
- **Data paths:** None. Pure presentation entry screen; writes are initiated after subsequent onboarding steps are submitted.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic local UI rendering and animation physics.
- **AI Logic:** None.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Welcome Screen specifications.
