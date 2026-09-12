# FitKarma — Error Handling

## 1. Principles
- Never let a network or backend error block a locally-loggable action (meal, workout, biometric entry) — write to Drift first, surface sync errors separately and non-blockingly.
- Never show a raw exception, stack trace, or backend error code to the user — always a bilingual, human-readable message with an optional "details" affordance for support/debugging.
- Every caught exception that isn't purely expected (e.g. normal offline state) goes to Sentry with PII scrubbed.

## 2. Client-side (Flutter)
- Each feature repository wraps Supabase/Drift calls and maps exceptions to a small set of typed failures (`NetworkFailure`, `AuthFailure`, `ValidationFailure`, `SyncConflictFailure`, `UnknownFailure`) that Riverpod state exposes to the UI.
- Retry policy: exponential backoff for transient network failures on sync (outbox worker), capped at a sane max interval; no infinite tight retry loops.
- AI call failures (Groq unreachable/timeout via Edge Function): fall back to the last cached DIP/coach response with a "showing your last update" notice rather than blocking the screen.
- Sentry: Flutter SDK captures unhandled exceptions and flagged handled failures; scrub `email`, `phone`, `abha_id`, and any biometric values before attaching context.

## 3. Backend (Edge Functions) — standard error shape
```json
{
  "error": {
    "code": "AUTH_REQUIRED" | "VALIDATION_FAILED" | "RATE_LIMITED" | "UPSTREAM_FAILURE" | "INTERNAL",
    "message": "human-readable, safe to log"
  }
}
```
- `UPSTREAM_FAILURE` covers Groq/RevenueCat/WhatsApp/ABDM dependency failures — Edge Functions must catch these explicitly and never leak the upstream's raw error body to the client.
- All Edge Function exceptions are reported to Sentry (server-side SDK) with the request's `user_id` (not full JWT) attached for correlation.

## 4. Data sync conflicts
- Mutable-row conflicts (e.g. profile edits from two devices) resolve via `updated_at`-based last-write-wins; the losing write is logged (not silently dropped) so a future "sync history" view is possible.
- Append-only tables (`wearable_samples`, `cgm_telemetry`) use a unique constraint to make conflicts structurally impossible rather than resolving them after the fact.

## 5. Third-party degradation behavior
| Dependency | Failure mode | Behavior |
| :--- | :--- | :--- |
| Groq | Timeout/5xx | Serve cached DIP/coach reply, flag as stale |
| RevenueCat webhook | Signature/verification failure | Reject (401), do not update entitlements, alert via Sentry |
| Grocery price sources | Scrape blocked / API down | Serve last cached price, flagged stale; drop vendor from comparison if no cache exists |
| ABDM/ABHA | Sandbox/prod outage | Disable ABHA-linked features for the session, don't block core app usage |
| WhatsApp | Webhook delivery failure | Meta retries per their standard policy; no custom retry needed client-side |

## 6. User-facing error copy
All error messages go through the same bilingual copy review as the rest of the UI (see `ui_spec.md`) — no untranslated English-only error strings in production.
