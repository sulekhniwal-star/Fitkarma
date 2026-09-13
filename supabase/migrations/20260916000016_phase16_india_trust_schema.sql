-- Phase 16: India Growth & Trust Layer Schema (ABHA, WhatsApp Logs, Corporate Wellness)

-- 1. ABHA Records Table
CREATE TABLE IF NOT EXISTS public.abha_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    abha_number TEXT NOT NULL,
    abha_address TEXT NOT NULL,
    is_linked BOOLEAN NOT NULL DEFAULT true,
    fhir_sync_status TEXT NOT NULL DEFAULT 'synced',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.abha_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_abha_records" ON public.abha_records
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "owner_insert_abha_records" ON public.abha_records
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "owner_update_abha_records" ON public.abha_records
    FOR UPDATE USING (auth.uid() = user_id);


-- 2. WhatsApp Logs Table (Inbound/Outbound chat logging)
CREATE TABLE IF NOT EXISTS public.whatsapp_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    phone_number TEXT NOT NULL,
    message_id TEXT NOT NULL,
    direction TEXT NOT NULL CHECK (direction IN ('inbound', 'outbound')),
    raw_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.whatsapp_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_whatsapp_logs" ON public.whatsapp_logs
    FOR SELECT USING (auth.uid() = user_id);


-- 3. Corporate Wellness Teams Table
CREATE TABLE IF NOT EXISTS public.corporate_teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT NOT NULL,
    team_name TEXT NOT NULL,
    corporate_code TEXT NOT NULL UNIQUE,
    wellness_score NUMERIC(5, 2) NOT NULL DEFAULT 50.00,
    member_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.corporate_teams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_corporate_teams" ON public.corporate_teams
    FOR SELECT USING (true);
