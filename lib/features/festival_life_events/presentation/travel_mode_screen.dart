import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/travel_mode_models.dart';
import 'providers/travel_mode_provider.dart';

/// Screen displaying Travel Intelligence System, Hotel Room Workouts,
/// Circadian Jet Lag Mitigation, and Ayurvedic Vata Protection.
class TravelModeScreen extends ConsumerWidget {
  const TravelModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(travelModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Travel Intelligence & Mode',
          regionalText: 'यात्रा स्वास्थ्य व जेट-लैग अनुकूलन',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Travel Context Horizontal Selector Carousel
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: TravelContext.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final ctx = TravelContext.values[index];
                  final isSelected = report.activeContext == ctx;
                  return ChoiceChip(
                    label: Text(
                      ctx.name.split('(').first.trim(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.focusBlue,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (_) => ref
                        .read(travelModeProvider.notifier)
                        .updateContext(ctx),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Travel Mode Bento Card
            _buildHeroTravelCard(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 3. Circadian Jet Lag Advice Card
            _buildJetLagCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Ayurvedic Vata Shield Card
            _buildVataShieldCard(report),
            const SizedBox(height: AppSpacing.md),

            // 5. Active Travel & Hotel Actions List
            const BilingualLabel(
              primaryText: 'Hotel Room & Transit Protocols',
              regionalText: 'होटल व पारगमन फिटनेस नियम',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeTravelActions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildActionCard(action),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Airport & Dhaba Dining Strategy Card
            _buildDiningCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTravelCard(
    BuildContext context,
    WidgetRef ref,
    TravelIntelligenceReport report,
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
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.focusBlue, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flight_takeoff,
                        color: AppColors.focusBlue, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${report.destinationCityOrTimezone} (${report.timezoneShiftHours > 0 ? "+${report.timezoneShiftHours}" : "${report.timezoneShiftHours}"}h Shift)',
                      style: const TextStyle(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Travel Mode',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: report.isTravelModeActive,
                    activeThumbColor: AppColors.focusBlue,
                    onChanged: (val) {
                      ref
                          .read(travelModeProvider.notifier)
                          .toggleTravelMode(val);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.activeContext.name,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            report.activeContext.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Adapted Step Goal',
                value: '${report.adaptedStepGoal}',
                unit: 'steps',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Fitness Window',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${report.hotelWorkoutDurationMinutes} Min Minimalist HIIT',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Context: ${report.activeContext.description}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.karmaGreen,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJetLagCard(TravelIntelligenceReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_outlined,
                  color: AppColors.energyOrange, size: 18),
              SizedBox(width: 6),
              Text(
                'Circadian Jet Lag & Sunlight Timing',
                style: TextStyle(
                  color: AppColors.energyOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.jetLagCircadianAdvice,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalJetLagAdvice,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVataShieldCard(TravelIntelligenceReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.spa_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Ayurvedic Vata Travel Shield (पाद अभ्यंग)',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.vataBalancingRitual,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalVataBalancingRitual,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(TravelActionItem action) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                action.title,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  action.category,
                  style: const TextStyle(
                    color: AppColors.focusBlue,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          Text(
            action.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            action.instruction,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
              fontSize: 11,
            ),
          ),
          Text(
            action.regionalInstruction,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiningCard(TravelIntelligenceReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant, color: AppColors.karmaGreen, size: 18),
              SizedBox(width: 6),
              Text(
                'Transit & Dining Survival Strategy',
                style: TextStyle(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.airportDhabaDiningTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalAirportDhabaDiningTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showPhilosophyModal(BuildContext context) {
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
                primaryText: 'Travel Mode Wellness Philosophy',
                regionalText: 'यात्रा स्वास्थ्य विज्ञान व सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Travel Mode transforms hotel rooms into functional movement spaces, balances aggravated Vata dosha through warm foot massage (Pada Abhyanga), resets circadian rhythms with sunlight timing, and guides healthy airport/dhaba dining.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
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
