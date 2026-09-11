-- ============================================================================
-- FitKarma Postgres Migration 09: DPDP Act 2023 Compliance & Cascading Deletion RPC
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: erasure_receipts (Immutable Cryptographic DPDP Audit Log)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.erasure_receipts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id_hash TEXT NOT NULL, -- SHA-256 hash of the deleted user ID
    reason TEXT NOT NULL DEFAULT 'USER_REQUESTED_ERASURE',
    tables_purged JSONB NOT NULL DEFAULT '[]'::jsonb,
    cross_references_cleaned JSONB NOT NULL DEFAULT '[]'::jsonb,
    storage_objects_flagged INTEGER NOT NULL DEFAULT 0,
    cryptographic_signature TEXT NOT NULL,
    executed_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc'::text, NOW()),
    status TEXT NOT NULL DEFAULT 'COMPLETED'
);

CREATE INDEX idx_erasure_receipts_hash ON public.erasure_receipts(user_id_hash);

ALTER TABLE public.erasure_receipts ENABLE ROW LEVEL SECURITY;

-- Receipts can only be read by service_role for legal/compliance verification
CREATE POLICY "Service role can view erasure receipts"
    ON public.erasure_receipts FOR SELECT
    USING (auth.role() = 'service_role');

-- ----------------------------------------------------------------------------
-- RPC Function: delete_user_data(target_user_id, reason)
-- DPDP Act 2023 Section 12 Right-to-Erasure Implementation
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.delete_user_data(
    target_user_id UUID,
    deletion_reason TEXT DEFAULT 'USER_REQUESTED_ERASURE'
)
RETURNS JSONB AS $$
DECLARE
    user_hash TEXT;
    signature_payload TEXT;
    purged_list JSONB := '[]'::jsonb;
    cross_ref_list JSONB := '[]'::jsonb;
    result JSONB;
BEGIN
    -- Security Check: Caller must be the user themselves or service_role
    IF auth.uid() IS NOT NULL AND auth.uid() <> target_user_id AND auth.role() <> 'service_role' THEN
        RAISE EXCEPTION 'Unauthorized: Cannot execute right-to-erasure for another user.';
    END IF;

    -- Generate cryptographic SHA-256 hash of the user ID for anonymized audit
    user_hash := encode(digest(target_user_id::text, 'sha256'), 'hex');

    -- 1. Clean up squads where user is creator or solo member
    DELETE FROM public.squads 
    WHERE creator_id = target_user_id 
      AND id NOT IN (
          SELECT squad_id FROM public.squad_members 
          WHERE user_id <> target_user_id
      );
    cross_ref_list := cross_ref_list || jsonb_build_array('empty_created_squads_purged');

    -- Reassign remaining squads created by this user to another active member
    UPDATE public.squads s
    SET creator_id = sm.user_id
    FROM (
        SELECT DISTINCT ON (squad_id) squad_id, user_id 
        FROM public.squad_members 
        WHERE user_id <> target_user_id 
        ORDER BY squad_id, joined_at ASC
    ) sm
    WHERE s.id = sm.squad_id AND s.creator_id = target_user_id;

    -- 2. Clean up storage objects in storage.objects if storage schema exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'storage' AND table_name = 'objects') THEN
        DELETE FROM storage.objects 
        WHERE bucket_id IN ('progress-photos', 'food-snaps', 'clinical-dossiers')
          AND (path_tokens[1] = target_user_id::text OR owner = target_user_id);
        cross_ref_list := cross_ref_list || jsonb_build_array('storage_objects_purged');
    END IF;

    -- 3. Execute cascading profile deletion (foreign keys will cascade across all 23+ dependent tables)
    DELETE FROM public.profiles WHERE id = target_user_id;
    purged_list := jsonb_build_array(
        'profiles', 'dosha_scores', 'cycle_tracking', 'compliance_consents',
        'push_tokens', 'daily_intelligence', 'biomarkers', 'cgm_telemetry',
        'wearable_samples', 'blood_pressure_logs', 'soreness_logs', 'sleep_sessions',
        'environmental_telemetry', 'longevity_reports', 'body_analytics', 'meals',
        'water_logs', 'fasting_sessions', 'workout_logs', 'workout_sets',
        'movement_trajectories', 'habits', 'habit_logs', 'user_badges',
        'karma_points', 'karma_transactions', 'transformation_milestones',
        'entitlements', 'affiliate_profiles', 'doctor_access_grants',
        'abha_records', 'voice_logs', 'whatsapp_conversations',
        'corporate_enrollments', 'grocery_carts'
    );

    -- 4. Generate immutable cryptographic signature for compliance
    signature_payload := encode(digest(user_hash || ':' || deletion_reason || ':' || NOW()::text, 'sha256'), 'hex');

    -- 5. Record erasure receipt
    INSERT INTO public.erasure_receipts (
        user_id_hash,
        reason,
        tables_purged,
        cross_references_cleaned,
        cryptographic_signature,
        status
    ) VALUES (
        user_hash,
        deletion_reason,
        purged_list,
        cross_ref_list,
        signature_payload,
        'COMPLETED'
    );

    result := jsonb_build_object(
        'status', 'COMPLETED',
        'user_id_hash', user_hash,
        'signature', signature_payload,
        'executed_at', NOW()
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
