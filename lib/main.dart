import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_typography.dart';
import 'shared/widgets/activity_rings.dart';
import 'shared/widgets/glass_card.dart';
import 'shared/widgets/glowing_metric.dart';
import 'shared/widgets/health_score_ring.dart';

void main() {
  runApp(const ProviderScope(child: FitKarmaApp()));
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryCyan,
          secondary: AppColors.primaryEmerald,
          surface: AppColors.bgSecondary,
        ),
      ),
    );
  }
}

class FoundationHomePage extends StatelessWidget {
  const FoundationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FitKarma', style: AppTypography.displayLarge),
              const SizedBox(height: 8.0),
              Text(
                'India\'s Intelligent Health Operating System',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24.0),
              const GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HealthScoreRing(score: 88, size: 100.0),
                    ActivityRings(
                      moveProgress: 0.85,
                      exerciseProgress: 0.65,
                      standProgress: 0.90,
                      size: 90.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const GlassCard(
                child: GlowingMetric(
                  value: '10,482',
                  label: 'Daily Steps',
                  unit: 'steps',
                  color: AppColors.primaryCyan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
