/// <reference types="@cloudflare/workers-types" />

import { getCached, setCached, hashPrompt } from '../shared/aiCache';
import { callGroq } from '../shared/groq';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
  ENVIRONMENT?: string;
}

export interface UserDueRow {
  localId: string;
  name: string;
  timezoneOffsetMinutes: number;
  preferredDIPHour: number;
  goals: string;
  dietType: string;
  tone: string;
}

/**
 * Returns users whose local hour matches their preferredDIPHour in the current 15-min window
 */
export async function getUsersDueForDIP(db: D1Database, nowUtc: Date = new Date()): Promise<UserDueRow[]> {
  const { results: allUsers } = await db
    .prepare(
      `SELECT localId, name, timezoneOffsetMinutes, preferredDIPHour, goals, dietType, tone
       FROM users`
    )
    .all<UserDueRow>();

  const currentUtcMinutes = nowUtc.getUTCHours() * 60 + nowUtc.getUTCMinutes();

  return allUsers.filter(u => {
    // User local time in minutes of day (0..1439)
    const userLocalMinutes = (currentUtcMinutes + u.timezoneOffsetMinutes + 1440) % 1440;
    const userLocalHour = Math.floor(userLocalMinutes / 60);
    return userLocalHour === u.preferredDIPHour;
  });
}

/**
 * Health OS Fan-out Step: Generates DIP for an individual user with error isolation
 */
export async function generateDIPForUser(user: UserDueRow, env: Env): Promise<{ userId: string; status: string; dip?: any }> {
  try {
    const prompt = `Generate Daily Intelligence Package for ${user.name}. Goals: ${user.goals}, Diet: ${user.dietType}, Tone: ${user.tone}. Output JSON format.`;
    const promptHash = await hashPrompt(prompt);

    // Step 1: Check AI cache
    const cached = await getCached(env.DB, user.localId, promptHash);
    if (cached) {
      return { userId: user.localId, status: 'cached', dip: JSON.parse(cached) };
    }

    // Step 2: Groq LLaMA 3.1 70B call
    const groqRes = await callGroq({
      apiKey: env.GROQ_API_KEY,
      model: 'llama-3.1-70b-versatile',
      messages: [
        {
          role: 'system',
          content: `You are the FitKarma Health OS Brain. Generate a Daily Intelligence Package with primaryInsight, todaysMission, nutritionFocus, recoveryFocus, motivationMessage, adjustedCalories, adjustedProtein, adjustedHydrationL, recommendedIntensity, isRestDay.`,
        },
        { role: 'user', content: prompt },
      ],
      response_format: { type: 'json_object' },
      max_tokens: 350,
    });

    const parsedDIP = JSON.parse(groqRes.content);

    // Step 3: Store in D1
    const dipId = `dip_${user.localId}_${Date.now()}`;
    const today = new Date().toISOString().split('T')[0];

    await env.DB.prepare(`
      INSERT INTO daily_intelligence_packages (
        localId, userId, packageDate, primaryInsight, todaysMission,
        nutritionFocus, recoveryFocus, motivationMessage, adjustedCalories,
        adjustedProtein, adjustedHydrationL, recommendedIntensity, isRestDay,
        activeRisks, showFestivalBanner, dietBreakActive, proteinTimingTarget,
        loggingReliabilityStatus, satietyTargetScore, aiCallsUsed
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      dipId,
      user.localId,
      today,
      parsedDIP.primaryInsight ?? 'Focus on balanced macros today.',
      parsedDIP.todaysMission ?? 'Complete 30 min morning walk.',
      parsedDIP.nutritionFocus ?? 'High protein lunch.',
      parsedDIP.recoveryFocus ?? '8 hours sleep target.',
      parsedDIP.motivationMessage ?? 'One rep at a time.',
      parsedDIP.adjustedCalories ?? 2200,
      parsedDIP.adjustedProtein ?? 120,
      parsedDIP.adjustedHydrationL ?? 3.0,
      parsedDIP.recommendedIntensity ?? 'moderate',
      parsedDIP.isRestDay ? 1 : 0,
      '[]',
      0,
      0,
      25,
      'high',
      70,
      1
    ).run();

    // Step 4: Cache for 24h
    await setCached(env.DB, user.localId, promptHash, groqRes.content, 24);

    return { userId: user.localId, status: 'generated', dip: parsedDIP };
  } catch (err: any) {
    console.error(`[Health OS Fan-out] Failed for user ${user.localId}: ${err.message}`);
    return { userId: user.localId, status: 'error', dip: null };
  }
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    const dueUsers = await getUsersDueForDIP(env.DB);
    console.log(`[Health OS Workflows Fan-out] Processing ${dueUsers.length} eligible users at ${new Date().toISOString()}`);

    // Fan-out execution across users concurrently with per-user error isolation
    const results = await Promise.allSettled(
      dueUsers.map(user => generateDIPForUser(user, env))
    );

    console.log(`[Health OS Workflows Fan-out] Finished ${results.length} jobs.`);
  },

  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === '/health-os/sweep') {
      const dueUsers = await getUsersDueForDIP(env.DB);
      const results = await Promise.allSettled(
        dueUsers.map(user => generateDIPForUser(user, env))
      );
      return new Response(JSON.stringify({ swept: dueUsers.length, results }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    return new Response(
      JSON.stringify({
        service: 'fitkarma-health-os',
        status: 'operational',
        workflowFanOut: true,
        timezoneAwareScheduling: true,
      }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  },
};
