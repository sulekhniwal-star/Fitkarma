/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    console.log('[fitkarma-insights] Daily behavioral insights cron triggered');

    const { results: users } = await env.DB.prepare(
      'SELECT localId, name FROM users'
    ).all<{ localId: string; name: string }>();

    for (const user of users) {
      // Ingest last 14 days of recovery logs to evaluate sleep & readiness trends
      const { results: logs } = await env.DB.prepare(
        'SELECT readinessScore, sleepQuality, logDate FROM recovery_logs WHERE userId = ? ORDER BY logDate DESC LIMIT 14'
      ).bind(user.localId).all<{ readinessScore: number; sleepQuality: number; logDate: string }>();

      if (logs.length < 3) continue;

      const avgReadiness = logs.reduce((acc, l) => acc + l.readinessScore, 0) / logs.length;

      if (avgReadiness < 50) {
        await env.DB.prepare(`
          INSERT INTO ai_insights (localId, userId, generatedAt, category, content, actionTaken)
          VALUES (?, ?, datetime('now'), 'recovery_alert', ?, 0)
        `).bind(
          `ins_${Date.now()}_${user.localId}`,
          user.localId,
          'Your 14-day recovery average is below 50. Prioritize 30 minutes earlier bedtime tonight.'
        ).run();
      }
    }
  },

  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response(JSON.stringify({ service: 'fitkarma-insights', status: 'operational' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  },
};
