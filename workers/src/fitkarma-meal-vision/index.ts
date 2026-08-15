/// <reference types="@cloudflare/workers-types" />

import { getCached, setCached, hashPrompt } from '../shared/aiCache';
import { callGroq } from '../shared/groq';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    if (request.method !== 'POST') {
      return new Response(JSON.stringify({ service: 'fitkarma-meal-vision', status: 'operational' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const userId = request.headers.get('x-user-id') || 'usr_client_1';
    const body = (await request.json().catch(() => ({}))) as Record<string, any>;
    const { imageBase64 } = body;

    if (!imageBase64) {
      return new Response(JSON.stringify({ error: 'Missing imageBase64' }), { status: 400 });
    }

    // 1. Compute hash of image bytes for cache lookup
    const imgHash = await hashPrompt(imageBase64.slice(0, 1000));

    // 2. Check user-scoped cache (72-hour TTL = 3 days)
    const cached = await getCached(env.DB, userId, imgHash);
    if (cached) {
      return new Response(cached, { headers: { 'Content-Type': 'application/json', 'x-cache': 'HIT' } });
    }

    // 3. Call Groq LLaMA 3.2 11B Vision
    const groqRes = await callGroq({
      apiKey: env.GROQ_API_KEY,
      model: 'llama-3.2-11b-vision-preview',
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: 'Analyze this Indian food photo. Return JSON only with fields: meal_name, estimated_calories, protein_g, carbs_g, fat_g, confidence_score, and item_breakdown.',
            },
            {
              type: 'image_url',
              image_url: { url: `data:image/jpeg;base64,${imageBase64}` },
            },
          ],
        },
      ],
      response_format: { type: 'json_object' },
      max_tokens: 300,
    });

    await setCached(env.DB, userId, imgHash, groqRes.content, 72);
    return new Response(groqRes.content, { headers: { 'Content-Type': 'application/json', 'x-cache': 'MISS' } });
  },
};
