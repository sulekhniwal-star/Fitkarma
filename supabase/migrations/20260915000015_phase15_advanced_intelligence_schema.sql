-- Phase 15: Advanced Intelligence Schema (Adaptive Metabolism & Longevity Scores)

-- 1. Metabolic Profiles Table
CREATE TABLE IF NOT EXISTS public.metabolic_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    baseline_bmr NUMERIC(6, 1) NOT NULL,
    estimated_tdee NUMERIC(6, 1) NOT NULL,
    current_calorie_target NUMERIC(6, 1) NOT NULL,
    adaptation_factor NUMERIC(4, 3) NOT NULL,
    plateau_status TEXT NOT NULL CHECK (plateau_status IN ('progressing', 'stalling', 'plateaued')),
    weeks_stalled INTEGER NOT NULL DEFAULT 0,
    strategy TEXT NOT NULL,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.metabolic_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_metabolic_profiles" ON public.metabolic_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "owner_insert_metabolic_profiles" ON public.metabolic_profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "owner_update_metabolic_profiles" ON public.metabolic_profiles
    FOR UPDATE USING (auth.uid() = user_id);


-- 2. Longevity Assessments Table
CREATE TABLE IF NOT EXISTS public.longevity_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    overall_score INTEGER NOT NULL CHECK (overall_score >= 0 AND overall_score <= 100),
    cardiometabolic_score NUMERIC(5, 2) NOT NULL,
    cellular_recovery_score NUMERIC(5, 2) NOT NULL,
    functional_strength_score NUMERIC(5, 2) NOT NULL,
    lifestyle_score NUMERIC(5, 2) NOT NULL,
    projected_lifespan_gain_years NUMERIC(4, 2) NOT NULL,
    primary_lever TEXT NOT NULL,
    assessed_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.longevity_assessments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_longevity_assessments" ON public.longevity_assessments
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "owner_insert_longevity_assessments" ON public.longevity_assessments
    FOR INSERT WITH CHECK (auth.uid() = user_id);
