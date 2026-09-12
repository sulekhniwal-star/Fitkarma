# FitKarma — Testing Strategy

*(Filename kept as `tedting.md` to match the requested file list — rename to `testing.md` if that was a typo you'd like fixed.)*

## 1. Test pyramid
1. **Unit tests** (Dart) — deterministic logic: readiness scoring, Dosha scoring, macro/micronutrient calculations, karma point math. These must stay 100% offline-runnable with no Supabase/network dependency.
2. **Widget tests** (Flutter) — screen-level behavior, especially offline states (logging while disconnected, sync-pending indicators).
3. **RLS policy tests** (pgTAP via `supabase test db`) — every table's policy set gets at minimum an "owner can read/write their row, a different authenticated user cannot" pair. New tables are not considered done without this.
4. **Edge Function tests** (Deno test runner) — request validation, error-shape conformance (`error_handling.md` §3), and critically: RevenueCat webhook signature verification and the `delete_user_data` cascade, given their billing/compliance sensitivity.
5. **Integration/E2E** — key user flows (onboarding → first DIP, meal logging offline → sync, subscription purchase → entitlement unlock) run against the staging Supabase project.

## 2. Current baseline
- 145/145 automated unit + widget tests passing, 0 issues on `flutter analyze` (carried over from the pre-migration stack — these are stack-agnostic and must keep passing through the Supabase port).

## 3. Migration-specific test additions
- Any feature ported from Firestore-backed access to Supabase-backed access gets its repository-layer tests re-pointed at the Supabase client (mocked) rather than a Firestore mock, and a new RLS test pair added for the underlying table.
- Offline-sync outbox worker: dedicated test suite covering flush success, flush retry/backoff, and conflict resolution (last-write-wins vs. append-only paths) — see `architechture.md` §4.

## 4. CI gating
- `flutter-ci.yml` runs unit + widget tests on every PR.
- `rls-test.yml` runs pgTAP tests on any PR touching migrations.
- No PR merges to `develop`/`main` with a failing required check (see `github_actions.md` §6).

## 5. Manual/exploratory testing
- Offline scenarios (airplane mode mid-log, reconnect during sync) are tested manually each release candidate since they're the hardest to fully automate against real device network transitions.
- ABHA sandbox flows and WhatsApp webhook delivery are tested against sandbox/test credentials before any production credential switch (see `production_checklist.md`).
