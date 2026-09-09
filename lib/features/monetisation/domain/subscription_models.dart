import 'package:flutter/foundation.dart';

/// Subscription tier levels in FitKarma ecosystem
enum SubscriptionTier {
  free(
    id: 'free',
    name: 'FitKarma Free',
    regionalName: 'फिटकर्मा निःशुल्क',
    monthlyPriceInr: 0,
    annualPriceInr: 0,
    dailyAiCallsQuota: 10,
    accentColorValue: 0xFF94A3B8, // Slate
  ),
  pro(
    id: 'pro',
    name: 'FitKarma Pro',
    regionalName: 'फिटकर्मा प्रो',
    monthlyPriceInr: 499,
    annualPriceInr: 3999, // ~₹333/month
    dailyAiCallsQuota: 50,
    accentColorValue: 0xFF00E676, // Karma Green
  ),
  elite(
    id: 'elite',
    name: 'FitKarma Elite',
    regionalName: 'फिटकर्मा एलिट',
    monthlyPriceInr: 1499,
    annualPriceInr: 9999, // ~₹833/month
    dailyAiCallsQuota: 200,
    accentColorValue: 0xFFFFD700, // Gold
  );

  final String id;
  final String name;
  final String regionalName;
  final int monthlyPriceInr;
  final int annualPriceInr;
  final int dailyAiCallsQuota;
  final int accentColorValue;

  const SubscriptionTier({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.monthlyPriceInr,
    required this.annualPriceInr,
    required this.dailyAiCallsQuota,
    required this.accentColorValue,
  });

  bool get isPaid => this != SubscriptionTier.free;
}

/// Gated product features across the app
enum EntitlementFeature {
  aiCoachBasic(
    name: 'AI Coach Briefings & Advice',
    regionalName: 'एआई कोच दैनिक मार्गदर्शन',
    minimumTier: SubscriptionTier.free,
  ),
  bodyMetricsTracking(
    name: 'Body Metrics & Weight Analytics',
    regionalName: 'वजन व शारीरिक मेट्रिक्स विश्लेषण',
    minimumTier: SubscriptionTier.free,
  ),
  smartCalendarMicroWindows(
    name: 'Smart Calendar Micro-Windows',
    regionalName: 'स्मार्ट कैलेंडर सूक्ष्म स्वास्थ्य अंतराल',
    minimumTier: SubscriptionTier.free,
  ),
  wearableFreeComposition(
    name: 'Wearable-Free Body Composition AI',
    regionalName: 'बिना वियरेबल शरीर संरचना अनुमान',
    minimumTier: SubscriptionTier.pro,
  ),
  aiRoastMode(
    name: 'Desi AI Roast & Accountability Coach',
    regionalName: 'देसी एआई रोस्ट व अनुशासन कोच',
    minimumTier: SubscriptionTier.pro,
  ),
  travelFestivalIntelligence(
    name: 'Travel & Festival Feasting Protocols',
    regionalName: 'यात्रा व त्यौहार स्वास्थ्य अनुकूलन',
    minimumTier: SubscriptionTier.pro,
  ),
  weddingTransformation(
    name: 'Wedding 90-Day Silhouette Transformation',
    regionalName: 'विवाह ९०-दिवसीय कायाकल्प मोड',
    minimumTier: SubscriptionTier.pro,
  ),
  clinicalLabReportParsing(
    name: 'Comprehensive Blood/Lab Report OCR & Vision AI',
    regionalName: 'रक्त परीक्षण व मेडिकल रिपोर्ट ओसीआर विश्लेषण',
    minimumTier: SubscriptionTier.elite,
  ),
  humanCoachConsultations(
    name: 'Verified Human Coach Consultations & Marketplace',
    regionalName: 'प्रमाणित व्यक्तिगत कोच व सलाहकार सेवा',
    minimumTier: SubscriptionTier.elite,
  ),
  familyCircleSharing(
    name: 'Family Health Circle (Up to 5 members)',
    regionalName: 'पारिवारिक स्वास्थ्य समूह (५ सदस्य तक)',
    minimumTier: SubscriptionTier.elite,
  ),
  unlimitedDeepSynthesis(
    name: 'Uncapped Groq 70B Deep Weekly Synthesis',
    regionalName: 'अनलिमिटेड ७०बी एआई गहन साप्ताहिक विश्लेषण',
    minimumTier: SubscriptionTier.elite,
  );

  final String name;
  final String regionalName;
  final SubscriptionTier minimumTier;

  const EntitlementFeature({
    required this.name,
    required this.regionalName,
    required this.minimumTier,
  });
}

/// Subscription billing period
enum BillingCycle {
  monthly(name: 'Monthly', regionalName: 'मासिक', discountPercent: 0),
  annual(name: 'Annual (Save 33%)', regionalName: 'वार्षिक (३३% छूट)', discountPercent: 33);

  final String name;
  final String regionalName;
  final int discountPercent;

  const BillingCycle({
    required this.name,
    required this.regionalName,
    required this.discountPercent,
  });
}

/// Subscription status state
enum SubscriptionStatus {
  active,
  gracePeriod,
  pastDue,
  canceled,
  expired,
  sandboxTest,
}

/// User's verified entitlements representation
@immutable
class UserEntitlements {
  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime? expiresAt;
  final bool willRenew;
  final String? originalPurchaseTransactionId;
  final int dailyAiCallsUsed;
  final DateTime lastQuotaResetDate;
  final String serverVerificationHash; // Cryptographic hash from Cloud Functions
  final DateTime updatedAt;

  const UserEntitlements({
    required this.userId,
    required this.tier,
    required this.status,
    this.expiresAt,
    required this.willRenew,
    this.originalPurchaseTransactionId,
    required this.dailyAiCallsUsed,
    required this.lastQuotaResetDate,
    required this.serverVerificationHash,
    required this.updatedAt,
  });

  bool get isActive {
    if (tier == SubscriptionTier.free) return true;
    if (status == SubscriptionStatus.expired || status == SubscriptionStatus.pastDue) {
      return false;
    }
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) {
      return status == SubscriptionStatus.gracePeriod;
    }
    return true;
  }

  int get remainingDailyAiCalls {
    final remaining = tier.dailyAiCallsQuota - dailyAiCallsUsed;
    return remaining > 0 ? remaining : 0;
  }

  /// Default free tier entitlements
  factory UserEntitlements.free(String userId) {
    return UserEntitlements(
      userId: userId,
      tier: SubscriptionTier.free,
      status: SubscriptionStatus.active,
      expiresAt: null,
      willRenew: false,
      dailyAiCallsUsed: 0,
      lastQuotaResetDate: DateTime.now(),
      serverVerificationHash: 'free_tier_local_default',
      updatedAt: DateTime.now(),
    );
  }
}

/// Access evaluation result for a gated feature
@immutable
class EntitlementAccessResult {
  final bool isGranted;
  final EntitlementFeature feature;
  final SubscriptionTier requiredTier;
  final SubscriptionTier userTier;
  final String denialReason;
  final String regionalDenialReason;

  const EntitlementAccessResult({
    required this.isGranted,
    required this.feature,
    required this.requiredTier,
    required this.userTier,
    required this.denialReason,
    required this.regionalDenialReason,
  });

  factory EntitlementAccessResult.granted(EntitlementFeature feature, SubscriptionTier userTier) {
    return EntitlementAccessResult(
      isGranted: true,
      feature: feature,
      requiredTier: feature.minimumTier,
      userTier: userTier,
      denialReason: '',
      regionalDenialReason: '',
    );
  }

  factory EntitlementAccessResult.denied(
    EntitlementFeature feature,
    SubscriptionTier userTier, {
    String? customReason,
    String? regionalReason,
  }) {
    return EntitlementAccessResult(
      isGranted: false,
      feature: feature,
      requiredTier: feature.minimumTier,
      userTier: userTier,
      denialReason: customReason ??
          '${feature.name} requires ${feature.minimumTier.name}. Please upgrade to access this feature.',
      regionalDenialReason: regionalReason ??
          'इस सुविधा के लिए ${feature.minimumTier.regionalName} आवश्यक है। कृपया अपग्रेड करें।',
    );
  }
}
