class HeartRateLog {
  final String id;
  final String oderId;
  final int bpm;
  final DateTime date;
  final String? note;
  final bool isManual;

  const HeartRateLog({
    required this.id,
    required this.oderId,
    required this.bpm,
    required this.date,
    this.note,
    this.isManual = true,
  });

  factory HeartRateLog.fromJson(Map<String, dynamic> json) {
    return HeartRateLog(
      id: json['id'] as String? ?? '',
      oderId: json['user'] as String? ?? '',
      bpm: json['bpm'] as int? ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      note: json['note'] as String?,
      isManual: json['is_manual'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': oderId,
      'bpm': bpm,
      'date': date.toIso8601String(),
      'note': note,
      'is_manual': isManual,
    };
  }

  String get bpmCategory {
    if (bpm < 60) return 'Low';
    if (bpm <= 100) return 'Normal';
    if (bpm <= 120) return 'Elevated';
    return 'High';
  }

  String get bpmCategoryHindi {
    if (bpm < 60) return 'धीमा';
    if (bpm <= 100) return 'सामान्य';
    if (bpm <= 120) return 'थोड़ा उच्च';
    return 'उच्च';
  }
}
