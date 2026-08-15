import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/doctor_sharing_service.dart';
import '../providers/abha_provider.dart';

final doctorSharingServiceProvider = Provider<DoctorSharingService>((ref) => const DoctorSharingService());

final doctorShareConfigProvider = StateProvider<DoctorShareConfig?>((ref) => null);

final doctorReportSummaryProvider = Provider<DoctorReportSummary>((ref) {
  final service = ref.watch(doctorSharingServiceProvider);
  return service.generateSampleReportSummary('User');
});

/// §P10-J Doctor Sharing Portal Screen
/// Route: /sharing/doctor
class DoctorSharingScreen extends ConsumerWidget {
  const DoctorSharingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(doctorReportSummaryProvider);
    final activeConfig = ref.watch(doctorShareConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('🩺 Doctor Sharing Portal', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Consent Header BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock_person_outlined, color: AppColors.primary, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Patient Consent & Security Protocol', style: AppTypography.labelLg),
                              Text('AES-256 Encrypted PDF • 4-Digit Passcode PIN', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Export a comprehensive 90-day clinical overview protected by a 4-digit PIN of your choice, or generate a 7-day time-decaying link for your doctor.',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Report Data Preview Section
              Text('Included Report Contents (90-Day Overview)', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Blood Pressure (90-Day Avg)', value: '${summary.averageSystolicBp}/${summary.averageDiastolicBp} mmHg'),
                    const Divider(height: 16),
                    _DetailRow(label: 'Fasting Glucose (Avg)', value: '${summary.averageFastingGlucoseMgDl} mg/dL'),
                    const Divider(height: 16),
                    _DetailRow(label: 'Nutrition Adherence', value: '${summary.adherencePct90Days}%'),
                    const Divider(height: 16),
                    _DetailRow(label: 'Workout Consistency', value: '${summary.consistencyPct90Days}%'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Active Risk Flags & Biomarkers
              Text('Active Risk Flags & Biomarkers', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final flag in summary.activeRiskFlags)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 16),
                      const SizedBox(width: 6),
                      Expanded(child: Text(flag, style: AppTypography.bodySm)),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),

              // Active Portal Link Status Card
              if (activeConfig != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('🌐 Active Time-Decaying Link', style: AppTypography.labelLg.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold)),
                          Text('PIN: ${activeConfig.passCodePin}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(activeConfig.shareUrl, style: AppTypography.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Valid for ${activeConfig.validDays} days (Expires ${activeConfig.expiresAt.day}/${activeConfig.expiresAt.month})', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // §P16-C ABHA Health ID & FHIR-Lite Export Card
              Consumer(
                builder: (context, ref, child) {
                  final abhaProfile = ref.watch(abhaProvider);
                  return BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_user, color: AppColors.teal, size: 22),
                                const SizedBox(width: 8),
                                Text('ABHA Health ID (NDHM)', style: AppTypography.labelLg),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: abhaProfile.isLinked ? AppColors.teal.withAlpha(40) : AppColors.surface1,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                abhaProfile.isLinked ? 'VERIFIED' : 'NOT LINKED',
                                style: AppTypography.labelSmall.copyWith(
                                  color: abhaProfile.isLinked ? AppColors.teal : AppColors.textMuted,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          abhaProfile.isLinked
                              ? 'Linked: ${abhaProfile.abhaNumber} (${abhaProfile.abhaAddress})'
                              : 'Link your national ABHA ID for structured FHIR bundle sharing with network doctors.',
                          style: AppTypography.bodySm,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (abhaProfile.isLinked)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: AppColors.bg0,
                              minimumSize: const Size.fromHeight(38),
                            ),
                            icon: const Icon(Icons.share, size: 16),
                            label: const Text('Export FHIR-Lite JSON Bundle'),
                            onPressed: () {
                              ref.read(abhaProvider.notifier).exportFhirBundle(summary);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('FHIR-Lite Clinical Bundle Generated for NDHM Network')),
                              );
                            },
                          )
                        else
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.teal,
                              side: const BorderSide(color: AppColors.teal),
                              minimumSize: const Size.fromHeight(38),
                            ),
                            onPressed: () {
                              ref.read(abhaProvider.notifier).linkAbha(
                                    rawAbhaNumber: '91-1234-5678-9012',
                                    abhaAddress: 'arjun.sharma@abdm',
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('ABHA ID 91-1234-5678-9012 Successfully Linked')),
                              );
                            },
                            child: const Text('Link ABHA ID'),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // CTA Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.picture_as_pdf, color: AppColors.bg0, size: 18),
                      label: Text('Export Encrypted PDF', style: AppTypography.labelLg.copyWith(color: AppColors.bg0)),
                      onPressed: () {
                        ref.read(doctorShareConfigProvider.notifier).state = ref.read(doctorSharingServiceProvider).generateShareToken(passCodePin: '4829');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generated Encrypted PDF with PIN 4829')),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.labelLg),
      ],
    );
  }
}
