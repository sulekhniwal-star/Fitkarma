-- =============================================================================
-- FitKarma — Phase 6 Workout System Schema & RLS Policies
-- =============================================================================

-- 1. Workout Sessions Table
create table if not exists public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'Strength Training',
  duration_seconds integer not null default 0,
  total_volume_kg numeric not null default 0,
  avg_rpe numeric not null default 8.0,
  started_at timestamptz not null default now(),
  completed_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.workout_sessions enable row level security;

create policy "Users can view own workout sessions"
  on public.workout_sessions for select
  using (auth.uid() = user_id);

create policy "Users can insert own workout sessions"
  on public.workout_sessions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own workout sessions"
  on public.workout_sessions for update
  using (auth.uid() = user_id);

create policy "Users can delete own workout sessions"
  on public.workout_sessions for delete
  using (auth.uid() = user_id);


-- 2. Workout Sets Table
create table if not exists public.workout_sets (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions(id) on delete cascade,
  exercise_id text not null,
  set_number integer not null,
  weight_kg numeric not null default 0,
  reps integer not null default 0,
  rpe integer not null default 8,
  is_completed boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.workout_sets enable row level security;

create policy "Users can view own workout sets"
  on public.workout_sets for select
  using (
    exists (
      select 1 from public.workout_sessions s
      where s.id = workout_sets.session_id
      and s.user_id = auth.uid()
    )
  );

create policy "Users can insert own workout sets"
  on public.workout_sets for insert
  with check (
    exists (
      select 1 from public.workout_sessions s
      where s.id = workout_sets.session_id
      and s.user_id = auth.uid()
    )
  );

create policy "Users can delete own workout sets"
  on public.workout_sets for delete
  using (
    exists (
      select 1 from public.workout_sessions s
      where s.id = workout_sets.session_id
      and s.user_id = auth.uid()
    )
  );
