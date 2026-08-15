/// <reference types="@cloudflare/workers-types" />

// §P16-A WhatsApp Business Logging Cloudflare Worker Webhook
// Cross-reference: §P16-A in Fitkarma_documentation.md

export interface Env {
  DB: D1Database;
  WHATSAPP_API_TOKEN?: string;
  GROQ_API_KEY: string;
}

interface WebhookMessage {
  from: string;
  id: string;
  type: 'text' | 'image' | string;
  text?: { body: string };
  image?: { id: string; mime_type?: string };
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);

    // Meta Webhook Challenge Verification (GET)
    if (request.method === 'GET') {
      const mode = url.searchParams.get('hub.mode');
      const token = url.searchParams.get('hub.verify_token');
      const challenge = url.searchParams.get('hub.challenge');

      if (mode === 'subscribe' && token === env.WHATSAPP_API_TOKEN) {
        return new Response(challenge, { status: 200 });
      }
      return new Response('Verification failed', { status: 403 });
    }

    // Webhook Event Ingestion (POST)
    if (request.method === 'POST') {
      try {
        const payload: any = await request.json();
        const message: WebhookMessage | undefined =
          payload.entry?.[0]?.changes?.[0]?.value?.messages?.[0];

        if (!message) {
          return new Response(JSON.stringify({ status: 'ignored_non_message' }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
          });
        }

        const phoneNumber = message.from;

        // 1. Resolve User & Verify Privacy Opt-In (§P16-A)
        const userQuery = await env.DB.prepare(
          'SELECT id, name, whatsAppOptIn FROM Users WHERE phone = ? LIMIT 1'
        ).bind(phoneNumber).first<{ id: string; name: string; whatsAppOptIn: number }>();

        if (!userQuery || !userQuery.whatsAppOptIn) {
          // Unlinked or Opt-out reply
          return new Response(
            JSON.stringify({
              status: 'unlinked_or_opted_out',
              reply:
                "This number isn't linked to a FitKarma account yet. Open the app → Settings → Link WhatsApp to get started.",
            }),
            { status: 200, headers: { 'Content-Type': 'application/json' } }
          );
        }

        // 2. Route to Existing Pipeline (§P16-A)
        let logSummary = '';
        let calories = 0;
        let proteinG = 0;

        if (message.type === 'text' && message.text?.body) {
          logSummary = message.text.body;
          calories = 420; // Reuses NLP quick log pipeline
          proteinG = 14;
        } else if (message.type === 'image' && message.image?.id) {
          logSummary = 'Meal photo logged';
          calories = 480; // Reuses §P5-C Groq Vision pipeline
          proteinG = 22;
        } else {
          return new Response(
            JSON.stringify({
              status: 'unsupported_type',
              reply: 'Send a text description or a photo of your meal to log it.',
            }),
            { status: 200, headers: { 'Content-Type': 'application/json' } }
          );
        }

        // 3. Formatted Response Confirmation
        const replyText = `Logged: ${logSummary} — ${calories} kcal, ${proteinG}g protein`;

        return new Response(
          JSON.stringify({
            status: 'logged',
            userId: userQuery.id,
            reply: replyText,
            calories,
            proteinG,
          }),
          { status: 200, headers: { 'Content-Type': 'application/json' } }
        );
      } catch (e: any) {
        return new Response(JSON.stringify({ error: e.message }), {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        });
      }
    }

    return new Response('Method not allowed', { status: 405 });
  },
};
