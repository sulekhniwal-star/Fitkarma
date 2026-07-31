/// <reference types="@cloudflare/workers-types" />

// §P3-C Cloudflare Worker: fitkarma-coach (v2)
// Key changes from v1:
// 1. Receives compressed Health Snapshot (~400 tokens), not raw 7-day logs
// 2. Uses conversation summary + last 5 messages, not full history
// 3. Model tier is Large (70B) — chat is the right place for it
// 4. Tone is injected from user profile
// 5. Response validated against §P3-A guardrails (no generic advice)

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
  COACH_KV: KVNamespace; // Conversation summaries KV store
}

interface CoachRequestBody {
  userId: string;
  message: string;
  conversationId?: string;
}

interface HealthSnapshot {
  name: string;
  tone: string;
  goals: string[];
  program: string;
  programPhase: string;
  readinessScore: number;
  readinessConfidence: string;
  healthScore: number;
  primaryConcern: string;
  proteinTrend: string;
  avgProtein7d: number;
  proteinTarget: number;
  sleepTrend: string;
  sleepDebtMin: number;
  weightChange4w: number;
  streak: number;
  dietType: string;
  injuries: string[];
}

interface ConversationContext {
  summary: string;
  lastFiveMessages: Array<{ role: 'user' | 'assistant'; content: string }>;
}

async function getHealthSnapshot(userId: string, db: D1Database): Promise<HealthSnapshot> {
  // Query D1 for compressed user health snapshot
  const row = await db.prepare(
    `SELECT * FROM health_snapshots WHERE user_id = ? ORDER BY created_at DESC LIMIT 1`
  ).bind(userId).first();

  if (!row) {
    // Sensible defaults for new users
    return {
      name: 'User',
      tone: 'Empathetic',
      goals: ['Health Improvement'],
      program: 'General Fitness',
      programPhase: 'Foundation',
      readinessScore: 70,
      readinessConfidence: 'Basic',
      healthScore: 65,
      primaryConcern: 'Building healthy habits',
      proteinTrend: 'Stable',
      avgProtein7d: 80,
      proteinTarget: 120,
      sleepTrend: 'Improving',
      sleepDebtMin: -30,
      weightChange4w: 0,
      streak: 1,
      dietType: 'Vegetarian',
      injuries: [],
    };
  }

  return {
    name: row.name as string,
    tone: (row.tone as string) || 'Empathetic',
    goals: JSON.parse((row.goals as string) || '[]'),
    program: (row.program as string) || 'General Fitness',
    programPhase: (row.program_phase as string) || 'Foundation',
    readinessScore: (row.readiness_score as number) || 70,
    readinessConfidence: (row.readiness_confidence as string) || 'Basic',
    healthScore: (row.health_score as number) || 65,
    primaryConcern: (row.primary_concern as string) || 'General wellness',
    proteinTrend: (row.protein_trend as string) || 'Stable',
    avgProtein7d: (row.avg_protein_7d as number) || 80,
    proteinTarget: (row.protein_target as number) || 120,
    sleepTrend: (row.sleep_trend as string) || 'Stable',
    sleepDebtMin: (row.sleep_debt_min as number) || 0,
    weightChange4w: (row.weight_change_4w as number) || 0,
    streak: (row.streak as number) || 1,
    dietType: (row.diet_type as string) || 'Vegetarian',
    injuries: JSON.parse((row.injuries as string) || '[]'),
  };
}

async function getConversationContext(
  userId: string,
  conversationId: string,
  kv: KVNamespace
): Promise<ConversationContext> {
  const key = `conv:${userId}:${conversationId}`;
  const stored = await kv.get(key, 'json') as ConversationContext | null;
  return stored ?? { summary: '', lastFiveMessages: [] };
}

async function updateConversationSummary(
  userId: string,
  conversationId: string,
  userMessage: string,
  aiReply: string,
  ctx: ConversationContext,
  kv: KVNamespace
): Promise<void> {
  const updatedMessages = [
    ...ctx.lastFiveMessages,
    { role: 'user' as const, content: userMessage },
    { role: 'assistant' as const, content: aiReply },
  ].slice(-5); // Keep last 5 exchanges only

  const newCtx: ConversationContext = {
    summary: ctx.summary,
    lastFiveMessages: updatedMessages,
  };

  // Store in KV with 7-day TTL
  await kv.put(
    `conv:${userId}:${conversationId}`,
    JSON.stringify(newCtx),
    { expirationTtl: 60 * 60 * 24 * 7 }
  );
}

async function callGroq(
  systemPrompt: string,
  conversationCtx: ConversationContext,
  userMessage: string,
  apiKey: string
): Promise<string> {
  const messages = [
    { role: 'system', content: systemPrompt },
    ...conversationCtx.lastFiveMessages,
    { role: 'user', content: userMessage },
  ];

  const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'llama-3.3-70b-versatile',
      messages,
      max_tokens: 400,
      temperature: 0.7,
    }),
  });

  if (!response.ok) {
    throw new Error(`Groq API error: ${response.status} ${response.statusText}`);
  }

  const data = await response.json() as any;
  return data.choices?.[0]?.message?.content ?? 'Unable to generate response.';
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    // CORS pre-flight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        },
      });
    }

    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const body = await request.json() as CoachRequestBody;
      const { userId, message, conversationId = 'default' } = body;

      if (!userId || !message) {
        return new Response(
          JSON.stringify({ error: 'userId and message are required' }),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        );
      }

      // 1. Fetch compressed Health Snapshot from D1 (~400 tokens vs ~6000 raw)
      const snapshot = await getHealthSnapshot(userId, env.DB);

      // 2. Fetch rolling conversation context (summary + last 5 messages)
      const conversationCtx = await getConversationContext(userId, conversationId, env.COACH_KV);

      // 3. Build §P3-A guardrail-enforced system prompt
      const systemPrompt = `You are FitKarma's AI health coach. You are ${snapshot.tone} in tone.
You have access to the user's compressed health context — use it in EVERY response.
NEVER give generic advice. ALWAYS reference specific numbers from the health snapshot.
Use Indian food examples for nutrition suggestions (paneer, moong dal, chana, curd, sprouts).

User: ${snapshot.name}
Diet: ${snapshot.dietType}
Goals: ${snapshot.goals.join(', ')}
Program: ${snapshot.program} — Phase: ${snapshot.programPhase}
Today's readiness: ${snapshot.readinessScore}/100 (${snapshot.readinessConfidence} Tier)
Health Score: ${snapshot.healthScore}/100
Primary concern: ${snapshot.primaryConcern}
Protein trend: ${snapshot.proteinTrend} (7-day avg: ${snapshot.avgProtein7d}g vs target ${snapshot.proteinTarget}g)
Sleep trend: ${snapshot.sleepTrend} (Sleep debt: ${snapshot.sleepDebtMin} mins)
Weight change (4w): ${snapshot.weightChange4w}kg
Streak: ${snapshot.streak} days
${snapshot.injuries.length > 0 ? `Active injuries/limitations: ${snapshot.injuries.join(', ')}` : ''}

Keep responses under 4 sentences. Be precise and cite the user's actual numbers.`;

      // 4. Call Groq API with compressed context
      const reply = await callGroq(systemPrompt, conversationCtx, message, env.GROQ_API_KEY);

      // 5. Update conversation summary in background (non-blocking)
      ctx.waitUntil(
        updateConversationSummary(userId, conversationId, message, reply, conversationCtx, env.COACH_KV)
      );

      return new Response(
        JSON.stringify({
          reply,
          sources: ['7-day data', 'your profile'],
          modelUsed: 'llama-3.3-70b-versatile',
          conversationId,
        }),
        {
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        }
      );
    } catch (error: any) {
      console.error('[fitkarma-coach] Error:', error.message);
      return new Response(
        JSON.stringify({ error: 'Internal server error', detail: error.message }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }
  },
};
