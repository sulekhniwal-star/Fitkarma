-- Phase 13: Monetisation Schema (Entitlements, Coach Marketplace, Affiliates)

-- 1. Entitlements Table (Server-role-only writes via RevenueCat webhook / Razorpay webhook)
CREATE TABLE IF NOT EXISTS public.entitlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    tier TEXT NOT NULL CHECK (tier IN ('free', 'pro', 'elite', 'corporate')),
    source TEXT NOT NULL, -- 'revenuecat', 'razorpay', 'corporate_sso'
    expires_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.entitlements ENABLE ROW LEVEL SECURITY;

-- Owner can read their own entitlements
CREATE POLICY "owner_select_entitlements" ON public.entitlements
    FOR SELECT USING (auth.uid() = user_id);

-- Explicitly no client INSERT/UPDATE/DELETE policies (Service Role only)


-- 2. Coach Profiles Table (Public read for active coaches)
CREATE TABLE IF NOT EXISTS public.coach_profiles (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    specialty TEXT NOT NULL,
    bio TEXT NOT NULL,
    languages TEXT[] NOT NULL DEFAULT '{}',
    rating NUMERIC(3, 2) NOT NULL DEFAULT 5.00,
    review_count INTEGER NOT NULL DEFAULT 0,
    hourly_rate_inr INTEGER NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.coach_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_coach_profiles" ON public.coach_profiles
    FOR SELECT USING (true);


-- 3. Coach Bookings Table
CREATE TABLE IF NOT EXISTS public.coach_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    coach_id TEXT NOT NULL REFERENCES public.coach_profiles(id) ON DELETE CASCADE,
    scheduled_at TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    amount_inr INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.coach_bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_coach_bookings" ON public.coach_bookings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "owner_insert_coach_bookings" ON public.coach_bookings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "owner_update_coach_bookings" ON public.coach_bookings
    FOR UPDATE USING (auth.uid() = user_id);


-- 4. Affiliate Referrals Table
CREATE TABLE IF NOT EXISTS public.affiliate_referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    referral_code TEXT NOT NULL,
    referee_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    karma_reward INTEGER NOT NULL DEFAULT 250,
    commission_inr INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.affiliate_referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_select_affiliate_referrals" ON public.affiliate_referrals
    FOR SELECT USING (auth.uid() = referrer_id);

CREATE POLICY "owner_insert_affiliate_referrals" ON public.affiliate_referrals
    FOR INSERT WITH CHECK (auth.uid() = referrer_id);
