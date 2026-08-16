/// <reference types="@cloudflare/workers-types" />

/**
 * fitkarma-food-db Worker
 * Handles all food database and food logging endpoints.
 *
 * Routes:
 *   GET  /food-db/search?q=dal&limit=20&category=lentils  — FTS5 search
 *   GET  /food-db/item/:id                                 — single item
 *   GET  /food-db/categories                               — list all categories
 *   POST /food-db/log                                      — log a food entry
 */

import { getCached, setCached, hashPrompt } from '../shared/aiCache';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
  ENVIRONMENT?: string;
}

interface FoodItem {
  foodId: string;
  foodName: string;
  defaultServing: string;
  calories: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  glycemicIndex: number;
  fiberG: number;
  satietyIndex: number;
  category: string;
  region: string;
  servingGrams: number;
  sourceTag: string;
}

function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'public, max-age=3600',
    },
  });
}

function errorResponse(message: string, status = 400): Response {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;
    const userId = request.headers.get('x-user-id') ?? 'anonymous';

    // ── Health check ──────────────────────────────────────────────────────────
    if (request.method === 'GET' && path === '/food-db') {
      return jsonResponse({ service: 'fitkarma-food-db', status: 'operational' });
    }

    // ── GET /food-db/search?q=...&limit=...&category=... ──────────────────────
    if (request.method === 'GET' && path === '/food-db/search') {
      const q = (url.searchParams.get('q') ?? '').trim();
      if (!q || q.length < 2) {
        return errorResponse('Query param "q" must be at least 2 characters');
      }
      const limit = Math.min(parseInt(url.searchParams.get('limit') ?? '20'), 50);
      const category = (url.searchParams.get('category') ?? '').trim();

      // Cache key includes q + category + limit
      const cacheKey = `food_search:${q.toLowerCase()}:${category}:${limit}`;
      const promptHash = await hashPrompt(cacheKey);
      const cached = await getCached(env.DB, 'food_db', promptHash);
      if (cached) {
        return new Response(cached, {
          headers: { 'Content-Type': 'application/json', 'x-cache': 'HIT' },
        });
      }

      let results: FoodItem[];

      // Try FTS5 first for ranked relevance results
      try {
        const ftsQuery = category
          ? `SELECT fr.* FROM food_fts fts
             JOIN food_references fr ON fr.foodId = fts.foodId
             WHERE food_fts MATCH ? AND fr.category = ?
             ORDER BY rank LIMIT ?`
          : `SELECT fr.* FROM food_fts fts
             JOIN food_references fr ON fr.foodId = fts.foodId
             WHERE food_fts MATCH ?
             ORDER BY rank LIMIT ?`;

        const params = category ? [q, category, limit] : [q, limit];
        const ftsResult = await env.DB.prepare(ftsQuery).bind(...params).all<FoodItem>();
        results = ftsResult.results ?? [];
      } catch (_ftsErr) {
        // FTS5 not available or query error — fallback to LIKE search
        const likeQ = `%${q}%`;
        const likeQuery = category
          ? `SELECT * FROM food_references WHERE foodName LIKE ? AND category = ? ORDER BY foodName LIMIT ?`
          : `SELECT * FROM food_references WHERE foodName LIKE ? ORDER BY foodName LIMIT ?`;

        const params = category ? [likeQ, category, limit] : [likeQ, limit];
        const likeResult = await env.DB.prepare(likeQuery).bind(...params).all<FoodItem>();
        results = likeResult.results ?? [];
      }

      const responseBody = JSON.stringify({ items: results, count: results.length, query: q });

      // Cache for 1 hour (3600s)
      ctx.waitUntil(setCached(env.DB, 'food_db', promptHash, responseBody, 1));

      return new Response(responseBody, {
        headers: { 'Content-Type': 'application/json', 'x-cache': 'MISS' },
      });
    }

    // ── GET /food-db/item/:id ─────────────────────────────────────────────────
    if (request.method === 'GET' && path.startsWith('/food-db/item/')) {
      const foodId = path.replace('/food-db/item/', '').trim();
      if (!foodId) return errorResponse('Missing food ID');

      const result = await env.DB
        .prepare('SELECT * FROM food_references WHERE foodId = ?')
        .bind(foodId)
        .first<FoodItem>();

      if (!result) return errorResponse(`Food item not found: ${foodId}`, 404);
      return jsonResponse({ item: result });
    }

    // ── GET /food-db/categories ───────────────────────────────────────────────
    if (request.method === 'GET' && path === '/food-db/categories') {
      const cacheKey = 'food_db:categories';
      const promptHash = await hashPrompt(cacheKey);
      const cached = await getCached(env.DB, 'food_db', promptHash);
      if (cached) {
        return new Response(cached, {
          headers: { 'Content-Type': 'application/json', 'x-cache': 'HIT' },
        });
      }

      const result = await env.DB
        .prepare('SELECT DISTINCT category FROM food_references ORDER BY category')
        .all<{ category: string }>();

      const categories = (result.results ?? []).map(r => r.category).filter(Boolean);
      const body = JSON.stringify({ categories });

      // Cache 24 hours
      ctx.waitUntil(setCached(env.DB, 'food_db', promptHash, body, 24));
      return new Response(body, { headers: { 'Content-Type': 'application/json', 'x-cache': 'MISS' } });
    }

    // ── POST /food-db/log — online food logging ───────────────────────────────
    if (request.method === 'POST' && path === '/food-db/log') {
      let body: Record<string, unknown>;
      try {
        body = (await request.json()) as Record<string, unknown>;
      } catch {
        return errorResponse('Invalid JSON body');
      }

      const { localId, foodName, calories, protein, carbs, fat, consumeTime, processingTier } = body as {
        localId: string;
        foodName: string;
        calories: number;
        protein: number;
        carbs: number;
        fat: number;
        consumeTime: string;
        processingTier?: number;
      };

      if (!localId || !foodName || calories == null) {
        return errorResponse('Required fields: localId, foodName, calories');
      }

      const createdAt = new Date().toISOString();

      await env.DB
        .prepare(
          `INSERT OR REPLACE INTO food_logs
           (localId, userId, consumeTime, foodName, calories, protein, carbs, fat,
            processingTier, hasGlycemicAnalysis, createdAt)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?)`
        )
        .bind(
          localId,
          userId,
          consumeTime ?? createdAt,
          foodName,
          Number(calories),
          Number(protein ?? 0),
          Number(carbs ?? 0),
          Number(fat ?? 0),
          Number(processingTier ?? 1.0),
          createdAt,
        )
        .run();

      return jsonResponse({ success: true, localId }, 201);
    }

    return errorResponse('Not found', 404);
  },
};
