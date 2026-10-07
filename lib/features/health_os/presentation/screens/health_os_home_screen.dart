import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/activity_rings.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/core/widgets/bilingual_label.dart';
import 'package:fitkarma/core/widgets/glowing_metric.dart';
import 'package:fitkarma/main.dart';
import 'package:fitkarma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitkarma/features/coach/presentation/screens/ai_coach_screen.dart';
import 'package:fitkarma/features/health_tracking/presentation/screens/steps_tracking_screen.dart';
import 'package:fitkarma/features/nutrition/presentation/screens/meal_logger_screen.dart';
import 'package:fitkarma/features/readiness_engine/presentation/screens/recovery_log_screen.dart';
import 'package:fitkarma/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:fitkarma/features/hydration/domain/providers/hydration_provider.dart';
import 'package:fitkarma/features/hydration/presentation/screens/hydration_tracker_screen.dart';
import 'package:fitkarma/core/localization/app_language.dart';
import '../providers/dashboard_providers.dart';

class HealthOSHomeScreen extends ConsumerWidget {
  final ValueChanged<int>? onTabSelected;

  const HealthOSHomeScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final dashboard = ref.watch(dashboardStateProvider);
    final env = ref.watch(environmentalEngineProvider).assess(
          aqi: 142,
          uvIndex: 6.4,
          temperatureC: 31.0,
          humidityPercent: 65.0,
        );

    final currentLanguage = ref.watch(appLanguageProvider);
    final hydration = ref.watch(hydrationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const BilingualLabel(
          english: 'Health OS Intelligence',
          hindi: 'हेल्थ ओएस इंटेलिजेंस',
        ),
        actions: [
          // Language Switcher Button
          InkWell(
            onTap: () => _showLanguagePicker(context, ref),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlass,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentLanguage.flag, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    currentLanguage.code.toUpperCase(),
                    style: AppTypography.label.copyWith(
                      color: AppColors.primaryCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sync, color: AppColors.primaryCyan),
            tooltip: 'Sync Offline Outbox',
            onPressed: () {
              ref.read(outboxSyncWorkerProvider).triggerSync();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offline outbox sync triggered'),
                  backgroundColor: AppColors.surfaceCard,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.accentCoral),
            tooltip: 'Sign Out',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // 1. User Header Pill
            if (user != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryCyan.withAlpha(50),
                      backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                      child: user.avatarUrl == null
                          ? Text(
                              (user.fullName ?? user.email).substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName ?? 'FitKarma Member',
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user.email,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withAlpha(35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryEmerald,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'LIVE SYNC',
                            style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

            // 2. Hero Dynamic Readiness Bento Card
            BentoCard(
              isGlowing: dashboard.readinessScore != null,
              glowColor: _getReadinessColor(dashboard.readinessScore),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RecoveryLogScreen()),
                );
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              english: 'Daily Readiness Score',
                              hindi: 'दैनिक फिटनेस तत्परता',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dashboard.readinessSubtitle,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (dashboard.readinessScore != null)
                        GlowingMetric(
                          value: '${dashboard.readinessScore}',
                          label: dashboard.readinessLabel,
                          hindiLabel: dashboard.readinessHindiLabel,
                          glowColor: _getReadinessColor(dashboard.readinessScore),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryCyan.withAlpha(100)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app_outlined, size: 16, color: AppColors.primaryCyan),
                              const SizedBox(width: 6),
                              Text(
                                'Check-In',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primaryCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        dashboard.readinessScore != null
                            ? 'Tap to update recovery ritual  →'
                            : 'Tap to complete morning check-in  →',
                        style: AppTypography.label.copyWith(
                          color: AppColors.primaryCyan,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 16),

            // 3. Dynamic Activity Target Rings & Macros Split
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rings Card
                Expanded(
                  flex: 5,
                  child: BentoCard(
                    child: Column(
                      children: [
                        const BilingualLabel(
                          english: 'Activity Rings',
                          hindi: 'दैनिक लक्ष्य',
                        ),
                        const SizedBox(height: 14),
                        ActivityRings(
                          size: 115,
                          rings: [
                            RingData(
                              progress: dashboard.caloriesRingProgress,
                              color: AppColors.primaryCyan,
                              strokeWidth: 8,
                            ),
                            RingData(
                              progress: dashboard.workoutRingProgress,
                              color: AppColors.primaryEmerald,
                              strokeWidth: 8,
                            ),
                            RingData(
                              progress: dashboard.stepsRingProgress,
                              color: AppColors.accentAmber,
                              strokeWidth: 8,
                            ),
                          ],
                          centerChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${dashboard.consumedCalories.toInt()}',
                                style: AppTypography.h3.copyWith(fontSize: 18),
                              ),
                              Text(
                                'kcal in',
                                style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Ring Legend
                        _buildRingLegendDot(
                          AppColors.primaryCyan,
                          'Calories: ${dashboard.consumedCalories.toInt()} / ${dashboard.targetCalories.toInt()}',
                        ),
                        const SizedBox(height: 4),
                        _buildRingLegendDot(
                          AppColors.primaryEmerald,
                          'Workout: ${dashboard.workoutDurationMinutes} / ${dashboard.workoutTargetMinutes}m',
                        ),
                        const SizedBox(height: 4),
                        _buildRingLegendDot(
                          AppColors.accentAmber,
                          'Steps: ${dashboard.todaySteps} / ${dashboard.stepGoal}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Macros Budget Card
                Expanded(
                  flex: 5,
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          english: 'Macros Budget',
                          hindi: 'पोषक तत्व',
                        ),
                        const SizedBox(height: 12),
                        _buildMacroProgress(
                          label: 'Protein',
                          consumed: dashboard.consumedProteinGrams,
                          target: dashboard.targetProteinGrams,
                          color: AppColors.primaryCyan,
                        ),
                        const SizedBox(height: 10),
                        _buildMacroProgress(
                          label: 'Carbs',
                          consumed: dashboard.consumedCarbsGrams,
                          target: dashboard.targetCarbsGrams,
                          color: AppColors.accentAmber,
                        ),
                        const SizedBox(height: 10),
                        _buildMacroProgress(
                          label: 'Fats',
                          consumed: dashboard.consumedFatsGrams,
                          target: dashboard.targetFatsGrams,
                          color: AppColors.accentCoral,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGlassHover,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Burned', style: AppTypography.label.copyWith(fontSize: 10)),
                              Text(
                                '${dashboard.burnedCalories.toInt()} kcal',
                                style: AppTypography.label.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryEmerald,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Hydration Card (Indian Climate Aware)
            BentoCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HydrationTrackerScreen()),
              ),
              isGlowing: hydration.isGoalMet,
              glowColor: AppColors.primaryCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCyan.withAlpha(35),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.water_drop, color: AppColors.primaryCyan, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BilingualLabel(
                                english: 'Daily Hydration',
                                hindi: 'दैनिक जल सेवन',
                              ),
                              Text(
                                '${hydration.consumedMl.toInt()} / ${hydration.goalMl.toInt()} ml',
                                style: AppTypography.heroMetric.copyWith(fontSize: 18, color: AppColors.primaryCyan),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.primaryCyan, size: 24),
                            tooltip: 'Quick +250ml Glass',
                            onPressed: () {
                              ref.read(hydrationProvider.notifier).logWater(amountMl: 250);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added 250ml water (Glass)! 💧'),
                                  backgroundColor: AppColors.primaryCyan,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.local_drink, color: AppColors.primaryEmerald, size: 24),
                            tooltip: 'Quick +500ml Bottle',
                            onPressed: () {
                              ref.read(hydrationProvider.notifier).logWater(amountMl: 500);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added 500ml water (Bottle)! 💧'),
                                  backgroundColor: AppColors.primaryEmerald,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: hydration.progressFraction,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceCard,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryCyan),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hydration.isGoalMet ? 'Daily goal reached! 🎉' : '${hydration.remainingMl.toInt()} ml remaining',
                        style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      Text(
                        'Nimbu Pani • Coconut Water • Chai options inside →',
                        style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryCyan),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 120.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // 4. Quick Action Logging Bar
            Text('Quick Activity Logging', style: AppTypography.h3),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionButton(
                    icon: Icons.water_drop_outlined,
                    label: '+ Hydration',
                    color: AppColors.primaryCyan,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HydrationTrackerScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.restaurant_outlined,
                    label: '+ Log Meal',
                    color: AppColors.primaryCyan,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MealLoggerScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.fitness_center,
                    label: '+ Start Workout',
                    color: AppColors.primaryEmerald,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ActiveWorkoutScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.self_improvement,
                    label: '+ Recovery Check-in',
                    color: AppColors.accentPurple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RecoveryLogScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.directions_walk,
                    label: '+ Track Steps',
                    color: AppColors.accentAmber,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StepsTrackingScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.smart_toy_outlined,
                    label: 'Ask AI Coach',
                    color: AppColors.primaryCyan,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AICoachScreen()),
                      );
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // 5. Today's Activity Stream
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Logged Activities', style: AppTypography.h3),
                Text(
                  '${dashboard.mealsLoggedCount + dashboard.workoutsLoggedCount} items',
                  style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (dashboard.recentMeals.isEmpty && dashboard.recentWorkouts.isEmpty)
              BentoCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.playlist_add_check, size: 36, color: AppColors.textMuted),
                        const SizedBox(height: 8),
                        Text(
                          'No activities logged yet today',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Log a meal or workout above to see real-time updates',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else ...[
              // Logged Meals
              ...dashboard.recentMeals.map((meal) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lunch_dining, size: 18, color: AppColors.primaryCyan),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meal.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                              Text(
                                '${meal.mealType.toUpperCase()} • ${meal.proteinGrams.toStringAsFixed(1)}g P • ${meal.carbsGrams.toStringAsFixed(1)}g C • ${meal.fatGrams.toStringAsFixed(1)}g F',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '+${meal.caloriesKcal.toInt()} kcal',
                          style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              // Logged Workouts
              ...dashboard.recentWorkouts.map((workout) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.fitness_center, size: 18, color: AppColors.primaryEmerald),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workout.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                              Text(
                                '${(workout.durationSeconds / 60).round()} mins • ${workout.totalVolumeKg.toInt()} kg volume • RPE ${workout.avgRpe.toStringAsFixed(1)}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(workout.durationSeconds / 60 * 7.5).round()} kcal',
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
            ],

            const SizedBox(height: 16),

            // 6. Environmental Safety Card
            BentoCard(
              glowColor: AppColors.accentAmber,
              isGlowing: env.aqi > 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        english: 'Environmental Health Shield',
                        hindi: 'पर्यावरण स्वास्थ्य कवच',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AQI ${env.aqi}',
                          style: AppTypography.label.copyWith(color: AppColors.accentAmber, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    env.safetyAdvisory,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    env.safetyAdvisoryHindi,
                    style: AppTypography.bilingualSub,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getReadinessColor(int? score) {
    if (score == null) return AppColors.primaryCyan;
    if (score >= 85) return AppColors.primaryEmerald;
    if (score >= 70) return AppColors.primaryCyan;
    if (score >= 50) return AppColors.accentAmber;
    return AppColors.accentCoral;
  }

  Widget _buildRingLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroProgress({
    required String label,
    required double consumed,
    required double target,
    required Color color,
  }) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
            Text(
              '${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}g',
              style: AppTypography.label.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: AppColors.surfaceCard,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.label.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.read(appLanguageProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Language • மொழி / भाषा',
                      style: AppTypography.h3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: AppLanguage.values.length,
                    itemBuilder: (ctx, index) {
                      final lang = AppLanguage.values[index];
                      final isSelected = currentLanguage == lang;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            ref.read(appLanguageProvider.notifier).setLanguage(lang);
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryCyan.withAlpha(30) : AppColors.surfaceGlass,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryCyan : AppColors.borderGlass,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(lang.flag, style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.nativeLabel,
                                        style: AppTypography.bodyMedium.copyWith(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected ? AppColors.primaryCyan : AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        lang.subLabel,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryCyan),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
