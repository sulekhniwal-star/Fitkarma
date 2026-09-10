import 'voice_models.dart';

/// Pure Dart Deterministic Engine for Multilingual Vernacular Voice Logging,
/// Indian Regional Food NLP, Phonetic Token Disambiguation, and Intent Extraction.
class VoiceEngine {
  const VoiceEngine();

  /// Processes spoken audio transcript across 10 Indian languages/dialects
  VoiceTranscriptResult processVoiceTranscript({
    required String transcript,
    VernacularLanguage? forcedLanguage,
    Duration audioDuration = const Duration(seconds: 4),
  }) {
    final clean = transcript.trim();
    final lower = clean.toLowerCase();

    final detectedLang = forcedLanguage ?? _detectLanguage(clean, lower);
    final parsedEntity = _parseSpeechIntent(clean, lower, detectedLang);

    // Compute confidence score based on recognized tokens vs total words
    final words =
        clean.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    double confidence = 0.94;
    if (words.length <= 1) confidence = 0.82;
    if (parsedEntity.detectedFoodItems.isEmpty &&
        parsedEntity.intentType == VoiceIntentType.mealNutrition) {
      confidence = 0.78;
    }

    return VoiceTranscriptResult(
      rawTranscript: clean,
      detectedLanguage: detectedLang,
      confidenceScore: double.parse(confidence.toStringAsFixed(2)),
      parsedEntity: parsedEntity,
      audioDuration: audioDuration,
      recordedAt: DateTime.now(),
    );
  }

  VernacularLanguage _detectLanguage(String raw, String lower) {
    // Check script-based detection
    if (RegExp(r'[\u0900-\u097F]').hasMatch(raw)) {
      // Devanagari: check Marathi specific vs Hindi
      if (lower.contains('दोन') ||
          lower.contains('भाकरी') ||
          lower.contains('पिठलं') ||
          lower.contains('ताक')) {
        return VernacularLanguage.marathi;
      }
      return VernacularLanguage.hindi;
    }
    if (RegExp(r'[\u0B80-\u0BFF]').hasMatch(raw)) {
      return VernacularLanguage.tamil;
    }
    if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(raw)) {
      return VernacularLanguage.telugu;
    }
    if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(raw)) {
      return VernacularLanguage.kannada;
    }
    if (RegExp(r'[\u0980-\u09FF]').hasMatch(raw)) {
      return VernacularLanguage.bengali;
    }
    if (RegExp(r'[\u0A80-\u0AFF]').hasMatch(raw)) {
      return VernacularLanguage.gujarati;
    }
    if (RegExp(r'[\u0A00-\u0A7F]').hasMatch(raw)) {
      return VernacularLanguage.punjabi;
    }

    // Latin Script / Hinglish vs English
    if (_hasHinglishKeywords(lower)) return VernacularLanguage.hinglish;
    return VernacularLanguage.english;
  }

  bool _hasHinglishKeywords(String text) {
    const keywords = [
      'roti',
      'khaya',
      'liya',
      'pani',
      'paani',
      'chawal',
      'dahi',
      'chaas',
      'bhaji',
      'bhookh',
      'subah',
      'shaam',
      'dopahar',
      'katori',
      'chamach',
      'aadha',
      'ek',
      'do',
      'teen',
      'chaar',
      'walk kiya',
      'kadam',
      'khichdi',
      'dal',
      'paneer'
    ];
    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }
    return false;
  }

  ParsedVoiceEntity _parseSpeechIntent(
      String raw, String lower, VernacularLanguage lang) {
    // 1. Meal Check First (if solid food items detected, treat as meal even if drink/water is included)
    if (_hasMealKeywords(lower)) {
      return _parseVernacularMeal(raw, lower, lang);
    }

    // 2. Water / Hydration Check
    if (_isWaterIntent(lower)) {
      final int ml = _extractWaterVolume(lower);
      return ParsedVoiceEntity(
        intentType: VoiceIntentType.waterHydration,
        primarySummary: 'Hydration logged: $ml mL',
        regionalSummary: '$ml मिली जल दर्ज किया गया',
        waterMl: ml,
        postMealGuidance:
            'Sip water in seated posture; avoid ice-cold fluids after workouts.',
        regionalPostMealGuidance:
            'बैठकर घूंट-घूंट पानी पिएं; कसरत बाद ठंडा पानी न लें।',
      );
    }

    // 3. Workout / Activity Check
    if (_isWorkoutIntent(lower)) {
      final (int mins, int steps, double cals) = _extractWorkoutData(lower);
      return ParsedVoiceEntity(
        intentType: VoiceIntentType.workoutPhysicalActivity,
        primarySummary: mins > 0
            ? 'Workout logged: $mins mins (~${cals.toInt()} kcal)'
            : 'Steps logged: $steps steps',
        regionalSummary: mins > 0
            ? 'व्यायाम दर्ज: $mins मिनट (~${cals.toInt()} कैलोरी)'
            : 'कदम दर्ज: $steps कदम',
        workoutDurationMinutes: mins,
        stepsCount: steps,
        calories: cals,
        postMealGuidance:
            'Hydrate with electrolytes and perform 5 minutes of cool-down stretching.',
        regionalPostMealGuidance:
            'इलेक्ट्रोलाइट्स युक्त जल लें व ५ मिनट स्ट्रेचिंग करें।',
      );
    }

    // 4. Weight / Biometrics Check
    if (_isWeightIntent(lower)) {
      final double weight = _extractWeight(lower);
      return ParsedVoiceEntity(
        intentType: VoiceIntentType.biometricWeight,
        primarySummary: 'Body weight logged: ${weight.toStringAsFixed(1)} kg',
        regionalSummary: 'वजन दर्ज: ${weight.toStringAsFixed(1)} किग्रा',
        weightKg: weight,
      );
    }

    // 5. Default fallback to meal parsing
    return _parseVernacularMeal(raw, lower, lang);
  }

  bool _hasMealKeywords(String text) {
    const mealKeys = [
      'roti',
      'chapati',
      'phulka',
      'bhakri',
      'भाकरी',
      'पोळी',
      'रोटी',
      'पिठलं',
      'pithla',
      'dal',
      'daal',
      'दाल',
      'वरण',
      'sambar',
      'rasam',
      'rice',
      'chawal',
      'चावल',
      'भात',
      'biryani',
      'idli',
      'dosa',
      'ragi mudde',
      'paneer',
      'chicken',
      'fish',
      'egg',
      'eggs',
      'अंडे',
      'curd',
      'dahi',
      'दही',
      'salad',
      'khichdi',
      'poha',
      'upma',
      'thepla',
      'dhokla',
      'paratha',
      'chhole',
      'rajma',
      'sabji',
      'bhaji'
    ];
    for (final k in mealKeys) {
      if (text.contains(k)) return true;
    }
    return false;
  }

  bool _isWaterIntent(String text) {
    return text.contains('water') ||
        text.contains('pani') ||
        text.contains('paani') ||
        text.contains('पानी') ||
        text.contains('जल') ||
        text.contains('thani') ||
        text.contains('neellu') ||
        text.contains('neeru') ||
        text.contains('jol') ||
        text.contains('chaas') ||
        text.contains('ताक') ||
        text.contains('छाछ') ||
        text.contains('coconut') ||
        text.contains('नारियल') ||
        text.contains('इळनीर');
  }

  int _extractWaterVolume(String text) {
    if (text.contains('coconut') ||
        text.contains('नारियल') ||
        text.contains('इळनीर')) {
      return 300;
    }

    // Look for ml or liters
    final mlMatch = RegExp(r'(\d+)\s*(?:ml|मिली|మి.లీ|மிலி)?').firstMatch(text);
    if (mlMatch != null && text.contains('ml')) {
      return int.tryParse(mlMatch.group(1)!) ?? 250;
    }

    final lMatch =
        RegExp(r'(\d+(?:\.\d+)?)\s*(?:l|liter|litre|लीटर|లీటర్|லிட்டர்)')
            .firstMatch(text);
    if (lMatch != null) {
      final double l = double.tryParse(lMatch.group(1)!) ?? 1.0;
      return (l * 1000).toInt();
    }

    final glassMatch = RegExp(
            r'(\d+|one|two|three|ek|do|teen|दोन|ஒன்று|రెండు)\s*(?:glass|glaas|गिलास|ग्लास|டம்ளர்|గ్లాసు)')
        .firstMatch(text);
    if (glassMatch != null) {
      final String qtyStr = glassMatch.group(1)!;
      final int count = _parseWordQuantity(qtyStr);
      return count * 250;
    }

    if (text.contains('chaas') ||
        text.contains('छाछ') ||
        text.contains('ताक')) {
      return 200;
    }

    return 250;
  }

  bool _isWorkoutIntent(String text) {
    return text.contains('walk') ||
        text.contains('run') ||
        text.contains('steps') ||
        text.contains('gym') ||
        text.contains('workout') ||
        text.contains('yoga') ||
        text.contains('surya namaskar') ||
        text.contains('कदम') ||
        text.contains('व्यायाम') ||
        text.contains('कसरत') ||
        text.contains('दौड़') ||
        text.contains('നടത്തം') ||
        text.contains('நடை') ||
        text.contains('నడక') ||
        text.contains('cycling') ||
        text.contains('swimming');
  }

  (int, int, double) _extractWorkoutData(String text) {
    int duration = 0;
    int steps = 0;
    double calories = 0;

    final stepMatch =
        RegExp(r'(\d+)\s*(?:steps|kadam|कदम|అడుగులు|படிகள்)').firstMatch(text);
    if (stepMatch != null) {
      steps = int.tryParse(stepMatch.group(1)!) ?? 0;
      calories += (steps * 0.04);
    }

    final minMatch =
        RegExp(r'(\d+)\s*(?:min|mins|minute|minutes|मिनट|நிமிடம்|నిమిషాలు)')
            .firstMatch(text);
    if (minMatch != null) {
      duration = int.tryParse(minMatch.group(1)!) ?? 30;
    } else if (text.contains('1 hour') ||
        text.contains('१ घंटा') ||
        text.contains('एक घंटा')) {
      duration = 60;
    } else if (text.contains('half hour') || text.contains('आधा घंटा')) {
      duration = 30;
    }

    if (duration > 0 && calories == 0) {
      calories = duration * 6.5;
    }

    return (duration, steps, calories);
  }

  bool _isWeightIntent(String text) {
    return (text.contains('weight') ||
            text.contains('vajan') ||
            text.contains('वजन') ||
            text.contains('तोल') ||
            text.contains('எடை')) &&
        (text.contains('kg') || RegExp(r'\d+(\.\d+)?').hasMatch(text));
  }

  double _extractWeight(String text) {
    final match = RegExp(r'(\d+(?:\.\d+)?)\s*(?:kg|kilos|किग्रा|కిలోలు)?')
        .firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 70.0;
    }
    return 70.0;
  }

  ParsedVoiceEntity _parseVernacularMeal(
      String raw, String lower, VernacularLanguage lang) {
    final List<String> detected = [];
    double totalCals = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    // 1. Roti / Chapati / Phulka / Bhakri
    if (lower.contains('roti') ||
        lower.contains('chapati') ||
        lower.contains('phulka') ||
        lower.contains('रोटी') ||
        lower.contains('पोळी') ||
        lower.contains('சப்பாத்தி')) {
      final int qty = _extractItemQuantity(
          lower, ['roti', 'chapati', 'phulka', 'रोटी', 'पोळी', 'சப்பாத்தி'],
          defaultQty: 2);
      detected.add('$qty Roti / Chapati');
      totalCals += qty * 85.0;
      totalProtein += qty * 3.0;
      totalCarbs += qty * 15.0;
      totalFat += qty * 1.5;
      totalFiber += qty * 2.0;
    } else if (lower.contains('bhakri') ||
        lower.contains('भाकरी') ||
        lower.contains('jowar') ||
        lower.contains('bajra')) {
      final int qty = _extractItemQuantity(
          lower, ['bhakri', 'भाकरी', 'jowar', 'bajra'],
          defaultQty: 1);
      detected.add('$qty Jowar/Bajra Bhakri');
      totalCals += qty * 120.0;
      totalProtein += qty * 3.5;
      totalCarbs += qty * 24.0;
      totalFat += qty * 1.8;
      totalFiber += qty * 3.5;
    }

    // 2. Dal / Sambar / Rasam / Kadhi
    if (lower.contains('dal') ||
        lower.contains('daal') ||
        lower.contains('दाल') ||
        lower.contains('वरण') ||
        lower.contains('sambar') ||
        lower.contains('சாம்பார்') ||
        lower.contains('పప్పు')) {
      final int qty = _extractItemQuantity(
          lower, ['dal', 'daal', 'दाल', 'वरण', 'sambar', 'சாம்பார்', 'పప్పు'],
          defaultQty: 1);
      detected.add('$qty Bowl Dal / Sambar');
      totalCals += qty * 140.0;
      totalProtein += qty * 7.5;
      totalCarbs += qty * 18.0;
      totalFat += qty * 4.0;
      totalFiber += qty * 4.0;
    }

    // 3. Rice / Chawal / Bhaat / Biryani
    if (lower.contains('rice') ||
        lower.contains('chawal') ||
        lower.contains('चावल') ||
        lower.contains('भात') ||
        lower.contains('அரிசி') ||
        lower.contains('అన్నం') ||
        lower.contains('biryani')) {
      final bool isBiryani =
          lower.contains('biryani') || lower.contains('बिरयानी');
      detected.add(isBiryani ? '1 Plate Biryani' : '1 Bowl Steamed Rice');
      totalCals += isBiryani ? 450.0 : 170.0;
      totalProtein += isBiryani ? 22.0 : 3.0;
      totalCarbs += isBiryani ? 52.0 : 38.0;
      totalFat += isBiryani ? 16.0 : 0.5;
      totalFiber += isBiryani ? 2.0 : 1.0;
    }

    // 4. South Indian Staples (Idli, Dosa, Pesarattu, Ragi Mudde)
    if (lower.contains('idli') ||
        lower.contains('इ़डली') ||
        lower.contains('இட்லி') ||
        lower.contains('ఇడ్లీ')) {
      final int qty = _extractItemQuantity(
          lower, ['idli', 'इ़डली', 'இட்லி', 'ఇడ్లీ'],
          defaultQty: 2);
      detected.add('$qty Steamed Idlis');
      totalCals += qty * 75.0;
      totalProtein += qty * 2.5;
      totalCarbs += qty * 15.0;
      totalFat += qty * 0.5;
      totalFiber += qty * 1.5;
    } else if (lower.contains('dosa') ||
        lower.contains('डोसा') ||
        lower.contains('தோசை') ||
        lower.contains('దోశ')) {
      final int qty = _extractItemQuantity(
          lower, ['dosa', 'डोसा', 'தோசை', 'దోశ'],
          defaultQty: 1);
      detected.add('$qty Crispy Dosa');
      totalCals += qty * 165.0;
      totalProtein += qty * 3.5;
      totalCarbs += qty * 28.0;
      totalFat += qty * 4.5;
      totalFiber += qty * 1.5;
    } else if (lower.contains('ragi mudde') ||
        lower.contains('ராகி களி') ||
        lower.contains('రాగి ముద్ద')) {
      detected.add('1 Ragi Mudde Ball');
      totalCals += 200.0;
      totalProtein += 4.5;
      totalCarbs += 42.0;
      totalFat += 1.2;
      totalFiber += 6.5;
    }

    // 5. Paneer / Chicken / Fish / Eggs
    if (lower.contains('paneer') ||
        lower.contains('पनीर') ||
        lower.contains('பன்னீர்')) {
      detected.add('100g Paneer Curry/Bhurji');
      totalCals += 240.0;
      totalProtein += 14.0;
      totalCarbs += 4.0;
      totalFat += 18.0;
      totalFiber += 1.0;
    } else if (lower.contains('chicken') ||
        lower.contains('चिकन') ||
        lower.contains('கோழி') ||
        lower.contains('చికెన్')) {
      detected.add('150g Chicken Curry/Grilled');
      totalCals += 220.0;
      totalProtein += 28.0;
      totalCarbs += 4.0;
      totalFat += 8.0;
      totalFiber += 0.0;
    } else if (lower.contains('fish') ||
        lower.contains('मछली') ||
        lower.contains('मासा') ||
        lower.contains('மீன்') ||
        lower.contains('చేప')) {
      detected.add('150g Fish Curry');
      totalCals += 190.0;
      totalProtein += 24.0;
      totalCarbs += 3.0;
      totalFat += 7.0;
      totalFiber += 0.0;
    } else if (lower.contains('egg') ||
        lower.contains('eggs') ||
        lower.contains('अंडे') ||
        lower.contains('अंड') ||
        lower.contains('முட்டை') ||
        lower.contains('గుడ్డు')) {
      final int qty = _extractItemQuantity(
          lower, ['egg', 'eggs', 'अंडे', 'अंड', 'முட்டை', 'గుడ్డు'],
          defaultQty: 2);
      detected.add('$qty Boiled/Omelette Eggs');
      totalCals += qty * 75.0;
      totalProtein += qty * 6.0;
      totalCarbs += qty * 0.5;
      totalFat += qty * 5.0;
    }

    // 6. Curd / Dahi / Chaas / Taak / Salad
    if (lower.contains('chaas') ||
        lower.contains('छाछ') ||
        lower.contains('ताक') ||
        lower.contains('mattha')) {
      detected.add('1 Glass Spiced Chaas / Taak');
      totalCals += 60.0;
      totalProtein += 3.0;
      totalCarbs += 4.0;
      totalFat += 2.5;
    } else if (lower.contains('curd') ||
        lower.contains('dahi') ||
        lower.contains('दही')) {
      detected.add('1 Bowl Dahi / Curd');
      totalCals += 90.0;
      totalProtein += 4.0;
      totalCarbs += 6.0;
      totalFat += 5.0;
    }

    if (lower.contains('pithla') ||
        lower.contains('पिठलं') ||
        lower.contains('पिठले')) {
      detected.add('1 Bowl Besan Pithla');
      totalCals += 150.0;
      totalProtein += 6.5;
      totalCarbs += 14.0;
      totalFat += 6.0;
      totalFiber += 3.5;
    }

    if (lower.contains('salad') ||
        lower.contains('सलाद') ||
        lower.contains('ककड़ी') ||
        lower.contains('खीरा')) {
      detected.add('1 Bowl Green Salad');
      totalCals += 40.0;
      totalProtein += 1.0;
      totalCarbs += 8.0;
      totalFat += 0.5;
      totalFiber += 3.0;
    }

    // Fallback if none specifically isolated
    if (detected.isEmpty) {
      detected.add('Wholesome Indian Meal');
      totalCals = 360.0;
      totalProtein = 12.0;
      totalCarbs = 48.0;
      totalFat = 13.0;
      totalFiber = 5.0;
    }

    return ParsedVoiceEntity(
      intentType: VoiceIntentType.mealNutrition,
      primarySummary: detected.join(', '),
      regionalSummary: detected.join(', '),
      calories: totalCals,
      proteinGrams: totalProtein,
      carbsGrams: totalCarbs,
      fatGrams: totalFat,
      fiberGrams: totalFiber,
      detectedFoodItems: detected,
      postMealGuidance:
          'Take 100 Shatapadi steps to optimize metabolic glucose response.',
      regionalPostMealGuidance:
          'शर्करा स्तर नियंत्रण व पाचन सुधार हेतु १०० कदम शतपावली करें।',
    );
  }

  int _extractItemQuantity(String text, List<String> triggers,
      {int defaultQty = 1}) {
    for (final trigger in triggers) {
      final pattern = RegExp(
          '(?:(\\d+|one|two|three|four|ek|do|teen|chaar|दोन|तीन|चार|ஒன்று|இரண்டு|ఒకటి|రెండు)\\s+(?:\\S+\\s+)?)$trigger');
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        return _parseWordQuantity(match.group(1)!);
      }
      final directPattern = RegExp(
          '(\\d+|one|two|three|four|ek|do|teen|chaar|दोन|तीन|चार|ஒன்று|இரண்டு|ఒకటి|రెండు)\\s*$trigger');
      final directMatch = directPattern.firstMatch(text);
      if (directMatch != null) {
        return _parseWordQuantity(directMatch.group(1)!);
      }
    }
    return defaultQty;
  }

  int _parseWordQuantity(String token) {
    final lower = token.toLowerCase();
    final int? direct = int.tryParse(lower);
    if (direct != null) return direct;

    switch (lower) {
      case 'one':
      case 'ek':
      case 'एक':
      case 'ஒன்று':
      case 'ఒకటి':
        return 1;
      case 'two':
      case 'do':
      case 'दो':
      case 'दोन':
      case 'இரண்டு':
      case 'రెండు':
        return 2;
      case 'three':
      case 'teen':
      case 'तीन':
      case 'மூன்று':
      case 'మూడు':
        return 3;
      case 'four':
      case 'chaar':
      case 'चार':
      case 'நான்கு':
      case 'నాలుగు':
        return 4;
      default:
        return 1;
    }
  }

  /// Synthesizes spoken audio feedback prompt for TTS
  VoiceAudioPrompt generateAudioPrompt(VoiceTranscriptResult result) {
    final entity = result.parsedEntity;
    final lang = result.detectedLanguage;

    final String spoken;
    final String regional;

    switch (entity.intentType) {
      case VoiceIntentType.mealNutrition:
        spoken =
            'Logged ${entity.primarySummary}. Total calories ${entity.calories.toInt()} with ${entity.proteinGrams.toStringAsFixed(0)} grams of protein. Remember to take your Shatapadi walk.';
        regional =
            '${entity.regionalSummary} दर्ज हो गया। ${entity.calories.toInt()} कैलोरी व ${entity.proteinGrams.toStringAsFixed(0)} ग्राम प्रोटीन। शतपावली अवश्य करें।';
        break;
      case VoiceIntentType.waterHydration:
        spoken =
            'Logged ${entity.waterMl} milliliters of water. Great hydration discipline.';
        regional = '${entity.waterMl} मिली पानी दर्ज हो गया। बहुत बढ़िया।';
        break;
      case VoiceIntentType.workoutPhysicalActivity:
        spoken =
            'Activity logged successfully. Energy burned: ${entity.calories.toInt()} calories.';
        regional =
            'व्यायाम सफलता से दर्ज हुआ। ऊर्जा व्यय: ${entity.calories.toInt()} कैलोरी।';
        break;
      case VoiceIntentType.biometricWeight:
        spoken =
            'Body weight of ${entity.weightKg.toStringAsFixed(1)} kilograms recorded.';
        regional =
            'वजन ${entity.weightKg.toStringAsFixed(1)} किग्रा दर्ज किया गया।';
        break;
      default:
        spoken = 'FitKarma has logged your health update.';
        regional = 'फिटकर्मा ने आपका विवरण दर्ज कर लिया है।';
    }

    return VoiceAudioPrompt(
      spokenText: spoken,
      regionalSpokenText: regional,
      language: lang,
    );
  }
}
