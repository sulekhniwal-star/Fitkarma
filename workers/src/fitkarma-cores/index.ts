/// <reference types="@cloudflare/workers-types" />

import { getCached, setCached, hashPrompt } from '../shared/aiCache';
import { callGroq } from '../shared/groq';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const action = url.searchParams.get('action');
    const userId = request.headers.get('x-user-id') || 'usr_demo_101';

    if (request.method !== 'POST') {
      return new Response(JSON.stringify({ service: 'fitkarma-cores', status: 'operational' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const body = (await request.json().catch(() => ({}))) as Record<string, any>;

    // 1. Generate 7-day Indian Diet Plan
    if (action === 'generate-diet') {
      const { targetCalories, targetProtein, dietaryPrefs, physicalProfile } = body;
      const prompt = `Generate a 7-day Indian diet plan. Calories: ${targetCalories ?? 2000}kcal, Protein: ${targetProtein ?? 120}g, Prefs: ${dietaryPrefs ?? 'Vegetarian'}, Profile: ${JSON.stringify(physicalProfile ?? {})}`;
      const promptHash = await hashPrompt(prompt);

      // Check user-scoped cache (7-day TTL = 168 hours)
      const cached = await getCached(env.DB, userId, promptHash);
      if (cached) {
        return new Response(cached, { headers: { 'Content-Type': 'application/json', 'x-cache': 'HIT' } });
      }

      const groqRes = await callGroq({
        apiKey: env.GROQ_API_KEY,
        model: 'llama-3.1-70b-versatile',
        messages: [
          { role: 'system', content: 'You are an expert Indian clinical dietitian. Return structured JSON with 7 days of Indian meals meeting macro targets.' },
          { role: 'user', content: prompt },
        ],
        response_format: { type: 'json_object' },
        max_tokens: 500,
      });

      await setCached(env.DB, userId, promptHash, groqRes.content, 168);
      return new Response(groqRes.content, { headers: { 'Content-Type': 'application/json', 'x-cache': 'MISS' } });
    }

    // 2. Generate 12-week Progression Blueprint
    if (action === 'generate-blueprint') {
      const { goals, limitations, age, gender } = body;
      const prompt = `Generate a 12-week workout blueprint. Goals: ${goals}, Limitations: ${limitations}, Age: ${age}, Gender: ${gender}`;
      const promptHash = await hashPrompt(prompt);

      // Check user-scoped cache (30-day TTL = 720 hours)
      const cached = await getCached(env.DB, userId, promptHash);
      if (cached) {
        return new Response(cached, { headers: { 'Content-Type': 'application/json', 'x-cache': 'HIT' } });
      }

      const groqRes = await callGroq({
        apiKey: env.GROQ_API_KEY,
        model: 'llama-3.1-70b-versatile',
        messages: [
          { role: 'system', content: 'You are an elite athletic coach. Generate a 12-week progressive overload blueprint in JSON format.' },
          { role: 'user', content: prompt },
        ],
        response_format: { type: 'json_object' },
        max_tokens: 500,
      });

      await setCached(env.DB, userId, promptHash, groqRes.content, 720);
      return new Response(groqRes.content, { headers: { 'Content-Type': 'application/json', 'x-cache': 'MISS' } });
    }

    return new Response(JSON.stringify({ error: 'Invalid action for fitkarma-cores' }), { status: 400 });
  },
};
