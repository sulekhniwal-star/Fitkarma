import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/activity_rings.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../domain/models/readiness_input.dart';
import '../../domain/models/readiness_result.dart';
import 'recovery_log_screen.dart';

class DailyBriefingScreen extends ConsumerStatefulWidget {
  const DailyBriefingScreen({super.key});

  @override
  ConsumerState<DailyBriefingScreen> createState() => _DailyBriefingScreenState();
}

class _DailyBriefingScreenState extends ConsumerState<DailyBriefingScreen> {
  late ReadinessResult _readiness;

  @override
  void initState() {
    super.initState();
    // Default initial synthesis
    const input = ReadinessInput(
      sleepDurationHours: 7.8,
      sleepTargetHours: 8.0,
      deepSleepMinutes: 85,
      remSleepMinutes: 95,
      hrvRmssdMs: 62.0,
      hrvBaselineMs: 58.0,
      restingHeartRateBpm: 51,
      restingHeartRateBaselineBpm: 53,
      perceivedEnergy: 4,
      perceivedStress: 2,
    );

    final engine = ref.read(readinessCalculationEngineProvider);
    _readiness = engine.computeReadiness(input: input, chronologicalAge: 27);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          english: 'Daily Mission & Readiness',
          hindi: 'दैनिक मिशन और फिटनेस तत्परता',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, color: AppColors.primaryCyan),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecoveryLogScreen(
                    onReadinessComputed: (res) {
                      setState(() => _readiness = res);
                      Navigator.of(context).pop();
                    },
                  ),
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
            // 1. Hero Readiness Score Bento Card
            BentoCard(
              isGlowing: true,
              glowColor: _readiness.stateColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BilingualLabel(
                            english: _readiness.stateTitle,
                            hindi: _readiness.stateTitleHindi,
                            primaryStyle: AppTypography.h2.copyWith(color: _readiness.stateColor),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _readiness.stateColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_readiness.confidenceTier.name.toUpperCase()} CONFIDENCE TIER',
                              style: AppTypography.label.copyWith(
                                color: _readiness.stateColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GlowingMetric(
                        value: '${_readiness.score}',
                        label: 'Readiness',
                        hindiLabel: 'तत्परता',
                        glowColor: _readiness.stateColor,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(_readiness.narrative, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(_readiness.narrativeHindi, style: AppTypography.bilingualSub),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Strain Capacity Budget & Recovery Age Split
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          english: 'Strain Capacity',
                          hindi: 'दैनिक सहनशक्ति सीमा',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${_readiness.strainCapacityBudget}',
                              style: AppTypography.h1.copyWith(color: AppColors.primaryCyan),
                            ),
                            Text(' / 21', style: AppTypography.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Target Day Strain balance', style: AppTypography.bilingualSub),
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
                          english: 'Recovery Age',
                          hindi: 'जैविक रिकवरी आयु',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${_readiness.recoveryAgeYears}',
                              style: AppTypography.h1.copyWith(color: AppColors.primaryEmerald),
                            ),
                            Text(' yrs', style: AppTypography.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Biological recovery rate', style: AppTypography.bilingualSub),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Sleep Architecture & Debt Card
            BentoCard(
              child: Row(
                children: [
                  ActivityRings(
                    size: 90,
                    rings: [
                      RingData(progress: _readiness.sleepEfficiencyScore / 100.0, color: AppColors.primaryCyan, strokeWidth: 7),
                      RingData(progress: (8.0 - _readiness.sleepDebtHours) / 8.0, color: AppColors.primaryEmerald, strokeWidth: 7),
                    ],
                    centerChild: Text(
                      '${_readiness.sleepEfficiencyScore.toInt()}%',
                      style: AppTypography.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          english: 'Sleep Intelligence Layer',
                          hindi: 'नींद एवं रिकवरी विश्लेषण',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _readiness.sleepDebtHours > 0
                              ? 'Sleep Debt: ${_readiness.sleepDebtHours}h accumulated.'
                              : 'Zero sleep debt. Optimal restorative sleep.',
                          style: AppTypography.bodySmall.copyWith(
                            color: _readiness.sleepDebtHours > 1 ? AppColors.accentAmber : AppColors.primaryEmerald,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Prescribed Recovery Protocols Bento
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualLabel(
                    english: 'Prescribed Recovery Protocols',
                    hindi: 'दैनिक रिकवरी प्रोटोकॉल',
                  ),
                  const SizedBox(height: 12),
                  ..._readiness.recoveryPrescriptions.map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('⚡ ', style: TextStyle(fontSize: 14)),
                          Expanded(child: Text(p, style: AppTypography.bodySmall)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
