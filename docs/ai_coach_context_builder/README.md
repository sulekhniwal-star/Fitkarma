# AI Coach Philosophy & Context Builder

## 1. Feature Description
Compiles the user's complete physiological state (biometrics, readiness, sleep architecture, somatic soreness, daily strain, environmental AQI/heat) into an empathetic, evidence-based system prompt for the AI Coach.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 3 — AI Adaptive Coach, §P3 AI Coach Philosophy & Context Builder)
- **Phase:** Phase 3 — AI Adaptive Coach

## 3. Key Files & Responsibilities
- `lib/features/ai_coach/domain/coach_philosophy_prompt.dart`: Master coaching guidelines, cultural fluency rules (Indian diet, fasting, urban pollution), and medical boundary guardrails.
- `lib/features/ai_coach/domain/coach_context_builder.dart`: Pure Dart deterministic builder compiling user demographics, daily intelligence packages (DIP), sleep stages, body soreness, and environmental heat into structured payload strings.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}`, `/users/{uid}/healthOS/{date}`, `/users/{uid}/dailyLogs/{date}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic compilation of context metrics, payload serialization, and safety constraints.
- **AI Logic:** The compiled system prompt is dispatched server-side to Groq LLM instances via Firebase Cloud Functions.

## 6. Deviations from Spec
- None. Fully adheres to AI Coach Philosophy & Context Builder specifications.
