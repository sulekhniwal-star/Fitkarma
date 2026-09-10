import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/club_engine.dart';
import '../domain/club_models.dart';
import 'providers/club_provider.dart';

/// Screen displaying Local Geolocation Clubs, Distance Filters, and Neighborhood Meetups
class LocalGeolocationClubsScreen extends ConsumerWidget {
  const LocalGeolocationClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localClubsProvider);
    final displayedClubs = LocalClubEngine.filterClubsByRadius(
      clubs: state.allClubs,
      maxRadiusKm: state.selectedRadiusKm,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Local Clubs (Kshetra)',
          regionalText: 'स्थानीय क्लब एवं पड़ोस मिलन',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showClubPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Geolocation Location & Radius Filter Card
            _buildLocationFilterCard(context, ref, state),
            const SizedBox(height: AppSpacing.md),

            // 2. Section Header
            BilingualLabel(
              primaryText:
                  'Clubs within ${state.selectedRadiusKm.toInt()} km (${displayedClubs.length} active)',
              regionalText: 'निकटवर्ती सक्रिय साधना क्लब',
            ),
            const SizedBox(height: AppSpacing.sm),

            // 3. Local Clubs List
            if (displayedClubs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    'No clubs found within this distance. Try expanding the radius!',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...displayedClubs.map((club) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _buildClubBentoCard(context, ref, club),
                  )),

            // 4. Host a Local Meetup Action Card
            _buildHostMeetupBanner(context),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationFilterCard(
      BuildContext context, WidgetRef ref, LocalClubsState state) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location,
                  color: AppColors.karmaGreen, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                state.userCurrentLocationLabel,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Filter by Walking & Commuting Radius:',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [1.0, 3.0, 5.0, 10.0].map((radius) {
              final isSelected = state.selectedRadiusKm == radius;

              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(
                    '${radius.toInt()} km',
                    style: AppTypography.metricLabel.copyWith(
                      color:
                          isSelected ? Colors.black : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.karmaGreen,
                  backgroundColor: AppColors.surfaceElevated,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(localClubsProvider.notifier)
                          .updateRadius(radius);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClubBentoCard(
      BuildContext context, WidgetRef ref, LocalGeoClub club) {
    final actColor = Color(club.primaryActivity.colorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Activity Tag, Distance Pill, and Join Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: actColor.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusFull,
                    ),
                    child: Text(
                      club.primaryActivity.label,
                      style: AppTypography.metricLabel.copyWith(
                        color: actColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: AppRadii.radiusFull,
                    ),
                    child: Text(
                      '${club.distanceFromUserKm.toStringAsFixed(1)} km away',
                      style: AppTypography.metricLabel.copyWith(
                        color: AppColors.focusBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: club.isUserJoined
                      ? AppColors.surfaceElevated
                      : AppColors.karmaGreen,
                  foregroundColor: club.isUserJoined
                      ? AppColors.textSecondary
                      : Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => ref
                    .read(localClubsProvider.notifier)
                    .toggleJoinClub(club.id),
                child: Text(
                  club.isUserJoined ? 'Joined' : 'Join Club',
                  style: AppTypography.metricLabel.copyWith(
                    fontWeight: FontWeight.bold,
                    color: club.isUserJoined
                        ? AppColors.textSecondary
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title & Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: AppTypography.titleLarge
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      '${club.landmarkArea}, ${club.city}',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${club.activeMembersCount} neighbors practicing together weekly.',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GlowingMetric(
                value:
                    '${(club.weeklyCollectiveSteps / 1000000).toStringAsFixed(1)}M',
                label: 'Weekly Steps',
                accentColor: actColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Next Meetup Card if scheduled
          if (club.nextMeetup != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.surfaceElevated),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event,
                              color: AppColors.gold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Next Physical Meetup',
                            style: AppTypography.metricLabel.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${club.nextMeetup!.rsvpCount} RSVP’d',
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.nextMeetup!.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '📍 ${club.nextMeetup!.venueName}',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Led by ${club.nextMeetup!.organizerName}',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textMuted, fontSize: 10),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: club.nextMeetup!.isUserRsvpd
                              ? AppColors.karmaGreen.withValues(alpha: 0.2)
                              : AppColors.surfaceElevated,
                          foregroundColor: club.nextMeetup!.isUserRsvpd
                              ? AppColors.karmaGreen
                              : AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => ref
                            .read(localClubsProvider.notifier)
                            .toggleMeetupRsvp(
                              club.id,
                              club.nextMeetup!.id,
                            ),
                        child: Text(
                          club.nextMeetup!.isUserRsvpd
                              ? 'RSVP Confirmed ✓'
                              : 'RSVP for Meetup',
                          style: AppTypography.metricLabel.copyWith(
                            color: club.nextMeetup!.isUserRsvpd
                                ? AppColors.karmaGreen
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHostMeetupBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.aiPurple.withValues(alpha: 0.10),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.aiPurple.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.aiPurple.withValues(alpha: 0.2),
            child: const Icon(Icons.add_location_alt,
                color: AppColors.aiPurple, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Host a Neighborhood Sadhana',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.aiPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Organize a weekend morning Shatpawali or calisthenics circle at your local park. Earn +100 Organizer Karma.',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClubPhilosophyModal(BuildContext context) {
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
                'Local Geolocation Clubs (Kshetra)',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma Local Clubs connect athletes living within the same neighborhood or park radius:\n\n'
                '• Real-world morning meetups for Shatpawali, Calisthenics, and Running.\n'
                '• Geofenced check-in bonuses (+25 Karma) for attending park sadhanas.\n'
                '• Safe, community-moderated spaces to meet fellow practitioners.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
