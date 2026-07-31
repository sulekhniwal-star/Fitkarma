/// Transformation Memory Monthly Snapshot
class TransformationMemory {
  final String monthYear;
  final double weightKg;
  final double bodyFatPercentage;
  final int averageReadinessScore;

  const TransformationMemory({
    required this.monthYear,
    required this.weightKg,
    required this.bodyFatPercentage,
    required this.averageReadinessScore,
  });
}

/// Encrypted Local Progress Photo Vault Entry
class ProgressPhotoEntry {
  final String id;
  final DateTime date;
  final String encryptedFilePath;
  final bool isBiometricProtected;

  const ProgressPhotoEntry({
    required this.id,
    required this.date,
    required this.encryptedFilePath,
    this.isBiometricProtected = true,
  });
}
