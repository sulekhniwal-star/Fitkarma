/// §P5-I Micronutrient Dashboard UI
///
/// Micronutrient Intelligence Core dashboard displaying overall 8-biomarker RDA coverage gauge,
/// cohort-specific deficiency risk alert banners, 8 biomarker progress bars (Iron, B12, D3, Calcium, Magnesium, Zinc, Folate, Omega-3),
/// and Indian food sources quick reference guide.
library;

import 'package:fitkarma/features/food/micronutrient_controller.dart';
import 'package:fitkarma/features/food/micronutrient_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0E0F14);
const _surfaceColor = Color(0xFF1A1C26);
const _cardColor = Color(0xFF222434);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentRed = Color(0xFFF87171);
const _accentBlue = Color(0xFF60A5FA);
const _accentYellow = Color(0xFFFBBF24);
const _accentPurple = Color(0xFFA78BFA);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2D2F45);

class MicronutrientDashboardScreen extends ConsumerWidget {
  const MicronutrientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(micronutrientProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Micronutrient Core 2.0',
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Demographics Selector Chips ──
              _DemographicsBar(state: state),

              const SizedBox(height: 14),

              // ── Overall Coverage Gauge Card ──
              _CoverageGaugeCard(state: state),

              const SizedBox(height: 16),

              // ── Deficiency Risk Alert Banners ──
              if (state.activeAlerts.isNotEmpty) ...[
                const Text(
                  'Cohort Deficiency Risk Warnings',
                  style: TextStyle(
                    color: _textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                for (final alert in state.activeAlerts) ...[
                  _AlertCard(alert: alert),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 12),
              ],

              // ── 8 Biomarker RDA Progress Grid ──
              const Text(
                'Essential 8 Biomarker Progress',
                style: TextStyle(
                  color: _textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              _BiomarkerProgressRow(
                name: 'Iron (Non-Heme 1.8x)',
                current: state.summary.ironMg,
                target: state.rdaConfig.ironMg,
                unit: 'mg',
                icon: Icons.opacity_rounded,
                color: _accentRed,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Vitamin B12 (Crucial)',
                current: state.summary.vitaminB12Mcg,
                target: state.rdaConfig.vitaminB12Mcg,
                unit: 'mcg',
                icon: Icons.electric_bolt_rounded,
                color: _accentPurple,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Vitamin D3 (Sunlight & Fortified)',
                current: state.summary.vitaminD3Iu,
                target: state.rdaConfig.vitaminD3Iu,
                unit: 'IU',
                icon: Icons.wb_sunny_rounded,
                color: _accentYellow,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Calcium (Bone Density)',
                current: state.summary.calciumMg,
                target: state.rdaConfig.calciumMg,
                unit: 'mg',
                icon: Icons.fitness_center_rounded,
                color: _accentBlue,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Magnesium (Insulin & Recovery)',
                current: state.summary.magnesiumMg,
                target: state.rdaConfig.magnesiumMg,
                unit: 'mg',
                icon: Icons.spa_rounded,
                color: _accentGreen,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Zinc (Immunity)',
                current: state.summary.zincMg,
                target: state.rdaConfig.zincMg,
                unit: 'mg',
                icon: Icons.shield_rounded,
                color: _accentOrange,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Folate (Cell Division)',
                current: state.summary.folateMcg,
                target: state.rdaConfig.folateMcg,
                unit: 'mcg',
                icon: Icons.eco_rounded,
                color: _accentGreen,
              ),
              const SizedBox(height: 8),
              _BiomarkerProgressRow(
                name: 'Omega-3 (Anti-Inflammatory)',
                current: state.summary.omega3G,
                target: state.rdaConfig.omega3G,
                unit: 'g',
                icon: Icons.water_drop_rounded,
                color: _accentBlue,
              ),

              const SizedBox(height: 20),

              // ── Indian Food Sources Guide Card ──
              const _IndianFoodSourcesGuideCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DemographicsBar extends ConsumerWidget {
  const _DemographicsBar({required this.state});

  final MicronutrientState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(micronutrientProvider.notifier);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          key: const Key('micro_chip_veg'),
          label: const Text('🥗 Vegetarian (1.8x Iron & B12)'),
          selected: state.isVegetarian,
          onSelected: (val) => notifier.updateDemographics(isVegetarian: val),
          selectedColor: _accentGreen.withAlpha(40),
          backgroundColor: _surfaceColor,
          checkmarkColor: _accentGreen,
          labelStyle: TextStyle(
            color: state.isVegetarian ? _accentGreen : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: state.isVegetarian ? _accentGreen : _borderColor,
            ),
          ),
        ),
        FilterChip(
          key: const Key('micro_chip_female'),
          label: const Text('👩 Female Target (21mg Iron)'),
          selected: state.isFemale,
          onSelected: (val) => notifier.updateDemographics(isFemale: val),
          selectedColor: _accentPurple.withAlpha(40),
          backgroundColor: _surfaceColor,
          checkmarkColor: _accentPurple,
          labelStyle: TextStyle(
            color: state.isFemale ? _accentPurple : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: state.isFemale ? _accentPurple : _borderColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CoverageGaugeCard extends StatelessWidget {
  const _CoverageGaugeCard({required this.state});

  final MicronutrientState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: state.overallCoveragePct / 100.0,
                  backgroundColor: _borderColor,
                  valueColor: AlwaysStoppedAnimation(
                    state.overallCoveragePct >= 80.0
                        ? _accentGreen
                        : (state.overallCoveragePct >= 50.0
                              ? _accentYellow
                              : _accentRed),
                  ),
                  strokeWidth: 8,
                ),
                Center(
                  child: Text(
                    '${state.overallCoveragePct.round()}%',
                    key: const Key('micro_overall_coverage_pct'),
                    style: const TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Micronutrient Coverage',
                  style: TextStyle(
                    color: _textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.activeAlerts.isEmpty
                      ? '🟢 All 8 essential biomarker RDA targets on track!'
                      : '⚠️ ${state.activeAlerts.length} deficiency risk warning(s) detected.',
                  style: TextStyle(
                    color: state.activeAlerts.isEmpty
                        ? _accentGreen
                        : _accentYellow,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final MicroAlert alert;

  Color get _color {
    return switch (alert.severity) {
      MicroAlertSeverity.high => _accentRed,
      MicroAlertSeverity.medium => _accentYellow,
      MicroAlertSeverity.low => _accentBlue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('micro_alert_card_${alert.affectedNutrient.name}'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _color.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: _color, size: 18),
              const SizedBox(width: 8),
              Text(
                alert.title,
                style: TextStyle(
                  color: _color,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            alert.message,
            style: const TextStyle(color: _textPrimary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates_rounded,
                color: _accentGreen,
                size: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  alert.recommendation,
                  style: const TextStyle(
                    color: _accentGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BiomarkerProgressRow extends StatelessWidget {
  const _BiomarkerProgressRow({
    required this.name,
    required this.current,
    required this.target,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String name;
  final double current;
  final double target;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = (current / (target > 0 ? target : 1)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _surfaceColor,
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
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '${current.toStringAsFixed(1)} / ${target.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  color: color,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _borderColor,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndianFoodSourcesGuideCard extends StatelessWidget {
  const _IndianFoodSourcesGuideCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                color: _accentOrange,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'High-Yield Indian Food Sources',
                style: TextStyle(
                  color: _textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _FoodSourceItem(
            nutrient: 'Iron',
            sources: 'Spinach (Palak), Soya Chunks, Black Chana, Jaggery',
          ),
          _FoodSourceItem(
            nutrient: 'B12',
            sources: 'Whole Milk Curd, Paneer, Fortified Milk, Eggs',
          ),
          _FoodSourceItem(
            nutrient: 'Calcium',
            sources: 'Curd, Paneer, Til (Sesame Seeds), Ragi Atta',
          ),
          _FoodSourceItem(
            nutrient: 'Omega-3',
            sources: 'Flaxseeds (Alsi), Walnuts, Mustard Oil, Fish',
          ),
        ],
      ),
    );
  }
}

class _FoodSourceItem extends StatelessWidget {
  const _FoodSourceItem({required this.nutrient, required this.sources});

  final String nutrient;
  final String sources;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$nutrient: ',
              style: const TextStyle(
                color: _accentOrange,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: sources,
              style: const TextStyle(color: _textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
