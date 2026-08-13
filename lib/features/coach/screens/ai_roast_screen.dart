import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/ai_roast_engine.dart';
import '../providers/ai_roast_provider.dart';

/// §P12-D AI Roast Mode & Tone Settings Screen
/// Route: /coach/roast
class AiRoastScreen extends ConsumerWidget {
  const AiRoastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roastState = ref.watch(aiRoastProvider);
    final nudge = roastState.activeNudge;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('AI Coach Tone & Roast Mode 🔥', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crisis Safety Override Alert
              if (roastState.isCrisisSafetyDisabled)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: AppColors.warning, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Safety Protocol Active: Roast Mode automatically paused due to high stress/recovery signals.',
                          style: AppTypography.bodySm.copyWith(color: AppColors.warning, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Active Nudge BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current AI Nudge', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(nudge.category, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      '"${nudge.roastMessage}"',
                      style: AppTypography.h3.copyWith(color: AppColors.primary, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppColors.teal, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(nudge.motivationalPivot, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Coach Tone Selector
              Text('Select AI Coach Personality', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              _ToneOptionTile(
                tone: CoachTone.gentle,
                title: 'Gentle & Supportive 🌸',
                subtitle: 'Soft, encouraging nudges focused on self-compassion',
                isSelected: roastState.selectedTone == CoachTone.gentle,
                onTap: () => ref.read(aiRoastProvider.notifier).setCoachTone(CoachTone.gentle),
              ),
              _ToneOptionTile(
                tone: CoachTone.motivational,
                title: 'Motivational & High Energy ⚡',
                subtitle: 'Push performance, celebrate wins, hype progression',
                isSelected: roastState.selectedTone == CoachTone.motivational,
                onTap: () => ref.read(aiRoastProvider.notifier).setCoachTone(CoachTone.motivational),
              ),
              _ToneOptionTile(
                tone: CoachTone.roast,
                title: 'AI Roast Mode (Sarcastic Humor) 🔥',
                subtitle: 'Opt-in brutal honesty and witty fitness banter',
                isSelected: roastState.selectedTone == CoachTone.roast,
                onTap: () => ref.read(aiRoastProvider.notifier).setCoachTone(CoachTone.roast),
              ),
              _ToneOptionTile(
                tone: CoachTone.noNonsense,
                title: 'No-Nonsense Data Direct 📊',
                subtitle: 'Pure stats, zero fluff, immediate execution calls',
                isSelected: roastState.selectedTone == CoachTone.noNonsense,
                onTap: () => ref.read(aiRoastProvider.notifier).setCoachTone(CoachTone.noNonsense),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneOptionTile extends StatelessWidget {
  final CoachTone tone;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToneOptionTile({
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: AppTypography.labelLg.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary)),
            subtitle: Text(subtitle, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
                : const Icon(Icons.radio_button_unchecked, color: AppColors.textMuted, size: 22),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
