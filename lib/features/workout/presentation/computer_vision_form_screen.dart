import 'dart:math';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/exercise_database.dart';
import '../domain/computer_vision_form_engine.dart';
import '../domain/workout_models.dart';

class ComputerVisionFormScreen extends StatefulWidget {
  final Exercise? initialExercise;

  const ComputerVisionFormScreen({
    super.key,
    this.initialExercise,
  });

  @override
  State<ComputerVisionFormScreen> createState() => _ComputerVisionFormScreenState();
}

class _ComputerVisionFormScreenState extends State<ComputerVisionFormScreen> with SingleTickerProviderStateMixin {
  late Exercise _selectedExercise;
  late AnimationController _pulseController;

  // Real-time dynamic simulation state
  double _primaryJointAngle = 170.0; // Knee or Elbow angle
  double _secondaryJointAngle = 165.0; // Hip or Shoulder angle
  final int _completedReps = 3;
  bool _isAutoSimulating = true;
  double _simTime = 0.0;
  bool _audioCuesEnabled = true;

  final List<FormRepSummary> _repHistory = [
    const FormRepSummary(
      repNumber: 1,
      eccentricSeconds: 2.1,
      concentricSeconds: 1.1,
      peakAngleDegrees: 84.5,
      qualityTier: FormFeedbackTier.optimal,
      primaryFeedback: 'Pristine depth & vertical chest control',
    ),
    const FormRepSummary(
      repNumber: 2,
      eccentricSeconds: 2.3,
      concentricSeconds: 1.3,
      peakAngleDegrees: 88.0,
      qualityTier: FormFeedbackTier.optimal,
      primaryFeedback: 'Controlled descent with explosive ascent',
    ),
    const FormRepSummary(
      repNumber: 3,
      eccentricSeconds: 1.8,
      concentricSeconds: 1.5,
      peakAngleDegrees: 96.5,
      qualityTier: FormFeedbackTier.warning,
      primaryFeedback: 'Slightly above parallel; maintain full hip crease depth',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.initialExercise ?? ExerciseDatabase.exercises.first;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _startSimulationLoop();
  }

  void _startSimulationLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 60));
      if (!mounted) return false;
      if (_isAutoSimulating) {
        setState(() {
          _simTime += 0.07;
          // Oscillate joint angles based on sine wave simulating a dynamic rep cycle
          final wave = sin(_simTime);
          if (_selectedExercise.name.toLowerCase().contains('bench') ||
              _selectedExercise.name.toLowerCase().contains('dand') ||
              _selectedExercise.name.toLowerCase().contains('pushup')) {
            _primaryJointAngle = 120.0 + 45.0 * wave; // 75 to 165 deg (Elbow)
            _secondaryJointAngle = 55.0 + 20.0 * sin(_simTime * 0.5); // Shoulder tuck angle
          } else {
            _primaryJointAngle = 125.0 + 50.0 * wave; // 75 to 175 deg (Knee)
            _secondaryJointAngle = 110.0 + 35.0 * wave; // Hip angle
          }
        });
      }
      return true;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frameAnalysis = ComputerVisionFormEngine.analyzeExerciseFrame(
      exercise: _selectedExercise,
      kneeAngle: _primaryJointAngle,
      hipAngle: _secondaryJointAngle,
      completedRepsCount: _completedReps,
      history: _repHistory,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Computer Vision Form HUD',
              style: AppTypography.titleLarge,
            ),
            Text(
              '100% On-Device Pose Kinematics • 60 FPS',
              style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _audioCuesEnabled ? 'Mute Biomechanical Voice' : 'Enable Biomechanical Voice',
            icon: Icon(
              _audioCuesEnabled ? Icons.volume_up : Icons.volume_off,
              color: _audioCuesEnabled ? AppColors.focusBlue : AppColors.textMuted,
            ),
            onPressed: () {
              setState(() {
                _audioCuesEnabled = !_audioCuesEnabled;
              });
            },
          ),
          IconButton(
            tooltip: _isAutoSimulating ? 'Pause Motion Simulator' : 'Play Motion Simulator',
            icon: Icon(
              _isAutoSimulating ? Icons.pause_circle_outline : Icons.play_circle_outline,
              color: AppColors.karmaGreen,
            ),
            onPressed: () {
              setState(() {
                _isAutoSimulating = !_isAutoSimulating;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseSelector(),
            const SizedBox(height: AppSpacing.md),
            _buildLiveSkeletonViewport(frameAnalysis),
            const SizedBox(height: AppSpacing.md),
            _buildRealtimePhasePill(frameAnalysis),
            const SizedBox(height: AppSpacing.md),
            _buildLiveFormFeedbackCard(frameAnalysis),
            const SizedBox(height: AppSpacing.md),
            _buildBiomechanicalMetricsGrid(frameAnalysis),
            const SizedBox(height: AppSpacing.md),
            if (!_isAutoSimulating) _buildManualAngleCalibrator(),
            const SizedBox(height: AppSpacing.md),
            _buildRepHistoryLedger(),
            const SizedBox(height: AppSpacing.md),
            _buildEdgePrivacyBanner(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Target Kinematic Model',
            regionalText: 'लक्ष्य बायोमैकेनिकल व्यायाम',
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ExerciseDatabase.exercises.take(6).map((ex) {
                final isSelected = ex.id == _selectedExercise.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      ex.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.surface : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.karmaGreen,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedExercise = ex;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveSkeletonViewport(VisionFormAnalysisFrame frame) {
    Color tierColor;
    switch (frame.feedbackTier) {
      case FormFeedbackTier.optimal:
        tierColor = AppColors.karmaGreen;
        break;
      case FormFeedbackTier.warning:
        tierColor = AppColors.energyOrange;
        break;
      case FormFeedbackTier.fault:
        tierColor = AppColors.alertRed;
        break;
    }

    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tierColor.withAlpha(120), width: 2),
        boxShadow: [
          BoxShadow(
            color: tierColor.withAlpha(40),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Grid background to simulate camera tracking canvas
            CustomPaint(
              size: const Size(double.infinity, 280),
              painter: _SkeletonCanvasPainter(
                primaryAngle: _primaryJointAngle,
                secondaryAngle: _secondaryJointAngle,
                accentColor: tierColor,
                isSquatMode: !_selectedExercise.name.toLowerCase().contains('bench') &&
                    !_selectedExercise.name.toLowerCase().contains('pushup') &&
                    !_selectedExercise.name.toLowerCase().contains('dand'),
              ),
            ),
            // Floating Camera Tracking Overlay Header
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.focusBlue.withAlpha(100)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'AI POSE TRACKER • 60 FPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating Angle Badge
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(200),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: tierColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.polyline, color: tierColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${_primaryJointAngle.toStringAsFixed(1)}° JOINT ANGLE',
                      style: TextStyle(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimePhasePill(VisionFormAnalysisFrame frame) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Rep Movement Phase',
                regionalText: 'व्यायाम गति चक्र',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Rep #${_completedReps + 1}',
                  style: const TextStyle(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: RepPhase.values.map((phase) {
              final isCurrent = phase == frame.currentPhase;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.focusBlue : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrent ? Border.all(color: Colors.white, width: 1.5) : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        phase.name.substring(0, min(3, phase.name.length)).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.black : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phase.regionalLabel.split(' ').first,
                        style: TextStyle(
                          fontSize: 8,
                          color: isCurrent ? Colors.black87 : AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveFormFeedbackCard(VisionFormAnalysisFrame frame) {
    Color bannerColor;
    IconData icon;
    switch (frame.feedbackTier) {
      case FormFeedbackTier.optimal:
        bannerColor = AppColors.karmaGreen;
        icon = Icons.check_circle_outline;
        break;
      case FormFeedbackTier.warning:
        bannerColor = AppColors.energyOrange;
        icon = Icons.warning_amber_rounded;
        break;
      case FormFeedbackTier.fault:
        bannerColor = AppColors.alertRed;
        icon = Icons.error_outline;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bannerColor.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bannerColor.withAlpha(150), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: bannerColor, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      frame.feedbackTier.label,
                      style: AppTypography.titleMedium.copyWith(
                        color: bannerColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      frame.feedbackTier.regionalLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: bannerColor.withAlpha(200),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  frame.liveCue,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  frame.regionalLiveCue,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomechanicalMetricsGrid(VisionFormAnalysisFrame frame) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Primary Joint',
              value: '${frame.primaryJointAngleDegrees.toStringAsFixed(1)}°',
              unit: frame.exercise.name.toLowerCase().contains('bench') ? 'Elbow' : 'Knee',
              accentColor: AppColors.focusBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Secondary Joint',
              value: '${frame.secondaryJointAngleDegrees.toStringAsFixed(1)}°',
              unit: frame.exercise.name.toLowerCase().contains('bench') ? 'Torso Tuck' : 'Hip Crease',
              accentColor: AppColors.focusBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Logged Reps',
              value: '${frame.completedReps}',
              unit: 'Target 8',
              accentColor: AppColors.karmaGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualAngleCalibrator() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Manual Kinematic Calibrator (Paused)',
            regionalText: 'मैनुअल कोण समायोजन',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Primary Angle: ${_primaryJointAngle.toStringAsFixed(1)}°',
            style: AppTypography.bodySmall,
          ),
          Slider(
            value: _primaryJointAngle,
            min: 60,
            max: 180,
            activeColor: AppColors.karmaGreen,
            inactiveColor: AppColors.surfaceElevated,
            onChanged: (val) {
              setState(() {
                _primaryJointAngle = val;
              });
            },
          ),
          Text(
            'Secondary Angle: ${_secondaryJointAngle.toStringAsFixed(1)}°',
            style: AppTypography.bodySmall,
          ),
          Slider(
            value: _secondaryJointAngle,
            min: 30,
            max: 180,
            activeColor: AppColors.focusBlue,
            inactiveColor: AppColors.surfaceElevated,
            onChanged: (val) {
              setState(() {
                _secondaryJointAngle = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRepHistoryLedger() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Rep Quality Ledger',
            regionalText: 'रेप गुणवत्ता रिकॉर्ड',
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._repHistory.map((rep) {
            Color qColor;
            switch (rep.qualityTier) {
              case FormFeedbackTier.optimal:
                qColor = AppColors.karmaGreen;
                break;
              case FormFeedbackTier.warning:
                qColor = AppColors.energyOrange;
                break;
              case FormFeedbackTier.fault:
                qColor = AppColors.alertRed;
                break;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: qColor.withAlpha(70)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: qColor.withAlpha(40),
                    child: Text(
                      '#${rep.repNumber}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: qColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rep.primaryFeedback,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Eccentric: ${rep.eccentricSeconds}s • Concentric: ${rep.concentricSeconds}s • Depth: ${rep.peakAngleDegrees}°',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: qColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      rep.qualityTier.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: qColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEdgePrivacyBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.focusBlue.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.focusBlue, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '100% Privacy Protected Edge Vision',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Video frames are processed in-memory directly on device and are never uploaded or saved to any cloud servers.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCanvasPainter extends CustomPainter {
  final double primaryAngle;
  final double secondaryAngle;
  final Color accentColor;
  final bool isSquatMode;

  _SkeletonCanvasPainter({
    required this.primaryAngle,
    required this.secondaryAngle,
    required this.accentColor,
    required this.isSquatMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withAlpha(12)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final bonePaint = Paint()
      ..color = accentColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final jointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final jointBorderPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cx = size.width * 0.5;

    if (isSquatMode) {
      final head = Offset(cx, 40);
      final neck = Offset(cx, 65);
      final spine = Offset(cx + (180 - secondaryAngle) * 0.25, 120);
      final hip = Offset(cx + (180 - secondaryAngle) * 0.3, 150);

      final kneeDisplacement = (180 - primaryAngle) * 0.5;
      final leftKnee = Offset(cx - 35 - kneeDisplacement * 0.2, 190 + kneeDisplacement * 0.3);
      final rightKnee = Offset(cx + 35 + kneeDisplacement * 0.2, 190 + kneeDisplacement * 0.3);

      final leftAnkle = Offset(cx - 35, 250);
      final rightAnkle = Offset(cx + 35, 250);

      canvas.drawLine(head, neck, bonePaint);
      canvas.drawLine(neck, spine, bonePaint);
      canvas.drawLine(spine, hip, bonePaint);
      canvas.drawLine(hip, leftKnee, bonePaint);
      canvas.drawLine(hip, rightKnee, bonePaint);
      canvas.drawLine(leftKnee, leftAnkle, bonePaint);
      canvas.drawLine(rightKnee, rightAnkle, bonePaint);

      final leftShoulder = Offset(cx - 30, 75);
      final rightShoulder = Offset(cx + 30, 75);
      final leftElbow = Offset(cx - 45, 110);
      final rightElbow = Offset(cx + 45, 110);
      canvas.drawLine(neck, leftShoulder, bonePaint);
      canvas.drawLine(neck, rightShoulder, bonePaint);
      canvas.drawLine(leftShoulder, leftElbow, bonePaint);
      canvas.drawLine(rightShoulder, rightElbow, bonePaint);

      final joints = [
        head, neck, spine, hip, leftShoulder, rightShoulder, leftElbow, rightElbow,
        leftKnee, rightKnee, leftAnkle, rightAnkle
      ];
      for (final j in joints) {
        canvas.drawCircle(j, 5, jointPaint);
        canvas.drawCircle(j, 5, jointBorderPaint);
      }
    } else {
      final head = Offset(cx - 80, 100);
      final shoulder = Offset(cx - 50, 115);
      final hip = Offset(cx + 40, 120);
      final feet = Offset(cx + 100, 125);

      final elbowDisplacement = (180 - primaryAngle) * 0.3;
      final elbow = Offset(cx - 50, 155 - elbowDisplacement);
      final wrist = Offset(cx - 50, 185);

      canvas.drawLine(head, shoulder, bonePaint);
      canvas.drawLine(shoulder, hip, bonePaint);
      canvas.drawLine(hip, feet, bonePaint);
      canvas.drawLine(shoulder, elbow, bonePaint);
      canvas.drawLine(elbow, wrist, bonePaint);

      final joints = [head, shoulder, hip, feet, elbow, wrist];
      for (final j in joints) {
        canvas.drawCircle(j, 5, jointPaint);
        canvas.drawCircle(j, 5, jointBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SkeletonCanvasPainter oldDelegate) {
    return oldDelegate.primaryAngle != primaryAngle ||
        oldDelegate.secondaryAngle != secondaryAngle ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isSquatMode != isSquatMode;
  }
}
