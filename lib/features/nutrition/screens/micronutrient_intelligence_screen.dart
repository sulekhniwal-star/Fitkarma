import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/micronutrient_alert_engine.dart';

/// §P5-I Micronutrient Intelligence Core Screen
/// Route: /food/micronutrients
class MicronutrientIntelligenceScreen extends StatefulWidget {
  const MicronutrientIntelligenceScreen({super.key});

  @override
  State<MicronutrientIntelligenceScreen> createState() => _MicronutrientIntelligenceScreenState();
}

class _MicronutrientIntelligenceScreenState extends State<MicronutrientIntelligenceScreen> {
  final _engine = const MicronutrientAlertEngine();
  bool _isFemale = true;
  bool _isVegetarian = true;
  bool _hasPcosGoal = false;

  late UserMicroTargets _targets;
  List<MicroAlert> _alerts = [];

  @override
  void initState() {
    super.initState();
    _reevaluate();
  }

  void _reevaluate() {
    _targets = UserMicroTargets.derive(
      isFemale: _isFemale,
      isVegetarian: _isVegetarian,
      hasPcosOrFertilityGoal: _hasPcosGoal,
    );

    // Sample 3-day micronutrient log
    final sampleLogs = [
      DailyMicroLog(ironMg: 9.0, b12Mcg: 1.0, d3Iu: 200, calciumMg: 800, magnesiumMg: 280, zincMg: 6.0, folateMcg: 300, omega3G: 1.0),
      DailyMicroLog(ironMg: 10.0, b12Mcg: 1.2, d3Iu: 250, calciumMg: 850, magnesiumMg: 300, zincMg: 7.0, folateMcg: 350, omega3G: 1.2),
      DailyMicroLog(ironMg: 8.5, b12Mcg: 0.9, d3Iu: 180, calciumMg: 780, magnesiumMg: 260, zincMg: 5.5, folateMcg: 280, omega3G: 0.9),
    ];

    final alerts = _engine.evaluateLogs(
      logs: sampleLogs,
      targets: _targets,
      isVegetarian: _isVegetarian,
      isFemale: _isFemale,
    );

    setState(() {
      _alerts = alerts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Micronutrient Intelligence Core', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demographic Controls GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Demographic Profile Adjustments', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vegetarian Diet (1.8x Non-Heme Iron)', style: AppTypography.bodySm),
                      Switch(
                        value: _isVegetarian,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _isVegetarian = val);
                          _reevaluate();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Female Target Adjustments', style: AppTypography.bodySm),
                      Switch(
                        value: _isFemale,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _isFemale = val);
                          _reevaluate();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PCOS / Fertility Goals', style: AppTypography.bodySm),
                      Switch(
                        value: _hasPcosGoal,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _hasPcosGoal = val);
                          _reevaluate();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Auto-Alert Triggers Section
            if (_alerts.isNotEmpty) ...[
              Text('Auto-Alert Warnings:', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final alert in _alerts)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(alert.severity).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: _getSeverityColor(alert.severity).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        alert.severity == MicronutrientAlertSeverity.high
                            ? Icons.error_outline
                            : Icons.warning_amber_rounded,
                        color: _getSeverityColor(alert.severity),
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alert.title, style: AppTypography.labelLg.copyWith(color: _getSeverityColor(alert.severity))),
                            const SizedBox(height: 2),
                            Text(alert.message, style: AppTypography.bodySm),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Biomarkers Tracked Target Table per §P5-I Spec
            Text('Biomarkers Tracked & Targets:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _MicroTargetRow(name: 'Iron', value: '${_targets.targetIronMg.toStringAsFixed(1)} mg', note: 'Hemoglobin & Oxygen'),
            _MicroTargetRow(name: 'Vitamin B12', value: '${_targets.targetB12Mcg.toStringAsFixed(1)} mcg', note: 'Nerve tissue & DNA'),
            _MicroTargetRow(name: 'Vitamin D3', value: '${_targets.targetD3Iu.round()} IU', note: 'Immunity & Bone density'),
            _MicroTargetRow(name: 'Calcium', value: '${_targets.targetCalciumMg.round()} mg', note: 'Bone & Muscle firing'),
            _MicroTargetRow(name: 'Magnesium', value: '${_targets.targetMagnesiumMg.round()} mg', note: 'Insulin sensitivity & Stress'),
            _MicroTargetRow(name: 'Zinc', value: '${_targets.targetZincMg.round()} mg', note: 'Immunity & Testosterone'),
            _MicroTargetRow(name: 'Folate', value: '${_targets.targetFolateMcg.round()} mcg', note: 'Cellular division'),
            _MicroTargetRow(name: 'Omega-3', value: '${_targets.targetOmega3G.toStringAsFixed(1)} g', note: 'Anti-inflammatory recovery'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(MicronutrientAlertSeverity severity) {
    switch (severity) {
      case MicronutrientAlertSeverity.high:
        return AppColors.error;
      case MicronutrientAlertSeverity.medium:
        return AppColors.accent;
      case MicronutrientAlertSeverity.low:
        return AppColors.teal;
    }
  }
}

class _MicroTargetRow extends StatelessWidget {
  final String name;
  final String value;
  final String note;

  const _MicroTargetRow({required this.name, required this.value, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
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
              Text(name, style: AppTypography.labelLg),
              Text(note, style: AppTypography.bodySm.copyWith(fontSize: 11)),
            ],
          ),
          Text(value, style: AppTypography.h3.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
