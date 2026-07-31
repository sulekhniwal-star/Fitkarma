/// <reference types="@cloudflare/workers-types" />

// §P3-C Proactive Insights Worker — Event-Driven, NOT Daily Polling
// Strategy: At 6am IST, check AI trigger thresholds per user.
//           Only generate insight if threshold crossed — skip LLM call otherwise.
// Trigger: Cron schedule (0 0 30 * * for 6am IST / 00:30 UTC)

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
  INSIGHTS_KV: KVNamespace; // Store generated insights per user
}

interface AITrigger {
  userId: string;
  triggerType: 'protein_deficit' | 'sleep_debt_excess' | 'plateau' | 'illness_risk';
  value: number;
  threshold: number;
}

interface UserHealthData {
  userId: string;
  name: string;
  avgProtein7d: number;
  proteinTarget: number;
  sleepDebtHours: number;
  plateauWeeks: number;
  readinessScore: number;
  rhrDeltaBpm: number;
  hrv7dRatio: number;
}

// §P3-C: Check event trigger thresholds — returns null if no insight needed today
function checkAITrigger(user: UserHealthData): AITrigger | null {
  // Illness risk: RHR >10% above baseline AND HRV <85% of baseline
  if (user.rhrDeltaBpm >= 7 && user.hrv7dRatio <= 0.85) {
    return {
      userId: user.userId,
      triggerType: 'illness_risk',
      value: user.rhrDeltaBpm,
      threshold: 7,
    };
  }

  // Sleep debt excess: >3h accumulated debt
  if (user.sleepDebtHours >= 3.0) {
    return {
      userId: user.userId,
      triggerType: 'sleep_debt_excess',
      value: user.sleepDebtHours,
      threshold: 3.0,
    };
  }

  // Protein deficit: <70% of target for 5+ days
  if (user.avgProtein7d < user.proteinTarget * 0.70) {
    return {
      userId: user.userId,
      triggerType: 'protein_deficit',
      value: user.avgProtein7d,
      threshold: user.proteinTarget * 0.70,
    };
  }

  // Plateau: >3 consecutive weeks without weight/metric change
  if (user.plateauWeeks >= 3) {
    return {
      userId: user.userId,
      triggerType: 'plateau',
      value: user.plateauWeeks,
      threshold: 3,
    };
  }

  return null; // No insight needed today — skip LLM call entirely
}

// Generate a data-grounded, targeted insight (§P3-A guardrails enforced)
async function generateTargetedInsight(
  trigger: AITrigger,
  user: UserHealthData,
  apiKey: string
): Promise<string> {
  const promptMap: Record<string, string> = {
    protein_deficit: `User ${user.name} has averaged only ${user.avgProtein7d}g protein for 7 days against a target of ${user.proteinTarget}g. Generate a 2-sentence, specific nudge referencing these exact numbers and suggest an Indian meal item (paneer, moong dal, chana). Do NOT give generic advice.`,
    sleep_debt_excess: `User ${user.name} has accumulated ${user.sleepDebtHours.toFixed(1)}h sleep debt with readiness score ${user.readinessScore}/100. Generate a 2-sentence actionable bedtime nudge referencing these numbers.`,
    plateau: `User ${user.name} has plateaued for ${trigger.value} weeks. Calorie target needs recalibration. Generate a 2-sentence insight referencing plateau duration and suggesting a 100 kcal deficit adjustment.`,
    illness_risk: `User ${user.name}'s RHR is elevated +${user.rhrDeltaBpm} bpm and HRV is at ${(user.hrv7dRatio * 100).toFixed(0)}% of baseline. Generate a 2-sentence wellness alert advising mandatory rest and reduced training load.`,
  };

  const prompt = promptMap[trigger.triggerType];
  if (!prompt) return '';

  const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'llama-3.1-8b-instant', // Tiny model — insights are short and structured
      messages: [
        {
          role: 'system',
          content: 'You are FitKarma\'s AI coach generating short, data-grounded health insights. NEVER give generic advice. Always reference specific numbers.',
        },
        { role: 'user', content: prompt },
      ],
      max_tokens: 150,
    }),
  });

  if (!response.ok) throw new Error(`Groq error: ${response.status}`);
  const data = await response.json() as any;
  return data.choices?.[0]?.message?.content ?? '';
}

export default {
  // Cron trigger: 6am IST = 00:30 UTC
  async scheduled(_event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    console.log('[fitkarma-insights] Starting event-driven proactive insights run...');

    // Fetch active users with their compressed health data
    const { results: activeUsers } = await env.DB.prepare(`
      SELECT
        u.user_id,
        u.name,
        hs.avg_protein_7d,
        hs.protein_target,
        hs.sleep_debt_hours,
        hs.plateau_weeks,
        hs.readiness_score,
        hs.rhr_delta_bpm,
        hs.hrv_7d_ratio
      FROM users u
      JOIN health_snapshots hs ON hs.user_id = u.user_id
      WHERE u.is_active = 1
        AND hs.created_at >= datetime('now', '-1 day')
    `).all();

    console.log(`[fitkarma-insights] Checking ${activeUsers.length} active users...`);

    let insightsGenerated = 0;
    let usersSkipped = 0;

    for (const row of activeUsers) {
      const user: UserHealthData = {
        userId: row.user_id as string,
        name: row.name as string,
        avgProtein7d: row.avg_protein_7d as number,
        proteinTarget: row.protein_target as number,
        sleepDebtHours: row.sleep_debt_hours as number,
        plateauWeeks: row.plateau_weeks as number,
        readinessScore: row.readiness_score as number,
        rhrDeltaBpm: row.rhr_delta_bpm as number,
        hrv7dRatio: row.hrv_7d_ratio as number,
      };

      // §P3-C: Event-driven — skip LLM call if no threshold crossed
      const trigger = checkAITrigger(user);
      if (!trigger) {
        usersSkipped++;
        continue;
      }

      try {
        const insight = await generateTargetedInsight(trigger, user, env.GROQ_API_KEY);
        if (!insight) continue;

        // Store insight in KV (TTL: 24h — will be fetched on next app open)
        await env.INSIGHTS_KV.put(
          `insight:${user.userId}`,
          JSON.stringify({
            triggerType: trigger.triggerType,
            message: insight,
            generatedAt: new Date().toISOString(),
            urgency: trigger.triggerType === 'illness_risk' ? 'high' : 'medium',
          }),
          { expirationTtl: 60 * 60 * 24 }
        );

        insightsGenerated++;
      } catch (err) {
        console.error(`[fitkarma-insights] Failed for user ${user.userId}:`, err);
      }
    }

    console.log(
      `[fitkarma-insights] Done. Generated: ${insightsGenerated}, Skipped (no trigger): ${usersSkipped}`
    );
  },
};
