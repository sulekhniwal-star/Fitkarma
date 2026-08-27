# AI Coach Screen (Local Chat Cache, Optimistic UI)

## 1. Feature Description
Provides a real-time conversational chat interface with Karma Coach, featuring instantaneous optimistic UI message insertion, sub-50ms opening with local caching, contextual prompt chips, and seamless offline template fallbacks.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 3 — AI Adaptive Coach, §P3 AI Coach Screen)
- **Phase:** Phase 3 — AI Adaptive Coach

## 3. Key Files & Responsibilities
- `lib/features/ai_coach/domain/coach_message.dart`: Message entity model supporting sender roles (`user`, `coach`), timestamps, and optimistic flags.
- `lib/features/ai_coach/data/coach_chat_repository.dart`: Firestore repository with local cache retrieval.
- `lib/features/ai_coach/providers/coach_chat_provider.dart`: Riverpod `StateNotifier` orchestrating optimistic UI updates, Groq multi-model routing requests, and `TemplateFallbackEngine` offline fallbacks.
- `lib/features/ai_coach/presentation/coach_chat_screen.dart`: Interactive chat screen with prompt chips, thinking indicators, auto-scrolling, and glassmorphic bubbles.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/aiConversations/{date}`
  - Fields: `messages` (`id`, `text`, `sender`, `timestamp`), `lastUpdatedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Message rendering, optimistic UI state management, scrolling, and offline template responses are 100% deterministic pure Dart.
- **AI Logic:** Natural language responses are synthesized via Groq Llama models through backend Cloud Functions.

## 6. Deviations from Spec
- None. Fully adheres to AI Coach Screen specifications.
