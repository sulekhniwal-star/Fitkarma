import 'package:flutter/foundation.dart';

/// Coach specialization areas in FitKarma marketplace
enum CoachSpecialty {
  hypertrophyStrength(
    name: 'Strength & Hypertrophy',
    regionalName: 'स्ट्रेंथ व वेट ट्रेनिंग',
  ),
  clinicalNutrition(
    name: 'Clinical Nutrition & Metabolic Health',
    regionalName: 'क्लिनिकल पोषण व मेटाबॉलिक स्वास्थ्य',
  ),
  ayurvedicVaidya(
    name: 'Ayurvedic Gut & Dosha Health',
    regionalName: 'आयुर्वेदिक पाचन व त्रिदोष संतुलन',
  ),
  yogaMobility(
    name: 'Ashtanga Yoga & Spinal Posture',
    regionalName: 'अष्टांग योग व मेरुदंड गतिशीलता',
  ),
  transformationFatLoss(
    name: 'Fat Loss & Desi Dietetics',
    regionalName: 'वजन नियंत्रण व संतुलित देसी आहार',
  );

  final String name;
  final String regionalName;

  const CoachSpecialty({
    required this.name,
    required this.regionalName,
  });
}

/// Type of marketplace offering
enum ListingType {
  structuredProgram(
    name: 'Structured Transformation Program',
    regionalName: 'संरचित फिटनेस प्रोग्राम (४-१२ सप्ताह)',
  ),
  oneOnOneConsultation(
    name: '1-on-1 Video Consultation',
    regionalName: 'व्यक्तिगत १-ऑन-१ वीडियो परामर्श',
  ),
  customDietProtocol(
    name: 'Personalized Macro & Meal Plan',
    regionalName: 'अनुकूलित आहार व पोषण योजना',
  );

  final String name;
  final String regionalName;

  const ListingType({
    required this.name,
    required this.regionalName,
  });
}

/// Verified Creator / Coach Profile
@immutable
class CoachProfile {
  final String coachId;
  final String name;
  final String title;
  final String regionalTitle;
  final List<CoachSpecialty> specialties;
  final String bio;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final int yearsExperience;
  final List<String> languages;
  final int totalStudents;

  const CoachProfile({
    required this.coachId,
    required this.name,
    required this.title,
    required this.regionalTitle,
    required this.specialties,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.yearsExperience,
    required this.languages,
    required this.totalStudents,
  });
}

/// An individual program, consultation, or diet listing
@immutable
class MarketplaceListing {
  final String listingId;
  final String coachId;
  final String coachName;
  final bool isCoachVerified;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final ListingType type;
  final CoachSpecialty specialty;
  final int priceInr;
  final int originalPriceInr;
  final int durationWeeksOrMinutes;
  final double rating;
  final int enrolledCount;
  final List<String> features;
  final List<String> regionalFeatures;
  final bool isFeatured;

  const MarketplaceListing({
    required this.listingId,
    required this.coachId,
    required this.coachName,
    required this.isCoachVerified,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.type,
    required this.specialty,
    required this.priceInr,
    required this.originalPriceInr,
    required this.durationWeeksOrMinutes,
    required this.rating,
    required this.enrolledCount,
    required this.features,
    required this.regionalFeatures,
    this.isFeatured = false,
  });

  int get discountPercent {
    if (originalPriceInr <= priceInr) return 0;
    return (((originalPriceInr - priceInr) / originalPriceInr) * 100).round();
  }
}

/// Marketplace order / enrollment
@immutable
class MarketplaceOrder {
  final String orderId;
  final String userId;
  final String listingId;
  final String coachId;
  final String listingTitle;
  final int amountPaidInr;
  final int coachPayoutInr;
  final int platformFeeInr;
  final DateTime purchasedAt;
  final String status; // 'active', 'completed', 'refunded'

  const MarketplaceOrder({
    required this.orderId,
    required this.userId,
    required this.listingId,
    required this.coachId,
    required this.listingTitle,
    required this.amountPaidInr,
    required this.coachPayoutInr,
    required this.platformFeeInr,
    required this.purchasedAt,
    required this.status,
  });
}

/// Filter state for browsing marketplace
@immutable
class MarketplaceFilter {
  final CoachSpecialty? specialty;
  final ListingType? type;
  final int? maxPriceInr;
  final double minRating;
  final bool onlyVerified;
  final String searchQuery;

  const MarketplaceFilter({
    this.specialty,
    this.type,
    this.maxPriceInr,
    this.minRating = 0.0,
    this.onlyVerified = false,
    this.searchQuery = '',
  });

  MarketplaceFilter copyWith({
    CoachSpecialty? specialty,
    bool clearSpecialty = false,
    ListingType? type,
    bool clearType = false,
    int? maxPriceInr,
    bool clearMaxPrice = false,
    double? minRating,
    bool? onlyVerified,
    String? searchQuery,
  }) {
    return MarketplaceFilter(
      specialty: clearSpecialty ? null : (specialty ?? this.specialty),
      type: clearType ? null : (type ?? this.type),
      maxPriceInr: clearMaxPrice ? null : (maxPriceInr ?? this.maxPriceInr),
      minRating: minRating ?? this.minRating,
      onlyVerified: onlyVerified ?? this.onlyVerified,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
