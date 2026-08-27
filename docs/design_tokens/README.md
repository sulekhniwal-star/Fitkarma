# Design Tokens

## 1. Feature Description
Provides a unified design token system for FitKarma comprising dark-mode color palettes, glassmorphism opacities, typography scales (Outfit + Inter), spacing baselines, border radii, and spring-physics animation parameters.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-D Design Tokens & UI System)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/shared/theme/app_colors.dart`: Color tokens for dark backgrounds, glassmorphism surfaces, readiness zones, brand accents, and gradients.
- `lib/shared/theme/app_typography.dart`: Typography styles combining Outfit (display/metrics) and Inter (body/captions).
- `lib/shared/theme/app_spacing.dart`: Standardized 4px spacing scale and padding constants.
- `lib/shared/theme/app_radii.dart`: Standard border radius tokens (`sm`, `md`, `lg`, `xl`, `full`).
- `lib/shared/theme/app_animations.dart`: Animation durations and spring curves.
- `lib/shared/theme/app_theme.dart`: Central dark `ThemeData` builder.
- `docs/design_tokens/design_tokens.md`: Design system specification and token dictionary.

## 4. Firestore Collections & Fields
- **Data paths:** None. This is a local UI design system layer.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic local styling and theme values.
- **AI Logic:** None.

## 6. Deviations from Spec
- None. Fully adheres to §P0-D design specifications.
