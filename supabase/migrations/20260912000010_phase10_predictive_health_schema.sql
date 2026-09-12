-- Phase 10: Predictive & Clinical Health Schema
-- Tables: biological_age_estimates, clinical_lab_reports, medications, doctor_access_grants

-- 1. Biological Age Estimates Table
CREATE TABLE IF NOT EXISTS public.biological_age_estimates (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    chronological_age INTEGER NOT NULL,
    biological_age DOUBLE PRECISION NOT NULL,
    age_delta DOUBLE PRECISION NOT NULL,
    confidence_score DOUBLE PRECISION NOT NULL DEFAULT 0.90,
    top_improvement_action TEXT NOT NULL,
    top_improvement_action_hindi TEXT NOT NULL,
    calculated_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.biological_age_estimates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own biological age estimates"
    ON public.biological_age_estimates
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_bio_age_user_date 
    ON public.biological_age_estimates(user_id, calculated_at DESC);

-- 2. Clinical Lab Reports Table
CREATE TABLE IF NOT EXISTS public.clinical_lab_reports (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    lab_name TEXT NOT NULL,
    test_date TIMESTAMPTZ NOT NULL,
    results JSONB NOT NULL DEFAULT '[]'::jsonb,
    executive_summary TEXT NOT NULL,
    executive_summary_hindi TEXT NOT NULL,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.clinical_lab_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own clinical lab reports"
    ON public.clinical_lab_reports
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_lab_reports_user_date 
    ON public.clinical_lab_reports(user_id, test_date DESC);

-- 3. Medications Schedule Table
CREATE TABLE IF NOT EXISTS public.medications (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    medication_name TEXT NOT NULL,
    dosage TEXT NOT NULL,
    frequency TEXT NOT NULL,
    timing_category TEXT NOT NULL,
    food_interaction_warning TEXT,
    food_interaction_warning_hindi TEXT,
    is_taken_today BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.medications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own medications"
    ON public.medications
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 4. Doctor Access Grants Table
CREATE TABLE IF NOT EXISTS public.doctor_access_grants (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_name TEXT NOT NULL,
    clinic_hospital TEXT NOT NULL,
    access_pin TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.doctor_access_grants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own doctor access grants"
    ON public.doctor_access_grants
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
