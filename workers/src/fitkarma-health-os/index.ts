/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    console.log(`[Health OS Cron] Triggered at ${new Date(event.scheduledTime).toISOString()}`);
  },

  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response(JSON.stringify({ status: "fitkarma-health-os operational" }), {
      headers: { "Content-Type": "application/json" },
    });
  },
};
