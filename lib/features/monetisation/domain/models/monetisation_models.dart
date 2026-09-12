enum AppSubscriptionTier {
  free,
  pro,
  elite,
  corporate,
}

enum CoachSpecialty {
  pcosRemission,
  diabetesReversal,
  ayurvedicStrength,
  postpartumRecovery,
  cardiometabolicHealth,
}

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class UserEntitlement {
  final String id;
  final String userId;
  final AppSubscriptionTier tier;
  final String source; // 'revenuecat', 'razorpay', 'corporate_sso'
  final DateTime? expiresAt;
  final bool isActive;
  final DateTime createdAt;

  const UserEntitlement({
    required this.id,
    required this.userId,
    required this.tier,
    required this.source,
    this.expiresAt,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'tier': tier.name,
        'source': source,
        'expires_at': expiresAt?.toIso8601String(),
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };
}

class CoachProfile {
  final String id;
  final String name;
  final String title;
  final CoachSpecialty specialty;
  final String bio;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final int hourlyRateInr;
  final String? avatarUrl;

  const CoachProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.languages,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRateInr,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'specialty': specialty.name,
        'bio': bio,
        'languages': languages,
        'rating': rating,
        'review_count': reviewCount,
        'hourly_rate_inr': hourlyRateInr,
        'avatar_url': avatarUrl,
      };
}

class CoachBooking {
  final String id;
  final String userId;
  final String coachId;
  final DateTime scheduledAt;
  final BookingStatus status;
  final int amountInr;
  final DateTime createdAt;

  const CoachBooking({
    required this.id,
    required this.userId,
    required this.coachId,
    required this.scheduledAt,
    this.status = BookingStatus.pending,
    required this.amountInr,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coach_id': coachId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'status': status.name,
        'amount_inr': amountInr,
        'created_at': createdAt.toIso8601String(),
      };
}

class AffiliateReferral {
  final String id;
  final String referrerId;
  final String referralCode;
  final String refereeUserId;
  final int karmaReward;
  final int commissionInr;
  final DateTime createdAt;

  const AffiliateReferral({
    required this.id,
    required this.referrerId,
    required this.referralCode,
    required this.refereeUserId,
    required this.karmaReward,
    required this.commissionInr,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'referrer_id': referrerId,
        'referral_code': referralCode,
        'referee_user_id': refereeUserId,
        'karma_reward': karmaReward,
        'commission_inr': commissionInr,
        'created_at': createdAt.toIso8601String(),
      };
}
