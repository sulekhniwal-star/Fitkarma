# Phase 4 — Health Tracking & Wearable Sync (Unblocked)

## Status
Fully unblocked and wired. All Drift tables, Supabase schema, and RLS policies were already in place (migration `20260912000004_phase4_health_tracking_schema.sql`). This phase adds the missing client-side wiring.

## What Changed (vs. previous state)
| Component | Before | After |
|:---|:---|:---|
| `OutboxSyncWorker.pullSync()` | Missing | Added — incremental pull from Supabase (`updated_at > last_synced_at`) |
| `GoogleHealthSyncService` | Existed but not triggered | Triggered on app startup + every `AppLifecycleState.resumed` event |
| `FitKarmaApp` | `StatelessWidget` | `ConsumerStatefulWidget` with `WidgetsBindingObserver` |
| AndroidManifest | Missing BLOOD_OXYGEN, HRV | Added `READ_BLOOD_OXYGEN`, `READ_HEART_RATE_VARIABILITY` |

## Architecture
```
App resume / startup
  └─► _FitKarmaAppState.didChangeAppLifecycleState(resumed)
        └─► GoogleHealthSyncService.syncData(userId)          [lib/features/health_tracking/services/]
              ├─► Health.getTotalStepsInInterval()            [health package — Health Connect / HealthKit]
              ├─► Health.getHealthDataFromTypes()             [steps, HR, sleep, BP, glucose]
              └─► HealthTrackingRepository.recordWearableSample()  [lib/features/health_tracking/data/]
                    ├─► Drift INSERT (synchronous, offline-first)
                    └─► OutboxSyncWorker.enqueueMutation()    [async, flushes on reconnect]
                          └─► Supabase wearable_samples UPSERT  [unique constraint = no conflict on late sync]
```

## Key Files
- [`lib/features/health_tracking/services/google_health_sync_service.dart`](file:///f:/fitkarma/lib/features/health_tracking/services/google_health_sync_service.dart) — Health Connect/HealthKit read + Riverpod Notifier
- [`lib/core/sync/outbox_sync_worker.dart`](file:///f:/fitkarma/lib/core/sync/outbox_sync_worker.dart) — push outbox + new `pullSync()` method
- [`lib/main.dart`](file:///f:/fitkarma/lib/main.dart) — lifecycle observer triggers sync on resume
- [`supabase/migrations/20260912000004_phase4_health_tracking_schema.sql`](file:///f:/fitkarma/supabase/migrations/20260912000004_phase4_health_tracking_schema.sql) — schema + RLS + unique constraints

## Tables & RLS
- `wearable_samples` — unique `(user_id, source, metric, timestamp)` — append-only, conflict-free late sync (ADR-002)
- `biomarkers` — owner RLS (select/insert/update/delete)
- `cgm_telemetry` — unique `(user_id, recorded_at)` — append-only

## Deterministic vs. AI Split
- **Pure Dart (offline)**: `WearableComparisonEngine` (4-tier confidence weighting), `PreventiveIntelligenceEngine` (BP staging, HbA1c, Thin-Fat phenotype)
- **Platform API (online)**: Health Connect / HealthKit reads via `health` package
- **No AI calls** in this phase — all data ingestion and analysis is deterministic

## Deviations from Spec
- None.
