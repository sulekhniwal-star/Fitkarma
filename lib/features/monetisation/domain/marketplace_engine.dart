import 'package:flutter/foundation.dart';
import 'marketplace_models.dart';

/// Pure Dart Deterministic Engine for Marketplace Filtering, Search & Revenue Splitting
class MarketplaceEngine {
  const MarketplaceEngine();

  /// Filters marketplace listings deterministically based on user query & filters
  List<MarketplaceListing> filterListings({
    required List<MarketplaceListing> listings,
    required MarketplaceFilter filter,
  }) {
    return listings.where((listing) {
      // 1. Specialty filter
      if (filter.specialty != null && listing.specialty != filter.specialty) {
        return false;
      }

      // 2. Listing Type filter
      if (filter.type != null && listing.type != filter.type) {
        return false;
      }

      // 3. Max Price filter
      if (filter.maxPriceInr != null &&
          listing.priceInr > filter.maxPriceInr!) {
        return false;
      }

      // 4. Min Rating filter
      if (listing.rating < filter.minRating) {
        return false;
      }

      // 5. Verified Coach filter
      if (filter.onlyVerified && !listing.isCoachVerified) {
        return false;
      }

      // 6. Search query
      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.trim().toLowerCase();
        final matchTitle = listing.title.toLowerCase().contains(query);
        final matchCoach = listing.coachName.toLowerCase().contains(query);
        final matchDesc = listing.description.toLowerCase().contains(query);
        final matchRegional =
            listing.regionalTitle.toLowerCase().contains(query);
        if (!matchTitle && !matchCoach && !matchDesc && !matchRegional) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Calculates revenue split between creator (80%) and FitKarma platform (20%)
  RevenueSplit calculateRevenueSplit({
    required int priceInr,
    double platformFeeFraction = 0.20,
  }) {
    final platformFee = (priceInr * platformFeeFraction).round();
    final coachPayout = priceInr - platformFee;
    return RevenueSplit(
      amountPaidInr: priceInr,
      coachPayoutInr: coachPayout,
      platformFeeInr: platformFee,
    );
  }

  /// Creates a validated order record
  MarketplaceOrder createOrder({
    required String userId,
    required MarketplaceListing listing,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();
    final split = calculateRevenueSplit(priceInr: listing.priceInr);

    return MarketplaceOrder(
      orderId: 'ord_${now.millisecondsSinceEpoch}',
      userId: userId,
      listingId: listing.listingId,
      coachId: listing.coachId,
      listingTitle: listing.title,
      amountPaidInr: split.amountPaidInr,
      coachPayoutInr: split.coachPayoutInr,
      platformFeeInr: split.platformFeeInr,
      purchasedAt: now,
      status: 'active',
    );
  }

  /// Sample Pan-Indian Verified Creator & Coach Marketplace Catalog
  static List<MarketplaceListing> sampleCatalog() {
    return const [
      MarketplaceListing(
        listingId: 'list_1',
        coachId: 'coach_vikram',
        coachName: 'Coach Vikram Rawat (CSCS)',
        isCoachVerified: true,
        title: '12-Week Desi Muscle Hypertrophy & Recomposition',
        regionalTitle: '१२-सप्ताह देसी स्ट्रेंथ व मसल बिल्डिंग प्रोग्राम',
        description:
            'Periodized barbell, dumbbell, and calisthenics training with vegetarian & non-veg Indian macro meal plans.',
        regionalDescription:
            'शाकाहारी व मांसाहारी देसी डाइट चार्ट के साथ वैज्ञानिक स्ट्रेंथ ट्रेनिंग।',
        type: ListingType.structuredProgram,
        specialty: CoachSpecialty.hypertrophyStrength,
        priceInr: 2499,
        originalPriceInr: 4999,
        durationWeeksOrMinutes: 12,
        rating: 4.9,
        enrolledCount: 342,
        features: [
          '5-day Upper/Lower + PPL split',
          'High-protein Indian meal templates (paneer/eggs/soya)',
          'Form check video feedback',
          'Deload & fatigue management protocol',
        ],
        regionalFeatures: [
          '५-दिवसीय पीपीएल वर्कआउट विभाजन',
          'उच्च प्रोटीन भारतीय भोजन योजना',
          'व्यायाम फॉर्म जांच व वीडियो समीक्षा',
        ],
        isFeatured: true,
      ),
      MarketplaceListing(
        listingId: 'list_2',
        coachId: 'coach_priya',
        coachName: 'Dr. Priya Sen (Clinical Dietitian)',
        isCoachVerified: true,
        title: 'Metabolic Health & PCOS/Insulin Reversal Protocol',
        regionalTitle: 'पीसीओएस एवं इंसुलिन संतुलन क्लिनिकल डाइट प्रोग्राम',
        description:
            'Evidence-based hormonal balancing through low-glycemic Indian grains, seed cycling, and anti-inflammatory spices.',
        regionalDescription:
            'कम ग्लाइसेमिक भारतीय अनाजों व हार्मोन संतुलन आहार द्वारा पीसीओएस नियंत्रण।',
        type: ListingType.customDietProtocol,
        specialty: CoachSpecialty.clinicalNutrition,
        priceInr: 1999,
        originalPriceInr: 3499,
        durationWeeksOrMinutes: 8,
        rating: 4.8,
        enrolledCount: 512,
        features: [
          'Low-GI millet & whole grain guide',
          'Hormonal blood biomarker analysis',
          'Weekly metabolic check-in calls',
          'Supplements & micronutrient stack',
        ],
        regionalFeatures: [
          'मिलेट्स व मोटे अनाज की रेसिपी गाइड',
          'रक्त रिपोर्ट विश्लेषण व मार्गदर्शन',
          'साप्ताहिक स्वास्थ्य प्रगति समीक्षा',
        ],
        isFeatured: true,
      ),
      MarketplaceListing(
        listingId: 'list_3',
        coachId: 'coach_anand',
        coachName: 'Vaidya Anand Sharma (BAMS, Kerala)',
        isCoachVerified: true,
        title: '30-Day Agni & Gut Detox (Ayurvedic Protocol)',
        regionalTitle: '३०-दिवसीय जठराग्नि व आंत डिटॉक्स आयुर्वेदिक पद्धति',
        description:
            'Deep digestive reset, eliminating Ama (toxins) through seasonal Ritucharya and customized herbal churnas.',
        regionalDescription:
            'ऋतुचर्या व आयुर्वेदिक जड़ी-बूटियों द्वारा आम दोष का निष्कासन व पाचन सुधार।',
        type: ListingType.structuredProgram,
        specialty: CoachSpecialty.ayurvedicVaidya,
        priceInr: 1499,
        originalPriceInr: 2499,
        durationWeeksOrMinutes: 4,
        rating: 4.95,
        enrolledCount: 780,
        features: [
          'Prakriti / Dosha questionnaire review',
          'Warm digestive kashayam protocols',
          'Dinacharya circadian optimization',
          'Triphala & ginger Agni booster timing',
        ],
        regionalFeatures: [
          'प्रकृति व दोष परीक्षण विश्लेषण',
          'दिनचर्या व पाचन काढ़ा नुस्खे',
          'त्रिफला व अदरक जठराग्नि वृद्धि समय',
        ],
        isFeatured: false,
      ),
      MarketplaceListing(
        listingId: 'list_4',
        coachId: 'coach_rohit',
        coachName: 'Coach Rohit Varma (Biomechanics Specialist)',
        isCoachVerified: true,
        title: '1-on-1 Video Biomechanics & Form Clinic (45 Min)',
        regionalTitle: '१-ऑन-१ वीडियो बायोमैकेनिक्स व पोस्चर परामर्श',
        description:
            'Live 1-on-1 video call assessing your squat, bench press, deadlift mechanics, and joint mobility restrictions.',
        regionalDescription:
            'लाइव वीडियो कॉल पर आपके व्यायाम पोस्चर और जोड़ों के लचीलेपन की विस्तृत जांच।',
        type: ListingType.oneOnOneConsultation,
        specialty: CoachSpecialty.hypertrophyStrength,
        priceInr: 999,
        originalPriceInr: 1800,
        durationWeeksOrMinutes: 45,
        rating: 4.9,
        enrolledCount: 195,
        features: [
          '45-minute live 1-on-1 Google Meet session',
          'Real-time barbell bar-path review',
          'Personalized mobility drill prescription',
          'Session recording & summary PDF',
        ],
        regionalFeatures: [
          '४५-मिनट लाइव वीडियो सत्र',
          'व्यायाम फॉर्म व बार-पाथ समीक्षा',
          'निजी मोबिलिटी ड्रिल पीडीएफ रिपोर्ट',
        ],
        isFeatured: false,
      ),
      MarketplaceListing(
        listingId: 'list_5',
        coachId: 'coach_ananya',
        coachName: 'Acharya Ananya Iyer (RYS 500)',
        isCoachVerified: true,
        title: 'Ashtanga Vinyasa & Spinal Mobility Mastery',
        regionalTitle: 'अष्टांग विन्यास योग व मेरुदंड लचीलापन कोर्स',
        description:
            'Comprehensive breath-synchronized asana sequence for desk workers suffering from upper cross syndrome and tight hips.',
        regionalDescription:
            'डेस्क जॉब वालों की पीठ दर्द व जकड़न दूर करने हेतु अष्टांग योग सत्र।',
        type: ListingType.structuredProgram,
        specialty: CoachSpecialty.yogaMobility,
        priceInr: 1299,
        originalPriceInr: 2199,
        durationWeeksOrMinutes: 6,
        rating: 4.85,
        enrolledCount: 420,
        features: [
          'Daily 25-min guided audio/video asana flows',
          'Pranayama & Kumbhaka breath control',
          'Hip opening & thoracic extension drills',
          'Ayurvedic oil self-massage routine',
        ],
        regionalFeatures: [
          'दैनिक २५-मिनट निर्देशित योगासन प्रवाह',
          'प्राणायाम व कुम्भक श्वास नियंत्रण',
          'हिप ओपनिंग व मेरुदंड विस्तार अभ्यास',
        ],
        isFeatured: false,
      ),
    ];
  }
}

/// Revenue Split Helper
@immutable
class RevenueSplit {
  final int amountPaidInr;
  final int coachPayoutInr;
  final int platformFeeInr;

  const RevenueSplit({
    required this.amountPaidInr,
    required this.coachPayoutInr,
    required this.platformFeeInr,
  });
}
