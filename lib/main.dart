import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/sync/outbox_sync_worker.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'core/widgets/activity_rings.dart';
import 'core/widgets/bento_card.dart';
import 'core/widgets/bilingual_label.dart';
import 'core/widgets/glowing_metric.dart';
import 'features/environmental/services/environmental_health_engine.dart';
import 'features/health_os/services/ai_routing_service.dart';
import 'features/health_os/services/health_os_brain.dart';
import 'features/metabolism/services/metabolism_engine.dart';

// Riverpod Global Providers
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final outboxSyncWorkerProvider = Provider<OutboxSyncWorker>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final worker = OutboxSyncWorker(db: db);
  ref.onDispose(() => worker.dispose());
  return worker;
});

final metabolismEngineProvider = Provider<MetabolismEngine>((ref) {
  return const MetabolismEngine();
});

final environmentalEngineProvider = Provider<EnvironmentalHealthEngine>((ref) {
  return const EnvironmentalHealthEngine();
});

final aiRoutingServiceProvider = Provider<AIRoutingService>((ref) {
  return AIRoutingService();
});

final healthOSBrainProvider = Provider<HealthOSBrain>((ref) {
  return HealthOSBrain(
    metabolismEngine: ref.watch(metabolismEngineProvider),
    environmentalEngine: ref.watch(environmentalEngineProvider),
    aiRoutingService: ref.watch(aiRoutingServiceProvider),
  );
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: FitKarmaApp(),
    ),
  );
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const FoundationDashboardScreen(),
    );
  }
}

class FoundationDashboardScreen extends ConsumerWidget {
  const FoundationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metabolism = ref.watch(metabolismEngineProvider).calculateProfile(
          weightKg: 72.0,
          heightCm: 175.0,
          age: 28,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          goal: Goal.fatLoss,
        );

    final env = ref.watch(environmentalEngineProvider).assess(
          aqi: 142,
          uvIndex: 6.4,
          temperatureC: 31.0,
          humidityPercent: 65.0,
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          english: 'Health OS Foundation',
          hindi: 'हेल्थ ओएस फाउंडेशन',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: AppColors.primaryCyan),
            onPressed: () {
              ref.read(outboxSyncWorkerProvider).triggerSync();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offline outbox sync triggered'),
                  backgroundColor: AppColors.surfaceCard,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Hero Readiness Bento Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          english: 'Readiness Score',
                          hindi: 'दैनिक फिटनेस तत्परता',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your system is primed for training today.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const GlowingMetric(
                    value: '86',
                    label: 'Prime',
                    hindiLabel: 'सर्वोत्तम',
                    glowColor: AppColors.primaryEmerald,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Activity Rings & Metabolism Split
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    child: Column(
                      children: [
                        const BilingualLabel(
                          english: 'Target Rings',
                          hindi: 'दैनिक लक्ष्य',
                        ),
                        const SizedBox(height: 12),
                        ActivityRings(
                          size: 110,
                          rings: const [
                            RingData(progress: 0.75, color: AppColors.primaryCyan, strokeWidth: 8),
                            RingData(progress: 0.60, color: AppColors.primaryEmerald, strokeWidth: 8),
                            RingData(progress: 0.90, color: AppColors.accentAmber, strokeWidth: 8),
                          ],
                          centerChild: Text(
                            '${metabolism.targetCalories.toInt()}',
                            style: AppTypography.h3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          english: 'Macros Budget',
                          hindi: 'पोषक तत्व',
                        ),
                        const SizedBox(height: 8),
                        _buildMacroRow('Protein', '${metabolism.targetProteinGrams}g', AppColors.primaryCyan),
                        _buildMacroRow('Carbs', '${metabolism.targetCarbsGrams}g', AppColors.accentAmber),
                        _buildMacroRow('Fats', '${metabolism.targetFatsGrams}g', AppColors.accentCoral),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Environmental Safety Card
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
                        english: 'Environmental Health',
                        hindi: 'पर्यावरण स्वास्थ्य',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AQI ${env.aqi}',
                          style: AppTypography.label.copyWith(color: AppColors.accentAmber),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.bodySmall),
            ],
          ),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
