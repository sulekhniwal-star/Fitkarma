import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/providers/azure_provider.dart';
import 'package:fitkarma/core/providers/core_providers.dart';
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
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:fitkarma/shared/widgets/fit_chip.dart';
import 'package:fitkarma/shared/widgets/fit_text_field.dart';
import 'package:fitkarma/shared/widgets/glass_card.dart';
import 'package:fitkarma/shared/widgets/glowing_metric.dart';
import 'package:fitkarma/shared/widgets/state_widgets.dart';
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
  
  // Interactive fields for components sandbox
  final TextEditingController _testInputController = TextEditingController();
  int _selectedChipIndex = 0;
  bool _btnLoadingState = false;

  _ThemeColors get colors => _ThemeColors(Theme.of(context).brightness == Brightness.dark);

  @override
  void dispose() {
    _testInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.bg0,
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
                      child: _activeTab == 0 
                          ? _buildDashboardView() 
                          : (_activeTab == 1 ? _buildSpecsView() : _buildComponentsView()),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BilingualLabel(
            englishText: 'FITKARMA',
            hindiText: 'फिटकर्मा • स्वास्थ्य ओएस',
            englishStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: colors.primary,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Connection Status Badge
              GestureDetector(
                onTap: () {
                  ref.read(connectivityProvider.notifier).setOnline(!isOnline);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isOnline 
                          ? colors.success.withOpacity(0.08)
                          : colors.textMuted.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: isOnline 
                            ? colors.success.withOpacity(0.3)
                            : colors.textMuted.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: isOnline ? colors.success : colors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isOnline ? colors.success : colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              // Dynamic Theme Toggler
              GestureDetector(
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggle();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: colors.secondary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: colors.secondary.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          size: 12,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          isDark ? 'Light' : 'Dark',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        const SizedBox(width: 12.0),
        _buildTabItem(2, 'Components', Icons.grid_view_rounded),
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
                ? colors.primary.withOpacity(0.1)
                : colors.surface0,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected 
                  ? colors.primary.withOpacity(0.4)
                  : colors.glassBorder,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.primary : colors.textSecondary,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              BilingualLabel(
                englishText: 'Daily Mission progress',
                hindiText: 'दैनिक मिशन प्रगति',
                englishStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Center(
                child: ActivityRings(
                  rings: [
                    RingData(
                      value: 7800,
                      target: 10000,
                      colors: [colors.primary, colors.accent],
                      strokeWidth: 10.0,
                    ),
                    RingData(
                      value: 580,
                      target: 800,
                      colors: [colors.rose, colors.purple],
                      strokeWidth: 10.0,
                    ),
                    RingData(
                      value: 30,
                      target: 45,
                      colors: [colors.teal, colors.success],
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
                  _buildLegendDot('Steps', colors.primary),
                  _buildLegendDot('Energy', colors.rose),
                  _buildLegendDot('Active', colors.teal),
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
                    BilingualLabel(
                      englishText: 'Heart Rate',
                      hindiText: 'हृदय गति',
                      englishStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    GlowingMetric(
                      value: '124',
                      unit: 'bpm',
                      glowColor: colors.rose,
                      customStyle: AppTypography.metricLg.copyWith(
                        color: colors.textPrimary,
                      ),
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
                              ? colors.rose 
                              : colors.rose.withOpacity(0.3),
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
            
            // 1. Optimistic SQLite insert
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

            // 3. Trigger worker sync
            ref.read(syncWorkerProvider).triggerSync();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BilingualLabel(
                englishText: 'Water Log',
                hindiText: 'पानी का सेवन',
                englishStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              GlowingMetric(
                value: '$waterCups',
                unit: 'cups',
                glowColor: colors.teal,
                customStyle: AppTypography.metricLg.copyWith(color: colors.textPrimary),
              ),
              const Spacer(),
              Text(
                '+ Log (Writes DB)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.teal,
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
          customBgColor: colors.surface1.withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BilingualLabel(
                englishText: 'Sync Status',
                hindiText: 'सिंक स्थिति',
                englishStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Queued: $queueCount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: colors.accent,
                ),
              ),
              Text(
                'DLQ: $dlqCount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: dlqCount > 0 ? colors.error : colors.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                ref.watch(syncWorkerProvider).isSyncing ? 'Syncing...' : 'Idle',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
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
                    BilingualLabel(
                      englishText: 'Today\'s Routine',
                      hindiText: 'आज का व्यायाम',
                      englishStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Hypertrophy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Push workout A',
                      style: AppTypography.bodySm.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: isDark ? AppElevation.primaryGlowDark : AppElevation.primaryGlowLight,
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
              BilingualLabel(
                englishText: 'Spring Physics Simulator',
                hindiText: 'स्प्रिंग भौतिकी सिम्युलेटर',
                englishStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Uses AppSprings.touchResponseCurve (damping: 0.5, freq: 1.8) on state transformations.',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
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
                    color: colors.glassBorder,
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppGradients.primary,
                              boxShadow: isDark ? AppElevation.primaryGlowDark : AppElevation.primaryGlowLight,
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
                  Text(
                    'Physics formula: Damped Harmonic Oscillator',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      color: colors.textMuted,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _springToggled = !_springToggled;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary.withOpacity(0.12),
                      foregroundColor: colors.primary,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        side: BorderSide(
                          color: colors.primary,
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

  // --- VIEW 2: TOKEN SPECIFICATIONS ---
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
              Text(
                'Cloud Sync Simulation & Diagnostics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12.0),
              // Failures switch
              SwitchListTile(
                title: const Text('Simulate Flaky Internet (60% REST drop)'),
                subtitle: const Text('Forces retries up to 3 times, then drops items to DLQ'),
                value: client.simulateNetworkFailures,
                activeThumbColor: colors.primary,
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
                    backgroundColor: colors.error.withOpacity(0.12),
                    foregroundColor: colors.error,
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
              Text(
                'Design Palette Tokens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12.0),
              _buildColorSwatch('bg0 (Scaffold Background)', colors.bg0, '#080810 / #F6F6FB'),
              _buildColorSwatch('surface0 (Default Container)', colors.surface0, '#1C1C2E / #FFFFFF'),
              _buildColorSwatch('primary (Brand highlight)', colors.primary, '#FF6B35 / #E04E1B'),
              _buildColorSwatch('accent (Gains & Achievements)', colors.accent, '#FFB547 / #D97706'),
              _buildColorSwatch('secondary (Sleep/Meditation)', colors.secondary, '#7B6FF0 / #5D50DD'),
              _buildColorSwatch('teal (Hydration & Vitals)', colors.teal, '#00D4B4 / #009688'),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        
        // Typography Spec
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Typography Tokens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12.0),
              Text('Display Bold (72px)', style: AppTypography.heroDisplay.copyWith(color: colors.textPrimary)),
              const SizedBox(height: 8.0),
              Text('Metric Hero (56px)', style: AppTypography.metricXL.copyWith(color: colors.textPrimary)),
              const SizedBox(height: 8.0),
              Text('Header H1 (22px)', style: AppTypography.h1.copyWith(color: colors.textPrimary)),
              const SizedBox(height: 8.0),
              Text('Body Regular (14px)', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  // --- VIEW 3: COMPONENT SANDBOX VIEW ---
  Widget _buildComponentsView() {
    final activeDeviceTier = ref.watch(deviceTierProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Performance blur switcher
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance-Aware Glassmorphism Fallbacks',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'GlassCard automatically disables blur filters on DeviceTier.low devices to save GPU cycles.',
                style: TextStyle(fontSize: 12.0, color: colors.textSecondary),
              ),
              const SizedBox(height: 14.0),
              // Segmented tier selection
              Row(
                children: [
                  Expanded(
                    child: _buildTierButton(DeviceTier.low, 'Low Tier (Solid Fallback)'),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildTierButton(DeviceTier.medium, 'Medium Tier (Blurred)'),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildTierButton(DeviceTier.high, 'High Tier (Blurred)'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Sandbox Demonstration Cards side-by-side
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      height: 120.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.speed_rounded, size: 28.0),
                          const SizedBox(height: 8.0),
                          Text(
                            activeDeviceTier == DeviceTier.low ? 'Solid Fallback Active' : 'Blur Filter Active',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // 2. Buttons Spec
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interactive Button Library',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14.0),
              Row(
                children: [
                  Expanded(
                    child: FitButton(
                      onPressed: () {},
                      type: FitButtonType.primary,
                      child: const Text('Primary Orange'),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: FitButton(
                      onPressed: () {},
                      type: FitButtonType.secondary,
                      child: const Text('Secondary Glass'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: FitButton(
                      onPressed: () {},
                      type: FitButtonType.accent,
                      child: const Text('Accent Gold'),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: FitButton(
                      onPressed: () {
                        setState(() {
                          _btnLoadingState = !_btnLoadingState;
                        });
                      },
                      isLoading: _btnLoadingState,
                      child: const Text('Tap to Toggle Loading'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              FitButton(
                onPressed: () {},
                isDisabled: true,
                width: double.infinity,
                child: const Text('Disabled Action'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // 3. Inputs & Chips
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bilingual TextFields & Chips',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14.0),
              FitTextField(
                controller: _testInputController,
                englishLabel: 'Full Name',
                hindiLabel: 'पूरा नाम',
                hintText: 'Enter your name...',
              ),
              const SizedBox(height: 16.0),
              // Chips display
              Text(
                'Selectable Chips',
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: colors.textSecondary),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FitChip(
                    label: 'Breakfast (नाश्ता)',
                    isSelected: _selectedChipIndex == 0,
                    badgeText: '340 kcal',
                    icon: Icons.breakfast_dining_rounded,
                    onTap: () => setState(() => _selectedChipIndex = 0),
                  ),
                  FitChip(
                    label: 'Lunch (दोपहर का भोजन)',
                    isSelected: _selectedChipIndex == 1,
                    badgeText: '620 kcal',
                    icon: Icons.lunch_dining_rounded,
                    onTap: () => setState(() => _selectedChipIndex = 1),
                  ),
                  FitChip(
                    label: 'Dinner (रात का भोजन)',
                    isSelected: _selectedChipIndex == 2,
                    badgeText: '510 kcal',
                    icon: Icons.dinner_dining_rounded,
                    onTap: () => setState(() => _selectedChipIndex = 2),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // 4. Standard UI State placeholders
        BentoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unified UI State Components',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14.0),
              const Text('1. Loading State', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
              const SizedBox(height: 8.0),
              const FitLoadingState(
                message: 'Processing sync transaction...',
                hindiMessage: 'सिंक लेनदेन की प्रक्रिया चल रही है...',
              ),
              const Divider(height: 32.0, color: Colors.white24),
              const Text('2. Empty State', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
              const SizedBox(height: 8.0),
              const FitEmptyState(
                englishTitle: 'No workouts logged today',
                hindiTitle: 'आज कोई व्यायाम दर्ज नहीं किया गया',
                englishSubtitle: 'Complete a routine to start your daily streak.',
                hindiSubtitle: 'दैनिक सिलसिला शुरू करने के लिए एक व्यायाम पूरा करें।',
                icon: Icons.assignment_turned_in_rounded,
              ),
              const Divider(height: 32.0, color: Colors.white24),
              const Text('3. Error State', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
              const SizedBox(height: 8.0),
              FitErrorState(
                englishMessage: 'Sync operation timed out',
                hindiMessage: 'सिंक ऑपरेशन का समय समाप्त हो गया',
                onRetry: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Retrying data synchronization queue...', style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: AppColorsDark.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTierButton(DeviceTier tier, String label) {
    final activeDeviceTier = ref.watch(deviceTierProvider);
    final isSelected = activeDeviceTier == tier;
    
    return GestureDetector(
      onTap: () {
        ref.read(deviceTierProvider.notifier).setTier(tier);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? colors.primary.withOpacity(0.12) : colors.surface1,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected ? colors.primary : colors.glassBorder,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
          ),
        ),
      ),
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
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: colors.textSecondary,
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
              border: Border.all(color: colors.glassBorder),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  hexCode,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: colors.textSecondary,
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

// Private class to dynamically map colors based on brightness state
class _ThemeColors {
  _ThemeColors(this.isDark);

  final bool isDark;

  Color get bg0 => isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
  Color get bg1 => isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
  Color get bg2 => isDark ? AppColorsDark.bg2 : AppColorsLight.bg2;
  Color get surface0 => isDark ? AppColorsDark.surface0 : AppColorsLight.surface0;
  Color get surface1 => isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
  Color get surface2 => isDark ? AppColorsDark.surface2 : AppColorsLight.surface2;
  Color get glass => isDark ? AppColorsDark.glass : AppColorsLight.glass;
  Color get glassBorder => isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder;
  Color get primary => isDark ? AppColorsDark.primary : AppColorsLight.primary;
  Color get primaryGlow => isDark ? AppColorsDark.primaryGlow : AppColorsLight.primaryGlow;
  Color get primaryMuted => isDark ? AppColorsDark.primaryMuted : AppColorsLight.primaryMuted;
  Color get accent => isDark ? AppColorsDark.accent : AppColorsLight.accent;
  Color get accentGlow => isDark ? AppColorsDark.accentGlow : AppColorsLight.accentGlow;
  Color get secondary => isDark ? AppColorsDark.secondary : AppColorsLight.secondary;
  Color get secondaryGlow => isDark ? AppColorsDark.secondaryGlow : AppColorsLight.secondaryGlow;
  Color get teal => isDark ? AppColorsDark.teal : AppColorsLight.teal;
  Color get tealGlow => isDark ? AppColorsDark.tealGlow : AppColorsLight.tealGlow;
  Color get success => isDark ? AppColorsDark.success : AppColorsLight.success;
  Color get successGlow => isDark ? AppColorsDark.successGlow : AppColorsLight.successGlow;
  Color get warning => isDark ? AppColorsDark.warning : AppColorsLight.warning;
  Color get error => isDark ? AppColorsDark.error : AppColorsLight.error;
  Color get rose => isDark ? AppColorsDark.rose : AppColorsLight.rose;
  Color get purple => isDark ? AppColorsDark.purple : AppColorsLight.purple;
  Color get textPrimary => isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
  Color get textSecondary => isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
  Color get textMuted => isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted;
  Color get divider => isDark ? AppColorsDark.divider : AppColorsLight.divider;
}
