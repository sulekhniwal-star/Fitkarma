/**
 * Webhooks Handlers — RevenueCat, WhatsApp Business, etc.
 */
const { handleRevenueCatEvent, computeEntitlementHash, PRODUCT_TIER_MAP } = require('./revenuecat');

module.exports = {
  handleRevenueCatEvent,
  computeEntitlementHash,
  PRODUCT_TIER_MAP
};
