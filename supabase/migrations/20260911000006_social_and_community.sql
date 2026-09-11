-- ============================================================================
-- FitKarma Postgres Migration 06: Social, Squads, Geolocation Clubs & Communities
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: squads (Micro-Accountability Groups)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    avatar_url TEXT,
    weekly_target_steps INTEGER DEFAULT 70000,
    weekly_target_workouts INTEGER DEFAULT 5,
    max_members INTEGER DEFAULT 10 CHECK (max_members >= 2 AND max_members <= 50),
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TRIGGER set_squads_updated_at
    BEFORE UPDATE ON public.squads
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: squad_members
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.squad_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    squad_id UUID NOT NULL REFERENCES public.squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('leader', 'admin', 'member')),
    weekly_step_contribution INTEGER DEFAULT 0,
    weekly_workout_contribution INTEGER DEFAULT 0,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT squad_members_unique UNIQUE (squad_id, user_id)
);

CREATE INDEX idx_squad_members_squad ON public.squad_members(squad_id);
CREATE INDEX idx_squad_members_user ON public.squad_members(user_id);

-- ----------------------------------------------------------------------------
-- Table: clubs (Geolocation Running / Fitness Hubs)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.clubs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    locality TEXT NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    radius_km NUMERIC(4,1) DEFAULT 10.0,
    member_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_clubs_city ON public.clubs(city);

-- ----------------------------------------------------------------------------
-- Table: club_members
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.club_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    club_id UUID NOT NULL REFERENCES public.clubs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT club_members_unique UNIQUE (club_id, user_id)
);

-- ----------------------------------------------------------------------------
-- Table: communities (Specialized Public Interest Sanghas)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.communities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('pcos', 'hypertrophy', 'ayurveda_lifestyle', 'plant_based', 'running', 'longevity', 'diabetes_cgm')),
    member_count INTEGER DEFAULT 0,
    icon_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ----------------------------------------------------------------------------
-- Table: discussion_threads
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discussion_threads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES public.communities(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    upvotes_count INTEGER DEFAULT 0,
    replies_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TRIGGER set_discussion_threads_updated_at
    BEFORE UPDATE ON public.discussion_threads
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_threads_community ON public.discussion_threads(community_id, created_at DESC);

-- ----------------------------------------------------------------------------
-- Table: discussion_replies
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discussion_replies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    thread_id UUID NOT NULL REFERENCES public.discussion_threads(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    parent_reply_id UUID REFERENCES public.discussion_replies(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_replies_thread ON public.discussion_replies(thread_id, created_at ASC);

-- ----------------------------------------------------------------------------
-- Table: public_feed (Public Sangha Feed & Kudos)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.public_feed (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL CHECK (activity_type IN ('workout_milestone', 'badge_earned', 'cgm_personal_best', 'streak_achievement', 'recipe_share')),
    title TEXT NOT NULL,
    description TEXT,
    metrics_snapshot JSONB DEFAULT '{}'::jsonb,
    kudos_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE INDEX idx_public_feed_time ON public.public_feed(created_at DESC);

-- ----------------------------------------------------------------------------
-- Supabase Realtime Setup
-- Enable replica identity full for Realtime Postgres subscriptions
-- ----------------------------------------------------------------------------
ALTER TABLE public.squad_members REPLICA IDENTITY FULL;
ALTER TABLE public.discussion_threads REPLICA IDENTITY FULL;
ALTER TABLE public.discussion_replies REPLICA IDENTITY FULL;
ALTER TABLE public.public_feed REPLICA IDENTITY FULL;

-- Add tables to realtime publication if publication exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.squad_members, public.discussion_threads, public.discussion_replies, public.public_feed;
    END IF;
END $$;

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.club_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.public_feed ENABLE ROW LEVEL SECURITY;

-- Squads & Members
CREATE POLICY "Authenticated users can view squads"
    ON public.squads FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can create squads"
    ON public.squads FOR INSERT WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Creators can update/delete own squads"
    ON public.squads FOR ALL USING (auth.uid() = creator_id);

CREATE POLICY "Authenticated users can view squad members"
    ON public.squad_members FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can manage own squad membership"
    ON public.squad_members FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Clubs
CREATE POLICY "Authenticated users can view clubs"
    ON public.clubs FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can manage club membership"
    ON public.club_members FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Communities & Threads
CREATE POLICY "Public read for communities"
    ON public.communities FOR SELECT USING (true);

CREATE POLICY "Authenticated users can view threads"
    ON public.discussion_threads FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create threads"
    ON public.discussion_threads FOR INSERT WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Authors can update/delete threads"
    ON public.discussion_threads FOR UPDATE USING (auth.uid() = author_id);

CREATE POLICY "Authenticated users can view replies"
    ON public.discussion_replies FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create replies"
    ON public.discussion_replies FOR INSERT WITH CHECK (auth.uid() = author_id);

-- Public Feed
CREATE POLICY "Authenticated users can view public feed"
    ON public.public_feed FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create public feed items"
    ON public.public_feed FOR INSERT WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Authors can manage own public feed items"
    ON public.public_feed FOR ALL USING (auth.uid() = author_id);
