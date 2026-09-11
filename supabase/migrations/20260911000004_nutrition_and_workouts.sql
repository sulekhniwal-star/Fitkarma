-- ============================================================================
-- FitKarma Postgres Migration 04: Nutrition, Indian Food DB & Workout Systems
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: food_items (Global Indian Food & Recipe Database)
-- Includes pgvector embedding for semantic food swap searches
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.food_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    hindi_name TEXT,
    regional_names JSONB DEFAULT '{}'::jsonb, -- e.g. {"ta": "தோசை", "te": "దోశ"}
    region TEXT DEFAULT 'pan_india', -- 'north_india', 'south_india', 'west_india', 'east_india', 'pan_india'
    category TEXT NOT NULL, -- 'grain_roti', 'dal_pulse', 'vegetable_curry', 'dairy', 'street_food', 'snack', 'beverage', 'sweet'
    serving_unit TEXT NOT NULL DEFAULT 'serving', -- 'roti', 'katori', 'piece', 'plate', 'glass', 'gram'
    serving_size_g NUMERIC(6,2) NOT NULL DEFAULT 100.0,
    calories NUMERIC(6,2) NOT NULL,
    protein_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    carbs_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    fats_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    fiber_g NUMERIC(5,2) DEFAULT 0.0,
    glycemic_index INTEGER CHECK (glycemic_index >= 0 AND glycemic_index <= 100),
    dosha_affinity TEXT CHECK (dosha_affinity IN ('vata_pacifying', 'pitta_pacifying', 'kapha_pacifying', 'tridoshic')),
    is_vegetarian BOOLEAN NOT NULL DEFAULT TRUE,
    is_vegan BOOLEAN NOT NULL DEFAULT FALSE,
    is_street_food BOOLEAN NOT NULL DEFAULT FALSE,
    micronutrients JSONB DEFAULT '{}'::jsonb, -- iron, calcium, zinc, b12
    healthy_swaps JSONB DEFAULT '[]'::jsonb,
    tags TEXT[] DEFAULT '{}',
    embedding vector(1536), -- Semantic vector for AI swap recommendations
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_food_items_category ON public.food_items(category);
CREATE INDEX idx_food_items_name ON public.food_items(name);

-- ----------------------------------------------------------------------------
-- Table: meals (User Logged Meals & Indian Macro Analysis)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.meals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'pre_workout', 'post_workout')),
    meal_title TEXT NOT NULL,
    logged_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    total_calories NUMERIC(6,2) NOT NULL,
    total_protein_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    total_carbs_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    total_fats_g NUMERIC(5,2) NOT NULL DEFAULT 0.0,
    total_fiber_g NUMERIC(5,2) DEFAULT 0.0,
    satiety_score NUMERIC(4,2) CHECK (satiety_score >= 0 AND satiety_score <= 100),
    glycemic_load NUMERIC(5,2),
    meal_quality_score INTEGER CHECK (meal_quality_score >= 0 AND meal_quality_score <= 100),
    photo_url TEXT,
    items JSONB NOT NULL DEFAULT '[]'::jsonb, -- array of {food_item_id, name, quantity, unit, calories, protein_g, carbs_g, fats_g}
    ai_feedback TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_meals_user_time ON public.meals(user_id, logged_at DESC);

-- ----------------------------------------------------------------------------
-- Table: water_logs (Hydration Tracking)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.water_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    volume_ml INTEGER NOT NULL CHECK (volume_ml > 0 AND volume_ml <= 5000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_water_logs_user_time ON public.water_logs(user_id, timestamp DESC);

-- ----------------------------------------------------------------------------
-- Table: fasting_sessions (Intermittent Fasting & Circadian Windows)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.fasting_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    protocol TEXT NOT NULL DEFAULT '16_8' CHECK (protocol IN ('12_12', '14_10', '16_8', '18_6', '20_4', 'omad', 'custom')),
    start_time TIMESTAMPTZ NOT NULL,
    target_end_time TIMESTAMPTZ NOT NULL,
    actual_end_time TIMESTAMPTZ,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'broken', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_fasting_sessions_user_time ON public.fasting_sessions(user_id, start_time DESC);

-- ----------------------------------------------------------------------------
-- Table: workout_logs (Training Sessions & Progressive Overload)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.workout_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    workout_type TEXT NOT NULL CHECK (workout_type IN ('hypertrophy', 'strength', 'hiit', 'yoga_asana', 'calisthenics', 'cardio', 'mobility', 'mixed')),
    start_time TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    end_time TIMESTAMPTZ,
    duration_minutes INTEGER,
    total_volume_kg NUMERIC(8,2) DEFAULT 0.0,
    average_rpe NUMERIC(3,1) CHECK (average_rpe >= 1 AND average_rpe <= 10),
    calories_burned INTEGER,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('in_progress', 'completed', 'discarded')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_workout_logs_user_time ON public.workout_logs(user_id, start_time DESC);

-- ----------------------------------------------------------------------------
-- Table: workout_sets (Exercise Reps, Weights & 1RM Calculations)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.workout_sets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_log_id UUID NOT NULL REFERENCES public.workout_logs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    exercise_name TEXT NOT NULL,
    exercise_category TEXT DEFAULT 'compound', -- compound, isolation, bodyweight, flexibility
    set_number INTEGER NOT NULL,
    weight_kg NUMERIC(6,2) NOT NULL DEFAULT 0.0,
    reps INTEGER NOT NULL CHECK (reps >= 0),
    rpe NUMERIC(3,1) CHECK (rpe >= 1 AND rpe <= 10),
    is_warmup BOOLEAN NOT NULL DEFAULT FALSE,
    one_rep_max_est NUMERIC(6,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_workout_sets_log_id ON public.workout_sets(workout_log_id);
CREATE INDEX idx_workout_sets_user_exercise ON public.workout_sets(user_id, exercise_name);

-- ----------------------------------------------------------------------------
-- Table: movement_trajectories (MediaPipe Pose Landmarks & Form Scores)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.movement_trajectories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_set_id UUID REFERENCES public.workout_sets(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    exercise_name TEXT NOT NULL,
    form_score INTEGER CHECK (form_score >= 0 AND form_score <= 100),
    joint_angles JSONB NOT NULL DEFAULT '{}'::jsonb, -- e.g. {"knee_angle": 88.5, "hip_angle": 92.1}
    fault_detected TEXT, -- 'knee_valgus', 'spinal_flexion', 'asymmetrical_load'
    rep_duration_ms INTEGER,
    velocity_m_s NUMERIC(4,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_movement_trajectories_user ON public.movement_trajectories(user_id);

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.food_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fasting_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movement_trajectories ENABLE ROW LEVEL SECURITY;

-- Food Items: Authenticated & Anonymous read access to global nutrition catalogue
CREATE POLICY "Public read for food items"
    ON public.food_items FOR SELECT USING (true);

-- User Private Data: Strict user isolation
CREATE POLICY "Users can manage own meals"
    ON public.meals FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own water logs"
    ON public.water_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own fasting sessions"
    ON public.fasting_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own workout logs"
    ON public.workout_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own workout sets"
    ON public.workout_sets FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own movement trajectories"
    ON public.movement_trajectories FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
