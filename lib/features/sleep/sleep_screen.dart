import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/sleep/sleep_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium Deep Indigo Theme
    final bgColor = isDark ? const Color(0xFF0F0C20) : const Color(0xFFECEBFC);
    final gradientColor = isDark
        ? const Color(0xFF1E1A3C)
        : const Color(0xFFD6D4FA);
    final cardBg = isDark ? const Color(0xFF181530) : const Color(0xFFFFFFFF);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1B2D);
    final textSecondary = isDark
        ? const Color(0xFFA5A3C7)
        : const Color(0xFF676585);
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final successColor = isDark
        ? AppColorsDark.success
        : AppColorsLight.success;

    final hours = state.sleepMinutes ~/ 60;
    final minutes = state.sleepMinutes % 60;

    // Calculate percentages
    final int totalStages =
        state.awakeMinutes +
        state.remMinutes +
        state.lightMinutes +
        state.deepMinutes;
    final double total = totalStages > 0 ? totalStages.toDouble() : 1.0;
    final double awakePct = state.awakeMinutes / total;
    final double remPct = state.remMinutes / total;
    final double lightPct = state.lightMinutes / total;
    final double deepPct = state.deepMinutes / total;

    // Stars rating calculation
    final int stars = (state.sleepQuality / 20).round().clamp(1, 5);

    // Sleep debt description
    final isDebtPositive = state.sleepDebtMinutes > 0;
    final debtLabel = isDebtPositive
        ? '${state.sleepDebtMinutes}m (High)'
        : '${state.sleepDebtMinutes.abs()}m (Low)';
    final debtColor = isDebtPositive ? Colors.orange : successColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, gradientColor],
          ),
        ),
        child: SafeArea(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: textPrimary,
                            ),
                            onPressed: () => context.pop(),
                          ),
                          Text(
                            'Sleep OS',
                            style: AppTypography.h3.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 48), // Spacer
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 1. Last Night Card
                      BentoCard(
                        customBgColor: cardBg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LAST NIGHT',
                              style: AppTypography.labelMd.copyWith(
                                color: textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${hours}h ${minutes}m',
                              style: AppTypography.h1.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: Normal',
                              style: AppTypography.bodyMd.copyWith(
                                color: successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(color: Colors.white12, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quality',
                                      style: AppTypography.bodySm.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          index < stars
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Sleep Debt',
                                      style: AppTypography.bodySm.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isDebtPositive
                                          ? '+$debtLabel'
                                          : '-$debtLabel',
                                      style: AppTypography.bodyMd.copyWith(
                                        color: debtColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.bentoGap),

                      // 2. Sleep Stages Card
                      BentoCard(
                        customBgColor: cardBg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sleep Stages',
                              style: AppTypography.h3.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Segmented Bar Chart representing Sleep Stages
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 24,
                                child: Row(
                                  children: [
                                    if (awakePct > 0)
                                      Expanded(
                                        flex: (awakePct * 100).round(),
                                        child: Container(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    if (remPct > 0)
                                      Expanded(
                                        flex: (remPct * 100).round(),
                                        child: Container(
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    if (lightPct > 0)
                                      Expanded(
                                        flex: (lightPct * 100).round(),
                                        child: Container(
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                    if (deepPct > 0)
                                      Expanded(
                                        flex: (deepPct * 100).round(),
                                        child: Container(color: primaryColor),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Legend Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStageLegend(
                                  'Awake',
                                  '${(awakePct * 100).round()}%',
                                  Colors.redAccent,
                                ),
                                _buildStageLegend(
                                  'REM',
                                  '${(remPct * 100).round()}%',
                                  Colors.purpleAccent,
                                ),
                                _buildStageLegend(
                                  'Light',
                                  '${(lightPct * 100).round()}%',
                                  Colors.indigoAccent,
                                ),
                                _buildStageLegend(
                                  'Deep',
                                  '${(deepPct * 100).round()}%',
                                  primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.bentoGap),

                      // 3. 7-Day HRV Trend (Wearable)
                      BentoCard(
                        customBgColor: cardBg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7-Day HRV Trend (Wearable)',
                              style: AppTypography.h3.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Visual Representation of HRV readings
                            SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: state.hrvTrend.map((hrv) {
                                  final double hrvFraction = (hrv / 100.0)
                                      .clamp(0.1, 1.0);
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${hrv.round()}ms',
                                        style: AppTypography.labelMd.copyWith(
                                          color: textPrimary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 16,
                                        height: 60 * hrvFraction,
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 4. Log Sleep Button
                      ElevatedButton.icon(
                        key: const Key('sleep_log_manual_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () => _showManualEntrySheet(context, ref),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          'Log Night\'s Sleep',
                          style: AppTypography.bodyLg.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStageLegend(String label, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColorsDark.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showManualEntrySheet(BuildContext context, WidgetRef ref) {
    final TextEditingController durationController = TextEditingController(
      text: '480',
    );
    final TextEditingController qualityController = TextEditingController(
      text: '80',
    );
    final TextEditingController hrvController = TextEditingController(
      text: '65',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181530),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Log Night\'s Sleep',
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qualityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Sleep Quality (1-100)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hrvController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'HRV (ms)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('sleep_save_log_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final dur = int.tryParse(durationController.text) ?? 480;
                  final qual = int.tryParse(qualityController.text) ?? 80;
                  final hrvVal = double.tryParse(hrvController.text) ?? 65.0;

                  // Compute balanced stage divisions (Awake: 5%, REM: 20%, Light: 55%, Deep: 20%)
                  final awake = (dur * 0.05).round();
                  final rem = (dur * 0.20).round();
                  final light = (dur * 0.55).round();
                  final deep = dur - (awake + rem + light);

                  ref
                      .read(sleepProvider.notifier)
                      .addSleepLog(
                        durationMinutes: dur,
                        awakeMinutes: awake,
                        remMinutes: rem,
                        lightMinutes: light,
                        deepMinutes: deep,
                        quality: qual,
                        hrv: hrvVal,
                        date: DateTime.now(),
                      );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save Entry',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
