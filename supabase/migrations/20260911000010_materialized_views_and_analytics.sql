-- ============================================================================
-- FitKarma Postgres Migration 10: Materialized Views & Demographic Benchmarks
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Materialized View: mv_weekly_leaderboards
-- Summarizes karma points and activity ranks for weekly cohorts
-- ----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW IF NOT EXISTS public.mv_weekly_leaderboards AS
SELECT 
    p.id AS user_id,
    p.full_name,
    p.avatar_url,
    p.preferred_language,
    kp.level,
    kp.tier_status,
    COALESCE(SUM(kt.amount) FILTER (WHERE kt.created_at >= (NOW() - INTERVAL '7 days')), 0)::INTEGER AS weekly_karma_earned,
    kp.balance AS total_karma_balance,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(kt.amount) FILTER (WHERE kt.created_at >= (NOW() - INTERVAL '7 days')), 0) DESC) AS rank
FROM public.profiles p
JOIN public.karma_points kp ON kp.user_id = p.id
LEFT JOIN public.karma_transactions kt ON kt.user_id = p.id AND kt.amount > 0
GROUP BY p.id, p.full_name, p.avatar_url, p.preferred_language, kp.level, kp.tier_status, kp.balance;

CREATE UNIQUE INDEX idx_mv_weekly_leaderboards_user ON public.mv_weekly_leaderboards(user_id);

-- ----------------------------------------------------------------------------
-- Materialized View: mv_cohort_benchmarks
-- Anonymized demographic cohort percentiles (Age bracket + Gender + Dosha)
-- ----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW IF NOT EXISTS public.mv_cohort_benchmarks AS
SELECT 
    CASE 
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN p.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_bracket,
    p.gender,
    COALESCE(ds.dominant_dosha, 'tridosha') AS dominant_dosha,
    COUNT(DISTINCT p.id)::INTEGER AS sample_size,
    ROUND(AVG(di.readiness_score), 2) AS avg_readiness_score,
    ROUND(AVG(di.recovery_score), 2) AS avg_recovery_score,
    ROUND(AVG(ss.total_sleep_minutes), 0) AS avg_sleep_minutes,
    ROUND(AVG(lr.vo2_max_estimate), 1) AS avg_vo2_max,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY di.readiness_score) AS median_readiness,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY di.readiness_score) AS p90_readiness
FROM public.profiles p
LEFT JOIN public.dosha_scores ds ON ds.user_id = p.id
LEFT JOIN public.daily_intelligence di ON di.user_id = p.id AND di.date >= (CURRENT_DATE - INTERVAL '14 days')
LEFT JOIN public.sleep_sessions ss ON ss.user_id = p.id AND ss.sleep_date >= (CURRENT_DATE - INTERVAL '14 days')
LEFT JOIN public.longevity_reports lr ON lr.user_id = p.id
WHERE p.age IS NOT NULL AND p.gender IS NOT NULL
GROUP BY 
    CASE 
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN p.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END,
    p.gender,
    COALESCE(ds.dominant_dosha, 'tridosha');

CREATE UNIQUE INDEX idx_mv_cohort_benchmarks_group ON public.mv_cohort_benchmarks(age_bracket, gender, dominant_dosha);

-- ----------------------------------------------------------------------------
-- Maintenance Functions: Concurrent Refresh
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.refresh_leaderboards()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_weekly_leaderboards;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.refresh_cohort_benchmarks()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_cohort_benchmarks;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant Read Access to Authenticated Users
GRANT SELECT ON public.mv_weekly_leaderboards TO authenticated, anon;
GRANT SELECT ON public.mv_cohort_benchmarks TO authenticated, anon;
