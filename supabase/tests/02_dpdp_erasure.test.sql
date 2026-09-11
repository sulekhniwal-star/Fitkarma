-- FitKarma pgTAP DPDP Act 2023 delete_user_data RPC Test Suite
BEGIN;
SELECT plan(4);

-- 1. Test function exists
SELECT has_function('public', 'delete_user_data', ARRAY['uuid'], 'delete_user_data RPC function must exist');

-- 2. Test erasure_receipts table exists and has RLS active
SELECT has_table('public', 'erasure_receipts', 'erasure_receipts table must exist for compliance auditing');
SELECT row_level_security_active('public', 'erasure_receipts', 'erasure_receipts must have RLS active');

-- 3. Test that erasure_receipts has cryptographic receipt_hash column
SELECT has_column('public', 'erasure_receipts', 'receipt_hash', 'erasure_receipts must contain receipt_hash column');

SELECT * FROM finish();
ROLLBACK;
