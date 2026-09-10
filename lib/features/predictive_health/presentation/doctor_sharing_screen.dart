import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/doctor_sharing_models.dart';
import 'providers/doctor_sharing_provider.dart';

/// Screen displaying Time-Bound Doctor Sharing Access, ABDM / EMR Interoperability,
/// Clinical Dossier Export, and Access Audit Logging.
class DoctorSharingScreen extends ConsumerWidget {
  const DoctorSharingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(doctorSharingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Doctor Sharing Portal',
          regionalText: 'चिकित्सक परामर्श डेटा शेयरिंग',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSharingMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Doctor Sharing Status Card
            _buildHeroPortalCard(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 2. Action: Create New Access Link Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.focusBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                ),
                icon: const Icon(Icons.add_link, color: Colors.white),
                label: const Text(
                  'Grant New Doctor Access Link',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                onPressed: () => _showCreateGrantModal(context, ref),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 3. Active Doctor Access Grants List
            const BilingualLabel(
              primaryText: 'Active Physician Grants & Temporary Links',
              regionalText: 'सक्रिय डॉक्टर एक्सेस व समयबद्ध लिंक',
            ),
            const SizedBox(height: AppSpacing.sm),
            if (report.activeGrants.isEmpty)
              const BentoCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(
                    child: Text(
                      'No active doctor sharing grants. Tap above to create one.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              )
            else
              ...report.activeGrants.map((grant) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildGrantCard(context, ref, grant),
                  )),
            const SizedBox(height: AppSpacing.md),

            // 4. Formatted Clinical Dossier Export Card
            _buildDossierExportCard(context, report.currentDossier),
            const SizedBox(height: AppSpacing.md),

            // 5. Clinical Access Audit Trail
            const BilingualLabel(
              primaryText: 'Access Audit Log (ABDM / HIPAA)',
              regionalText: 'डेटा एक्सेस सुरक्षा व ऑडिट लॉग',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildAuditTrailCard(report.auditLogs),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPortalCard(
    BuildContext context,
    WidgetRef ref,
    DoctorSharingPortalReport report,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined,
                        color: AppColors.karmaGreen, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'ABDM & EMR Compliant',
                      style: TextStyle(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (report.hasActiveSharingLinks)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    ref.read(doctorSharingProvider.notifier).revokeAllGrants();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'All active doctor sharing grants revoked immediately.'),
                        backgroundColor: AppColors.alertRed,
                      ),
                    );
                  },
                  child: Text(
                    'Revoke All Access',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.bold,
                    ),
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
                label: 'Active Grants',
                value: report.totalActiveGrantsCount.toString(),
                unit: 'doctors',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Privacy State',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    report.hasActiveSharingLinks
                        ? 'Time-Bound Read-Only Access'
                        : 'Encrypted & Isolated',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${report.auditLogs.length} Audit Access Events Logged',
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

  Widget _buildGrantCard(
    BuildContext context,
    WidgetRef ref,
    DoctorAccessGrant grant,
  ) {
    final isGrantActive = grant.isActive && !grant.isExpired;
    final statusColor =
        isGrantActive ? AppColors.karmaGreen : AppColors.textSecondary;

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
                child: const Icon(Icons.local_hospital,
                    color: AppColors.focusBlue, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grant.doctorName,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${grant.specialization} • ${grant.clinicOrHospital}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Reg. No: ${grant.medicalRegistrationNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  isGrantActive ? 'Active' : 'Expired/Revoked',
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.key, color: AppColors.focusBlue, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Access PIN: ${grant.secureAccessToken}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  isGrantActive
                      ? 'Expires: ${grant.expiresAt.day}/${grant.expiresAt.month} ${grant.expiresAt.hour}:${grant.expiresAt.minute}'
                      : 'Revoked',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: grant.permittedScopes.map((scope) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.1),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  scope.name.split("&").first.trim(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontSize: 9,
                  ),
                ),
              );
            }).toList(),
          ),
          if (isGrantActive) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.focusBlue),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusSm,
                      ),
                    ),
                    icon: const Icon(Icons.share,
                        size: 14, color: AppColors.focusBlue),
                    label: const Text('Share Access Link',
                        style: TextStyle(
                            color: AppColors.focusBlue, fontSize: 12)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text:
                            'FitKarma Doctor Access: https://fitkarma.app/telemetry?token=${grant.secureAccessToken}&id=${grant.grantId}',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Doctor sharing link copied to clipboard!'),
                          backgroundColor: AppColors.karmaGreen,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.alertRed),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusSm,
                    ),
                  ),
                  onPressed: () => ref
                      .read(doctorSharingProvider.notifier)
                      .revokeGrant(grant.grantId),
                  child: const Text('Revoke',
                      style:
                          TextStyle(color: AppColors.alertRed, fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDossierExportCard(
      BuildContext context, FormattedDoctorDossier dossier) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppColors.focusBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Clinical Health Dossier (EMR Ready)',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Structured 30-day vitals, glycemic curves, and medication adherence formatted for clinical review.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.visibility,
                      color: Colors.white, size: 16),
                  label: const Text('Preview Full Dossier',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => _showDossierModal(context, dossier),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.copy, color: AppColors.karmaGreen),
                tooltip: 'Copy text dossier',
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: dossier.fullFormattedTextForPdf));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clinical dossier copied to clipboard!'),
                      backgroundColor: AppColors.karmaGreen,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTrailCard(List<ClinicalAuditLogEntry> logs) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: logs.map((log) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.history, color: AppColors.focusBlue, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${log.doctorName} accessed telemetry (${log.scopesViewed.length} scopes)',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '${log.accessedAt.day}/${log.accessedAt.month} ${log.accessedAt.hour}:${log.accessedAt.minute} • ${log.ipAddressOrDevice}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showCreateGrantModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Generate Doctor Access Grant',
                regionalText: 'नया डॉक्टर एक्सेस कोड बनाएं',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'This creates a secure, temporary, read-only token granting a physician access to selected telemetry sections.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () {
                    ref.read(doctorSharingProvider.notifier).createNewGrant(
                          doctorName: 'Dr. Anita Desai, MD (Endocrinology)',
                          specialization:
                              'Endocrinologist & Diabetes Specialist',
                          clinicOrHospital: 'Apollo Hospitals',
                          medicalRegistrationNumber: 'MCI-84920',
                          permittedScopes: [
                            ClinicalDataScope.glycemicCgm,
                            ClinicalDataScope.labBiomarkers,
                            ClinicalDataScope.medicationRegimens,
                          ],
                          durationWindow: SharingDurationWindow.days7,
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Doctor access grant generated successfully!'),
                        backgroundColor: AppColors.karmaGreen,
                      ),
                    );
                  },
                  child: const Text('Confirm & Generate 7-Day Access PIN',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDossierModal(BuildContext context, FormattedDoctorDossier dossier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.92,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ListView(
                controller: scrollController,
                children: [
                  const BilingualLabel(
                    primaryText: 'Clinical EMR Dossier Preview',
                    regionalText: 'चिकित्सक रिपोर्ट पूर्वावलोकन',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: AppRadii.radiusMd,
                      border: Border.all(color: AppColors.surfaceElevated),
                    ),
                    child: SelectableText(
                      dossier.fullFormattedTextForPdf,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.focusBlue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close Preview',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSharingMethodologyModal(BuildContext context) {
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
                primaryText: 'Doctor Sharing & Consent Protocol',
                regionalText: 'डेटा सुरक्षा व सहमति नियम',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma follows the Ayushman Bharat Digital Mission (ABDM) and HIPAA privacy frameworks. All physician sharing grants are strictly time-bound, permission-gated, and can be revoked by the patient with a single tap at any moment.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Access audit logs record every physician viewing session, including time, scopes viewed, and IP addresses.',
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
                  child: const Text('Understand & Close',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
