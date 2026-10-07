# FitKarma — Decisions Log (ADR-style)

Each entry: context → decision → consequences. Add new entries at the top. Don't edit past entries to "fix" them in hindsight — add a new entry that supersedes the old one instead.

---

## ADR-005: Indian Market High-Convenience Adaptations (UPI Rail, Barcode Scanner, Thali Presets, Hydration, Vernacular Onboarding)
**Context**: FitKarma had advanced intelligence moats (Dosha, CGM, Festival modes), but lacked crucial convenience hooks common in Indian daily life: UPI checkout, packaged food barcode lookups, single-tap thali logging, summer hydration tracking, and instant language onboarding.
**Decision**:
1. **Payments**: Augmented RevenueCat paywall with native Razorpay Fast Checkout sheet supporting Google Pay, PhonePe, Paytm, BHIM, and No-Cost EMI.
2. **Nutrition**: Added `BarcodeScanEngine` pre-seeded with Indian FMCG brands (Amul, Britannia, Maggi, Haldiram, Epigamia, Tata) and `ThaliPresetsScreen` for 1-tap logging of complete regional thalis (North, South, Gujarati, Bengali, Gym Protein).
3. **Hydration**: Added `HydrationTrackerScreen` + Home Bento card with temperature/AQI-aware goal adjustments and desi drinks (Nimbu Pani, Coconut Water, Chai).
4. **Onboarding & Vernacular**: Inserted `LanguageSelectionStep` as Step 0 in the onboarding flow supporting Hindi, Hinglish, Tamil, Telugu, Marathi, Bengali, Gujarati, Punjabi, Kannada, and English.
5. **Engagement & Virality**: Added `ReferralScreen` (WhatsApp invite with 7-day Pro reward), `ShareableProgressCardScreen` (9:16 Instagram/WhatsApp story cards), and "Dost Mode" Hinglish AI coach personality.
**Consequences**: Eliminates friction for Tier-1, Tier-2, and Tier-3 Indian fitness users without adding heavy external server dependencies.

---

## ADR-004: ABHA Integration — Phase 1 Scope (Demo-Safe)
**Context**: Full ABDM (Ayushman Bharat Digital Mission) M1 token exchange requires government sandbox approval and OAuth2 flows that take months. The college major-project demo needs a working ABHA feature now (see PRD §9 Milestone 1).
**Decision**: Phase 1 ships **format validation only** — 14-digit numeric check on the client, upsert to `abha_records` with `fhir_sync_status = 'pending'` via the `validate-abha` Edge Function. The UI shows "ABHA Linked — Records will sync once ABDM integration is live." No actual ABDM API calls are made.
**Consequences**: Demo works without government approval. `fhir_sync_status` column already distinguishes `pending` vs `synced` so Phase 2 (real M1 token exchange) can update that column without a schema change. Live ABDM token exchange is tracked as a post-launch milestone in `architechture.md §3` under the ABHA edge function.

---

## ADR-003: RevenueCat entitlement verification moves server-side
**Context**: entitlement checks were previously validated client-side only, which is spoofable and doesn't survive reinstalls/device changes correctly.
**Decision**: RevenueCat webhook → Edge Function verifies signature → upserts `entitlements` table via service role. Client reads `entitlements`, never trusts local RevenueCat SDK state alone for gating.
**Consequences**: adds one more Edge Function and a webhook endpoint to secure/test (see `security.md`, `tedting.md`); closes the spoofing gap.

---

## ADR-002: Offline-first sync approach — Hand-rolled Drift Outbox + Append-Only Telemetry
**Context**: Firestore's automatic offline cache has no direct Supabase equivalent (see `architechture.md` §4).
**Options considered**: (a) hand-rolled Drift outbox + sync worker, (b) PowerSync, (c) ElectricSQL.
**Decision**: **Option (a) Hand-rolled Drift outbox (`pending_mutations`) with `OutboxSyncWorker`.** For high-frequency telemetry tables (`wearable_samples`, `cgm_telemetry`), an append-only unique constraint `(user_id, source, metric, timestamp)` is enforced, completely avoiding update conflicts on late sync. For mutable profile/setting rows, `updated_at`-based last-write-wins is applied.
**Consequences**: zero external SDK vendor dependency; utilizes existing SQLCipher-encrypted Drift database already in the stack; predictable local writes with automatic background flush on reconnect.

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
