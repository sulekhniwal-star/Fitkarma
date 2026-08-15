import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/festival_adaptation_engine.dart';
import '../providers/festival_provider.dart';

/// §P12-A Festival Intelligence System & Survival Mode Screen
/// Route: /lifestyle/festival
class FestivalSurvivalScreen extends ConsumerWidget {
  const FestivalSurvivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalState = ref.watch(festivalProvider);
    final activeFest = festivalState.activeFestival;
    final adapt = festivalState.activeAdaptation;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            Text('Festival Survival Mode 🎉', style: AppTypography.h2),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Festival Survival Banner
              if (activeFest != null && festivalState.isSurvivalModeActive)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFB45309)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('SURVIVAL MODE ACTIVE',
                                style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text('3-Day Buffer Active',
                              style: AppTypography.bodySm.copyWith(
                                  color: AppColors.bg0, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${activeFest.name} Mode',
                          style:
                              AppTypography.h1.copyWith(color: AppColors.bg0)),
                      Text(activeFest.description,
                          style: AppTypography.bodySm.copyWith(
                              color: AppColors.bg0.withValues(alpha: 0.9))),
                    ],
                  ),
                ),

              // Cross-Module Adaptation BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cross-Module Targets Matrix',
                        style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    _AdaptRow(
                        icon: Icons.local_fire_department,
                        label: 'Calorie Buffer',
                        value: '+${adapt.calorieBuffer} kcal/day'),
                    _AdaptRow(
                        icon: Icons.egg_alt,
                        label: 'Protein Focus',
                        value: adapt.proteinFocus),
                    _AdaptRow(
                        icon: Icons.water_drop,
                        label: 'Hydration Boost',
                        value: '+${adapt.hydrationIncreaseLiters} L/day'),
                    _AdaptRow(
                        icon: Icons.fitness_center,
                        label: 'Workout Strategy',
                        value: adapt.workoutStrategy),
                    _AdaptRow(
                        icon: Icons.directions_walk,
                        label: 'Step Adjust',
                        value:
                            '${adapt.stepTargetAdjust >= 0 ? '+' : ''}${adapt.stepTargetAdjust} steps'),
                    _AdaptRow(
                        icon: Icons.bedtime,
                        label: 'Sleep Emphasis',
                        value: adapt.sleepEmphasis),
                    _AdaptRow(
                        icon: Icons.record_voice_over,
                        label: 'AI Coach Tone',
                        value: adapt.coachTone),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Select Festival Preset
              Text('Tracked Festivals & Presets', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              for (final fest in festivalState.upcomingFestivals)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(fest.name, style: AppTypography.labelLg),
                      subtitle: Text(fest.description,
                          style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary, fontSize: 11)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activeFest?.id == fest.id
                              ? AppColors.primary
                              : AppColors.bg1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                        child: Text(
                          activeFest?.id == fest.id ? 'Active' : 'Activate',
                          style: AppTypography.labelSmall.copyWith(
                            color: activeFest?.id == fest.id
                                ? AppColors.bg0
                                : AppColors.textPrimary,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(festivalProvider.notifier)
                              .selectFestival(fest);
                        },
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdaptRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AdaptRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(
              width: 120,
              child: Text(label,
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: AppTypography.labelLg)),
        ],
      ),
    );
  }
}
