enum SquadRole {
  leader,
  member,
}

enum HealthAlertLevel {
  normal,
  attentionNeeded,
  urgentConsultation,
}

enum ActivityType {
  workoutCompleted,
  mealLogged,
  stepsMilestone,
  streakAchieved,
  karmaTierUnlocked,
}

class Squad {
  final String id;
  final String name;
  final String bio;
  final String? bannerUrl;
  final int streakDays;
  final int totalKarma;
  final List<SquadMember> members;

  const Squad({
    required this.id,
    required this.name,
    required this.bio,
    this.bannerUrl,
    required this.streakDays,
    required this.totalKarma,
    this.members = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bio': bio,
        'banner_url': bannerUrl,
        'streak_days': streakDays,
        'total_karma': totalKarma,
      };
}

class SquadMember {
  final String id;
  final String squadId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final SquadRole role;
  final bool todayLogged;
  final int todayKarma;
  final String? todayCommitment;

  const SquadMember({
    required this.id,
    required this.squadId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.role,
    required this.todayLogged,
    required this.todayKarma,
    this.todayCommitment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'squad_id': squadId,
        'user_id': userId,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'role': role.name,
        'today_logged': todayLogged,
        'today_karma': todayKarma,
        'today_commitment': todayCommitment,
      };
}

class SquadNudge {
  final String senderId;
  final String recipientId;
  final String recipientName;
  final String message;
  final String messageHindi;
  final DateTime sentAt;

  const SquadNudge({
    required this.senderId,
    required this.recipientId,
    required this.recipientName,
    required this.message,
    required this.messageHindi,
    required this.sentAt,
  });
}

class SocialActivityPost {
  final String id;
  final String userId;
  final String authorName;
  final String? authorAvatar;
  final ActivityType activityType;
  final String title;
  final String? description;
  final String? mediaUrl;
  final int karmaEarned;
  final int likesCount;
  final int cheersCount;
  final DateTime createdAt;

  const SocialActivityPost({
    required this.id,
    required this.userId,
    required this.authorName,
    this.authorAvatar,
    required this.activityType,
    required this.title,
    this.description,
    this.mediaUrl,
    required this.karmaEarned,
    required this.likesCount,
    required this.cheersCount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'author_name': authorName,
        'author_avatar': authorAvatar,
        'activity_type': activityType.name,
        'title': title,
        'description': description,
        'media_url': mediaUrl,
        'karma_earned': karmaEarned,
        'likes_count': likesCount,
        'cheers_count': cheersCount,
        'created_at': createdAt.toIso8601String(),
      };
}

class FamilyMemberHealth {
  final String id;
  final String userId;
  final String relativeUserId;
  final String relativeName;
  final String relation; // Mother, Father, Grandparent, Spouse
  final int age;
  final double? latestSystolicBp;
  final double? latestDiastolicBp;
  final double? latestFastingGlucoseMgDl;
  final int? todaySteps;
  final HealthAlertLevel alertLevel;
  final String? alertMessage;
  final String? alertMessageHindi;
  final DateTime updatedAt;

  const FamilyMemberHealth({
    required this.id,
    required this.userId,
    required this.relativeUserId,
    required this.relativeName,
    required this.relation,
    required this.age,
    this.latestSystolicBp,
    this.latestDiastolicBp,
    this.latestFastingGlucoseMgDl,
    this.todaySteps,
    required this.alertLevel,
    this.alertMessage,
    this.alertMessageHindi,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'relative_user_id': relativeUserId,
        'relative_name': relativeName,
        'relation': relation,
        'age': age,
        'latest_systolic_bp': latestSystolicBp,
        'latest_diastolic_bp': latestDiastolicBp,
        'latest_fasting_glucose_mg_dl': latestFastingGlucoseMgDl,
        'today_steps': todaySteps,
        'alert_level': alertLevel.name,
        'alert_message': alertMessage,
        'alert_message_hindi': alertMessageHindi,
        'updated_at': updatedAt.toIso8601String(),
      };
}

class FamilyBlessing {
  final String id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String blessingType; // Pranam, Ashirwad, Chai Cheer, Care Nudge
  final String blessingHindi;
  final DateTime sentAt;

  const FamilyBlessing({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.blessingType,
    required this.blessingHindi,
    required this.sentAt,
  });
}

class SocialClub {
  final String id;
  final String name;
  final String city;
  final String locality;
  final String clubType; // Running, Strength, Yoga, Calisthenics
  final int memberCount;
  final String? bannerUrl;
  final String nextMeetup;
  final String nextMeetupHindi;

  const SocialClub({
    required this.id,
    required this.name,
    required this.city,
    required this.locality,
    required this.clubType,
    required this.memberCount,
    this.bannerUrl,
    required this.nextMeetup,
    required this.nextMeetupHindi,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'locality': locality,
        'club_type': clubType,
        'member_count': memberCount,
        'banner_url': bannerUrl,
        'next_meetup': nextMeetup,
        'next_meetup_hindi': nextMeetupHindi,
      };
}

class LeaderboardRank {
  final int rank;
  final String entityId;
  final String name;
  final String? avatarUrl;
  final int totalKarma;
  final int streakDays;
  final String cohortBadge;
  final bool isCurrentUser;

  const LeaderboardRank({
    required this.rank,
    required this.entityId,
    required this.name,
    this.avatarUrl,
    required this.totalKarma,
    required this.streakDays,
    required this.cohortBadge,
    this.isCurrentUser = false,
  });
}
