enum MissionCategory { steps, workout, nutrition, hydration, recovery }

class DailyMissionItem {
  final String id;
  final String title;
  final String regionalTitle;
  final String targetSubtitle;
  final int karmaReward;
  final MissionCategory category;
  final bool isCompleted;

  const DailyMissionItem({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.targetSubtitle,
    required this.karmaReward,
    required this.category,
    this.isCompleted = false,
  });

  DailyMissionItem copyWith({
    String? id,
    String? title,
    String? regionalTitle,
    String? targetSubtitle,
    int? karmaReward,
    MissionCategory? category,
    bool? isCompleted,
  }) {
    return DailyMissionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      regionalTitle: regionalTitle ?? this.regionalTitle,
      targetSubtitle: targetSubtitle ?? this.targetSubtitle,
      karmaReward: karmaReward ?? this.karmaReward,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory DailyMissionItem.fromMap(Map<String, dynamic> map) {
    final catName = map['category'] as String? ?? 'steps';
    final category = MissionCategory.values.firstWhere(
      (e) => e.name == catName,
      orElse: () => MissionCategory.steps,
    );

    return DailyMissionItem(
      id: map['id'] as String? ?? 'mission_steps',
      title: map['title'] as String? ?? 'Daily Steps',
      regionalTitle: map['regionalTitle'] as String? ?? 'दैनिक कदम',
      targetSubtitle: map['targetSubtitle'] as String? ?? 'Target: 8,000 steps',
      karmaReward: (map['karmaReward'] as num?)?.toInt() ?? 10,
      category: category,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'regionalTitle': regionalTitle,
      'targetSubtitle': targetSubtitle,
      'karmaReward': karmaReward,
      'category': category.name,
      'isCompleted': isCompleted,
    };
  }
}
