import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/glucose/glucose_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class GlucoseScreen extends ConsumerWidget {
  const GlucoseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(glucoseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final errorColor = isDark ? AppColorsDark.error : AppColorsLight.error;
    final successColor = isDark
        ? AppColorsDark.success
        : AppColorsLight.success;

    if (!state.isUnlocked) {
      return _buildLockScreen(
        context,
        ref,
        state,
        bgColor,
        cardBg,
        textPrimary,
        textSecondary,
        primaryColor,
        errorColor,
      );
    }

    // HbA1c progress calculation: pre-diabetic threshold is 5.7%
    // Maximum expected HbA1c representation range: e.g. 4.0% to 8.0%
    final double hba1cMin = 4.0;
    final double hba1cMax = 8.0;
    final double progressFraction =
        ((state.estimatedHba1c - hba1cMin) / (hba1cMax - hba1cMin)).clamp(
          0.0,
          1.0,
        );
    final isPreDiabetic = state.estimatedHba1c >= 5.7;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Blood Glucose',
          style: AppTypography.h3.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            key: const Key('glucose_lock_button'),
            icon: Icon(Icons.lock_rounded, color: textSecondary),
            onPressed: () => ref.read(glucoseProvider.notifier).resetLock(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Fasting & Post-Meal Dual Bento Grid Cards
                  Row(
                    children: [
                      // Fasting Card
                      Expanded(
                        child: BentoCard(
                          customBgColor: cardBg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fasting',
                                style: AppTypography.bodySm.copyWith(
                                  color: textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${state.fastingGlucose.round()} mg/dL',
                                style: AppTypography.h2.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _getFastingCategory(state.fastingGlucose),
                                style: AppTypography.bodySm.copyWith(
                                  color: _getFastingColor(
                                    state.fastingGlucose,
                                    successColor,
                                    errorColor,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.bentoGap),
                      // Post-Meal Card
                      Expanded(
                        child: BentoCard(
                          customBgColor: cardBg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post-Meal',
                                style: AppTypography.bodySm.copyWith(
                                  color: textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${state.postMealGlucose.round()} mg/dL',
                                style: AppTypography.h2.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _getPostMealCategory(state.postMealGlucose),
                                style: AppTypography.bodySm.copyWith(
                                  color: _getPostMealColor(
                                    state.postMealGlucose,
                                    successColor,
                                    errorColor,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 2. Estimated HbA1c Section
                  BentoCard(
                    customBgColor: cardBg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated HbA1c',
                              style: AppTypography.bodyMd.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.estimatedHba1c.toStringAsFixed(1)}%',
                              style: AppTypography.h3.copyWith(
                                color: isPreDiabetic
                                    ? Colors.orange
                                    : successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isPreDiabetic
                              ? 'Pre-diabetic Threshold: 5.7%'
                              : 'Normal Metabolic Health range',
                          style: AppTypography.bodySm.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Progress bar representating HbA1c
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progressFraction,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isPreDiabetic
                                      ? [Colors.orange, errorColor]
                                      : [successColor, accentColor],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 3. History List Section
                  BentoCard(
                    customBgColor: cardBg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glucose Response History',
                          style: AppTypography.h3.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (state.history.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No glucose records logged yet.',
                                style: AppTypography.bodyMd.copyWith(
                                  color: textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.history.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.white10),
                            itemBuilder: (context, index) {
                              final item = state.history[index];
                              final isFasting = item.mealTag == 'Fasting';
                              final cat = isFasting
                                  ? _getFastingCategory(item.valueMgDl)
                                  : _getPostMealCategory(item.valueMgDl);
                              final catColor = isFasting
                                  ? _getFastingColor(
                                      item.valueMgDl,
                                      successColor,
                                      errorColor,
                                    )
                                  : _getPostMealColor(
                                      item.valueMgDl,
                                      successColor,
                                      errorColor,
                                    );

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.valueMgDl.round()} mg/dL',
                                          style: AppTypography.bodyLg.copyWith(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          cat,
                                          style: AppTypography.bodySm.copyWith(
                                            color: catColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.mealTag,
                                          style: AppTypography.labelMd.copyWith(
                                            color: textSecondary,
                                          ),
                                        ),
                                        Text(
                                          '${item.measuredAt.day}/${item.measuredAt.month}',
                                          style: AppTypography.labelMd.copyWith(
                                            color: textSecondary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Log Entry Button
                  ElevatedButton.icon(
                    key: const Key('glucose_log_manual_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => _showManualEntrySheet(context, ref),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      'Log Blood Glucose',
                      style: AppTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLockScreen(
    BuildContext context,
    WidgetRef ref,
    GlucoseState state,
    Color bgColor,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
    Color primaryColor,
    Color errorColor,
  ) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.shield_rounded, size: 72, color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Sensitive Vitals Locked',
                  textAlign: TextAlign.center,
                  style: AppTypography.h2.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Biometric authentication or backup PIN is required.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMd.copyWith(color: textSecondary),
                ),
                const SizedBox(height: 32),

                // Biometrics Simulator Button
                ElevatedButton.icon(
                  key: const Key('glucose_biometric_simulate_button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardBg,
                    foregroundColor: textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showBiometricDialog(context, ref),
                  icon: const Icon(Icons.fingerprint_rounded),
                  label: const Text('Authenticate with FaceID/TouchID'),
                ),
                const SizedBox(height: 24),

                // PIN indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: index < state.pinInput.length
                            ? primaryColor
                            : Colors.white12,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (state.isPinError)
                  Text(
                    'Invalid PIN. Try again.',
                    key: const Key('glucose_pin_error_text'),
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySm.copyWith(
                      color: errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 24),

                // PIN Grid Keys
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return IconButton(
                        icon: Icon(Icons.backspace_rounded, color: textPrimary),
                        onPressed: () =>
                            ref.read(glucoseProvider.notifier).clearPin(),
                      );
                    }
                    if (index == 11) {
                      return const SizedBox.shrink();
                    }
                    final digit = index == 10 ? '0' : '${index + 1}';
                    return ElevatedButton(
                      key: Key('glucose_pin_key_$digit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cardBg,
                        foregroundColor: textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => ref
                          .read(glucoseProvider.notifier)
                          .enterPinDigit(digit),
                      child: Text(
                        digit,
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBiometricDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1E2C),
          title: const Text(
            'Simulated Biometrics',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Simulate system biometric authentication check.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              key: const Key('glucose_biometric_fail'),
              onPressed: () {
                ref
                    .read(glucoseProvider.notifier)
                    .authenticateBiometrics(false);
                Navigator.pop(context);
              },
              child: const Text(
                'Fail',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              key: const Key('glucose_biometric_success'),
              onPressed: () {
                ref.read(glucoseProvider.notifier).authenticateBiometrics(true);
                Navigator.pop(context);
              },
              child: const Text(
                'Success',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getFastingCategory(double val) {
    if (val < 100) return 'Normal';
    if (val >= 100 && val < 126) return 'Prediabetes';
    return 'Diabetes';
  }

  Color _getFastingColor(double val, Color normal, Color alert) {
    if (val < 100) return normal;
    if (val >= 100 && val < 126) return Colors.orange;
    return alert;
  }

  String _getPostMealCategory(double val) {
    if (val < 140) return 'Normal';
    if (val >= 140 && val < 200) return 'Elevated';
    return 'Diabetes';
  }

  Color _getPostMealColor(double val, Color normal, Color alert) {
    if (val < 140) return normal;
    if (val >= 140 && val < 200) return Colors.orange;
    return alert;
  }

  void _showManualEntrySheet(BuildContext context, WidgetRef ref) {
    final TextEditingController valController = TextEditingController(
      text: '100',
    );
    String selectedTag = 'Fasting';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
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
                    'Log Blood Glucose',
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: valController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Glucose Level (mg/dL)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Meal Period Tag',
                    style: AppTypography.bodySm.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF1C1A2E),
                    value: selectedTag,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    underline: Container(height: 1, color: Colors.white24),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'Fasting',
                        child: Text('Fasting'),
                      ),
                      DropdownMenuItem(
                        value: 'Pre-Meal',
                        child: Text('Pre-Meal'),
                      ),
                      DropdownMenuItem(
                        value: 'Post-Meal (1-hour)',
                        child: Text('Post-Meal (1-hour)'),
                      ),
                      DropdownMenuItem(
                        value: 'Post-Meal (2-hour)',
                        child: Text('Post-Meal (2-hour)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setStateSheet(() {
                          selectedTag = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    key: const Key('glucose_save_log_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsDark.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final val = double.tryParse(valController.text) ?? 100.0;
                      ref
                          .read(glucoseProvider.notifier)
                          .addGlucoseReading(val, selectedTag);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save Record',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
