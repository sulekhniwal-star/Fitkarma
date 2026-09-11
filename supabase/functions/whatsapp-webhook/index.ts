// FitKarma Meta Cloud API WhatsApp Webhook
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0';
import { corsHeaders, handleCors } from '../_shared/cors.ts';

serve(async (req: Request) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  const url = new URL(req.url);

  // 1. Meta Webhook Verification Handshake (GET)
  if (req.method === 'GET') {
    const mode = url.searchParams.get('hub.mode');
    const token = url.searchParams.get('hub.verify_token');
    const challenge = url.searchParams.get('hub.challenge');

    const verifyToken = Deno.env.get('WHATSAPP_VERIFY_TOKEN') || 'fitkarma_meta_verify_2026';

    if (mode === 'subscribe' && token === verifyToken) {
      return new Response(challenge, { status: 200 });
    }
    return new Response('Verification failed', { status: 403 });
  }

  // 2. Incoming WhatsApp Message Handler (POST)
  if (req.method === 'POST') {
    try {
      const body = await req.json();
      const entry = body.entry?.[0];
      const changes = entry?.changes?.[0];
      const value = changes?.value;
      const message = value?.messages?.[0];

      if (!message) {
        return new Response(JSON.stringify({ status: 'ignored' }), {
          status: 200,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        });
      }

      const fromPhone = message.from; // e.g. "919876543210"
      const textBody = message.text?.body || '';

      const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
      const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
      const adminClient = createClient(supabaseUrl, supabaseServiceKey);

      // Find user profile matching the WhatsApp phone number
      const formattedPhone = fromPhone.startsWith('+') ? fromPhone : `+${fromPhone}`;
      const { data: profile } = await adminClient
        .from('profiles')
        .select('id, full_name')
        .eq('phone_number', formattedPhone)
        .maybeSingle();

      const userId = profile?.id;

      // Parse simple Indian meal or water commands
      let loggedType = 'general_text';
      if (/roti|paneer|dal|rice|sattu|eggs|chicken|dosa|idli/i.test(textBody)) {
        loggedType = 'meal_logged';
        if (userId) {
          await adminClient.from('meals').insert({
            user_id: userId,
            meal_name: textBody,
            meal_type: 'whatsapp_quick_log',
            source: 'whatsapp_meta_cloud',
            logged_at: new Date().toISOString(),
          });
        }
      } else if (/water|paani|glass|litre|ml/i.test(textBody)) {
        loggedType = 'hydration_logged';
      }

      return new Response(
        JSON.stringify({
          status: 'success',
          from: formattedPhone,
          logged_type: loggedType,
          user_linked: !!userId,
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
          message: error instanceof Error ? error.message : 'Webhook error',
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        },
      );
    }
  }

  return new Response('Method Not Allowed', { status: 405 });
});
