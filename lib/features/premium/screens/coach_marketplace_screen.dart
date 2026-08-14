import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../models/creator_marketplace_models.dart';
import '../providers/marketplace_provider.dart';

/// §P13-B Creator & Coach Marketplace Screen (NEW v1)
class CoachMarketplaceScreen extends ConsumerWidget {
  const CoachMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);
    final notifier = ref.read(marketplaceProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        title: const Text('Creator & Coach Marketplace', style: AppTypography.h2),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    title: 'Specialist Coaches',
                    isSelected: state.selectedTab == 0,
                    onTap: () => notifier.selectTab(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    title: 'Blueprint Store',
                    isSelected: state.selectedTab == 1,
                    onTap: () => notifier.selectTab(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Escrow Protection Guarantee Banner (§P13-B Trust & Escrow)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: AppColors.teal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '🔒 7-Day Escrow Protection: Funds held in escrow. Auto-refund if coach does not engage.',
                        style: AppTypography.labelMd.copyWith(color: AppColors.teal),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              if (state.selectedTab == 0) ...[
                // Top Matched Header
                Text(
                  'Top Matched Coaches for You',
                  style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personalized to your goals: ${state.clientProfile.goals.join(', ')}',
                  style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Coaches List
                ...state.matchedCoaches.map((coach) => _CoachCard(coach: coach)),
              ] else ...[
                // Blueprint Store Header
                Text(
                  'Community Blueprints',
                  style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'One-time unlock: multi-week structured programs created by certified coaches',
                  style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Blueprints List
                ...state.blueprints.map((bp) => _BlueprintCard(blueprint: bp)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.teal : AppColors.glassBgMid,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTypography.labelMd.copyWith(
              color: isSelected ? Colors.black : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _CoachCard extends ConsumerWidget {
  final CreatorProfile coach;

  const _CoachCard({required this.coach});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: BentoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.glassBgMid,
                  child: Text(
                    coach.name.substring(0, 1),
                    style: AppTypography.h1.copyWith(color: AppColors.teal),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(coach.name, style: AppTypography.h3),
                          ),
                          if (coach.isVerified)
                            const Icon(Icons.verified, color: AppColors.teal, size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.warning, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${coach.averageRating} (${coach.activeClientsCount} active clients)',
                            style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              coach.bio,
              style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Certifications
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: coach.certifications.map((cert) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.glassBgMid,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    cert,
                    style: AppTypography.labelMd.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.glassBorder, height: 1),
            const SizedBox(height: AppSpacing.sm),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly Coaching', style: AppTypography.labelMd.copyWith(fontSize: 10)),
                    Text(
                      coach.formattedMonthlyRate,
                      style: AppTypography.h3.copyWith(color: AppColors.teal),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ref.read(marketplaceProvider.notifier).purchaseCoaching(coach);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 Secured 1:1 coaching with ${coach.name}! Escrow active.'),
                        backgroundColor: AppColors.teal,
                      ),
                    );
                  },
                  child: const Text('Book Coach', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlueprintCard extends ConsumerWidget {
  final BlueprintProgram blueprint;

  const _BlueprintCard({required this.blueprint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: BentoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${blueprint.durationWeeks} Weeks Program',
                    style: AppTypography.labelMd.copyWith(color: AppColors.secondary, fontSize: 10),
                  ),
                ),
                Text(
                  blueprint.formattedPrice,
                  style: AppTypography.h3.copyWith(color: AppColors.teal),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(blueprint.title, style: AppTypography.h3),
            const SizedBox(height: 2),
            Text(
              'By ${blueprint.creatorName}',
              style: AppTypography.labelMd.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            Text(
              blueprint.description,
              style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: 6,
              children: blueprint.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.glassBgMid,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#$tag',
                    style: AppTypography.labelMd.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.teal,
                  side: const BorderSide(color: AppColors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ref.read(marketplaceProvider.notifier).purchaseBlueprint(blueprint);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 Unlocked ${blueprint.title}! Added to your routines.'),
                      backgroundColor: AppColors.teal,
                    ),
                  );
                },
                child: Text('Get Blueprint (${blueprint.formattedPrice})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
