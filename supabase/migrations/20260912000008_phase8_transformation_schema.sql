-- Phase 8: Transformation Journey Schema
-- Tables: body_transformation_logs, transformation_milestones

-- 1. Body Transformation Logs Table
CREATE TABLE IF NOT EXISTS public.body_transformation_logs (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recorded_at TIMESTAMPTZ NOT NULL,
    weight_kg DOUBLE PRECISION NOT NULL,
    body_fat_percent DOUBLE PRECISION,
    waist_circumference_cm DOUBLE PRECISION,
    hip_circumference_cm DOUBLE PRECISION,
    chest_circumference_cm DOUBLE PRECISION,
    front_photo_path TEXT,
    side_photo_path TEXT,
    back_photo_path TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.body_transformation_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own body transformation logs"
    ON public.body_transformation_logs
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_body_transformation_logs_user_date 
    ON public.body_transformation_logs(user_id, recorded_at DESC);

-- 2. Transformation Milestones Table
CREATE TABLE IF NOT EXISTS public.transformation_milestones (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    unlocked_at TIMESTAMPTZ NOT NULL,
    metric_snapshot JSONB NOT NULL DEFAULT '{}'::jsonb,
    badge_icon TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.transformation_milestones ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own transformation milestones"
    ON public.transformation_milestones
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_transformation_milestones_user 
    ON public.transformation_milestones(user_id, unlocked_at DESC);
