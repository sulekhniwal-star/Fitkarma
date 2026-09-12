-- Phase 9: Social & Community Schema
-- Tables: squads, squad_members, community_posts, family_members, clubs

-- 1. Squads Table
CREATE TABLE IF NOT EXISTS public.squads (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    bio TEXT NOT NULL,
    banner_url TEXT,
    streak_days INTEGER NOT NULL DEFAULT 0,
    total_karma INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.squads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can view squads"
    ON public.squads
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can create squads"
    ON public.squads
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- 2. Squad Members Join Table
CREATE TABLE IF NOT EXISTS public.squad_members (
    id TEXT PRIMARY KEY,
    squad_id TEXT NOT NULL REFERENCES public.squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    role TEXT NOT NULL DEFAULT 'member',
    today_logged BOOLEAN NOT NULL DEFAULT false,
    today_karma INTEGER NOT NULL DEFAULT 0,
    today_commitment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(squad_id, user_id)
);

ALTER TABLE public.squad_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Squad members can read squad rosters"
    ON public.squad_members
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can manage their own squad membership"
    ON public.squad_members
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 3. Community Posts Table
CREATE TABLE IF NOT EXISTS public.community_posts (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    author_name TEXT NOT NULL,
    author_avatar TEXT,
    activity_type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    media_url TEXT,
    karma_earned INTEGER NOT NULL DEFAULT 0,
    likes_count INTEGER NOT NULL DEFAULT 0,
    cheers_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public authenticated read for community posts"
    ON public.community_posts
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can create their own activity posts"
    ON public.community_posts
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_community_posts_created 
    ON public.community_posts(created_at DESC);

-- 4. Family Members Health Monitoring Table
CREATE TABLE IF NOT EXISTS public.family_members (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    relative_user_id TEXT NOT NULL,
    relative_name TEXT NOT NULL,
    relation TEXT NOT NULL,
    age INTEGER NOT NULL,
    latest_systolic_bp DOUBLE PRECISION,
    latest_diastolic_bp DOUBLE PRECISION,
    latest_fasting_glucose_mg_dl DOUBLE PRECISION,
    today_steps INTEGER,
    alert_level TEXT NOT NULL DEFAULT 'normal',
    alert_message TEXT,
    alert_message_hindi TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.family_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their family members"
    ON public.family_members
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 5. Local Geolocation Clubs Table
CREATE TABLE IF NOT EXISTS public.clubs (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    locality TEXT NOT NULL,
    club_type TEXT NOT NULL,
    member_count INTEGER NOT NULL DEFAULT 1,
    banner_url TEXT,
    next_meetup TEXT NOT NULL,
    next_meetup_hindi TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.clubs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can view clubs"
    ON public.clubs
    FOR SELECT
    TO authenticated
    USING (true);
