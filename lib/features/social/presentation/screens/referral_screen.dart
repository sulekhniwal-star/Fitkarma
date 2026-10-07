import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class ReferralScreen extends StatefulWidget {
  final String userReferralCode;

  const ReferralScreen({
    super.key,
    this.userReferralCode = 'KARMA-ROHIT-88',
  });

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _copied = false;
  final int _friendsJoined = 2;
  final int _targetFriends = 5;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.userReferralCode));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied to clipboard!'),
        backgroundColor: AppColors.primaryEmerald,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _shareViaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening WhatsApp: "Hey! Track Indian meals & workouts on FitKarma. Use my code ${widget.userReferralCode} for 7 days Free Pro!"',
        ),
        backgroundColor: AppColors.primaryEmerald,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Invite Friends & Sangha',
          hindi: 'मित्रों को जोड़ें और कमाएं',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryCyan.withAlpha(40),
                    AppColors.primaryEmerald.withAlpha(30),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryCyan.withAlpha(80)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard, color: AppColors.primaryEmerald, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Give 7 Days Pro, Get 7 Days Pro',
                    style: AppTypography.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Whenever a friend signs up with your code, both of you unlock FitKarma Pro access for free!',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Referral Code Box
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryCyan,
              child: Column(
                children: [
                  Text('YOUR EXCLUSIVE REFERRAL CODE', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryCyan.withAlpha(120), style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.userReferralCode,
                          style: AppTypography.heroMetric.copyWith(fontSize: 22, color: AppColors.primaryCyan, letterSpacing: 1.5),
                        ),
                        IconButton(
                          icon: Icon(
                            _copied ? Icons.check : Icons.copy_rounded,
                            color: _copied ? AppColors.primaryEmerald : AppColors.primaryCyan,
                          ),
                          onPressed: _copyCode,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _shareViaWhatsApp,
                      icon: const Icon(Icons.share, size: 18),
                      label: Text(
                        'Share via WhatsApp / व्हाट्सएप',
                        style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Milestone Tracker
            Text('Sangha Reward Milestones', style: AppTypography.h3),
            const SizedBox(height: 10),
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_friendsJoined of $_targetFriends Friends Invited', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      Text('${((_friendsJoined / _targetFriends) * 100).toInt()}% Complete', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _friendsJoined / _targetFriends,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMilestoneRow(
                    icon: Icons.looks_one,
                    title: '1 Friend: 7 Days Free Pro',
                    status: 'Unlocked ✅',
                    isUnlocked: true,
                  ),
                  const SizedBox(height: 10),
                  _buildMilestoneRow(
                    icon: Icons.looks_3,
                    title: '3 Friends: 1 Month Pro + AI Coach Review',
                    status: '1 more friend needed',
                    isUnlocked: false,
                  ),
                  const SizedBox(height: 10),
                  _buildMilestoneRow(
                    icon: Icons.looks_5,
                    title: '5 Friends: FitKarma Stainless Steel Shaker Bottle',
                    status: '3 more friends needed',
                    isUnlocked: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Friends Joined List
            Text('Friends in Your Sangha (2)', style: AppTypography.h3),
            const SizedBox(height: 10),
            _buildFriendTile('Aarav Mehta', 'Joined 2 days ago', 'Active Yogi • Day 3 Streak'),
            const SizedBox(height: 8),
            _buildFriendTile('Priya Sharma', 'Joined yesterday', 'Active Yogi • Day 2 Streak'),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneRow({
    required IconData icon,
    required String title,
    required String status,
    required bool isUnlocked,
  }) {
    return Row(
      children: [
        Icon(icon, color: isUnlocked ? AppColors.primaryEmerald : AppColors.textMuted, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              Text(
                status,
                style: AppTypography.label.copyWith(
                  fontSize: 10,
                  color: isUnlocked ? AppColors.primaryEmerald : AppColors.accentAmber,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFriendTile(String name, String time, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryCyan.withAlpha(40),
            child: Text(name[0], style: const TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                Text(sub, style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.primaryEmerald)),
              ],
            ),
          ),
          Text(time, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
