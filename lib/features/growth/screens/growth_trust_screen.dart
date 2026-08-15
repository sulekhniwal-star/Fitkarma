import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/growth_model.dart';
import '../providers/growth_provider.dart';

class GrowthTrustScreen extends ConsumerWidget {
  const GrowthTrustScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(growthProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title:
            Text('India Growth & Trust Layer', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WhatsApp Cloud API Integration Switch Card
              GlassCard(
                child: SwitchListTile(
                  title: Text('WhatsApp Business Cloud Assistant',
                      style: AppTypography.titleMedium),
                  subtitle: Text(
                      'Log meals & workouts via WhatsApp voice notes (Off by default)',
                      style: AppTypography.labelSmall),
                  value: state.isWhatsappOptedIn,
                  activeThumbColor: AppColors.primaryEmerald,
                  onChanged: (_) =>
                      ref.read(growthProvider.notifier).toggleWhatsappOptIn(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Vernacular ASR Voice Parser Language Selector
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vernacular ASR Voice Language',
                        style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: VernacularLanguage.values.map((lang) {
                        final isSelected = state.selectedLanguage == lang;
                        return ChoiceChip(
                          label: Text(lang.name.toUpperCase()),
                          selected: isSelected,
                          selectedColor: AppColors.primaryCyan,
                          backgroundColor: AppColors.bgSecondary,
                          onSelected: (_) => ref
                              .read(growthProvider.notifier)
                              .selectLanguage(lang),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ABHA Health ID OAuth Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ABHA Health ID (ABDM OAuth)',
                            style: AppTypography.titleMedium),
                        Text('Encrypted ID: ${state.abhaAccount.abhaNumber}',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text('FHIR-Lite Active',
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.primaryEmerald)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Grocery Vendor Adapters Section
              Text('Quick-Commerce Grocery Cart Adapters',
                  style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.vendorAdapters.map(
                (vendor) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(vendor.partnerName,
                            style: AppTypography.titleMedium),
                        const Icon(Icons.shopping_cart,
                            color: AppColors.primaryCyan),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
