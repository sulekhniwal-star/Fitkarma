# Proactive Event-Driven Insights

## 1. Feature Description
Monitors user biometric milestones and real-time environmental factors to deliver proactive, contextual insight nudges (PR celebrations, sleep deficit training load adjustments, extreme AQI warnings, evening protein reminders, circadian wind-down cues).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 3 — AI Adaptive Coach, §P3 Proactive Event-Driven Insights)
- **Phase:** Phase 3 — AI Adaptive Coach

## 3. Key Files & Responsibilities
- `lib/features/ai_coach/domain/proactive_insight_engine.dart`: Pure Dart deterministic trigger evaluation engine for PR milestones, severe sleep deficits ($<5.5\text{h}$), environmental hazard warnings ($\text{AQI}>250$, $\text{Heat Index}>38^\circ\text{C}$), evening protein reminders, and 9:00 PM wind-down cues.
- `lib/features/ai_coach/presentation/proactive_insight_card.dart`: Interactive bento card with color-coded urgency indicators, category icons, and direct actionable shortcut buttons.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/dailyLogs/{date}`, `/users/{uid}/healthOS/{date}`
  - Writes: Logged as ephemeral proactive notifications or persisted to `/users/{uid}/dailyInsights/{date}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic biometric trigger evaluation, threshold testing, and rule-based nudge generation in pure Dart.
- **AI Logic:** None in the core trigger engine; insights can optionally be expanded in chat conversations with Karma Coach.

## 6. Deviations from Spec
- None. Fully adheres to Proactive Event-Driven Insights specifications.
