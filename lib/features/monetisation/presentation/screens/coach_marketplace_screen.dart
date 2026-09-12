import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/monetisation/domain/models/monetisation_models.dart';
import 'package:fitkarma/features/monetisation/domain/services/coach_marketplace_engine.dart';

class CoachMarketplaceScreen extends ConsumerStatefulWidget {
  const CoachMarketplaceScreen({super.key});

  @override
  ConsumerState<CoachMarketplaceScreen> createState() => _CoachMarketplaceScreenState();
}

class _CoachMarketplaceScreenState extends ConsumerState<CoachMarketplaceScreen> {
  final _coachEngine = const CoachMarketplaceEngine();
  CoachSpecialty? _selectedSpecialty;

  @override
  Widget build(BuildContext context) {
    final coaches = _coachEngine.filterCoaches(specialty: _selectedSpecialty);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Verified Coach Marketplace', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Specialty Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('ALL SPECIALTIES'),
                      selected: _selectedSpecialty == null,
                      selectedColor: AppColors.primaryEmerald,
                      backgroundColor: AppColors.surfaceCard,
                      labelStyle: TextStyle(
                        color: _selectedSpecialty == null ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedSpecialty = null);
                      },
                    ),
                  ),
                  ...CoachSpecialty.values.map((s) {
                    final isSelected = _selectedSpecialty == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s.name.toUpperCase()),
                        selected: isSelected,
                        selectedColor: AppColors.primaryEmerald,
                        backgroundColor: AppColors.surfaceCard,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedSpecialty = s);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Coach List
            ...coaches.map((coach) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BentoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(coach.name, style: AppTypography.h3),
                                Text(coach.title, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryCyan)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.accentAmber, size: 18),
                              const SizedBox(width: 4),
                              Text('${coach.rating}', style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
                              Text(' (${coach.reviewCount})', style: AppTypography.bilingualSub),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(coach.bio, style: AppTypography.bodyMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: coach.languages.map((l) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceGlass,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l, style: AppTypography.bilingualSub),
                          );
                        }).toList(),
                      ),
                      const Divider(color: AppColors.borderGlass, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('₹${coach.hourlyRateInr}/session', style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryEmerald,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Consultation booked with ${coach.name}!'),
                                  backgroundColor: AppColors.primaryEmerald,
                                ),
                              );
                            },
                            child: Text('Book Consultation', style: AppTypography.label.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
