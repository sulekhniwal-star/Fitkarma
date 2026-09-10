import 'travel_mode_models.dart';

/// Pure Dart Deterministic Engine for Travel Intelligence, Jet Lag Mitigations, and Hotel Workouts
class TravelModeEngine {
  const TravelModeEngine();

  /// Compiles a complete travel intelligence plan and hotel room fitness adaptation
  TravelIntelligenceReport generateTravelPlan({
    required TravelContext context,
    String destinationCityOrTimezone = 'London (GMT)',
    int timezoneShiftHours = 5,
    bool isTravelModeActive = true,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    int stepGoal;
    int workoutMins;

    switch (context) {
      case TravelContext.flightTransit:
      case TravelContext.trainRoadTrip:
        stepGoal = 6000;
        workoutMins = 15;
        break;
      case TravelContext.hotelNoGym:
        stepGoal = 8000;
        workoutMins = 20;
        break;
      case TravelContext.hotelWithGym:
        stepGoal = 10000;
        workoutMins = 35;
        break;
      case TravelContext.internationalJetLag:
        stepGoal = 7000;
        workoutMins = 20;
        break;
    }

    final actionItems = _buildTravelActionItems(context, workoutMins);
    final (jetLag, regJetLag) = _getJetLagAdvice(context, timezoneShiftHours);
    final (vata, regVata) = _getVataBalancingRitual();
    final (dining, regDining) = _getDiningGuidance(context);

    return TravelIntelligenceReport(
      isTravelModeActive: isTravelModeActive,
      activeContext: context,
      destinationCityOrTimezone: destinationCityOrTimezone,
      timezoneShiftHours: timezoneShiftHours,
      adaptedStepGoal: stepGoal,
      hotelWorkoutDurationMinutes: workoutMins,
      activeTravelActions: actionItems,
      jetLagCircadianAdvice: jetLag,
      regionalJetLagAdvice: regJetLag,
      vataBalancingRitual: vata,
      regionalVataBalancingRitual: regVata,
      airportDhabaDiningTip: dining,
      regionalAirportDhabaDiningTip: regDining,
      generatedAt: now,
    );
  }

  List<TravelActionItem> _buildTravelActionItems(
      TravelContext context, int workoutMins) {
    return [
      TravelActionItem(
        category: 'Hotel Room Movement',
        title: '$workoutMins-Minute Minimalist Room Circuit',
        regionalTitle: '$workoutMins मिनट का कमरा आधारित व्यायाम',
        instruction:
            '3 rounds of: 15 Bodyweight Squats, 10 Bed Dips, 12 Pushups, 20 Mountain Climbers, and 45-sec Wall Sit.',
        regionalInstruction:
            '१५ उठक-बैठक, १० बेड डिप्स, १२ पुश-अप्स व दीवार के सहारे ४५ सेकंड बैठने का ३ बार अभ्यास करें।',
      ),
      const TravelActionItem(
        category: 'Anti-Edema & Circulation',
        title: '10-Minute Legs-Up-The-Wall (Viparita Karani)',
        regionalTitle: 'विपरीत करणी (पैरों को दीवार पर टिकाना)',
        instruction:
            'Lie on the hotel bed and rest your legs vertically against the wall for 10 minutes to drain lower leg venous fluid after prolonged sitting.',
        regionalInstruction:
            'यात्रा की थकान व पैरों की सूजन दूर करने हेतु १० मिनट पैरों को दीवार के सहारे ऊपर रखें।',
      ),
      const TravelActionItem(
        category: 'Hydration & Pressurized Air',
        title: 'Electrolyte Mineralization Protocol',
        regionalTitle: 'इलेक्ट्रोलाइट व जल संतुलन',
        instruction:
            'Drink 250ml water for every 1 hour in pressurized flight cabin. Avoid excessive caffeine and alcohol to prevent dehydration headaches.',
        regionalInstruction:
            'हवाई यात्रा के दौरान प्रति घंटा २५० मिली पानी पिएं तथा अत्यधिक कैफीन से बचें।',
      ),
    ];
  }

  (String, String) _getJetLagAdvice(TravelContext context, int shiftHours) {
    if (shiftHours.abs() >= 4 || context == TravelContext.internationalJetLag) {
      return (
        'Timezone Shift ($shiftHours hrs): Seek 20 minutes of bright morning sunlight immediately upon waking in destination. Match meal timing strictly to local destination hours.',
        'समय क्षेत्र परिवर्तन ($shiftHours घंटे): गंतव्य पर पहुंचकर सुबह २० मिनट की धूप लें और स्थानीय समय अनुसार ही भोजन करें।',
      );
    } else {
      return (
        'Domestic / Low Shift: Keep your core sleep anchor within 60 minutes of your home routine to maintain circadian stability.',
        'घरेलू यात्रा: नींद के समय को सामान्य दिनचर्या के ६० मिनट के भीतर ही रखें ताकि जैविक घड़ी संतुलित रहे।',
      );
    }
  }

  (String, String) _getVataBalancingRitual() {
    return (
      'Ayurvedic Vata Shield: Motion and air travel aggravate Vata (dryness & restlessness). Massage feet with warm sesame oil (Pada Abhyanga) before sleep and sip warm ginger-clove water.',
      'वात संतुलन नियम: यात्रा से वात दोष बढ़ता है। रात्रि में पैरों के तलवों की तिल के तेल से मालिश (पाद अभ्यंग) करें और अदरक-लौंग का गुनगुना पानी पिएं।',
    );
  }

  (String, String) _getDiningGuidance(TravelContext context) {
    switch (context) {
      case TravelContext.flightTransit:
        return (
          'Airport Sourcing: Opt for fresh Steamed Idli-Sambar, boiled eggs, or roasted chana/nuts. Avoid heavy creamy curries before boarding.',
          'हवाई अड्डा आहार: इडली-सांभर, उबले अंडे या भुने चने चुनें। भारी मलाईदार भोजन से बचें।',
        );
      case TravelContext.trainRoadTrip:
        return (
          'Highway Dhaba Guide: Choose Dal Tadka with Tandoori Roti (no butter) and a glass of salted Chaas (Buttermilk) for active digestive probiotics.',
          'ढाबा आहार: तंदूरी रोटी, दाल तड़का एवं छाछ का चयन करें जो पाचन में सुपाच्य हो।',
        );
      default:
        return (
          'Hotel Buffet Strategy: Fill half your plate with fresh grilled vegetables/paneer/eggs first before exploring carb options.',
          'होटल बुफे रणनीति: आधी थाली में पहले ग्रिल्ड सब्जियां, पनीर या अंडे लें, फिर अन्य व्यंजन।',
        );
    }
  }
}
