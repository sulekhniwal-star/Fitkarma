import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/periodization_controller.dart';

/// §P5-G Nutrition Periodization Engine Control Screen
/// Route: /food/periodization
class NutritionPeriodizationScreen extends StatefulWidget {
  const NutritionPeriodizationScreen({super.key});

  @override
  State<NutritionPeriodizationScreen> createState() => _NutritionPeriodizationScreenState();
}

class _NutritionPeriodizationScreenState extends State<NutritionPeriodizationScreen> {
  final _controller = const PeriodizationController();
  PeriodizationPhase _currentPhase = PeriodizationPhase.fatLoss;
  DateTime _phaseStartAt = DateTime.now().subtract(const Duration(days: 60)); // 8.5 weeks in fat loss
  late List<WeightLog> _weightLogs;
  PeriodizationStatus? _status;

  @override
  void initState() {
    super.initState();
    _initSampleData();
    _checkProgression();
  }

  void _initSampleData() {
    final now = DateTime.now();
    _weightLogs = [
      WeightLog(loggedAt: now, weightKg: 78.0),
      WeightLog(loggedAt: now.subtract(const Duration(days: 7)), weightKg: 78.1),
      WeightLog(loggedAt: now.subtract(const Duration(days: 14)), weightKg: 78.0),
      WeightLog(loggedAt: now.subtract(const Duration(days: 21)), weightKg: 78.0),
    ];
  }

  void _checkProgression() {
    final status = _controller.checkPhaseProgression(
      currentPhase: _currentPhase,
      phaseStartAt: _phaseStartAt,
      weightHistory: _weightLogs,
    );
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInPhase = DateTime.now().difference(_phaseStartAt).inDays;
    final weeksInPhase = (daysInPhase / 7.0).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Nutrition Periodization', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Active Phase GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Phase', style: AppTypography.bodySm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$weeksInPhase weeks active',
                          style: AppTypography.labelMd.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_currentPhase.displayName, style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Calorie Target: ${(_currentPhase.calorieModifier * 100).round()}% TDEE · Protein: ${_currentPhase.proteinTargetGPerKg}g/kg',
                    style: AppTypography.bodySm.copyWith(color: AppColors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Auto-Progression Action Needed Card
            if (_status != null && _status!.actionRequired) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.accent, size: 20),
                        const SizedBox(width: 6),
                        Text('Periodization Transition Prompt', style: AppTypography.labelLg.copyWith(color: AppColors.accent)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_status!.reason, style: AppTypography.bodyMd),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPhase = _status!.nextPhase;
                          _phaseStartAt = DateTime.now();
                          _checkProgression();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Switched phase to ${_currentPhase.displayName}')),
                        );
                      },
                      child: Text('Switch to ${_status!.nextPhase.displayName}', style: AppTypography.labelMd.copyWith(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Periodization Cycle Roadmap (5 Phases)
            Text('Periodization Phase Cycle:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final phase in PeriodizationPhase.values)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: phase == _currentPhase ? AppColors.surface1 : AppColors.surface0,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: phase == _currentPhase ? AppColors.primary : AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          phase == _currentPhase ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: phase == _currentPhase ? AppColors.primary : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(phase.displayName, style: AppTypography.labelLg),
                      ],
                    ),
                    Text(
                      '${(phase.calorieModifier * 100).round()}% TDEE',
                      style: AppTypography.bodySm.copyWith(color: AppColors.teal),
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
