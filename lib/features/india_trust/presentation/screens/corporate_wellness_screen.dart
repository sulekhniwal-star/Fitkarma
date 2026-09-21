import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/india_trust/domain/services/corporate_wellness_engine.dart';

class CorporateWellnessScreen extends ConsumerStatefulWidget {
  const CorporateWellnessScreen({super.key});

  @override
  ConsumerState<CorporateWellnessScreen> createState() => _CorporateWellnessScreenState();
}

class _CorporateWellnessScreenState extends ConsumerState<CorporateWellnessScreen> {
  final _engine = const CorporateWellnessEngine();

  @override
  Widget build(BuildContext context) {
    final team = _engine.evaluateTeamWellness(
      id: 'corp-1',
      companyName: 'Infosys BPM',
      teamName: 'Engineering & Product',
      corporateCode: 'INFY-HEALTH-2026',
      memberAdherencePercentages: [0.85, 0.92, 0.78, 0.88, 0.95, 0.70, 0.82],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Corporate Wellness & Insurer Tier', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Corporate Team Hero Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.primaryCyan,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(team.companyName, style: AppTypography.h3),
                          Text(team.teamName, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryCyan)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          team.corporateCode,
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Team Wellness', '${team.teamWellnessScore.toInt()}%'),
                      _buildMetric('Active Members', '${team.activeMembersCount}'),
                      _buildMetric('Insurer Discount', '${team.insurerDiscountPct.toInt()}%'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Health Insurance Premium Savings
            Text('Group Health Insurance Benefit', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              glowColor: AppColors.primaryEmerald,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.health_and_safety, color: AppColors.primaryEmerald),
                      const SizedBox(width: 8),
                      Text('Dynamic Premium Rebate: ${team.insurerDiscountPct.toInt()}% Off', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your employer’s group health policy automatically applies wellness tier discounts on corporate annual renewals when team adherence stays above 80%.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Inter-Team Leaderboard
            Text('Company Leaderboard', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildTeamRank('1', 'Engineering & Product', '84% Wellness', true),
            const SizedBox(height: 8),
            _buildTeamRank('2', 'Design & Research', '79% Wellness', false),
            const SizedBox(height: 8),
            _buildTeamRank('3', 'Sales & Marketing', '71% Wellness', false),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h2.copyWith(color: AppColors.primaryCyan)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTeamRank(String rank, String title, String score, bool isLeader) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLeader ? AppColors.primaryEmerald.withValues(alpha: 0.2) : AppColors.surfaceGlass,
              shape: BoxShape.circle,
            ),
            child: Text(rank, style: AppTypography.h3.copyWith(color: isLeader ? AppColors.primaryEmerald : AppColors.textSecondary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTypography.h3)),
          Text(score, style: AppTypography.label.copyWith(color: isLeader ? AppColors.primaryEmerald : AppColors.primaryCyan)),
        ],
      ),
    );
  }
}
