import 'package:flutter/foundation.dart';

/// Primary Habit Identity Archetype (Swaroopa)
enum IdentityArchetype {
  dharmaYogi(
    id: 'dharma_yogi',
    title: 'Mindful Practitioner (Dharma Yogi)',
    regionalTitle: 'सजग साधक (धर्म योगी)',
    mantra: 'I live in harmony with circadian rhythms, breath, and conscious nourishment.',
    regionalMantra: 'मैं दिनचर्या, श्वास और सात्विक पोषण के साथ पूर्ण सामंजस्य में जीता हूँ।',
    corePillars: 'Circadian sync, Surya Namaskar, Shatpawali, Sattvic recovery',
    iconName: 'self_improvement',
  ),
  kshatriyaAthlete(
    id: 'kshatriya_athlete',
    title: 'Resilient Athlete (Kshatriya Warrior)',
    regionalTitle: 'शक्ति साधक (बलवान एथलीट)',
    mantra: 'I build unshakeable physical strength, progressive power, and cellular resilience.',
    regionalMantra: 'मैं अटूट शारीरिक शक्ति, निरंतर प्रगति और सुदृढ़ सामर्थ्य का निर्माण करता हूँ।',
    corePillars: 'Progressive overload, high protein density, VO2 max conditioning',
    iconName: 'fitness_center',
  ),
  urbanPacesetter(
    id: 'urban_pacesetter',
    title: 'Urban Pacesetter (Karmyogi)',
    regionalTitle: 'सक्रिय कर्मयोगी (गतिशील नेतृत्वकर्ता)',
    mantra: 'I effortlessly integrate high movement, metabolic vitality, and mental clarity.',
    regionalMantra: 'मैं व्यस्त जीवन में भी गतिशीलता, मेटाबॉलिक संतुलन और मानसिक स्पष्टता बनाए रखता हूँ।',
    corePillars: '10k steps, post-meal walks, stress regulation, micro-recovery',
    iconName: 'directions_walk',
  ),
  holisticHealer(
    id: 'holistic_healer',
    title: 'Preventive Healer (Swasthya Rakshak)',
    regionalTitle: 'स्वास्थ्य रक्षक (आरोग्य साधक)',
    mantra: 'I honor my cardiovascular health, metabolic markers, and lifelong vitality.',
    regionalMantra: 'मैं अपने हृदय स्वास्थ्य, रक्तचाप संतुलन और दीर्घायु की रक्षा करता हूँ।',
    corePillars: 'Sub-0.50 WHtR, autonomic HRV recovery, blood pressure stability',
    iconName: 'favorite',
  );

  final String id;
  final String title;
  final String regionalTitle;
  final String mantra;
  final String regionalMantra;
  final String corePillars;
  final String iconName;

  const IdentityArchetype({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.mantra,
    required this.regionalMantra,
    required this.corePillars,
    required this.iconName,
  });
}

/// Habit Identity Fusion Maturity Stage
enum IdentityFusionStage {
  jigyasu(
    level: 1,
    title: 'Seeker (Jigyasu)',
    regionalTitle: 'जिज्ञासु (आरंभिक स्तर)',
    description: 'Relying on external prompts and conscious willpower to initiate habits.',
    regionalDescription: 'आदतों को शुरू करने के लिए बाह्य प्रेरणा और सजग इच्छाशक्ति पर निर्भर।',
    minFusionScore: 0.0,
  ),
  abhyasi(
    level: 2,
    title: 'Practitioner (Abhyasi)',
    regionalTitle: 'अभ्यासी (नियमित साधक)',
    description: 'Routines are forming; behavioral friction and cognitive resistance are dropping.',
    regionalDescription: 'दैनिक दिनचर्या स्थिर हो रही है; मानसिक विरोध और आलस्य घट रहा है।',
    minFusionScore: 30.0,
  ),
  nishtha(
    level: 3,
    title: 'Embodied (Nishthavan)',
    regionalTitle: 'निष्ठावान (गहरा समर्पण)',
    description: 'Habits are deeply internalised; missing a ritual feels unnatural to your self-concept.',
    regionalDescription: 'आदतें आत्मसात हो चुकी हैं; नियम टूटना स्वाभाविक नहीं लगता।',
    minFusionScore: 65.0,
  ),
  sahaja(
    level: 4,
    title: 'Autonomous Master (Sahaja Swaroopa)',
    regionalTitle: 'सहज स्वरूप (पूर्ण एकात्मता)',
    description: 'The behavior is fully fused with your identity: "This is simply who I am."',
    regionalDescription: 'आचरण और पहचान एकाकार हो चुके हैं: "यह मेरी स्वाभाविक जीवनशैली है।"',
    minFusionScore: 85.0,
  );

  final int level;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final double minFusionScore;

  const IdentityFusionStage({
    required this.level,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.minFusionScore,
  });
}

/// Individual Identity Vote cast through a completed ritual
@immutable
class IdentityVoteRecord {
  final String id;
  final String habitName;
  final String regionalHabitName;
  final IdentityArchetype archetypeReinforced;
  final int votesCount;
  final DateTime timestamp;
  final String reinforcementMessage;
  final String regionalReinforcementMessage;

  const IdentityVoteRecord({
    required this.id,
    required this.habitName,
    required this.regionalHabitName,
    required this.archetypeReinforced,
    required this.votesCount,
    required this.timestamp,
    required this.reinforcementMessage,
    required this.regionalReinforcementMessage,
  });
}

/// Category breakdown of cumulative identity votes
@immutable
class ArchetypeVoteTally {
  final IdentityArchetype archetype;
  final int totalVotes;
  final double percentageShare;

  const ArchetypeVoteTally({
    required this.archetype,
    required this.totalVotes,
    required this.percentageShare,
  });
}

/// Comprehensive Habit Identity Report
@immutable
class HabitIdentityReport {
  final IdentityArchetype primaryArchetype;
  final IdentityFusionStage fusionStage;
  final double identityFusionScore; // 0.0 to 100.0
  final double habitAutomaticityIndex; // 0.0 to 100.0 (Fogg/Lally scale)
  final int totalVotesCast;
  final List<ArchetypeVoteTally> voteTallies;
  final List<IdentityVoteRecord> recentVotes;
  final String dailySankalpaAffirmation;
  final String regionalDailySankalpaAffirmation;
  final double cognitiveFrictionReductionPercent;

  const HabitIdentityReport({
    required this.primaryArchetype,
    required this.fusionStage,
    required this.identityFusionScore,
    required this.habitAutomaticityIndex,
    required this.totalVotesCast,
    required this.voteTallies,
    required this.recentVotes,
    required this.dailySankalpaAffirmation,
    required this.regionalDailySankalpaAffirmation,
    required this.cognitiveFrictionReductionPercent,
  });
}
