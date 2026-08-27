# Shared Foundation Widgets (BentoCard, ActivityRings, GlowingMetric, BilingualLabel)

## 1. Feature Description
Provides reusable, high-aesthetic UI foundation widgets for FitKarma's glassmorphic dashboards, biometric activity rings, neon metric indicators, and multilingual Indian UX.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-D Design Tokens & UI System — Shared foundation widgets)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/shared/widgets/bento_card.dart`: Glassmorphism bento-grid card with backdrop blur and touch spring feedback.
- `lib/shared/widgets/activity_rings.dart`: Multi-concentric animated activity and readiness ring renderer.
- `lib/shared/widgets/glowing_metric.dart`: Numerical metric component with glowing drop shadows and trend indicators.
- `lib/shared/widgets/bilingual_label.dart`: Multilingual typography component pairing English with regional Indian language copy.
- `lib/shared/widgets/widgets.dart`: Barrel export file for convenient import.
- `docs/shared_foundation_widgets/foundation_widgets.md`: Technical specification and usage guidelines.

## 4. Firestore Collections & Fields
- **Data paths:** None. Pure UI presentation components.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic UI rendering and local animation physics.
- **AI Logic:** None.

## 6. Deviations from Spec
- None. Fully adheres to §P0-D design specifications.
