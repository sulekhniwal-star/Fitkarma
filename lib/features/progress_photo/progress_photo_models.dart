/// §P11-B Progress Photo Models & TransformationCheck Metadata

class ProgressPhotoEntry {
  const ProgressPhotoEntry({
    required this.localId,
    required this.userId,
    required this.checkDate,
    required this.weightKg,
    this.bodyFatPct,
    this.waistCm,
    this.neckCm,
    this.hipCm,
    this.encryptedPhotoBase64,
    this.photoTag = 'Front',
    this.notes,
    this.syncStatus = 'pending',
  });

  final String localId;
  final String userId;
  final DateTime checkDate;
  final double weightKg;
  final double? bodyFatPct;
  final double? waistCm;
  final double? neckCm;
  final double? hipCm;
  final String? encryptedPhotoBase64;
  final String photoTag;
  final String? notes;
  final String syncStatus;

  /// Converts entry to TransformationCheck metadata map for persistence.
  Map<String, dynamic> toTransformationCheckJson() => {
        'localId': localId,
        'userId': userId,
        'checkDate': checkDate.toIso8601String(),
        'weightKg': weightKg,
        'bodyFatPct': bodyFatPct,
        'waistCm': waistCm,
        'neckCm': neckCm,
        'hipCm': hipCm,
        'photoPath': 'encrypted://$localId.enc',
        'encryptedPhotoBase64': encryptedPhotoBase64,
        'photoTag': photoTag,
        'notes': notes,
        'syncStatus': syncStatus,
      };

  factory ProgressPhotoEntry.fromJson(Map<String, dynamic> json) =>
      ProgressPhotoEntry(
        localId: json['localId'] as String,
        userId: json['userId'] as String,
        checkDate: DateTime.parse(json['checkDate'] as String),
        weightKg: (json['weightKg'] as num).toDouble(),
        bodyFatPct: (json['bodyFatPct'] as num?)?.toDouble(),
        waistCm: (json['waistCm'] as num?)?.toDouble(),
        neckCm: (json['neckCm'] as num?)?.toDouble(),
        hipCm: (json['hipCm'] as num?)?.toDouble(),
        encryptedPhotoBase64: json['encryptedPhotoBase64'] as String?,
        photoTag: json['photoTag'] as String? ?? 'Front',
        notes: json['notes'] as String?,
        syncStatus: json['syncStatus'] as String? ?? 'pending',
      );
}

class ProgressPhotoComparison {
  const ProgressPhotoComparison({
    required this.before,
    required this.after,
  });

  final ProgressPhotoEntry before;
  final ProgressPhotoEntry after;

  double get weightDeltaKg => after.weightKg - before.weightKg;

  double? get waistDeltaCm {
    if (before.waistCm == null || after.waistCm == null) return null;
    return after.waistCm! - before.waistCm!;
  }

  double? get bodyFatDeltaPct {
    if (before.bodyFatPct == null || after.bodyFatPct == null) return null;
    return after.bodyFatPct! - before.bodyFatPct!;
  }

  int get elapsedDays => after.checkDate.difference(before.checkDate).inDays.abs();
}
