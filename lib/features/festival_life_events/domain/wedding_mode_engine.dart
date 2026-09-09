import 'dart:math';
import 'wedding_mode_models.dart';

/// Pure Dart Deterministic Engine for Wedding Transformation & Peak Week Protocols
class WeddingModeEngine {
  const WeddingModeEngine();

  /// Compiles a tailored wedding transformation timeline, aesthetic workouts, and skin radiance plan
  WeddingTransformationReport generateWeddingPlan({
    required WeddingRole role,
    required DateTime weddingDate,
    required double currentWeightKg,
    required double targetWeightKg,
    required double targetBodyFatPercent,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();
    final daysUntil = max(0, weddingDate.difference(now).inDays);

    // 1. Determine Timeline Phase
    WeddingTimelinePhase phase;
    if (daysUntil > 56) {
      phase = WeddingTimelinePhase.foundation;
    } else if (daysUntil > 28) {
      phase = WeddingTimelinePhase.definition;
    } else if (daysUntil > 7) {
      phase = WeddingTimelinePhase.refinement;
    } else {
      phase = WeddingTimelinePhase.peakWeek;
    }

    // 2. Generate Active Pillar Actions
    final pillarActions = _buildPillarActions(role, phase);

    // 3. Peak Week De-Bloat Strategy
    final (deBloat, regDeBloat) = _getDeBloatGuidance(phase);

    // 4. Ayurvedic Ojas Skin Radiance Protocol
    final (skin, regSkin) = _getSkinRadianceProtocol(role);

    // 5. Sangeet Stamina Tip
    final sangeetStamina = _getSangeetStaminaGuidance(role, phase);

    return WeddingTransformationReport(
      role: role,
      currentPhase: phase,
      daysUntilWedding: daysUntil,
      weddingDate: weddingDate,
      targetWeightKg: targetWeightKg,
      currentWeightKg: currentWeightKg,
      targetBodyFatPercent: targetBodyFatPercent,
      activePillarActions: pillarActions,
      peakWeekDeBloatTip: deBloat,
      regionalPeakWeekDeBloatTip: regDeBloat,
      ojasSkinRadianceProtocol: skin,
      regionalOjasSkinRadianceProtocol: regSkin,
      sangeetStaminaRecommendation: sangeetStamina,
      generatedAt: now,
    );
  }

  List<WeddingPillarItem> _buildPillarActions(WeddingRole role, WeddingTimelinePhase phase) {
    final actions = <WeddingPillarItem>[];

    // 1. Posture & Garment Drape
    if (role == WeddingRole.bride) {
      actions.add(const WeddingPillarItem(
        pillar: 'Bridal Posture & Drape',
        actionTitle: 'Scapular Retraction & Open Decolletage',
        regionalActionTitle: 'वधू मुद्रा एवं कंठ-स्कंध सुधार',
        detailedStrategy:
            'Focus on face pulls, prone Y-T-W raises, and thoracic spine mobility to ensure open shoulder drape for heavy bridal dupatta and jewelry.',
        regionalDetailedStrategy:
            'भारी दुपट्टा व आभूषणों को सहजता से धारण करने हेतु पीठ के ऊपरी हिस्से व कंधों का व्यायाम करें।',
      ));
    } else if (role == WeddingRole.groom) {
      actions.add(const WeddingPillarItem(
        pillar: 'Sherwani V-Taper Frame',
        actionTitle: 'Lateral Deltoids & Upper Lat Width',
        regionalActionTitle: 'शेरवानी वी-टेपर एवं चौड़े कंधे',
        detailedStrategy:
            'Prioritize lateral dumbbell raises, wide-grip pull-ups, and chest openers to create an athletic silhouette under tailored sherwani fits.',
        regionalDetailedStrategy:
            'शेरवानी की उत्कृष्ट फिटिंग हेतु कंधों व पीठ के ऊपरी हिस्से के विस्तार वाले व्यायाम करें।',
      ));
    } else {
      actions.add(const WeddingPillarItem(
        pillar: 'Mobility & Joint Health',
        actionTitle: 'Lower Back & Hip Flexor Decompression',
        regionalActionTitle: 'कमर व कूल्हों का तनाव निवारण',
        detailedStrategy:
            'Incorporate daily 10-minute hip opener stretches and gentle core stabilization to withstand multi-hour rituals and standing.',
        regionalDetailedStrategy:
            'लंबे समय तक खड़े रहने व पूजा-विधान हेतु कमर व जोड़ों को लचीला व मजबूत बनाएं।',
      ));
    }

    // 2. Phase-Specific Nutrition Focus
    if (phase == WeddingTimelinePhase.peakWeek) {
      actions.add(const WeddingPillarItem(
        pillar: 'Peak Week Nutrition',
        actionTitle: 'Zero-Gas & Potassium-Rich Cleansing',
        regionalActionTitle: 'गैस-रहित व पोटैशियम युक्त आहार',
        detailedStrategy:
            'Eliminate cruciferous vegetables (broccoli/cauliflower) and carbonated drinks. Hydrate with cucumber, coconut water, and boiled moong water.',
        regionalDetailedStrategy:
            'पेट फूलने वाले खाद्य पदार्थों से बचें। खीरा, नारियल पानी व मूंग सूप से हल्कापन बनाए रखें।',
      ));
    } else {
      actions.add(const WeddingPillarItem(
        pillar: 'Nutritional Periodization',
        actionTitle: 'High-Protein & Anti-Inflammatory Whole Foods',
        regionalActionTitle: 'उच्च प्रोटीन व सूजनरोधी आहार',
        detailedStrategy:
            'Target 1.6g/kg protein, rainbow antioxidants, and zero ultra-processed seed oils to foster cellular fat loss while nurturing glowing skin.',
        regionalDetailedStrategy:
            'पर्याप्त प्रोटीन, ताजे फल व हरी सब्जियों का सेवन करें तथा रिफाइंड तेल से पूरी तरह बचें।',
      ));
    }

    // 3. Autonomic Stress & Sleep Management
    actions.add(const WeddingPillarItem(
      pillar: 'Stress & Cortisol Shield',
      actionTitle: 'Ashwagandha & 4-7-8 Evening Respiration',
      regionalActionTitle: 'अश्वगंधा व तनाव मुक्ति श्वास',
      detailedStrategy:
          'Modulate pre-wedding anxiety and wedding planning cortisol spikes with 500mg KSM-66 Ashwagandha and 5 minutes of 4-7-8 parasympathetic breathing.',
      regionalDetailedStrategy:
          'विवाह की तैयारियों के तनाव को दूर करने हेतु अश्वगंधा एवं गहरी श्वास का अभ्यास करें।',
    ));

    return actions;
  }

  (String, String) _getDeBloatGuidance(WeddingTimelinePhase phase) {
    if (phase == WeddingTimelinePhase.peakWeek) {
      return (
        'Final 7 Days Peak Protocol: Maintain steady hydration (3.5L Days 1–4, 2.5L Days 5–6, sip as needed Day 7). Avoid raw onions, kidney beans, and salty snacks after 7 PM.',
        'पीक वीक नियम: प्रारंभिक ४ दिन ३.५ लीटर पानी पिएं, अंतिम २ दिन २.५ लीटर। रात ७ बजे के बाद कच्चे प्याज, राजमा व अत्यधिक नमक से पूरी तरह बचें।',
      );
    } else {
      return (
        'Consistent Daily Pacing: Drink 3L of water daily and take a 100-step Shatapadi walk after dinner to ensure zero digestive fermentation.',
        'दैनिक नियम: प्रतिदिन ३ लीटर पानी पिएं एवं भोजन पश्चात १०० कदम शतपदी भ्रमण अवश्य करें।',
      );
    }
  }

  (String, String) _getSkinRadianceProtocol(WeddingRole role) {
    return (
      'Ojas Golden Radiance: Sip warm golden saffron-turmeric milk at night with 2 soaked almonds. Take 30ml fresh Amla-Aloe vera juice in the morning for glowing Rasa & Rakta Dhatu.',
      'ओजस कांति नियम: रात्रि में केसर-हल्दी युक्त गुनगुना दूध बादाम के साथ लें। प्रातःकाल आंवला-एलोवेरा स्वरस का सेवन करें जिससे त्वचा में प्राकृतिक निखार आए।',
    );
  }

  String _getSangeetStaminaGuidance(WeddingRole role, WeddingTimelinePhase phase) {
    return 'Integrate 3 sets of 45-second high-knees and rotational core pivots 3x weekly to build effortless stamina for 2-hour Sangeet dance performances.';
  }
}
