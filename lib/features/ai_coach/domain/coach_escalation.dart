enum EscalationReason {
  medicalBoundary(name: 'Medical / Injury Precaution', regionalName: 'चिकित्सीय सावधानी'),
  advancedContestPrep(name: 'Elite Periodization / Contest Prep', regionalName: 'उन्नत प्रतियोगिता तैयारी'),
  userRequested(name: 'Direct Human Consultation', regionalName: 'प्रमाणित कोच से सीधा परामर्श');

  final String name;
  final String regionalName;

  const EscalationReason({required this.name, required this.regionalName});
}

enum EscalationStatus { pendingReview, assigned, completed }

class CoachHandoverDossier {
  final String userName;
  final int age;
  final String sex;
  final double weightKg;
  final double heightCm;
  final double bmi;
  final String primaryGoal;
  final String dosha;
  final int readinessScore;
  final double rolling14DayHrvMs;
  final double averageSleepHours;
  final String summaryNotes;
  final DateTime generatedAt;

  const CoachHandoverDossier({
    required this.userName,
    required this.age,
    required this.sex,
    required this.weightKg,
    required this.heightCm,
    required this.bmi,
    required this.primaryGoal,
    required this.dosha,
    required this.readinessScore,
    required this.rolling14DayHrvMs,
    required this.averageSleepHours,
    required this.summaryNotes,
    required this.generatedAt,
  });

  factory CoachHandoverDossier.fromMap(Map<String, dynamic> map) {
    return CoachHandoverDossier(
      userName: map['userName'] as String? ?? 'User',
      age: (map['age'] as num?)?.toInt() ?? 28,
      sex: map['sex'] as String? ?? 'Male',
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 70.0,
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 175.0,
      bmi: (map['bmi'] as num?)?.toDouble() ?? 22.8,
      primaryGoal: map['primaryGoal'] as String? ?? 'General Fitness',
      dosha: map['dosha'] as String? ?? 'Pitta',
      readinessScore: (map['readinessScore'] as num?)?.toInt() ?? 75,
      rolling14DayHrvMs: (map['rolling14DayHrvMs'] as num?)?.toDouble() ?? 55.0,
      averageSleepHours: (map['averageSleepHours'] as num?)?.toDouble() ?? 7.5,
      summaryNotes: map['summaryNotes'] as String? ?? '',
      generatedAt: map['generatedAt'] != null
          ? DateTime.tryParse(map['generatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'age': age,
      'sex': sex,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'bmi': bmi,
      'primaryGoal': primaryGoal,
      'dosha': dosha,
      'readinessScore': readinessScore,
      'rolling14DayHrvMs': rolling14DayHrvMs,
      'averageSleepHours': averageSleepHours,
      'summaryNotes': summaryNotes,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

class CoachEscalationTicket {
  final String id;
  final String userId;
  final EscalationReason reason;
  final EscalationStatus status;
  final CoachHandoverDossier dossier;
  final String? assignedCoachName;
  final String? coachResponseNotes;
  final DateTime createdAt;

  const CoachEscalationTicket({
    required this.id,
    required this.userId,
    required this.reason,
    required this.status,
    required this.dossier,
    this.assignedCoachName,
    this.coachResponseNotes,
    required this.createdAt,
  });

  factory CoachEscalationTicket.fromMap(Map<String, dynamic> map, String id) {
    final reasonName = map['reason'] as String? ?? 'userRequested';
    final reason = EscalationReason.values.firstWhere(
      (e) => e.name == reasonName,
      orElse: () => EscalationReason.userRequested,
    );

    final statusName = map['status'] as String? ?? 'pendingReview';
    final status = EscalationStatus.values.firstWhere(
      (e) => e.name == statusName,
      orElse: () => EscalationStatus.pendingReview,
    );

    return CoachEscalationTicket(
      id: id,
      userId: map['userId'] as String? ?? '',
      reason: reason,
      status: status,
      dossier: CoachHandoverDossier.fromMap(Map<String, dynamic>.from(map['dossier'] ?? {})),
      assignedCoachName: map['assignedCoachName'] as String?,
      coachResponseNotes: map['coachResponseNotes'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reason': reason.name,
      'status': status.name,
      'dossier': dossier.toMap(),
      'assignedCoachName': assignedCoachName,
      'coachResponseNotes': coachResponseNotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
