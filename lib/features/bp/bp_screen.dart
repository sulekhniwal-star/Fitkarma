import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/bp/bp_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class BpScreen extends ConsumerWidget {
  const BpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bpProvider);
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
          'Blood Pressure',
          style: AppTypography.h3.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            key: const Key('bp_lock_button'),
            icon: Icon(Icons.lock_rounded, color: textSecondary),
            onPressed: () => ref.read(bpProvider.notifier).resetLock(),
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
                  // 1. Latest Reading Card
                  BentoCard(
                    customBgColor: cardBg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Reading',
                          style: AppTypography.bodySm.copyWith(
                            color: textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${state.latestSystolic} / ${state.latestDiastolic} mmHg',
                          style: AppTypography.h1.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getBpCategory(
                            state.latestSystolic,
                            state.latestDiastolic,
                          ),
                          style: AppTypography.bodyMd.copyWith(
                            color: _getBpColor(
                              state.latestSystolic,
                              state.latestDiastolic,
                              successColor,
                              errorColor,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 2. Warning Card (Triggered if 3 consecutive readings are rising)
                  if (state.showWarning)
                    Container(
                      key: const Key('bp_warning_card'),
                      decoration: BoxDecoration(
                        color: errorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: errorColor.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: errorColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'WARNING',
                                style: AppTypography.labelMd.copyWith(
                                  color: errorColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Warning: 3 rising BP readings recorded. Limit caffeine and record again tonight.',
                            style: AppTypography.bodyMd.copyWith(
                              color: textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state.showWarning)
                    const SizedBox(height: AppSpacing.bentoGap),

                  // 3. History Section
                  BentoCard(
                    customBgColor: cardBg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Systolic / Diastolic History (30 Days)',
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
                                'No records logged yet.',
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
                                          '${item.systolic}/${item.diastolic} mmHg',
                                          style: AppTypography.bodyLg.copyWith(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _getBpCategory(
                                            item.systolic,
                                            item.diastolic,
                                          ),
                                          style: AppTypography.bodySm.copyWith(
                                            color: _getBpColor(
                                              item.systolic,
                                              item.diastolic,
                                              successColor,
                                              errorColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${item.measuredAt.day}/${item.measuredAt.month} ${item.recordingMethod}',
                                      style: AppTypography.labelMd.copyWith(
                                        color: textSecondary,
                                      ),
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
                    key: const Key('bp_log_manual_button'),
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
                      'Record Blood Pressure',
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
    BpState state,
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
                  key: const Key('bp_biometric_simulate_button'),
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
                    key: const Key('bp_pin_error_text'),
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
                            ref.read(bpProvider.notifier).clearPin(),
                      );
                    }
                    if (index == 11) {
                      return const SizedBox.shrink();
                    }
                    final digit = index == 10 ? '0' : '${index + 1}';
                    return ElevatedButton(
                      key: Key('bp_pin_key_$digit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cardBg,
                        foregroundColor: textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          ref.read(bpProvider.notifier).enterPinDigit(digit),
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
              key: const Key('bp_biometric_fail'),
              onPressed: () {
                ref.read(bpProvider.notifier).authenticateBiometrics(false);
                Navigator.pop(context);
              },
              child: const Text(
                'Fail',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              key: const Key('bp_biometric_success'),
              onPressed: () {
                ref.read(bpProvider.notifier).authenticateBiometrics(true);
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

  String _getBpCategory(int sys, int dia) {
    if (sys < 120 && dia < 80) return 'Normal';
    if (sys >= 120 && sys < 130 && dia < 80) return 'Elevated';
    if ((sys >= 130 && sys < 140) || (dia >= 80 && dia < 90))
      return 'Hypertension Stage 1';
    return 'Hypertension Stage 2';
  }

  Color _getBpColor(int sys, int dia, Color normal, Color alert) {
    if (sys < 120 && dia < 80) return normal;
    if (sys >= 120 && sys < 130 && dia < 80) return Colors.orangeAccent;
    return alert;
  }

  void _showManualEntrySheet(BuildContext context, WidgetRef ref) {
    final TextEditingController sysController = TextEditingController(
      text: '120',
    );
    final TextEditingController diaController = TextEditingController(
      text: '80',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1A2E),
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
                'Record Blood Pressure',
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: sysController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Systolic (mmHg)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: diaController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Diastolic (mmHg)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('bp_save_log_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final sys = int.tryParse(sysController.text) ?? 120;
                  final dia = int.tryParse(diaController.text) ?? 80;

                  ref
                      .read(bpProvider.notifier)
                      .addBpReading(sys, dia, 'manual');
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
  }
}
