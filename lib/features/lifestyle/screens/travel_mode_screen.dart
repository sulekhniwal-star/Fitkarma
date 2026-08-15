import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../core/brain/travel_intelligence_engine.dart';
import '../providers/travel_mode_provider.dart';

/// §P12-E Travel Mode Screen (Travel Intelligence)
class TravelModeScreen extends ConsumerStatefulWidget {
  const TravelModeScreen({super.key});

  @override
  ConsumerState<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends ConsumerState<TravelModeScreen> {
  void _showNewTravelSheet(BuildContext context) {
    String origin = 'Delhi';
    String destination = 'Mumbai';
    TravelMode selectedMode = TravelMode.domestic;
    TravelDirection direction = TravelDirection.east;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            top: AppSpacing.lg,
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Plan New Travel', style: AppTypography.h3),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Travel Type', style: AppTypography.labelLg),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: TravelMode.values.map((mode) {
                  final isSelected = selectedMode == mode;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setSheetState(() => selectedMode = mode),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.teal.withValues(alpha: 0.2)
                              : AppColors.glassBgMid,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.teal
                                : AppColors.glassBorder,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            mode.displayName,
                            style: AppTypography.labelMd.copyWith(
                              color: isSelected
                                  ? AppColors.teal
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Origin City',
                  prefixIcon: Icon(Icons.flight_takeoff, color: AppColors.teal),
                ),
                controller: TextEditingController(text: origin),
                onChanged: (v) => origin = v,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Destination City',
                  prefixIcon: Icon(Icons.flight_land, color: AppColors.teal),
                ),
                controller: TextEditingController(text: destination),
                onChanged: (v) => destination = v,
              ),
              if (selectedMode == TravelMode.international) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Flight Direction (Jet Lag Calibration)',
                    style: AppTypography.labelLg),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('East (e.g. Bangkok / Tokyo)'),
                        selected: direction == TravelDirection.east,
                        onSelected: (s) => setSheetState(
                            () => direction = TravelDirection.east),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('West (e.g. London / NYC)'),
                        selected: direction == TravelDirection.west,
                        onSelected: (s) => setSheetState(
                            () => direction = TravelDirection.west),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    ref.read(travelModeProvider.notifier).startTravelMode(
                          TravelContext(
                            mode: selectedMode,
                            origin: origin,
                            destination: destination,
                            departureDate: DateTime.now(),
                            direction: direction,
                          ),
                        );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Activate Travel Mode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(travelModeProvider);
    final contextData = state.activeContext;
    final adaptation = state.adaptation;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Travel Intelligence', style: AppTypography.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined,
                color: AppColors.teal),
            tooltip: 'Change Travel Context',
            onPressed: () => _showNewTravelSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: state.isActive && adaptation != null && contextData != null
            ? _buildActiveTravelView(state, contextData, adaptation)
            : _buildInactiveView(),
      ),
    );
  }

  Widget _buildActiveTravelView(
    TravelModeState state,
    TravelContext contextData,
    TravelAdaptation adaptation,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Header Banner: ✈️ Travel Mode Active & Route
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.teal.withValues(alpha: 0.25),
                AppColors.secondary.withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.teal.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('✈️ ', style: TextStyle(fontSize: 20)),
                  Text(
                    'Travel Mode Active',
                    style: AppTypography.h3.copyWith(color: AppColors.teal),
                  ),
                  const Spacer(),
                  if (state.extendedDays > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Text(
                        '+${state.extendedDays}d Extended',
                        style: AppTypography.labelMd
                            .copyWith(color: AppColors.warning, fontSize: 11),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                contextData.routeDisplay,
                style: AppTypography.bodyLg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your entire daily health blueprint has been adapted for travel context.',
                style: AppTypography.bodySm
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),
        Text('Your Plan is Adapted:', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),

        // 1. Workout Adaptation Card
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🏋️ ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      'Workout: ${adaptation.workoutPlan.title}',
                      style: AppTypography.labelLg
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${adaptation.workoutPlan.minutes} min',
                      style:
                          AppTypography.labelMd.copyWith(color: AppColors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: adaptation.workoutPlan.exercises
                    .map(
                      (e) => Chip(
                        label: Text(e, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.glassBgMid,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 6),
              Text(
                adaptation.workoutPlan.tip,
                style: AppTypography.bodySm
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // 2. Nutrition Adaptation Card
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🥗 ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      'Nutrition: ${adaptation.calorieBudget}',
                      style: AppTypography.labelLg
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Strategy: ${adaptation.nutritionPlan.strategy}',
                style:
                    AppTypography.bodySm.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text('Best Bets:',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: adaptation.nutritionPlan.bestBets
                    .map(
                      (b) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.glassBgMid,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Text(
                          b,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // 3. Hydration Card
        BentoCard(
          child: Row(
            children: [
              const Text('💧 ', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hydration Target', style: AppTypography.labelLg),
                    Text(
                      adaptation.hydrationNote,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // 4. Sleep & Circadian Card
        if (adaptation.sleepNote != null)
          BentoCard(
            child: Row(
              children: [
                const Text('😴 ', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sleep Protocol', style: AppTypography.labelLg),
                      Text(
                        adaptation.sleepNote!,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.sm),

        // 5. Readiness Expectation Card
        BentoCard(
          child: Row(
            children: [
              const Text('📊 ', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Readiness Expectation', style: AppTypography.labelLg),
                    Text(
                      adaptation.readinessExpectationSummary,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 6. Jet Lag Protocol Card (if international)
        if (adaptation.jetLagProtocol != null) ...[
          const SizedBox(height: AppSpacing.sm),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🌐 ', style: TextStyle(fontSize: 18)),
                    Text(
                      'Jet Lag Protocol (${adaptation.jetLagProtocol!.direction.displayName})',
                      style:
                          AppTypography.labelLg.copyWith(color: AppColors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...adaptation.jetLagProtocol!.recommendations.map(
                  (rec) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppColors.teal)),
                        Expanded(
                          child: Text(
                            rec,
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.lg),

        // Action Buttons: [End Travel Mode] [Extend by 1 day]
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () =>
                    ref.read(travelModeProvider.notifier).endTravelMode(),
                child: const Text('End Travel Mode'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => ref
                    .read(travelModeProvider.notifier)
                    .extendTravelMode(days: 1),
                child: const Text('Extend by 1 day',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildInactiveView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧳', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 16),
            Text('Travel Mode Inactive', style: AppTypography.h2),
            const SizedBox(height: 8),
            Text(
              'Traveling soon? Activate Travel Mode to auto-adapt your workouts, nutrition buffers, and circadian sleep schedules.',
              textAlign: TextAlign.center,
              style:
                  AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.flight_takeoff),
              label: const Text('Activate Travel Mode',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _showNewTravelSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
