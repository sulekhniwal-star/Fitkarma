/**
 * Meta WhatsApp Business Cloud API Webhook Handler
 * Processes inbound user text/voice/media health logs and syncs with FitKarma Firestore
 */

const WHATSAPP_VERIFY_TOKEN = process.env.WHATSAPP_VERIFY_TOKEN || 'fitkarma_whatsapp_webhook_verify_secret';

/**
 * Handles GET Webhook Verification Handshake from Meta
 */
function verifyWhatsAppWebhook(query) {
  const mode = query['hub.mode'];
  const token = query['hub.verify_token'];
  const challenge = query['hub.challenge'];

  if (mode === 'subscribe' && token === WHATSAPP_VERIFY_TOKEN) {
    return { status: 200, challenge };
  }
  return { status: 403, error: 'Verification token mismatch' };
}

/**
 * Handles POST Webhook Events (Messages, Status Receipts)
 */
async function handleWhatsAppWebhookEvent(body, firestore) {
  if (body.object !== 'whatsapp_business_account') {
    return { status: 404, message: 'Not a whatsapp business event' };
  }

  const entries = body.entry || [];
  for (const entry of entries) {
    const changes = entry.changes || [];
    for (const change of changes) {
      if (change.field === 'messages') {
        const value = change.value;
        const messages = value.messages || [];

        for (const msg of messages) {
          const from = msg.from; // e.g. "919876543210"
          const normalizedPhone = from.startsWith('+') ? from : `+${from}`;
          const msgType = msg.type;
          let textBody = '';

          if (msgType === 'text') {
            textBody = msg.text.body;
          } else if (msgType === 'interactive') {
            textBody = msg.interactive.button_reply ? msg.interactive.button_reply.id : msg.interactive.list_reply.id;
          } else if (msgType === 'image') {
            textBody = 'Photo of meal received for vision analysis';
          }

          // If firestore instance is provided, save incoming message
          if (firestore) {
            // Find user by phone number
            const userSnap = await firestore
              .collection('users')
              .where('whatsappPhoneNumber', '==', normalizedPhone)
              .limit(1)
              .get();

            if (!userSnap.empty) {
              const userDoc = userSnap.docs[0];
              const userId = userDoc.id;

              await firestore
                .collection('users')
                .doc(userId)
                .collection('whatsappLogs')
                .add({
                  rawMessage: textBody,
                  msgType,
                  from: normalizedPhone,
                  receivedAt: new Date().toISOString(),
                  processed: true,
                });
            }
          }
        }
      }
    }
  }

  return { status: 200, received: true };
}

module.exports = {
  verifyWhatsAppWebhook,
  handleWhatsAppWebhookEvent,
  WHATSAPP_VERIFY_TOKEN,
};
