/// <reference types="@cloudflare/workers-types" />

/**
 * Computes a SHA-256 hash of the input prompt
 */
export async function hashPrompt(prompt: string): Promise<string> {
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(prompt));
  return [...new Uint8Array(digest)]
    .map(b => b.toString(16).padStart(2, '0'))
    .join('')
    .slice(0, 16);
}

/**
 * Retrieves cached AI response scoped by userId and promptHash (§DB-C / §CF)
 */
export async function getCached(
  db: D1Database,
  userId: string,
  promptHash: string
): Promise<string | null> {
  const row = await db
    .prepare(
      `SELECT response FROM ai_cache
       WHERE user_id = ? AND prompt_hash = ? AND expires_at > datetime('now')`
    )
    .bind(userId, promptHash)
    .first<{ response: string }>();

  return row?.response ?? null;
}

/**
 * Sets user-scoped AI cache entry with configurable TTL hours
 */
export async function setCached(
  db: D1Database,
  userId: string,
  promptHash: string,
  response: string,
  ttlHours = 24
): Promise<void> {
  const expires = new Date(Date.now() + ttlHours * 3600000).toISOString();
  const localId = `cache_${userId}_${promptHash}_${Date.now()}`;

  await db
    .prepare(
      `INSERT INTO ai_cache (localId, user_id, prompt_hash, response, expires_at)
       VALUES (?, ?, ?, ?, ?)
       ON CONFLICT(user_id, prompt_hash)
       DO UPDATE SET response = excluded.response, expires_at = excluded.expires_at`
    )
    .bind(localId, userId, promptHash, response, expires)
    .run();
}

/**
 * Purges all cached AI outputs derived from a user's data (DPDP Act right-to-erasure)
 */
export async function purgeCacheForUser(db: D1Database, userId: string): Promise<void> {
  await db.prepare('DELETE FROM ai_cache WHERE user_id = ?').bind(userId).run();
}
