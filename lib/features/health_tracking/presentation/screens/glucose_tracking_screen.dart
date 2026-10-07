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

class GlucoseTrackingScreen extends ConsumerStatefulWidget {
  const GlucoseTrackingScreen({super.key});

  @override
  ConsumerState<GlucoseTrackingScreen> createState() => _GlucoseTrackingScreenState();
}

class _GlucoseTrackingScreenState extends ConsumerState<GlucoseTrackingScreen> {
  final _glucoseController = TextEditingController();
  bool _isFasting = true;
  final _engine = const PreventiveIntelligenceEngine();
  bool _isSaving = false;

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveGlucose() async {
    final val = double.tryParse(_glucoseController.text);
    if (val == null || val < 40 || val > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid glucose reading (e.g. 95 mg/dL)')),
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
      type: _isFasting ? BiomarkerType.fastingGlucose : BiomarkerType.postMealGlucose,
      primaryValue: val,
      unit: 'mg/dL',
      measuredAt: now,
    );

    setState(() {
      _isSaving = false;
      _glucoseController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Glucose reading of ${val.toStringAsFixed(0)} mg/dL saved!'),
          backgroundColor: AppColors.primaryEmerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final glucoseAsync = ref.watch(latestGlucoseStreamProvider);
    final syncState = ref.watch(googleHealthSyncServiceProvider);
    final syncService = ref.read(googleHealthSyncServiceProvider.notifier);
    final userId = ref.watch(activeUserIdProvider);

    final recordedGlucose = glucoseAsync.value;
    final hasRecordedGlucose = recordedGlucose != null && recordedGlucose.primaryValue > 0;
    final glucoseVal = hasRecordedGlucose ? recordedGlucose.primaryValue : 100.0;

    final hba1cEstimate = _engine.estimateHbA1c(glucoseVal);
    final thinFatAssessment = _engine.evaluateThinFatPhenotype(
      bmi: 22.1,
      fastingGlucoseMgDl: hasRecordedGlucose ? glucoseVal : null,
      systolicBp: 120,
      restingHeartRate: 70,
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
          english: 'Metabolic & Glucose',
          hindi: 'ग्लूकोज व मेटाबॉलिक स्वास्थ्य',
          primaryStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Health Connect / Apple Health Integration Banner
            BentoCard(
              isGlowing: syncState.isAuthorized,
              glowColor: AppColors.primaryEmerald,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.water_drop_rounded, color: AppColors.primaryEmerald, size: 20),
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
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryEmerald),
                        )
                      else if (!syncState.isAuthorized)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryEmerald,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => syncService.requestAuthorization(),
                          child: const Text('Connect', style: TextStyle(fontSize: 12, color: AppColors.background)),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.sync_rounded, color: AppColors.primaryEmerald, size: 20),
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

            // ADAG HbA1c Estimation Bento Card
            if (hasRecordedGlucose)
              BentoCard(
                isGlowing: true,
                glowColor: hba1cEstimate.color,
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
                              '${hba1cEstimate.estimatedHbA1c}%',
                              style: AppTypography.h1.copyWith(
                                color: hba1cEstimate.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Estimated HbA1c (${glucoseVal.toStringAsFixed(0)} mg/dL)',
                                style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: hba1cEstimate.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: hba1cEstimate.color),
                          ),
                          child: Text(
                            hba1cEstimate.glycemicCategory,
                            style: AppTypography.label.copyWith(color: hba1cEstimate.color, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hba1cEstimate.insight,
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
                    const Icon(Icons.water_drop_outlined, color: AppColors.primaryEmerald, size: 48),
                    const SizedBox(height: 12),
                    Text('No Glucose Readings Recorded Yet', textAlign: TextAlign.center, style: AppTypography.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Record your blood glucose measurement below or sync automatically from ${syncState.platformServiceName}.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Thin-Fat Phenotype Risk Card
            if (hasRecordedGlucose && thinFatAssessment.isAtRisk)
              BentoCard(
                isGlowing: true,
                glowColor: AppColors.accentCoral,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.accentCoral, size: 22),
                        const SizedBox(width: 8),
                        Text('Thin-Fat Phenotype Detected',
                            style: AppTypography.h3.copyWith(color: AppColors.accentCoral)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      thinFatAssessment.summary,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      thinFatAssessment.summaryHindi,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Log New Blood Glucose
            Text('Record Glucose Reading', style: AppTypography.h3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassHover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Glucose (mg/dL)', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                        TextField(
                          controller: _glucoseController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTypography.h3,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 4),
                            border: InputBorder.none,
                            hintText: 'e.g. 95',
                            hintStyle: AppTypography.h3.copyWith(color: AppColors.textMuted.withValues(alpha: 0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Fasting'),
                          selected: _isFasting,
                          onSelected: (val) {
                            setState(() {
                              _isFasting = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Post-Meal'),
                          selected: !_isFasting,
                          onSelected: (val) {
                            setState(() {
                              _isFasting = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSaving ? null : _handleSaveGlucose,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                      )
                    : const Text('Save Glucose Reading', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 24),

            // Indian Low-GI Food Swaps
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, color: AppColors.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text('Glycemic Optimizations (Indian Diet)', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSwapItem('White Rice', 'Ragi / Foxtail Millet (Kangni)', 'Reduces insulin surge by 34%'),
                  _buildSwapItem('Maida Naan/Roti', 'Jowar & Bajra Multi-grain Roti', 'High soluble fiber blunts absorption'),
                  _buildSwapItem('Chai with Sugar', 'Spiced Kadha / Green Tea with Cinnamon', 'Natural insulin-sensitizing polyphenol'),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapItem(String from, String to, String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                from,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accentCoral,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.primaryEmerald, size: 14),
              Text(
                to,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryEmerald,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(benefit, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
