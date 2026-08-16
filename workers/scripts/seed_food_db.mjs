#!/usr/bin/env node
/**
 * workers/scripts/seed_food_db.mjs
 *
 * Seeds the D1 food_references table with data from food_references_seed.json.
 * Uses the Cloudflare D1 REST API to batch-insert in 500-row chunks.
 *
 * Prerequisites:
 *   - Run migration 0002_food_references.sql first via wrangler
 *   - Set env vars: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID
 *   - Run ETL script first: python Food-db/scripts/build_food_db.py
 *
 * Usage:
 *   node workers/scripts/seed_food_db.mjs --env staging
 *   node workers/scripts/seed_food_db.mjs --env production
 *   node workers/scripts/seed_food_db.mjs --env dev          (local wrangler dev)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// ── Config ────────────────────────────────────────────────────────────────────
const ENV_ARG = process.argv.find(a => a.startsWith('--env='))?.split('=')[1]
  ?? process.argv[process.argv.indexOf('--env') + 1]
  ?? 'staging';

// DB IDs: prefer GitHub secret env vars, fall back to wrangler.toml values.
// Add CF_D1_DB_ID_STAGING and CF_D1_DB_ID_PRODUCTION to your GitHub repo secrets.
const DB_IDS = {
  dev:        process.env.CF_D1_DB_ID_STAGING    ?? '39cc4384-437f-44d8-939c-65325dff0fa7',
  staging:    process.env.CF_D1_DB_ID_STAGING    ?? '39cc4384-437f-44d8-939c-65325dff0fa7',
  production: process.env.CF_D1_DB_ID_PRODUCTION ?? 'bd8e12fe-2f17-4d42-a847-930d41f90fd5',
};

const DB_ID = DB_IDS[ENV_ARG];
if (!DB_ID) {
  console.error(`Unknown env "${ENV_ARG}". Use: dev | staging | production`);
  process.exit(1);
}

const API_TOKEN  = process.env.CLOUDFLARE_API_TOKEN;
const ACCOUNT_ID = process.env.CLOUDFLARE_ACCOUNT_ID;

if (!API_TOKEN || !ACCOUNT_ID) {
  console.error('Missing env vars: CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are required.');
  console.error('In CI: these come from GitHub secrets automatically.');
  console.error('Locally: set them in your shell before running this script.');
  process.exit(1);
}

const SEED_FILE = path.resolve(__dirname, '../../Food-db/output/food_references_seed.json');
if (!fs.existsSync(SEED_FILE)) {
  console.error(`Seed file not found: ${SEED_FILE}`);
  console.error('Run first: python Food-db/scripts/build_food_db.py');
  process.exit(1);
}

const BATCH_SIZE = 500;
const D1_API_BASE = `https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/d1/database/${DB_ID}/query`;

// ── Helpers ───────────────────────────────────────────────────────────────────
function esc(s) {
  return String(s ?? '').replace(/'/g, "''");
}

async function executeSQL(sql) {
  const response = await fetch(D1_API_BASE, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${API_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ sql }),
  });
  const data = await response.json();
  if (!response.ok || !data.success) {
    throw new Error(`D1 API error: ${JSON.stringify(data.errors ?? data)}`);
  }
  return data;
}

async function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

// ── Main ──────────────────────────────────────────────────────────────────────
async function main() {
  console.log(`\n🍛 FitKarma Food DB Seeder`);
  console.log(`   Target env:  ${ENV_ARG}`);
  console.log(`   D1 database: ${DB_ID}`);
  console.log(`   Seed file:   ${SEED_FILE}\n`);

  const items = JSON.parse(fs.readFileSync(SEED_FILE, 'utf-8'));
  console.log(`📦 Loaded ${items.length} food items from seed file`);

  // Clear existing data
  console.log('🗑️  Clearing existing food_references rows...');
  await executeSQL('DELETE FROM food_references;');
  // Also clear FTS index
  await executeSQL('DELETE FROM food_fts;').catch(() => {
    // FTS might auto-clear via triggers; ignore error
  });

  // Batch insert
  const totalBatches = Math.ceil(items.length / BATCH_SIZE);
  let insertedTotal = 0;

  for (let b = 0; b < totalBatches; b++) {
    const batch = items.slice(b * BATCH_SIZE, (b + 1) * BATCH_SIZE);
    const vals = batch.map(item =>
      `('${esc(item.foodId)}','${esc(item.foodName)}','${esc(item.defaultServing)}',` +
      `${item.calories},${item.proteinG},${item.carbsG},${item.fatG},` +
      `${item.glycemicIndex},${item.fiberG},${item.satietyIndex},` +
      `'${esc(item.category)}','${esc(item.region)}',` +
      `${item.servingGrams},'${esc(item.sourceTag)}')`
    ).join(',\n');

    const sql =
      `INSERT INTO food_references ` +
      `(foodId,foodName,defaultServing,calories,proteinG,carbsG,fatG,` +
      `glycemicIndex,fiberG,satietyIndex,category,region,servingGrams,sourceTag) ` +
      `VALUES\n${vals};`;

    try {
      await executeSQL(sql);
      insertedTotal += batch.length;
      const pct = Math.round((insertedTotal / items.length) * 100);
      process.stdout.write(`\r   Batch ${b + 1}/${totalBatches} — ${insertedTotal}/${items.length} rows (${pct}%)`);
    } catch (err) {
      console.error(`\n❌ Batch ${b + 1} failed: ${err.message}`);
      process.exit(1);
    }

    // Small delay to avoid rate-limiting on free tier
    if (b < totalBatches - 1) await sleep(200);
  }

  console.log(`\n\n✅ Seeding complete — ${insertedTotal} rows inserted into food_references`);

  // Verify count
  const countRes = await executeSQL('SELECT COUNT(*) as total FROM food_references;');
  const total = countRes.result?.[0]?.results?.[0]?.total ?? '?';
  console.log(`✅ Verification: ${total} rows in food_references table`);
  console.log(`\nNext step: deploy the /food-db Worker with 'wrangler deploy --env ${ENV_ARG}'\n`);
}

main().catch(err => {
  console.error('\n❌ Fatal error:', err.message);
  process.exit(1);
});
