-- ============================================================================
-- FitKarma Postgres Migration 07: Monetisation, RevenueCat Entitlements & Marketplace
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: entitlements (Server-Verified RevenueCat Subscription Entitlements)
-- Clients can ONLY READ. Updates are strictly performed by service_role Edge Function.
-- ----------------------------------------------------------------------------
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

CREATE TRIGGER set_entitlements_updated_at
    BEFORE UPDATE ON public.entitlements
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: marketplace_listings (Creator & Coach Blueprints & Plans)
-- ----------------------------------------------------------------------------
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

CREATE TRIGGER set_marketplace_updated_at
    BEFORE UPDATE ON public.marketplace_listings
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: affiliate_profiles (Referral Tracking & Creator Revenue Share)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.affiliate_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    referral_code TEXT NOT NULL UNIQUE,
    commission_rate_pct NUMERIC(4,2) NOT NULL DEFAULT 20.0, -- Default 20%
    total_earned_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    pending_balance_inr NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    upi_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT affiliate_user_unique UNIQUE (user_id)
);

CREATE TRIGGER set_affiliate_updated_at
    BEFORE UPDATE ON public.affiliate_profiles
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: referral_commissions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.referral_commissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    affiliate_id UUID NOT NULL REFERENCES public.affiliate_profiles(id) ON DELETE CASCADE,
    referred_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    subscription_tier TEXT NOT NULL,
    amount_inr NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'refunded')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ----------------------------------------------------------------------------
-- Table: payouts (Affiliate & Creator Bank/UPI Disbursements)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.entitlements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketplace_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.affiliate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.referral_commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payouts ENABLE ROW LEVEL SECURITY;

-- Entitlements: Users can READ ONLY. Server (service_role) writes via webhook.
CREATE POLICY "Users can read own entitlements"
    ON public.entitlements FOR SELECT
    USING (auth.uid() = user_id);

-- Marketplace Listings: Authenticated read; Creators manage own listings
CREATE POLICY "Public read for active marketplace listings"
    ON public.marketplace_listings FOR SELECT
    USING (is_active = true OR auth.uid() = creator_id);

CREATE POLICY "Creators can manage own listings"
    ON public.marketplace_listings FOR ALL
    USING (auth.uid() = creator_id)
    WITH CHECK (auth.uid() = creator_id);

-- Affiliate Profiles & Referrals
CREATE POLICY "Users can view and manage own affiliate profile"
    ON public.affiliate_profiles FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Affiliates can view own referral commissions"
    ON public.referral_commissions FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.affiliate_profiles 
        WHERE id = public.referral_commissions.affiliate_id AND user_id = auth.uid()
    ));

CREATE POLICY "Affiliates can view own payouts"
    ON public.payouts FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.affiliate_profiles 
        WHERE id = public.payouts.affiliate_id AND user_id = auth.uid()
    ));
