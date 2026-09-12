-- =============================================================================
-- FitKarma — Phase 7 Gamification Schema & RLS Policies
-- =============================================================================

-- 1. Karma Points Ledger Table (Append-only)
create table if not exists public.karma_points (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  points integer not null,
  action_type text not null,
  description text not null,
  earned_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.karma_points enable row level security;

create policy "Users can view own karma points"
  on public.karma_points for select
  using (auth.uid() = user_id);

create policy "Users can insert own karma points"
  on public.karma_points for insert
  with check (auth.uid() = user_id);


-- 2. Habit Streaks Table
create table if not exists public.habit_streaks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  habit_type text not null,
  current_streak integer not null default 1,
  longest_streak integer not null default 1,
  last_active_date timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint habit_streaks_user_habit_unique unique (user_id, habit_type)
);

alter table public.habit_streaks enable row level security;

create policy "Users can view own habit streaks"
  on public.habit_streaks for select
  using (auth.uid() = user_id);

create policy "Users can insert own habit streaks"
  on public.habit_streaks for insert
  with check (auth.uid() = user_id);

create policy "Users can update own habit streaks"
  on public.habit_streaks for update
  using (auth.uid() = user_id);
