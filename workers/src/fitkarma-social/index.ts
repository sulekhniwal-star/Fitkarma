/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
  JWT_SIGNING_SECRET?: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const method = request.method;
    const action = url.searchParams.get('action');
    const userId = request.headers.get('x-user-id') || 'usr_demo_101';

    if (method === 'POST') {
      const body = (await request.json().catch(() => ({}))) as Record<string, any>;

      if (action === 'high-five') {
        const { targetFeedItemId, receiverUserId } = body;
        try {
          // Atomic D1 batch execution for reaction and XP award
          const statements: D1PreparedStatement[] = [
            env.DB.prepare(`
              INSERT INTO karma_events (localId, userId, eventTime, xpAwarded, eventType, description)
              VALUES (?, ?, datetime('now'), 2, 'high_five_received', 'Received a high five on squad feed')
            `).bind(`ke_${Date.now()}_${receiverUserId}`, receiverUserId || userId),
          ];

          await env.DB.batch(statements);
          return new Response(JSON.stringify({ success: true, xpAwarded: 2 }), {
            headers: { 'Content-Type': 'application/json' },
          });
        } catch (err: any) {
          return new Response(JSON.stringify({ error: err.message }), { status: 500 });
        }
      }

      if (action === 'post-activity') {
        const { type, payload } = body;
        const eventId = `act_${Date.now()}_${userId}`;
        await env.DB.prepare(`
          INSERT INTO karma_events (localId, userId, eventTime, xpAwarded, eventType, description)
          VALUES (?, ?, datetime('now'), 10, ?, ?)
        `).bind(eventId, userId, type ?? 'activity_logged', JSON.stringify(payload ?? {})).run();

        return new Response(JSON.stringify({ success: true, eventId }), { status: 201 });
      }
    }

    if (method === 'GET' && action === 'leaderboard') {
      const city = url.searchParams.get('city') || 'Mumbai';
      const { results } = await env.DB.prepare(`
        SELECT localId, name, region, dailyStepsTarget
        FROM users
        WHERE region = ?
        LIMIT 50
      `).bind(city).all();

      return new Response(JSON.stringify({ city, leaderboard: results }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    return new Response(JSON.stringify({ service: 'fitkarma-social', status: 'operational' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  },
};
