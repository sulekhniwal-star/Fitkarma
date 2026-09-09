import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/marketplace_models.dart';
import 'providers/marketplace_provider.dart';

/// Screen displaying Creator & Coach Marketplace, Certified Trainer Listings,
/// Clinical Nutritionist Consultations, and Ayurvedic Protocols.
class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);
    final notifier = ref.read(marketplaceProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Creator & Coach Marketplace',
          regionalText: 'प्रशिक्षक एवं विशेषज्ञ बाज़ार',
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: state.userOrders.isNotEmpty,
              label: Text('${state.userOrders.length}'),
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
            ),
            tooltip: 'My Enrollments',
            onPressed: () => _showMyOrdersBottomSheet(context, state),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success / Error Banner
            if (state.successMessage != null)
              _buildSuccessBanner(state.successMessage!),

            // 1. Search Bar
            _buildSearchBar(notifier),
            const SizedBox(height: AppSpacing.sm),

            // 2. Specialty Horizontal Filter Carousel
            _buildSpecialtyFilters(state, notifier),
            const SizedBox(height: AppSpacing.xs),

            // 3. Type Filter Chips & Verified Toggle
            _buildTypeFilterRow(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 4. Hero Marketplace Stats Bento Card
            _buildMarketplaceHeroCard(state),
            const SizedBox(height: AppSpacing.md),

            // 5. Listings Feed Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BilingualLabel(
                  primaryText: 'Available Programs & Consultations (${state.filteredListings.length})',
                  regionalText: 'उपलब्ध कोर्स एवं परामर्श सत्र',
                ),
                if (state.filter.specialty != null ||
                    state.filter.type != null ||
                    state.filter.searchQuery.isNotEmpty ||
                    state.filter.onlyVerified)
                  TextButton(
                    onPressed: () => notifier.resetFilters(),
                    child: const Text('Reset Filters', style: TextStyle(color: AppColors.focusBlue, fontSize: 11)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // 6. Listings List
            if (state.filteredListings.isEmpty)
              _buildEmptyListingsCard(notifier)
            else
              ...state.filteredListings.map(
                (listing) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildListingCard(context, notifier, listing),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.karmaGreen, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(MarketplaceNotifier notifier) {
    return TextField(
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        hintText: 'Search coach, strength, PCOS, Ayurveda, yoga...',
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 18),
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (val) => notifier.setSearchQuery(val),
    );
  }

  Widget _buildSpecialtyFilters(MarketplaceState state, MarketplaceNotifier notifier) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('All Specialties', style: TextStyle(fontSize: 11)),
            selected: state.filter.specialty == null,
            selectedColor: AppColors.focusBlue,
            backgroundColor: AppColors.surfaceElevated,
            labelStyle: TextStyle(
              color: state.filter.specialty == null ? Colors.white : AppColors.textSecondary,
              fontWeight: state.filter.specialty == null ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) => notifier.setSpecialty(null),
          ),
          const SizedBox(width: 6),
          ...CoachSpecialty.values.map((spec) {
            final isSelected = state.filter.specialty == spec;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(spec.name.split('&').first.trim(), style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: AppColors.focusBlue,
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => notifier.setSpecialty(isSelected ? null : spec),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTypeFilterRow(MarketplaceState state, MarketplaceNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...ListingType.values.map((type) {
                  final isSelected = state.filter.type == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(
                        type == ListingType.structuredProgram
                            ? 'Programs'
                            : (type == ListingType.oneOnOneConsultation ? '1-on-1 Calls' : 'Diet Plans'),
                        style: const TextStyle(fontSize: 10),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.karmaGreen.withValues(alpha: 0.25),
                      checkmarkColor: AppColors.karmaGreen,
                      backgroundColor: AppColors.surfaceElevated,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.karmaGreen : AppColors.textSecondary,
                      ),
                      onSelected: (_) => notifier.setListingType(isSelected ? null : type),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, color: AppColors.focusBlue, size: 14),
            const SizedBox(width: 4),
            Text('Verified', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            Switch(
              value: state.filter.onlyVerified,
              activeThumbColor: AppColors.focusBlue,
              onChanged: (val) => notifier.toggleVerifiedOnly(val),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketplaceHeroCard(MarketplaceState state) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, color: AppColors.gold, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'VERIFIED COACH NETWORK',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                '80% Direct Creator Payout',
                style: AppTypography.bodySmall.copyWith(color: AppColors.karmaGreen, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Verified Coaches',
                value: '120+',
                unit: 'pros',
                accentColor: AppColors.gold,
                isHero: true,
              ),
              SizedBox(width: AppSpacing.lg),
              GlowingMetric(
                label: 'Average Rating',
                value: '4.9',
                unit: '/5.0',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(
    BuildContext context,
    MarketplaceNotifier notifier,
    MarketplaceListing listing,
  ) {
    final discount = listing.discountPercent;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Coach info & Type Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text(
                      listing.coachName.characters.first,
                      style: const TextStyle(color: AppColors.focusBlue, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    listing.coachName,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  if (listing.isCoachVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: AppColors.focusBlue, size: 13),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  listing.specialty.name.split('&').first.trim(),
                  style: const TextStyle(color: AppColors.energyOrange, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title & Hindi Title
          Text(
            listing.title,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            listing.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Description
          Text(
            listing.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Key features bullet points
          ...listing.features.take(2).map((feat) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.karmaGreen, size: 12),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        feat,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.sm),

          // Bottom Bar: Price, Rating & CTA Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '₹${listing.priceInr}',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹${listing.originalPriceInr}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.alertRed.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(color: AppColors.alertRed, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 11),
                      const SizedBox(width: 2),
                      Text(
                        '${listing.rating} (${listing.enrolledCount} enrolled)',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.focusBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                ),
                onPressed: () => _showCheckoutBottomSheet(context, notifier, listing),
                child: Text(
                  listing.type == ListingType.oneOnOneConsultation ? 'Book Slot' : 'Enroll Now',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyListingsCard(MarketplaceNotifier notifier) {
    return BentoCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Column(
            children: [
              const Icon(Icons.search_off, color: AppColors.textSecondary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No listings found matching your search and filters.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.focusBlue),
                onPressed: () => notifier.resetFilters(),
                child: const Text('Clear Filters', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckoutBottomSheet(
    BuildContext context,
    MarketplaceNotifier notifier,
    MarketplaceListing listing,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Confirm Enrollment & Checkout',
                regionalText: 'प्रोग्राम में शामिल होने की पुष्टि करें',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                listing.title,
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text('Instructor: ${listing.coachName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Program Price:', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        Text('₹${listing.priceInr}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Platform Guarantee & Protection:', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        Text('Included (Free)', style: TextStyle(color: AppColors.karmaGreen, fontSize: 11)),
                      ],
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Payable:', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                        Text('₹${listing.priceInr}', style: const TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.karmaGreen,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    notifier.purchaseListing(listing);
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Pay ₹${listing.priceInr} & Start Transformation',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMyOrdersBottomSheet(BuildContext context, MarketplaceState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'My Enrolled Programs & Consultations',
                regionalText: 'मेरे सक्रिय कोर्स व परामर्श',
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.userOrders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(
                    child: Text(
                      'No active enrollments yet. Explore the marketplace to enroll!',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...state.userOrders.map((order) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.listingTitle,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Order #${order.orderId.substring(order.orderId.length - 6)} • ₹${order.amountPaidInr}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.karmaGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: const Text('ACTIVE', style: TextStyle(color: AppColors.karmaGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'FitKarma Creator & Coach Economy',
                regionalText: 'प्रशिक्षक पारिस्थितिकी तंत्र व नीति',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma empowers certified fitness coaches, clinical nutritionists, and Ayurvedic Vaidyas with an 80/20 revenue share. All instructors undergo rigorous credential screening ensuring safe, evidence-based health guidance.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understood', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
