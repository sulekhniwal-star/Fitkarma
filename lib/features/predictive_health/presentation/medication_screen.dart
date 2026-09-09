import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/medication_models.dart';
import 'providers/medication_provider.dart';

/// Screen displaying Medication Adherence Tracking, Ayurvedic Herb-Drug Cross-Interactions,
/// Safe Timing Buffers, and Daily Pill Management.
class MedicationSafetyScreen extends ConsumerWidget {
  const MedicationSafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(medicationProvider);
    final hasAlerts = report.detectedInteractions.isNotEmpty;
    final safetyColor = report.hasCriticalContraindication
        ? AppColors.alertRed
        : (hasAlerts ? AppColors.energyOrange : AppColors.karmaGreen);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Medication & Herb Safety',
          regionalText: 'दवा व जड़ी-बूटी सुरक्षा ट्रैकर',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSafetyMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Medication Adherence & Safety Overview Card
            _buildHeroSafetyCard(report, safetyColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Detected Cross-Interaction Alerts (if any)
            if (hasAlerts) ...[
              const BilingualLabel(
                primaryText: 'Herb-Drug Interaction Alerts',
                regionalText: 'परस्पर औषधि-जड़ी-बूटी सावधानी अलर्ट',
              ),
              const SizedBox(height: AppSpacing.sm),
              ...report.detectedInteractions.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildInteractionCard(alert),
                  )),
              const SizedBox(height: AppSpacing.md),
            ],

            // 3. Clinical Safety Summary
            _buildClinicalSafetySummary(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Daily Medication Checklist
            const BilingualLabel(
              primaryText: "Today's Prescriptions & Rasayanas",
              regionalText: 'आज की निर्धारित दवाएं व आयुर्वेदिक रस',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeMedications.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildMedicationCard(context, ref, med),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSafetyCard(MedicationScheduleReport report, Color safetyColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: safetyColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: safetyColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      report.hasCriticalContraindication ? Icons.warning_rounded : Icons.shield_outlined,
                      color: safetyColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.hasCriticalContraindication
                          ? 'Contraindication Alert'
                          : (report.detectedInteractions.isNotEmpty ? 'Timing Precautions' : 'All Clear • Safe'),
                      style: AppTypography.bodySmall.copyWith(
                        color: safetyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${report.dosesTakenToday}/${report.totalDosesToday} Doses Taken Today',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Adherence',
                value: '${report.adherenceScorePercent.toInt()}%',
                unit: 'compliance',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Prescriptions',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.activeMedications.length} Regimens Tracked',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${report.detectedInteractions.length} Inter-Agent Rules Screened',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionCard(MedicationInteractionAlert alert) {
    final alertColor = Color(alert.severity.colorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.compare_arrows_rounded, color: alertColor, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${alert.primaryAgent} ↔ ${alert.secondaryAgent}',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: alertColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: alertColor, width: 1),
                ),
                child: Text(
                  alert.severity.label.split("(").first.trim(),
                  style: AppTypography.bodySmall.copyWith(
                    color: alertColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            alert.interactionMechanism,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            alert.regionalInteractionMechanism,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.focusBlue, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Safe Timing Rule: ${alert.safeSpacingGuideline}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.focusBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalSafetySummary(MedicationScheduleReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety, color: AppColors.focusBlue, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Clinical Pharmacological Assessment',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.clinicalSafetySummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalClinicalSafetySummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, WidgetRef ref, TrackedMedication med) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Icon(_getMedicationIcon(med.type), color: AppColors.focusBlue, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      med.regionalName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${med.dosage} • ${med.timing.label}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  med.isTakenToday ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: med.isTakenToday ? AppColors.karmaGreen : AppColors.textSecondary,
                  size: 28,
                ),
                tooltip: med.isTakenToday ? 'Mark as not taken' : 'Mark as taken',
                onPressed: () {
                  ref.read(medicationProvider.notifier).toggleDoseTaken(med.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(med.isTakenToday ? '${med.name} marked as untaken' : '${med.name} dose logged (+10 Karma)!'),
                      backgroundColor: AppColors.karmaGreen,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            med.clinicalPurpose,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  med.type.name,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                '${med.totalPillsRemaining} doses remaining',
                style: AppTypography.bodySmall.copyWith(
                  color: med.totalPillsRemaining < 7 ? AppColors.energyOrange : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getMedicationIcon(MedicationType type) {
    switch (type) {
      case MedicationType.allopathicPrescription:
        return Icons.medication;
      case MedicationType.ayurvedicHerb:
        return Icons.eco;
      case MedicationType.supplementVitamin:
        return Icons.vaccines;
    }
  }

  void _showSafetyMethodologyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Herb-Drug Interaction Safety Engine',
                regionalText: 'औषधि व जड़ी-बूटी सुरक्षा पद्धति',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma screens for potential pharmacokinetic and pharmacodynamic interactions between modern allopathic pharmaceuticals and traditional Ayurvedic herbs/rasayanas.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'By enforcing safe temporal buffers (e.g. taking Triphala at night away from morning blood pressure pills, or staggering Curcumin and Aspirin), therapeutic efficacy is maximized without adverse events.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understand & Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
