-- =============================================================================
-- FitKarma — Phase 4 Health Tracking Schema & RLS Policies
-- =============================================================================

-- 1. Wearable Telemetry Samples (Time-series with unique constraint for idempotency)
create table if not exists public.wearable_samples (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source text not null, -- 'apple_watch', 'garmin', 'health_connect', 'healthkit', etc.
  metric text not null, -- 'steps', 'heart_rate', 'hrv_rmssd', 'active_calories'
  value numeric not null,
  unit text not null,
  timestamp timestamptz not null,
  created_at timestamptz not null default now(),
  constraint wearable_samples_unique_point unique (user_id, source, metric, timestamp)
);

alter table public.wearable_samples enable row level security;

create policy "Users can view own wearable samples"
  on public.wearable_samples for select
  using (auth.uid() = user_id);

create policy "Users can insert own wearable samples"
  on public.wearable_samples for insert
  with check (auth.uid() = user_id);

create policy "Users can delete own wearable samples"
  on public.wearable_samples for delete
  using (auth.uid() = user_id);


-- 2. Biomarkers Table (Blood Pressure, Glucose, HbA1c, Lipids)
create table if not exists public.biomarkers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source text not null default 'manual', -- 'manual', 'cgm', 'lab_report'
  type text not null, -- 'bloodPressure', 'fastingGlucose', 'postMealGlucose', 'hba1c', 'lipidProfile'
  primary_value numeric not null,
  secondary_value numeric,
  unit text not null,
  note text,
  measured_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.biomarkers enable row level security;

create policy "Users can view own biomarkers"
  on public.biomarkers for select
  using (auth.uid() = user_id);

create policy "Users can insert own biomarkers"
  on public.biomarkers for insert
  with check (auth.uid() = user_id);

create policy "Users can update own biomarkers"
  on public.biomarkers for update
  using (auth.uid() = user_id);

create policy "Users can delete own biomarkers"
  on public.biomarkers for delete
  using (auth.uid() = user_id);


-- 3. CGM Telemetry Table (Continuous Glucose Monitor readings)
create table if not exists public.cgm_telemetry (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  glucose_mg_dl numeric not null,
  trend_arrow text not null default 'flat', -- 'flat', 'rising_slow', 'rising_fast', 'falling_slow', 'falling_fast'
  associated_meal_id text,
  recorded_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint cgm_telemetry_unique_point unique (user_id, recorded_at)
);

alter table public.cgm_telemetry enable row level security;

create policy "Users can view own cgm telemetry"
  on public.cgm_telemetry for select
  using (auth.uid() = user_id);

create policy "Users can insert own cgm telemetry"
  on public.cgm_telemetry for insert
  with check (auth.uid() = user_id);

create policy "Users can delete own cgm telemetry"
  on public.cgm_telemetry for delete
  using (auth.uid() = user_id);
