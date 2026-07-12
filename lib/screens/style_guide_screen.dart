import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/providers/azure_provider.dart';
import 'package:fitkarma/core/sync/connectivity_service.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_gradients.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/shared/widgets/activity_rings.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/bento_grid.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/shared/widgets/glowing_metric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stream providers for offline-first reactive UI sync states
final waterLogsTodayProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  final query = db.select(db.waterLogs)..where((t) => t.loggedAt.isBiggerThanValue(todayStart));
  return query.watch().map((list) {
    return list.fold<int>(0, (sum, item) => sum + item.cups);
  });
});

final syncQueueCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.syncQueueItems).watch().map((list) => list.length);
});

final dlqCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.deadLetterQueueItems).watch().map((list) => list.length);
});

class StyleGuideScreen extends ConsumerStatefulWidget {
  const StyleGuideScreen({super.key});

  @override
  ConsumerState<StyleGuideScreen> createState() => _StyleGuideScreenState();
}

class _StyleGuideScreenState extends ConsumerState<StyleGuideScreen> {
  bool _springToggled = false;
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.bg0,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTabBar(),
                    const SizedBox(height: 20.0),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _activeTab == 0 ? _buildDashboardView() : _buildSpecsView(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader() {
    final isOnline = ref.watch(connectivityProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BilingualLabel(
            englishText: 'FITKARMA',
            hindiText: 'फिटकर्मा • स्वास्थ्य ओएस',
            englishStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: AppColorsDark.primary,
            ),
          ),
          // Interactive Connection Status Badge
          GestureDetector(
            onTap: () {
              ref.read(connectivityProvider.notifier).setOnline(!isOnline);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: isOnline 
                      ? AppColorsDark.success.withOpacity(0.08)
                      : AppColorsDark.textMuted.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: isOnline 
                        ? AppColorsDark.success.withOpacity(0.3)
                        : AppColorsDark.textMuted.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: isOnline ? AppColorsDark.success : AppColorsDark.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      isOnline ? 'Online (Click to toggle)' : 'Offline (Click to toggle)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isOnline ? AppColorsDark.success : AppColorsDark.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- NAVIGATION TAB BAR ---
  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTabItem(0, 'Health Dashboard', Icons.fitness_center_rounded),
        const SizedBox(width: 12.0),
        _buildTabItem(1, 'Token Specs', Icons.menu_book_rounded),
      ],
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColorsDark.primary.withOpacity(0.1)
                : AppColorsDark.surface0,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected 
                  ? AppColorsDark.primary.withOpacity(0.4)
                  : AppColorsDark.glassBorder,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColorsDark.primary : AppColorsDark.textSecondary,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColorsDark.primary : AppColorsDark.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- VIEW 1: FITNESS DASHBOARD VIEW ---
  Widget _buildDashboardView() {
    final waterCupsAsync = ref.watch(waterLogsTodayProvider);
    final waterCups = waterCupsAsync.value ?? 0;

    final queueCountAsync = ref.watch(syncQueueCountProvider);
    final queueCount = queueCountAsync.value ?? 0;

    final dlqCountAsync = ref.watch(dlqCountProvider);
    final dlqCount = dlqCountAsync.value ?? 0;

    final bentoItems = [
      // 1. Concentric Activity Rings (2x2)
      BentoGridItem(
        columnSpan: 2,
        rowSpan: 2,
        child: BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                englishText: 'Daily Mission progress',
                hindiText: 'दैनिक मिशन प्रगति',
                englishStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.textPrimary,
                ),
              ),
              const Spacer(),
              Center(
                child: ActivityRings(
                  rings: const [
                    RingData(
                      value: 7800,
                      target: 10000,
                      colors: [AppColorsDark.primary, AppColorsDark.accent],
                      strokeWidth: 10.0,
                    ),
                    RingData(
                      value: 580,
                      target: 800,
                      colors: [AppColorsDark.rose, AppColorsDark.purple],
                      strokeWidth: 10.0,
                    ),
                    RingData(
                      value: 30,
                      target: 45,
                      colors: [AppColorsDark.teal, AppColorsDark.success],
                      strokeWidth: 10.0,
                    ),
                  ],
                  size: 120.0,
                  gap: 4.0,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendDot('Steps', AppColorsDark.primary),
                  _buildLegendDot('Energy', AppColorsDark.rose),
                  _buildLegendDot('Active', AppColorsDark.teal),
                ],
              )
            ],
          ),
        ),
      ),

      // 2. Heart Rate (2x1)
      BentoGridItem(
        columnSpan: 2,
        rowSpan: 1,
        child: BentoCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BilingualLabel(
                      englishText: 'Heart Rate',
                      hindiText: 'हृदय गति',
                      englishStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColorsDark.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const GlowingMetric(
                      value: '124',
                      unit: 'bpm',
                      glowColor: AppColorsDark.rose,
                      customStyle: AppTypography.metricLg,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(10, (index) {
                      final heights = [0.2, 0.4, 0.3, 0.9, 0.8, 0.3, 0.5, 0.7, 0.4, 0.3];
                      return Container(
                        width: 4,
                        height: 45 * heights[index],
                        decoration: BoxDecoration(
                          color: index == 3 || index == 4 
                              ? AppColorsDark.rose 
                              : AppColorsDark.rose.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      // 3. Encrypted Local SQLite + Sync Queue Water Incrementer (1x1)
      BentoGridItem(
        columnSpan: 1,
        rowSpan: 1,
        child: BentoCard(
          onTap: () async {
            final db = ref.read(databaseProvider);
            final batchId = 'water_batch_${DateTime.now().millisecondsSinceEpoch}';
            
            // 1. Optimistic SQLite insert (streams update local UI state immediately)
            await db.into(db.waterLogs).insert(
              WaterLogsCompanion.insert(
                cups: 1,
                syncBatchId: batchId,
                loggedAt: DateTime.now(),
                hlcPhysicalTime: DateTime.now(),
                hlcLogicalCounter: 0,
                hlcNodeId: 'node_mobile_device',
              ),
            );

            // 2. Queue local sync item
            await db.into(db.syncQueueItems).insert(
              SyncQueueItemsCompanion.insert(
                entityType: 'water_log',
                entityId: batchId,
                serializedPayload: jsonEncode({
                  'cups': 1,
                  'loggedAt': DateTime.now().toIso8601String(),
                  'syncBatchId': batchId,
                }),
                createdAt: DateTime.now(),
                syncBatchId: batchId,
              ),
            );

            // 3. Trigger worker thread sync
            ref.read(syncWorkerProvider).triggerSync();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                englishText: 'Water Log',
                hindiText: 'पानी का सेवन',
                englishStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColorsDark.textSecondary,
                ),
              ),
              const Spacer(),
              GlowingMetric(
                value: '$waterCups',
                unit: 'cups',
                glowColor: AppColorsDark.teal,
                customStyle: AppTypography.metricLg.copyWith(color: Colors.white),
              ),
              const Spacer(),
              const Text(
                '+ Log (Writes DB)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.teal,
                ),
              ),
            ],
          ),
        ),
      ),

      // 4. Diagnostics Dashboard (1x1)
      BentoGridItem(
        columnSpan: 1,
        rowSpan: 1,
        child: BentoCard(
          customBgColor: AppColorsDark.surface1.withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                englishText: 'Sync Status',
                hindiText: 'सिंक स्थिति',
                englishStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColorsDark.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Queued: $queueCount',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColorsDark.accent,
                ),
              ),
              Text(
                'DLQ: $dlqCount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: dlqCount > 0 ? AppColorsDark.error : AppColorsDark.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                ref.watch(syncWorkerProvider).isSyncing ? 'Syncing...' : 'Idle',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColorsDark.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),

      // 5. Workout Card (2x1)
      BentoGridItem(
        columnSpan: 2,
        rowSpan: 1,
        child: BentoCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BilingualLabel(
                      englishText: 'Today\'s Routine',
                      hindiText: 'आज का व्यायाम',
                      englishStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColorsDark.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      'Hypertrophy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColorsDark.textPrimary,
                      ),
                    ),
                    Text(
                      'Push workout A',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColorsDark.success,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsDark.primaryGlow,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              )
            ],
          ),
        ),
      ),

      // 6. Interactive Springs Simulator Card (4x2)
      BentoGridItem(
        columnSpan: 4,
        rowSpan: 2,
        child: BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                englishText: 'Spring Physics Simulator',
                hindiText: 'स्प्रिंग भौतिकी सिम्युलेटर',
                englishStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Uses AppSprings.touchResponseCurve (damping: 0.5, freq: 1.8) on state transformations.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColorsDark.textSecondary,
                ),
              ),
              const Spacer(),
              // Spring track
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColorsDark.glassBorder,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 700),
                      curve: AppSprings.touchResponseCurve,
                      left: _springToggled ? 250.0 : 20.0,
                      top: 15.0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _springToggled = !_springToggled;
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppGradients.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColorsDark.primaryGlow,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.bolt,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Physics formula: Damped Harmonic Oscillator',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      color: AppColorsDark.textMuted,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _springToggled = !_springToggled;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsDark.primary.withOpacity(0.12),
                      foregroundColor: AppColorsDark.primary,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        side: const BorderSide(
                          color: AppColorsDark.primary,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Launch Spring',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BentoGrid(
          items: bentoItems,
        ),
      ],
    );
  }

  // --- VIEW 2: TOKEN SPECIFICATIONS AND DIAGNOSTICS ---
  Widget _buildSpecsView() {
    final client = ref.read(azureSyncClientProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Simulated Cloud Config Toggles
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cloud Sync Simulation & Diagnostics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.textPrimary,
                ),
              ),
              const SizedBox(height: 12.0),
              // Failures switch
              SwitchListTile(
                title: const Text('Simulate Flaky Internet (60% REST drop)'),
                subtitle: const Text('Forces retries up to 3 times, then drops items to DLQ'),
                value: client.simulateNetworkFailures,
                activeThumbColor: AppColorsDark.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    client.simulateNetworkFailures = val;
                  });
                },
              ),
              // Purge database button
              const SizedBox(height: 12.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final db = ref.read(databaseProvider);
                    await db.delete(db.waterLogs).go();
                    await db.delete(db.syncQueueItems).go();
                    await db.delete(db.deadLetterQueueItems).go();
                    ref.read(syncWorkerProvider).triggerSync();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.error.withOpacity(0.12),
                    foregroundColor: AppColorsDark.error,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  child: const Text('Purge Database & Sync Queues', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12.0),

        // Color Palette Tokens
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Design Palette Tokens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.textPrimary,
                ),
              ),
              const SizedBox(height: 12.0),
              _buildColorSwatch('bg0 (Scaffold Background)', AppColorsDark.bg0, '#080810'),
              _buildColorSwatch('surface0 (Default Container)', AppColorsDark.surface0, '#1C1C2E'),
              _buildColorSwatch('primary (Brand highlight)', AppColorsDark.primary, '#FF6B35'),
              _buildColorSwatch('accent (Gains & Achievements)', AppColorsDark.accent, '#FFB547'),
              _buildColorSwatch('secondary (Sleep/Meditation)', AppColorsDark.secondary, '#7B6FF0'),
              _buildColorSwatch('teal (Hydration & Vitals)', AppColorsDark.teal, '#00D4B4'),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        
        // Typography Spec
        const BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Typography Tokens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.textPrimary,
                ),
              ),
              SizedBox(height: 12.0),
              Text('Display Bold (72px)', style: AppTypography.heroDisplay),
              SizedBox(height: 8.0),
              Text('Metric Hero (56px)', style: AppTypography.metricXL),
              SizedBox(height: 8.0),
              Text('Header H1 (22px)', style: AppTypography.h1),
              SizedBox(height: 8.0),
              Text('Body Regular (14px)', style: AppTypography.bodyMd),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColorsDark.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color, String hexCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColorsDark.glassBorder),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColorsDark.textPrimary,
                  ),
                ),
                Text(
                  hexCode,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: AppColorsDark.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
