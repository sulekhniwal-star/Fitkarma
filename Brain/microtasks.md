# FitKarma — Microtasks (Firebase → Supabase Migration)

This supplements `TODO.md` with the granular breakdown for the active migration work. `TODO.md` remains the authoritative checklist for what's "next"; this file exists so a task doesn't get marked done prematurely.

## 1. Supabase project setup
- [ ] Provision staging Supabase project.
- [ ] Configure Auth providers (Phone OTP, Google OAuth).
- [ ] Set up `supabase/migrations/` directory structure and initial schema migration from `data_model.md`.
- [ ] Write RLS policies for every table in the same migration that creates it (no table ships without one).

## 2. Local offline-sync layer (§2.1 of the doc, `architechture.md` §4)
- [ ] Decide: hand-rolled Drift outbox vs. PowerSync/ElectricSQL (log decision in `decisions.md`).
- [ ] If hand-rolled: implement `pending_mutations` table in Drift.
- [ ] Implement background sync worker (flush on reconnect, exponential backoff).
- [ ] Implement incremental pull sync (`updated_at`-based).
- [ ] Write conflict-resolution logic for mutable tables; unique-constraint append-only pattern for telemetry tables.

## 3. Auth migration
- [ ] Port phone OTP flow to Supabase Auth.
- [ ] Port Google Sign-In to Supabase OAuth.
- [ ] Build ABHA M1 token → custom JWT claim Edge Function.
- [ ] Migrate any existing user session handling in Riverpod providers.

## 4. Data/Storage migration
- [ ] Write one-time migration script(s) for any existing user data (Firestore export → Postgres import), if there is production data to preserve.
- [ ] Recreate Storage buckets (`meals`, `progress-photos`, `clinical-dossiers`) with bucket policies.
- [ ] Migrate existing Storage objects, preserving path structure.

## 5. Backend logic port (per phase, P0–P9 first since those are already built)
- [ ] Port each Cloud Function to an equivalent Edge Function (see `api_contract.md` for target contracts).
- [ ] Replace Firestore `onWrite` triggers with Postgres triggers or Database Webhooks.
- [ ] Replace Firestore snapshot listeners (squads/social feeds) with Supabase Realtime subscriptions.
- [ ] Re-point each feature repository from Firestore calls to Supabase client calls, one feature at a time (P0 → P9 in order, per `master_rules.md` §1).

## 6. Monetisation
- [ ] Rebuild `entitlements` table and RevenueCat webhook Edge Function (server-side verification, closing the prior client-only gap — see `decisions.md`).
- [ ] Wire AdMob tier-gating to the new `entitlements` table (`admob_spec.md` §7).

## 7. CI/CD
- [ ] Add `supabase-migrate.yml` and `edge-functions-deploy.yml` workflows.
- [ ] Add `rls-test.yml` (pgTAP) workflow.
- [ ] Remove any remaining `firebase deploy` CI steps once the corresponding piece is fully ported.

## 8. Testing
- [ ] Re-point repository-layer unit tests from Firestore mocks to Supabase client mocks per ported feature.
- [ ] Add RLS pgTAP tests per table.
- [ ] Add Deno tests for each Edge Function, prioritizing the RevenueCat webhook and `delete_user_data`.

## 9. Documentation
- [ ] Update each feature's README (per `master_rules.md` §4) to reflect the Supabase-backed implementation once ported.
- [ ] Log every non-trivial migration choice in `decisions.md` as it's made, not retroactively.
