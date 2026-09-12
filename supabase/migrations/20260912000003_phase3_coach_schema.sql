-- =============================================================================
-- FitKarma — Phase 3 AI Adaptive Coach Schema & RLS Policies
-- =============================================================================

-- 1. Coach Sessions Table
create table if not exists public.coach_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Daily Coaching Session',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.coach_sessions enable row level security;

create policy "Users can view own coach sessions"
  on public.coach_sessions for select
  using (auth.uid() = user_id);

create policy "Users can insert own coach sessions"
  on public.coach_sessions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own coach sessions"
  on public.coach_sessions for update
  using (auth.uid() = user_id);

create policy "Users can delete own coach sessions"
  on public.coach_sessions for delete
  using (auth.uid() = user_id);


-- 2. Coach Messages Table
create table if not exists public.coach_messages (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.coach_sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  sender text not null check (sender in ('user', 'coach', 'system')),
  content text not null,
  model_used text,
  created_at timestamptz not null default now()
);

alter table public.coach_messages enable row level security;

create policy "Users can view own coach messages"
  on public.coach_messages for select
  using (auth.uid() = user_id);

create policy "Users can insert own coach messages"
  on public.coach_messages for insert
  with check (auth.uid() = user_id);
