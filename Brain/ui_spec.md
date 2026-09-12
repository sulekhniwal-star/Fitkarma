# FitKarma — UI Spec

## 1. Design language
- **Theme**: dark mode primary, background `#0D0F12`.
- **Style**: glassmorphism panels, bento-grid layout for dashboard/home content, spring-physics-based motion (not linear easing) for card transitions and metric reveals.
- **Localization**: every user-facing string ships bilingual (Hindi/English) via `BilingualLabel`; vernacular voice logging screens additionally support Hinglish, Tamil, Telugu input.

## 2. Core reusable components (Phase 0)
- **`BentoCard`** — base card primitive for the bento grid; supports glass background, elevation, and a size variant (1x1, 2x1, 2x2).
- **`ActivityRings`** — circular multi-metric progress rings (steps/calories/active minutes style), reused across readiness and workout summaries.
- **`GlowingMetric`** — single-number hero metric with a glow/pulse treatment for "the one thing to look at" on a card.
- **`BilingualLabel`** — text widget that renders the active language pair per user preference, falling back to English if a Hindi string is missing.

## 3. Navigation structure
- Bottom navigation: Home (DIP/dashboard), Nutrition, Workout, Squad/Social, Profile.
- Contextual entry points (not in bottom nav): Coach chat (floating action), Doctor dossier share (from Profile), Corporate dashboard (separate entry for B2B accounts, surfaces via FitKarma Hub-issued deep link).

## 4. Key screens by phase
- **Onboarding (P1)**: demographics → BMI calibration → Dosha assessment → women's health toggle (if applicable).
- **Home/Daily Mission (P2)**: readiness score hero (`GlowingMetric`), morning briefing card, soreness heatmap.
- **Coach (P3)**: chat-style interface, model attribution not shown to the user (internal only).
- **Nutrition (P5)**: meal log (photo/voice/manual), swap suggestions, grocery price comparison view.
- **Workout (P6)**: session player with MediaPipe pose overlay for form feedback.
- **Squad/Social (P9)**: feed, squad challenge cards, geolocation club discovery.
- **Predictive Health (P10)**: biological age card, CGM trend chart, doctor dossier share flow.
- **Monetisation (P13)**: paywall screens per tier, clearly distinguishing Free (ad-supported, see `admob_spec.md`) from Pro/Elite (ad-free).

## 5. Accessibility
- Minimum tap target sizes per platform guidelines.
- Color contrast checked against the dark `#0D0F12` background for all text/glass combinations, not just the default theme swatches.
- All icon-only actions carry a semantic label for screen readers.

## 6. Ad placement constraint (ties to `admob_spec.md`)
No ad units appear on clinical/biomarker/CGM screens or the Dosha/women's-health flow, regardless of tier — ad placement is restricted to non-sensitive, non-clinical surfaces (e.g. dashboard footer, nutrition browse) on the Free tier only.
