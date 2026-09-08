import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/sharing_engine.dart';
import '../domain/sharing_models.dart';
import 'providers/sharing_provider.dart';

/// Screen displaying the Shareable Story Card Generator & Multi-Channel Dispatcher
class ActivitySharingScreen extends ConsumerWidget {
  const ActivitySharingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activitySharingProvider);
    final payload = state.activePayload;
    final theme = payload.cardTheme;
    final primaryColor = Color(theme.primaryColor);
    final secondaryColor = Color(theme.secondaryColor);

    final viralScore = ActivitySharingEngine.calculateViralContagionIndex(
      totalSharesCount: state.totalSharesCount,
      karmaPointsEarned: state.totalShareBonusKarmaEarned,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Share Milestone & Sadhana',
          regionalText: 'साधना उपलब्धि साझा करें',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSharingPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Achievement Selector Carousel
            const BilingualLabel(
              primaryText: 'Select Milestone to Celebrate',
              regionalText: 'साझा करने हेतु उपलब्धि चुनें',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildAchievementCarousel(context, ref, state),
            const SizedBox(height: AppSpacing.md),

            // 2. Interactive Story Card Canvas Preview
            _buildStoryCardCanvas(payload, primaryColor, secondaryColor),
            const SizedBox(height: AppSpacing.md),

            // 3. Card Visual Palette Theme Selector
            _buildThemePaletteSelector(ref, theme),
            const SizedBox(height: AppSpacing.md),

            // 4. Multi-Channel Share Buttons
            const BilingualLabel(
              primaryText: 'Broadcast Channel',
              regionalText: 'प्रसारण माध्यम चुनें',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildShareActionGrid(context, ref, payload),
            const SizedBox(height: AppSpacing.md),

            // 5. Viral Contagion & Karma Multiplier Bento
            _buildViralContagionBento(state, viralScore),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCarousel(
      BuildContext context, WidgetRef ref, ActivitySharingState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: state.availableAchievements.map((item) {
          final isSelected = item.id == state.activePayload.id;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                item.primaryMetricValue,
                style: AppTypography.metricLabel.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.karmaGreen,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (selected) {
                if (selected) {
                  ref.read(activitySharingProvider.notifier).selectPayload(item);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStoryCardCanvas(
      ShareableActivityPayload payload, Color primaryColor, Color secondaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.18),
            secondaryColor.withValues(alpha: 0.05),
            AppColors.surfaceElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: primaryColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Brand, Verification Badge, and Karma Points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.bolt, color: Colors.black, size: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'FITKARMA SANGHA',
                    style: AppTypography.metricLabel.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '+${payload.karmaPointsEarned} Karma',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Primary Metric Hero Number
          Text(
            payload.primaryMetricValue,
            style: AppTypography.displayLarge.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 44,
            ),
          ),
          Text(
            payload.primaryMetricLabel,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Headline & Regional Headline
          Text(
            payload.headline,
            style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
          ),
          Text(
            payload.regionalHeadline,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Details Subtitle
          Text(
            payload.detailedSubtitle,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),

          // Verified Biometric Footer Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusFull,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: AppColors.karmaGreen, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Verified via ${payload.verificationSource}',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemePaletteSelector(WidgetRef ref, ShareCardTheme activeTheme) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Story Card Theme Palette',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ShareCardTheme.values.map((t) {
                final isSelected = t == activeTheme;
                final color = Color(t.primaryColor);

                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    avatar: CircleAvatar(backgroundColor: color, radius: 6),
                    label: Text(
                      t.name.split('(')[0].trim(),
                      style: AppTypography.metricLabel.copyWith(
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: color,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(activitySharingProvider.notifier).switchCardTheme(t);
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

  Widget _buildShareActionGrid(
      BuildContext context, WidgetRef ref, ShareableActivityPayload payload) {
    return BentoCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildShareButton(
                  context: context,
                  ref: ref,
                  channel: ShareChannel.whatsApp,
                  payload: payload,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildShareButton(
                  context: context,
                  ref: ref,
                  channel: ShareChannel.instagramStories,
                  payload: payload,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildShareButton(
                  context: context,
                  ref: ref,
                  channel: ShareChannel.sanghaFeed,
                  payload: payload,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildShareButton(
                  context: context,
                  ref: ref,
                  channel: ShareChannel.copyLink,
                  payload: payload,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required BuildContext context,
    required WidgetRef ref,
    required ShareChannel channel,
    required ShareableActivityPayload payload,
  }) {
    final color = Color(channel.colorCode);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: Icon(
        channel == ShareChannel.whatsApp
            ? Icons.chat
            : channel == ShareChannel.instagramStories
                ? Icons.camera_alt
                : channel == ShareChannel.sanghaFeed
                    ? Icons.public
                    : Icons.link,
        size: 16,
      ),
      label: Text(
        channel.label.split('(')[0].trim(),
        style: AppTypography.metricLabel.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
      onPressed: () {
        ref.read(activitySharingProvider.notifier).recordShareBroadcast(channel);
        final formattedText = ActivitySharingEngine.generateShareableTextPayload(payload: payload);
        Clipboard.setData(ClipboardData(text: formattedText));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${channel.label.split('(')[0].trim()} Payload copied (+15 Karma awarded)!'),
            backgroundColor: AppColors.karmaGreen,
          ),
        );
      },
    );
  }

  Widget _buildViralContagionBento(ActivitySharingState state, double viralScore) {
    return BentoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Positive Social Contagion',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                '${state.totalSharesCount} Milestone Broadcasts • +${state.totalShareBonusKarmaEarned} Bonus Karma',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          GlowingMetric(
            value: '${viralScore.toInt()}%',
            label: 'Sangha Impact',
            accentColor: AppColors.karmaGreen,
          ),
        ],
      ),
    );
  }

  void _showSharingPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FitKarma Social Sharing Philosophy',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma turns habit consistency into positive social contagion:\n\n'
                '• Verified Biometric Badges: Only authentic Apple Health or Computer Vision PRs can be broadcast.\n'
                '• Multi-Channel Export: Beautiful WhatsApp Status & Instagram Story canvas exports.\n'
                '• Earn Karma Bonuses: Radiating positive health habits to friends and family rewards you with community Karma.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
