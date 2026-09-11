-- ============================================================================
-- FitKarma Postgres Migration 11: Storage Buckets & Storage Security Policies
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Create Private Storage Buckets
-- ----------------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
    ('progress-photos', 'progress-photos', false, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp']),
    ('food-snaps', 'food-snaps', false, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp']),
    ('clinical-dossiers', 'clinical-dossiers', false, 26214400, ARRAY['application/pdf', 'image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

-- ----------------------------------------------------------------------------
-- Storage Row Level Security (RLS) Policies on storage.objects
-- ----------------------------------------------------------------------------

-- 1. Progress Photos Policies (Folder structure: progress-photos/{userId}/{filename})
CREATE POLICY "Users can upload own progress photos"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'progress-photos' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can view own progress photos"
    ON storage.objects FOR SELECT
    USING (
        bucket_id = 'progress-photos' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete own progress photos"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'progress-photos' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- 2. Food Snaps Policies (Folder structure: food-snaps/{userId}/{filename})
CREATE POLICY "Users can upload own food snaps"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'food-snaps' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can view own food snaps"
    ON storage.objects FOR SELECT
    USING (
        bucket_id = 'food-snaps' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete own food snaps"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'food-snaps' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- 3. Clinical Dossiers Policies (Folder structure: clinical-dossiers/{patientId}/{filename})
CREATE POLICY "Patients can upload own clinical dossiers"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'clinical-dossiers' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Patients and Authorized Doctors can view clinical dossiers"
    ON storage.objects FOR SELECT
    USING (
        bucket_id = 'clinical-dossiers' AND (
            auth.uid()::text = (storage.foldername(name))[1]
            OR EXISTS (
                SELECT 1 FROM public.doctor_access_grants dag
                WHERE dag.patient_id::text = (storage.foldername(name))[1]
                  AND dag.doctor_id = auth.uid()
                  AND dag.is_revoked = false
                  AND dag.valid_until > NOW()
            )
        )
    );

CREATE POLICY "Patients can delete own clinical dossiers"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'clinical-dossiers' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );
