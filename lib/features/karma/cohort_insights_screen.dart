/// §P7-F Demographic Cohort Insights UI
///
/// Route: /cohort-insights
/// Renders city & age-group rankings, program success stats, and privacy guarantee badge.
library;

import 'package:fitkarma/features/karma/cohort_aggregation_pipeline.dart';
import 'package:fitkarma/features/karma/cohort_insights_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CohortInsightsScreen extends ConsumerWidget {
  const CohortInsightsScreen({
    this.insights,
    super.key,
  });

  static const routeName = '/cohort-insights';

  final CohortInsights? insights;

  CohortInsights _getDefaultInsights(WidgetRef ref) {
    final service = ref.read(cohortInsightsServiceProvider);
    return service.getInsights(
      ageGroup: '25-30',
      gender: 'Male',
      region: 'Noida',
      dietType: 'Vegetarian',
      primaryGoal: 'Fat Loss',
      sampleCohortSize: 4210,
      avgSteps: 9400,
      avgProtein: 78,
      avgReadiness: 85,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = insights ?? _getDefaultInsights(ref);

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
          'Cohort Insights',
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
            // 1. Privacy Guarantee Badge
            _buildPrivacyBadge(data),
            const SizedBox(height: 20),

            // 2. City Leaderboard Card
            _buildCityRankCard(data.cityRank),
            const SizedBox(height: 16),

            // 3. Age-Group Leaderboard Card
            _buildAgeGroupRankCard(data.ageGroupRank),
            const SizedBox(height: 16),

            // 4. Program Success Network Effect Card
            _buildProgramSuccessCard(data.programSuccessStat),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyBadge(CohortInsights data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.shade900.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.security, color: Colors.tealAccent, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🔒 Privacy-Protected: k-Anonymity (N ≥ 25) Enforced. Zero PII transmitted.',
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityRankCard(CityRank cityRank) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.indigoAccent, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    '${cityRank.city} City Rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigoAccent),
                ),
                child: Text(
                  cityRank.formattedTop,
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Rank: ${cityRank.formattedRank} members in ${cityRank.city}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeGroupRankCard(AgeGroupRank ageGroupRank) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.groups, color: Colors.amberAccent, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Age ${ageGroupRank.ageGroup} Group',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amberAccent),
                ),
                child: Text(
                  ageGroupRank.formattedTop,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Rank: ${ageGroupRank.formattedRank} peers nationwide',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramSuccessCard(ProgramComparisonStat stat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.greenAccent, size: 24),
              SizedBox(width: 10),
              Text(
                'Network Effect Insights',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${stat.successRatePercent}% of ${stat.cohortLabel} achieved their target goals on ${stat.programName}.',
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
