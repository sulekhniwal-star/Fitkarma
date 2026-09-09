import 'ai_roast_models.dart';

/// Pure Dart Deterministic Engine for Culturally Relatable Indian AI Roasts & Tough Love
class AiRoastEngine {
  const AiRoastEngine();

  /// Generates a structured roast artifact based on persona, intensity, and scenario trigger
  RoastMessageArtifact generateRoast({
    required RoastPersona persona,
    required RoastIntensity intensity,
    required RoastTriggerEvent trigger,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    final (headline, en, hi, challenge, regChallenge) = _selectRoastContent(persona, intensity, trigger);

    return RoastMessageArtifact(
      id: 'roast_${now.millisecondsSinceEpoch}',
      persona: persona,
      intensity: intensity,
      trigger: trigger,
      headlinePunchline: headline,
      fullRoastEnglish: en,
      fullRoastHindi: hi,
      actionableActionChallenge: challenge,
      regionalActionChallenge: regChallenge,
      generatedAt: now,
    );
  }

  /// System instruction builder for Groq LLM real-time streaming roast generation
  String buildSystemInstruction(RoastPersona persona, RoastIntensity intensity) {
    return '''
You are the "${persona.name}" AI coach on FitKarma. Your job is to deliver witty, culturally authentic Indian tough-love roasts to keep the user accountable.
Intensity Level: ${intensity.name}.
Catchphrase: "${persona.catchphrase}"
Guidelines:
1. Use sharp, hilarious, and relatable Desi references (Sharma ji ka beta, Swiggy late night, gym reel scrolling, Agni/Dosha imbalance).
2. NEVER use abusive slurs, hate speech, or body shaming. Keep it strictly about behavioral accountability, habits, and self-discipline.
3. Always conclude with a quick, punchy, immediate physical challenge (e.g. 20 pushups, 500ml water, 10-min walk).
''';
  }

  (String, String, String, String, String) _selectRoastContent(
    RoastPersona persona,
    RoastIntensity intensity,
    RoastTriggerEvent trigger,
  ) {
    switch (trigger) {
      case RoastTriggerEvent.missedWorkout:
        if (persona == RoastPersona.desiGymBro) {
          return (
            'Bhai Reel Scroll Karne Se Muscle Nahi Bante!',
            'You snoozed the alarm and scrolled Instagram gym reels for 45 minutes thinking you were "absorbing gains via osmosis". Newsflash: Thumb curls don’t build deltoids.',
            'अलार्म बंद करके ४५ मिनट रील्स देखने से मांसपेशियां नहीं बनतीं भाई! अंगूठे से स्क्रोल करने को व्यायाम नहीं कहते।',
            'Drop down and give me 25 pushups right now to redeem your Karma score.',
            'अभी तुरंत २५ पुश-अप्स लगाएं और अपना कर्मा स्कोर सुधारें।',
          );
        } else if (persona == RoastPersona.strictDesiParent) {
          return (
            'Sharma Ji Ka Beta Subah 5 Baje Doad Raha Hai!',
            'Look at Sharma ji’s son—already ran 5k and studying, while you are cocooned under the blanket giving motivational speeches to your ceiling.',
            'शर्मा जी के बेटे को देखो—सुबह ५ बजे उठकर दौड़ भी आया, और तुम रजाई में सोकर छत को घूर रहे हो!',
            'Get out of bed, drink 2 glasses of water, and do a 15-minute brisk walk.',
            'बिस्तर छोड़ो, २ गिलास पानी पियो और १५ मिनट तेज गति से चलो।',
          );
        } else {
          return (
            'Tamasik Inertia Has Trapped Your Prana!',
            'Your Kapha dosha is so high right now that the bed has filed for joint custody. Rise up before your Agni completely extinguishes.',
            'कफ दोष इतना बढ़ गया है कि बिस्तर ने तुम्हें गोद ले लिया है! उठो इससे पहले कि जठराग्नि शांत हो जाए।',
            'Do 5 rounds of Surya Namaskar immediately to ignite your digestive fire.',
            'तत्काल ५ चक्र सूर्य नमस्कार करें ताकि शरीर में ऊर्जा का संचार हो।',
          );
        }

      case RoastTriggerEvent.lateNightJunkOrder:
        if (persona == RoastPersona.desiGymBro) {
          return (
            'Midnight Butter Chicken Is Not An Anabolic Window!',
            'Bro, ordering extra cheese garlic bread at 12:30 AM is not "carb loading for tomorrow’s leg day"—it’s pure sabotage.',
            'रात १२:३० बजे चीज़ गार्लिक ब्रेड और बटर चिकन मंगाना "कार्ब लोडिंग" नहीं है भाई, यह सरासर धोखा है!',
            'Drink a large glass of warm water and close the food delivery apps.',
            'एक बड़ा गिलास गुनगुना पानी पिएं और डिलीवरी ऐप तुरंत बंद करें।',
          );
        } else {
          return (
            'Swiggy Delivery Guy Knows Your Address Better Than Your Relatives!',
            'At this rate, the midnight delivery driver will be invited to family weddings. Put the phone down and drink warm water.',
            'इतने ऑर्डर्स के बाद तो डिलीवरी वाला पारिवारिक शादियों में भी न्योता मांगने लगेगा! फोन रखो और पानी पियो।',
            'Sip warm water with a pinch of ginger to settle your nighttime cravings.',
            'अदरक युक्त गुनगुना पानी पिएं और रात की लालसा को शांत करें।',
          );
        }

      case RoastTriggerEvent.sedentarySlump:
        return (
          'Are You Applying For Permanent Furniture Status?',
          'You’ve been glued to that chair for 3.5 hours straight without blinking. The only thing you are currently building is cervical spondylosis.',
          'साढ़े तीन घंटे से कुर्सी से चिपके हो! इस तरह सिर्फ गर्दन का दर्द अनलॉक होगा, सिक्स पैक नहीं।',
          'Stand up immediately, do 15 air squats and roll your shoulders 10 times.',
          'तुरंत खड़े हों, १५ उठक-बैठक करें और कंधों को घुमाएं।',
        );

      case RoastTriggerEvent.skippedWaterHydration:
        return (
          'Even Cactus Plants Drink More Water Than You!',
          'Your total water intake today is 400ml and 3 cups of cutting chai. Your kidneys are currently crying in Morse code.',
          'आज दिन भर में सिर्फ ४०० मिली पानी और ३ कप चाय? आपकी किडनियां मदद की गुहार लगा रही हैं!',
          'Chug 500ml of room temperature water right now before touching anything else.',
          'कुछ भी और करने से पूर्व अभी ५०० मिली पानी पिएं।',
        );

      case RoastTriggerEvent.smashingGoals:
        return (
          'Dekho Dekho, Kisi Ne Aaj Dhang Ka Kaam Kiya!',
          'Well, well, look who actually completed their entire mission without crying. Good job! Now don’t post 8 celebratory stories about it—stay humble and show up tomorrow.',
          'अरे वाह! आज बिना किसी बहाने के पूरा लक्ष्य हासिल कर लिया। बहुत बढ़िया! अब सोशल मीडिया पर ढिंढोरा मत पीटो, कल भी यही लय बनाए रखो।',
          'Lock in your recovery shake and prep your workout gear for tomorrow morning.',
          'अपना रिकवरी ड्रिंक लें और कल सुबह के व्यायाम की तैयारी अभी से करें।',
        );
    }
  }
}
