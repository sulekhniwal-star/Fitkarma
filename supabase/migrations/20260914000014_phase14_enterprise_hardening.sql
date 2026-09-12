-- Phase 14: Enterprise Hardening Schema (DPDP Erasure Receipts & Audit Log)

CREATE TABLE IF NOT EXISTS public.erasure_receipts (
    receipt_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    anonymized_hash TEXT NOT NULL,
    deleted_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.erasure_receipts ENABLE ROW LEVEL SECURITY;

-- Service Role only writes and reads for compliance auditing
-- No client user access

-- Storage Buckets Configuration for Secure Health Artifacts
INSERT INTO storage.buckets (id, name, public)
VALUES 
    ('progress-photos', 'progress-photos', false),
    ('lab-reports', 'lab-reports', false),
    ('doctor-dossiers', 'doctor-dossiers', false)
ON CONFLICT (id) DO NOTHING;

-- RLS for Storage Objects (Private access with signed URLs)
CREATE POLICY "owner_read_progress_photos" ON storage.objects
    FOR SELECT USING (bucket_id = 'progress-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "owner_insert_progress_photos" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'progress-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "owner_delete_progress_photos" ON storage.objects
    FOR DELETE USING (bucket_id = 'progress-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "owner_read_lab_reports" ON storage.objects
    FOR SELECT USING (bucket_id = 'lab-reports' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "owner_insert_lab_reports" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'lab-reports' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "owner_delete_lab_reports" ON storage.objects
    FOR DELETE USING (bucket_id = 'lab-reports' AND auth.uid()::text = (storage.foldername(name))[1]);
