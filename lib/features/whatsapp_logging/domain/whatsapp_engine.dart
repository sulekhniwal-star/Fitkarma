import 'whatsapp_models.dart';

/// Pure Dart Deterministic Engine for WhatsApp Message Parsing,
/// Food NLP, Water/Workout Log Extraction, and Bilingual Interactive Templates.
class WhatsAppEngine {
  const WhatsAppEngine();

  /// Formats and validates phone number to E.164 Indian format (+91XXXXXXXXXX)
  static String? normalizeIndianPhoneNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      return cleaned;
    }
    if (cleaned.startsWith('91') && cleaned.length == 12) {
      return '+$cleaned';
    }
    if (cleaned.length == 10 && RegExp(r'^[6-9]').hasMatch(cleaned)) {
      return '+91$cleaned';
    }
    return null;
  }

  /// Generates deterministic 6-digit OTP for phone verification
  String generateVerificationOtp(String phoneNumber) {
    int hash = 5381;
    for (int i = 0; i < phoneNumber.length; i++) {
      hash = ((hash << 5) + hash) + phoneNumber.codeUnitAt(i);
    }
    final int otp = (hash.abs() % 900000) + 100000;
    return otp.toString();
  }

  /// Verifies entered OTP against generated OTP
  bool verifyOtp({required String enteredOtp, required String expectedOtp}) {
    return enteredOtp.trim() == expectedOtp.trim();
  }

  /// Parses any natural WhatsApp message in English, Hindi, or Hinglish
  ParsedWhatsAppEntity parseInboundMessage(String message) {
    final lower = message.toLowerCase().trim();

    // 1. Check for quick commands
    if (_isSummaryCommand(lower)) {
      return const ParsedWhatsAppEntity(
        logType: WhatsAppLogType.quickCommand,
        parsedSummary: 'Daily Health & Macro Summary Requested',
        regionalParsedSummary: 'दैनिक स्वास्थ्य व मैक्रोज़ सारांश अनुरोधित',
      );
    }

    // 2. Check for Water / Hydration Log
    if (_isWaterLog(lower)) {
      final int ml = _extractWaterMl(lower);
      return ParsedWhatsAppEntity(
        logType: WhatsAppLogType.water,
        parsedSummary: 'Logged $ml mL of Water / Hydration',
        regionalParsedSummary: '$ml मिली जल / जलयोजन दर्ज किया गया',
        waterMl: ml,
      );
    }

    // 3. Check for Workout / Steps Log
    if (_isWorkoutOrStepsLog(lower)) {
      final (int mins, int steps, double cals) = _extractWorkoutAndSteps(lower);
      return ParsedWhatsAppEntity(
        logType: WhatsAppLogType.workout,
        parsedSummary: mins > 0 ? 'Workout logged: $mins mins (~${cals.toInt()} kcal)' : 'Steps logged: $steps steps',
        regionalParsedSummary: mins > 0 ? 'व्यायाम दर्ज: $mins मिनट (~${cals.toInt()} कैलोरी)' : 'कदम दर्ज: $steps कदम',
        workoutDurationMinutes: mins,
        stepsCount: steps,
        calories: cals,
      );
    }

    // 4. Check for Weight Log
    if (_isWeightLog(lower)) {
      final double weight = _extractWeight(lower);
      return ParsedWhatsAppEntity(
        logType: WhatsAppLogType.weight,
        parsedSummary: 'Body Weight logged: ${weight.toStringAsFixed(1)} kg',
        regionalParsedSummary: 'शारीरिक वजन दर्ज: ${weight.toStringAsFixed(1)} किग्रा',
        weightKg: weight,
      );
    }

    // 5. Default to Food / Meal Log
    return _parseMealMessage(lower, message);
  }

  bool _isSummaryCommand(String text) {
    return text == 'today' ||
        text == 'summary' ||
        text == 'macros' ||
        text == 'score' ||
        text == 'report' ||
        text == 'आज' ||
        text == 'सारांश';
  }

  bool _isWaterLog(String text) {
    return text.contains('water') ||
        text.contains('pani') ||
        text.contains('paani') ||
        text.contains('पानी') ||
        text.contains('ml') ||
        text.contains('chaas') ||
        text.contains('छाछ') ||
        text.contains('glass') ||
        text.contains('गिलास') ||
        text.contains('bottle') ||
        text.contains('coconut water') ||
        text.contains('नारियल पानी');
  }

  int _extractWaterMl(String text) {
    // Check for explicit ml (e.g. 500ml, 750 ml)
    final mlMatch = RegExp(r'(\d+)\s*(?:ml|मिली)').firstMatch(text);
    if (mlMatch != null) {
      return int.tryParse(mlMatch.group(1)!) ?? 250;
    }

    // Check for liters (e.g. 1 liter, 1.5l)
    final literMatch = RegExp(r'(\d+(?:\.\d+)?)\s*(?:l|liter|litre|लीटर)').firstMatch(text);
    if (literMatch != null) {
      final double l = double.tryParse(literMatch.group(1)!) ?? 1.0;
      return (l * 1000).toInt();
    }

    // Check for glasses (e.g. 2 glasses, 1 glass)
    final glassMatch = RegExp(r'(\d+)\s*(?:glass|glaas|गिलास|ग्लास)').firstMatch(text);
    if (glassMatch != null) {
      final int count = int.tryParse(glassMatch.group(1)!) ?? 1;
      return count * 250;
    }

    if (text.contains('coconut') || text.contains('नारियल')) return 300;
    if (text.contains('chaas') || text.contains('छाछ')) return 200;

    return 250; // default single glass
  }

  bool _isWorkoutOrStepsLog(String text) {
    return text.contains('walk') ||
        text.contains('run') ||
        text.contains('steps') ||
        text.contains('gym') ||
        text.contains('workout') ||
        text.contains('yoga') ||
        text.contains('surya namaskar') ||
        text.contains('कदम') ||
        text.contains('व्यायाम') ||
        text.contains('दौड़') ||
        text.contains('कसरत') ||
        text.contains('cycling');
  }

  (int, int, double) _extractWorkoutAndSteps(String text) {
    int durationMins = 0;
    int steps = 0;
    double calories = 0;

    // Steps (e.g. 5000 steps, 4500 कदम)
    final stepsMatch = RegExp(r'(\d+)\s*(?:steps|kadam|कदम)').firstMatch(text);
    if (stepsMatch != null) {
      steps = int.tryParse(stepsMatch.group(1)!) ?? 0;
      calories += (steps * 0.04);
    }

    // Duration (e.g. 45 mins, 30 min, 1 hour)
    final minsMatch = RegExp(r'(\d+)\s*(?:min|mins|minute|minutes|मिनट)').firstMatch(text);
    if (minsMatch != null) {
      durationMins = int.tryParse(minsMatch.group(1)!) ?? 30;
    } else if (text.contains('1 hour') || text.contains('१ घंटा')) {
      durationMins = 60;
    }

    if (durationMins > 0 && calories == 0) {
      // Average 6 METs ~ 6.5 kcal/min for 70kg individual
      calories = durationMins * 6.5;
    }

    return (durationMins, steps, calories);
  }

  bool _isWeightLog(String text) {
    return (text.contains('wt') || text.contains('weight') || text.contains('वजन')) &&
        (text.contains('kg') || RegExp(r'\d+(\.\d+)?').hasMatch(text));
  }

  double _extractWeight(String text) {
    final match = RegExp(r'(\d+(?:\.\d+)?)\s*(?:kg|kilos|किग्रा)?').firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 70.0;
    }
    return 70.0;
  }

  ParsedWhatsAppEntity _parseMealMessage(String lower, String original) {
    final List<String> identified = [];
    double totalCals = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    // 1. Roti / Chapati / Phulka
    final rotiMatch = RegExp(r'(\d+)?\s*(?:roti|rotis|chapati|chapatis|phulka|phulke|रोटी|रोटियां)').firstMatch(lower);
    if (rotiMatch != null) {
      final int qty = int.tryParse(rotiMatch.group(1) ?? '1') ?? 1;
      identified.add('$qty Roti(s)');
      totalCals += qty * 85.0;
      totalProtein += qty * 3.0;
      totalCarbs += qty * 15.0;
      totalFat += qty * 1.5;
      totalFiber += qty * 2.0;
    }

    // 2. Dal / Sambhar / Moong Dal
    if (lower.contains('dal') || lower.contains('daal') || lower.contains('दाल') || lower.contains('sambhar')) {
      int qty = 1;
      final match = RegExp(r'(\d+)?\s*(?:bowl|katori|plate)?\s*(?:dal|daal|दाल)').firstMatch(lower);
      if (match != null && match.group(1) != null) qty = int.tryParse(match.group(1)!) ?? 1;
      identified.add('$qty Bowl Dal Tadka');
      totalCals += qty * 140.0;
      totalProtein += qty * 7.0;
      totalCarbs += qty * 18.0;
      totalFat += qty * 4.0;
      totalFiber += qty * 4.0;
    }

    // 3. Rice / Chawal / Biryani
    if (lower.contains('rice') || lower.contains('chawal') || lower.contains('चावल') || lower.contains('biryani')) {
      final bool isBiryani = lower.contains('biryani');
      identified.add(isBiryani ? '1 Plate Chicken Biryani' : '1 Bowl Steamed Rice');
      totalCals += isBiryani ? 450.0 : 170.0;
      totalProtein += isBiryani ? 22.0 : 3.0;
      totalCarbs += isBiryani ? 52.0 : 38.0;
      totalFat += isBiryani ? 16.0 : 0.5;
      totalFiber += isBiryani ? 2.0 : 1.0;
    }

    // 4. Paneer / Tofu
    if (lower.contains('paneer') || lower.contains('पनीर')) {
      identified.add('100g Paneer Curry / Bhurji');
      totalCals += 240.0;
      totalProtein += 14.0;
      totalCarbs += 4.0;
      totalFat += 18.0;
      totalFiber += 1.0;
    }

    // 5. Chicken / Fish / Meat
    if (lower.contains('chicken') || lower.contains('fish') || lower.contains('चिकन')) {
      identified.add('150g Grilled/Curry Chicken');
      totalCals += 220.0;
      totalProtein += 28.0;
      totalCarbs += 4.0;
      totalFat += 8.0;
      totalFiber += 0.0;
    }

    // 6. Eggs / Omelette / Bhurji
    final eggMatch = RegExp(r'(\d+)?\s*(?:egg|eggs|अंडे|अंडा|omelet|omelette|bhurji)').firstMatch(lower);
    if (eggMatch != null) {
      final int qty = int.tryParse(eggMatch.group(1) ?? '2') ?? 2;
      identified.add('$qty Eggs / Omelette');
      totalCals += qty * 75.0;
      totalProtein += qty * 6.0;
      totalCarbs += qty * 0.5;
      totalFat += qty * 5.0;
    }

    // 7. Curd / Dahi / Raita
    if (lower.contains('curd') || lower.contains('dahi') || lower.contains('दही') || lower.contains('raita')) {
      identified.add('1 Bowl Fresh Dahi / Curd');
      totalCals += 90.0;
      totalProtein += 4.0;
      totalCarbs += 6.0;
      totalFat += 5.0;
    }

    // 8. Salad / Cucumber / Tomatoes
    if (lower.contains('salad') || lower.contains('ककड़ी') || lower.contains('खीरा') || lower.contains('सलाद')) {
      identified.add('1 Bowl Fresh Green Salad');
      totalCals += 40.0;
      totalProtein += 1.0;
      totalCarbs += 8.0;
      totalFat += 0.5;
      totalFiber += 3.0;
    }

    // 9. South Indian (Idli, Dosa)
    if (lower.contains('idli') || lower.contains('इ़डली')) {
      identified.add('2 Steamed Idlis with Sambar');
      totalCals += 160.0;
      totalProtein += 5.0;
      totalCarbs += 32.0;
      totalFat += 1.0;
      totalFiber += 3.0;
    } else if (lower.contains('dosa') || lower.contains('डोसा')) {
      identified.add('1 Plain/Masala Dosa');
      totalCals += 220.0;
      totalProtein += 4.5;
      totalCarbs += 36.0;
      totalFat += 6.0;
      totalFiber += 2.0;
    }

    // If no specific item detected, provide generic wholesome meal estimate
    if (identified.isEmpty) {
      identified.add('Indian Thali / Mixed Meal');
      totalCals = 380.0;
      totalProtein = 12.0;
      totalCarbs = 50.0;
      totalFat = 14.0;
      totalFiber = 5.0;
    }

    return ParsedWhatsAppEntity(
      logType: WhatsAppLogType.meal,
      parsedSummary: identified.join(', '),
      regionalParsedSummary: identified.join(', '),
      calories: totalCals,
      proteinGrams: totalProtein,
      carbsGrams: totalCarbs,
      fatGrams: totalFat,
      fiberGrams: totalFiber,
      identifiedItems: identified,
    );
  }

  /// Formats WhatsApp Bot Outbound Response in Markdown with emojis
  String formatBotReply(ParsedWhatsAppEntity parsed, {required String language}) {
    final bool isHindi = language == 'hi';

    switch (parsed.logType) {
      case WhatsAppLogType.meal:
        if (isHindi) {
          return '''*✅ फिटकर्मा भोजन दर्ज! 🥗*
━━━━━━━━━━━━━━━━━
🍽️ *घटक:* ${parsed.parsedSummary}
🔥 *कैलोरी:* ${parsed.calories.toInt()} kcal
💪 *प्रोटीन:* ${parsed.proteinGrams.toStringAsFixed(1)}g
🌾 *कार्ब्स:* ${parsed.carbsGrams.toStringAsFixed(1)}g
🥑 *फैट:* ${parsed.fatGrams.toStringAsFixed(1)}g
🌿 *फाइबर:* ${parsed.fiberGrams.toStringAsFixed(1)}g

🚶‍♂️ *सलाह:* भोजनोपरांत १०० कदम शतपावली अवश्य करें!''';
        }
        return '''*✅ FitKarma Logged! 🥗*
━━━━━━━━━━━━━━━━━
🍽️ *Items:* ${parsed.parsedSummary}
🔥 *Calories:* ${parsed.calories.toInt()} kcal
💪 *Protein:* ${parsed.proteinGrams.toStringAsFixed(1)}g
🌾 *Carbs:* ${parsed.carbsGrams.toStringAsFixed(1)}g
🥑 *Fat:* ${parsed.fatGrams.toStringAsFixed(1)}g
🌿 *Fiber:* ${parsed.fiberGrams.toStringAsFixed(1)}g

🚶‍♂️ *Tip:* Take a 100-step Shatapadi walk to blunt post-prandial glucose spike!''';

      case WhatsAppLogType.water:
        if (isHindi) {
          return '''*💧 जलयोजन दर्ज!*
━━━━━━━━━━━━━━━━━
+${parsed.waterMl} mL जल सफलता से दर्ज हुआ।
दिनभर में ३ लीटर का लक्ष्य पूर्ण करें! 🥥''';
        }
        return '''*💧 Hydration Logged!*
━━━━━━━━━━━━━━━━━
+${parsed.waterMl} mL successfully logged.
Stay on track towards your 3,000 mL daily goal! 🥥''';

      case WhatsAppLogType.workout:
        if (isHindi) {
          return '''*🔥 व्यायाम व सक्रियता दर्ज!*
━━━━━━━━━━━━━━━━━
${parsed.workoutDurationMinutes > 0 ? "⏱️ अवधि: ${parsed.workoutDurationMinutes} मिनट" : ""}
${parsed.stepsCount > 0 ? "👟 कदम: ${parsed.stepsCount}" : ""}
⚡ अनुमानित ऊर्जा व्यय: ~${parsed.calories.toInt()} kcal
उत्कृष्ट समर्पण! 🧘‍♂️''';
        }
        return '''*🔥 Workout & Activity Logged!*
━━━━━━━━━━━━━━━━━
${parsed.workoutDurationMinutes > 0 ? "⏱️ Duration: ${parsed.workoutDurationMinutes} mins" : ""}
${parsed.stepsCount > 0 ? "👟 Steps: ${parsed.stepsCount}" : ""}
⚡ Energy Burned: ~${parsed.calories.toInt()} kcal
Keep the Karma streak alive! 🧘‍♂️''';

      case WhatsAppLogType.weight:
        if (isHindi) {
          return '''*⚖️ वजन दर्ज:* ${parsed.weightKg.toStringAsFixed(1)} kg
शारीरिक परिवर्तन ग्राफ में अपडेट कर दिया गया है।''';
        }
        return '''*⚖️ Weight Logged:* ${parsed.weightKg.toStringAsFixed(1)} kg
Successfully synced with your Body Analytics Blueprint.''';

      case WhatsAppLogType.quickCommand:
        if (isHindi) {
          return '''*📊 दैनिक स्वास्थ्य सारांश (FitKarma OS)*
━━━━━━━━━━━━━━━━━
🔥 कैलोरी: १२४० / २१०० kcal
💪 प्रोटीन: ७८ / १२५ g
💧 जल: २१०० / ३००० mL
👟 कदम: ७४२० / १००००
✨ कर्म स्कोर: ९२ (उत्कृष्ट)''';
        }
        return '''*📊 Daily Health Summary (FitKarma OS)*
━━━━━━━━━━━━━━━━━
🔥 Calories: 1,240 / 2,100 kcal
💪 Protein: 78 / 125 g
💧 Water: 2,100 / 3,000 mL
👟 Steps: 7,420 / 10,000
✨ Karma Score: 92 (Optimal Trajectory)''';

      case WhatsAppLogType.general:
        return 'FitKarma AI Coach is here! You can text your meals, water intake, workouts, or "today" for your daily summary.';
    }
  }

  /// Builds interactive template JSON payload for WhatsApp Business Cloud API
  Map<String, dynamic> buildInteractiveTemplatePayload({
    required WhatsAppTemplateType templateType,
    required String recipientPhone,
    Map<String, String>? parameters,
  }) {
    switch (templateType) {
      case WhatsAppTemplateType.morningReadiness:
        return {
          'messaging_product': 'whatsapp',
          'to': recipientPhone,
          'type': 'interactive',
          'interactive': {
            'type': 'button',
            'header': {'type': 'text', 'text': '🌅 FitKarma Morning Briefing'},
            'body': {
              'text': parameters?['bodyText'] ??
                  'Good morning! Your Readiness Score is 88/100 (Optimal). Jatharagni is primed. Recommended workout: Upper Body Strength at 07:30 AM.'
            },
            'action': {
              'buttons': [
                {'type': 'reply', 'reply': {'id': 'log_breakfast', 'title': '🍳 Log Breakfast'}},
                {'type': 'reply', 'reply': {'id': 'view_plan', 'title': '🏋️ View Workout'}},
              ]
            }
          }
        };

      case WhatsAppTemplateType.postMealShatapadi:
        return {
          'messaging_product': 'whatsapp',
          'to': recipientPhone,
          'type': 'interactive',
          'interactive': {
            'type': 'button',
            'header': {'type': 'text', 'text': '🚶 100-Step Shatapadi Reminder'},
            'body': {
              'text': 'Post-meal glycemic window active! A light 10-minute stroll will blunt blood sugar spikes and boost digestion.'
            },
            'action': {
              'buttons': [
                {'type': 'reply', 'reply': {'id': 'start_walk', 'title': '✅ Walking Now'}},
                {'type': 'reply', 'reply': {'id': 'log_water', 'title': '💧 Log Water'}},
              ]
            }
          }
        };

      case WhatsAppTemplateType.waterHydrationNudge:
        return {
          'messaging_product': 'whatsapp',
          'to': recipientPhone,
          'type': 'interactive',
          'interactive': {
            'type': 'button',
            'header': {'type': 'text', 'text': '💧 Afternoon Hydration Check'},
            'body': {
              'text': 'You are at 1,400 mL / 3,000 mL daily target. Grab a glass of water, coconut water, or Nimbu-Pani!'
            },
            'action': {
              'buttons': [
                {'type': 'reply', 'reply': {'id': 'log_250ml', 'title': '+250 mL'}},
                {'type': 'reply', 'reply': {'id': 'log_500ml', 'title': '+500 mL'}},
              ]
            }
          }
        };

      case WhatsAppTemplateType.eveningRecap:
        return {
          'messaging_product': 'whatsapp',
          'to': recipientPhone,
          'type': 'interactive',
          'interactive': {
            'type': 'button',
            'header': {'type': 'text', 'text': '🌙 Nightly Karma & Macro Recap'},
            'body': {
              'text': 'Daily mission completed: 92% adherence. Digital sunset begins at 21:30 for melatonin optimization.'
            },
            'action': {
              'buttons': [
                {'type': 'reply', 'reply': {'id': 'view_score', 'title': '✨ Karma Score'}},
              ]
            }
          }
        };
    }
  }
}
