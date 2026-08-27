# AI Routing Layer (Groq Multi-Model Router)

## 1. Feature Description
Routes conversational coaching, synthesis, and vision tasks through tiered Groq models server-side, enforcing subscription budgets, per-user response caching in Firestore, and deterministic offline fallbacks.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-F AI Routing Layer, §P0-H Security)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `functions/aiRouter/index.js`: Server-side Groq router implementing tiered routing (`TINY`: Llama 8B, `MEDIUM`: Llama 70B, `LARGE`: Llama 70B Synthesis), MD5-keyed Firestore caching, cost budget enforcement, and fallback templates.
- `lib/features/ai_routing/domain/template_fallback_engine.dart`: Pure Dart offline fallback engine providing domain-appropriate coaching templates when offline.
- `lib/features/ai_routing/data/ai_routing_repository.dart`: Flutter repository invoking the `askAiCoach` Firebase Callable Function with graceful offline fallback.
- `lib/features/ai_routing/providers/ai_routing_provider.dart`: Riverpod providers for managing AI query states.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/aiCache/{cacheKey}`
  - Fields: `response`, `tier`, `modelUsed`, `taskType`, `fromCache`, `createdAt`.
- **Security rules & compliance:** Stored within the user's private document tree (`/users/{uid}/aiCache/**`) ensuring strict DPDP Act right-to-erasure cascading deletion on account purge.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Model tier selection, MD5 cache hashing, subscription token budget verification, and offline template responses are 100% deterministic.
- **AI Logic:** Natural language understanding and response generation via Groq API (server-side only; API keys never touch the client).
- **Split location:** The client triggers `httpsCallable('askAiCoach')`. The Cloud Function handles cache checking, Groq execution, and response caching before returning text to the client.

## 6. Deviations from Spec
- None. Fully adheres to §P0-F specifications.
