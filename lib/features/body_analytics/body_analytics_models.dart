/// §P11-A Body Analytics — Models & Calculations

class BodyMeasurementEntry {
  const BodyMeasurementEntry({
    required this.localId,
    required this.userId,
    required this.logDate,
    this.neckCm,
    this.chestCm,
    this.bicepsCm,
    this.waistCm,
    this.hipsCm,
    this.thighCm,
    this.calvesCm,
    this.weightKg,
    this.syncStatus = 'pending',
  });

  final String localId;
  final String userId;
  final DateTime logDate;
  final double? neckCm;
  final double? chestCm;
  final double? bicepsCm;
  final double? waistCm;
  final double? hipsCm;
  final double? thighCm;
  final double? calvesCm;
  final double? weightKg;
  final String syncStatus;

  /// Waist-to-Hip Ratio (WHR = waist / hips)
  double? get waistToHipRatio {
    if (waistCm == null || hipsCm == null || hipsCm! <= 0) return null;
    return waistCm! / hipsCm!;
  }

  /// WHR Health Risk Classification
  String get whrCategory {
    final whr = waistToHipRatio;
    if (whr == null) return 'N/A';
    if (whr < 0.85) return 'Optimal (Low Risk)';
    if (whr <= 0.90) return 'Moderate Risk';
    return 'High Risk';
  }

  /// Estimated Body Fat % (Navy Body Fat Formula estimate)
  double? get estimatedBodyFatPct {
    if (waistCm == null || neckCm == null || waistCm! <= neckCm!) return null;
    final diff = waistCm! - neckCm!;
    if (diff <= 0) return null;
    if (hipsCm != null && hipsCm! > 0) {
      // Female formula estimate
      final total = waistCm! + hipsCm! - neckCm!;
      return ((total * 0.28) - 16.0).clamp(8.0, 45.0);
    }
    // Male formula estimate
    return ((diff * 0.42) - 3.0).clamp(6.0, 40.0);
  }

  Map<String, dynamic> toJson() => {
        'localId': localId,
        'userId': userId,
        'logDate': logDate.toIso8601String(),
        'neckCm': neckCm,
        'chestCm': chestCm,
        'bicepsCm': bicepsCm,
        'waistCm': waistCm,
        'hipsCm': hipsCm,
        'thighCm': thighCm,
        'calvesCm': calvesCm,
        'weightKg': weightKg,
        'syncStatus': syncStatus,
      };

  factory BodyMeasurementEntry.fromJson(Map<String, dynamic> json) =>
      BodyMeasurementEntry(
        localId: json['localId'] as String,
        userId: json['userId'] as String,
        logDate: DateTime.parse(json['logDate'] as String),
        neckCm: (json['neckCm'] as num?)?.toDouble(),
        chestCm: (json['chestCm'] as num?)?.toDouble(),
        bicepsCm: (json['bicepsCm'] as num?)?.toDouble(),
        waistCm: (json['waistCm'] as num?)?.toDouble(),
        hipsCm: (json['hipsCm'] as num?)?.toDouble(),
        thighCm: (json['thighCm'] as num?)?.toDouble(),
        calvesCm: (json['calvesCm'] as num?)?.toDouble(),
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        syncStatus: json['syncStatus'] as String? ?? 'pending',
      );
}

class BodyMeasurementTrend {
  const BodyMeasurementTrend({
    required this.siteName,
    required this.currentCm,
    required this.previousCm,
    required this.deltaCm,
  });

  final String siteName;
  final double currentCm;
  final double previousCm;
  final double deltaCm;

  bool get isReduction => deltaCm < 0;
}
