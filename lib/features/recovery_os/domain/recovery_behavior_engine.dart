import 'package:flutter/material.dart';

enum RecoveryBehaviorType {
  pranayama(
    id: 'pranayama',
    name: 'Pranayama & Box Breathing',
    regionalName: 'प्राणायाम एवं श्वास अभ्यास',
    category: 'Nervous System',
    estimatedHrvImpactMs: 6.5,
    icon: Icons.spa_rounded,
  ),
  lateCaffeineCutoff(
    id: 'late_caffeine_cutoff',
    name: 'No Caffeine After 4 PM',
    regionalName: 'शाम 4 बजे के बाद कैफीन नहीं',
    category: 'Sleep Architecture',
    estimatedHrvImpactMs: 4.0,
    icon: Icons.local_cafe_rounded,
  ),
  haldiAshwagandha(
    id: 'haldi_ashwagandha',
    name: 'Haldi Doodh / Ashwagandha',
    regionalName: 'हल्दी दूध / अश्वगंधा',
    category: 'Deep Sleep',
    estimatedHrvImpactMs: 5.5,
    icon: Icons.local_drink_rounded,
  ),
  coldContrastBath(
    id: 'cold_contrast_bath',
    name: 'Cold Shower / Contrast Bath',
    regionalName: 'ठंडा स्नान / कंट्रास्ट बाथ',
    category: 'Muscle Recovery',
    estimatedHrvImpactMs: 3.5,
    icon: Icons.shower_rounded,
  ),
  screenFreeBuffer(
    id: 'screen_free_buffer',
    name: 'Screen-Free 60m Wind-down',
    regionalName: 'सोने से 1 घंटा पहले नो-स्क्रीन',
    category: 'Circadian Melatonin',
    estimatedHrvImpactMs: 5.0,
    icon: Icons.phonelink_erase_rounded,
  ),
  postMealWalk(
    id: 'post_meal_walk',
    name: '10-Min Post-Meal Walk (शतपावली)',
    regionalName: 'भोजनोपरांत 10 मिनट टहलना',
    category: 'Metabolic Clearance',
    estimatedHrvImpactMs: 3.0,
    icon: Icons.directions_walk_rounded,
  ),
  saunaHotBath(
    id: 'sauna_hot_bath',
    name: 'Hot Bath / Steam Bath',
    regionalName: 'गर्म पानी स्नान / स्टीम',
    category: 'Vasodilation',
    estimatedHrvImpactMs: 4.5,
    icon: Icons.hot_tub_rounded,
  ),
  electrolyteHydration(
    id: 'electrolyte_hydration',
    name: 'Coconut Water / Electrolytes',
    regionalName: 'नारियल पानी / इलेक्ट्रोलाइट्स',
    category: 'Hydration',
    estimatedHrvImpactMs: 4.0,
    icon: Icons.water_drop_rounded,
  );

  final String id;
  final String name;
  final String regionalName;
  final String category;
  final double estimatedHrvImpactMs;
  final IconData icon;

  const RecoveryBehaviorType({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.category,
    required this.estimatedHrvImpactMs,
    required this.icon,
  });
}

class RecoveryPrescriptionItem {
  final RecoveryBehaviorType behavior;
  final String priorityReason;
  final String instruction;
  final bool isCompleted;

  const RecoveryPrescriptionItem({
    required this.behavior,
    required this.priorityReason,
    required this.instruction,
    this.isCompleted = false,
  });

  RecoveryPrescriptionItem copyWith({bool? isCompleted}) {
    return RecoveryPrescriptionItem(
      behavior: behavior,
      priorityReason: priorityReason,
      instruction: instruction,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class RecoveryBehaviorEngine {
  /// Generates 3 prioritized, evidence-based recovery prescriptions based on today's strain and soreness
  static List<RecoveryPrescriptionItem> generateDailyPrescriptions({
    required double currentStrain,
    required int sorenessScore,
    required double sleepDebtHours,
    Set<String> completedBehaviorIds = const {},
  }) {
    final List<RecoveryPrescriptionItem> prescriptions = [];

    // 1. High Strain (>14.0) or High Soreness (>40%) Trigger
    if (sorenessScore > 40 || currentStrain > 14.0) {
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.haldiAshwagandha,
          priorityReason: 'High muscular strain requires anti-inflammatory support.',
          instruction: 'Drink warm turmeric milk with black pepper and ashwagandha 45m before bed.',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.haldiAshwagandha.id),
        ),
      );
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.pranayama,
          priorityReason: 'Autonomic nervous system recovery boost needed.',
          instruction: 'Perform 8 minutes of Anulom Vilom (alternate nostril) or 4-7-8 breathing.',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.pranayama.id),
        ),
      );
    } else {
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.postMealWalk,
          priorityReason: 'Maintains healthy glucose disposal without adding fatigue.',
          instruction: '10-minute relaxed post-dinner stroll (शतपावली) before bedtime.',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.postMealWalk.id),
        ),
      );
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.pranayama,
          priorityReason: 'Optimal vagal nerve stimulation for overnight recovery.',
          instruction: '5 minutes of evening resonance breathing (5.5s in, 5.5s out).',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.pranayama.id),
        ),
      );
    }

    // 2. Sleep Debt (>1.5h) or General Circadian Optimization
    if (sleepDebtHours > 1.5) {
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.screenFreeBuffer,
          priorityReason: 'Cumulative sleep debt detected (+${sleepDebtHours.toStringAsFixed(1)}h).',
          instruction: 'Dim all screens 60m before bed to trigger natural melatonin release.',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.screenFreeBuffer.id),
        ),
      );
    } else {
      prescriptions.add(
        RecoveryPrescriptionItem(
          behavior: RecoveryBehaviorType.lateCaffeineCutoff,
          priorityReason: 'Protects deep sleep architecture & REM duration.',
          instruction: 'Avoid chai/coffee after 4:00 PM to clear adenosine receptor blockage.',
          isCompleted: completedBehaviorIds.contains(RecoveryBehaviorType.lateCaffeineCutoff.id),
        ),
      );
    }

    return prescriptions;
  }
}
