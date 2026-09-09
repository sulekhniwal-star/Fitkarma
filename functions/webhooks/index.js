/**
 * Webhooks Handlers — RevenueCat, WhatsApp Business, etc.
 */
const { handleRevenueCatEvent, computeEntitlementHash, PRODUCT_TIER_MAP } = require('./revenuecat');
const { verifyWhatsAppWebhook, handleWhatsAppWebhookEvent, WHATSAPP_VERIFY_TOKEN } = require('./whatsapp');

module.exports = {
  handleRevenueCatEvent,
  computeEntitlementHash,
  PRODUCT_TIER_MAP,
  verifyWhatsAppWebhook,
  handleWhatsAppWebhookEvent,
  WHATSAPP_VERIFY_TOKEN,
};
