import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/coach_escalation_repository.dart';
import '../domain/coach_escalation.dart';

final coachEscalationRepositoryProvider = Provider<CoachEscalationRepository>((ref) {
  return CoachEscalationRepository();
});

class CoachEscalationScreen extends ConsumerStatefulWidget {
  const CoachEscalationScreen({super.key});

  @override
  ConsumerState<CoachEscalationScreen> createState() => _CoachEscalationScreenState();
}

class _CoachEscalationScreenState extends ConsumerState<CoachEscalationScreen> {
  EscalationReason _selectedReason = EscalationReason.userRequested;
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitTicket() async {
    final uid = ref.read(currentUserIdProvider);
    final ticketId = 'esc_${DateTime.now().millisecondsSinceEpoch}';

    final dossier = CoachHandoverDossier(
      userName: 'FitKarma Member',
      age: 28,
      sex: 'Male',
      weightKg: 74.5,
      heightCm: 178.0,
      bmi: 23.5,
      primaryGoal: 'Muscle Hypertrophy & Fat Loss',
      dosha: 'Pitta-Kapha',
      readinessScore: 78,
      rolling14DayHrvMs: 58.2,
      averageSleepHours: 7.4,
      summaryNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : 'User requested 1-on-1 certified human coach review.',
      generatedAt: DateTime.now(),
    );

    final ticket = CoachEscalationTicket(
      id: ticketId,
      userId: uid,
      reason: _selectedReason,
      status: EscalationStatus.pendingReview,
      dossier: dossier,
      createdAt: DateTime.now(),
    );

    await ref.read(coachEscalationRepositoryProvider).submitEscalationTicket(
          uid: uid,
          ticket: ticket,
        );

    setState(() => _isSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Certified Coach Escalation',
          regionalText: 'प्रमाणित मानव कोच परामर्श',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: _isSubmitted ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Elite Tier Banner
        BentoCard(
          hasGlow: true,
          glowColor: AppColors.gold,
          backgroundColor: AppColors.surfaceElevated,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELITE TIER BENEFIT',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1-on-1 Certified Sports Nutritionist & Coach Review',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 2. Select Reason
        const Text(
          'SELECT REASON FOR HANDOFF (कारण चुनें)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        ...EscalationReason.values.map((reason) {
          final isSelected = _selectedReason == reason;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BentoCard(
              hasGlow: isSelected,
              glowColor: AppColors.focusBlue,
              backgroundColor: isSelected ? AppColors.surfaceElevated : AppColors.surface,
              border: Border.all(
                color: isSelected ? AppColors.focusBlue : AppColors.glassBorder,
              ),
              onTap: () => setState(() => _selectedReason = reason),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reason.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      Text(
                        reason.regionalName,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded, color: AppColors.focusBlue, size: 20),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.md),

        // 3. Automated Dossier Preview Card
        const BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.description_rounded, color: AppColors.karmaGreen, size: 18),
                  SizedBox(width: 8),
                  BilingualLabel(
                    primaryText: 'Auto-Compiled Health Dossier',
                    regionalText: 'स्वचालित स्वास्थ्य सारांश',
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma will attach your 14-day HRV averages, readiness trends, and metabolic parameters to your coach ticket.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GlowingMetric(label: '14-Day HRV', value: '58.2ms', accentColor: AppColors.focusBlue),
                  GlowingMetric(label: 'Avg Sleep', value: '7.4h', accentColor: AppColors.aiPurple),
                  GlowingMetric(label: 'Readiness', value: '78%', accentColor: AppColors.karmaGreen),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 4. Notes / Question Input Box
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Describe your specific question or injury/periodization goal for the human coach...',
            hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.8), fontSize: 13),
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: const OutlineInputBorder(
              borderRadius: AppRadii.radiusSm,
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 5. Submit Button
        Container(
          width: double.infinity,
          height: 54,
          decoration: const BoxDecoration(
            borderRadius: AppRadii.radiusMd,
            gradient: AppColors.primaryGradient,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
            ),
            onPressed: _submitTicket,
            child: Text(
              'Submit to Human Coach',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.karmaGreen.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.karmaGreen, size: 64),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Escalation Ticket Submitted',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your health dossier has been transmitted to a certified sports coach. Expected review turnaround is within 4–6 business hours.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceElevated,
              shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Return to Coach Chat', style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
