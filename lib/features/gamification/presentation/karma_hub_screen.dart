import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/karma_models.dart';
import 'providers/karma_provider.dart';

class KarmaHubScreen extends ConsumerStatefulWidget {
  const KarmaHubScreen({super.key});

  @override
  ConsumerState<KarmaHubScreen> createState() => _KarmaHubScreenState();
}

class _KarmaHubScreenState extends ConsumerState<KarmaHubScreen> with SingleTickerProviderStateMixin {
  KarmaBadgeCategory? _selectedCategory;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final karmaProfile = ref.watch(karmaProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Karma Hub',
              style: AppTypography.titleLarge,
            ),
            Text(
              'Deterministic Health Currency • Gamification OS',
              style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.karmaGreen.withAlpha(30),
              borderRadius: BorderRadius.circular(AppRadii.full),
              border: Border.all(color: AppColors.karmaGreen.withAlpha(120)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: AppColors.karmaGreen, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${karmaProfile.streakMultiplier.toStringAsFixed(2)}x',
                  style: const TextStyle(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroKarmaCard(karmaProfile),
            const SizedBox(height: AppSpacing.md),
            _buildStreakAndMultipliersRow(karmaProfile),
            const SizedBox(height: AppSpacing.md),
            _buildQuickActionRewardSimulator(),
            const SizedBox(height: AppSpacing.md),
            _buildBadgeShowcaseSection(karmaProfile),
            const SizedBox(height: AppSpacing.md),
            _buildRecentKarmaLedger(karmaProfile),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroKarmaCard(KarmaProfile profile) {
    final tierColor = Color(profile.tier.badgeColorCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tierColor.withAlpha(35),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tierColor.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: tierColor.withAlpha(30),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tierColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(AppRadii.full),
                      border: Border.all(color: tierColor),
                    ),
                    child: Text(
                      'TIER: ${profile.tier.title.toUpperCase()}',
                      style: TextStyle(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.tier.regionalTitle,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: tierColor.withAlpha(50),
                child: Text(
                  'L${profile.currentLevel}',
                  style: TextStyle(
                    color: tierColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '${profile.currentKarmaPoints}',
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 44,
            ),
          ),
          Text(
            'LIFETIME KARMA POINTS (KP)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Level progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${profile.currentLevel} Progress',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    '${(profile.levelProgressPercent * 100).toInt()}% • ${profile.pointsToNextLevel} KP to L${profile.currentLevel + 1}',
                    style: AppTypography.bodySmall.copyWith(
                      color: tierColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.full),
                child: LinearProgressIndicator(
                  value: profile.levelProgressPercent,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(tierColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakAndMultipliersRow(KarmaProfile profile) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Current Streak',
              value: '${profile.currentStreakDays}',
              unit: 'Days',
              accentColor: AppColors.energyOrange,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Longest Streak',
              value: '${profile.longestStreakDays}',
              unit: 'Days',
              accentColor: AppColors.focusBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Badges Unlocked',
              value: '${profile.unlockedBadgesCount}/${profile.totalBadgesCount}',
              accentColor: AppColors.karmaGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionRewardSimulator() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Daily Health Karma Loggers',
            regionalText: 'दैनिक स्वास्थ्य कर्म लॉगिंग',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Complete daily health actions to earn Karma points boosted by your active streak multiplier.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionChip(
                label: '+ Shatpawali (1000 Steps)',
                action: KarmaActionType.shatpawaliSteps,
                color: AppColors.karmaGreen,
              ),
              _buildActionChip(
                label: '+ Workout Completed',
                action: KarmaActionType.workoutCompletion,
                color: AppColors.focusBlue,
              ),
              _buildActionChip(
                label: '+ Protein Target Hit',
                action: KarmaActionType.nutritionAdherence,
                color: AppColors.energyOrange,
              ),
              _buildActionChip(
                label: '+ Optimal Sleep Logged',
                action: KarmaActionType.sleepGoalAchieved,
                color: AppColors.aiPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required KarmaActionType action,
    required Color color,
  }) {
    return ActionChip(
      avatar: Icon(Icons.add_circle, color: color, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.surfaceElevated,
      side: BorderSide(color: color.withAlpha(90)),
      onPressed: () {
        ref.read(karmaProvider.notifier).recordKarmaAction(
          action: action,
          isReadinessAligned: true,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surfaceElevated,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            content: Row(
              children: [
                Icon(Icons.stars, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Karma Awarded: ${action.label}!',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadgeShowcaseSection(KarmaProfile profile) {
    final filteredBadges = _selectedCategory == null
        ? profile.allBadges
        : profile.allBadges.where((b) => b.category == _selectedCategory).toList();

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Achievements & Badges',
                regionalText: 'उपलब्धियां और सम्मान पदक',
              ),
              Text(
                '${profile.unlockedBadgesCount} / ${profile.totalBadgesCount} Unlocked',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: const Text('All Pillars', style: TextStyle(fontSize: 11)),
                    selected: _selectedCategory == null,
                    selectedColor: AppColors.karmaGreen,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = null;
                        });
                      }
                    },
                  ),
                ),
                ...KarmaBadgeCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: FilterChip(
                      label: Text(cat.label, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: AppColors.karmaGreen,
                      backgroundColor: AppColors.surfaceElevated,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Badges Grid
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredBadges.length,
            itemBuilder: (context, index) {
              final badge = filteredBadges[index];
              return _buildBadgeCard(badge);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(KarmaBadge badge) {
    final isUnlocked = badge.isUnlocked;
    final badgeColor = isUnlocked ? AppColors.gold : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: isUnlocked ? AppColors.gold.withAlpha(120) : AppColors.glassBorder,
          width: isUnlocked ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: isUnlocked ? AppColors.gold.withAlpha(40) : AppColors.surface,
            child: Icon(
              isUnlocked ? Icons.workspace_premium : Icons.lock_outline,
              color: badgeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      badge.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'UNLOCKED',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  badge.regionalName,
                  style: AppTypography.bodySmall.copyWith(
                    color: isUnlocked ? AppColors.focusBlue : AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Requirement: ${badge.requirementLabel}',
                        style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                      ),
                      Text(
                        '${(badge.progress * 100).toInt()}%',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.focusBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.full),
                    child: LinearProgressIndicator(
                      value: badge.progress,
                      minHeight: 4,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.focusBlue),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentKarmaLedger(KarmaProfile profile) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Karma Activity Ledger',
            regionalText: 'कर्म गतिविधि लेखा-जोखा',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...profile.recentTransactions.map((tx) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadii.sm),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.karmaGreen.withAlpha(35),
                    child: const Icon(Icons.add, color: AppColors.karmaGreen, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          tx.regionalDescription,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+${tx.totalPointsAwarded} KP',
                        style: const TextStyle(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${tx.multiplier}x boost',
                        style: const TextStyle(
                          color: AppColors.focusBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
