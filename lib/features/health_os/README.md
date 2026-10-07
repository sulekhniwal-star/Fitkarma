# Feature: Medical Records (Phase 10 — Predictive & Clinical Health)

## Overview
Offline-first clinical data layer for FitKarma. Covers lab report upload/parsing (Groq vision), medication tracking, ABHA ID linking, and doctor access grants.

## Spec Sections Implemented
- `architechture.md §3` (Edge Functions: ABHA, doctor dossier), `data_model.md` (Phase 10 tables)
- `decisions.md ADR-004` (ABHA Phase 1 scope: format validation only, live ABDM deferred)

## Key Files
| File | Role |
|:---|:---|
| [`lib/features/health_os/data/medical_records_repository.dart`](file:///f:/fitkarma/lib/features/health_os/data/medical_records_repository.dart) | Offline-first repo — Drift writes + outbox sync |
| [`lib/features/health_os/presentation/providers/medical_records_providers.dart`](file:///f:/fitkarma/lib/features/health_os/presentation/providers/medical_records_providers.dart) | Riverpod streams + `MedicalRecordsController` |
| [`supabase/functions/parse-lab-report/index.ts`](file:///f:/fitkarma/supabase/functions/parse-lab-report/index.ts) | Groq llama-3.2-11b-vision → structured lab JSON + bilingual summary |
| [`supabase/functions/validate-abha/index.ts`](file:///f:/fitkarma/supabase/functions/validate-abha/index.ts) | 14-digit ABHA format validation + abha_records upsert |
| [`supabase/migrations/20261007000017_phase10_addendum_storage_abha.sql`](file:///f:/fitkarma/supabase/migrations/20261007000017_phase10_addendum_storage_abha.sql) | clinical-dossiers Storage RLS + pdf_storage_path column + abha unique constraint |

## Supabase Tables & RLS
| Table | RLS | Notes |
|:---|:---|:---|
| `clinical_lab_reports` | owner ALL | + `pdf_storage_path` column for Storage reference |
| `medications` | owner ALL | `is_taken_today` mutable (UPDATE via outbox) |
| `abha_records` | owner ALL | Unique on `user_id` — one ABHA per user |
| `doctor_access_grants` | owner ALL | Soft-delete via `is_active = false` |

## Storage Bucket
- **Name**: `clinical-dossiers` | **Access**: Private (signed URLs only, 1-hour TTL)
- **Path structure**: `{user_id}/lab_{report_id}.pdf`
- **RLS**: `storage.foldername(name)[1] = auth.uid()::text` — users read/write only their own folder

## Lab Report Flow
```
User picks PDF
  → MedicalRecordsRepository.uploadReportPdf()   → Supabase Storage
  → supabase.functions.invoke('parse-lab-report') → Groq vision
  → MedicalRecordsRepository.saveLabReport()      → Drift (offline-first) + outbox
  → UI renders parsed results card
```

## ABHA Linking Flow (Phase 1 — Demo Safe)
```
User enters 14-digit ABHA number
  → Client-side format check (digits only)
  → MedicalRecordsRepository.linkAbhaNumber()
      → supabase.functions.invoke('validate-abha') → server-side check + DB upsert
      → Local Drift persist (offline fallback if network fails)
  → UI shows "ABHA Linked — pending ABDM sync"
```

## Deterministic vs. AI Split
- **Pure Dart (offline)**: ABHA format validation, medication CRUD, doctor grant CRUD
- **AI-backed (Edge Function, server-side)**: `parse-lab-report` uses Groq vision — zero AI keys on client

## Deviations from Spec
- ABHA: Phase 1 (format validation only). Live ABDM M1 token exchange is Phase 2 post-launch. Logged in `decisions.md ADR-004`.
