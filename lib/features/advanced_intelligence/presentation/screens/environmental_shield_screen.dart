import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/environmental_intelligence_engine.dart';

class EnvironmentalShieldScreen extends ConsumerStatefulWidget {
  const EnvironmentalShieldScreen({super.key});

  @override
  ConsumerState<EnvironmentalShieldScreen> createState() => _EnvironmentalShieldScreenState();
}

class _EnvironmentalShieldScreenState extends ConsumerState<EnvironmentalShieldScreen> {
  final _engine = const EnvironmentalIntelligenceEngine();
  String _selectedCity = 'Delhi / NCR';
  int _currentAqi = 265; // Severe AQI demo

  final Map<String, int> _cityAqiPresets = {
    'Delhi / NCR': 265,
    'Mumbai': 120,
    'Bengaluru': 48,
    'Kolkata': 185,
    'Chennai': 65,
  };

  @override
  Widget build(BuildContext context) {
    final plan = _engine.generateEnvironmentalPlan(
      city: _selectedCity,
      aqi: _currentAqi,
      temperatureC: 34.0,
      humidityPercent: 68.0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Environmental Shield OS', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _cityAqiPresets.keys.map((city) {
                  final isSelected = city == _selectedCity;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(city),
                      selected: isSelected,
                      selectedColor: AppColors.primaryCyan,
                      backgroundColor: AppColors.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedCity = city;
                            _currentAqi = _cityAqiPresets[city]!;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Live AQI Hero Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: plan.canExerciseOutdoors ? AppColors.primaryEmerald : AppColors.accentCoral,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AIR QUALITY INDEX (AQI)', style: AppTypography.label.copyWith(color: plan.canExerciseOutdoors ? AppColors.primaryEmerald : AppColors.accentCoral)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('${plan.aqi}', style: AppTypography.heroMetric.copyWith(color: plan.canExerciseOutdoors ? AppColors.primaryEmerald : AppColors.accentCoral)),
                              const SizedBox(width: 8),
                              Text(plan.aqiCategory, style: AppTypography.h3),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        plan.canExerciseOutdoors ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: plan.canExerciseOutdoors ? AppColors.primaryEmerald : AppColors.accentCoral,
                        size: 36,
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Outdoor Workout Safety:', style: AppTypography.label),
                      Text(
                        plan.canExerciseOutdoors ? 'SAFE TO RUN' : 'HAZARDOUS: STAY INDOORS',
                        style: AppTypography.label.copyWith(
                          color: plan.canExerciseOutdoors ? AppColors.primaryEmerald : AppColors.accentCoral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Smog Shield Workout Adaptation
            Text('Smog Defense Workout Adaptation', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.air, color: AppColors.primaryCyan),
                      const SizedBox(width: 8),
                      Text('Indoor Air-Filtered Protocol', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(plan.indoorSubstitutionWorkout, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(plan.indoorSubstitutionWorkoutHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Thermal Stress & Hydration Modifier
            Text('Thermal Stress & Hydration Multiplier', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              glowColor: AppColors.accentAmber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: AppColors.accentAmber),
                      const SizedBox(width: 8),
                      Text('Heat Index: ${plan.heatIndexC}°C', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(plan.hydrationModifier, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
