enum DoshaType {
  vata(name: 'Vata', regionalName: 'वात', element: 'Air & Ether (वायु एवं आकाश)'),
  pitta(name: 'Pitta', regionalName: 'पित्त', element: 'Fire & Water (अग्नि एवं जल)'),
  kapha(name: 'Kapha', regionalName: 'कफ', element: 'Earth & Water (पृथ्वी एवं जल)');

  final String name;
  final String regionalName;
  final String element;

  const DoshaType({
    required this.name,
    required this.regionalName,
    required this.element,
  });
}

class DoshaQuizQuestion {
  final String id;
  final String question;
  final String regionalQuestion;
  final List<DoshaQuizOption> options;

  const DoshaQuizQuestion({
    required this.id,
    required this.question,
    required this.regionalQuestion,
    required this.options,
  });
}

class DoshaQuizOption {
  final String text;
  final String regionalText;
  final DoshaType dosha;

  const DoshaQuizOption({
    required this.text,
    required this.regionalText,
    required this.dosha,
  });
}

class DoshaScoreResult {
  final DoshaType primaryDosha;
  final DoshaType secondaryDosha;
  final double vataPercent;
  final double pittaPercent;
  final double kaphaPercent;
  final String nutritionGuidance;
  final String trainingGuidance;

  const DoshaScoreResult({
    required this.primaryDosha,
    required this.secondaryDosha,
    required this.vataPercent,
    required this.pittaPercent,
    required this.kaphaPercent,
    required this.nutritionGuidance,
    required this.trainingGuidance,
  });
}

class DoshaScoringEngine {
  static const List<DoshaQuizQuestion> questions = [
    DoshaQuizQuestion(
      id: 'body_frame',
      question: 'How would you describe your natural body frame?',
      regionalQuestion: 'आपकी प्राकृतिक शारीरिक बनावट कैसी है?',
      options: [
        DoshaQuizOption(
          text: 'Lean, slender, light bones, hard to gain weight',
          regionalText: 'पतला शरीर, हल्की हड्डियां, वजन बढ़ाना कठिन',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Medium, athletic, well-defined muscle tone',
          regionalText: 'मध्यम बनावट, एथलेटिक, सुगठित मांसपेशियां',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Broad, sturdy, heavy bone structure, gains easily',
          regionalText: 'चौड़ा ढांचा, मजबूत हड्डियां, वजन आसानी से बढ़ता है',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
    DoshaQuizQuestion(
      id: 'digestion',
      question: 'How is your digestion and appetite rhythm?',
      regionalQuestion: 'आपकी पाचन शक्ति एवं भूख का स्वभाव कैसा है?',
      options: [
        DoshaQuizOption(
          text: 'Irregular appetite, prone to bloating/gas',
          regionalText: 'अनियमित भूख, गैस या पेट फूलने की प्रवृत्ति',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Strong, intense appetite, prone to acidity/heat',
          regionalText: 'तीव्र भूख, एसिडिटी या शरीर में गर्मी की प्रवृत्ति',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Slow, steady appetite, can skip meals easily',
          regionalText: 'धीमी एवं स्थिर पाचन क्रिया, आसानी से भोजन छोड़ सकते हैं',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
    DoshaQuizQuestion(
      id: 'energy_level',
      question: 'What is your typical energy pattern during the day?',
      regionalQuestion: 'दिन भर आपकी शारीरिक ऊर्जा का स्तर कैसा रहता है?',
      options: [
        DoshaQuizOption(
          text: 'Quick bursts of high energy followed by sudden fatigue',
          regionalText: 'तेज ऊर्जा के झोंके और फिर अचानक थकान',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Consistent, driven, high endurance and intensity',
          regionalText: 'लगातार उच्च ऊर्जा, महत्वाकांक्षी एवं दृढ़',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Slow to get started, but steady long-lasting endurance',
          regionalText: 'शुरुआत में धीमा, लेकिन लंबे समय तक स्थिर सहनशक्ति',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
    DoshaQuizQuestion(
      id: 'sleep_quality',
      question: 'How would you describe your sleep quality?',
      regionalQuestion: 'आपकी नींद की गुणवत्ता कैसी रहती है?',
      options: [
        DoshaQuizOption(
          text: 'Light, restless, easily awakened by noise',
          regionalText: 'हल्की नींद, बेचैन, आवाज से तुरंत खुल जाती है',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Moderate, sound, wake up feeling sharp & alert',
          regionalText: 'संतुलित नींद, जागने पर ऊर्जावान महसूस होता है',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Deep, heavy, hard to wake up in early mornings',
          regionalText: 'गहरी एवं भारी नींद, सुबह जल्दी उठना कठिन',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
    DoshaQuizQuestion(
      id: 'stress_response',
      question: 'How do you instinctively react under high stress?',
      regionalQuestion: 'अत्यधिक तनाव की स्थिति में आपकी क्या प्रतिक्रिया होती है?',
      options: [
        DoshaQuizOption(
          text: 'Anxious, overwhelmed, overthinking and restless',
          regionalText: 'चिंता, घबराहट एवं अत्यधिक सोच-विचार',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Irritable, frustrated, impatient, take charge',
          regionalText: 'चिड़चिड़ापन, अधीरता एवं तुरंत नियंत्रण लेने की इच्छा',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Calm, detached, resistant to change or withdrawn',
          regionalText: 'शांत, परिवर्तन से बचना एवं एकांत पसंद करना',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
    DoshaQuizQuestion(
      id: 'weather_preference',
      question: 'Which weather or climate bothers you the most?',
      regionalQuestion: 'कौन सा मौसम आपको सबसे अधिक परेशान करता है?',
      options: [
        DoshaQuizOption(
          text: 'Cold, dry, windy weather (prefers warmth)',
          regionalText: 'ठंडा, सूखा एवं हवादार मौसम (गर्मी पसंद)',
          dosha: DoshaType.vata,
        ),
        DoshaQuizOption(
          text: 'Hot, humid, sunny weather (prefers cool)',
          regionalText: 'गर्म, धूप एवं उमस भरा मौसम (ठंडक पसंद)',
          dosha: DoshaType.pitta,
        ),
        DoshaQuizOption(
          text: 'Damp, rainy, gloomy cold weather (prefers dry heat)',
          regionalText: 'गीला, बरसाती एवं ठंडा मौसम (सूखी गर्मी पसंद)',
          dosha: DoshaType.kapha,
        ),
      ],
    ),
  ];

  /// Computes deterministic Dosha score from user's selected option indices
  static DoshaScoreResult calculateScore(Map<String, DoshaType> answers) {
    int vataCount = 0;
    int pittaCount = 0;
    int kaphaCount = 0;

    for (final dosha in answers.values) {
      switch (dosha) {
        case DoshaType.vata:
          vataCount++;
          break;
        case DoshaType.pitta:
          pittaCount++;
          break;
        case DoshaType.kapha:
          kaphaCount++;
          break;
      }
    }

    final total = (vataCount + pittaCount + kaphaCount).clamp(1, 100);
    final vataPercent = vataCount / total;
    final pittaPercent = pittaCount / total;
    final kaphaPercent = kaphaCount / total;

    // Rank doshas
    final doshaScores = [
      MapEntry(DoshaType.vata, vataCount),
      MapEntry(DoshaType.pitta, pittaCount),
      MapEntry(DoshaType.kapha, kaphaCount),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final primary = doshaScores[0].key;
    final secondary = doshaScores[1].key;

    final String nutritionGuidance;
    final String trainingGuidance;

    switch (primary) {
      case DoshaType.vata:
        nutritionGuidance = 'Focus on warm, grounding, nourishing Indian meals (ghee, daal, cooked root vegetables). Avoid cold dry salads and raw fasting.';
        trainingGuidance = 'Prioritize consistent resistance training with moderate weights and grounding yoga/mobility. Avoid over-exhausting cardio.';
        break;
      case DoshaType.pitta:
        nutritionGuidance = 'Incorporate cooling foods (coconut water, coriander, sweet fruits, curd/buttermilk). Limit excessive chilies, garlic, and deep-fried items.';
        trainingGuidance = 'Channel intense drive into progressive compound lifts and early morning outdoor running before peak heat.';
        break;
      case DoshaType.kapha:
        nutritionGuidance = 'Focus on light, warm, spiced foods with ginger, black pepper, and turmeric. Keep carbohydrates moderate and prioritize lean protein.';
        trainingGuidance = 'Thrives on high-intensity interval training (HIIT), circuit workouts, and fast-paced cardio to stimulate metabolism.';
        break;
    }

    return DoshaScoreResult(
      primaryDosha: primary,
      secondaryDosha: secondary,
      vataPercent: vataPercent,
      pittaPercent: pittaPercent,
      kaphaPercent: kaphaPercent,
      nutritionGuidance: nutritionGuidance,
      trainingGuidance: trainingGuidance,
    );
  }
}
