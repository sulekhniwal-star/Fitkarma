# FitKarma — Changelog

Format: date-less, version-based (dates added once actual commit history exists to source them from — don't backfill invented dates).

## v2.2 — Documentation detail pass
- Expanded the master documentation with concrete project specifics (project context, phase completion status, stack additions: Drift/SQLCipher, MediaPipe, Health Connect/HealthKit, Sentry).
- Added §2.1 Offline-First Strategy to address the loss of Firestore's automatic offline cache.
- Added §6 Open Decisions section to the master doc.
- Split out the full documentation suite: `master_rules.md`, `prd.md`, `trd.md`, `architechture.md`, `data_model.md`, `data_sources.md`, `scrapping_spec.md`, `api_contract.md`, `ui_spec.md`, `error_handling.md`, `security.md`, `admob_spec.md`, `github_actions.md`, `tedting.md`, `production_checklist.md`, `microtasks.md`, `decisions.md`, `skil.md`.

## v2.1 — Firebase → Supabase migration doc
- Replaced Firestore → Supabase Postgres (RLS), Cloud Functions → Edge Functions, Firebase Auth → Supabase Auth, Cloud Storage → Supabase Storage.
- Added Supabase Realtime for squad/social feeds.
- Flagged the offline-first gap and the FCM-for-push-only exception as migration risks.

## v2.0 — Master documentation baseline
- Original Firebase-stack documentation: 16-phase roadmap (P0–P16), DPDP Act 2023 compliance mechanism, 145/145 test baseline.

## v1.0 — Initial stack lock
- Locked stack for the fresh rebuild: Flutter/Dart frontend, Node.js Cloud Functions backend, Firestore database, REST API pattern — superseded by the Supabase migration in v2.1.
