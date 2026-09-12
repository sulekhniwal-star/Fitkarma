-- Phase 11: Visual Body Analytics Schema
-- Tables: progress_photos, body_composition_snapshots

-- 1. Progress Photos Table
CREATE TABLE IF NOT EXISTS public.progress_photos (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    pose_type TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    pose_confidence DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    recorded_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.progress_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own progress photos"
    ON public.progress_photos
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_progress_photos_user_date 
    ON public.progress_photos(user_id, recorded_at DESC);

-- 2. Body Composition Snapshots Table
CREATE TABLE IF NOT EXISTS public.body_composition_snapshots (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    body_fat_pct DOUBLE PRECISION NOT NULL,
    lean_mass_kg DOUBLE PRECISION NOT NULL,
    fat_mass_kg DOUBLE PRECISION NOT NULL,
    total_weight_kg DOUBLE PRECISION NOT NULL,
    waist_to_height_ratio DOUBLE PRECISION NOT NULL,
    ffmi DOUBLE PRECISION NOT NULL,
    insight TEXT NOT NULL,
    insight_hindi TEXT NOT NULL,
    calculated_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.body_composition_snapshots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own body composition snapshots"
    ON public.body_composition_snapshots
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_body_comp_user_date 
    ON public.body_composition_snapshots(user_id, calculated_at DESC);
