-- Phase 12: Festival & Life Events Schema
-- Tables: active_life_events, wedding_plans

-- 1. Active Life Events Table
CREATE TABLE IF NOT EXISTS public.active_life_events (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    title TEXT NOT NULL,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    config_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.active_life_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own active life events"
    ON public.active_life_events
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_life_events_user 
    ON public.active_life_events(user_id, start_date DESC);

-- 2. Wedding Transformation Plans Table
CREATE TABLE IF NOT EXISTS public.wedding_plans (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    wedding_date TIMESTAMPTZ NOT NULL,
    target_weight_kg DOUBLE PRECISION NOT NULL,
    target_waist_cm DOUBLE PRECISION NOT NULL,
    current_phase TEXT NOT NULL,
    current_phase_hindi TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.wedding_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own wedding plans"
    ON public.wedding_plans
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
