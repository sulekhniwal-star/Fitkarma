import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/models/social_models.dart';
import '../../domain/services/family_health_monitoring_engine.dart';

class FamilyHealthHubScreen extends StatefulWidget {
  final String userId;

  const FamilyHealthHubScreen({
    super.key,
    this.userId = 'demo-user-001',
  });

  @override
  State<FamilyHealthHubScreen> createState() => _FamilyHealthHubScreenState();
}

class _FamilyHealthHubScreenState extends State<FamilyHealthHubScreen> {
  final _familyEngine = const FamilyHealthMonitoringEngine();

  late List<FamilyMemberHealth> _familyList;

  @override
  void initState() {
    super.initState();
    _familyList = [
      _familyEngine.evaluateHealthStatus(
        id: 'fam-1',
        userId: widget.userId,
        relativeUserId: 'user-parent-1',
        relativeName: 'Ramesh Nair (Father)',
        relation: 'Father',
        age: 62,
        systolicBp: 132.0,
        diastolicBp: 84.0,
        fastingGlucoseMgDl: 112.0,
        todaySteps: 5400,
        recordedAt: DateTime.now(),
      ),
      _familyEngine.evaluateHealthStatus(
        id: 'fam-2',
        userId: widget.userId,
        relativeUserId: 'user-parent-2',
        relativeName: 'Lakshmi Nair (Mother)',
        relation: 'Mother',
        age: 58,
        systolicBp: 145.0,
        diastolicBp: 92.0,
        fastingGlucoseMgDl: 140.0,
        todaySteps: 3800,
        recordedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          BentoCard(
            isGlowing: true,
            glowColor: AppColors.primaryEmerald,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: AppColors.accentCoral, size: 24),
                    const SizedBox(width: 8),
                    Text('Joint Family Health OS', style: AppTypography.h3),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitor parents\' blood pressure, glucose, and daily steps remotely with cultural care blessings.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Family Members & Parents', style: AppTypography.h3),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _familyList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final member = _familyList[index];
              return _buildFamilyCard(member);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyCard(FamilyMemberHealth member) {
    Color alertColor;
    String alertTag;
    switch (member.alertLevel) {
      case HealthAlertLevel.urgentConsultation:
        alertColor = AppColors.accentCoral;
        alertTag = 'Urgent Doctor Review';
        break;
      case HealthAlertLevel.attentionNeeded:
        alertColor = AppColors.accentAmber;
        alertTag = 'Attention Needed';
        break;
      case HealthAlertLevel.normal:
        alertColor = AppColors.primaryEmerald;
        alertTag = 'Vitals Normal';
        break;
    }

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(member.relativeName, style: AppTypography.h3.copyWith(fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: alertColor.withAlpha(25), borderRadius: BorderRadius.circular(6)),
                child: Text(alertTag, style: AppTypography.label.copyWith(fontSize: 10, color: alertColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vitals Grid
          Row(
            children: [
              Expanded(
                child: _buildVitalPill(
                  'Blood Pressure',
                  '${member.latestSystolicBp?.toInt()}/${member.latestDiastolicBp?.toInt()} mmHg',
                  member.latestSystolicBp != null && member.latestSystolicBp! >= 140 ? AppColors.accentAmber : AppColors.primaryEmerald,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildVitalPill(
                  'Fasting Glucose',
                  '${member.latestFastingGlucoseMgDl?.toInt()} mg/dL',
                  member.latestFastingGlucoseMgDl != null && member.latestFastingGlucoseMgDl! >= 126 ? AppColors.accentAmber : AppColors.primaryEmerald,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildVitalPill(
                  'Steps',
                  '${member.todaySteps ?? 0}',
                  AppColors.primaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (member.alertMessage != null) ...[
            Text(
              member.alertMessageHindi ?? member.alertMessage!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
          ],

          // Blessing Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.volunteer_activism_rounded, size: 16, color: AppColors.primaryEmerald),
                label: Text('Send Pranam 🙏', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryEmerald)),
                onPressed: () {
                  final blessing = _familyEngine.createBlessing(
                    id: 'b1',
                    senderId: widget.userId,
                    senderName: 'Aarav',
                    recipientId: member.relativeUserId,
                    blessingType: 'pranam',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sent to ${member.relativeName}: "${blessing.blessingHindi}"'),
                      backgroundColor: AppColors.primaryEmerald,
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

  Widget _buildVitalPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
