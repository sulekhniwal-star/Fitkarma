import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/corporate_models.dart';
import '../providers/corporate_provider.dart';

/// Screen managing Corporate Wellness B2B memberships, IRDAI Dynamic Health
/// Insurance Premium Rebates, Team Step Challenges, and Workplace Ergonomic Alerts.
class CorporateWellnessScreen extends ConsumerStatefulWidget {
  const CorporateWellnessScreen({super.key});

  @override
  ConsumerState<CorporateWellnessScreen> createState() => _CorporateWellnessScreenState();
}

class _CorporateWellnessScreenState extends ConsumerState<CorporateWellnessScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _policyController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _policyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(corporateWellnessProvider);
    final notifier = ref.read(corporateWellnessProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Corporate Wellness & Insurer OS',
          regionalText: 'कॉर्पोरेट स्वास्थ्य व बीमा प्रीमियम छूट',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback Banner
            if (state.statusMessage != null) _buildStatusBanner(state.statusMessage!),

            // 1. Corporate Employee Profile & Employer Tier Card
            _buildCorporateProfileCard(state.employeeProfile, state.organization, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. IRDAI Dynamic Health Insurance Premium Rebate Card
            _buildInsurerRebateCard(state.insurerRebate, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Inter-Department Team Challenges Card
            _buildTeamChallengesCard(state.teamChallenges),
            const SizedBox(height: AppSpacing.md),

            // 4. Ergonomic Workplace Strain Alerts Card
            _buildErgonomicsCard(state.ergonomicAlerts),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.karmaGreen, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorporateProfileCard(
    CorporateEmployeeProfile employee,
    CorporateOrganization org,
    CorporateWellnessNotifier notifier,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.focusBlue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      org.activeTier,
                      style: const TextStyle(color: AppColors.focusBlue, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    org.companyName,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Text(
                  '100% Sponsored',
                  style: TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.department,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${employee.employeeId} • ${employee.workEmail}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.surfaceElevated),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '#${employee.corporateRank} in Org',
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      '${employee.earnedWellnessPoints} Wellness Pts',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Org Health Index: ${org.averageOrgHealthScore.toStringAsFixed(1)} / 100',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: () => _showCorporateLinkModal(context, notifier),
                child: const Text('Change Org', style: TextStyle(color: AppColors.focusBlue, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsurerRebateCard(InsurerPremiumRebate rebate, CorporateWellnessNotifier notifier) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.health_and_safety, color: AppColors.karmaGreen, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    rebate.insurer.name,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
                ),
                child: Text(
                  rebate.riskTier.label.split('(').first.trim(),
                  style: const TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: GlowingMetric(
                  value: '${rebate.calculatedDiscountPercentage.toStringAsFixed(1)}%',
                  unit: 'Discount',
                  label: 'Dynamic Rebate',
                  accentColor: AppColors.karmaGreen,
                ),
              ),
              Container(width: 1, height: 45, color: AppColors.surfaceElevated),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${rebate.annualSavingsInr.toInt()} Annual Savings',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Base Premium: ₹${rebate.baseAnnualPremiumInr.toInt()} / yr',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    Text(
                      'Policy: ${rebate.policyNumber}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.5),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('IRDAI Wellness Certificate:', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    Text(
                      rebate.renewalDiscountCertificateId,
                      style: const TextStyle(color: AppColors.focusBlue, fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceElevated,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () => _showInsurerLinkModal(context, notifier),
                  child: const Text('Link Policy', style: TextStyle(color: AppColors.textPrimary, fontSize: 11)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamChallengesCard(List<CorporateTeamChallenge> challenges) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Corporate Team Challenges',
                regionalText: 'कॉर्पोरेट टीम चुनौतियां',
              ),
              Icon(Icons.emoji_events, color: AppColors.gold, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Compete with cross-functional teams to earn corporate wellness points and charity pool funds.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...challenges.map((ch) => _buildChallengeItem(ch)),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(CorporateTeamChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.4),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  challenge.title,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${challenge.prizePoolWellnessPoints} Pts Pool',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Target: ${challenge.targetMetric} • Leader: ${challenge.leadingDepartment}',
            style: const TextStyle(color: AppColors.focusBlue, fontSize: 11),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (challenge.progressPercentage / 100.0).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.karmaGreen),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${challenge.participantCount} active colleagues',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
              Text(
                '${challenge.progressPercentage.toInt()}% achieved',
                style: const TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErgonomicsCard(List<ErgonomicAlert> alerts) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Workplace Ergonomics & Anti-Sedentary',
                regionalText: 'कार्यस्थल एर्गोनॉमिक्स व गतिशीलता',
              ),
              Icon(Icons.accessibility_new, color: AppColors.energyOrange, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Mitigate cervical spine strain, screen fatigue, and prolonged sitting during corporate workdays.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...alerts.map((alert) => _buildErgonomicItem(alert)),
        ],
      ),
    );
  }

  Widget _buildErgonomicItem(ErgonomicAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.3),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.energyOrange, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.actionPrompt,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCorporateLinkModal(BuildContext context, CorporateWellnessNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Verify Corporate Work Email',
                        regionalText: 'कॉर्पोरेट ईमेल सत्यापन',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Work Email (e.g. rahul@tcs.com)',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: '6-Digit Work OTP',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.focusBlue,
                            side: const BorderSide(color: AppColors.focusBlue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            notifier.initiateWorkEmailVerification(_emailController.text, 'Tata Consultancy Services', 'Engineering');
                          },
                          child: const Text('Send OTP'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.karmaGreen,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            final success = notifier.verifyOtp(_otpController.text);
                            if (success) Navigator.pop(ctx);
                          },
                          child: const Text('Verify Member', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showInsurerLinkModal(BuildContext context, CorporateWellnessNotifier notifier) {
    InsurerPartner selected = InsurerPartner.hdfcErgo;
    _policyController.text = 'HE-FIT-884920-BLR';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Link Health Insurance Policy',
                        regionalText: 'स्वास्थ्य बीमा पॉलिसी लिंक करें',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<InsurerPartner>(
                    initialValue: selected,
                    dropdownColor: AppColors.surfaceElevated,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Insurer Partner',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                    items: InsurerPartner.values.map((ins) {
                      return DropdownMenuItem(
                        value: ins,
                        child: Text('${ins.name} (Max ${ins.maxDiscountPercent.toInt()}%)'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selected = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _policyController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Policy / Member ID Number',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        notifier.linkInsurerPolicy(
                          insurer: selected,
                          policyNumber: _policyController.text,
                          baseAnnualPremium: 24000.0,
                        );
                        Navigator.pop(ctx);
                      },
                      child: const Text('Apply Policy Rebate', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              primaryText: 'Corporate Wellness & Insurer Economics',
              regionalText: 'कॉर्पोरेट व बीमा अर्थशास्त्र दर्शन',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma aligns employer productivity with healthcare economics. Under IRDAI Wellness Regulations, consistent daily steps, circadian sleep, and glycemic management earn direct dynamic discounts (up to 30%) on annual health insurance premiums, while enterprise team challenges and ergonomic desk alerts prevent workplace burnout.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
