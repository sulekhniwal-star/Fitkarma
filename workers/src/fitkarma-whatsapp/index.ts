/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
  WHATSAPP_API_TOKEN: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    if (request.method === "GET") {
      // WhatsApp Webhook Verification Endpoint
      return new Response("fitkarma-whatsapp webhook verified", { status: 200 });
    }

    if (request.method === "POST") {
      try {
        const payload: any = await request.json();
        console.log("[WhatsApp Webhook] Incoming message event:", payload);
        return new Response(JSON.stringify({ status: "processed" }), {
          headers: { "Content-Type": "application/json" },
        });
      } catch (e: any) {
        return new Response(JSON.stringify({ error: e.message }), { status: 500 });
      }
    }

    return new Response("Method not allowed", { status: 405 });
  },
};
