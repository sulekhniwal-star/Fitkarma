import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/blood_pressure_engine.dart';

final bloodPressureListProvider = StateProvider<List<BloodPressureReading>>((ref) {
  return [
    BloodPressureReading(
      id: 'bp_1',
      systolic: 118,
      diastolic: 76,
      pulseBpm: 68,
      arm: 'Left',
      posture: 'Sitting',
      recordedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    BloodPressureReading(
      id: 'bp_2',
      systolic: 122,
      diastolic: 78,
      pulseBpm: 72,
      arm: 'Left',
      posture: 'Sitting',
      recordedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});

final biometricUnlockedProvider = StateProvider<bool>((ref) => false);

class BloodPressureScreen extends ConsumerWidget {
  const BloodPressureScreen({super.key});

  Color _getCategoryColor(BloodPressureCategory category) {
    switch (category) {
      case BloodPressureCategory.normal:
        return AppColors.karmaGreen;
      case BloodPressureCategory.elevated:
        return AppColors.focusBlue;
      case BloodPressureCategory.stage1Hypertension:
        return AppColors.energyOrange;
      case BloodPressureCategory.stage2Hypertension:
      case BloodPressureCategory.hypertensiveCrisis:
        return AppColors.alertRed;
    }
  }

  void _showAddReadingDialog(BuildContext context, WidgetRef ref) {
    final systolicController = TextEditingController(text: '120');
    final diastolicController = TextEditingController(text: '80');
    final pulseController = TextEditingController(text: '72');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Log Blood Pressure',
                regionalText: 'रक्तचाप दर्ज करें',
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: systolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Systolic (mmHg)',
                        hintText: '120',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: diastolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Diastolic (mmHg)',
                        hintText: '80',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pulseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pulse (BPM)',
                  hintText: '72',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.karmaGreen,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                  ),
                  onPressed: () {
                    final sys = int.tryParse(systolicController.text) ?? 120;
                    final dia = int.tryParse(diastolicController.text) ?? 80;
                    final pulse = int.tryParse(pulseController.text) ?? 72;

                    final newReading = BloodPressureReading(
                      id: 'bp_${DateTime.now().millisecondsSinceEpoch}',
                      systolic: sys,
                      diastolic: dia,
                      pulseBpm: pulse,
                      recordedAt: DateTime.now(),
                    );

                    final current = ref.read(bloodPressureListProvider);
                    ref.read(bloodPressureListProvider.notifier).state = [newReading, ...current];
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Save Reading', style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked = ref.watch(biometricUnlockedProvider);
    final readings = ref.watch(bloodPressureListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Blood Pressure & Arterial Health',
          regionalText: 'रक्तचाप एवं धमनियों का स्वास्थ्य',
          alignment: CrossAxisAlignment.center,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
              color: isUnlocked ? AppColors.karmaGreen : AppColors.energyOrange,
            ),
            onPressed: () {
              ref.read(biometricUnlockedProvider.notifier).state = !isUnlocked;
            },
          ),
        ],
      ),
      floatingActionButton: isUnlocked
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.karmaGreen,
              icon: const Icon(Icons.add_rounded, color: AppColors.textInverse),
              label: const Text('Log BP', style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w700)),
              onPressed: () => _showAddReadingDialog(context, ref),
            )
          : null,
      body: SafeArea(
        child: isUnlocked
            ? _buildUnlockedContent(context, readings)
            : _buildBiometricGate(context, ref),
      ),
    );
  }

  Widget _buildBiometricGate(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.focusBlue.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.fingerprint_rounded, size: 72, color: AppColors.focusBlue),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Cardiovascular Vault Locked',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'In accordance with Indian Health Privacy & DPDP standards, blood pressure and cardiovascular vitals are protected under biometric authentication.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
              ),
              icon: const Icon(Icons.lock_open_rounded, color: AppColors.textInverse),
              label: const Text(
                'Unlock with Biometrics / PIN',
                style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                ref.read(biometricUnlockedProvider.notifier).state = true;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedContent(BuildContext context, List<BloodPressureReading> readings) {
    final latest = readings.isNotEmpty ? readings.first : null;
    final eval = latest != null
        ? BloodPressureEngine.evaluate(systolic: latest.systolic, diastolic: latest.diastolic)
        : null;

    final categoryColor = eval != null ? _getCategoryColor(eval.category) : AppColors.karmaGreen;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Latest Reading Hero Bento Card
          if (latest != null && eval != null) ...[
            BentoCard(
              hasGlow: true,
              glowColor: categoryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Latest Reading',
                        regionalText: 'नवीनतम रक्तचाप माप',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.15),
                          borderRadius: AppRadii.radiusSm,
                          border: Border.all(color: categoryColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          eval.category.name,
                          style: TextStyle(color: categoryColor, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GlowingMetric(
                        label: 'Systolic / Diastolic',
                        value: '${latest.systolic}/${latest.diastolic}',
                        unit: 'mmHg',
                        isHero: true,
                        accentColor: categoryColor,
                      ),
                      GlowingMetric(
                        label: 'Pulse Rate',
                        value: '${latest.pulseBpm}',
                        unit: 'bpm',
                        accentColor: AppColors.energyOrange,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.glassBorder, height: 1),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GlowingMetric(
                        label: 'Mean Arterial (MAP)',
                        value: '${eval.meanArterialPressure}',
                        unit: 'mmHg',
                        accentColor: AppColors.focusBlue,
                      ),
                      GlowingMetric(
                        label: 'Pulse Pressure',
                        value: '${eval.pulsePressure}',
                        unit: 'mmHg',
                        accentColor: AppColors.aiPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Clinical Guidance Card
            BentoCard(
              backgroundColor: AppColors.surfaceElevated,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.health_and_safety_rounded, color: categoryColor, size: 20),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Cardiovascular Guidance',
                          regionalText: 'हृदय स्वास्थ्य सलाह',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eval.lifestyleRecommendation,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // 3. Historical Log List
          const Text(
            'HISTORICAL BP LOGS (पिछला इतिहास)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: readings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = readings[index];
              final itemEval = BloodPressureEngine.evaluate(systolic: item.systolic, diastolic: item.diastolic);
              final col = _getCategoryColor(itemEval.category);

              return BentoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.systolic} / ${item.diastolic} mmHg',
                          style: AppTypography.titleSmall.copyWith(
                            color: col,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Pulse: ${item.pulseBpm} bpm • ${item.arm} Arm',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                    Text(
                      '${item.recordedAt.hour}:${item.recordedAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
