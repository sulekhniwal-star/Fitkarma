-- ============================================================================
-- FitKarma — Master Supabase Backend Migration (v2.2)
-- India's Intelligent Health Operating System
-- Consolidated schema, RLS policies, DPDP right-to-erasure RPC, and Seed Data
-- ============================================================================

BEGIN;

-- ============================================================================
-- SECTION 1: EXTENSIONS & SHARED FUNCTIONS
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_authenticated()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (auth.role() = 'authenticated');
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.requesting_user_id()
RETURNS UUID AS $$
BEGIN
    RETURN auth.uid();
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ============================================================================
-- SECTION 2: PROFILES & ONBOARDING
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone_number TEXT,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    age INTEGER CHECK (age >= 10 AND age <= 120),
    gender TEXT CHECK (gender IN ('male', 'female', 'non_binary', 'prefer_not_to_say')),
    height_cm NUMERIC(5,2) CHECK (height_cm > 50 AND height_cm < 300),
    weight_kg NUMERIC(5,2) CHECK (weight_kg > 20 AND weight_kg < 500),
    activity_level TEXT DEFAULT 'moderate' CHECK (activity_level IN ('sedentary', 'lightly_active', 'moderate', 'very_active', 'extra_active')),
    primary_goal TEXT DEFAULT 'general_health' CHECK (primary_goal IN ('fat_loss', 'muscle_gain', 'longevity', 'pcos_management', 'metabolic_health', 'general_health')),
    fitness_blueprint TEXT DEFAULT 'ayurvedic_hybrid',
    target_calories INTEGER,
    target_protein_g NUMERIC(5,2),
    target_carbs_g NUMERIC(5,2),
    target_fats_g NUMERIC(5,2),
    target_water_ml INTEGER DEFAULT 3000,
    preferred_language TEXT DEFAULT 'en' CHECK (preferred_language IN ('en', 'hi', 'hinglish', 'ta', 'te')),
    timezone TEXT DEFAULT 'Asia/Kolkata',
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

DROP TRIGGER IF EXISTS set_profiles_updated_at ON public.profiles;
CREATE TRIGGER set_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.dosha_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    vata_score NUMERIC(5,2) NOT NULL DEFAULT 0.0 CHECK (vata_score >= 0 AND vata_score <= 100),
    pitta_score NUMERIC(5,2) NOT NULL DEFAULT 0.0 CHECK (pitta_score >= 0 AND pitta_score <= 100),
    kapha_score NUMERIC(5,2) NOT NULL DEFAULT 0.0 CHECK (kapha_score >= 0 AND kapha_score <= 100),
    dominant_dosha TEXT NOT NULL CHECK (dominant_dosha IN ('vata', 'pitta', 'kapha', 'vata_pitta', 'pitta_kapha', 'vata_kapha', 'tridosha')),
    secondary_dosha TEXT,
    assessment_answers JSONB DEFAULT '{}'::jsonb,
    evaluated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT dosha_scores_user_unique UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS public.cycle_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    phase TEXT NOT NULL CHECK (phase IN ('follicular', 'ovulatory', 'luteal', 'menstrual')),
    cycle_length_days INTEGER DEFAULT 28 CHECK (cycle_length_days >= 20 AND cycle_length_days <= 45),
    period_start_date DATE NOT NULL,
    estimated_ovulation_date DATE,
    pcos_flag BOOLEAN NOT NULL DEFAULT FALSE,
    symptoms TEXT[] DEFAULT '{}',
    energy_level INTEGER CHECK (energy_level >= 1 AND energy_level <= 10),
    notes TEXT,
    logged_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_cycle_tracking_user_date ON public.cycle_tracking(user_id, period_start_date DESC);

CREATE TABLE IF NOT EXISTS public.compliance_consents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    consent_version TEXT NOT NULL DEFAULT 'v2.2',
    dpdp_agreed BOOLEAN NOT NULL DEFAULT TRUE,
    medical_disclaimer_agreed BOOLEAN NOT NULL DEFAULT TRUE,
    terms_agreed BOOLEAN NOT NULL DEFAULT TRUE,
    ip_address TEXT,
    user_agent TEXT,
    agreed_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT compliance_consents_user_version_unique UNIQUE (user_id, consent_version)
);

CREATE TABLE IF NOT EXISTS public.push_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    device_token TEXT NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT push_tokens_user_token_unique UNIQUE (user_id, device_token)
);

DROP TRIGGER IF EXISTS set_push_tokens_updated_at ON public.push_tokens;
CREATE TRIGGER set_push_tokens_updated_at
    BEFORE UPDATE ON public.push_tokens
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================================
-- SECTION 3: TELEMETRY & HEALTH OS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.daily_intelligence (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    readiness_score NUMERIC(5,2) NOT NULL DEFAULT 70.0 CHECK (readiness_score >= 0 AND readiness_score <= 100),
    recovery_score NUMERIC(5,2) NOT NULL DEFAULT 70.0 CHECK (recovery_score >= 0 AND recovery_score <= 100),
    strain_target NUMERIC(5,2) DEFAULT 12.0,
    morning_briefing TEXT,
    dip_payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    deterministic_overrides JSONB DEFAULT '{}'::jsonb,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT daily_intelligence_user_date_unique UNIQUE (user_id, date)
);

CREATE INDEX IF NOT EXISTS idx_daily_intelligence_user_date ON public.daily_intelligence(user_id, date DESC);

CREATE TABLE IF NOT EXISTS public.biomarkers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    test_date DATE NOT NULL,
    hba1c NUMERIC(4,2),
    fasting_blood_sugar NUMERIC(5,2),
    total_cholesterol NUMERIC(5,2),
    hdl NUMERIC(5,2),
    ldl NUMERIC(5,2),
    triglycerides NUMERIC(5,2),
    crp NUMERIC(5,2),
    vitamin_d NUMERIC(5,2),
    vitamin_b12 NUMERIC(6,2),
    raw_metrics JSONB DEFAULT '{}'::jsonb,
    lab_source TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_biomarkers_user_date ON public.biomarkers(user_id, test_date DESC);

CREATE TABLE IF NOT EXISTS public.cgm_telemetry (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL,
    glucose_mg_dl NUMERIC(5,2) NOT NULL,
    trend_arrow TEXT DEFAULT 'flat' CHECK (trend_arrow IN ('double_up', 'single_up', 'forty_five_up', 'flat', 'forty_five_down', 'single_down', 'double_down')),
    rate_of_change NUMERIC(4,2),
    sensor_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_cgm_telemetry_user_time ON public.cgm_telemetry(user_id, timestamp DESC);

CREATE TABLE IF NOT EXISTS public.wearable_samples (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    source TEXT NOT NULL CHECK (source IN ('health_connect', 'healthkit', 'fitbit', 'garmin', 'whoop', 'oura', 'manual')),
    sample_type TEXT NOT NULL CHECK (sample_type IN ('steps', 'heart_rate', 'hrv_rmssd', 'spo2', 'active_calories', 'basal_calories', 'respiratory_rate', 'skin_temperature')),
    timestamp TIMESTAMPTZ NOT NULL,
    value NUMERIC(10,3) NOT NULL,
    unit TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT wearable_samples_unique UNIQUE (user_id, source, sample_type, timestamp)
);

CREATE INDEX IF NOT EXISTS idx_wearable_samples_user_type_time ON public.wearable_samples(user_id, sample_type, timestamp DESC);

CREATE TABLE IF NOT EXISTS public.blood_pressure_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    systolic INTEGER NOT NULL CHECK (systolic >= 50 AND systolic <= 260),
    diastolic INTEGER NOT NULL CHECK (diastolic >= 30 AND diastolic <= 160),
    pulse INTEGER CHECK (pulse >= 30 AND pulse <= 240),
    category TEXT CHECK (category IN ('normal', 'elevated', 'hypertension_stage_1', 'hypertension_stage_2', 'hypertensive_crisis')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_bp_logs_user_time ON public.blood_pressure_logs(user_id, timestamp DESC);

CREATE TABLE IF NOT EXISTS public.soreness_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    overall_soreness INTEGER NOT NULL CHECK (overall_soreness >= 0 AND overall_soreness <= 10),
    body_map JSONB NOT NULL DEFAULT '{}'::jsonb,
    recovery_recommendation TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT soreness_logs_user_date_unique UNIQUE (user_id, date)
);

CREATE TABLE IF NOT EXISTS public.sleep_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    sleep_date DATE NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    total_sleep_minutes INTEGER NOT NULL,
    deep_sleep_minutes INTEGER DEFAULT 0,
    rem_sleep_minutes INTEGER DEFAULT 0,
    light_sleep_minutes INTEGER DEFAULT 0,
    awake_minutes INTEGER DEFAULT 0,
    sleep_score INTEGER CHECK (sleep_score >= 0 AND sleep_score <= 100),
    sleep_debt_minutes INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT sleep_sessions_user_date_unique UNIQUE (user_id, sleep_date)
);

CREATE INDEX IF NOT EXISTS idx_sleep_sessions_user_date ON public.sleep_sessions(user_id, sleep_date DESC);

CREATE TABLE IF NOT EXISTS public.environmental_telemetry (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    city TEXT,
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    aqi INTEGER,
    pm2_5 NUMERIC(6,2),
    pm10 NUMERIC(6,2),
    uv_index NUMERIC(4,2),
    wet_bulb_temp_c NUMERIC(4,2),
    outdoor_recommendation TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_env_telemetry_user_time ON public.environmental_telemetry(user_id, timestamp DESC);

CREATE TABLE IF NOT EXISTS public.longevity_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    biological_age NUMERIC(4,1) NOT NULL,
    chronological_age INTEGER NOT NULL,
    longevity_score NUMERIC(5,2) NOT NULL CHECK (longevity_score >= 0 AND longevity_score <= 100),
    hallmarks_breakdown JSONB NOT NULL DEFAULT '{}'::jsonb,
    vo2_max_estimate NUMERIC(4,1),
    recommendations TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.body_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    logged_date DATE NOT NULL,
    weight_kg NUMERIC(5,2) NOT NULL,
    body_fat_pct NUMERIC(4,2),
    skeletal_muscle_mass_kg NUMERIC(5,2),
    visceral_fat_level INTEGER,
    waist_cm NUMERIC(5,2),
    hip_cm NUMERIC(5,2),
    bmr_kcal INTEGER,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_body_analytics_user_date ON public.body_analytics(user_id, logged_date DESC);

-- ============================================================================
-- SECTION 4: NUTRITION & WORKOUTS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.food_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    hindi_name TEXT,
    regional_names JSONB DEFAULT '{}'::jsonb,
    region TEXT DEFAULT 'pan_india',
    category TEXT NOT NULL,
    serving_unit TEXT NOT NULL DEFAULT 'serving',
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
    micronutrients JSONB DEFAULT '{}'::jsonb,
    healthy_swaps JSONB DEFAULT '[]'::jsonb,
    tags TEXT[] DEFAULT '{}',
    embedding vector(1536),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_food_items_category ON public.food_items(category);
CREATE INDEX IF NOT EXISTS idx_food_items_name ON public.food_items(name);

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
    items JSONB NOT NULL DEFAULT '[]'::jsonb,
    ai_feedback TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_meals_user_time ON public.meals(user_id, logged_at DESC);

CREATE TABLE IF NOT EXISTS public.water_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    volume_ml INTEGER NOT NULL CHECK (volume_ml > 0 AND volume_ml <= 5000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_water_logs_user_time ON public.water_logs(user_id, timestamp DESC);

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

CREATE INDEX IF NOT EXISTS idx_fasting_sessions_user_time ON public.fasting_sessions(user_id, start_time DESC);

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

CREATE INDEX IF NOT EXISTS idx_workout_logs_user_time ON public.workout_logs(user_id, start_time DESC);

CREATE TABLE IF NOT EXISTS public.workout_sets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_log_id UUID NOT NULL REFERENCES public.workout_logs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    exercise_name TEXT NOT NULL,
    exercise_category TEXT DEFAULT 'compound',
    set_number INTEGER NOT NULL,
    weight_kg NUMERIC(6,2) NOT NULL DEFAULT 0.0,
    reps INTEGER NOT NULL CHECK (reps >= 0),
    rpe NUMERIC(3,1) CHECK (rpe >= 1 AND rpe <= 10),
    is_warmup BOOLEAN NOT NULL DEFAULT FALSE,
    one_rep_max_est NUMERIC(6,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_workout_sets_log_id ON public.workout_sets(workout_log_id);
CREATE INDEX IF NOT EXISTS idx_workout_sets_user_exercise ON public.workout_sets(user_id, exercise_name);

CREATE TABLE IF NOT EXISTS public.movement_trajectories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_set_id UUID REFERENCES public.workout_sets(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    exercise_name TEXT NOT NULL,
    form_score INTEGER CHECK (form_score >= 0 AND form_score <= 100),
    joint_angles JSONB NOT NULL DEFAULT '{}'::jsonb,
    fault_detected TEXT,
    rep_duration_ms INTEGER,
    velocity_m_s NUMERIC(4,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ============================================================================
-- SECTION 5: GAMIFICATION, KARMA & HABITS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.habits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('nutrition', 'training', 'mindfulness', 'sleep', 'hydration', 'ayurveda')),
    cue TEXT,
    routine TEXT,
    reward TEXT,
    target_frequency_days INTEGER DEFAULT 7 CHECK (target_frequency_days >= 1 AND target_frequency_days <= 7),
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

DROP TRIGGER IF EXISTS set_habits_updated_at ON public.habits;
CREATE TRIGGER set_habits_updated_at
    BEFORE UPDATE ON public.habits
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.habit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    habit_id UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    completed_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT habit_logs_unique UNIQUE (habit_id, completed_date)
);

CREATE INDEX IF NOT EXISTS idx_habit_logs_user_date ON public.habit_logs(user_id, completed_date DESC);

CREATE TABLE IF NOT EXISTS public.badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    badge_key TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    hindi_name TEXT,
    description TEXT NOT NULL,
    icon_name TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('streak', 'readiness', 'nutrition', 'strength', 'ayurveda', 'community')),
    tier TEXT NOT NULL DEFAULT 'bronze' CHECK (tier IN ('bronze', 'silver', 'gold', 'platinum', 'diamond')),
    karma_reward INTEGER NOT NULL DEFAULT 50,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    metadata JSONB DEFAULT '{}'::jsonb,
    CONSTRAINT user_badges_user_badge_unique UNIQUE (user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS public.karma_points (
    user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    balance INTEGER NOT NULL DEFAULT 0,
    lifetime_earned INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tier_status TEXT NOT NULL DEFAULT 'sadhaka' CHECK (tier_status IN ('sadhaka', 'abhyasi', 'yogi', 'acharya', 'guru')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.karma_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('workout_completed', 'habit_streak', 'meal_logged', 'cgm_in_range', 'badge_unlocked', 'reward_redeemed', 'bonus', 'penalty')),
    idempotency_key TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT karma_tx_idempotency_unique UNIQUE (user_id, idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_karma_tx_user ON public.karma_transactions(user_id, created_at DESC);

CREATE OR REPLACE FUNCTION public.apply_karma_transaction()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.karma_points (user_id, balance, lifetime_earned, level, tier_status, updated_at)
    VALUES (
        NEW.user_id,
        GREATEST(0, NEW.amount),
        GREATEST(0, NEW.amount),
        1,
        'sadhaka',
        TIMEZONE('utc'::text, NOW())
    )
    ON CONFLICT (user_id) DO UPDATE SET
        balance = GREATEST(0, public.karma_points.balance + NEW.amount),
        lifetime_earned = CASE 
            WHEN NEW.amount > 0 THEN public.karma_points.lifetime_earned + NEW.amount 
            ELSE public.karma_points.lifetime_earned 
        END,
        level = 1 + ((CASE WHEN NEW.amount > 0 THEN public.karma_points.lifetime_earned + NEW.amount ELSE public.karma_points.lifetime_earned END) / 500),
        tier_status = CASE 
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 10000 THEN 'guru'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 5000 THEN 'acharya'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 2000 THEN 'yogi'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 500 THEN 'abhyasi'
            ELSE 'sadhaka'
        END,
        updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_karma_transaction_insert ON public.karma_transactions;
CREATE TRIGGER on_karma_transaction_insert
    AFTER INSERT ON public.karma_transactions
    FOR EACH ROW EXECUTE FUNCTION public.apply_karma_transaction();

CREATE TABLE IF NOT EXISTS public.transformation_milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    milestone_type TEXT NOT NULL CHECK (milestone_type IN ('weight_lost', 'strength_pr', 'streak_record', 'biological_age_reversal', 'habit_identity')),
    title TEXT NOT NULL,
    description TEXT,
    achieved_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    metric_snapshot JSONB DEFAULT '{}'::jsonb,
    photo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ============================================================================
-- SECTION 6: SOCIAL, SQUADS, CLUBS & COMMUNITIES
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    avatar_url TEXT,
    weekly_target_steps INTEGER DEFAULT 70000,
    weekly_target_workouts INTEGER DEFAULT 5,
    max_members INTEGER DEFAULT 10 CHECK (max_members >= 2 AND max_members <= 50),
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

DROP TRIGGER IF EXISTS set_squads_updated_at ON public.squads;
CREATE TRIGGER set_squads_updated_at
    BEFORE UPDATE ON public.squads
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.squad_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    squad_id UUID NOT NULL REFERENCES public.squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('leader', 'admin', 'member')),
    weekly_step_contribution INTEGER DEFAULT 0,
    weekly_workout_contribution INTEGER DEFAULT 0,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT squad_members_unique UNIQUE (squad_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_squad_members_squad ON public.squad_members(squad_id);
CREATE INDEX IF NOT EXISTS idx_squad_members_user ON public.squad_members(user_id);

CREATE TABLE IF NOT EXISTS public.clubs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    locality TEXT NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    radius_km NUMERIC(4,1) DEFAULT 10.0,
    member_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.club_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    club_id UUID NOT NULL REFERENCES public.clubs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT club_members_unique UNIQUE (club_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.communities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('pcos', 'hypertrophy', 'ayurveda_lifestyle', 'plant_based', 'running', 'longevity', 'diabetes_cgm')),
    member_count INTEGER DEFAULT 0,
    icon_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.discussion_threads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES public.communities(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    upvotes_count INTEGER DEFAULT 0,
    replies_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

DROP TRIGGER IF EXISTS set_discussion_threads_updated_at ON public.discussion_threads;
CREATE TRIGGER set_discussion_threads_updated_at
    BEFORE UPDATE ON public.discussion_threads
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.discussion_replies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    thread_id UUID NOT NULL REFERENCES public.discussion_threads(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    parent_reply_id UUID REFERENCES public.discussion_replies(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.public_feed (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL CHECK (activity_type IN ('workout_milestone', 'badge_earned', 'cgm_personal_best', 'streak_achievement', 'recipe_share')),
    title TEXT NOT NULL,
    description TEXT,
    metrics_snapshot JSONB DEFAULT '{}'::jsonb,
    kudos_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX IF NOT EXISTS idx_public_feed_time ON public.public_feed(created_at DESC);

-- ============================================================================
-- SECTION 7: MONETISATION & MARKETPLACE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.entitlements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    tier TEXT NOT NULL DEFAULT 'free' CHECK (tier IN ('free', 'pro', 'elite')),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'canceled', 'pastDue', 'expired')),
    expires_at TIMESTAMPTZ,
    will_renew BOOLEAN NOT NULL DEFAULT FALSE,
    original_transaction_id TEXT,
    server_verification_hash TEXT,
    raw_event JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT entitlements_user_unique UNIQUE (user_id)
);

DROP TRIGGER IF EXISTS set_entitlements_updated_at ON public.entitlements;
CREATE TRIGGER set_entitlements_updated_at
    BEFORE UPDATE ON public.entitlements
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.marketplace_listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('workout_blueprint', 'ayurvedic_meal_plan', 'pcos_reversal', 'cgm_optimization', 'posture_mastery')),
    price_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    required_tier TEXT DEFAULT 'free' CHECK (required_tier IN ('free', 'pro', 'elite')),
    banner_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.affiliate_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    referral_code TEXT NOT NULL UNIQUE,
    commission_rate_pct NUMERIC(4,2) NOT NULL DEFAULT 20.0,
    total_earned_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    pending_balance_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    upi_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT affiliate_user_unique UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS public.referral_commissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    affiliate_id UUID NOT NULL REFERENCES public.affiliate_profiles(id) ON DELETE CASCADE,
    referred_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    subscription_tier TEXT NOT NULL,
    amount_inr NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'refunded')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.payouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    affiliate_id UUID NOT NULL REFERENCES public.affiliate_profiles(id) ON DELETE CASCADE,
    amount_inr NUMERIC(10,2) NOT NULL,
    payout_method TEXT NOT NULL DEFAULT 'upi',
    payout_details JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'processing' CHECK (status IN ('processing', 'completed', 'failed')),
    transaction_ref TEXT,
    processed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ============================================================================
-- SECTION 8: CLINICAL, INDIA LAYER & COMPLIANCE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.doctor_access_grants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    doctor_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    doctor_email TEXT NOT NULL,
    access_token TEXT NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(24), 'hex'),
    access_level TEXT NOT NULL DEFAULT 'read_dossier' CHECK (access_level IN ('read_dossier', 'full_telemetry', 'cgm_stream')),
    valid_until TIMESTAMPTZ NOT NULL,
    is_revoked BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.abha_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    abha_number TEXT NOT NULL UNIQUE,
    abha_address TEXT NOT NULL UNIQUE,
    abdm_token_metadata JSONB DEFAULT '{}'::jsonb,
    fhir_sync_status TEXT NOT NULL DEFAULT 'synced' CHECK (fhir_sync_status IN ('pending', 'synced', 'error', 'revoked')),
    last_synced_at TIMESTAMPTZ,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT abha_records_user_unique UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS public.voice_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    audio_duration_ms INTEGER,
    detected_language TEXT NOT NULL DEFAULT 'hi' CHECK (detected_language IN ('hi', 'hinglish', 'en', 'ta', 'te')),
    raw_transcription TEXT NOT NULL,
    extracted_entities JSONB NOT NULL DEFAULT '{}'::jsonb,
    intent TEXT NOT NULL DEFAULT 'log_meal' CHECK (intent IN ('log_meal', 'log_workout', 'ask_coach', 'log_symptom')),
    audio_file_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.whatsapp_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    phone_number TEXT NOT NULL,
    whatsapp_message_id TEXT NOT NULL,
    direction TEXT NOT NULL CHECK (direction IN ('inbound', 'outbound')),
    message_text TEXT NOT NULL,
    parsed_payload JSONB DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'processed' CHECK (status IN ('received', 'processed', 'failed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TABLE IF NOT EXISTS public.corporate_enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    corporate_code TEXT NOT NULL,
    company_name TEXT NOT NULL,
    employee_id TEXT NOT NULL,
    insurance_rebate_eligible BOOLEAN NOT NULL DEFAULT TRUE,
    rebate_percentage NUMERIC(4,2) DEFAULT 20.0,
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT corporate_enrollments_user_unique UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS public.grocery_carts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    vendor TEXT NOT NULL CHECK (vendor IN ('blinkit', 'zepto', 'swiggy_instamart', 'bigbasket', 'amazon_fresh', 'local_kirana_whatsapp')),
    items JSONB NOT NULL DEFAULT '[]'::jsonb,
    total_price_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    checkout_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ============================================================================
-- SECTION 9: DPDP RIGHT-TO-ERASURE RPC & RECEIPT LOGS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.erasure_receipts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id_hash TEXT NOT NULL,
    reason TEXT NOT NULL DEFAULT 'USER_REQUESTED_ERASURE',
    tables_purged JSONB NOT NULL DEFAULT '[]'::jsonb,
    cross_references_cleaned JSONB NOT NULL DEFAULT '[]'::jsonb,
    storage_objects_flagged INTEGER NOT NULL DEFAULT 0,
    cryptographic_signature TEXT NOT NULL,
    executed_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    status TEXT NOT NULL DEFAULT 'COMPLETED'
);

CREATE INDEX IF NOT EXISTS idx_erasure_receipts_hash ON public.erasure_receipts(user_id_hash);

CREATE OR REPLACE FUNCTION public.delete_user_data(
    target_user_id UUID,
    deletion_reason TEXT DEFAULT 'USER_REQUESTED_ERASURE'
)
RETURNS JSONB AS $$
DECLARE
    user_hash TEXT;
    signature_payload TEXT;
    purged_list JSONB := '[]'::jsonb;
    cross_ref_list JSONB := '[]'::jsonb;
    result JSONB;
BEGIN
    IF auth.uid() IS NOT NULL AND auth.uid() <> target_user_id AND auth.role() <> 'service_role' THEN
        RAISE EXCEPTION 'Unauthorized: Cannot execute right-to-erasure for another user.';
    END IF;

    user_hash := encode(digest(target_user_id::text, 'sha256'), 'hex');

    DELETE FROM public.squads 
    WHERE creator_id = target_user_id 
      AND id NOT IN (
          SELECT squad_id FROM public.squad_members 
          WHERE user_id <> target_user_id
      );
    cross_ref_list := cross_ref_list || jsonb_build_array('empty_created_squads_purged');

    UPDATE public.squads s
    SET creator_id = sm.user_id
    FROM (
        SELECT DISTINCT ON (squad_id) squad_id, user_id 
        FROM public.squad_members 
        WHERE user_id <> target_user_id 
        ORDER BY squad_id, joined_at ASC
    ) sm
    WHERE s.id = sm.squad_id AND s.creator_id = target_user_id;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'storage' AND table_name = 'objects') THEN
        DELETE FROM storage.objects 
        WHERE bucket_id IN ('progress-photos', 'food-snaps', 'clinical-dossiers')
          AND (path_tokens[1] = target_user_id::text OR owner = target_user_id);
        cross_ref_list := cross_ref_list || jsonb_build_array('storage_objects_purged');
    END IF;

    DELETE FROM public.profiles WHERE id = target_user_id;
    purged_list := jsonb_build_array(
        'profiles', 'dosha_scores', 'cycle_tracking', 'compliance_consents',
        'push_tokens', 'daily_intelligence', 'biomarkers', 'cgm_telemetry',
        'wearable_samples', 'blood_pressure_logs', 'soreness_logs', 'sleep_sessions',
        'environmental_telemetry', 'longevity_reports', 'body_analytics', 'meals',
        'water_logs', 'fasting_sessions', 'workout_logs', 'workout_sets',
        'movement_trajectories', 'habits', 'habit_logs', 'user_badges',
        'karma_points', 'karma_transactions', 'transformation_milestones',
        'entitlements', 'affiliate_profiles', 'doctor_access_grants',
        'abha_records', 'voice_logs', 'whatsapp_conversations',
        'corporate_enrollments', 'grocery_carts'
    );

    signature_payload := encode(digest(user_hash || ':' || deletion_reason || ':' || NOW()::text, 'sha256'), 'hex');

    INSERT INTO public.erasure_receipts (
        user_id_hash,
        reason,
        tables_purged,
        cross_references_cleaned,
        cryptographic_signature,
        status
    ) VALUES (
        user_hash,
        deletion_reason,
        purged_list,
        cross_ref_list,
        signature_payload,
        'COMPLETED'
    );

    result := jsonb_build_object(
        'status', 'COMPLETED',
        'user_id_hash', user_hash,
        'signature', signature_payload,
        'executed_at', NOW()
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- SECTION 10: MATERIALIZED VIEWS & BENCHMARKS
-- ============================================================================
CREATE MATERIALIZED VIEW IF NOT EXISTS public.mv_weekly_leaderboards AS
SELECT 
    p.id AS user_id,
    p.full_name,
    p.avatar_url,
    p.preferred_language,
    kp.level,
    kp.tier_status,
    COALESCE(SUM(kt.amount) FILTER (WHERE kt.created_at >= (NOW() - INTERVAL '7 days')), 0)::INTEGER AS weekly_karma_earned,
    kp.balance AS total_karma_balance,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(kt.amount) FILTER (WHERE kt.created_at >= (NOW() - INTERVAL '7 days')), 0) DESC) AS rank
FROM public.profiles p
JOIN public.karma_points kp ON kp.user_id = p.id
LEFT JOIN public.karma_transactions kt ON kt.user_id = p.id AND kt.amount > 0
GROUP BY p.id, p.full_name, p.avatar_url, p.preferred_language, kp.level, kp.tier_status, kp.balance;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_weekly_leaderboards_user ON public.mv_weekly_leaderboards(user_id);

CREATE MATERIALIZED VIEW IF NOT EXISTS public.mv_cohort_benchmarks AS
SELECT 
    CASE 
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN p.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_bracket,
    p.gender,
    COALESCE(ds.dominant_dosha, 'tridosha') AS dominant_dosha,
    COUNT(DISTINCT p.id)::INTEGER AS sample_size,
    ROUND(AVG(di.readiness_score), 2) AS avg_readiness_score,
    ROUND(AVG(di.recovery_score), 2) AS avg_recovery_score,
    ROUND(AVG(ss.total_sleep_minutes), 0) AS avg_sleep_minutes,
    ROUND(AVG(lr.vo2_max_estimate), 1) AS avg_vo2_max,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY di.readiness_score) AS median_readiness,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY di.readiness_score) AS p90_readiness
FROM public.profiles p
LEFT JOIN public.dosha_scores ds ON ds.user_id = p.id
LEFT JOIN public.daily_intelligence di ON di.user_id = p.id AND di.date >= (CURRENT_DATE - INTERVAL '14 days')
LEFT JOIN public.sleep_sessions ss ON ss.user_id = p.id AND ss.sleep_date >= (CURRENT_DATE - INTERVAL '14 days')
LEFT JOIN public.longevity_reports lr ON lr.user_id = p.id
WHERE p.age IS NOT NULL AND p.gender IS NOT NULL
GROUP BY 
    CASE 
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN p.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END,
    p.gender,
    COALESCE(ds.dominant_dosha, 'tridosha');

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_cohort_benchmarks_group ON public.mv_cohort_benchmarks(age_bracket, gender, dominant_dosha);

CREATE OR REPLACE FUNCTION public.refresh_leaderboards()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_weekly_leaderboards;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.refresh_cohort_benchmarks()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_cohort_benchmarks;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT SELECT ON public.mv_weekly_leaderboards TO authenticated, anon;
GRANT SELECT ON public.mv_cohort_benchmarks TO authenticated, anon;

-- ============================================================================
-- SECTION 11: ROW LEVEL SECURITY (RLS) ENABLEMENT & POLICIES
-- ============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dosha_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cycle_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.compliance_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_intelligence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.biomarkers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cgm_telemetry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wearable_samples ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blood_pressure_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.soreness_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sleep_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.environmental_telemetry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.longevity_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fasting_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movement_trajectories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.karma_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.karma_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transformation_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.club_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.public_feed ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entitlements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketplace_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.affiliate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.referral_commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctor_access_grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.abha_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.voice_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.whatsapp_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.corporate_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grocery_carts ENABLE ROW LEVEL SECURITY;

-- Policies (Drop existing if needed and recreate cleanly)
DO $$
BEGIN
    -- Profiles
    DROP POLICY IF EXISTS "Users can read own profile" ON public.profiles;
    CREATE POLICY "Users can read own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
    DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
    CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
    DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
    CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
    DROP POLICY IF EXISTS "Users can delete own profile" ON public.profiles;
    CREATE POLICY "Users can delete own profile" ON public.profiles FOR DELETE USING (auth.uid() = id);

    -- Telemetry & Health OS
    DROP POLICY IF EXISTS "Users can manage own dosha scores" ON public.dosha_scores;
    CREATE POLICY "Users can manage own dosha scores" ON public.dosha_scores FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own cycle tracking" ON public.cycle_tracking;
    CREATE POLICY "Users can manage own cycle tracking" ON public.cycle_tracking FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own compliance consents" ON public.compliance_consents;
    CREATE POLICY "Users can manage own compliance consents" ON public.compliance_consents FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own push tokens" ON public.push_tokens;
    CREATE POLICY "Users can manage own push tokens" ON public.push_tokens FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own daily intelligence" ON public.daily_intelligence;
    CREATE POLICY "Users can manage own daily intelligence" ON public.daily_intelligence FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own biomarkers" ON public.biomarkers;
    CREATE POLICY "Users can manage own biomarkers" ON public.biomarkers FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own cgm telemetry" ON public.cgm_telemetry;
    CREATE POLICY "Users can manage own cgm telemetry" ON public.cgm_telemetry FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own wearable samples" ON public.wearable_samples;
    CREATE POLICY "Users can manage own wearable samples" ON public.wearable_samples FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own blood pressure logs" ON public.blood_pressure_logs;
    CREATE POLICY "Users can manage own blood pressure logs" ON public.blood_pressure_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own soreness logs" ON public.soreness_logs;
    CREATE POLICY "Users can manage own soreness logs" ON public.soreness_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own sleep sessions" ON public.sleep_sessions;
    CREATE POLICY "Users can manage own sleep sessions" ON public.sleep_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own environmental telemetry" ON public.environmental_telemetry;
    CREATE POLICY "Users can manage own environmental telemetry" ON public.environmental_telemetry FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own longevity reports" ON public.longevity_reports;
    CREATE POLICY "Users can manage own longevity reports" ON public.longevity_reports FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own body analytics" ON public.body_analytics;
    CREATE POLICY "Users can manage own body analytics" ON public.body_analytics FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    -- Nutrition & Workouts
    DROP POLICY IF EXISTS "Public read for food items" ON public.food_items;
    CREATE POLICY "Public read for food items" ON public.food_items FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Users can manage own meals" ON public.meals;
    CREATE POLICY "Users can manage own meals" ON public.meals FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own water logs" ON public.water_logs;
    CREATE POLICY "Users can manage own water logs" ON public.water_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own fasting sessions" ON public.fasting_sessions;
    CREATE POLICY "Users can manage own fasting sessions" ON public.fasting_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own workout logs" ON public.workout_logs;
    CREATE POLICY "Users can manage own workout logs" ON public.workout_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own workout sets" ON public.workout_sets;
    CREATE POLICY "Users can manage own workout sets" ON public.workout_sets FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own movement trajectories" ON public.movement_trajectories;
    CREATE POLICY "Users can manage own movement trajectories" ON public.movement_trajectories FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    -- Gamification
    DROP POLICY IF EXISTS "Public read for badges" ON public.badges;
    CREATE POLICY "Public read for badges" ON public.badges FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Users can manage own habits" ON public.habits;
    CREATE POLICY "Users can manage own habits" ON public.habits FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own habit logs" ON public.habit_logs;
    CREATE POLICY "Users can manage own habit logs" ON public.habit_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can read/insert own badges" ON public.user_badges;
    CREATE POLICY "Users can read/insert own badges" ON public.user_badges FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can read own karma points" ON public.karma_points;
    CREATE POLICY "Users can read own karma points" ON public.karma_points FOR SELECT USING (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can insert/read own karma transactions" ON public.karma_transactions;
    CREATE POLICY "Users can insert/read own karma transactions" ON public.karma_transactions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own transformation milestones" ON public.transformation_milestones;
    CREATE POLICY "Users can manage own transformation milestones" ON public.transformation_milestones FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    -- Social
    DROP POLICY IF EXISTS "Authenticated users can view squads" ON public.squads;
    CREATE POLICY "Authenticated users can view squads" ON public.squads FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Authenticated users can create squads" ON public.squads;
    CREATE POLICY "Authenticated users can create squads" ON public.squads FOR INSERT WITH CHECK (auth.uid() = creator_id);

    DROP POLICY IF EXISTS "Creators can update/delete own squads" ON public.squads;
    CREATE POLICY "Creators can update/delete own squads" ON public.squads FOR ALL USING (auth.uid() = creator_id);

    DROP POLICY IF EXISTS "Authenticated users can view squad members" ON public.squad_members;
    CREATE POLICY "Authenticated users can view squad members" ON public.squad_members FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Users can manage own squad membership" ON public.squad_members;
    CREATE POLICY "Users can manage own squad membership" ON public.squad_members FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Authenticated users can view clubs" ON public.clubs;
    CREATE POLICY "Authenticated users can view clubs" ON public.clubs FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Users can manage club membership" ON public.club_members;
    CREATE POLICY "Users can manage club membership" ON public.club_members FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Public read for communities" ON public.communities;
    CREATE POLICY "Public read for communities" ON public.communities FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Authenticated users can view threads" ON public.discussion_threads;
    CREATE POLICY "Authenticated users can view threads" ON public.discussion_threads FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Users can create threads" ON public.discussion_threads;
    CREATE POLICY "Users can create threads" ON public.discussion_threads FOR INSERT WITH CHECK (auth.uid() = author_id);

    DROP POLICY IF EXISTS "Authors can update/delete threads" ON public.discussion_threads;
    CREATE POLICY "Authors can update/delete threads" ON public.discussion_threads FOR UPDATE USING (auth.uid() = author_id);

    DROP POLICY IF EXISTS "Authenticated users can view replies" ON public.discussion_replies;
    CREATE POLICY "Authenticated users can view replies" ON public.discussion_replies FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Users can create replies" ON public.discussion_replies;
    CREATE POLICY "Users can create replies" ON public.discussion_replies FOR INSERT WITH CHECK (auth.uid() = author_id);

    DROP POLICY IF EXISTS "Authenticated users can view public feed" ON public.public_feed;
    CREATE POLICY "Authenticated users can view public feed" ON public.public_feed FOR SELECT USING (auth.role() = 'authenticated');

    DROP POLICY IF EXISTS "Users can create public feed items" ON public.public_feed;
    CREATE POLICY "Users can create public feed items" ON public.public_feed FOR INSERT WITH CHECK (auth.uid() = author_id);

    DROP POLICY IF EXISTS "Authors can manage own public feed items" ON public.public_feed;
    CREATE POLICY "Authors can manage own public feed items" ON public.public_feed FOR ALL USING (auth.uid() = author_id);

    -- Monetisation
    DROP POLICY IF EXISTS "Users can read own entitlements" ON public.entitlements;
    CREATE POLICY "Users can read own entitlements" ON public.entitlements FOR SELECT USING (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Public read for active marketplace listings" ON public.marketplace_listings;
    CREATE POLICY "Public read for active marketplace listings" ON public.marketplace_listings FOR SELECT USING (is_active = true OR auth.uid() = creator_id);

    DROP POLICY IF EXISTS "Creators can manage own listings" ON public.marketplace_listings;
    CREATE POLICY "Creators can manage own listings" ON public.marketplace_listings FOR ALL USING (auth.uid() = creator_id) WITH CHECK (auth.uid() = creator_id);

    DROP POLICY IF EXISTS "Users can view and manage own affiliate profile" ON public.affiliate_profiles;
    CREATE POLICY "Users can view and manage own affiliate profile" ON public.affiliate_profiles FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    -- Clinical & India Layer
    DROP POLICY IF EXISTS "Patients can manage own doctor grants" ON public.doctor_access_grants;
    CREATE POLICY "Patients can manage own doctor grants" ON public.doctor_access_grants FOR ALL USING (auth.uid() = patient_id) WITH CHECK (auth.uid() = patient_id);

    DROP POLICY IF EXISTS "Doctors can view grants assigned to them" ON public.doctor_access_grants;
    CREATE POLICY "Doctors can view grants assigned to them" ON public.doctor_access_grants FOR SELECT USING (auth.uid() = doctor_id);

    DROP POLICY IF EXISTS "Users can manage own ABHA records" ON public.abha_records;
    CREATE POLICY "Users can manage own ABHA records" ON public.abha_records FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own voice logs" ON public.voice_logs;
    CREATE POLICY "Users can manage own voice logs" ON public.voice_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own WhatsApp conversations" ON public.whatsapp_conversations;
    CREATE POLICY "Users can manage own WhatsApp conversations" ON public.whatsapp_conversations FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own corporate enrollments" ON public.corporate_enrollments;
    CREATE POLICY "Users can manage own corporate enrollments" ON public.corporate_enrollments FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can manage own grocery carts" ON public.grocery_carts;
    CREATE POLICY "Users can manage own grocery carts" ON public.grocery_carts FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
END $$;

COMMIT;
