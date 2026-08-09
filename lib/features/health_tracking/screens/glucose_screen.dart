import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/glucose_engine.dart';
import '../providers/glucose_provider.dart';

/// §P4-E Glucose Screen
/// Route: /health/glucose | Biometric Lock Required
class GlucoseScreen extends ConsumerStatefulWidget {
  const GlucoseScreen({super.key});

  @override
  ConsumerState<GlucoseScreen> createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends ConsumerState<GlucoseScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(glucoseProvider.notifier).unlockScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(glucoseProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Blood Glucose', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: Icon(
              state.isLocked ? Icons.lock : Icons.lock_open,
              color: state.isLocked ? AppColors.error : AppColors.teal,
              size: 20,
            ),
            onPressed: () {
              if (state.isLocked) {
                ref.read(glucoseProvider.notifier).unlockScreen();
              } else {
                ref.read(glucoseProvider.notifier).lockScreen();
              }
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.isLocked ? const _GlucoseLockedView() : _GlucoseUnlockedView(state: state),
      ),
    );
  }
}

// ── Locked View ───────────────────────────────────────────────────────────────

class _GlucoseLockedView extends StatelessWidget {
  const _GlucoseLockedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, color: AppColors.primary, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text('Biometric Security Lock', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text('Authentication required to view sensitive glucose readings.', style: AppTypography.bodySm, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Unlocked Main Content View ────────────────────────────────────────────────

class _GlucoseUnlockedView extends ConsumerWidget {
  final GlucoseState state;

  const _GlucoseUnlockedView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Fasting vs Post-Meal Dual Metric Card ─────────────────────────
          _DualGlucoseHeaderCard(
            fasting: state.latestFasting,
            postMeal: state.latestPostMeal,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Spike Warning Nudge Card ───────────────────────────────────────
          if (state.spikeNudge != null) ...[
            _GlucoseSpikeCard(nudge: state.spikeNudge!),
            const SizedBox(height: AppSpacing.lg),
          ],

          // ── Glucose Response Curve Chart ──────────────────────────────────
          _GlucoseResponseCurveCard(records: state.records),
          const SizedBox(height: AppSpacing.lg),

          // ── Estimated HbA1c Card ──────────────────────────────────────────
          _Hba1cCard(hba1c: state.hba1c),
          const SizedBox(height: AppSpacing.lg),

          // ── Add Reading Button ───────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
              ),
              onPressed: () => _showAddGlucoseSheet(context, ref),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Log Glucose Reading', style: AppTypography.labelLg.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showAddGlucoseSheet(BuildContext context, WidgetRef ref) {
    final valueController = TextEditingController(text: '110');
    final mealController = TextEditingController(text: 'Breakfast');
    GlucoseContextTag selectedTag = GlucoseContextTag.postMeal1h;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log Glucose Reading', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Glucose (mg/dL)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<GlucoseContextTag>(
                    initialValue: selectedTag,
                    decoration: const InputDecoration(
                      labelText: 'Measurement Context',
                      border: OutlineInputBorder(),
                    ),
                    items: GlucoseContextTag.values.map((tag) {
                      return DropdownMenuItem(
                        value: tag,
                        child: Text(tag.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedTag = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: mealController,
                    decoration: const InputDecoration(
                      labelText: 'Correlated Meal (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        final mg = double.tryParse(valueController.text) ?? 110.0;
                        ref.read(glucoseProvider.notifier).logGlucoseReading(
                              mgDl: mg,
                              tag: selectedTag,
                              correlatedMealName: mealController.text.isNotEmpty ? mealController.text : null,
                            );
                        Navigator.pop(ctx);
                      },
                      child: Text('Save Log', style: AppTypography.labelLg.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Dual Glucose Header Card ─────────────────────────────────────────────────

class _DualGlucoseHeaderCard extends StatelessWidget {
  final GlucoseRecord? fasting;
  final GlucoseRecord? postMeal;

  const _DualGlucoseHeaderCard({required this.fasting, required this.postMeal});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _GlucoseMetricColumn(
              title: 'Fasting',
              record: fasting,
              color: AppColors.teal,
            ),
          ),
          Container(width: 1, height: 60, color: AppColors.glassBorder),
          Expanded(
            child: _GlucoseMetricColumn(
              title: 'Post-Meal',
              record: postMeal,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlucoseMetricColumn extends StatelessWidget {
  final String title;
  final GlucoseRecord? record;
  final Color color;

  const _GlucoseMetricColumn({
    required this.title,
    required this.record,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mg = record?.readingLabel ?? '-- mg/dL';
    final category = record?.category.label ?? 'Normal';

    return Column(
      children: [
        Text(title, style: AppTypography.bodySm),
        const SizedBox(height: 4),
        Text(mg, style: AppTypography.h2.copyWith(color: color)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(category, style: AppTypography.labelMd.copyWith(color: color, fontSize: 10)),
        ),
      ],
    );
  }
}

// ── Spike Warning Card ────────────────────────────────────────────────────────

class _GlucoseSpikeCard extends StatelessWidget {
  final String nudge;
  const _GlucoseSpikeCard({required this.nudge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bolt, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(nudge, style: AppTypography.bodyMd.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ── Response Curve Chart Card ─────────────────────────────────────────────────

class _GlucoseResponseCurveCard extends StatelessWidget {
  final List<GlucoseRecord> records;
  const _GlucoseResponseCurveCard({required this.records});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Glucose Response Curve', style: AppTypography.h3),
          const SizedBox(height: 4),
          Text('Response curve mapped to logged meals', style: AppTypography.bodySm),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _GlucoseCurvePainter(records: records),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlucoseCurvePainter extends CustomPainter {
  final List<GlucoseRecord> records;

  _GlucoseCurvePainter({required this.records});

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final sorted = List<GlucoseRecord>.from(records)
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    const minVal = 60.0;
    const maxVal = 200.0;
    const range = maxVal - minVal;

    final n = sorted.length;
    final step = n > 1 ? size.width / (n - 1) : size.width;

    Offset pt(int i) {
      final x = n > 1 ? i * step : size.width / 2;
      final norm = (sorted[i].mgDl - minVal) / range;
      final y = size.height - (norm * size.height);
      return Offset(x, y.clamp(0.0, size.height));
    }

    // Grid baseline (140 mg/dL threshold)
    final norm140 = (140.0 - minVal) / range;
    final y140 = size.height - (norm140 * size.height);
    final dashedPaint = Paint()
      ..color = AppColors.warning.withValues(alpha: 0.4)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, y140), Offset(size.width, y140), dashedPaint);

    final path = Path();
    path.moveTo(pt(0).dx, pt(0).dy);

    for (int i = 1; i < n; i++) {
      path.lineTo(pt(i).dx, pt(i).dy);
    }

    final linePaint = Paint()
      ..color = AppColors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < n; i++) {
      final record = sorted[i];
      final ptPos = pt(i);
      final isSpike = record.mgDl >= 140.0;
      final dotColor = isSpike ? AppColors.primary : AppColors.teal;
      canvas.drawCircle(ptPos, 4.0, Paint()..color = dotColor);
    }
  }

  @override
  bool shouldRepaint(covariant _GlucoseCurvePainter old) => old.records != records;
}

// ── Estimated HbA1c Card ──────────────────────────────────────────────────────

class _Hba1cCard extends StatelessWidget {
  final Hba1cEstimation hba1c;

  const _Hba1cCard({required this.hba1c});

  @override
  Widget build(BuildContext context) {
    final pct = (hba1c.estimatedHba1cPct / 10.0).clamp(0.0, 1.0);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated HbA1c', style: AppTypography.h3),
              Text(
                hba1c.isSufficientData ? '${hba1c.estimatedHba1cPct}%' : 'Pending Data',
                style: AppTypography.h2.copyWith(
                  color: hba1c.estimatedHba1cPct >= 5.7 ? AppColors.warning : AppColors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(hba1c.statusLabel, style: AppTypography.bodySm),
          const SizedBox(height: AppSpacing.md),

          // Progress gauge bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hba1c.isSufficientData ? pct : 0.2,
              minHeight: 8,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation(
                hba1c.estimatedHba1cPct >= 5.7 ? AppColors.warning : AppColors.teal,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Normal (<5.7%)', style: AppTypography.bodySm.copyWith(fontSize: 10)),
              Text('Pre-Diabetic (5.7%-6.4%)', style: AppTypography.bodySm.copyWith(fontSize: 10)),
              Text('Diabetic (>=6.5%)', style: AppTypography.bodySm.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
