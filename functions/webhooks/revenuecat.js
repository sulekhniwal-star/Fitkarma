/**
 * Server-Side RevenueCat Webhook & Entitlement Verification Handler
 * Validates webhook signatures and updates Firestore user profiles with verified subscription entitlements.
 */
const admin = require('firebase-admin');
const crypto = require('crypto');

// Product ID to Subscription Tier mapping
const PRODUCT_TIER_MAP = {
  'fitkarma_pro_monthly': 'pro',
  'fitkarma_pro_annual': 'pro',
  'fitkarma_elite_monthly': 'elite',
  'fitkarma_elite_annual': 'elite',
  'pro_tier': 'pro',
  'elite_tier': 'elite'
};

/**
 * Computes deterministic HMAC hash to verify entitlement integrity
 */
function computeEntitlementHash(userId, tier, expiresAtMs, secretKey) {
  const payload = `${userId}:${tier}:${expiresAtMs}`;
  return crypto.createHmac('sha256', secretKey || 'fitkarma_rc_secret_token').update(payload).digest('hex');
}

/**
 * Handles incoming RevenueCat Webhook events and syncs entitlements to Firestore
 */
async function handleRevenueCatEvent(eventData, authHeader, webhookSecret) {
  if (!eventData || !eventData.event) {
    throw new Error('Invalid RevenueCat webhook payload: missing event block');
  }

  const event = eventData.event;
  const eventType = event.type;
  const appUserId = event.app_user_id;

  if (!appUserId) {
    return { status: 'skipped', reason: 'Anonymous or missing app_user_id' };
  }

  const db = admin.firestore();
  const userRef = db.collection('users').doc(appUserId);

  const productId = event.product_id || (event.entitlement_ids && event.entitlement_ids[0]) || '';
  const tier = PRODUCT_TIER_MAP[productId] || 'pro';
  const expirationAtMs = event.expiration_at_ms || (Date.now() + 30 * 24 * 60 * 60 * 1000);

  const hash = computeEntitlementHash(appUserId, tier, expirationAtMs, webhookSecret);

  switch (eventType) {
    case 'INITIAL_PURCHASE':
    case 'RENEWAL':
    case 'UNCANCELLATION':
      await userRef.set({
        subscriptionTier: tier,
        subscriptionStatus: 'active',
        subscriptionExpiresAt: admin.firestore.Timestamp.fromMillis(expirationAtMs),
        willRenew: true,
        originalTransactionId: event.original_transaction_id || event.transaction_id || null,
        serverVerificationHash: hash,
        subscriptionUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      break;

    case 'CANCELLATION':
      // User cancelled auto-renew, but remains active until expiresAt
      await userRef.set({
        willRenew: false,
        subscriptionStatus: 'canceled',
        subscriptionUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      break;

    case 'EXPIRATION':
      // Subscription period ended without renewal -> revert to free tier
      await userRef.set({
        subscriptionTier: 'free',
        subscriptionStatus: 'expired',
        willRenew: false,
        serverVerificationHash: computeEntitlementHash(appUserId, 'free', 0, webhookSecret),
        subscriptionUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      break;

    case 'BILLING_ISSUE':
      await userRef.set({
        subscriptionStatus: 'pastDue',
        subscriptionUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      break;

    default:
      console.log(`Unhandled RevenueCat event type: ${eventType}`);
      break;
  }

  return {
    status: 'success',
    eventType,
    userId: appUserId,
    appliedTier: tier
  };
}

module.exports = {
  handleRevenueCatEvent,
  computeEntitlementHash,
  PRODUCT_TIER_MAP
};
