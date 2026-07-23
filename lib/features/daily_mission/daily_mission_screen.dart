import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/bento_grid.dart';
import 'package:fitkarma/shared/widgets/glowing_metric.dart';
import 'package:fitkarma/shared/widgets/state_widgets.dart';

// Provider to fetch today's Daily Intelligence Package directly from Drift.
// This fulfills the performance requirement (<100ms) by avoiding expensive network or redundant AI calls on startup.
final dailyBriefingProvider =
    FutureProvider.autoDispose<DailyIntelligencePackage?>((ref) async {
      final db = ref.watch(databaseProvider);
      final userId = 'onboarding_user'; // Standard user reference

      final todayStart = DateTime.now().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

      // 1. Instantly check Drift database (local cache)
      final latestPackage =
          await (db.select(db.dailyIntelligencePackages)
                ..where((t) => t.userId.equals(userId))
                ..orderBy([
                  (t) => drift.OrderingTerm(
                    expression: t.packageDate,
                    mode: drift.OrderingMode.desc,
                  ),
                ])
                ..limit(1))
              .getSingleOrNull();

      final isSameDay =
          latestPackage != null &&
          latestPackage.packageDate.year == todayStart.year &&
          latestPackage.packageDate.month == todayStart.month &&
          latestPackage.packageDate.day == todayStart.day;

      if (isSameDay) {
        return latestPackage;
      }

      // 2. Fallback: Trigger generation using HealthOSBrain
      final brain = ref.read(healthOSBrainProvider);
      return await brain.getOrGenerateDIP(userId);
    });

// A provider for the active user name to personalize the greeting.
final userNameProvider = FutureProvider.autoDispose<String>((ref) async {
  final db = ref.watch(databaseProvider);
  final userId = 'onboarding_user';
  final user = await (db.select(
    db.users,
  )..where((t) => t.id.equals(userId))).getSingleOrNull();
  return user?.name ?? 'Arjun';
});

class DailyMissionScreen extends ConsumerWidget {
  const DailyMissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefingAsync = ref.watch(dailyBriefingProvider);
    final userNameAsync = ref.watch(userNameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: briefingAsync.when(
        loading: () => const FitLoadingState(
          message: 'Assembling your daily briefing...',
          hindiMessage: 'आपकी दैनिक ब्रीफिंग तैयार हो रही है...',
        ),
        error: (err, stack) => FitErrorState(
          englishMessage: 'Failed to load daily briefing',
          hindiMessage: 'दैनिक ब्रीफing लोड करने में विफल',
          onRetry: () => ref.refresh(dailyBriefingProvider),
        ),
        data: (dip) {
          if (dip == null) {
            return const FitEmptyState(
              englishTitle: 'No Briefing Available',
              hindiTitle: 'कोई ब्रीफिंग उपलब्ध नहीं है',
              englishSubtitle: 'Complete your check-in or profile to start.',
            );
          }

          // Determine readiness mock score and confidence levels from DIP data
          final recommendedIntensity = dip.recommendedIntensity.toLowerCase();
          final int readinessScore = recommendedIntensity == 'high'
              ? 85
              : (recommendedIntensity == 'medium' ? 72 : 48);

          final String confidenceLabel = recommendedIntensity == 'high'
              ? 'Very high confidence'
              : (recommendedIntensity == 'medium'
                    ? 'High confidence'
                    : 'Medium confidence');

          final String readinessStatus = recommendedIntensity == 'high'
              ? 'Great day for a hard session'
              : (recommendedIntensity == 'medium'
                    ? 'Standard program intensity'
                    : 'Recovery or active rest focus');

          final String name = userNameAsync.value ?? 'Arjun';

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dailyBriefingProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Section (320px, heroDeep gradient) ──
                  Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppColorsDark.heroGradient
                          : const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColorsLight.surface2,
                                AppColorsLight.bg1,
                                AppColorsLight.bg0,
                              ],
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenH,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Good morning, $name 👋',
                            style: AppTypography.displayMd.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),
                          // ReadinessRing (128px)
                          ReadinessRing(
                            score: readinessScore,
                            confidenceLabel: confidenceLabel,
                            size: 128,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${recommendedIntensity.toUpperCase()} · ${confidenceLabel.toUpperCase()}',
                            style: AppTypography.h3.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            readinessStatus,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySm.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Body Panel ──
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Health Score Ring Section
                        BentoCard(
                          child: Row(
                            children: [
                              const HealthScoreRing(score: 82, size: 80),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Health Score',
                                      style: AppTypography.h3.copyWith(
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward_rounded,
                                          color: isDark
                                              ? AppColorsDark.success
                                              : AppColorsLight.success,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '↑ 4 pts from yesterday — Consistency improving',
                                          style: AppTypography.bodySm.copyWith(
                                            color: isDark
                                                ? AppColorsDark.success
                                                : AppColorsLight.success,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.bentoGap),

                        // Conditional Recovery Alert
                        if (readinessScore < 55) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14.0),
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.bentoGap,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? AppColorsDark.error
                                          : AppColorsLight.error)
                                      .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color:
                                    (isDark
                                            ? AppColorsDark.error
                                            : AppColorsLight.error)
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: isDark
                                      ? AppColorsDark.error
                                      : AppColorsLight.error,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Recovery Alert',
                                        style: AppTypography.h3.copyWith(
                                          color: isDark
                                              ? AppColorsDark.error
                                              : AppColorsLight.error,
                                        ),
                                      ),
                                      Text(
                                        'Decision Hierarchy: Recovery priority today',
                                        style: AppTypography.bodySm.copyWith(
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Today's Mission Card
                        BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '🎯',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Today's Mission",
                                    style: AppTypography.h2.copyWith(
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildMissionItem(dip.todaysMission, isDark),
                              const SizedBox(height: 8),
                              _buildMissionItem(dip.nutritionFocus, isDark),
                              const SizedBox(height: 8),
                              _buildMissionItem(dip.recoveryFocus, isDark),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.bentoGap),

                        // Today's Focus Bento Grid
                        BentoGrid(
                          items: [
                            BentoGridItem(
                              columnSpan: 1,
                              rowSpan: 1,
                              child: BentoCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '😴 Sleep Debt',
                                      style: AppTypography.labelLg.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GlowingMetric(
                                      value: '-45',
                                      unit: 'min',
                                      glowColor: isDark
                                          ? AppColorsDark.secondary
                                          : AppColorsLight.secondary,
                                      customStyle: AppTypography.displayMd,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BentoGridItem(
                              columnSpan: 1,
                              rowSpan: 1,
                              child: BentoCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '⚡ Energy',
                                      style: AppTypography.labelLg.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      recommendedIntensity == 'high'
                                          ? 'High'
                                          : 'Moderate',
                                      style: AppTypography.displayMd.copyWith(
                                        color: textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BentoGridItem(
                              columnSpan: 1,
                              rowSpan: 1,
                              child: BentoCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '🔥 Streak',
                                      style: AppTypography.labelLg.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GlowingMetric(
                                      value: '12',
                                      unit: 'days',
                                      glowColor: isDark
                                          ? AppColorsDark.primary
                                          : AppColorsLight.primary,
                                      customStyle: AppTypography.displayMd,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BentoGridItem(
                              columnSpan: 1,
                              rowSpan: 1,
                              child: BentoCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '🏆 Karma Today',
                                      style: AppTypography.labelLg.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GlowingMetric(
                                      value: '+45',
                                      unit: 'XP',
                                      glowColor: isDark
                                          ? AppColorsDark.accent
                                          : AppColorsLight.accent,
                                      customStyle: AppTypography.displayMd,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.bentoGap),

                        // AI Coach Insight Card
                        BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '🤖',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Coach Insight',
                                    style: AppTypography.h2.copyWith(
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                dip.primaryInsight,
                                style: AppTypography.bodyMd.copyWith(
                                  color: textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dip.motivationMessage,
                                style: AppTypography.bodySm.copyWith(
                                  color: primaryColor,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Quick Actions
                        Text(
                          'Quick Actions',
                          style: AppTypography.h2.copyWith(color: textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionButton(
                                context,
                                label: 'Log Breakfast',
                                icon: Icons.restaurant_rounded,
                                color: isDark
                                    ? AppColorsDark.primary
                                    : AppColorsLight.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickActionButton(
                                context,
                                label: 'Start Workout',
                                icon: Icons.play_arrow_rounded,
                                color: isDark
                                    ? AppColorsDark.secondary
                                    : AppColorsLight.secondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickActionButton(
                                context,
                                label: 'Log Water',
                                icon: Icons.water_drop_rounded,
                                color: isDark
                                    ? AppColorsDark.teal
                                    : AppColorsLight.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionItem(String text, bool isDark) {
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 8.0),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: isDark ? AppColorsDark.primary : AppColorsLight.primary,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Triggered action: $label'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelMd.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Paint ReadinessRing Widget matching the style specs (128px circular score representation)
class ReadinessRing extends StatelessWidget {
  const ReadinessRing({
    super.key,
    required this.score,
    required this.confidenceLabel,
    required this.size,
  });

  final int score;
  final String confidenceLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final secondaryColor = isDark
        ? AppColorsDark.secondary
        : AppColorsLight.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              score: score,
              primaryColor: primaryColor,
              trackColor: isDark
                  ? AppColorsDark.surface0
                  : AppColorsLight.surface2,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: AppTypography.metricLg.copyWith(
                  color: isDark
                      ? AppColorsDark.textPrimary
                      : AppColorsLight.textPrimary,
                  fontWeight: FontWeight.w900,
                  shadows: isDark
                      ? [
                          Shadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: secondaryColor.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  confidenceLabel.split(' ').first.toUpperCase(),
                  style: AppTypography.labelMd.copyWith(
                    color: secondaryColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
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

// Custom Paint HealthScoreRing Widget
class HealthScoreRing extends StatelessWidget {
  const HealthScoreRing({super.key, required this.score, required this.size});

  final int score;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tealColor = isDark ? AppColorsDark.teal : AppColorsLight.teal;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              score: score,
              primaryColor: tealColor,
              trackColor: isDark
                  ? AppColorsDark.surface0
                  : AppColorsLight.surface2,
            ),
          ),
          Text(
            '$score',
            style: AppTypography.h1.copyWith(
              color: isDark
                  ? AppColorsDark.textPrimary
                  : AppColorsLight.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.score,
    required this.primaryColor,
    required this.trackColor,
  });

  final int score;
  final Color primaryColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paintTrack = Paint()
      ..color = trackColor
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    final paintArc = Paint()
      ..color = primaryColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    canvas.drawCircle(center, radius, paintTrack);

    final double sweepAngle = 2 * 3.1415926535 * (score / 100.0);
    // Draw the progress arc starting from the top (-pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2,
      sweepAngle,
      false,
      paintArc..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
