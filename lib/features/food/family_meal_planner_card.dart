/// §P5-Q Family Meal Planner UI Display Card
///
/// Interactive UI Card displaying unified family meal header (*Palak Paneer + Multigrain Rotis + Curd + Salad*),
/// clinical safety badge ("🟢 Diabetic Safe - Low GI"), and per-member portion guide cards (Father, Mother, Child).
library;

import 'package:fitkarma/features/food/family_meal_planner_controller.dart';
import 'package:fitkarma/features/food/family_meal_planner_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _surfaceColor = Color(0xFF1B1D2A);
const _cardBgColor = Color(0xFF24273A);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentBlue = Color(0xFF60A5FA);
const _accentYellow = Color(0xFFFBBF24);
const _accentPurple = Color(0xFFA78BFA);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2E324A);

class FamilyMealPlannerCard extends ConsumerWidget {
  const FamilyMealPlannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyMealPlannerProvider);
    final meal = state.currentUnifiedMeal;

    return Container(
      key: const Key('family_meal_planner_card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header & Clinical Safety Badge ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accentPurple.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.family_restroom_rounded,
                  color: _accentPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unified Family Dinner 🍲',
                      style: TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${meal.totalFamilyPortions} Family Members • ${meal.totalCalories.round()} kcal Total',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Clinical Safety Banner ──
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accentGreen.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accentGreen.withAlpha(100)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.health_and_safety_rounded,
                  color: _accentGreen,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    meal.clinicalSummary,
                    key: const Key('family_clinical_summary_text'),
                    style: const TextStyle(
                      color: _accentGreen,
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Base Dish Title ──
          Text(
            meal.baseRecipeName,
            style: const TextStyle(
              color: _accentYellow,
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),
          const Divider(color: _borderColor, height: 1),
          const SizedBox(height: 12),

          // ── Per-Member Portion Guide Cards ──
          const Text(
            'Per-Member Portion & Clinical Guides',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          ...meal.memberPortions.values.map((guide) {
            return _MemberPortionTile(guide: guide);
          }),
        ],
      ),
    );
  }
}

class _MemberPortionTile extends StatelessWidget {
  const _MemberPortionTile({required this.guide});

  final MemberPortionGuide guide;

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(guide.role);

    return Container(
      key: Key('member_portion_tile_${guide.role}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    guide.memberName,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${guide.baseMultiplier}x Serving',
                      style: TextStyle(
                        color: roleColor,
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${guide.allocatedCalories.round()} kcal',
                style: const TextStyle(
                  color: _accentOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            guide.customInstructions,
            style: const TextStyle(color: _textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    final lc = role.toLowerCase();
    if (lc.contains('father')) return _accentBlue;
    if (lc.contains('mother')) return _accentPurple;
    if (lc.contains('child')) return _accentGreen;
    return _accentYellow;
  }
}
