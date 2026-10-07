import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/providers/hydration_provider.dart';
import '../../domain/models/hydration_models.dart';

class HydrationTrackerScreen extends ConsumerWidget {
  const HydrationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationProvider);
    final notifier = ref.read(hydrationProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const BilingualLabel(
          english: 'Hydration Tracker',
          hindi: 'पानी का ट्रैकर',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero water progress card
            BentoCard(
              isGlowing: hydration.isGoalMet,
              glowColor: const Color(0xFF00B4D8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              english: "Today's Water Intake",
                              hindi: 'आज का पानी',
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: (hydration.consumedMl / 1000).toStringAsFixed(1),
                                    style: AppTypography.heroMetric.copyWith(
                                      fontSize: 40,
                                      color: const Color(0xFF00B4D8),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${(hydration.goalMl / 1000).toStringAsFixed(1)} L',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Animated water drop icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00B4D8).withAlpha(30),
                          border: Border.all(
                            color: const Color(0xFF00B4D8).withAlpha(100),
                          ),
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          size: 32,
                          color: Color(0xFF00B4D8),
                        ),
                      ).animate(
                        onPlay: (ctrl) => ctrl.repeat(reverse: true),
                      ).scale(
                        duration: 1200.ms,
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.05, 1.05),
                        curve: Curves.easeInOut,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: hydration.progressFraction,
                      backgroundColor: AppColors.surfaceDark,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        hydration.isGoalMet
                            ? AppColors.primaryEmerald
                            : const Color(0xFF00B4D8),
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hydration.isGoalMet
                        ? '✅ Goal achieved! Aap bahut achha kar rahe ho!'
                        : '💧 ${(hydration.remainingMl / 1000).toStringAsFixed(1)}L remaining to hit goal',
                    style: AppTypography.bodySmall.copyWith(
                      color: hydration.isGoalMet
                          ? AppColors.primaryEmerald
                          : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Hydration tip
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF00B4D8).withAlpha(60)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      notifier.hydrationTip,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Quick-add grid
            Text('Quick Add', style: AppTypography.h3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: HydrationGoalEngine.quickAddOptions.map((opt) {
                return InkWell(
                  onTap: () {
                    notifier.logWater(amountMl: opt.ml.toDouble());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${opt.emoji} +${opt.ml}ml logged!',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        backgroundColor: AppColors.surfaceCard,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(opt.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          opt.label,
                          style: AppTypography.label.copyWith(
                            fontSize: 10,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${opt.ml}ml',
                          style: AppTypography.label.copyWith(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Today's logs
            if (hydration.logs.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Log", style: AppTypography.h3),
                  TextButton.icon(
                    onPressed: notifier.removeLastLog,
                    icon: const Icon(Icons.undo, size: 14, color: AppColors.accentCoral),
                    label: Text(
                      'Undo Last',
                      style: AppTypography.label.copyWith(color: AppColors.accentCoral),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...hydration.logs.reversed.take(8).map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlass,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  child: Row(
                    children: [
                      Text(log.source.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.source.label,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _formatTime(log.loggedAt),
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+${log.amountMl.toInt()}ml',
                        style: AppTypography.label.copyWith(
                          color: const Color(0xFF00B4D8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
