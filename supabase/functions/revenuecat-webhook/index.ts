// FitKarma RevenueCat Server Webhook Handler
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0';
import { corsHeaders, handleCors } from '../_shared/cors.ts';

serve(async (req: Request) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  try {
    const authHeader = req.headers.get('Authorization');
    const expectedSecret = Deno.env.get('REVENUECAT_WEBHOOK_AUTH_KEY');

    // Verify webhook secret
    if (expectedSecret && authHeader !== `Bearer ${expectedSecret}` && authHeader !== expectedSecret) {
      return new Response(JSON.stringify({ error: 'Unauthorized webhook call' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const payload = await req.json();
    const event = payload.event;

    if (!event || !event.app_user_id) {
      return new Response(JSON.stringify({ error: 'Invalid event payload' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const userId = event.app_user_id;
    const eventType = event.type; // INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION, etc.
    const entitlementId = event.entitlement_id || event.product_id || 'karma_pro';
    const expiresDate = event.expiration_at_ms
      ? new Date(event.expiration_at_ms).toISOString()
      : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

    let tier = 'free';
    let status = 'active';

    if (eventType === 'EXPIRATION' || eventType === 'REVOCATION') {
      tier = 'free';
      status = 'expired';
    } else if (entitlementId.includes('elite')) {
      tier = 'fitkarma_elite';
      status = 'active';
    } else if (entitlementId.includes('pro')) {
      tier = 'karma_pro';
      status = 'active';
    }

    // Connect to Supabase using service-role key to update entitlements table
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    const { error: upsertError } = await adminClient.from('entitlements').upsert(
      {
        user_id: userId,
        tier,
        status,
        valid_until: expiresDate,
        revenuecat_customer_id: event.original_app_user_id || userId,
        updated_at: new Date().toISOString(),
      },
      { onConflict: 'user_id' },
    );

    if (upsertError) {
      console.error('Error upserting entitlement:', upsertError);
      return new Response(JSON.stringify({ error: upsertError.message }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    return new Response(
      JSON.stringify({
        status: 'success',
        user_id: userId,
        tier,
        event_type: eventType,
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
        message: error instanceof Error ? error.message : 'Unknown webhook error',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    );
  }
});
