// supabase/functions/validate-abha/index.ts
// Phase 1 (demo-safe): validates 14-digit ABHA format then upserts to abha_records.
// Live ABDM M1 token exchange deferred — see decisions.md ADR-004.
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const cors = { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' };

const supabase = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return err('AUTH_REQUIRED', 'Missing Authorization header', 401);

    const { data: { user }, error: authError } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''));
    if (authError || !user) return err('AUTH_REQUIRED', 'Invalid session', 401);

    const { abhaNumber, abhaAddress, userId } = await req.json();
    if (!abhaNumber || !abhaAddress || !userId) return err('VALIDATION_FAILED', 'abhaNumber, abhaAddress, and userId are required', 400);
    if (user.id !== userId) return err('AUTH_REQUIRED', 'User ID mismatch', 403);

    // 14-digit numeric check (client already strips hyphens/spaces)
    if (!/^\d{14}$/.test(abhaNumber)) return err('VALIDATION_FAILED', 'ABHA number must be exactly 14 digits', 400);

    const { error: upsertError } = await supabase
      .from('abha_records')
      .upsert({
        user_id: user.id,
        abha_number: abhaNumber,
        abha_address: abhaAddress,
        fhir_sync_status: 'pending',
        is_linked: true,
        updated_at: new Date().toISOString(),
      }, { onConflict: 'user_id' });

    if (upsertError) {
      console.error('[validate-abha] upsert error:', upsertError);
      return err('INTERNAL', 'Could not save ABHA record', 500);
    }

    return new Response(
      JSON.stringify({ status: 'linked', message: 'ABHA linked. Records will sync once ABDM integration goes live.' }),
      { headers: { ...cors, 'Content-Type': 'application/json' }, status: 200 },
    );
  } catch (e) {
    console.error('[validate-abha] unhandled:', e);
    return err('INTERNAL', 'An internal error occurred', 500);
  }
});

function err(code: string, message: string, status: number): Response {
  return new Response(JSON.stringify({ error: { code, message } }), { headers: { ...cors, 'Content-Type': 'application/json' }, status });
}
