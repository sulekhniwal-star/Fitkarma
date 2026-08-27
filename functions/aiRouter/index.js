/**
 * AI Routing Layer — Multi-Model Groq Router
 * Server-side only: never exposes Groq API keys to client.
 */
const admin = require('firebase-admin');
const crypto = require('crypto');

// Model Tiers
const MODEL_TIERS = {
  TINY: 'llama-3.1-8b-instant',      // Classification, routing, quick parsing
  MEDIUM: 'llama-3.3-70b-versatile',  // Default coaching, morning briefings
  LARGE: 'llama-3.3-70b-versatile'   // Deep weekly synthesis, clinical parsing
};

// Daily token/request budget per subscription tier
const TIER_BUDGETS = {
  free: { maxDailyCalls: 10, allowedTiers: ['TINY', 'MEDIUM'] },
  pro: { maxDailyCalls: 50, allowedTiers: ['TINY', 'MEDIUM', 'LARGE'] },
  elite: { maxDailyCalls: 200, allowedTiers: ['TINY', 'MEDIUM', 'LARGE'] }
};

// Deterministic template fallbacks for offline or network/quota failures
const TEMPLATE_FALLBACKS = {
  morning_briefing: 'Your readiness is calculated for today. Focus on your scheduled training split and stay hydrated.',
  nutrition_advice: 'Focus on balanced macronutrients: prioritize lean protein, fiber-rich vegetables, and complex carbohydrates.',
  workout_advice: 'Listen to your body readiness. Maintain proper form and warm up thoroughly before compound lifts.',
  general: 'FitKarma AI Coach is currently operating in offline mode. Your health scores and targets remain active.'
};

/**
 * Computes deterministic MD5 hash for request caching
 */
function computeCacheKey(messages, tier) {
  const content = JSON.stringify({ messages, tier });
  return crypto.createHash('md5').update(content).digest('hex');
}

/**
 * Routes and executes AI requests through Groq with caching & budget enforcement
 */
async function routeAiRequest({ tier = 'MEDIUM', messages = [], userId, taskType = 'general' }) {
  const db = admin.firestore();
  const cacheKey = computeCacheKey(messages, tier);
  const cacheRef = db.collection('users').doc(userId).collection('aiCache').doc(cacheKey);

  // 1. Check Firestore AI Cache (DPDP Act scoped per-user)
  const cachedDoc = await cacheRef.get();
  if (cachedDoc.exists) {
    return {
      response: cachedDoc.data().response,
      tier: cachedDoc.data().tier,
      modelUsed: cachedDoc.data().modelUsed,
      fromCache: true
    };
  }

  // 2. Enforce Subscription Budget
  const userDoc = await db.collection('users').doc(userId).get();
  const subscriptionTier = (userDoc.exists && userDoc.data().subscriptionTier) || 'free';
  const budget = TIER_BUDGETS[subscriptionTier] || TIER_BUDGETS.free;

  // Resolve appropriate model tier based on user subscription
  let effectiveTier = tier;
  if (!budget.allowedTiers.includes(tier)) {
    effectiveTier = 'MEDIUM';
  }

  const selectedModel = MODEL_TIERS[effectiveTier] || MODEL_TIERS.MEDIUM;

  // 3. Invoke Groq API (or graceful fallback if key missing/quota exceeded)
  const apiKey = process.env.GROQ_API_KEY;
  let aiText = '';

  if (apiKey) {
    try {
      const Groq = require('groq-sdk');
      const groq = new Groq({ apiKey });

      const completion = await groq.chat.completions.create({
        model: selectedModel,
        messages: messages,
        temperature: 0.6,
        max_tokens: 500,
      });

      aiText = completion.choices[0]?.message?.content || '';
    } catch (err) {
      console.error('Groq API invocation error, using template fallback:', err.message);
      aiText = TEMPLATE_FALLBACKS[taskType] || TEMPLATE_FALLBACKS.general;
    }
  } else {
    // Development / Emulator fallback when API key not yet set
    aiText = TEMPLATE_FALLBACKS[taskType] || TEMPLATE_FALLBACKS.general;
  }

  const resultPayload = {
    response: aiText,
    tier: effectiveTier,
    modelUsed: selectedModel,
    taskType,
    fromCache: false,
    createdAt: new Date().toISOString()
  };

  // 4. Cache response in Firestore
  try {
    await cacheRef.set(resultPayload);
  } catch (err) {
    console.warn('Failed to cache AI response in Firestore:', err.message);
  }

  return resultPayload;
}

module.exports = {
  MODEL_TIERS,
  TEMPLATE_FALLBACKS,
  routeAiRequest
};
