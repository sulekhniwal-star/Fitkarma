import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';
import '../models/soreness_models.dart';

/// Body Soreness Map Widget (§P2-C spec)
/// Interactive body coordinate vector mapping allowing tap-to-select soreness rating.
class BodySorenessMapWidget extends StatefulWidget {
  final SorenessState sorenessState;
  final Function(MuscleGroup muscle) onToggleMuscle;

  const BodySorenessMapWidget({
    super.key,
    required this.sorenessState,
    required this.onToggleMuscle,
  });

  @override
  State<BodySorenessMapWidget> createState() => _BodySorenessMapWidgetState();
}

class _BodySorenessMapWidgetState extends State<BodySorenessMapWidget> {
  bool _isFrontView = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Front / Back View Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isFrontView ? 'Anterior (Front View)' : 'Posterior (Back View)',
              style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary),
            ),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Front'),
                  selected: _isFrontView,
                  onSelected: (selected) {
                    if (selected) setState(() => _isFrontView = true);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.3),
                  labelStyle: AppTypography.labelMd.copyWith(
                    color: _isFrontView ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Back'),
                  selected: !_isFrontView,
                  onSelected: (selected) {
                    if (selected) setState(() => _isFrontView = false);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.3),
                  labelStyle: AppTypography.labelMd.copyWith(
                    color: !_isFrontView ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Body Interactive Canvas Container
            Expanded(
              flex: 5,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapUp: (details) => _handleTap(details.localPosition, constraints.biggest),
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _BodyMapPainter(
                          isFrontView: _isFrontView,
                          sorenessMap: widget.sorenessState.sorenessMap,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Sidebar: Selected Muscles & Severity
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected Soreness:', style: AppTypography.h3),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildSelectedMusclesList(),
                    ),
                    const Divider(color: AppColors.glassBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cumulative:', style: AppTypography.labelMd),
                        Text(
                          _getCumulativeLabel(widget.sorenessState.compositeSorenessValue),
                          style: AppTypography.h3.copyWith(
                            color: _getCumulativeColor(widget.sorenessState.compositeSorenessValue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleTap(Offset pos, Size size) {
    final width = size.width;
    final height = size.height;

    if (_isFrontView) {
      if (Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.1).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.shoulders);
      } else if (Rect.fromLTWH(width * 0.38, height * 0.25, width * 0.24, height * 0.12).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.chest);
      } else if (Rect.fromLTWH(width * 0.4, height * 0.38, width * 0.2, height * 0.15).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.abs);
      } else if (Rect.fromLTWH(width * 0.32, height * 0.55, width * 0.36, height * 0.25).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.quads);
      } else if (Rect.fromLTWH(width * 0.2, height * 0.24, width * 0.16, height * 0.3).contains(pos) ||
          Rect.fromLTWH(width * 0.64, height * 0.24, width * 0.16, height * 0.3).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.arms);
      }
    } else {
      if (Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.1).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.shoulders);
      } else if (Rect.fromLTWH(width * 0.36, height * 0.35, width * 0.28, height * 0.15).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.lowerBack);
      } else if (Rect.fromLTWH(width * 0.34, height * 0.51, width * 0.32, height * 0.14).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.glutes);
      } else if (Rect.fromLTWH(width * 0.32, height * 0.66, width * 0.36, height * 0.24).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.hamstrings);
      } else if (Rect.fromLTWH(width * 0.2, height * 0.24, width * 0.16, height * 0.3).contains(pos) ||
          Rect.fromLTWH(width * 0.64, height * 0.24, width * 0.16, height * 0.3).contains(pos)) {
        widget.onToggleMuscle(MuscleGroup.arms);
      }
    }
  }

  Widget _buildSelectedMusclesList() {
    final activeEntries = widget.sorenessState.sorenessMap.entries
        .where((e) => e.value != SorenessSeverity.none)
        .toList();

    if (activeEntries.isEmpty) {
      return const Center(
        child: Text(
          'Tap muscle regions on body map to log soreness',
          textAlign: TextAlign.center,
          style: AppTypography.labelMd,
        ),
      );
    }

    return ListView.builder(
      itemCount: activeEntries.length,
      itemBuilder: (context, index) {
        final entry = activeEntries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key.displayName, style: AppTypography.bodySm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getSeverityColor(entry.value).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _getSeverityColor(entry.value)),
                ),
                child: Text(
                  entry.value.displayName,
                  style: AppTypography.labelMd.copyWith(color: _getSeverityColor(entry.value)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getSeverityColor(SorenessSeverity severity) {
    switch (severity) {
      case SorenessSeverity.none:
        return AppColors.textMuted;
      case SorenessSeverity.mild:
        return AppColors.warning;
      case SorenessSeverity.moderate:
        return AppColors.primary;
      case SorenessSeverity.severe:
        return AppColors.error;
    }
  }

  String _getCumulativeLabel(int val) {
    if (val <= 1) return 'Fresh (Low)';
    if (val <= 2) return 'Mild';
    if (val <= 3) return 'Medium';
    if (val <= 4) return 'High';
    return 'Severe';
  }

  Color _getCumulativeColor(int val) {
    if (val <= 1) return AppColors.success;
    if (val <= 2) return AppColors.accent;
    if (val <= 3) return AppColors.warning;
    return AppColors.error;
  }
}

class _BodyMapPainter extends CustomPainter {
  final bool isFrontView;
  final Map<MuscleGroup, SorenessSeverity> sorenessMap;

  _BodyMapPainter({
    required this.isFrontView,
    required this.sorenessMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final outlinePaint = Paint()
      ..color = AppColors.surface2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final headCenter = Offset(width * 0.5, height * 0.08);
    canvas.drawCircle(headCenter, width * 0.08, outlinePaint);

    if (isFrontView) {
      _drawRegion(canvas, Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.09), MuscleGroup.shoulders, 'Shoulders');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.38, height * 0.25, width * 0.24, height * 0.12), MuscleGroup.chest, 'Chest');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.4, height * 0.38, width * 0.2, height * 0.15), MuscleGroup.abs, 'Abs');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.32, height * 0.55, width * 0.36, height * 0.25), MuscleGroup.quads, 'Quads');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.2, height * 0.24, width * 0.16, height * 0.3), MuscleGroup.arms, 'L.Arm');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.64, height * 0.24, width * 0.16, height * 0.3), MuscleGroup.arms, 'R.Arm');
    } else {
      _drawRegion(canvas, Rect.fromLTWH(width * 0.35, height * 0.15, width * 0.3, height * 0.09), MuscleGroup.shoulders, 'Traps/Sh');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.36, height * 0.35, width * 0.28, height * 0.15), MuscleGroup.lowerBack, 'Lower Back');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.34, height * 0.51, width * 0.32, height * 0.14), MuscleGroup.glutes, 'Glutes');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.32, height * 0.66, width * 0.36, height * 0.24), MuscleGroup.hamstrings, 'Hamstrings');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.2, height * 0.24, width * 0.16, height * 0.3), MuscleGroup.arms, 'L.Arm');
      _drawRegion(canvas, Rect.fromLTWH(width * 0.64, height * 0.24, width * 0.16, height * 0.3), MuscleGroup.arms, 'R.Arm');
    }
  }

  void _drawRegion(Canvas canvas, Rect rect, MuscleGroup muscle, String label) {
    final severity = sorenessMap[muscle] ?? SorenessSeverity.none;

    final fillPaint = Paint()
      ..color = _getFillColor(severity)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _getBorderColor(severity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);
  }

  Color _getFillColor(SorenessSeverity severity) {
    switch (severity) {
      case SorenessSeverity.none:
        return AppColors.surface1.withOpacity(0.6);
      case SorenessSeverity.mild:
        return AppColors.warning.withOpacity(0.35);
      case SorenessSeverity.moderate:
        return AppColors.primary.withOpacity(0.45);
      case SorenessSeverity.severe:
        return AppColors.error.withOpacity(0.65);
    }
  }

  Color _getBorderColor(SorenessSeverity severity) {
    switch (severity) {
      case SorenessSeverity.none:
        return AppColors.glassBorder;
      case SorenessSeverity.mild:
        return AppColors.warning;
      case SorenessSeverity.moderate:
        return AppColors.primary;
      case SorenessSeverity.severe:
        return AppColors.error;
    }
  }

  @override
  bool shouldRepaint(covariant _BodyMapPainter oldDelegate) => true;
}
