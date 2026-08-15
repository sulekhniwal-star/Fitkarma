import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/hunger_craving_engine.dart';

/// §P5-L Adaptive Hunger & Cravings Screen
/// Route: /food/cravings
class AdaptiveHungerCravingsScreen extends StatefulWidget {
  const AdaptiveHungerCravingsScreen({super.key});

  @override
  State<AdaptiveHungerCravingsScreen> createState() =>
      _AdaptiveHungerCravingsScreenState();
}

class _AdaptiveHungerCravingsScreenState
    extends State<AdaptiveHungerCravingsScreen> {
  final _engine = const HungerCravingEngine();
  int _hungerScore = 3; // 1 = Stuffed, 5 = Starving
  CravingType _activeCraving = CravingType.sweet;
  double _stressLevel = 4.0; // 1.0 to 5.0

  late List<CravingLog> _history;
  HungerIntervention? _intervention;

  @override
  void initState() {
    super.initState();
    _initHistory();
    _evaluate();
  }

  void _initHistory() {
    final now = DateTime.now();
    _history = [
      CravingLog(
        timestamp: DateTime(
            now.year, now.month, now.day - 1, 21, 30), // 9:30 PM yesterday
        hungerScore: 4,
        cravingType: CravingType.sweet,
        isUltraProcessed: true,
        stressLevel: 4.2,
      ),
      CravingLog(
        timestamp: DateTime(now.year, now.month, now.day - 2, 21, 45),
        hungerScore: 5,
        cravingType: CravingType.salty,
        isUltraProcessed: true,
        stressLevel: 4.5,
      ),
    ];
  }

  void _evaluate() {
    final now = DateTime.now();
    final intervention = _engine.evaluateCravingRisk(
      logs: _history,
      currentTime:
          DateTime(now.year, now.month, now.day, 19, 0), // 7:00 PM simulate
      currentStressLevel: _stressLevel,
    );
    setState(() {
      _intervention = intervention;
    });
  }

  void _logCurrentCraving() {
    final newLog = CravingLog(
      timestamp: DateTime.now(),
      hungerScore: _hungerScore,
      cravingType: _activeCraving,
      isUltraProcessed: _activeCraving == CravingType.sweet ||
          _activeCraving == CravingType.salty,
      stressLevel: _stressLevel,
    );

    setState(() {
      _history.insert(0, newLog);
      _evaluate();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Craving logged successfully! Engine evaluated risk.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Hunger & Cravings Predictor', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Craving Log Prompt Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log Current Hunger & Stress', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),

                  // Hunger Score Slider (1 to 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hunger Score (1=Stuffed, 5=Starving)',
                          style: AppTypography.bodySm),
                      Text('$_hungerScore/5',
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: _hungerScore.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _hungerScore = val.round());
                      _evaluate();
                    },
                  ),

                  // Stress Level Slider (1.0 to 5.0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Work / Life Stress Level',
                          style: AppTypography.bodySm),
                      Text('${_stressLevel.toStringAsFixed(1)}/5.0',
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.accent)),
                    ],
                  ),
                  Slider(
                    value: _stressLevel,
                    min: 1.0,
                    max: 5.0,
                    divisions: 8,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      setState(() => _stressLevel = val);
                      _evaluate();
                    },
                  ),

                  // Active Craving Type Chips
                  Text('Active Craving Type:', style: AppTypography.bodySm),
                  const SizedBox(height: 6),
                  Row(
                    children: CravingType.values.map((type) {
                      final selected = _activeCraving == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(type.name.toUpperCase()),
                          selected: selected,
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.3),
                          onSelected: (_) {
                            setState(() => _activeCraving = type);
                            _evaluate();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: Text('Log Hunger & Craving Prompt',
                        style: AppTypography.labelLg
                            .copyWith(color: Colors.black)),
                    onPressed: _logCurrentCraving,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Proactive Intervention Nudge Banner
            if (_intervention != null && _intervention!.shouldTriggerNudge) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 6),
                        Text(_intervention!.nudgeTitle,
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.accent)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_intervention!.nudgeBody, style: AppTypography.bodyMd),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Recommended Pre-Emptive Snack:',
                        style: AppTypography.labelMd
                            .copyWith(color: AppColors.teal)),
                    Text(_intervention!.recommendedSnack,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.teal)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // History Log List
            Text('Recent Craving Logs:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final log in _history)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Craving: ${log.cravingType.name.toUpperCase()}',
                            style: AppTypography.labelLg),
                        Text(
                            'Hunger: ${log.hungerScore}/5 · Stress: ${log.stressLevel}',
                            style: AppTypography.bodySm),
                      ],
                    ),
                    Text(
                      '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
