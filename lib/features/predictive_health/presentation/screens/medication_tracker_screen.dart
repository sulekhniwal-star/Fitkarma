import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/models/predictive_health_models.dart';
import '../../domain/services/medication_safety_engine.dart';

class MedicationTrackerScreen extends StatefulWidget {
  final String userId;

  const MedicationTrackerScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MedicationTrackerScreen> createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final _safetyEngine = const MedicationSafetyEngine();
  late List<MedicationSchedule> _meds;

  @override
  void initState() {
    super.initState();
    _meds = [
      MedicationSchedule(
        id: 'med-1',
        userId: widget.userId,
        medicationName: 'Thyronorm (Levothyroxine)',
        dosage: '50 mcg',
        frequency: 'Once Daily (Morning Empty Stomach)',
        timingCategory: 'Morning (06:30 AM)',
        foodInteractionWarning: _safetyEngine.getFoodInteractionWarning('Thyronorm'),
        foodInteractionWarningHindi: _safetyEngine.getFoodInteractionWarningHindi('Thyronorm'),
        isTakenToday: true,
      ),
      MedicationSchedule(
        id: 'med-2',
        userId: widget.userId,
        medicationName: 'Metformin SR',
        dosage: '500 mg',
        frequency: 'Once Daily with Dinner',
        timingCategory: 'Dinner (08:00 PM)',
        foodInteractionWarning: _safetyEngine.getFoodInteractionWarning('Metformin'),
        foodInteractionWarningHindi: _safetyEngine.getFoodInteractionWarningHindi('Metformin'),
        isTakenToday: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Text('Medication & Chrono-Safety', style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.accentAmber,
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.accentAmber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Food-Drug Chrono Safety Shield', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Automatic reminders and nutrient timing interaction warnings.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Active Prescriptions & Timings', style: AppTypography.h3),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _meds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final med = _meds[index];
                return BentoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(med.medicationName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text('${med.dosage} • ${med.timingCategory}', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryCyan)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              med.isTakenToday ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: med.isTakenToday ? AppColors.primaryEmerald : AppColors.textMuted,
                              size: 26,
                            ),
                            onPressed: () {
                              setState(() {
                                _meds[index] = MedicationSchedule(
                                  id: med.id,
                                  userId: med.userId,
                                  medicationName: med.medicationName,
                                  dosage: med.dosage,
                                  frequency: med.frequency,
                                  timingCategory: med.timingCategory,
                                  foodInteractionWarning: med.foodInteractionWarning,
                                  foodInteractionWarningHindi: med.foodInteractionWarningHindi,
                                  isTakenToday: !med.isTakenToday,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      if (med.foodInteractionWarning != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmber.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.accentAmber.withAlpha(60)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.accentAmber),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(med.foodInteractionWarning!, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11)),
                                    if (med.foodInteractionWarningHindi != null) ...[
                                      const SizedBox(height: 4),
                                      Text(med.foodInteractionWarningHindi!, style: AppTypography.bodySmall.copyWith(color: AppColors.accentAmber, fontSize: 10, fontStyle: FontStyle.italic)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
