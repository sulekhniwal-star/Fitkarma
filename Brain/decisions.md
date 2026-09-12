# FitKarma — Decisions Log (ADR-style)

Each entry: context → decision → consequences. Add new entries at the top. Don't edit past entries to "fix" them in hindsight — add a new entry that supersedes the old one instead.

---

## ADR-003: RevenueCat entitlement verification moves server-side
**Context**: entitlement checks were previously validated client-side only, which is spoofable and doesn't survive reinstalls/device changes correctly.
**Decision**: RevenueCat webhook → Edge Function verifies signature → upserts `entitlements` table via service role. Client reads `entitlements`, never trusts local RevenueCat SDK state alone for gating.
**Consequences**: adds one more Edge Function and a webhook endpoint to secure/test (see `security.md`, `tedting.md`); closes the spoofing gap.

---

## ADR-002: Offline-first sync approach — pending decision
**Context**: Firestore's automatic offline cache has no Supabase equivalent (see `architechture.md` §4).
**Options considered**: (a) hand-rolled Drift outbox + sync worker, (b) PowerSync, (c) ElectricSQL.
**Decision**: **not yet finalized.** Default assumption in the docs is (a), since Drift/SQLCipher is already in the stack, but this should be confirmed before Phase 4 work resumes — the wearable late-sync conflict logic depends on which path is chosen.
**Consequences**: TBD — update this entry once decided, don't leave two conflicting "decisions" in the docs.

---

## ADR-001: Migrate backend from Firebase to Supabase
**Context**: original v1.0/v2.0 stack used Firebase (Firestore, Cloud Functions, Auth, Storage). Decision made to switch to Supabase.
**Decision**: Firestore → Postgres (RLS), Cloud Functions v2 → Edge Functions (Deno), Firebase Auth → Supabase Auth, Cloud Storage → Supabase Storage. FCM retained standalone for push notifications since Supabase has no equivalent.
**Consequences**: gains RLS/SQL/Realtime and (implicitly) more predictable relational modeling for tables like `entitlements` and `grocery_price_matrix`; loses Firestore's free offline persistence, requiring the new work tracked in ADR-002.

---

## Open items still needing a decision entry once resolved
- AQI/UV/Wet-Bulb data provider selection (`data_sources.md` §4).
- CGM vendor/format targeted first (`data_sources.md` §5).
- Per-vendor ToS status for grocery scraping (`scrapping_spec.md` §2) — track one line per vendor here once confirmed.
- AdMob mediation network selection (`admob_spec.md` §8).
- Column-level encryption scope for sensitive health fields (`security.md` §4).
