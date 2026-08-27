# Cloud Function AI Coach Endpoint

## 1. Feature Description
Provides a secure server-side Firebase Cloud Function (`askAiCoach`) that brokers client communication with Groq LLMs, enforcing authentication, subscription query budgets, and per-user MD5 request caching.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 3 — AI Adaptive Coach, §P3 & §P0-F Cloud Function Coach Endpoint)
- **Phase:** Phase 3 — AI Adaptive Coach

## 3. Key Files & Responsibilities
- `functions/index.js`: Exports `exports.askAiCoach = onCall(...)` with authenticated user context validation.
- `functions/aiRouter/index.js`: Core router implementing multi-tier model selection (`TINY` 8B, `MEDIUM` 70B, `LARGE` 70B), MD5 payload hashing, per-user `/users/{uid}/aiCache` retrieval, and deterministic template fallback strings.
- `lib/features/ai_routing/data/ai_routing_repository.dart`: Flutter client repository calling `askAiCoach` with automatic fallback to `TemplateFallbackEngine`.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{userId}/aiCache/{md5Hash}`
  - Fields: `response`, `tier`, `modelUsed`, `fromCache`, `taskType`, `createdAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Authentication checks, budget enforcement, MD5 cache key generation, and template fallback strings are 100% deterministic in JavaScript / Node.js.
- **AI Logic:** Natural language completion executed via Groq SDK (`groq-sdk`).

## 6. Deviations from Spec
- None. Fully adheres to Cloud Function Coach Endpoint specifications.
