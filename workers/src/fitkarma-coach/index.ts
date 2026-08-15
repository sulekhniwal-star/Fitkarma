/// <reference types="@cloudflare/workers-types" />

import { callGroq } from '../shared/groq';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    if (request.method !== 'POST') {
      return new Response(JSON.stringify({ service: 'fitkarma-coach', status: 'operational' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const userId = request.headers.get('x-user-id') || 'usr_client_1';
    const body = (await request.json().catch(() => ({}))) as Record<string, any>;
    const { message, chatSessionId } = body;

    if (!message) {
      return new Response(JSON.stringify({ error: 'Missing message parameter' }), { status: 400 });
    }

    // 1. Fetch user snapshot & long-term memory
    const user = await env.DB.prepare(
      'SELECT localId, name, tone, goals, dietType FROM users WHERE localId = ?'
    ).bind(userId).first<{ localId: string; name: string; tone: string; goals: string; dietType: string }>();

    // 2. Fetch rolling 7-day health metrics
    const { results: recentDIPs } = await env.DB.prepare(
      'SELECT packageDate, primaryInsight, todaysMission FROM daily_intelligence_packages WHERE userId = ? ORDER BY packageDate DESC LIMIT 7'
    ).bind(userId).all();

    // 3. Compress context & format prompt
    const systemPrompt = `
You are the FitKarma AI Coach.
User: ${user?.name ?? 'Athlete'}.
Tone: ${user?.tone ?? 'motivational'}.
Goals: ${user?.goals ?? 'Fat loss and strength'}.
Diet: ${user?.dietType ?? 'Vegetarian'}.
Recent Insights: ${JSON.stringify(recentDIPs ?? [])}.
Be concise, practical, empathetic, and culturally aware of Indian fitness lifestyles.
`;

    // 4. Call Groq LLaMA 3.1 70B
    const groqRes = await callGroq({
      apiKey: env.GROQ_API_KEY,
      model: 'llama-3.1-70b-versatile',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: message },
      ],
      max_tokens: 250,
    });

    const reply = groqRes.content;

    return new Response(
      JSON.stringify({
        reply,
        sessionId: chatSessionId ?? `session_${Date.now()}`,
        tone: user?.tone ?? 'motivational',
      }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  },
};
