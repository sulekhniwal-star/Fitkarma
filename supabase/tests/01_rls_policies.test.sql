-- FitKarma pgTAP RLS Policies Test Suite
BEGIN;
SELECT plan(6);

-- 1. Test profiles table exists and has RLS enabled
SELECT has_table('public', 'profiles', 'profiles table should exist');
SELECT row_level_security_active('public', 'profiles', 'profiles table must have RLS active');

-- 2. Test meals table exists and has RLS enabled
SELECT has_table('public', 'meals', 'meals table should exist');
SELECT row_level_security_active('public', 'meals', 'meals table must have RLS active');

-- 3. Test entitlements table exists and has RLS enabled
SELECT has_table('public', 'entitlements', 'entitlements table should exist');
SELECT row_level_security_active('public', 'entitlements', 'entitlements table must have RLS active');

SELECT * FROM finish();
ROLLBACK;
