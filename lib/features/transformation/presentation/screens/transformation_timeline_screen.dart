import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../data/transformation_repository.dart';
import '../../domain/models/transformation_models.dart';

class TransformationTimelineScreen extends ConsumerStatefulWidget {
  final String userId;
  final int consistentWeeks;
  final int streakDays;
  final TransformationRepository? repository;

  const TransformationTimelineScreen({
    super.key,
    this.userId = 'demo-user-001',
    this.consistentWeeks = 6,
    this.streakDays = 35,
    this.repository,
  });

  @override
  ConsumerState<TransformationTimelineScreen> createState() =>
      _TransformationTimelineScreenState();
}

class _TransformationTimelineScreenState
    extends ConsumerState<TransformationTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Text(
          'Transformation Journey',
          style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryCyan),
            tooltip: 'Log Transformation Check-in',
            onPressed: () => _showLogCheckInSheet(context),
          ),
        ],
      ),
      body: FutureBuilder<TransformationProgressSummary>(
        future: widget.repository?.evaluateTransformation(
              userId: widget.userId,
              consistentWeeks: widget.consistentWeeks,
              streakDays: widget.streakDays,
            ) ??
            Future.value(
              TransformationProgressSummary(
                initialWeightKg: 85.0,
                currentWeightKg: 78.5,
                totalWeightLossKg: 6.5,
                initialWaistCm: 94.0,
                currentWaistCm: 87.0,
                waistLossCm: 7.0,
                initialWaistToHipRatio: 0.95,
                currentWaistToHipRatio: 0.89,
                weeklyLossRateKg: 0.72,
                identityStage: HabitIdentityStage.healthAthlete,
                stageTitle: 'Health Athlete (अनुशासित एथलीट)',
                stageTitleHindi: 'दैनिक अनुशासन व शक्ति संपन्न',
                unlockedMilestones: [
                  TransformationMilestone(
                    id: 'm1',
                    userId: 'demo-user-001',
                    type: MilestoneType.baselineSet,
                    title: 'Transformation Baseline Established',
                    titleHindi: 'आरंभिक आधारभूत माप दर्ज',
                    description: 'First body composition and measurement snapshot captured.',
                    achievedAt: DateTime(2026, 1, 1),
                  ),
                  TransformationMilestone(
                    id: 'm2',
                    userId: 'demo-user-001',
                    type: MilestoneType.first5kgLost,
                    title: '5 Kilogram Transformation Milestone',
                    titleHindi: '५ किलोग्राम वजन में कमी का मील का पत्थर',
                    description: 'Substantial reduction in visceral adiposity and systemic inflammation.',
                    achievedAt: DateTime(2026, 2, 1),
                  ),
                ],
              ),
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryCyan),
            );
          }

          final summary = snapshot.data ??
              const TransformationProgressSummary(
                initialWeightKg: 85.0,
                currentWeightKg: 78.5,
                totalWeightLossKg: 6.5,
                initialWaistCm: 94.0,
                currentWaistCm: 87.0,
                waistLossCm: 7.0,
                initialWaistToHipRatio: 0.95,
                currentWaistToHipRatio: 0.89,
                weeklyLossRateKg: 0.72,
                identityStage: HabitIdentityStage.healthAthlete,
                stageTitle: 'Health Athlete (अनुशासित एथलीट)',
                stageTitleHindi: 'दैनिक अनुशासन व शक्ति संपन्न',
                unlockedMilestones: [],
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Habit Identity Card
                _buildIdentityCard(summary),
                const SizedBox(height: 16),

                // 2. Metrics Delta Bento Grid
                _buildMetricsGrid(summary),
                const SizedBox(height: 16),

                // 3. Waist-to-Hip Health Ratio Card
                _buildWaistToHipCard(summary),
                const SizedBox(height: 16),

                // 4. Milestone Timeline
                Text(
                  'Milestones & Achievements',
                  style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildMilestoneTimeline(summary.unlockedMilestones),
                const SizedBox(height: 24),

                // 5. Recent Logs Section
                Text(
                  'Check-In History',
                  style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildCheckInHistory(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdentityCard(TransformationProgressSummary summary) {
    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: AppColors.primaryCyan,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HABIT IDENTITY',
                      style: AppTypography.label.copyWith(
                        color: AppColors.primaryCyan,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary.stageTitle,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.stageTitleHindi,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primaryEmerald,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(TransformationProgressSummary summary) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEIGHT LOSS',
                  style: AppTypography.label.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${summary.totalWeightLossKg.abs().toStringAsFixed(1)} kg',
                      style: AppTypography.h2.copyWith(color: AppColors.primaryEmerald),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_downward,
                      color: AppColors.primaryEmerald,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.weeklyLossRateKg} kg/week rate',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BentoCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WAIST REDUCTION',
                  style: AppTypography.label.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${summary.waistLossCm.abs().toStringAsFixed(1)} cm',
                      style: AppTypography.h2.copyWith(color: AppColors.primaryCyan),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.straighten_rounded,
                      color: AppColors.primaryCyan,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Current: ${summary.currentWaistCm} cm',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaistToHipCard(TransformationProgressSummary summary) {
    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waist-to-Hip Ratio (WHR)',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Cardiometabolic Risk Marker',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${summary.initialWaistToHipRatio}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${summary.currentWaistToHipRatio}',
                  style: AppTypography.label.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneTimeline(List<TransformationMilestone> milestones) {
    if (milestones.isEmpty) {
      return BentoCard(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Keep logging your body metrics & habits to unlock transformation milestones!',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: milestones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final m = milestones[index];
        return BentoCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.primaryCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    Text(m.titleHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryEmerald)),
                    const SizedBox(height: 2),
                    Text(m.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckInHistory() {
    if (widget.repository != null) {
      return StreamBuilder<List<BodyTransformationPoint>>(
        stream: widget.repository!.watchBodyLogs(widget.userId),
        builder: (context, snapshot) {
          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
            return BentoCard(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No check-ins logged yet. Tap the top-right button to log your first check-in.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return _renderLogList(logs);
        },
      );
    }

    // Default static preview logs
    final sampleLogs = [
      BodyTransformationPoint(
        id: '1',
        userId: widget.userId,
        weightKg: 85.0,
        waistCm: 94.0,
        hipCm: 99.0,
        bodyFatPct: 24.0,
        loggedAt: DateTime(2026, 1, 1),
      ),
      BodyTransformationPoint(
        id: '2',
        userId: widget.userId,
        weightKg: 78.5,
        waistCm: 87.0,
        hipCm: 97.0,
        bodyFatPct: 19.5,
        loggedAt: DateTime(2026, 2, 15),
      ),
    ];

    return _renderLogList(sampleLogs);
  }

  Widget _renderLogList(List<BodyTransformationPoint> logs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        return BentoCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${log.loggedAt.day}/${log.loggedAt.month}/${log.loggedAt.year}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                  Text(
                    '${log.weightKg} kg',
                    style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              Text(
                'Waist: ${log.waistCm} cm',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                'Fat: ${log.bodyFatPct}%',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogCheckInSheet(BuildContext context) {
    final weightController = TextEditingController();
    final waistController = TextEditingController();
    final hipController = TextEditingController();
    final bodyFatController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Body Check-In',
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)*',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: waistController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Waist Circumference (cm)*',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hipController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Hip Circumference (cm)*',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyFatController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Body Fat % (e.g. 20.5)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final weight = double.tryParse(weightController.text);
                    final waist = double.tryParse(waistController.text);
                    final hip = double.tryParse(hipController.text);
                    if (weight == null || waist == null || hip == null) return;

                    if (widget.repository != null) {
                      await widget.repository!.logBodyTransformation(
                        id: const Uuid().v4(),
                        userId: widget.userId,
                        loggedAt: DateTime.now(),
                        weightKg: weight,
                        waistCm: waist,
                        hipCm: hip,
                        bodyFatPct: double.tryParse(bodyFatController.text) ?? 20.0,
                      );
                    }

                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Save Check-In',
                    style: AppTypography.label.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
