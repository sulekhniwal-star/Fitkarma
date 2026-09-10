import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/subscription_models.dart';
import 'providers/subscription_provider.dart';

/// Screen displaying Subscription Tiers, Server-side Entitlement Verification,
/// Paywall Comparison Matrix, and AI Token Quotas.
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'FitKarma Memberships',
          regionalText: 'फिटकर्मा प्रीमियम सदस्यता',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: AppColors.textSecondary),
            tooltip: 'Restore Purchases',
            onPressed: () => notifier.restorePurchases(),
          ),
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSecurityPhilosophyModal(context),
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
              _buildMessageBanner(state.successMessage!, isError: false),
            if (state.errorMessage != null)
              _buildMessageBanner(state.errorMessage!, isError: true),

            // 1. Current Active Tier & Daily AI Quota Bento Card
            _buildCurrentPlanCard(state),
            const SizedBox(height: AppSpacing.md),

            // 2. Billing Cycle Switcher (Monthly vs Annual)
            _buildBillingCycleSelector(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Subscription Tier Selection Cards
            const BilingualLabel(
              primaryText: 'Choose Your Plan',
              regionalText: 'अपनी आवश्यकतानुसार योजना चुनें',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...SubscriptionTier.values.map(
              (tier) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _buildTierCard(context, state, notifier, tier),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // 4. Feature Entitlement Comparison Matrix
            _buildFeaturesMatrix(state),
            const SizedBox(height: AppSpacing.lg),

            // 5. Trust & Server-side Verification Footer
            _buildSecurityFooter(notifier),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBanner(String message, {required bool isError}) {
    final color = isError ? AppColors.alertRed : AppColors.karmaGreen;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
              color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(SubscriptionState state) {
    final tier = state.entitlements.tier;
    final accentColor = Color(tier.accentColorValue);
    final quotaUsed = state.entitlements.dailyAiCallsUsed;
    final quotaMax = tier.dailyAiCallsQuota;
    final progress = (quotaUsed / quotaMax).clamp(0.0, 1.0);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: accentColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tier.isPaid ? Icons.verified : Icons.account_circle,
                        color: accentColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'ACTIVE: ${tier.name.toUpperCase()}',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Text(
                  'Server Verified',
                  style: TextStyle(
                      color: AppColors.karmaGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Daily AI Quota',
                value: '$quotaUsed',
                unit: '/ $quotaMax calls',
                accentColor: accentColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${state.entitlements.status.name.toUpperCase()}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tier.isPaid
                          ? 'Auto-renews: ${state.entitlements.willRenew ? "Yes" : "No"}'
                          : 'Basic features available for lifetime',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingCycleSelector(
      SubscriptionState state, SubscriptionNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusMd,
      ),
      child: Row(
        children: BillingCycle.values.map((cycle) {
          final isSelected = state.selectedBillingCycle == cycle;
          return Expanded(
            child: GestureDetector(
              onTap: () => notifier.selectBillingCycle(cycle),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceElevatedHigh
                      : Colors.transparent,
                  borderRadius: AppRadii.radiusSm,
                  border: isSelected
                      ? Border.all(color: AppColors.focusBlue, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    cycle.name,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context,
    SubscriptionState state,
    SubscriptionNotifier notifier,
    SubscriptionTier tier,
  ) {
    final isCurrentActive = state.entitlements.tier == tier;
    final isSelected = state.selectedTier == tier;
    final isAnnual = state.selectedBillingCycle == BillingCycle.annual;
    final accentColor = Color(tier.accentColorValue);

    final priceStr = tier == SubscriptionTier.free
        ? '₹0 Free Forever'
        : (isAnnual
            ? '₹${tier.annualPriceInr}/year (₹${(tier.annualPriceInr / 12).round()}/mo)'
            : '₹${tier.monthlyPriceInr}/month');

    return GestureDetector(
      onTap: () => notifier.selectTier(tier),
      child: BentoCard(
        border: isSelected
            ? Border.all(color: accentColor, width: 1.5)
            : (isCurrentActive
                ? Border.all(color: AppColors.karmaGreen, width: 1.5)
                : null),
        hasGlow: isSelected,
        glowColor: accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      tier.regionalName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (isCurrentActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.karmaGreen.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusSm,
                      border: Border.all(color: AppColors.karmaGreen, width: 1),
                    ),
                    child: const Text(
                      'CURRENT PLAN',
                      style: TextStyle(
                          color: AppColors.karmaGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else if (tier == SubscriptionTier.pro)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.focusBlue.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: const Text(
                      'MOST POPULAR',
                      style: TextStyle(
                          color: AppColors.focusBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else if (tier == SubscriptionTier.elite)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: const Text(
                      'VIP ALL-ACCESS',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              priceStr,
              style: AppTypography.titleSmall.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${tier.dailyAiCallsQuota} AI Coach queries/day • Full offline engine support',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCurrentActive ? AppColors.surfaceElevated : accentColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                ),
                onPressed: isCurrentActive
                    ? null
                    : () {
                        notifier.upgradeTier(tier);
                      },
                child: state.isLoading && isSelected
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2),
                      )
                    : Text(
                        isCurrentActive
                            ? 'Currently Subscribed'
                            : (tier == SubscriptionTier.free
                                ? 'Downgrade to Free'
                                : 'Select ${tier.name}'),
                        style: TextStyle(
                          color: isCurrentActive
                              ? AppColors.textSecondary
                              : (tier == SubscriptionTier.elite
                                  ? Colors.black
                                  : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesMatrix(SubscriptionState state) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Feature Entitlement Matrix',
            regionalText: 'सुविधाओं की तुलना एवं पात्रता',
          ),
          const SizedBox(height: AppSpacing.md),
          ...EntitlementFeature.values.map((f) {
            final requiredTier = f.minimumTier;
            final isUnlocked =
                _isFeatureUnlocked(state.entitlements.tier, requiredTier);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock_outline,
                    color: isUnlocked
                        ? AppColors.karmaGreen
                        : AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: isUnlocked
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isUnlocked
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          f.regionalName,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(requiredTier.accentColorValue)
                          .withValues(alpha: 0.12),
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: Text(
                      requiredTier.name.split(' ').last.toUpperCase(),
                      style: TextStyle(
                        color: Color(requiredTier.accentColorValue),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _isFeatureUnlocked(
      SubscriptionTier userTier, SubscriptionTier requiredTier) {
    final int userLevel = userTier == SubscriptionTier.free
        ? 0
        : (userTier == SubscriptionTier.pro ? 1 : 2);
    final int reqLevel = requiredTier == SubscriptionTier.free
        ? 0
        : (requiredTier == SubscriptionTier.pro ? 1 : 2);
    return userLevel >= reqLevel;
  }

  Widget _buildSecurityFooter(SubscriptionNotifier notifier) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, color: AppColors.karmaGreen, size: 14),
            SizedBox(width: 6),
            Text(
              'Server-side entitlement verification via RevenueCat',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Subscriptions auto-renew unless cancelled at least 24 hours before the end of the billing period in Google Play / Apple ID settings.',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textSecondary, fontSize: 9),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () => notifier.restorePurchases(),
          child: const Text('Restore Purchases',
              style: TextStyle(color: AppColors.focusBlue, fontSize: 11)),
        ),
      ],
    );
  }

  void _showSecurityPhilosophyModal(BuildContext context) {
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
                primaryText: 'Server-Side Entitlement Security',
                regionalText: 'सर्वर-स्तरीय सुरक्षा एवं प्रमाणीकरण',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma enforces zero client-side self-reporting of premium status. All subscriptions are validated by Firebase Cloud Functions receiving authenticated RevenueCat webhooks, generating cryptographic verification hashes in Firestore.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
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
                  child: const Text('Understood',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
