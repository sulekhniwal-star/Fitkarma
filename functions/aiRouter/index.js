/**
 * AI Routing Layer — Multi-Model Groq Router
 * Tiers: Tiny (classification), Medium (general coaching), Large (synthesis)
 */

const MODEL_TIERS = {
  TINY: 'llama-3.1-8b-instant',
  MEDIUM: 'llama-3.3-70b-versatile',
  LARGE: 'llama-3.3-70b-versatile'
};

async function routeAiRequest({ tier, messages, userId }) {
  // Skeleton AI router to be expanded in Phase 0 AI Routing feature
  const selectedModel = MODEL_TIERS[tier] || MODEL_TIERS.MEDIUM;
  return {
    modelUsed: selectedModel,
    routedAt: new Date().toISOString()
  };
}

module.exports = {
  MODEL_TIERS,
  routeAiRequest
};
