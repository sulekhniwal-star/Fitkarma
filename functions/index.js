const { onRequest, onCall } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

admin.initializeApp();

const { generateDailyIntelligencePackage } = require('./healthOS');
const { routeAiRequest } = require('./aiRouter');
const { handleRevenueCatEvent } = require('./webhooks');

// Callable: Generate or retrieve DIP
exports.getDailyIntelligence = onCall(async (request) => {
  if (!request.auth) {
    throw new Error('Unauthenticated user.');
  }
  const dateStr = request.data.date || new Date().toISOString().split('T')[0];
  return await generateDailyIntelligencePackage(request.auth.uid, dateStr);
});

// Callable: Routed AI Request
exports.askAiCoach = onCall(async (request) => {
  if (!request.auth) {
    throw new Error('Unauthenticated user.');
  }
  return await routeAiRequest({
    tier: request.data.tier || 'MEDIUM',
    messages: request.data.messages || [],
    userId: request.auth.uid
  });
});

// Webhook HTTPS endpoint: RevenueCat
exports.revenueCatWebhook = onRequest(async (req, res) => {
  try {
    const result = await handleRevenueCatEvent(req.body);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
