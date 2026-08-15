/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const method = request.method;
    const action = url.searchParams.get('action');
    const userId = request.headers.get('x-user-id') || 'usr_client_1';

    // 1. Coach Matchmaking
    if (method === 'GET' && action === 'match') {
      const user = await env.DB.prepare(
        'SELECT localId, name, goals, dietType FROM users WHERE localId = ?'
      ).bind(userId).first();

      const { results: coaches } = await env.DB.prepare(
        'SELECT creatorId, name, bio, specialties, rating, rateInr FROM creator_profiles'
      ).all();

      return new Response(JSON.stringify({ user, coaches }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // 2. Hire Coach
    if (method === 'POST' && action === 'hire') {
      const body = (await request.json().catch(() => ({}))) as Record<string, any>;
      const { coachId } = body;

      const relationshipId = `rel_${Date.now()}_${coachId}_${userId}`;
      return new Response(
        JSON.stringify({ success: true, relationshipId, message: 'Coach hired with 80/20 platform split' }),
        { headers: { 'Content-Type': 'application/json' } }
      );
    }

    // 3. Creator Affiliate & Coaching Payouts with Double-Entry Ledger
    if (method === 'POST' && action === 'payout') {
      const body = (await request.json().catch(() => ({}))) as Record<string, any>;
      const { creatorId, amountInr } = body;
      const payoutAmount = amountInr ?? 5000.0;
      const txId = `tx_payout_${Date.now()}_${creatorId}`;

      // Insert double-entry ledger records (Debit CreatorPayable, Credit CashAsset)
      await env.DB.batch([
        env.DB.prepare(`
          INSERT INTO marketplace_ledger_entries (entryId, transactionId, walletId, accountType, debit, credit, memo)
          VALUES (?, ?, ?, 'creatorPayable', ?, 0.0, 'Creator monthly payout debit')
        `).bind(`entry_${Date.now()}_1`, txId, `wallet_${creatorId}`, payoutAmount),
        env.DB.prepare(`
          INSERT INTO marketplace_ledger_entries (entryId, transactionId, walletId, accountType, debit, credit, memo)
          VALUES (?, ?, ?, 'cashAsset', 0.0, ?, 'Cash disbursement payout credit')
        `).bind(`entry_${Date.now()}_2`, txId, `wallet_${creatorId}`, payoutAmount),
      ]);

      return new Response(
        JSON.stringify({ success: true, transactionId: txId, processedAmount: payoutAmount }),
        { headers: { 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ service: 'fitkarma-marketplace', status: 'operational' }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  },
};
