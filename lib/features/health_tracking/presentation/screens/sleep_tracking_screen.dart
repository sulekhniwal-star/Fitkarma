import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import '../../services/google_health_sync_service.dart';

class SleepTrackingScreen extends ConsumerStatefulWidget {
  const SleepTrackingScreen({super.key});

  @override
  ConsumerState<SleepTrackingScreen> createState() => _SleepTrackingScreenState();
}

class _SleepTrackingScreenState extends ConsumerState<SleepTrackingScreen> {
  final _sleepDurationController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _sleepDurationController.dispose();
    super.dispose();
  }

  Future<void> _handleManualSleepSave() async {
    final hours = double.tryParse(_sleepDurationController.text);
    if (hours == null || hours <= 0 || hours > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid sleep duration (e.g. 7.5 hours)')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final userId = ref.read(activeUserIdProvider);
    final repo = ref.read(healthTrackingRepositoryProvider);

    await repo.recordWearableSample(
      userId: userId,
      source: 'manual_entry',
      metric: 'sleep',
      value: hours,
      unit: 'hours',
      timestamp: DateTime.now(),
    );

    setState(() {
      _isSaving = false;
      _sleepDurationController.clear();
    });

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sleep of ${hours.toStringAsFixed(1)}h recorded successfully!'),
          backgroundColor: AppColors.primaryEmerald,
        ),
      );
    }
  }

  void _showLogSleepDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Log Sleep Duration', style: AppTypography.h3),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Enter total hours slept last night:',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sleepDurationController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: AppTypography.h2.copyWith(color: AppColors.accentPurple),
                decoration: InputDecoration(
                  hintText: 'e.g. 7.5',
                  hintStyle: AppTypography.h2.copyWith(color: AppColors.textMuted),
                  suffixText: 'hours',
                  suffixStyle: AppTypography.bodyMedium.copyWith(color: AppColors.accentPurple),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderGlass),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSaving ? null : _handleManualSleepSave,
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save Sleep Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sleepAsync = ref.watch(latestSleepStreamProvider);
    final syncState = ref.watch(googleHealthSyncServiceProvider);
    final syncService = ref.read(googleHealthSyncServiceProvider.notifier);
    final userId = ref.watch(activeUserIdProvider);

    final recordedSleep = sleepAsync.value;
    final hasRecordedSleep = recordedSleep != null && recordedSleep.value > 0;
    final totalHours = hasRecordedSleep ? recordedSleep.value : 0.0;

    // Derived architecture stages
    final deepHours = (totalHours * 0.23).clamp(0.0, 12.0);
    final remHours = (totalHours * 0.25).clamp(0.0, 12.0);
    final lightHours = (totalHours * 0.45).clamp(0.0, 12.0);
    final awakeHours = (totalHours * 0.07).clamp(0.0, 12.0);
    final efficiency = totalHours >= 7.0 ? 88 : (totalHours >= 5.5 ? 75 : 60);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const BilingualLabel(
          english: 'Sleep Architecture',
          hindi: 'निद्रा चक्र व विश्राम',
          primaryStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm_rounded, color: AppColors.accentPurple),
            tooltip: 'Log Sleep',
            onPressed: _showLogSleepDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Health Connect / Apple Health Integration Banner
            BentoCard(
              isGlowing: syncState.isAuthorized,
              glowColor: AppColors.accentPurple,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.nightlight_round, color: AppColors.accentPurple, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              syncState.platformServiceName,
                              style: AppTypography.h3.copyWith(fontSize: 15),
                            ),
                            Text(
                              syncState.isAuthorized
                                  ? 'Connected • Live Sync Active'
                                  : 'Not Connected • Tap to authorize',
                              style: AppTypography.bilingualSub.copyWith(
                                color: syncState.isAuthorized ? AppColors.primaryEmerald : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (syncState.connectionState == GoogleHealthConnectionState.syncing)
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentPurple),
                        )
                      else if (!syncState.isAuthorized)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => syncService.requestAuthorization(),
                          child: const Text('Connect', style: TextStyle(fontSize: 12, color: Colors.white)),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.sync_rounded, color: AppColors.accentPurple, size: 20),
                          tooltip: 'Sync Now',
                          onPressed: () => syncService.syncData(userId: userId),
                        ),
                    ],
                  ),
                  if (syncState.lastSyncTime != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last synced: ${DateFormat('hh:mm a, d MMM').format(syncState.lastSyncTime!)}',
                      style: AppTypography.bilingualSub.copyWith(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Main Sleep Duration Bento Card
            if (hasRecordedSleep)
              BentoCard(
                isGlowing: true,
                glowColor: AppColors.accentPurple,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlowingMetric(
                          value: '${totalHours.toStringAsFixed(1)}h',
                          label: 'Total Asleep Time',
                          unit: totalHours >= 7.0 ? 'Optimal' : (totalHours >= 6.0 ? 'Fair' : 'Short'),
                          glowColor: AppColors.accentPurple,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accentPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'Efficiency $efficiency%',
                            style: AppTypography.label.copyWith(color: AppColors.accentPurple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Visual Stage Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 14,
                        child: Row(
                          children: [
                            Expanded(
                              flex: (deepHours * 10).round().clamp(1, 100),
                              child: Container(color: AppColors.accentPurple),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: (remHours * 10).round().clamp(1, 100),
                              child: Container(color: AppColors.primaryCyan),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: (lightHours * 10).round().clamp(1, 100),
                              child: Container(color: AppColors.primaryEmerald.withValues(alpha: 0.7)),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: (awakeHours * 10).round().clamp(1, 100),
                              child: Container(color: AppColors.accentCoral.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStageLegend('Deep', '${deepHours.toStringAsFixed(1)}h', AppColors.accentPurple),
                        _buildStageLegend('REM', '${remHours.toStringAsFixed(1)}h', AppColors.primaryCyan),
                        _buildStageLegend('Light', '${lightHours.toStringAsFixed(1)}h', AppColors.primaryEmerald),
                        _buildStageLegend('Awake', '${awakeHours.toStringAsFixed(1)}h', AppColors.accentCoral),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0)
            else
              BentoCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.bedtime_outlined, color: AppColors.accentPurple, size: 48),
                    const SizedBox(height: 12),
                    Text('No Sleep Data Recorded Yet', style: AppTypography.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Sync automatically with ${syncState.platformServiceName} or tap below to record your sleep manually.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceGlassHover,
                        foregroundColor: AppColors.accentPurple,
                        side: const BorderSide(color: AppColors.accentPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Log Last Night\'s Sleep'),
                      onPressed: _showLogSleepDialog,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Circadian & Ayurvedic Sleep Hygiene
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.nightlight_round, color: AppColors.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text('Ayurvedic Circadian Alignment', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kapha Time (6:00 PM – 10:00 PM) is naturally heavy and conducive to deep restorative slow-wave sleep. Sleeping before 10:30 PM optimizes physical tissue repair and growth hormone secretion.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStageLegend(String name, String duration, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(name, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 2),
        Text(duration, style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}
