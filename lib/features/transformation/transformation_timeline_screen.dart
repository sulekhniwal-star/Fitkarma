/// §P8-B Transformation Timeline Screen UI
///
/// Route: /transformation
/// Split view layout matching §P8-B ASCII wireframe:
/// - Active JourneyStage banner pill
/// - 90-Day Prediction Shaded Forecast Card
/// - Target Pace Details (Projected Weight, Body Fat, Program Week)
/// - Biometric-Protected Progress Photos
/// - Milestones Timeline List
library;

import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';
import 'package:fitkarma/features/transformation/transformation_timeline_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransformationTimelineScreen extends ConsumerWidget {
  const TransformationTimelineScreen({super.key});

  static const routeName = '/transformation';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transformationTimelineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Transformation Journey',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Active Journey Stage Pill Header
            _buildStageHeaderPill(state.journeyStage, state.daysActive),
            const SizedBox(height: 20),

            // 2. Weight Projection & 90-Day Range Card
            _buildForecastCard(state),
            const SizedBox(height: 24),

            // 3. Target Prediction Card (At Current Pace)
            const Text(
              'Target Prediction (At Current Pace)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTargetPredictionCard(state),
            const SizedBox(height: 24),

            // 4. Secure Progress Photos (Biometric Locked)
            const Text(
              '🔒 Secure Progress Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildProgressPhotosCard(context, ref, state),
            const SizedBox(height: 24),

            // 5. Milestones Timeline Section
            const Text(
              'Journey Milestones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMilestonesTimeline(state.milestones),
          ],
        ),
      ),
    );
  }

  Widget _buildStageHeaderPill(JourneyStage stage, int daysActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amberAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            'Stage: ${stage.displayName} (Day $daysActive)',
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(TransformationTimelineState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight Projection & 90-Day Range',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current: ${state.currentWeightKg} kg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shaded Forecast Channel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigoAccent),
                  ),
                  child: Text(
                    '${state.projectedWeightMinKg}kg – ${state.projectedWeightMaxKg}kg',
                    style: const TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetPredictionCard(TransformationTimelineState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPredictionRow(
            'Projected Weight (90 days)',
            '${state.projectedWeightMinKg} kg – ${state.projectedWeightMaxKg} kg',
            Colors.amberAccent,
          ),
          const Divider(color: Colors.white10, height: 20),
          _buildPredictionRow(
            'Projected Body Fat',
            '${state.projectedBodyFatMin}% – ${state.projectedBodyFatMax}%',
            Colors.greenAccent,
          ),
          const Divider(color: Colors.white10, height: 20),
          _buildPredictionRow(
            'Program Target',
            'Week ${state.programWeekCurrent} of ${state.programWeekTotal} complete',
            Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionRow(String label, String value, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressPhotosCard(
      BuildContext context, WidgetRef ref, TransformationTimelineState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.arePhotosUnlocked ? Colors.greenAccent : Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoSlot('Week 1', state.arePhotosUnlocked),
              _buildPhotoSlot('Week 4', state.arePhotosUnlocked),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(transformationTimelineProvider.notifier).togglePhotosUnlocked();
            },
            icon: Icon(
              state.arePhotosUnlocked ? Icons.lock_open : Icons.lock,
              color: Colors.black,
            ),
            label: Text(
              state.arePhotosUnlocked ? 'Lock Progress Photos' : 'Tap to Unlock Photos',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: state.arePhotosUnlocked ? Colors.greenAccent : Colors.amberAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSlot(String label, bool isUnlocked) {
    return Container(
      width: 130,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUnlocked ? Colors.greenAccent : Colors.white24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? Icons.photo : Icons.lock_clock,
              color: isUnlocked ? Colors.greenAccent : Colors.white38,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              isUnlocked ? label : '$label (Locked)',
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesTimeline(List<TransformationMilestone> milestones) {
    return Column(
      children: milestones.map((m) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(m.iconSymbol, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(
                    m.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Icon(
                m.isAchieved ? Icons.check_circle : Icons.radio_button_unchecked,
                color: m.isAchieved ? Colors.greenAccent : Colors.white38,
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
