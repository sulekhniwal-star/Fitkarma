/// §P12-B Life Events Engine — Domain Models & Data Structures
///
/// Implements LifeEventType enum, LifeEventRecord, and LifeEventAdaptation payloads matching §P12-B spec.
library;

import 'dart:convert';

enum LifeEventType {
  wedding,
  injury,
  travelAbroad,
  travelDomestic,
  examSeason,
  ramadan,
  shiftWork,
  nightShift,
  officeDeadline,
  newBaby,
  relocation,
  grief,
  illness,
}

class LifeEventRecord {
  const LifeEventRecord({
    required this.localId,
    required this.userId,
    required this.eventType,
    this.eventData = const {},
    required this.startDate,
    this.endDate,
    this.isActive = true,
    required this.createdAt,
    this.syncStatus = 'pending',
  });

  final String localId;
  final String userId;
  final LifeEventType eventType;
  final Map<String, dynamic> eventData;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final String syncStatus;

  /// Serialization to Drift `LifeEvents` table map (§P12-B spec).
  Map<String, dynamic> toLifeEventsJson() => {
        'localId': localId,
        'userId': userId,
        'eventType': eventType.name,
        'eventData': jsonEncode(eventData),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'isActive': isActive,
        'syncStatus': syncStatus,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LifeEventRecord.fromJson(Map<String, dynamic> json) => LifeEventRecord(
        localId: json['localId'] as String,
        userId: json['userId'] as String,
        eventType: LifeEventType.values.byName(json['eventType'] as String),
        eventData: json['eventData'] is String
            ? (jsonDecode(json['eventData'] as String) as Map<String, dynamic>)
            : (json['eventData'] as Map<String, dynamic>? ?? {}),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        syncStatus: json['syncStatus'] as String? ?? 'pending',
      );
}

class LifeEventAdaptation {
  const LifeEventAdaptation({
    required this.eventType,
    this.reducedWorkoutDurationMin,
    this.rpeCap,
    this.restrictedExerciseTags = const [],
    this.calorieAdjustment = 0,
    this.sleepReadinessLowered = false,
    this.recoveryFirst = false,
    this.workoutBrief = false,
    this.stressManagement = false,
    required this.adaptationSummary,
  });

  final LifeEventType eventType;
  final int? reducedWorkoutDurationMin;
  final int? rpeCap;
  final List<String> restrictedExerciseTags;
  final int calorieAdjustment;
  final bool sleepReadinessLowered;
  final bool recoveryFirst;
  final bool workoutBrief;
  final bool stressManagement;
  final String adaptationSummary;
}
