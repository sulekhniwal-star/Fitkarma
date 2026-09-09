import 'life_event_models.dart';

/// Pure Dart Deterministic Engine for Life Events & Routine Disruption Adaptation
class LifeEventEngine {
  const LifeEventEngine();

  /// Generates dynamic life event adaptation report and grace streak protections
  LifeEventAdaptiveReport generateAdaptivePlan({
    required LifeEventCategory event,
    int daysElapsed = 3,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    // 1. Determine Transition Phase
    TransitionPhase phase;
    int stepGoal;
    int workoutMins;

    if (daysElapsed <= 7) {
      phase = TransitionPhase.acuteDisruption;
      stepGoal = 5000;
      workoutMins = 15;
    } else if (daysElapsed <= 21) {
      phase = TransitionPhase.stabilization;
      stepGoal = 7000;
      workoutMins = 25;
    } else {
      phase = TransitionPhase.progressiveReEntry;
      stepGoal = 9000;
      workoutMins = 40;
    }

    // 2. Pillar Adjustments
    final pillarAdjustments = _buildPillarAdjustments(event, phase, stepGoal, workoutMins);

    // 3. Ayurvedic Nervine / Medhya Rasayana Tonic
    final (tonic, regTonic) = _getAyurvedicTonic(event);

    // 4. Supportive Compassionate Message
    final (msg, regMsg) = _getSupportiveMessage(event, phase);

    return LifeEventAdaptiveReport(
      activeEvent: event,
      currentPhase: phase,
      daysElapsedInEvent: daysElapsed,
      isGraceStreakFreezeActive: true,
      stepGoalAdjustment: stepGoal,
      workoutDurationMinutes: workoutMins,
      nutritionMode: event.recommendedMode,
      pillarAdjustments: pillarAdjustments,
      ayurvedicNervineTonic: tonic,
      regionalAyurvedicTonic: regTonic,
      supportiveCoachMessage: msg,
      regionalSupportiveCoachMessage: regMsg,
      generatedAt: now,
    );
  }

  List<LifeEventPillarAdjustment> _buildPillarAdjustments(
    LifeEventCategory event,
    TransitionPhase phase,
    int stepGoal,
    int workoutMins,
  ) {
    switch (event) {
      case LifeEventCategory.examCrunch:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Physical Activity',
            originalTarget: '60 min heavy lifting / 10,000 steps',
            adaptedTarget: '$workoutMins min desk mobility + $stepGoal steps',
            rationale: 'Prevent physical exhaustion so maximum glucose & oxygen reach cerebral cortex.',
            regionalRationale: 'मानसिक एकाग्रता बढ़ाने हेतु भारी व्यायाम के स्थान पर हल्का संचलन करें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Cognitive Nutrition',
            originalTarget: 'Strict caloric deficit',
            adaptedTarget: 'Iso-caloric maintenance + Omega-3s & walnuts',
            rationale: 'Avoid brain fog; supply continuous steady glucose for hippocampal memory retention.',
            regionalRationale: 'स्मृति व एकाग्रता बनाए रखने हेतु अखरोट व संतुलित पोषण लें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Circadian Sleep Buffer',
            originalTarget: 'Fixed 06:00 wake time',
            adaptedTarget: '7.5h anchor with 20-min pre-exam Yoga Nidra',
            rationale: 'Deep sleep is mandatory for memory consolidation and neural synaptic clearing.',
            regionalRationale: 'याददाश्त सुदृढ़ करने के लिए गहरी नींद व योग निद्रा अत्यंत आवश्यक है।',
          ),
        ];

      case LifeEventCategory.newParenthood:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Movement & Posture',
            originalTarget: 'Gym progressive overload',
            adaptedTarget: '$workoutMins min stroller walk + core & thoracic spine opening',
            rationale: 'Relieve posture strain from baby carrying while keeping cardiovascular tone active.',
            regionalRationale: 'शिशु को गोद लेने से उत्पन्न पीठ के खिंचाव को दूर करने हेतु वक्ष-खिंचाव व्यायाम करें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Fractional Sleep Preservation',
            originalTarget: '8h uninterrupted sleep',
            adaptedTarget: 'Polyphasic nap stacking + Brahmari pranayama',
            rationale: 'Embrace micro-sleep windows and calm maternal/paternal autonomic anxiety.',
            regionalRationale: 'छोटे-छोटे विश्राम सत्रों (नैप्स) एवं भ्रामरी प्राणायाम से ऊर्जा संचित करें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Convenience Nutrition',
            originalTarget: 'Complex meal prep',
            adaptedTarget: 'One-pot nutrient-dense stews & soaked nuts',
            rationale: 'Minimize cooking stress while ensuring high micronutrient and lactation support.',
            regionalRationale: 'सरल व पौष्टिक एक-बर्तन भोजन (खिचड़ी/दलिया) अपनाएं।',
          ),
        ];

      case LifeEventCategory.careerShift:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Metabolic Workouts',
            originalTarget: '5 days/week gym split',
            adaptedTarget: '$workoutMins min morning HIIT / dumbbell circuit ($stepGoal steps)',
            rationale: 'Maintain insulin sensitivity during high-stress workplace onboarding.',
            regionalRationale: 'कार्यस्थल के तनाव को नियंत्रित करने हेतु सुबह १५-२० मिनट का संक्षिप्त व्यायाम करें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Stress Shielding',
            originalTarget: 'Standard tracking',
            adaptedTarget: 'Ashwagandha cortisol blunting + Box breathing',
            rationale: 'Blunt sympathetic cortisol spikes before critical business presentations.',
            regionalRationale: 'अश्वगंधा व प्राणायाम द्वारा कार्य संबंधी मानसिक तनाव को शांत रखें।',
          ),
        ];

      case LifeEventCategory.relocation:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Equipment-Free Movement',
            originalTarget: 'Barbell & machine regimen',
            adaptedTarget: '$workoutMins min bodyweight calisthenics + $stepGoal box-carrying steps',
            rationale: 'Leverage functional relocation movement without losing neuromuscular connection.',
            regionalRationale: 'बिना जिम उपकरणों के शारीरिक भार आधारित व्यायाम से सक्रिय रहें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Local Sourcing Mode',
            originalTarget: 'Specific brand grocery tracking',
            adaptedTarget: 'Fresh local sabzi mandi whole foods',
            rationale: 'Adapt flexibly to new neighborhood markets without diet tracking friction.',
            regionalRationale: 'स्थानीय ताजी सब्जियों व फलों से संतुलित पोषण प्राप्त करें।',
          ),
        ];

      case LifeEventCategory.postIllnessRecovery:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Restorative Movement',
            originalTarget: 'High-intensity interval training',
            adaptedTarget: '$workoutMins min gentle joint rotations (Sukshma Vyayama) + $stepGoal steps',
            rationale: 'Protect heart rate variability and avoid post-viral chronic fatigue flare-ups.',
            regionalRationale: 'हल्के सूक्ष्म व्यायाम करें ताकि हृदय गति व ऊर्जा पर अतिरिक्त भार न पड़े।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Agni Rebuilding Diet',
            originalTarget: 'High-fiber raw salads',
            adaptedTarget: 'Warm Moong broth & spiced herbal teas',
            rationale: 'Kindle compromised digestive Agni and eliminate residual Ama endotoxins.',
            regionalRationale: 'पाचन अग्नि को सुदृढ़ करने हेतु सुपाच्य मूंग दाल सूप व काढ़ा लें।',
          ),
        ];

      case LifeEventCategory.griefRecovery:
        return [
          LifeEventPillarAdjustment(
            pillarTitle: 'Grounding & Nature',
            originalTarget: 'Rigid fitness metrics',
            adaptedTarget: '$stepGoal gentle outdoor walking in green space + silence',
            rationale: 'Harness somatic grounding and gentle sunlight to regulate emotional state.',
            regionalRationale: 'प्राकृतिक वातावरण में शांतिपूर्वक टहलें और स्वयं को विश्राम दें।',
          ),
          const LifeEventPillarAdjustment(
            pillarTitle: 'Nourishment Grace',
            originalTarget: 'Strict macronutrient goals',
            adaptedTarget: 'Warm comfort foods & hydration reminders',
            rationale: 'Provide compassionate nutritional sustenance without guilt or tracking pressure.',
            regionalRationale: 'बिना किसी दबाव के गर्म व सात्विक भोजन से शरीर को पोषण दें।',
          ),
        ];
    }
  }

  (String, String) _getAyurvedicTonic(LifeEventCategory event) {
    switch (event) {
      case LifeEventCategory.examCrunch:
        return (
          'Brahmi & Shankhpushpi Medhya Rasayana (1 tsp in warm milk/water) for neuro-synaptic focus.',
          'ब्राह्मी एवं शंखपुष्पी मेध्य रसायन का सेवन करें जो एकाग्रता व स्मरण शक्ति बढ़ाता है।',
        );
      case LifeEventCategory.newParenthood:
        return (
          'Shatavari & Dashamoola Ksheerapaka for deep tissue rejuvenation and nervous calm.',
          'शतावरी व दशमूल का सेवन करें जो शरीर को नवऊर्जा व मानसिक शांति प्रदान करता है।',
        );
      case LifeEventCategory.careerShift:
        return (
          'KSM-66 Ashwagandha (500mg) at bedtime to modulate adrenal cortisol spikes.',
          'अश्वगंधा का सेवन करें जो कार्यस्थल के तनाव व कोर्टिसोल स्तर को नियंत्रित करता है।',
        );
      case LifeEventCategory.relocation:
        return (
          'Tulsi-Ginger-Giloy herbal infusion to fortify immune resilience against climate shifts.',
          'तुलसी, अदरक व गिलोय का काढ़ा लें जो नए वातावरण में रोग प्रतिरोधक क्षमता बढ़ाता है।',
        );
      case LifeEventCategory.postIllnessRecovery:
        return (
          'Amritarishta & Drakshasava with warm water post-meals to restore Ojas vitality.',
          'अमृतारिष्ट व द्राक्षासव का सेवन करें जो शरीर में ओजस व शक्ति का पुनः संचार करता है।',
        );
      case LifeEventCategory.griefRecovery:
        return (
          'Arjuna Ksheerapaka (Heart Tonic) & Jatamansi for emotional soothing and heart center peace.',
          'अर्जुन व जटामांसी का सेवन करें जो हृदय व मन को शांति व संबल प्रदान करता है।',
        );
    }
  }

  (String, String) _getSupportiveMessage(LifeEventCategory event, TransitionPhase phase) {
    switch (phase) {
      case TransitionPhase.acuteDisruption:
        return (
          'FitKarma has activated Grace Streak Freeze. Your health is about supporting your life—not competing with it. Focus on what matters today.',
          'फिटकर्मा ने ग्रेस स्ट्रीक फ्रीज सक्रिय कर दिया है। स्वास्थ्य जीवन को संबल देने के लिए है, तनाव बढ़ाने के लिए नहीं। आज जो महत्वपूर्ण है उस पर ध्यान दें।',
        );
      case TransitionPhase.stabilization:
        return (
          'You are navigating this transition with resilience. We are gradually expanding your daily micro-habits as routine stabilizes.',
          'आप इस बदलाव को कुशलता से संभाल रहे हैं। जैसे-जैसे दिनचर्या स्थिर हो रही है, हम सूक्ष्म आदतों को विस्तार दे रहे हैं।',
        );
      case TransitionPhase.progressiveReEntry:
        return (
          'Welcome back to full baseline momentum! Your strength through this transition is your real fitness victory.',
          'पुनः मुख्य लय में आपका स्वागत है! इस जीवन परिवर्तन को सफलतापूर्वक पार करना ही आपकी वास्तविक स्वास्थ्य विजय है।',
        );
    }
  }
}
