-- ============================================================================
-- FitKarma Postgres Migration 08: Clinical Dossiers, ABHA ID & India Growth Layer
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: doctor_access_grants (Time-Bound Clinical Dossier Sharing)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_doctor_grants_patient ON public.doctor_access_grants(patient_id);
CREATE INDEX idx_doctor_grants_token ON public.doctor_access_grants(access_token);

-- ----------------------------------------------------------------------------
-- Table: abha_records (Ayushman Bharat Health Account & ABDM Sync)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.abha_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    abha_number TEXT NOT NULL UNIQUE, -- 14-digit ABHA ID (e.g. 12-3456-7890-1234)
    abha_address TEXT NOT NULL UNIQUE, -- e.g. sulekh@abdm
    abdm_token_metadata JSONB DEFAULT '{}'::jsonb,
    fhir_sync_status TEXT NOT NULL DEFAULT 'synced' CHECK (fhir_sync_status IN ('pending', 'synced', 'error', 'revoked')),
    last_synced_at TIMESTAMPTZ,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT abha_records_user_unique UNIQUE (user_id)
);

CREATE TRIGGER set_abha_updated_at
    BEFORE UPDATE ON public.abha_records
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: voice_logs (Vernacular Voice Transcription & Entity Extraction)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.voice_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    audio_duration_ms INTEGER,
    detected_language TEXT NOT NULL DEFAULT 'hi' CHECK (detected_language IN ('hi', 'hinglish', 'en', 'ta', 'te')),
    raw_transcription TEXT NOT NULL,
    extracted_entities JSONB NOT NULL DEFAULT '{}'::jsonb, -- e.g. {"foods": ["2 roti", "dal"], "symptoms": ["bloating"]}
    intent TEXT NOT NULL DEFAULT 'log_meal' CHECK (intent IN ('log_meal', 'log_workout', 'ask_coach', 'log_symptom')),
    audio_file_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_voice_logs_user_time ON public.voice_logs(user_id, created_at DESC);

-- ----------------------------------------------------------------------------
-- Table: whatsapp_conversations (Meta Cloud API WhatsApp Logging)
-- ----------------------------------------------------------------------------
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

CREATE INDEX idx_whatsapp_conversations_user ON public.whatsapp_conversations(user_id, created_at DESC);

-- ----------------------------------------------------------------------------
-- Table: corporate_enrollments (B2B Wellness & Insurance Rebate Tier)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Table: grocery_carts (Multi-Vendor Quick-Commerce Price Matrix)
-- ----------------------------------------------------------------------------
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

CREATE TRIGGER set_grocery_carts_updated_at
    BEFORE UPDATE ON public.grocery_carts
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.doctor_access_grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.abha_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.voice_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.whatsapp_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.corporate_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grocery_carts ENABLE ROW LEVEL SECURITY;

-- Doctor Grants: Patient manages grants; Authorized Doctors can read
CREATE POLICY "Patients can manage own doctor grants"
    ON public.doctor_access_grants FOR ALL
    USING (auth.uid() = patient_id)
    WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Doctors can view grants assigned to them"
    ON public.doctor_access_grants FOR SELECT
    USING (auth.uid() = doctor_id);

-- ABHA, Voice, WhatsApp, Corporate, Grocery: Strict User Isolation
CREATE POLICY "Users can manage own ABHA records"
    ON public.abha_records FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own voice logs"
    ON public.voice_logs FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own WhatsApp conversations"
    ON public.whatsapp_conversations FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own corporate enrollments"
    ON public.corporate_enrollments FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own grocery carts"
    ON public.grocery_carts FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
