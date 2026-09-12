enum DoshaType { vata, pitta, kapha, dual, tridoshic }

class DoshaProfile {
  final int vataScore;
  final int pittaScore;
  final int kaphaScore;
  final double vataPercent;
  final double pittaPercent;
  final double kaphaPercent;
  final DoshaType dominantDosha;
  final String title;
  final String titleHindi;
  final String summary;
  final String summaryHindi;
  final List<String> dietaryGuidance;
  final List<String> dietaryGuidanceHindi;

  const DoshaProfile({
    required this.vataScore,
    required this.pittaScore,
    required this.kaphaScore,
    required this.vataPercent,
    required this.pittaPercent,
    required this.kaphaPercent,
    required this.dominantDosha,
    required this.title,
    required this.titleHindi,
    required this.summary,
    required this.summaryHindi,
    required this.dietaryGuidance,
    required this.dietaryGuidanceHindi,
  });
}

class DoshaQuestion {
  final String id;
  final String question;
  final String questionHindi;
  final String vataOption;
  final String vataOptionHindi;
  final String pittaOption;
  final String pittaOptionHindi;
  final String kaphaOption;
  final String kaphaOptionHindi;

  const DoshaQuestion({
    required this.id,
    required this.question,
    required this.questionHindi,
    required this.vataOption,
    required this.vataOptionHindi,
    required this.pittaOption,
    required this.pittaOptionHindi,
    required this.kaphaOption,
    required this.kaphaOptionHindi,
  });
}

/// DoshaScoringEngine — Pure Dart Ayurvedic Prakriti Evaluator
class DoshaScoringEngine {
  const DoshaScoringEngine();

  static const List<DoshaQuestion> questions = [
    DoshaQuestion(
      id: 'body_frame',
      question: 'How would you describe your natural physical frame?',
      questionHindi: 'आपकी स्वाभाविक शारीरिक बनावट कैसी है?',
      vataOption: 'Slender, light bones, find it hard to gain weight',
      vataOptionHindi: 'पतली, हल्की हड्डियां, वज़न बढ़ाना कठिन',
      pittaOption: 'Medium build, athletic, easy to gain or lose weight',
      pittaOptionHindi: 'मध्यम, एथलेटिक, वज़न आसानी से घटता/बढ़ता है',
      kaphaOption: 'Solid, broad shoulders/hips, easily gain weight',
      kaphaOptionHindi: 'मजबूत, चौड़े कंधे, वज़न जल्दी बढ़ता है',
    ),
    DoshaQuestion(
      id: 'digestion',
      question: 'How is your typical appetite and digestion (Agni)?',
      questionHindi: 'आपकी भूख और पाचन क्रिया (अग्नि) कैसी है?',
      vataOption: 'Irregular — hungry some days, skip meals on others',
      vataOptionHindi: 'अनियमित — कभी बहुत भूख, कभी भोजन छूट जाता है',
      pittaOption: 'Intense and sharp — get irritable if meals are delayed',
      pittaOptionHindi: 'तीव्र और तेज — समय पर भोजन न मिलने पर चिड़चिड़ापन',
      kaphaOption: 'Slow but steady — can easily skip breakfast without discomfort',
      kaphaOptionHindi: 'धीमी लेकिन स्थिर — नाश्ता छोड़े बिना कोई परेशानी नहीं',
    ),
    DoshaQuestion(
      id: 'energy_pace',
      question: 'What is your typical energy pattern through the day?',
      questionHindi: 'दिन भर में आपकी ऊर्जा का स्तर कैसा रहता है?',
      vataOption: 'Bursts of high energy followed by sudden fatigue',
      vataOptionHindi: 'अचानक बहुत ऊर्जा और फिर अचानक थकान',
      pittaOption: 'Strong, focused, and driven until the task is complete',
      pittaOptionHindi: 'मजबूत, केंद्रित और लक्ष्य पूरा होने तक सक्रिय',
      kaphaOption: 'Slow to start in morning, but sustained steady endurance',
      kaphaOptionHindi: 'सुबह धीमी शुरुआत, लेकिन दिन भर स्थिर सहनशक्ति',
    ),
    DoshaQuestion(
      id: 'stress_response',
      question: 'How does your mind respond under acute pressure or stress?',
      questionHindi: 'दबाव या तनाव में आपका मन कैसी प्रतिक्रिया देता है?',
      vataOption: 'Anxious, restless, racing thoughts, insomnia',
      vataOptionHindi: 'चिंता, बेचैनी, अत्यधिक विचार, अनिद्रा',
      pittaOption: 'Frustration, perfectionism, critical, irritable',
      pittaOptionHindi: 'गुस्सा, अधीरता, परफेक्शनिज़्म, चिड़चिड़ापन',
      kaphaOption: 'Withdrawn, stubborn, calm resistance, lethargy',
      kaphaOptionHindi: 'शांत, सुस्त, बदलाव के प्रति अनिच्छुक',
    ),
  ];

  DoshaProfile calculateDosha({
    required int vataPoints,
    required int pittaPoints,
    required int kaphaPoints,
  }) {
    final total = (vataPoints + pittaPoints + kaphaPoints).clamp(1, 100);
    final vataP = (vataPoints / total) * 100;
    final pittaP = (pittaPoints / total) * 100;
    final kaphaP = (kaphaPoints / total) * 100;

    DoshaType type;
    String title;
    String titleHindi;
    String summary;
    String summaryHindi;
    List<String> guidance;
    List<String> guidanceHindi;

    if ((vataP - pittaP).abs() < 10 && (pittaP - kaphaP).abs() < 10) {
      type = DoshaType.tridoshic;
      title = 'Tridoshic (Vata-Pitta-Kapha Balanced)';
      titleHindi = 'त्रिदोषज (समान संतुलन)';
      summary = 'Rare, harmonious constitution with balanced vitality and adaptable metabolism.';
      summaryHindi = 'दुर्लभ और संतुलित प्रकृति जो आसानी से अनुकूलित होती है।';
      guidance = ['Maintain seasonal moderation (Ritu-charya).', 'Vary whole grains and legumes.'];
      guidanceHindi = ['ऋतु अनुसार आहार लें।', 'अनाज और दालों में विविधता रखें।'];
    } else if (pittaP >= vataP && pittaP >= kaphaP) {
      type = DoshaType.pitta;
      title = 'Pitta Dominant (Fire & Transformation)';
      titleHindi = 'पित्त प्रधान (अग्नि और तेज)';
      summary = 'High metabolic burn rate, sharp digestion, and athletic intensity.';
      summaryHindi = 'तेज चयापचय (मेटाबॉलिज्म) और उच्च पाचन शक्ति।';
      guidance = [
        'Incorporate cooling foods: coconut water, cucumber, coriander, mint.',
        'Moderate excessive spicy/fried Indian foods to prevent acidity.',
        'Opt for paneer and moong over fiery gravies.',
      ];
      guidanceHindi = [
        'ठंडी तासीर वाले खाद्य पदार्थ लें: नारियल पानी, खीरा, धनिया।',
        'अत्यधिक तीखा और तला हुआ भोजन कम करें।',
        'मूंग दाल और पनीर का संतुलित उपयोग करें।',
      ];
    } else if (vataP >= pittaP && vataP >= kaphaP) {
      type = DoshaType.vata;
      title = 'Vata Dominant (Air & Movement)';
      titleHindi = 'वात प्रधान (वायु और गति)';
      summary = 'Quick, creative, and agile system prone to digestive variability and dryness.';
      summaryHindi = 'चंचल और फुर्तीला शरीर, जिसमें कभी-कभी पाचन में उतार-चढ़ाव होता है।';
      guidance = [
        'Prioritize warm, grounding meals: khichdi, cooked dals with pure desi ghee.',
        'Avoid cold or raw salads during evening meals.',
        'Include healthy fats (almonds, sesame seeds).',
      ];
      guidanceHindi = [
        'गर्म और पौष्टिक भोजन लें: देसी घी युक्त खिचड़ी और पकी दाल।',
        'शाम को ठंडे और कच्चे सलाद से बचें।',
        'तिल, बादाम और अखरोट शामिल करें।',
      ];
    } else {
      type = DoshaType.kapha;
      title = 'Kapha Dominant (Earth & Structure)';
      titleHindi = 'कफ प्रधान (पृथ्वी और स्थिरता)';
      summary = 'Strong endurance, robust immune system, and steady metabolism.';
      summaryHindi = 'मजबूत सहनशक्ति, मजबूत प्रतिरक्षा और स्थिर चयापचय।';
      guidance = [
        'Focus on light, stimulating spices: ginger, black pepper, turmeric.',
        'Incorporate roasted chana, sattu, and sprouted legumes.',
        'Keep dairy and refined grains minimal.',
      ];
      guidanceHindi = [
        'हल्के और पाचक मसाले लें: अदरक, काली मिर्च, हल्दी।',
        'भुना चना, सत्तू और अंकुरित दालें अपनाएं।',
        'अत्यधिक मीठे और भारी डेयरी से बचें।',
      ];
    }

    return DoshaProfile(
      vataScore: vataPoints,
      pittaScore: pittaPoints,
      kaphaScore: kaphaPoints,
      vataPercent: double.parse(vataP.toStringAsFixed(1)),
      pittaPercent: double.parse(pittaP.toStringAsFixed(1)),
      kaphaPercent: double.parse(kaphaP.toStringAsFixed(1)),
      dominantDosha: type,
      title: title,
      titleHindi: titleHindi,
      summary: summary,
      summaryHindi: summaryHindi,
      dietaryGuidance: guidance,
      dietaryGuidanceHindi: guidanceHindi,
    );
  }
}
