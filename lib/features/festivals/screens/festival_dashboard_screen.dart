import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/festival_provider.dart';

class FestivalDashboardScreen extends ConsumerWidget {
  const FestivalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(festivalProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Festival & Life Events', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3-Day Survival Mode Card
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.celebration,
                        color: AppColors.warningAmber, size: 32.0),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('3-Day Festival Survival Mode',
                              style: AppTypography.titleMedium),
                          Text(
                              'Pre-compensation caloric buffer & workout scaling',
                              style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Fasting Modes Toggles Card
              GlassCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Navratri Fasting Filter',
                          style: AppTypography.titleMedium),
                      subtitle: Text(
                          'Restricts non-veg, onion, garlic; surfaces Satvik foods',
                          style: AppTypography.labelSmall),
                      value: state.fastingConfig.isNavratriFastingActive,
                      activeThumbColor: AppColors.primaryEmerald,
                      onChanged: (_) => ref
                          .read(festivalProvider.notifier)
                          .toggleNavratriFasting(),
                    ),
                    const Divider(color: AppColors.glassBorder),
                    SwitchListTile(
                      title: Text('Ramadan Sehri & Iftar Mode',
                          style: AppTypography.titleMedium),
                      subtitle: Text(
                          'Splits timing into pre-dawn & post-sunset windows',
                          style: AppTypography.labelSmall),
                      value: state.fastingConfig.isRamadanModeActive,
                      activeThumbColor: AppColors.primaryCyan,
                      onChanged: (_) => ref
                          .read(festivalProvider.notifier)
                          .toggleRamadanMode(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Seeded 10-Festival Calendar
              Text('Indian Cultural Festival Calendar (10 Festivals)',
                  style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.festivals.map(
                (fest) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fest.name, style: AppTypography.titleMedium),
                            Text(
                                '${fest.durationDays} Days • ${fest.description}',
                                style: AppTypography.labelSmall),
                          ],
                        ),
                        const Icon(Icons.event, color: AppColors.primaryViolet),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
