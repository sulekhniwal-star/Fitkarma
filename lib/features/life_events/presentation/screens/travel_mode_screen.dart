import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/life_events/domain/services/travel_intelligence_engine.dart';

class TravelModeScreen extends ConsumerStatefulWidget {
  const TravelModeScreen({super.key});

  @override
  ConsumerState<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends ConsumerState<TravelModeScreen> {
  final _engine = const TravelIntelligenceEngine();
  bool _hasHotelGym = false;
  final String _destination = 'Bengaluru (Business Trip)';

  @override
  Widget build(BuildContext context) {
    final plan = _engine.createTravelPlan(
      destination: _destination,
      tripDurationDays: 4,
      hasHotelGym: _hasHotelGym,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Travel & Hotel Mode', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination & Gym Toggle Card
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DESTINATION', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                          Text(plan.destination, style: AppTypography.h3),
                        ],
                      ),
                      Switch(
                        value: _hasHotelGym,
                        activeThumbColor: AppColors.primaryEmerald,
                        onChanged: (val) {
                          setState(() => _hasHotelGym = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasHotelGym ? 'Hotel Gym Available (Dumbbell Complex)' : 'No Gym (Hotel Room Calisthenics & Surya Namaskar)',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Workouts
            Text('Travel Workout Protocol', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...plan.hotelWorkouts.map((wo) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.fitness_center, color: AppColors.primaryEmerald, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(wo, style: AppTypography.bodyMedium)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Digestion Shield & Restaurant Strategy
            Text('Travel Gut Health & Digestion Shield', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              glowColor: AppColors.accentAmber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.accentAmber),
                      const SizedBox(width: 8),
                      Text('Digestion & Anti-Bloat Checklist', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...plan.digestionChecklist.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.accentAmber)),
                            Expanded(child: Text(tip, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Text('Dining & Buffet Strategy:', style: AppTypography.h3),
                  const SizedBox(height: 4),
                  ...plan.regionalDiningTips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.primaryCyan)),
                            Expanded(child: Text(tip, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  Text('Hydration Target:', style: AppTypography.h3),
                  const SizedBox(height: 4),
                  Text(plan.hydrationStrategy, style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
