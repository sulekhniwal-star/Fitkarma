-- ============================================================================
-- FitKarma Postgres Migration 05: Gamification, Karma Economy & Habit Engines
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: habits (Atomic Habit Framework & Daily Rituals)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.habits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('nutrition', 'training', 'mindfulness', 'sleep', 'hydration', 'ayurveda')),
    cue TEXT,
    routine TEXT,
    reward TEXT,
    target_frequency_days INTEGER DEFAULT 7 CHECK (target_frequency_days >= 1 AND target_frequency_days <= 7),
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

CREATE TRIGGER set_habits_updated_at
    BEFORE UPDATE ON public.habits
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Table: habit_logs (Daily Habit Completions)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.habit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    habit_id UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    completed_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT habit_logs_unique UNIQUE (habit_id, completed_date)
);

CREATE INDEX idx_habit_logs_user_date ON public.habit_logs(user_id, completed_date DESC);

-- ----------------------------------------------------------------------------
-- Table: badges (Master Badge Catalog)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    badge_key TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    hindi_name TEXT,
    description TEXT NOT NULL,
    icon_name TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('streak', 'readiness', 'nutrition', 'strength', 'ayurveda', 'community')),
    tier TEXT NOT NULL DEFAULT 'bronze' CHECK (tier IN ('bronze', 'silver', 'gold', 'platinum', 'diamond')),
    karma_reward INTEGER NOT NULL DEFAULT 50,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ----------------------------------------------------------------------------
-- Table: user_badges (Unlocked User Badges)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    metadata JSONB DEFAULT '{}'::jsonb,
    CONSTRAINT user_badges_user_badge_unique UNIQUE (user_id, badge_id)
);

-- ----------------------------------------------------------------------------
-- Table: karma_points (User Karma Balance & Level Tier)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.karma_points (
    user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    balance INTEGER NOT NULL DEFAULT 0,
    lifetime_earned INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tier_status TEXT NOT NULL DEFAULT 'sadhaka' CHECK (tier_status IN ('sadhaka', 'abhyasi', 'yogi', 'acharya', 'guru')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ----------------------------------------------------------------------------
-- Table: karma_transactions (Idempotent Ledger of Karma Events)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.karma_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('workout_completed', 'habit_streak', 'meal_logged', 'cgm_in_range', 'badge_unlocked', 'reward_redeemed', 'bonus', 'penalty')),
    idempotency_key TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    CONSTRAINT karma_tx_idempotency_unique UNIQUE (user_id, idempotency_key)
);

CREATE INDEX idx_karma_tx_user ON public.karma_transactions(user_id, created_at DESC);

-- Trigger to automatically update karma_points balance on transaction insertion
CREATE OR REPLACE FUNCTION public.apply_karma_transaction()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.karma_points (user_id, balance, lifetime_earned, level, tier_status, updated_at)
    VALUES (
        NEW.user_id,
        GREATEST(0, NEW.amount),
        GREATEST(0, NEW.amount),
        1,
        'sadhaka',
        TIMEZONE('utc'::text, NOW())
    )
    ON CONFLICT (user_id) DO UPDATE SET
        balance = GREATEST(0, public.karma_points.balance + NEW.amount),
        lifetime_earned = CASE 
            WHEN NEW.amount > 0 THEN public.karma_points.lifetime_earned + NEW.amount 
            ELSE public.karma_points.lifetime_earned 
        END,
        level = 1 + ((CASE WHEN NEW.amount > 0 THEN public.karma_points.lifetime_earned + NEW.amount ELSE public.karma_points.lifetime_earned END) / 500),
        tier_status = CASE 
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 10000 THEN 'guru'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 5000 THEN 'acharya'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 2000 THEN 'yogi'
            WHEN (public.karma_points.lifetime_earned + NEW.amount) >= 500 THEN 'abhyasi'
            ELSE 'sadhaka'
        END,
        updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_karma_transaction_insert
    AFTER INSERT ON public.karma_transactions
    FOR EACH ROW EXECUTE FUNCTION public.apply_karma_transaction();

-- ----------------------------------------------------------------------------
-- Table: transformation_milestones (Identity Shift & Timeline Records)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.transformation_milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    milestone_type TEXT NOT NULL CHECK (milestone_type IN ('weight_lost', 'strength_pr', 'streak_record', 'biological_age_reversal', 'habit_identity')),
    title TEXT NOT NULL,
    description TEXT,
    achieved_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    metric_snapshot JSONB DEFAULT '{}'::jsonb,
    photo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW())
);

-- ----------------------------------------------------------------------------
-- Row Level Security (RLS) Policies
-- ----------------------------------------------------------------------------
ALTER TABLE public.habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.karma_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.karma_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transformation_milestones ENABLE ROW LEVEL SECURITY;

-- Badges Catalog: Public read
CREATE POLICY "Public read for badges"
    ON public.badges FOR SELECT USING (true);

-- User-isolated policies
CREATE POLICY "Users can manage own habits"
    ON public.habits FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own habit logs"
    ON public.habit_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read/insert own badges"
    ON public.user_badges FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read own karma points"
    ON public.karma_points FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert/read own karma transactions"
    ON public.karma_transactions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own transformation milestones"
    ON public.transformation_milestones FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
