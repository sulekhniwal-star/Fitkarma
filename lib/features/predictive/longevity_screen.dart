/// §P10-G Longevity Score UI Screen
///
/// Route: /longevity
/// Dark glassmorphic bento layout matching §P10-G ASCII wireframe:
/// - App Bar: [←] 🌱 Longevity Score
/// - Main Score Bento Card: Longevity Score (84), Biological Age (25), Chronological Age (28),
///   and statement ("You are 3 years younger than your actual age ✓")
/// - Factor Breakdown Section (Cardio, Sleep, Activity, Body Comp, Biomarkers) with star ratings
/// - Biggest Opportunity Card
/// - Monthly Schedule Footer ("Updated monthly. Next update: Jul 1.")
library;

import 'package:fitkarma/features/predictive/longevity_calculator.dart';
import 'package:fitkarma/features/predictive/longevity_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LongevityScreen extends ConsumerWidget {
  const LongevityScreen({super.key});

  static const routeName = '/longevity';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final longevity = ref.watch(longevityProvider);

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
          '🌱 Longevity Score',
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
            // 1. Main Longevity Score Bento Card
            _buildMainScoreCard(longevity),
            const SizedBox(height: 20),

            // 2. Factor Breakdown List
            _buildFactorBreakdownCard(longevity.factorScores),
            const SizedBox(height: 20),

            // 3. Biggest Opportunity Card
            _buildOpportunityCard(longevity.biggestOpportunity),
            const SizedBox(height: 20),

            // 4. Monthly Schedule Footer
            _buildMonthlyFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainScoreCard(LongevityResult longevity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Text(
            'Longevity Score',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${longevity.longevityScore}',
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 54,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: longevity.longevityScore / 100.0,
              minHeight: 8,
              backgroundColor: Colors.white10,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAgeStat('Biological Age', '${longevity.biologicalAge}', Colors.tealAccent),
              Container(width: 1, height: 30, color: Colors.white12),
              _buildAgeStat('Chronological Age', '${longevity.chronologicalAge}', Colors.white),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            longevity.isYoungerThanChronological
                ? 'You are ${longevity.ageDeltaYears} years younger than your actual age ✓'
                : 'Biological age matches chronological baseline.',
            style: TextStyle(
              color: Colors.tealAccent.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFactorBreakdownCard(LongevityFactorScores f) {
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
            'Factor Breakdown:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildFactorRow('❤️ Cardio (HRV/HR):', f.cardioScore),
          const SizedBox(height: 8),
          _buildFactorRow('😴 Sleep:', f.sleepScore),
          const SizedBox(height: 8),
          _buildFactorRow('🏃 Activity:', f.activityScore),
          const SizedBox(height: 8),
          _buildFactorRow('⚖️ Body Composition:', f.bodyFatScore),
          const SizedBox(height: 8),
          _buildFactorRow('🩺 Biomarkers:', f.biomarkerScore),
        ],
      ),
    );
  }

  Widget _buildFactorRow(String label, int score) {
    final stars = (score / 20).round().clamp(1, 5);
    final starText = '★' * stars + '☆' * (5 - stars);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
        Row(
          children: [
            Text(
              '$score ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              starText,
              style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpportunityCard(String opportunity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biggest Opportunity:',
            style: TextStyle(
              color: Colors.indigoAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyFooter() {
    return Center(
      child: Text(
        'Updated monthly. Next update: Jul 1.',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
