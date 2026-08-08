import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/squad_state_provider.dart';

/// §P9-A Social Screen
/// Route: /social
class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(squadStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        title: Text('Squad Accountability Hub', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nudge status banner if present
              if (state.nudgeMessage.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    state.nudgeMessage,
                    style: AppTypography.bodySm.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 1. Squad Overview Header BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.squadName, style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '🔥 ${state.collectiveStreakDays}-Day Squad Streak',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.teal, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'Team Avg Readiness: ${state.averageReadinessScore.toStringAsFixed(1)}%',
                          style: AppTypography.labelLg.copyWith(color: AppColors.teal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Active Squad Mission Card
              if (state.activeMission != null) ...[
                Text('Active Squad Mission', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.activeMission!.missionTitle, style: AppTypography.labelLg),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: state.activeMission!.progressPercent,
                        backgroundColor: AppColors.bg0,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.activeMission!.targetStatusText,
                        style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 3. Squad Member Readiness & Activity List
              Text('Squad Members (${state.members.length})', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Column(
                children: [
                  for (final member in state.members)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: member.readinessTier == SquadReadinessTier.high
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : member.readinessTier == SquadReadinessTier.moderate
                                      ? AppColors.warning.withValues(alpha: 0.2)
                                      : AppColors.error.withValues(alpha: 0.2),
                              child: Text(
                                member.name.substring(0, 1),
                                style: AppTypography.labelLg.copyWith(
                                  color: member.readinessTier == SquadReadinessTier.high
                                      ? AppColors.success
                                      : member.readinessTier == SquadReadinessTier.moderate
                                          ? AppColors.warning
                                          : AppColors.error,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(member.name, style: AppTypography.labelLg),
                                  Text(
                                    'Readiness: ${member.readinessTier.name.toUpperCase()} • ${member.hasLoggedToday ? "Logged Today" : "Not Logged"}',
                                    style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            if (member.readinessTier == SquadReadinessTier.low)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.warning,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  ref.read(squadStateProvider.notifier).sendSquadNudge(member.name, 'Rest & Recover');
                                },
                                child: Text('Nudge to Rest', style: AppTypography.labelSmall.copyWith(color: Colors.black)),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. Propose Challenge Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                  onPressed: () {
                    ref.read(squadStateProvider.notifier).proposeChallenge('🔥 100,000 Step Squad Challenge');
                  },
                  label: Text('Propose Squad Challenge', style: AppTypography.labelLg.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
