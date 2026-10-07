import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import '../../domain/models/health_models.dart';
import '../../domain/services/preventive_intelligence_engine.dart';
import '../../services/google_health_sync_service.dart';

class BloodPressureScreen extends ConsumerStatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  ConsumerState<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends ConsumerState<BloodPressureScreen> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _engine = const PreventiveIntelligenceEngine();
  bool _isSaving = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveMeasurement() async {
    final sys = int.tryParse(_systolicController.text);
    final dia = int.tryParse(_diastolicController.text);
    final pulse = int.tryParse(_pulseController.text);

    if (sys == null || dia == null || sys < 60 || sys > 260 || dia < 40 || dia > 160) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid Systolic (e.g. 120) and Diastolic (e.g. 80) values')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final userId = ref.read(activeUserIdProvider);
    final repo = ref.read(healthTrackingRepositoryProvider);
    final now = DateTime.now();

    await repo.recordBiomarkerReading(
      userId: userId,
      source: 'manual_entry',
      type: BiomarkerType.bloodPressure,
      primaryValue: sys.toDouble(),
      secondaryValue: dia.toDouble(),
      unit: 'mmHg',
      measuredAt: now,
    );

    if (pulse != null && pulse > 30 && pulse < 220) {
      await repo.recordWearableSample(
        userId: userId,
        source: 'manual_entry',
        metric: 'heart_rate',
        value: pulse.toDouble(),
        unit: 'bpm',
        timestamp: now,
      );
    }

    setState(() {
      _isSaving = false;
      _systolicController.clear();
      _diastolicController.clear();
      _pulseController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Blood Pressure $sys/$dia mmHg saved successfully!'),
          backgroundColor: AppColors.primaryEmerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bpAsync = ref.watch(latestBloodPressureStreamProvider);
    final hrAsync = ref.watch(latestHeartRateStreamProvider);
    final syncState = ref.watch(googleHealthSyncServiceProvider);
    final syncService = ref.read(googleHealthSyncServiceProvider.notifier);
    final userId = ref.watch(activeUserIdProvider);

    final recordedBp = bpAsync.value;
    final hasRecordedBp = recordedBp != null && recordedBp.primaryValue > 0;

    final sys = hasRecordedBp ? recordedBp.primaryValue.round() : 120;
    final dia = hasRecordedBp ? (recordedBp.secondaryValue ?? 80).round() : 80;
    final pulse = hrAsync.value?.value.round();

    final staging = _engine.classifyBloodPressure(
      systolicMmHg: sys,
      diastolicMmHg: dia,
    );

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
          english: 'Vascular & Blood Pressure',
          hindi: 'रक्तचाप व हृदय स्वास्थ्य',
          primaryStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Health Connect / Apple Health Sync Banner
            BentoCard(
              isGlowing: syncState.isAuthorized,
              glowColor: AppColors.primaryCyan,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.monitor_heart_rounded, color: AppColors.primaryCyan, size: 20),
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
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryCyan),
                        )
                      else if (!syncState.isAuthorized)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryCyan,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => syncService.requestAuthorization(),
                          child: const Text('Connect', style: TextStyle(fontSize: 12, color: AppColors.background)),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.sync_rounded, color: AppColors.primaryCyan, size: 20),
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

            // Classification Hero Card
            if (hasRecordedBp)
              BentoCard(
                isGlowing: true,
                glowColor: staging.color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$sys/$dia',
                              style: AppTypography.h1.copyWith(
                                color: staging.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('mmHg', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: staging.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: staging.color),
                          ),
                          child: Text(
                            staging.label,
                            style: AppTypography.label.copyWith(color: staging.color, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(staging.labelHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const Divider(color: AppColors.borderGlass, height: 24),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: AppColors.accentCoral, size: 18),
                        const SizedBox(width: 8),
                        Text('Pulse Pressure: ${staging.pulsePressure} mmHg', style: AppTypography.label),
                        if (pulse != null) ...[
                          const Spacer(),
                          const Icon(Icons.speed_rounded, color: AppColors.primaryCyan, size: 18),
                          const SizedBox(width: 6),
                          Text('$pulse BPM', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      staging.clinicalInsight,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms)
            else
              BentoCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.favorite_outline_rounded, color: AppColors.accentCoral, size: 48),
                    const SizedBox(height: 12),
                    Text('No Blood Pressure Readings Recorded Yet', textAlign: TextAlign.center, style: AppTypography.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Record your blood pressure measurement below or sync automatically from ${syncState.platformServiceName}.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Log New Reading Inputs
            Text('Record New Measurement', style: AppTypography.h3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _systolicController,
                    label: 'Systolic (Top)',
                    hint: 'e.g. 120',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _diastolicController,
                    label: 'Diastolic (Bottom)',
                    hint: 'e.g. 80',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _pulseController,
                    label: 'Pulse (BPM)',
                    hint: 'e.g. 72',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSaving ? null : _handleSaveMeasurement,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                      )
                    : const Text('Save BP Measurement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 24),

            // Indian Dietary / Lifestyle Guidelines
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primaryCyan, size: 20),
                      const SizedBox(width: 8),
                      Text('Cardiovascular Action Plan', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGuidelineBullet('Reduce pickle, papad, and packaged namkeen sodium content.'),
                  _buildGuidelineBullet('Hydrate with tender coconut water (natural potassium source).'),
                  _buildGuidelineBullet('Practice 10 mins Anulom Vilom Pranayama morning and night.'),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassHover,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: AppColors.textMuted)),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTypography.h3,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTypography.h3.copyWith(color: AppColors.textMuted.withValues(alpha: 0.5)),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryCyan, fontSize: 16)),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
