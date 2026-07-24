/// §P7-E Benchmarking Screen UI
///
/// Route: /benchmarking
/// Layout matching §P7-E ASCII wireframe:
/// - Cohort comparison pill
/// - Hero Overall Fitness Percentile card
/// - Breakdown metrics (Steps, Protein, Sleep, Workouts)
/// - Biggest opportunity coaching nudge card
library;

import 'package:fitkarma/features/karma/benchmarking_engine.dart';
import 'package:flutter/material.dart';

class BenchmarkingScreen extends StatelessWidget {
  const BenchmarkingScreen({
    this.benchmarkResult,
    super.key,
  });

  static const routeName = '/benchmarking';

  final BenchmarkResult? benchmarkResult;

  BenchmarkResult _getDefaultResult() {
    const engine = BenchmarkingEngine();
    return engine.compare(
      user: const UserProfile(age: 28, gender: 'Male', country: 'India'),
      data: const UserHealthData(
        avgSteps7d: 9400,
        avgProtein7d: 78,
        avgSleepH: 7.1,
        workoutsPerWeek: 4.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = benchmarkResult ?? _getDefaultResult();

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
          'Fitness Benchmarking',
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
            // 1. Cohort Pill Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people_outline, color: Colors.indigoAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Compared to: ${result.cohortLabel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Hero Overall Fitness Percentile Card
            _buildHeroPercentileCard(result),
            const SizedBox(height: 24),

            // 3. Metric Breakdown Section
            const Text(
              'Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetricTile('👟 Steps', 'Top ${100 - result.stepsPercentile}%', '9,400/day avg', Colors.blueAccent),
            const SizedBox(height: 8),
            _buildMetricTile('🥗 Protein', 'Top ${100 - result.proteinPercentile}%', '78g/day avg', Colors.orangeAccent),
            const SizedBox(height: 8),
            _buildMetricTile('😴 Sleep', 'Top ${100 - result.sleepPercentile}%', '7.1h avg', Colors.purpleAccent),
            const SizedBox(height: 8),
            _buildMetricTile('🏋️ Workouts', 'Top ${100 - result.workoutsPercentile}%', '4.2/week avg', Colors.greenAccent),
            const SizedBox(height: 24),

            // 4. Biggest Opportunity Card
            _buildOpportunityCard(result),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPercentileCard(BenchmarkResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade500.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Fitness Percentile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                result.topPercentageLabel,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Overall Score: ${result.overallPercentile}th pct',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (result.overallPercentile / 100.0).clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String topLabel, String detailText, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                detailText,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  topLabel,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
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

  Widget _buildOpportunityCard(BenchmarkResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.tealAccent, size: 22),
              SizedBox(width: 8),
              Text(
                'Your Biggest Opportunity',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            result.biggestOpportunityTip,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
