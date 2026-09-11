# FitKarma Supabase Backend & Database Architecture

This directory contains the complete Postgres database schema, Row Level Security (RLS) policies, DPDP Act 2023 Section 12 cascading deletion RPC, storage policies, materialized views, and seed datasets for **FitKarma (v2.2)**.

---

## Directory Structure

```
supabase/
├── config.toml                 # Local Supabase CLI emulator configuration
├── apply_all_migrations.sql    # 1-Click consolidated SQL script for Dashboard SQL Editor
├── seed.sql                    # Initial seed dataset (Indian foods, badges, communities)
├── README.md                   # Setup guide and reference documentation
└── migrations/
    ├── 20260911000001_initial_schema.sql
    ├── 20260911000002_core_profiles_and_onboarding.sql
    ├── 20260911000003_telemetry_and_health_os.sql
    ├── 20260911000004_nutrition_and_workouts.sql
    ├── 20260911000005_gamification_and_habits.sql
    ├── 20260911000006_social_and_community.sql
    ├── 20260911000007_monetisation_and_marketplace.sql
    ├── 20260911000008_clinical_india_layer.sql
    ├── 20260911000009_dpdp_compliance_and_rpcs.sql
    ├── 20260911000010_materialized_views_and_analytics.sql
    └── 20260911000011_storage_buckets_setup.sql
```

---

## How to Apply Migrations

### Option 1: Direct Execution in Supabase Dashboard (Recommended for quick deployment)
1. Log into your [Supabase Project Dashboard](https://supabase.com/dashboard).
2. Open the **SQL Editor** tab from the left sidebar.
3. Open or paste the contents of `supabase/apply_all_migrations.sql`.
4. Click **Run** to create all tables, indexes, triggers, and RLS policies.
5. (Optional) Run `supabase/seed.sql` to populate Indian recipe databases, badges, and default communities.

---

### Option 2: Using Supabase CLI

#### Local Development
```bash
# Start local Supabase container stack (Postgres, Studio, Auth, Storage, Inbucket)
npx supabase start

# Apply all migrations to local database
npx supabase db reset
```

#### Remote Deployment to Production / Staging
```bash
# Link to your Supabase project (find reference ID in Project Settings)
npx supabase link --project-ref <your-project-ref>

# Push migrations to remote database
npx supabase db push
```

---

## Key Backend Features

### 1. Row Level Security (RLS) Isolation
- Every personal health table (`meals`, `cgm_telemetry`, `wearable_samples`, `biomarkers`, `sleep_sessions`, etc.) is guarded by `auth.uid() = user_id`.
- The `entitlements` table is read-only for client SDKs; write operations are restricted to `service_role` (invoked via RevenueCat Webhook Edge Functions).

### 2. DPDP Act 2023 Section 12 Cascading Right-to-Erasure
- RPC function: `delete_user_data(target_user_id UUID, deletion_reason TEXT)`
- Purges all rows across 23+ user tables, cleans social squad associations, wipes private storage objects (`progress-photos`, `food-snaps`, `clinical-dossiers`), and writes an anonymized SHA-256 cryptographic audit receipt into `erasure_receipts`.

### 3. Realtime Feeds
Postgres Realtime Logical Replication is enabled on:
- `squad_members` (Live squad fitness progress)
- `discussion_threads` and `discussion_replies` (Sangha community discussions)
- `public_feed` (Sangha activity stream & kudos)

### 4. Vector Embeddings (`pgvector`)
- The `food_items` table contains an `embedding vector(1536)` column for AI semantic food swapping and recipe recommendations.
