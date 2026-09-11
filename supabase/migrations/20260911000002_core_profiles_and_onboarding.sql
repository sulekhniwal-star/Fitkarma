-- ============================================================================
-- FitKarma Postgres Migration 02: Core Profiles & Onboarding
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: profiles
-- ----------------------------------------------------------------------------
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

CREATE TRIGGER set_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: dosha_scores (Ayurvedic Prakriti Assessment)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Table: cycle_tracking (Women's Health & PCOS Engine)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_cycle_tracking_user_date ON public.cycle_tracking(user_id, period_start_date DESC);

-- ----------------------------------------------------------------------------
-- Table: compliance_consents (DPDP Act 2023 Explicit Consents)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Table: push_tokens (FCM Notification Device Registry)
-- ----------------------------------------------------------------------------
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

CREATE TRIGGER set_push_tokens_updated_at
    BEFORE UPDATE ON public.push_tokens
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dosha_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cycle_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.compliance_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_tokens ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
CREATE POLICY "Users can read own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can delete own profile"
    ON public.profiles FOR DELETE
    USING (auth.uid() = id);

-- Dosha Scores Policies
CREATE POLICY "Users can read own dosha scores"
    ON public.dosha_scores FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert/update own dosha scores"
    ON public.dosha_scores FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Cycle Tracking Policies
CREATE POLICY "Users can manage own cycle tracking"
    ON public.cycle_tracking FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Compliance Consents Policies
CREATE POLICY "Users can read/insert own compliance consents"
    ON public.compliance_consents FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Push Tokens Policies
CREATE POLICY "Users can manage own push tokens"
    ON public.push_tokens FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
