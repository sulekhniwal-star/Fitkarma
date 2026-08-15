import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/blood_pressure_engine.dart';
import '../providers/blood_pressure_provider.dart';

/// §P4-D Blood Pressure Screen
/// Route: /health/bp | Biometric Lock Required
class BloodPressureScreen extends ConsumerStatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  ConsumerState<BloodPressureScreen> createState() =>
      _BloodPressureScreenState();
}

class _BloodPressureScreenState extends ConsumerState<BloodPressureScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric prompt on mount
    Future.microtask(() {
      ref.read(bloodPressureProvider.notifier).authenticateWithBiometrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bloodPressureProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Blood Pressure', style: AppTypography.h2),
        actions: [
          if (state.lockStatus == BiometricLockStatus.unlocked)
            IconButton(
              icon: const Icon(Icons.lock_outline,
                  color: AppColors.textSecondary, size: 20),
              onPressed: () =>
                  ref.read(bloodPressureProvider.notifier).lockScreen(),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBodyForLockStatus(state),
      ),
    );
  }

  Widget _buildBodyForLockStatus(BloodPressureState state) {
    switch (state.lockStatus) {
      case BiometricLockStatus.locked:
      case BiometricLockStatus.authenticating:
        return _BiometricPromptView(
          isAuthenticating:
              state.lockStatus == BiometricLockStatus.authenticating,
          onAuthenticate: () => ref
              .read(bloodPressureProvider.notifier)
              .authenticateWithBiometrics(),
          onUsePin: () => ref
              .read(bloodPressureProvider.notifier)
              .authenticateWithBiometrics(simulateSuccess: false),
        );
      case BiometricLockStatus.failed:
        return _PinFallbackView(
          pinInput: state.pinInput,
          hasError: state.pinError,
          onDigitTap: (d) =>
              ref.read(bloodPressureProvider.notifier).appendPinDigit(d),
          onDeleteTap: () =>
              ref.read(bloodPressureProvider.notifier).deletePinDigit(),
          onRetryBiometric: () => ref
              .read(bloodPressureProvider.notifier)
              .authenticateWithBiometrics(),
        );
      case BiometricLockStatus.unlocked:
        return _UnlockedBpContentView(
          latest: state.latest,
          history: state.history,
          warningMessage: state.warningMessage,
          onLogNewReading: () => _showLogReadingDialog(context),
        );
    }
  }

  void _showLogReadingDialog(BuildContext context) {
    final sysController = TextEditingController(text: '120');
    final diaController = TextEditingController(text: '80');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Blood Pressure', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Systolic (mmHg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: diaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Diastolic (mmHg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final sys = int.tryParse(sysController.text) ?? 120;
                    final dia = int.tryParse(diaController.text) ?? 80;
                    ref.read(bloodPressureProvider.notifier).logBloodPressure(
                          systolic: sys,
                          diastolic: dia,
                        );
                    Navigator.pop(ctx);
                  },
                  child: Text('Save Reading',
                      style:
                          AppTypography.labelLg.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Biometric Authentication Prompt View ──────────────────────────────────────

class _BiometricPromptView extends StatelessWidget {
  final bool isAuthenticating;
  final VoidCallback onAuthenticate;
  final VoidCallback onUsePin;

  const _BiometricPromptView({
    required this.isAuthenticating,
    required this.onAuthenticate,
    required this.onUsePin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                child: const Icon(Icons.fingerprint,
                    color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Biometric Verification Required',
                  style: AppTypography.h3, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Unlock sensitive health records using Face ID, Fingerprint, or PIN.',
                style: AppTypography.bodySm,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (isAuthenticating)
                const CircularProgressIndicator(color: AppColors.primary)
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onAuthenticate,
                    child: Text('Unlock with Biometrics',
                        style: AppTypography.labelLg
                            .copyWith(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onUsePin,
                  child: Text('Use 6-Digit Backup PIN',
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.textSecondary)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── PIN Fallback Keypad View ──────────────────────────────────────────────────

class _PinFallbackView extends StatelessWidget {
  final String pinInput;
  final bool hasError;
  final ValueChanged<String> onDigitTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onRetryBiometric;

  const _PinFallbackView({
    required this.pinInput,
    required this.hasError,
    required this.onDigitTap,
    required this.onDeleteTap,
    required this.onRetryBiometric,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, color: AppColors.secondary, size: 36),
            const SizedBox(height: AppSpacing.sm),
            Text('Enter Backup PIN', style: AppTypography.h3),
            const SizedBox(height: 4),
            Text('Default test PIN: 123456',
                style: AppTypography.bodySm.copyWith(fontSize: 11)),
            const SizedBox(height: AppSpacing.lg),

            // PIN Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final filled = i < pinInput.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasError
                        ? AppColors.error
                        : (filled ? AppColors.secondary : AppColors.surface2),
                    border: Border.all(
                      color: hasError ? AppColors.error : AppColors.secondary,
                    ),
                  ),
                );
              }),
            ),
            if (hasError) ...[
              const SizedBox(height: 8),
              Text('Incorrect PIN. Try again.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.error)),
            ],
            const SizedBox(height: AppSpacing.xl),

            // Numeric Keypad
            SizedBox(
              width: 240,
              child: Column(
                children: [
                  for (final row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                  ])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row
                          .map((digit) => _KeypadButton(
                              text: digit, onTap: () => onDigitTap(digit)))
                          .toList(),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _KeypadButton(
                        icon: Icons.fingerprint,
                        onTap: onRetryBiometric,
                      ),
                      _KeypadButton(text: '0', onTap: () => onDigitTap('0')),
                      _KeypadButton(
                        icon: Icons.backspace_outlined,
                        onTap: onDeleteTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;

  const _KeypadButton({this.text, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      width: 60,
      height: 60,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface1,
            border: Border.all(color: AppColors.glassBorder),
          ),
          alignment: Alignment.center,
          child: text != null
              ? Text(text!, style: AppTypography.h3)
              : Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

// ── Unlocked Content View ─────────────────────────────────────────────────────

class _UnlockedBpContentView extends StatelessWidget {
  final BloodPressureRecord? latest;
  final List<BloodPressureRecord> history;
  final String? warningMessage;
  final VoidCallback onLogNewReading;

  const _UnlockedBpContentView({
    required this.latest,
    required this.history,
    required this.warningMessage,
    required this.onLogNewReading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Latest Reading Card ───────────────────────────────────────────
          if (latest != null) ...[
            _LatestReadingCard(latest: latest!),
            const SizedBox(height: AppSpacing.lg),
          ],

          // ── Warning Alert Card ───────────────────────────────────────────
          if (warningMessage != null) ...[
            _BpWarningCard(message: warningMessage!),
            const SizedBox(height: AppSpacing.lg),
          ],

          // ── Systolic / Diastolic History Chart (30 Days) ─────────────────
          _BpHistoryChartCard(history: history),
          const SizedBox(height: AppSpacing.lg),

          // ── Log Reading Button ───────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
              ),
              onPressed: onLogNewReading,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Log New Reading',
                  style: AppTypography.labelLg.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Latest Reading Card ───────────────────────────────────────────────────────

class _LatestReadingCard extends StatelessWidget {
  final BloodPressureRecord latest;
  const _LatestReadingCard({required this.latest});

  Color get _categoryColor {
    switch (latest.category) {
      case BpCategory.normal:
        return AppColors.success;
      case BpCategory.elevated:
        return AppColors.warning;
      case BpCategory.stage1:
        return AppColors.primary;
      case BpCategory.stage2:
        return AppColors.rose;
      case BpCategory.crisis:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Latest Reading', style: AppTypography.bodySm),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: _categoryColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  latest.category.label,
                  style: AppTypography.labelMd
                      .copyWith(color: _categoryColor, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            latest.readingLabel,
            style: AppTypography.metricLg.copyWith(color: _categoryColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Recorded: ${_formatRecordedTime(latest.measuredAt)} (${latest.recordingMethod.label})',
            style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            latest.category.guidance,
            style: AppTypography.bodySm.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  String _formatRecordedTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 1) return 'Today, ${dt.minute}m ago';
    if (diff.inHours < 24)
      return 'Today, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    return '${dt.day}/${dt.month} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ── Warning Alert Card ────────────────────────────────────────────────────────

class _BpWarningCard extends StatelessWidget {
  final String message;
  const _BpWarningCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.error, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Systolic / Diastolic History Line Chart (30 Days) ─────────────────────────

class _BpHistoryChartCard extends StatelessWidget {
  final List<BloodPressureRecord> history;
  const _BpHistoryChartCard({required this.history});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Systolic / Diastolic History', style: AppTypography.h3),
          const SizedBox(height: 4),
          Row(
            children: [
              _LegendDot(color: AppColors.primary, label: 'Systolic'),
              const SizedBox(width: 14),
              _LegendDot(color: AppColors.teal, label: 'Diastolic'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 140,
            child: CustomPaint(
              size: const Size(double.infinity, 140),
              painter: _BpDualLinePainter(history: history),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _BpDualLinePainter extends CustomPainter {
  final List<BloodPressureRecord> history;

  _BpDualLinePainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final sorted = List<BloodPressureRecord>.from(history)
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    const minVal = 60.0;
    const maxVal = 160.0;
    const range = maxVal - minVal;

    final n = sorted.length;
    final step = n > 1 ? size.width / (n - 1) : size.width;

    Offset ptSys(int i) {
      final x = n > 1 ? i * step : size.width / 2;
      final norm = (sorted[i].systolic - minVal) / range;
      final y = size.height - (norm * size.height);
      return Offset(x, y.clamp(0.0, size.height));
    }

    Offset ptDia(int i) {
      final x = n > 1 ? i * step : size.width / 2;
      final norm = (sorted[i].diastolic - minVal) / range;
      final y = size.height - (norm * size.height);
      return Offset(x, y.clamp(0.0, size.height));
    }

    // Grid lines (80, 120, 140)
    final gridPaint = Paint()
      ..color = const Color(0x1AFFFFFF)
      ..strokeWidth = 0.5;

    for (final val in [80.0, 120.0, 140.0]) {
      final norm = (val - minVal) / range;
      final y = size.height - (norm * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '${val.toInt()}',
          style: const TextStyle(color: Color(0xFF6B68A0), fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4, y - 10));
    }

    final sysPath = Path();
    final diaPath = Path();

    sysPath.moveTo(ptSys(0).dx, ptSys(0).dy);
    diaPath.moveTo(ptDia(0).dx, ptDia(0).dy);

    for (int i = 1; i < n; i++) {
      sysPath.lineTo(ptSys(i).dx, ptSys(i).dy);
      diaPath.lineTo(ptDia(i).dx, ptDia(i).dy);
    }

    final sysPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final diaPaint = Paint()
      ..color = AppColors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(sysPath, sysPaint);
    canvas.drawPath(diaPath, diaPaint);

    // Render points
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(ptSys(i), 3.5, Paint()..color = AppColors.primary);
      canvas.drawCircle(ptDia(i), 3.5, Paint()..color = AppColors.teal);
    }
  }

  @override
  bool shouldRepaint(covariant _BpDualLinePainter old) =>
      old.history != history;
}
