/// §P6-F Real-Time Form Feedback UI Overlay
///
/// Full-screen overlay widget rendering:
/// 1. Thermal Optimization Badge (§P6-F UX Transparency Safeguard)
/// 2. Color-coded Form Cue Banner (Green ≥80, Amber 60–79, Red <60)
/// 3. Skeleton Canvas Painter rendering normalized PoseKeypoint landmarks.
library;

import 'package:fitkarma/features/workout/form_deviation_detector.dart';
import 'package:fitkarma/features/workout/pose_landmark_adapter.dart';
import 'package:fitkarma/features/workout/thermal_frame_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormFeedbackOverlay extends ConsumerWidget {
  const FormFeedbackOverlay({
    required this.formScore,
    required this.skeleton,
    super.key,
  });

  final FormQualityScore formScore;
  final List<PoseKeypoint> skeleton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thermalState = ref.watch(thermalProcessorProvider);
    final badgeText = thermalState.optimizationBadge;

    return Stack(
      children: [
        // 1. Skeleton Canvas Layer
        if (skeleton.isNotEmpty)
          Positioned.fill(
            child: CustomPaint(
              painter: _SkeletonPainter(skeleton: skeleton),
            ),
          ),

        // 2. Thermal Optimization Transparency Badge
        if (badgeText != null)
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade400, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // 3. Color-Coded Form Cue Card
        Positioned(
          bottom: 32,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getCardColor(formScore.overallScore).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        '${formScore.overallScore}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formScore.feedback,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tracked Joints: ${formScore.trackedJointCount} | FPS Target: ${thermalState.targetFps}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getCardColor(int score) {
    if (score >= 80) return const Color(0xFF1E88E5); // Blue/Green good
    if (score >= 60) return const Color(0xFFFB8C00); // Amber warning
    return const Color(0xFFE53935); // Red poor
  }
}

class _SkeletonPainter extends CustomPainter {
  _SkeletonPainter({required this.skeleton});

  final List<PoseKeypoint> skeleton;

  @override
  void paint(Canvas canvas, Size size) {
    final jointPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.6)
      ..strokeWidth = 3.0;

    // Draw tracked joint points
    for (final kp in skeleton) {
      if (kp.isTracked && !kp.isEmpty) {
        final dx = kp.x * size.width;
        final dy = kp.y * size.height;
        canvas.drawCircle(Offset(dx, dy), 5.0, jointPaint);
      }
    }

    // Key connections (Hips -> Knees -> Ankles)
    _drawLine(canvas, size, linePaint, 23, 25);
    _drawLine(canvas, size, linePaint, 24, 26);
    _drawLine(canvas, size, linePaint, 25, 27);
    _drawLine(canvas, size, linePaint, 26, 28);
  }

  void _drawLine(Canvas canvas, Size size, Paint paint, int indexA, int indexB) {
    if (indexA < skeleton.length && indexB < skeleton.length) {
      final kpA = skeleton[indexA];
      final kpB = skeleton[indexB];
      if (kpA.isTracked && kpB.isTracked && !kpA.isEmpty && !kpB.isEmpty) {
        canvas.drawLine(
          Offset(kpA.x * size.width, kpA.y * size.height),
          Offset(kpB.x * size.width, kpB.y * size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SkeletonPainter oldDelegate) => true;
}
