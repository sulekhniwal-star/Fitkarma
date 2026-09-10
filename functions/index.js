const { onRequest, onCall } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

admin.initializeApp();

const { generateDailyIntelligencePackage } = require('./healthOS');
const { routeAiRequest } = require('./aiRouter');
const { handleRevenueCatEvent, verifyWhatsAppWebhook, handleWhatsAppWebhookEvent } = require('./webhooks');
const { deleteUserData } = require('./compliance/deleteUserData');

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

// Callable: DPDP Section 12 Right-to-Erasure cascading user data deletion
exports.deleteUserData = onCall(async (request) => {
  if (!request.auth) {
    throw new Error('Unauthenticated user.');
  }
  const userId = request.auth.uid;
  const reason = request.data.reason || 'USER_REQUESTED_ERASURE';
  return await deleteUserData(userId, reason);
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

// Webhook HTTPS endpoint: Meta WhatsApp Business Cloud API
exports.whatsappWebhook = onRequest(async (req, res) => {
  if (req.method === 'GET') {
    const verification = verifyWhatsAppWebhook(req.query);
    if (verification.status === 200) {
      res.status(200).send(verification.challenge);
    } else {
      res.status(verification.status).send(verification.error);
    }
  } else if (req.method === 'POST') {
    try {
      const result = await handleWhatsAppWebhookEvent(req.body, admin.firestore());
      res.status(result.status || 200).json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  } else {
    res.status(405).send('Method Not Allowed');
  }
});
