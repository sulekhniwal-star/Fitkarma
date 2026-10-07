-- Phase 10 Addendum: clinical-dossiers Storage bucket RLS policies
-- Run after creating the bucket in Supabase Dashboard (Settings > Storage > New Bucket)
-- Bucket name: clinical-dossiers | Public: NO | File size limit: 20MB

-- Users can upload only to their own folder: {user_id}/*
CREATE POLICY IF NOT EXISTS "owner_upload_clinical_dossiers"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'clinical-dossiers'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can read only their own files
CREATE POLICY IF NOT EXISTS "owner_read_clinical_dossiers"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'clinical-dossiers'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can delete only their own files
CREATE POLICY IF NOT EXISTS "owner_delete_clinical_dossiers"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'clinical-dossiers'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Add pdf_storage_path column to clinical_lab_reports if not present
ALTER TABLE public.clinical_lab_reports
  ADD COLUMN IF NOT EXISTS pdf_storage_path TEXT;

-- Ensure abha_records has a unique constraint on user_id for upsert
ALTER TABLE public.abha_records
  DROP CONSTRAINT IF EXISTS abha_records_user_id_unique;
ALTER TABLE public.abha_records
  ADD CONSTRAINT abha_records_user_id_unique UNIQUE (user_id);
