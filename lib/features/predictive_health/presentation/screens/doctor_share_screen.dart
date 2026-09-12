import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/models/predictive_health_models.dart';

class DoctorShareScreen extends StatefulWidget {
  final String userId;

  const DoctorShareScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DoctorShareScreen> createState() => _DoctorShareScreenState();
}

class _DoctorShareScreenState extends State<DoctorShareScreen> {
  final List<DoctorAccessGrant> _grants = [
    DoctorAccessGrant(
      id: 'grant-1',
      userId: 'demo-user-001',
      doctorName: 'Dr. Anand Kulkarni (MD, Cardiology)',
      clinicHospital: 'Apollo Hospitals, Bannerghatta',
      accessPin: '849201',
      expiresAt: DateTime.now().add(const Duration(hours: 48)),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Text('Doctor Sharing Portal', style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active PIN & QR Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryCyan,
              child: Column(
                children: [
                  Text('Active Clinician Consultation Passcode', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryCyan),
                    ),
                    child: Text(
                      '849 - 201',
                      style: AppTypography.heroMetric.copyWith(letterSpacing: 4.0, color: AppColors.primaryCyan, fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Share this 6-digit PIN with your doctor to grant 48-hour secure read-only access to your blood pressure, glucose, and lab trends.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Active Medical Access Grants', style: AppTypography.h3),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _grants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final grant = _grants[index];
                return BentoCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(grant.doctorName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(grant.clinicHospital, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('Expires in: 47 hours', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _grants.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Doctor access revoked.'),
                              backgroundColor: AppColors.accentCoral,
                            ),
                          );
                        },
                        child: Text('Revoke', style: AppTypography.label.copyWith(color: AppColors.accentCoral)),
                      ),
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
