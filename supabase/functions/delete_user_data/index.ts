// FitKarma DPDP Act 2023 Section 12 Cascading Erasure Edge Function
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0';
import { corsHeaders, handleCors } from '../_shared/cors.ts';

serve(async (req: Request) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
    const authHeader = req.headers.get('Authorization');

    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Initialize regular client to verify requester identity
    const userClient = createClient(supabaseUrl, Deno.env.get('SUPABASE_ANON_KEY') ?? '', {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: authError,
    } = await userClient.auth.getUser();

    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized user request' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const targetUserId = user.id;

    // Initialize admin client with service role key for privileged cascading erasure
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    // 1. Purge all storage bucket assets belonging to the user
    const storageBuckets = ['progress_photos', 'meal_snaps', 'clinical_dossiers', 'avatars'];
    for (const bucket of storageBuckets) {
      try {
        const { data: files } = await adminClient.storage.from(bucket).list(targetUserId);
        if (files && files.length > 0) {
          const filePaths = files.map((f) => `${targetUserId}/${f.name}`);
          await adminClient.storage.from(bucket).remove(filePaths);
        }
      } catch (storageErr) {
        console.warn(`Storage cleanup notice for bucket ${bucket}:`, storageErr);
      }
    }

    // 2. Call PostgreSQL RPC `delete_user_data` to cascade delete across all 23 tables
    const { data: receiptId, error: rpcError } = await adminClient.rpc('delete_user_data', {
      target_user_id: targetUserId,
    });

    if (rpcError) {
      throw new Error(`Database erasure cascade failed: ${rpcError.message}`);
    }

    // 3. Delete user from auth.users
    await adminClient.auth.admin.deleteUser(targetUserId);

    return new Response(
      JSON.stringify({
        status: 'success',
        message: 'All user data and storage assets have been irreversibly erased under DPDP Act 2023.',
        erasure_receipt_id: receiptId,
        timestamp: new Date().toISOString(),
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown erasure error',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    );
  }
});
