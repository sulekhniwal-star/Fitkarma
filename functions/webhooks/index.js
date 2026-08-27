/**
 * Webhooks Handlers — RevenueCat, WhatsApp Business, etc.
 */

async function handleRevenueCatEvent(eventData) {
  // Webhook event receiver for subscription status sync
  return { status: 'received' };
}

module.exports = {
  handleRevenueCatEvent
};
