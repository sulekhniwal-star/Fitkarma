enum AbhaLinkStatus {
  unlinked,
  otpSent,
  linked,
  failed,
}

enum GroceryPlatform {
  blinkit,
  zepto,
  instamart,
}

class AbhaRecord {
  final String id;
  final String userId;
  final String abhaNumber; // 14-digit formatted: 12-3456-7890-1234
  final String abhaAddress; // user@abdm
  final bool isLinked;
  final String fhirSyncStatus;
  final DateTime createdAt;

  const AbhaRecord({
    required this.id,
    required this.userId,
    required this.abhaNumber,
    required this.abhaAddress,
    required this.isLinked,
    this.fhirSyncStatus = 'synced',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'abha_number': abhaNumber,
        'abha_address': abhaAddress,
        'is_linked': isLinked,
        'fhir_sync_status': fhirSyncStatus,
        'created_at': createdAt.toIso8601String(),
      };
}

class ParsedVernacularEntry {
  final String rawText;
  final String detectedLanguage; // 'hinglish', 'hindi', 'english', 'tamil'
  final String entryType; // 'meal', 'workout', 'symptom'
  final Map<String, dynamic> extractedEntities;
  final int confidencePct;

  const ParsedVernacularEntry({
    required this.rawText,
    required this.detectedLanguage,
    required this.entryType,
    required this.extractedEntities,
    required this.confidencePct,
  });
}

class CorporateTeamSummary {
  final String id;
  final String companyName;
  final String teamName;
  final String corporateCode;
  final double teamWellnessScore; // 0-100
  final int activeMembersCount;
  final double insurerDiscountPct;

  const CorporateTeamSummary({
    required this.id,
    required this.companyName,
    required this.teamName,
    required this.corporateCode,
    required this.teamWellnessScore,
    required this.activeMembersCount,
    required this.insurerDiscountPct,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_name': companyName,
        'team_name': teamName,
        'corporate_code': corporateCode,
        'team_wellness_score': teamWellnessScore,
        'active_members_count': activeMembersCount,
        'insurer_discount_pct': insurerDiscountPct,
      };
}

class QuickCommerceBasketItem {
  final String itemName;
  final String quantityString;
  final int blinkitPriceInr;
  final int zeptoPriceInr;
  final int instamartPriceInr;

  const QuickCommerceBasketItem({
    required this.itemName,
    required this.quantityString,
    required this.blinkitPriceInr,
    required this.zeptoPriceInr,
    required this.instamartPriceInr,
  });
}
