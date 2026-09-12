# FitKarma — Security

## 1. Access control
- **Row Level Security (RLS)** is the sole authorization mechanism for user data in Postgres — every table enable-RLS with an explicit `auth.uid() = user_id` policy set (see `data_model.md` for the pattern). No table ships with RLS disabled or a default-allow policy.
- **Storage buckets** mirror the same ownership model with bucket-level policies; all user media access goes through short-lived signed URLs, never public bucket URLs.
- **Service role key** exists only inside Edge Functions and FitKarma Hub's backend — never bundled in the Flutter client, never exposed to a browser context.

## 2. Authentication
- Supabase Auth (GoTrue): phone OTP + Google OAuth for standard sign-in.
- ABHA-linked accounts: M1 token exchanged server-side (Edge Function) for a custom JWT claim (`abha_linked: true`) — the ABHA token itself is never stored client-side beyond the exchange call.
- Session tokens follow Supabase Auth's standard refresh-token rotation; no custom session handling.

## 3. Secrets management
- All third-party API keys (Groq, RevenueCat, Meta, ABDM, AdMob, Sentry DSN for server-side) live in Supabase project secrets / GitHub Actions secrets — never committed to the repo, never in client build config beyond public-safe keys (e.g. AdMob app ID, Sentry client DSN, which are designed to be public).
- Key rotation: Supabase project API keys and third-party secrets rotated on a defined schedule and immediately on any suspected exposure; log rotations in `decisions.md` or an internal ops log.

## 4. Data protection
- Sensitive fields (cycle tracking, biomarkers, CGM telemetry) are scoped by RLS at minimum; column-level encryption (pgcrypto/Vault) is evaluated per legal review before general availability — track this as an open item in `production_checklist.md`.
- Sentry error capture scrubs PII (name, phone, email, ABHA ID, biometric values) before events are sent — configured via `beforeSend` hooks on both client and server SDKs.
- No AI provider (Groq) receives more context than the specific task needs; conversation/meal data sent to Groq is scoped to the coaching/vision task at hand, not a full user data dump.

## 5. DPDP Act 2023 compliance
- Cascading right-to-erasure (`delete_user_data`) covers all 23+ user-data tables plus Storage objects, with an anonymized `erasure_receipts` record as proof of completion (see `data_model.md`, `architechture.md`).
- Data minimization: only fields with a stated product purpose are collected; anything speculative gets flagged in `decisions.md` before being added to a table.
- User isolation is structural (RLS), not just application-layer — a bug in Flutter/Edge Function code cannot expose another user's row without also being a Postgres policy bug.

## 6. Dependency & infra security
- Dependency vulnerability scanning as part of CI (see `github_actions.md`) for both the Flutter/Dart and Deno (Edge Functions) dependency trees.
- Supabase project-level settings (network restrictions, SSL enforcement) reviewed at each phase of `production_checklist.md`, not just once at launch.

## 7. Incident response
- Sentry is the first signal for both crashes and Edge Function exceptions; anomalous RLS-policy-denied spikes are a signal worth alerting on separately (possible probing).
- Any vendor legal/ToS contact related to the grocery scraping fallback routes to whoever owns FitKarma's legal review, not just to an engineering fix (see `scrapping_spec.md` §5).
