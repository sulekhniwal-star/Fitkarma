import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitkarma/core/database/app_database.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Domain Models (§P1-F)
// ──────────────────────────────────────────────────────────────────────────────

enum DoshaType { vata, pitta, kapha }

class DoshaOption {
  const DoshaOption({
    required this.text,
    required this.textHindi,
    required this.associatedDosha,
  });

  final String text;
  final String textHindi;
  final DoshaType associatedDosha;
}

class DoshaQuestion {
  const DoshaQuestion({
    required this.id,
    required this.question,
    required this.questionHindi,
    required this.options,
  });

  final String id;
  final String question;
  final String questionHindi;
  final List<DoshaOption> options;
}

class DoshaGuidelines {
  const DoshaGuidelines({
    required this.dietaryFocus,
    required this.stressFocus,
    required this.recommendedSpices,
  });

  factory DoshaGuidelines.fromJson(Map<String, dynamic> json) => DoshaGuidelines(
        dietaryFocus: json['dietaryFocus'] as String,
        stressFocus: json['stressFocus'] as String,
        recommendedSpices: List<String>.from(json['recommendedSpices'] as List),
      );

  final String dietaryFocus;
  final String stressFocus;
  final List<String> recommendedSpices;

  Map<String, dynamic> toJson() => {
        'dietaryFocus': dietaryFocus,
        'stressFocus': stressFocus,
        'recommendedSpices': recommendedSpices,
      };
}

class DoshaResult {
  const DoshaResult({
    required this.dominant,
    required this.vataPct,
    required this.pittaPct,
    required this.kaphaPct,
    required this.guidelines,
  });

  factory DoshaResult.fromJson(Map<String, dynamic> json) {
    return DoshaResult(
      dominant: DoshaType.values.byName(json['dominant'] as String),
      vataPct: (json['vataPct'] as num).toDouble(),
      pittaPct: (json['pittaPct'] as num).toDouble(),
      kaphaPct: (json['kaphaPct'] as num).toDouble(),
      guidelines: DoshaGuidelines.fromJson(json['guidelines'] as Map<String, dynamic>),
    );
  }

  final DoshaType dominant;
  final double vataPct;
  final double pittaPct;
  final double kaphaPct;
  final DoshaGuidelines guidelines;

  Map<String, dynamic> toJson() => {
        'dominant': dominant.name,
        'vataPct': vataPct,
        'pittaPct': pittaPct,
        'kaphaPct': kaphaPct,
        'guidelines': guidelines.toJson(),
      };
}

// ──────────────────────────────────────────────────────────────────────────────
// Scoring Engine (Pure Dart - Deterministic)
// ──────────────────────────────────────────────────────────────────────────────

class DoshaQuizScoringEngine {
  const DoshaQuizScoringEngine();

  DoshaResult calculateDoshaProfile(Map<String, DoshaType> answers) {
    int vataScore = 0;
    int pittaScore = 0;
    int kaphaScore = 0;

    for (final dosha in answers.values) {
      switch (dosha) {
        case DoshaType.vata:
          vataScore++;
          break;
        case DoshaType.pitta:
          pittaScore++;
          break;
        case DoshaType.kapha:
          kaphaScore++;
          break;
      }
    }

    final total = vataScore + pittaScore + kaphaScore;
    if (total == 0) {
      return const DoshaResult(
        dominant: DoshaType.vata,
        vataPct: 33.3,
        pittaPct: 33.3,
        kaphaPct: 33.3,
        guidelines: DoshaGuidelines(
          dietaryFocus: "Balanced diet containing equal elements.",
          stressFocus: "Alternate nostril breathing (Nadi Shodhana).",
          recommendedSpices: ["Ginger", "Fennel"],
        ),
      );
    }

    final vataPct = double.parse(((vataScore / total) * 100).toStringAsFixed(1));
    final pittaPct = double.parse(((pittaScore / total) * 100).toStringAsFixed(1));
    final kaphaPct = double.parse(((kaphaScore / total) * 100).toStringAsFixed(1));

    DoshaType dominant = DoshaType.vata;
    double maxPct = vataPct;
    if (pittaPct > maxPct) {
      dominant = DoshaType.pitta;
      maxPct = pittaPct;
    }
    if (kaphaPct > maxPct) {
      dominant = DoshaType.kapha;
    }

    return DoshaResult(
      dominant: dominant,
      vataPct: vataPct,
      pittaPct: pittaPct,
      kaphaPct: kaphaPct,
      guidelines: _generateGuidelines(dominant),
    );
  }

  DoshaGuidelines _generateGuidelines(DoshaType dominant) {
    return switch (dominant) {
      DoshaType.vata => const DoshaGuidelines(
          dietaryFocus: "Warm, cooked, and grounding foods. Favor sweet, sour, and salty tastes. Limit raw/cold items.",
          stressFocus: "Gentle grounding routines, warm oil self-massage (Abhyanga), and restorative yoga.",
          recommendedSpices: ["Ginger", "Cardamom", "Cinnamon", "Cumin"],
        ),
      DoshaType.pitta => const DoshaGuidelines(
          dietaryFocus: "Cooling, hydrating foods. Favor sweet, bitter, and astringent tastes. Avoid spicy/fermented foods.",
          stressFocus: "Non-competitive exercise, cooling breathing practices (Shitali Pranayama), and spending time in nature.",
          recommendedSpices: ["Fennel", "Coriander", "Cilantro", "Turmeric"],
        ),
      DoshaType.kapha => const DoshaGuidelines(
          dietaryFocus: "Warm, light, and dry foods. Favor pungent, bitter, and astringent tastes. Avoid heavy dairy and sweets.",
          stressFocus: "Vigorous daily physical activity, stimulating dynamic breathing (Kapalabhati), and warm-up stretches.",
          recommendedSpices: ["Black Pepper", "Ginger", "Mustard Seeds", "Cayenne"],
        ),
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Quiz Questions Data
// ──────────────────────────────────────────────────────────────────────────────

const List<DoshaQuestion> doshaQuestions = [
  DoshaQuestion(
    id: 'body_frame',
    question: 'How would you describe your body frame and physical build?',
    questionHindi: 'आप अपने शरीर की बनावट और शारीरिक गठन का वर्णन कैसे करेंगे?',
    options: [
      DoshaOption(
        text: 'Thin, light build, hard to gain weight',
        textHindi: 'पतला, हल्का शरीर, वजन बढ़ाना मुश्किल',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Medium build, athletic, easily gain/lose weight',
        textHindi: 'मध्यम गठन, एथलेटिक, वजन आसानी से बढ़ना/घटना',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Broad, heavy build, easily gain weight, hard to lose',
        textHindi: 'चौड़ा, भारी शरीर, वजन आसानी से बढ़ना, घटाना मुश्किल',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'skin_texture',
    question: 'What is your skin type and general texture?',
    questionHindi: 'आपकी त्वचा का प्रकार और सामान्य बनावट कैसी है?',
    options: [
      DoshaOption(
        text: 'Dry, rough, cool to touch, prone to cracking',
        textHindi: 'सूखी, खुरदरी, छूने में ठंडी, फटने की संभावना',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Warm, sensitive, flushed, prone to acne/freckles',
        textHindi: 'गर्म, संवेदनशील, लालिमा युक्त, मुंहासे/झाइयों की संभावना',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Smooth, soft, thick, oily, cool to touch',
        textHindi: 'चिकनी, मुलायम, घनी, तैलीय, छूने में ठंडी',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'hair_type',
    question: 'How would you describe your hair?',
    questionHindi: 'आप अपने बालों का वर्णन कैसे करेंगे?',
    options: [
      DoshaOption(
        text: 'Dry, frizzy, curly, or thin',
        textHindi: 'सूखे, घुंघराले, रूखे या पतले',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Fine, soft, premature thinning or greying',
        textHindi: 'बारीक, मुलायम, समय से पहले पतले या सफेद होना',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Thick, abundant, oily, wavy, or lustrous',
        textHindi: 'घने, प्रचुर, तैलीय, लहराते या चमकदार',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'appetite_digestion',
    question: 'How is your appetite and general digestion?',
    questionHindi: 'आपकी भूख और सामान्य पाचन क्रिया कैसी है?',
    options: [
      DoshaOption(
        text: 'Irregular, variable, forget to eat, prone to bloating/gas',
        textHindi: 'अनियमित, परिवर्तनशील, खाना भूल जाना, गैस/अपच की संभावना',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Strong, intense, get "hangry" if meals are delayed, prone to acidity',
        textHindi: 'तीव्र भूख, भोजन में देरी होने पर गुस्सा आना, एसिडिटी की संभावना',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Slow but steady, can skip meals easily, digestion feels heavy',
        textHindi: 'धीमी लेकिन स्थिर, भोजन छोड़ना आसान, पाचन भारी महसूस होना',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'stress_response',
    question: 'How do you typically react under stress or pressure?',
    questionHindi: 'तनाव या दबाव में आप आमतौर पर कैसे प्रतिक्रिया करते हैं?',
    options: [
      DoshaOption(
        text: 'Anxious, worried, fearful, mind starts racing',
        textHindi: 'चिंतित, घबराया हुआ, भयभीत, दिमाग तेजी से चलना',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Irritable, angry, impatient, competitive',
        textHindi: 'चिड़चिड़ा, गुस्सैल, अधीर, प्रतिस्पर्धी',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Calm, steady, slow-moving, complacent, protective',
        textHindi: 'शांत, स्थिर, धीमी गति, आत्मसंतुष्ट, सुरक्षात्मक',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'sleep_pattern',
    question: 'What is your typical sleep pattern?',
    questionHindi: 'आपकी नींद का सामान्य पैटर्न क्या है?',
    options: [
      DoshaOption(
        text: 'Light, irregular, wake up easily, prone to insomnia',
        textHindi: 'हल्की, अनियमित, आसानी से उठ जाना, अनिद्रा की संभावना',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Moderate, sound sleep, wake up refreshed, vivid dreams',
        textHindi: 'मध्यम, अच्छी नींद, तरोताजा उठना, जीवंत सपने',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Deep, heavy, sleep long hours, hard to wake up',
        textHindi: 'गहरी, भारी, लंबे समय तक सोना, सुबह उठना मुश्किल',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'weather_preference',
    question: 'What weather or environmental conditions do you dislike most?',
    questionHindi: 'आप किस मौसम या पर्यावरणीय परिस्थितियों को सबसे कम पसंद करते हैं?',
    options: [
      DoshaOption(
        text: 'Cold, windy, and dry weather',
        textHindi: 'ठंडा, हवादार और सूखा मौसम',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Hot, humid, and bright sunny weather',
        textHindi: 'गर्म, उमस भरा और तेज धूप वाला मौसम',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Damp, cold, and cloudy weather',
        textHindi: 'नम, ठंडा और बादलों वाला मौसम',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'activity_style',
    question: 'What is your general activity style and energy trend?',
    questionHindi: 'आपकी सामान्य गतिविधि शैली और ऊर्जा का स्तर कैसा रहता है?',
    options: [
      DoshaOption(
        text: 'Energetic but tires easily, active in bursts, restless',
        textHindi: 'ऊर्जावान लेकिन जल्दी थक जाना, टुकड़ों में सक्रिय, बेचैन',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Focused, goal-oriented, competitive, intense energy',
        textHindi: 'केंद्रित, लक्ष्य-उन्मुख, प्रतिस्पर्धी, तीव्र ऊर्जा',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Steady, slow-paced, high endurance but needs push to start',
        textHindi: 'स्थिर, धीमी गति, उच्च सहनशक्ति लेकिन शुरुआत के लिए प्रेरणा चाहिए',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'speech_communication',
    question: 'How would you describe your speech and conversation style?',
    questionHindi: 'आप अपनी बोली और बातचीत की शैली का वर्णन कैसे करेंगे?',
    options: [
      DoshaOption(
        text: 'Fast, talkative, jumps from topic to topic',
        textHindi: 'तेज, बातूनी, एक विषय से दूसरे विषय पर कूदना',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Direct, clear, persuasive, sharp or argumentative',
        textHindi: 'सीधी, स्पष्ट, प्रभावशाली, तीखी या तार्किक',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Soft, slow, thoughtful, sweet-spoken, good listener',
        textHindi: 'धीमी, विचारशील, मीठी बोली, अच्छा श्रोता',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
  DoshaQuestion(
    id: 'memory_learning',
    question: 'How do you learn new things and remember information?',
    questionHindi: 'आप नई चीजें कैसे सीखते हैं और जानकारी कैसे याद रखते हैं?',
    options: [
      DoshaOption(
        text: 'Learn quickly, but forget quickly; active imagination',
        textHindi: 'जल्दी सीखना, लेकिन जल्दी भूलना; सक्रिय कल्पनाशीलता',
        associatedDosha: DoshaType.vata,
      ),
      DoshaOption(
        text: 'Learn quickly, remember well, logical and analytical',
        textHindi: 'जल्दी सीखना, अच्छी याददाश्त, तार्किक और विश्लेषणात्मक',
        associatedDosha: DoshaType.pitta,
      ),
      DoshaOption(
        text: 'Learn slowly, but retain permanently; patient and methodical',
        textHindi: 'धीमे सीखना, लेकिन हमेशा के लिए याद रखना; धैर्यवान और व्यवस्थित',
        associatedDosha: DoshaType.kapha,
      ),
    ],
  ),
];

// ──────────────────────────────────────────────────────────────────────────────
// State Definition
// ──────────────────────────────────────────────────────────────────────────────

class DoshaQuizState {
  const DoshaQuizState({
    this.answers = const {},
    this.activeQuestionIndex = 0,
    this.isSaving = false,
    this.result,
  });

  final Map<String, DoshaType> answers;
  final int activeQuestionIndex;
  final bool isSaving;
  final DoshaResult? result;

  bool get isCompleted => answers.length == doshaQuestions.length;

  DoshaQuizState copyWith({
    Map<String, DoshaType>? answers,
    int? activeQuestionIndex,
    bool? isSaving,
    DoshaResult? result,
  }) {
    return DoshaQuizState(
      answers: answers ?? this.answers,
      activeQuestionIndex: activeQuestionIndex ?? this.activeQuestionIndex,
      isSaving: isSaving ?? this.isSaving,
      result: result ?? this.result,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingDoshaNotifier extends Notifier<DoshaQuizState> {
  @override
  DoshaQuizState build() => const DoshaQuizState();

  void selectOption(String questionId, DoshaType dosha) {
    final updatedAnswers = Map<String, DoshaType>.from(state.answers)..[questionId] = dosha;
    state = state.copyWith(answers: updatedAnswers);
  }

  void nextQuestion() {
    if (state.activeQuestionIndex < doshaQuestions.length - 1) {
      state = state.copyWith(activeQuestionIndex: state.activeQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.activeQuestionIndex > 0) {
      state = state.copyWith(activeQuestionIndex: state.activeQuestionIndex - 1);
    }
  }

  void calculateResult() {
    const engine = DoshaQuizScoringEngine();
    final result = engine.calculateDoshaProfile(state.answers);
    state = state.copyWith(result: result);
  }

  Future<void> saveToDb(AppDatabase db, String userId) async {
    state = state.copyWith(isSaving: true);
    calculateResult();
    
    if (state.result != null) {
      final serializedResult = jsonEncode(state.result!.toJson());
      await db.updateUserProfile(
        userId: userId,
        dosha: serializedResult,
      );
    }
    
    state = state.copyWith(isSaving: false);
  }
}

final onboardingDoshaProvider =
    NotifierProvider<OnboardingDoshaNotifier, DoshaQuizState>(
  OnboardingDoshaNotifier.new,
);
