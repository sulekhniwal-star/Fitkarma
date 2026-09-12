import '../models/monetisation_models.dart';

class CoachMarketplaceEngine {
  const CoachMarketplaceEngine();

  /// Curated list of verified Indian health and fitness coaches
  List<CoachProfile> getAllVerifiedCoaches() {
    return const [
      CoachProfile(
        id: 'coach_ananya_01',
        name: 'Dr. Ananya Iyer',
        title: 'Clinical Nutritionist & PCOS Specialist',
        specialty: CoachSpecialty.pcosRemission,
        bio: '10+ years specializing in Indian dietary interventions, hormonal balance, and ovulation restoration through sattvic protocols.',
        languages: ['English', 'Hindi', 'Tamil'],
        rating: 4.95,
        reviewCount: 142,
        hourlyRateInr: 1499,
      ),
      CoachProfile(
        id: 'coach_raghav_02',
        name: 'Coach Raghavendra Rao',
        title: 'Ayurvedic Strength Coach & Akhada Master',
        specialty: CoachSpecialty.ayurvedicStrength,
        bio: 'Former national wrestler combining traditional Vyayam (Gada, Jori, Dand) with scientific progressive overload.',
        languages: ['English', 'Hindi', 'Telugu', 'Kannada'],
        rating: 4.88,
        reviewCount: 98,
        hourlyRateInr: 1199,
      ),
      CoachProfile(
        id: 'coach_priya_03',
        name: 'Dr. Priya Sharma, MBBS, MD',
        title: 'Metabolic Health & Diabetes Remission Expert',
        specialty: CoachSpecialty.diabetesReversal,
        bio: 'Evidence-based reversal of Type 2 Diabetes and NAFLD with CGM tracking and customized Indian macro distribution.',
        languages: ['English', 'Hindi', 'Punjabi'],
        rating: 4.98,
        reviewCount: 230,
        hourlyRateInr: 1999,
      ),
      CoachProfile(
        id: 'coach_kavita_04',
        name: 'Kavita Menon',
        title: 'Postpartum Core & Pelvic Floor Specialist',
        specialty: CoachSpecialty.postpartumRecovery,
        bio: 'Guiding new mothers through safe diastasis recti recovery, postpartum nourishing foods, and gentle yoga.',
        languages: ['English', 'Hindi', 'Malayalam'],
        rating: 4.92,
        reviewCount: 87,
        hourlyRateInr: 1299,
      ),
    ];
  }

  /// Filters coaches based on user condition, language, and budget
  List<CoachProfile> filterCoaches({
    CoachSpecialty? specialty,
    String? language,
    int? maxRateInr,
  }) {
    return getAllVerifiedCoaches().where((coach) {
      if (specialty != null && coach.specialty != specialty) return false;
      if (language != null && !coach.languages.contains(language)) return false;
      if (maxRateInr != null && coach.hourlyRateInr > maxRateInr) return false;
      return true;
    }).toList();
  }
}
