-- =============================================================================
-- FitKarma — Phase 0 Foundation Schema & RLS Policies
-- =============================================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. Profiles Table
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  full_name text,
  age integer check (age > 0 and age < 125),
  gender text check (gender in ('male', 'female', 'other')),
  height_cm numeric(5, 2),
  weight_kg numeric(5, 2),
  primary_goal text check (primary_goal in ('fat_loss', 'muscle_gain', 'maintenance', 'athletic_performance')),
  activity_level text check (activity_level in ('sedentary', 'light', 'moderate', 'active', 'very_active')),
  dosha_type text check (dosha_type in ('vata', 'pitta', 'kapha', 'dual', 'tridoshic')),
  is_onboarded boolean default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint unique_user_profile unique (user_id)
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = user_id);

create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = user_id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = user_id);

create policy "Users can delete own profile"
  on public.profiles for delete
  using (auth.uid() = user_id);


-- 2. Readiness Scores Table
create table if not exists public.readiness_scores (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  score integer not null check (score >= 0 and score <= 100),
  confidence_tier text not null check (confidence_tier in ('high', 'moderate', 'low')),
  hrv_rmssd numeric,
  resting_hr integer,
  sleep_quality_score numeric,
  muscle_soreness_index numeric,
  calculated_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.readiness_scores enable row level security;

create policy "Users can view own readiness scores"
  on public.readiness_scores for select
  using (auth.uid() = user_id);

create policy "Users can insert own readiness scores"
  on public.readiness_scores for insert
  with check (auth.uid() = user_id);

create policy "Users can update own readiness scores"
  on public.readiness_scores for update
  using (auth.uid() = user_id);


-- 3. Daily Intelligence Package (DIP) Cache Table
create table if not exists public.dip_cache (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null default current_date,
  payload_json jsonb not null,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint unique_user_dip_date unique (user_id, date)
);

alter table public.dip_cache enable row level security;

create policy "Users can view own DIP cache"
  on public.dip_cache for select
  using (auth.uid() = user_id);

create policy "Users can insert/update own DIP cache"
  on public.dip_cache for insert
  with check (auth.uid() = user_id);


-- 4. Entitlements Table (Monetisation & Tier Gating)
-- Non-negotiable: Service-role only write via RevenueCat webhook Edge Function
create table if not exists public.entitlements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  tier text not null check (tier in ('free', 'pro', 'elite', 'corporate')) default 'free',
  source text not null default 'revenuecat',
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint unique_user_entitlement unique (user_id)
);

alter table public.entitlements enable row level security;

-- Client can only SELECT entitlements; INSERT/UPDATE are service-role only (Edge Functions)
create policy "Users can view own entitlements"
  on public.entitlements for select
  using (auth.uid() = user_id);
