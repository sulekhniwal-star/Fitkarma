import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/models/social_models.dart';
import '../../domain/services/squad_accountability_engine.dart';

class SquadDetailScreen extends StatefulWidget {
  final Squad squad;

  const SquadDetailScreen({
    super.key,
    required this.squad,
  });

  @override
  State<SquadDetailScreen> createState() => _SquadDetailScreenState();
}

class _SquadDetailScreenState extends State<SquadDetailScreen> {
  final _engine = const SquadAccountabilityEngine();

  @override
  Widget build(BuildContext context) {
    final adherence = _engine.calculateSquadDailyAdherence(widget.squad.members);
    final multiplier = _engine.calculateSquadStreakMultiplier(widget.squad.streakDays);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Text(widget.squad.name, style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Squad Stats Header
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Squad Streak', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                          Text('${widget.squad.streakDays} Days', style: AppTypography.h2.copyWith(color: AppColors.primaryEmerald)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryCyan),
                        ),
                        child: Text('${multiplier}x Multiplier', style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Today\'s Completion', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                      Text('${(adherence * 100).toInt()}%', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: adherence,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceCard,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Members Roster
            Text('Squad Roster & Micro-Commitments', style: AppTypography.h3),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.squad.members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final member = widget.squad.members[index];
                return BentoCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: member.todayLogged ? AppColors.primaryEmerald.withAlpha(30) : AppColors.surfaceCard,
                        child: Icon(
                          member.todayLogged ? Icons.check : Icons.access_time_rounded,
                          color: member.todayLogged ? AppColors.primaryEmerald : AppColors.accentAmber,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(member.displayName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                if (member.role == SquadRole.leader) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(color: AppColors.accentAmber.withAlpha(30), borderRadius: BorderRadius.circular(4)),
                                    child: Text('Leader', style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.accentAmber)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              member.todayCommitment ?? (member.todayLogged ? 'Logged today\'s mission' : 'Pending log for today'),
                              style: AppTypography.bodySmall.copyWith(color: member.todayLogged ? AppColors.textSecondary : AppColors.accentAmber),
                            ),
                          ],
                        ),
                      ),
                      if (!member.todayLogged)
                        TextButton(
                          onPressed: () {
                            final nudges = _engine.generatePendingNudges(
                              senderId: 'demo-user-001',
                              members: [member],
                              currentTime: DateTime.now(),
                            );
                            if (nudges.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Nudge sent to ${member.displayName}: "${nudges.first.messageHindi}"'),
                                  backgroundColor: AppColors.primaryCyan,
                                ),
                              );
                            }
                          },
                          child: Text('Nudge 👉', style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
