-- =============================================================================
-- FitKarma — Phase 5 Smart Indian Nutrition Schema & RLS Policies
-- =============================================================================

-- 1. Recipes Catalog Table (500+ Indian Regional Foods & Dishes)
create table if not exists public.recipes (
  id text primary key,
  name text not null,
  name_hindi text not null,
  region text not null, -- 'north', 'south', 'west', 'east', 'panIndia'
  dietary_type text not null, -- 'vegetarian', 'eggetarian', 'nonVegetarian', 'vegan', 'jain'
  calories_kcal numeric not null,
  protein_grams numeric not null,
  carbs_grams numeric not null,
  fat_grams numeric not null,
  fiber_grams numeric not null,
  glycemic_index numeric not null,
  created_at timestamptz not null default now()
);

alter table public.recipes enable row level security;

-- Public read-only policy for all authenticated users
create policy "Authenticated users can read recipes"
  on public.recipes for select
  using (auth.role() = 'authenticated');


-- 2. User Logged Meals Table
create table if not exists public.meals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  meal_type text not null check (meal_type in ('breakfast', 'lunch', 'snack', 'dinner')),
  calories_kcal numeric not null,
  protein_grams numeric not null,
  carbs_grams numeric not null,
  fat_grams numeric not null,
  fiber_grams numeric not null,
  meal_quality_score integer not null default 75,
  vision_confidence numeric not null default 1.0,
  photo_url text,
  logged_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.meals enable row level security;

create policy "Users can view own meals"
  on public.meals for select
  using (auth.uid() = user_id);

create policy "Users can insert own meals"
  on public.meals for insert
  with check (auth.uid() = user_id);

create policy "Users can update own meals"
  on public.meals for update
  using (auth.uid() = user_id);

create policy "Users can delete own meals"
  on public.meals for delete
  using (auth.uid() = user_id);


-- 3. Grocery Price Matrix Table (Quick Commerce / Indian Market Price Index)
create table if not exists public.grocery_price_matrix (
  id uuid primary key default gen_random_uuid(),
  item_name text not null,
  category text not null,
  price_inr numeric not null,
  unit text not null,
  vendor text not null default 'blinkit',
  updated_at timestamptz not null default now()
);

alter table public.grocery_price_matrix enable row level security;

create policy "Authenticated users can read grocery price matrix"
  on public.grocery_price_matrix for select
  using (auth.role() = 'authenticated');
