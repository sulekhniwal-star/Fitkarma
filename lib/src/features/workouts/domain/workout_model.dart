enum WorkoutCategory {
  yoga,
  bollywood,
  desi,
  hiit,
  gym,
  sports,
  cardio,
}

enum WorkoutDifficulty {
  beginner,
  intermediate,
  advanced,
}

class WorkoutModel {
  final String id;
  final String title;
  final String titleHindi;
  final String description;
  final WorkoutCategory category;
  final WorkoutDifficulty difficulty;
  final int durationMinutes;
  final int caloriesBurned;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? instructions;
  final List<String> equipmentNeeded;
  final bool isPremium;
  final int karmaCost;
  final List<String> benefits;
  final List<String>? contraindications;
  final String? youtubeVideoId;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.videoUrl,
    this.thumbnailUrl,
    this.instructions,
    this.equipmentNeeded = const [],
    this.isPremium = false,
    this.karmaCost = 0,
    this.benefits = const [],
    this.contraindications,
    this.youtubeVideoId,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleHindi: json['title_hindi'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: WorkoutCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => WorkoutCategory.yoga,
      ),
      difficulty: WorkoutDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => WorkoutDifficulty.beginner,
      ),
      durationMinutes: json['duration_mins'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail'] as String?,
      instructions: json['instructions'] as String?,
      equipmentNeeded: (json['equipment_needed'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isPremium: json['is_premium'] as bool? ?? false,
      karmaCost: json['karma_cost'] as int? ?? 0,
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      contraindications: (json['contraindications'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      youtubeVideoId: json['youtube_video_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_hindi': titleHindi,
      'description': description,
      'category': category.name,
      'difficulty': difficulty.name,
      'duration_mins': durationMinutes,
      'calories_burned': caloriesBurned,
      'video_url': videoUrl,
      'thumbnail': thumbnailUrl,
      'instructions': instructions,
      'equipment_needed': equipmentNeeded,
      'is_premium': isPremium,
      'karma_cost': karmaCost,
      'benefits': benefits,
      'contraindications': contraindications,
      'youtube_video_id': youtubeVideoId,
    };
  }

  String get categoryDisplayName {
    switch (category) {
      case WorkoutCategory.yoga:
        return 'Yoga';
      case WorkoutCategory.bollywood:
        return 'Bollywood Dance';
      case WorkoutCategory.desi:
        return 'Desi Workouts';
      case WorkoutCategory.hiit:
        return 'Home HIIT';
      case WorkoutCategory.gym:
        return 'Gym';
      case WorkoutCategory.sports:
        return 'Indian Sports';
      case WorkoutCategory.cardio:
        return 'Cardio';
    }
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get durationDisplay {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    } else {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
  }
}

class WorkoutLog {
  final String id;
  final String oderId;
  final String workoutId;
  final DateTime date;
  final int durationMinutes;
  final int caloriesBurned;
  final double heartRateAvg;
  final String note;
  final int rating;

  const WorkoutLog({
    required this.id,
    required this.oderId,
    required this.workoutId,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.heartRateAvg = 0,
    this.note = '',
    this.rating = 0,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'] as String? ?? '',
      oderId: json['user'] as String? ?? '',
      workoutId: json['workout'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: json['duration_mins'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      heartRateAvg: (json['heart_rate_avg'] as num?)?.toDouble() ?? 0,
      note: json['note'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': oderId,
      'workout': workoutId,
      'date': date.toIso8601String(),
      'duration_mins': durationMinutes,
      'calories_burned': caloriesBurned,
      'heart_rate_avg': heartRateAvg,
      'note': note,
      'rating': rating,
    };
  }
}
