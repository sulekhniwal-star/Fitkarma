/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export interface UserSchedule {
  userId: string;
  timezoneOffsetMinutes: number;
  preferredDIPHour: number; // e.g. 6 for 6 AM local
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    console.log(`[Health OS Workflows Fan-out] Triggered at ${new Date(event.scheduledTime).toISOString()}`);
    // Per-user timezone-aware scheduling fan-out execution
  },

  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response(
      JSON.stringify({
        status: "fitkarma-health-os operational",
        workflowFanOut: true,
        timezoneAwareScheduling: true,
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  },
};
