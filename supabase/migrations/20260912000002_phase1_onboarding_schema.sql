-- =============================================================================
-- FitKarma — Phase 1 Onboarding Schema & RLS Policies
-- =============================================================================

-- 1. Dosha Scores Table (Ayurvedic Assessment)
create table if not exists public.dosha_scores (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vata_score integer not null check (vata_score >= 0),
  pitta_score integer not null check (pitta_score >= 0),
  kapha_score integer not null check (kapha_score >= 0),
  dominant_dosha text not null check (dominant_dosha in ('vata', 'pitta', 'kapha', 'dual', 'tridoshic')),
  assessed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.dosha_scores enable row level security;

create policy "Users can view own dosha scores"
  on public.dosha_scores for select
  using (auth.uid() = user_id);

create policy "Users can insert own dosha scores"
  on public.dosha_scores for insert
  with check (auth.uid() = user_id);

create policy "Users can update own dosha scores"
  on public.dosha_scores for update
  using (auth.uid() = user_id);


-- 2. Cycle Tracking Table (Women's Advanced Health & PCOS)
create table if not exists public.cycle_tracking (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cycle_length_days integer not null check (cycle_length_days >= 20 and cycle_length_days <= 45),
  current_cycle_day integer not null check (current_cycle_day >= 1 and current_cycle_day <= 45),
  current_phase text not null check (current_phase in ('menstrual', 'follicular', 'ovulatory', 'luteal')),
  has_pcos boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint unique_user_cycle unique (user_id)
);

alter table public.cycle_tracking enable row level security;

create policy "Users can view own cycle tracking"
  on public.cycle_tracking for select
  using (auth.uid() = user_id);

create policy "Users can insert own cycle tracking"
  on public.cycle_tracking for insert
  with check (auth.uid() = user_id);

create policy "Users can update own cycle tracking"
  on public.cycle_tracking for update
  using (auth.uid() = user_id);
