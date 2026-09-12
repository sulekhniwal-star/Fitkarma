# FitKarma — Architecture

## 1. High-level shape

```
Flutter App (Riverpod) ──► Drift/SQLCipher (local source of truth)
        │                          │
        │ sync (outbox worker)     │ reads
        ▼                          ▼
   Supabase client SDK  ◄──────────┘
        │
        ▼
Supabase Postgres (RLS) ── Storage ── Auth (GoTrue) ── Realtime
        │
        ▼
Supabase Edge Functions (Deno/TS)
        │
   ┌────┼─────────────┬─────────────┬───────────────┐
   ▼    ▼              ▼             ▼               ▼
 Groq  RevenueCat   FCM (push)   WhatsApp API   ABDM/ABHA
```

FitKarma Hub (admin/ops platform) talks to the same Supabase project through its own Edge Functions using the service-role key — it never uses RLS-bypassing client keys directly from a browser.

## 2. Client architecture
- **UI**: Flutter widgets following the Bento/glassmorphism design system (see `ui_spec.md`).
- **State**: Riverpod `StateNotifierProvider`s per feature, one repository per feature (e.g. `lib/features/nutrition/data/nutrition_repository.dart`).
- **Local persistence**: Drift (SQLCipher-encrypted) is the primary read/write surface. Providers read from Drift; Drift is kept in sync with Supabase by a background worker, not queried against Supabase directly on every UI read.
- **Deterministic vs. AI split**: anything marked "Pure Dart — No AI" in the phase spec is implemented client-side, unit-tested, offline-capable. AI logic (coaching, meal photo analysis, narrative summaries) never runs client-side and never embeds a Groq key.

## 3. Backend architecture
- **Postgres**: one schema, RLS on every user-data table (`auth.uid() = user_id`). Materialized views for cohort benchmarking, refreshed on a schedule.
- **Auth**: Supabase Auth (GoTrue) — phone OTP + Google OAuth for normal users; ABHA M1 token exchanged for a custom JWT claim via an Edge Function for ABDM-linked accounts.
- **Storage**: private buckets (`meals`, `progress-photos`, `clinical-dossiers`) with bucket-level RLS mirroring table RLS; access via signed URLs only.
- **Edge Functions**: Groq routing/DIP orchestration, RevenueCat webhook verification, `delete_user_data` cascade, WhatsApp webhook, ABHA token exchange, doctor-dossier PDF generation, grocery price ingestion job trigger.
- **Realtime**: Postgres logical replication (WAL) powers squad feeds, doctor-dossier update notifications, and FitKarma Hub live dashboards.

## 4. Offline-first sync architecture
1. All writes land in Drift first (instant, works offline).
2. A `pending_mutations` outbox table records unsynced writes.
3. A background worker flushes the outbox to Supabase on reconnect; conflict strategy is `updated_at`-based last-write-wins for mutable rows, and append-only + unique constraint for telemetry (`wearable_samples`, `cgm_telemetry`) to avoid conflicts entirely.
4. Pulls are incremental: `select * where updated_at > :last_synced_at`, not full-table refreshes.
5. If the outbox/worker approach becomes a maintenance burden, PowerSync or ElectricSQL are the pre-agreed fallback (see `decisions.md`).

## 5. AI routing layer (Health OS Brain)
A single orchestration point in Edge Functions builds the Daily Intelligence Package (DIP) by combining cached feature outputs (readiness, nutrition, workout state) with model calls, routed by task complexity:
- Llama-3.3-70b — complex coaching narratives.
- Mixtral — fast structured analysis (e.g. food swap suggestions).
- Llama-3.2-11b (vision) — meal photo recognition.
Redundant AI calls are avoided by caching DIP components with short TTLs keyed on the inputs that changed.

## 6. Deployment topology
- Flutter app: built via GitHub Actions (Android + iOS), distributed via Play Console / TestFlight during development.
- Supabase: schema migrations and Edge Function deploys via `supabase` CLI in CI (see `github_actions.md`).
- Monitoring: Sentry receives client crashes and Edge Function exceptions.
