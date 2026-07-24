/// §P10-H Continuous Biomarker Tracking (CGM Sync) UI Screen
///
/// Route: /cgm
/// Dark glassmorphic dashboard matching §P10-H ASCII wireframe:
/// - App Bar: [←] 🩺 CGM Glucose Stream — Live
/// - Live Gauge Card: Current reading (124 mg/dL), trend badge ([↗ Rising]), status, sparkline
/// - Detected Spikes Card (Last 24 Hours): Spike list (🚨 Spike: +52 mg/dL at 2:15 PM)
/// - Correlated Food & Retrospective AI Insight Card (§P10-L)
library;

import 'package:fitkarma/features/predictive/cgm_notifier.dart';
import 'package:fitkarma/features/predictive/cgm_sync_engine.dart';
import 'package:fitkarma/features/predictive/clinical_disclaimer_shield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CgmDashboardScreen extends ConsumerWidget {
  const CgmDashboardScreen({super.key});

  static const routeName = '/cgm';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cgmState = ref.watch(cgmProvider);
    final current = cgmState.currentReading;

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
          '🩺 CGM Glucose Stream — Live',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.tealAccent),
            onPressed: () {
              ref.read(cgmProvider.notifier).syncLatest();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('CGM Sync: Sensor stream updated 🔄')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NonDiagnosticShieldBanner(),
            const SizedBox(height: 16),

            // 1. Live Glucose Gauge Card
            _buildLiveGlucoseCard(current, cgmState.sensorStatus),
            const SizedBox(height: 20),

            // 2. Detected Spikes Card (Last 24 Hours)
            _buildSpikesCard(cgmState.detectedSpikes),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveGlucoseCard(GlucoseReading current, SensorStatus status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(status.indicatorEmoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    status.displayName,
                    style: TextStyle(
                      color: Colors.tealAccent.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(
                'Last updated: 2 mins ago',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${current.glucoseValueMgDl.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'mg/dL',
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.6)),
                ),
                child: Text(
                  current.trendDirection.displayName,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sparkline Indicator Representation
          Container(
            height: 36,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                '[••••••••••••••••••••📈•••••••••••]',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontFamily: 'monospace',
                  letterSpacing: 2.0,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpikesCard(List<CgmSpikeEvent> spikes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ Detected Spikes (Last 24 Hours):',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          if (spikes.isEmpty)
            const Text(
              'No significant glucose spikes detected in the last 24 hours.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            )
          else
            Column(
              children: spikes.map((spike) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🚨 Spike: +${spike.glucoseDelta.round()} mg/dL',
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Peak: ${spike.peakGlucose.round()} mg/dL',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Correlated food: ${spike.correlatedMeal.foodName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Retrospective AI Insight Card (§P10-L)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade900.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                spike.aiInsight,
                                style: TextStyle(
                                  color: Colors.indigo.shade100,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
