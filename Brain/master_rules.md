# FitKarma — Master Rules

These are the non-negotiable operating rules for anyone (human or AI agent) working on this repo. They supersede any older guidance that still references Firebase — the backend is Supabase as of the v2.1 migration.

## 1. Source of truth hierarchy
1. `TODO.md` — the only work-order list. Don't build anything that isn't an unchecked item there, in phase order, unless explicitly told to jump ahead.
2. `FitKarma_Documentation_v2_Supabase_Detailed.md` — architecture/spec detail per phase.
3. `data_model.md` — canonical schema; if code and this file disagree, the file wins until updated in the same change.
4. `decisions.md` — why something is built the way it is; check before "fixing" something that looks wrong.

## 2. Locked stack — do not deviate without an explicit decision entry
Flutter 3.x / Dart, Riverpod 2.x, Drift + SQLCipher (local), Supabase (Postgres, Auth, Storage, Edge Functions, Realtime), Groq (server-side only), RevenueCat, Firebase Cloud Messaging (push only), Sentry, MediaPipe, Health Connect / HealthKit.

Any change to this list is an architecture decision — add it to `decisions.md` before writing code against it.

## 3. Non-negotiables
- **No AI keys on the client.** Groq is called only from Edge Functions.
- **No new table or Storage bucket without RLS policies in the same change.** Default-open is never acceptable.
- **No direct Supabase calls from widgets.** All access goes through a repository/service layer per feature.
- **All user-generated data must work offline** (write to Drift first, sync via the outbox — see `architechture.md` §4) unless the spec explicitly says a feature requires connectivity (e.g. live AI coaching).
- **No PII in Sentry breadcrumbs or logs.** Scrub before capture.
- **No client-side-only entitlement checks.** RevenueCat state is only trusted after the server-side webhook writes to `entitlements`.

## 4. Documentation requirement
Every completed feature gets a `README.md` in its folder covering: what it does, which spec section it implements, key files, which tables/buckets it touches, deterministic vs. AI split, and deviations from spec. A feature without this is not "done."

## 5. Definition of done
- [ ] Implemented per the referenced spec section
- [ ] Works offline where required
- [ ] RLS policies added/updated in the same change
- [ ] Tests added (unit + RLS pgTAP where relevant)
- [ ] Feature README written
- [ ] `TODO.md` checkbox ticked in the same change

## 6. When spec and reality conflict
Flag it. Don't silently improvise. Record the resolution in `decisions.md` and note the deviation in the feature README.
