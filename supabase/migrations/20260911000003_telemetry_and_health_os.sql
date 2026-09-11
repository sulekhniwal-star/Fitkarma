-- ============================================================================
-- FitKarma Postgres Migration 03: Telemetry & Health OS Engine
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: daily_intelligence (Daily Intelligence Package / DIP Cache)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_daily_intelligence_user_date ON public.daily_intelligence(user_id, date DESC);

-- ----------------------------------------------------------------------------
-- Table: biomarkers (Clinical Lab Blood Panels & Preventive Biomarkers)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_biomarkers_user_date ON public.biomarkers(user_id, test_date DESC);

-- ----------------------------------------------------------------------------
-- Table: cgm_telemetry (Continuous Glucose Monitor Pipeline)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_cgm_telemetry_user_time ON public.cgm_telemetry(user_id, timestamp DESC);

-- ----------------------------------------------------------------------------
-- Table: wearable_samples (Health Connect / HealthKit / Wearable Telemetry)
-- Append-only table with late-sync deduplication unique constraints
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_wearable_samples_user_type_time ON public.wearable_samples(user_id, sample_type, timestamp DESC);

-- ----------------------------------------------------------------------------
-- Table: blood_pressure_logs
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_bp_logs_user_time ON public.blood_pressure_logs(user_id, timestamp DESC);

-- ----------------------------------------------------------------------------
-- Table: soreness_logs (Readiness Heatmaps & Musculoskeletal Fatigue)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.soreness_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    overall_soreness INTEGER NOT NULL CHECK (overall_soreness >= 0 AND overall_soreness <= 10),
    body_map JSONB NOT NULL DEFAULT '{}'::jsonb, -- e.g. {"chest": 3, "quads": 7, "lower_back": 2}
    recovery_recommendation TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT soreness_logs_user_date_unique UNIQUE (user_id, date)
);

-- ----------------------------------------------------------------------------
-- Table: sleep_sessions (Circadian & Sleep Architecture)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_sleep_sessions_user_date ON public.sleep_sessions(user_id, sleep_date DESC);

-- ----------------------------------------------------------------------------
-- Table: environmental_telemetry (AQI, UV, Wet-Bulb Heat Layer)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_env_telemetry_user_time ON public.environmental_telemetry(user_id, timestamp DESC);

-- ----------------------------------------------------------------------------
-- Table: longevity_reports (Biological Age & Hallmarks Synthesis)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Table: body_analytics (Body Composition & Metrics)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_body_analytics_user_date ON public.body_analytics(user_id, logged_date DESC);

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
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

CREATE POLICY "Users can manage own daily intelligence"
    ON public.daily_intelligence FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own biomarkers"
    ON public.biomarkers FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own cgm telemetry"
    ON public.cgm_telemetry FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own wearable samples"
    ON public.wearable_samples FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own blood pressure logs"
    ON public.blood_pressure_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own soreness logs"
    ON public.soreness_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own sleep sessions"
    ON public.sleep_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own environmental telemetry"
    ON public.environmental_telemetry FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own longevity reports"
    ON public.longevity_reports FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own body analytics"
    ON public.body_analytics FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
