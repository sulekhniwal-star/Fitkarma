/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    console.log('[fitkarma-reports] Monthly report generation triggered on the 1st of month');

    const { results: users } = await env.DB.prepare(
      'SELECT localId, name FROM users'
    ).all<{ localId: string; name: string }>();

    for (const user of users) {
      // Calculate 30-day averages
      const stats = await env.DB.prepare(`
        SELECT AVG(calories) as avgCalories, AVG(protein) as avgProtein
        FROM food_logs
        WHERE userId = ? AND consumeTime >= datetime('now', '-30 days')
      `).bind(user.localId).first<{ avgCalories: number | null; avgProtein: number | null }>();

      if (!stats || stats.avgCalories === null) continue;

      const reportId = `rep_${Date.now()}_${user.localId}`;
      await env.DB.prepare(`
        INSERT INTO ai_insights (localId, userId, generatedAt, category, content, actionTaken)
        VALUES (?, ?, datetime('now'), 'monthly_report', ?, 0)
      `).bind(
        reportId,
        user.localId,
        `Monthly Summary: Average daily calories ${stats.avgCalories.toFixed(0)} kcal, average daily protein ${stats.avgProtein?.toFixed(0) ?? 0}g.`
      ).run();
    }
  },

  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response(JSON.stringify({ service: 'fitkarma-reports', status: 'operational' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  },
};
