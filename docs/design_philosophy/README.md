# Design Philosophy & Anti-Patterns

## 1. Feature Description
Establishes the foundational design principles, architectural rules, deterministic vs. AI separation, and anti-pattern guardrails for FitKarma — India's intelligent health operating system.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Vision Statement, §P0-A, §P0-B, §P0-D, §P0-E, §P0-F, §P0-H)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `docs/design_philosophy/design_philosophy_and_anti_patterns.md`: Detailed architectural specification covering the Decision Engine model, Health OS Brain orchestration, deterministic math vs. AI split, offline-first resilience, India-first customization, and explicit anti-patterns to avoid.
- `SKILL.md`: Mandatory development workflow and 5-step checklist for all codebase changes.
- `TODO.md`: Phase-by-phase execution roadmap.

## 4. Firestore Collections & Fields
- **Data paths:** None for this foundational design document.
- **Rule enforcement:** Establishes the standard that all future collections under `/users/{uid}/*` must enforce strict user-level isolation (`request.auth.uid == uid`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** All health metrics, score algorithms, progressive overload logic, safety boundaries, and streak calculations are written in pure, unit-tested Dart / JavaScript without LLM dependencies.
- **AI Logic:** Reserved exclusively for language understanding, meal photo perception, personalized coaching narrative generation, and speech parsing via backend Cloud Functions.
- **Split location:** The client never invokes AI APIs directly; the Health OS Brain orchestrates AI requests server-side through the Groq AI router.

## 6. Deviations from Spec
- None. Fully aligns with the v2.0 master architecture specification.
