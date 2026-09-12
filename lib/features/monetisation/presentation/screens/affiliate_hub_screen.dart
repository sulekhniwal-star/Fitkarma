import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/monetisation/domain/services/affiliate_engine.dart';

class AffiliateHubScreen extends ConsumerStatefulWidget {
  const AffiliateHubScreen({super.key});

  @override
  ConsumerState<AffiliateHubScreen> createState() => _AffiliateHubScreenState();
}

class _AffiliateHubScreenState extends ConsumerState<AffiliateHubScreen> {
  final _affiliateEngine = const AffiliateEngine();
  final String _userName = 'Vikram';
  late String _referralCode;

  @override
  void initState() {
    super.initState();
    _referralCode = _affiliateEngine.generateReferralCode(_userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Creator & Yogi Affiliates', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Referral Hero Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.primaryEmerald,
              isGlowing: true,
              child: Column(
                children: [
                  Text('YOUR EXCLUSIVE REFERRAL CODE', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassHover,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.5)),
                    ),
                    child: Text(_referralCode, style: AppTypography.heroMetric.copyWith(fontSize: 32, letterSpacing: 2)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Share with friends & community. They get 10% off; you earn 500 Karma + ₹200 commission per Pro subscriber!',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Earnings Stats Bento Grid
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL KARMA', style: AppTypography.label),
                        const SizedBox(height: 4),
                        Text('3,500', style: AppTypography.h1.copyWith(color: AppColors.accentAmber)),
                        Text('7 Friends Joined', style: AppTypography.bilingualSub),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('COMMISSIONS', style: AppTypography.label),
                        const SizedBox(height: 4),
                        Text('₹1,400', style: AppTypography.h1.copyWith(color: AppColors.primaryEmerald)),
                        Text('Paid via UPI', style: AppTypography.bilingualSub),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tier Reward Breakdown
            Text('Affiliate Commission Matrix', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildRewardItem('Pro Annual / Monthly', '500 Karma + ₹200 INR per signup', AppColors.primaryCyan),
            const SizedBox(height: 8),
            _buildRewardItem('Elite Coaching Membership', '1,500 Karma + ₹500 INR per signup', AppColors.primaryEmerald),
            const SizedBox(height: 8),
            _buildRewardItem('Free Yogi App Install', '100 Karma points per referral', AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String title, String reward, Color accent) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h3),
                const SizedBox(height: 2),
                Text(reward, style: AppTypography.bodySmall.copyWith(color: accent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
