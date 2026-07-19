import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/daily_mission/recovery_log_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';

class RecoveryLogScreen extends ConsumerStatefulWidget {
  const RecoveryLogScreen({super.key});

  @override
  ConsumerState<RecoveryLogScreen> createState() => _RecoveryLogScreenState();
}

class _RecoveryLogScreenState extends ConsumerState<RecoveryLogScreen> {
  bool isFrontView = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recoveryLogProvider);
    final notifier = ref.read(recoveryLogProvider.notifier);
    final db = ref.watch(databaseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final primaryColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Recovery Log',
          style: AppTypography.h2.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Readiness Score Card ──
              BentoCard(
                child: Column(
                  children: [
                    Text(
                      'Computed Readiness Score',
                      style: AppTypography.labelLg.copyWith(color: textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${state.readinessScore}',
                          style: AppTypography.displayLg.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          state.readinessScore >= 80
                              ? '(Optimal Capacity)'
                              : (state.readinessScore >= 50 ? '(Moderate Capacity)' : '(Recovery Focus)'),
                          style: AppTypography.h3.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Simulated status bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: LinearProgressIndicator(
                        value: state.readinessScore / 100.0,
                        backgroundColor: (isDark ? AppColorsDark.surface0 : AppColorsLight.surface2),
                        color: primaryColor,
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sleep: ${state.sleepDurationMin ~/ 60}h ${state.sleepDurationMin % 60}m · HRV: ${state.hrv?.round() ?? "--"} ms · resting HR: ${state.restingHR?.round() ?? "--"} bpm',
                      style: AppTypography.bodySm.copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.bentoGap),

              // ── Metrics Sliders ──
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subjective Metrics', style: AppTypography.h3.copyWith(color: textPrimary)),
                    const SizedBox(height: 16),
                    
                    // Sleep Duration
                    _buildSlider(
                      title: 'Sleep Duration',
                      value: state.sleepDurationMin.toDouble(),
                      min: 180,
                      max: 720,
                      label: '${(state.sleepDurationMin / 60).toStringAsFixed(1)} hours',
                      onChanged: (val) {
                        notifier.setCheckInResponses(
                          sleepQuality: state.sleepQuality,
                          sleepDurationMin: val.round(),
                          stressLevel: state.stressLevel,
                          energyLevel: state.energyLevel,
                        );
                      },
                    ),

                    // Sleep Quality
                    _buildSlider(
                      title: 'Sleep Quality',
                      value: state.sleepQuality.toDouble(),
                      min: 1,
                      max: 5,
                      label: '${state.sleepQuality} / 5',
                      onChanged: (val) {
                        notifier.setCheckInResponses(
                          sleepQuality: val.round(),
                          sleepDurationMin: state.sleepDurationMin,
                          stressLevel: state.stressLevel,
                          energyLevel: state.energyLevel,
                        );
                      },
                    ),

                    // Energy Level
                    _buildSlider(
                      title: 'Energy Level',
                      value: state.energyLevel.toDouble(),
                      min: 1,
                      max: 5,
                      label: '${state.energyLevel} / 5',
                      onChanged: (val) {
                        notifier.setCheckInResponses(
                          sleepQuality: state.sleepQuality,
                          sleepDurationMin: state.sleepDurationMin,
                          stressLevel: state.stressLevel,
                          energyLevel: val.round(),
                        );
                      },
                    ),

                    // Stress Level
                    _buildSlider(
                      title: 'Stress Level',
                      value: state.stressLevel.toDouble(),
                      min: 1,
                      max: 5,
                      label: '${state.stressLevel} / 5',
                      onChanged: (val) {
                        notifier.setCheckInResponses(
                          sleepQuality: state.sleepQuality,
                          sleepDurationMin: state.sleepDurationMin,
                          stressLevel: val.round(),
                          energyLevel: state.energyLevel,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.bentoGap),

              // ── Biometrics Input Card (Optional resting HR / HRV) ──
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Passive Wearable Data', style: AppTypography.h3.copyWith(color: textPrimary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Resting HR (BPM)',
                              labelStyle: AppTypography.bodySm.copyWith(color: textSecondary),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: state.restingHR?.round().toString() ?? '',
                            onChanged: (val) {
                              final hr = double.tryParse(val);
                              notifier.updateBiometrics(
                                restingHR: hr,
                                hrv: state.hrv,
                                baselineHR: state.baselineHR ?? 65,
                                baselineHRV: state.baselineHRV ?? 55,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'HRV (ms)',
                              labelStyle: AppTypography.bodySm.copyWith(color: textSecondary),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: state.hrv?.round().toString() ?? '',
                            onChanged: (val) {
                              final hrv = double.tryParse(val);
                              notifier.updateBiometrics(
                                restingHR: state.restingHR,
                                hrv: hrv,
                                baselineHR: state.baselineHR ?? 65,
                                baselineHRV: state.baselineHRV ?? 55,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.bentoGap),

              // ── Soreness Map Container ──
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Body Soreness Map', style: AppTypography.h3.copyWith(color: textPrimary)),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Front'),
                              selected: isFrontView,
                              onSelected: (selected) {
                                if (selected) setState(() => isFrontView = true);
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Back'),
                              selected: !isFrontView,
                              onSelected: (selected) {
                                if (selected) setState(() => isFrontView = false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Interactive Painter
                        Container(
                          width: 180,
                          height: 280,
                          decoration: BoxDecoration(
                            color: isDark ? AppColorsDark.surface0 : AppColorsLight.surface2,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: textSecondary.withValues(alpha: 0.2)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final w = constraints.maxWidth;
                                final h = constraints.maxHeight;
                                return GestureDetector(
                                  key: const Key('body_soreness_map'),
                                  behavior: HitTestBehavior.opaque,
                                  onTapUp: (details) {
                                    final pos = details.localPosition;
                                    _handleMapTap(pos.dx, pos.dy, w, h);
                                  },
                                  child: CustomPaint(
                                    size: Size(w, h),
                                    painter: _BodyPainter(
                                      state: state,
                                      isFrontView: isFrontView,
                                      isDark: isDark,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // List of selected sore muscles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Muscles:',
                                style: AppTypography.labelMd.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...state.soreness.sorenessMap.entries
                                  .where((e) => e.value != SorenessSeverity.none)
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: _getSeverityColor(e.value),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${e.key.name.toUpperCase()}: ${e.value.name.toUpperCase()}',
                                              style: AppTypography.bodySm.copyWith(color: textPrimary),
                                            ),
                                          ],
                                        ),
                                      )),
                              if (state.soreness.sorenessMap.values.every((v) => v == SorenessSeverity.none))
                                Text('No soreness selected', style: AppTypography.bodySm.copyWith(color: textSecondary)),
                              const SizedBox(height: 16),
                              Text(
                                'Cumulative: ${_getCumulativeSorenessLabel(state.soreness.compositeSorenessValue)}',
                                style: AppTypography.labelMd.copyWith(color: textSecondary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Commit Log Button ──
              FitButton(
                child: const Text('Commit Recovery Log'),
                onPressed: () async {
                  await notifier.commitLog(db);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recovery Log saved successfully!')),
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final primaryColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.bodySm.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
              Text(label, style: AppTypography.bodySm.copyWith(color: textSecondary)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: primaryColor,
            inactiveColor: primaryColor.withValues(alpha: 0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _handleMapTap(double dx, double dy, double width, double height) {
    final notifier = ref.read(recoveryLogProvider.notifier);
    final state = ref.read(recoveryLogProvider);

    MuscleGroup? tappedGroup;

    if (isFrontView) {
      if (Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.1).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.shoulders;
      } else if (Rect.fromLTWH(width * 0.4, height * 0.25, width * 0.2, height * 0.12).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.chest;
      } else if (Rect.fromLTWH(width * 0.42, height * 0.37, width * 0.16, height * 0.15).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.abs;
      } else if (Rect.fromLTWH(width * 0.35, height * 0.55, width * 0.3, height * 0.25).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.quads;
      } else if (Rect.fromLTWH(width * 0.2, height * 0.25, width * 0.15, height * 0.3).contains(Offset(dx, dy)) ||
          Rect.fromLTWH(width * 0.65, height * 0.25, width * 0.15, height * 0.3).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.arms;
      }
    } else {
      if (Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.1).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.shoulders;
      } else if (Rect.fromLTWH(width * 0.4, height * 0.32, width * 0.2, height * 0.16).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.lowerBack;
      } else if (Rect.fromLTWH(width * 0.38, height * 0.48, width * 0.24, height * 0.12).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.glutes;
      } else if (Rect.fromLTWH(width * 0.35, height * 0.6, width * 0.3, height * 0.25).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.hamstrings;
      } else if (Rect.fromLTWH(width * 0.2, height * 0.25, width * 0.15, height * 0.3).contains(Offset(dx, dy)) ||
          Rect.fromLTWH(width * 0.65, height * 0.25, width * 0.15, height * 0.3).contains(Offset(dx, dy))) {
        tappedGroup = MuscleGroup.arms;
      }
    }

    if (tappedGroup != null) {
      final current = state.soreness.sorenessMap[tappedGroup] ?? SorenessSeverity.none;
      final next = SorenessSeverity.values[(current.index + 1) % SorenessSeverity.values.length];
      notifier.updateSoreness(tappedGroup, next);
    }
  }

  Color _getSeverityColor(SorenessSeverity severity) {
    return switch (severity) {
      SorenessSeverity.none => Colors.transparent,
      SorenessSeverity.mild => Colors.yellow,
      SorenessSeverity.moderate => Colors.orange,
      SorenessSeverity.severe => Colors.red,
    };
  }

  String _getCumulativeSorenessLabel(int val) {
    return switch (val) {
      1 => 'None',
      2 => 'Mild',
      3 => 'Medium',
      4 => 'High',
      _ => 'Extreme',
    };
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.state,
    required this.isFrontView,
    required this.isDark,
  });

  final RecoveryLogState state;
  final bool isFrontView;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final baseColor = isDark ? Colors.white24 : Colors.black26;

    final outlinePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw simple humanoid figure
    // Head
    canvas.drawCircle(Offset(w * 0.5, h * 0.08), w * 0.08, outlinePaint);
    // Neck
    canvas.drawLine(Offset(w * 0.5, h * 0.12), Offset(w * 0.5, h * 0.15), outlinePaint);
    // Torso outline
    final torsoPath = Path()
      ..moveTo(w * 0.35, h * 0.15)
      ..lineTo(w * 0.65, h * 0.15)
      ..lineTo(w * 0.6, h * 0.5)
      ..lineTo(w * 0.4, h * 0.5)
      ..close();
    canvas.drawPath(torsoPath, outlinePaint);

    // Left Arm
    canvas.drawLine(Offset(w * 0.35, h * 0.15), Offset(w * 0.25, h * 0.45), outlinePaint);
    // Right Arm
    canvas.drawLine(Offset(w * 0.65, h * 0.15), Offset(w * 0.75, h * 0.45), outlinePaint);

    // Left Leg
    canvas.drawLine(Offset(w * 0.42, h * 0.5), Offset(w * 0.38, h * 0.9), outlinePaint);
    // Right Leg
    canvas.drawLine(Offset(w * 0.58, h * 0.5), Offset(w * 0.62, h * 0.9), outlinePaint);

    // Color code sore regions
    if (isFrontView) {
      _paintRegion(canvas, MuscleGroup.shoulders, Rect.fromLTWH(w * 0.35, h * 0.15, w * 0.3, h * 0.1));
      _paintRegion(canvas, MuscleGroup.chest, Rect.fromLTWH(w * 0.4, h * 0.25, w * 0.2, h * 0.12));
      _paintRegion(canvas, MuscleGroup.abs, Rect.fromLTWH(w * 0.42, h * 0.37, w * 0.16, h * 0.15));
      _paintRegion(canvas, MuscleGroup.quads, Rect.fromLTWH(w * 0.35, h * 0.55, w * 0.3, h * 0.25));
      _paintRegion(canvas, MuscleGroup.arms, Rect.fromLTWH(w * 0.2, h * 0.25, w * 0.15, h * 0.3));
      _paintRegion(canvas, MuscleGroup.arms, Rect.fromLTWH(w * 0.65, h * 0.25, w * 0.15, h * 0.3));
    } else {
      _paintRegion(canvas, MuscleGroup.shoulders, Rect.fromLTWH(w * 0.35, h * 0.15, w * 0.3, h * 0.1));
      _paintRegion(canvas, MuscleGroup.lowerBack, Rect.fromLTWH(w * 0.4, h * 0.32, w * 0.2, h * 0.16));
      _paintRegion(canvas, MuscleGroup.glutes, Rect.fromLTWH(w * 0.38, h * 0.48, w * 0.24, h * 0.12));
      _paintRegion(canvas, MuscleGroup.hamstrings, Rect.fromLTWH(w * 0.35, h * 0.6, w * 0.3, h * 0.25));
      _paintRegion(canvas, MuscleGroup.arms, Rect.fromLTWH(w * 0.2, h * 0.25, w * 0.15, h * 0.3));
      _paintRegion(canvas, MuscleGroup.arms, Rect.fromLTWH(w * 0.65, h * 0.25, w * 0.15, h * 0.3));
    }
  }

  void _paintRegion(Canvas canvas, MuscleGroup muscle, Rect rect) {
    final severity = state.soreness.sorenessMap[muscle] ?? SorenessSeverity.none;
    if (severity == SorenessSeverity.none) return;

    final paint = Paint()
      ..color = _getPaintColor(severity)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
  }

  Color _getPaintColor(SorenessSeverity severity) {
    return switch (severity) {
      SorenessSeverity.none => Colors.transparent,
      SorenessSeverity.mild => Colors.yellow.withValues(alpha: 0.25),
      SorenessSeverity.moderate => Colors.orange.withValues(alpha: 0.45),
      SorenessSeverity.severe => Colors.red.withValues(alpha: 0.65),
    };
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.isFrontView != isFrontView || oldDelegate.isDark != isDark;
  }
}
