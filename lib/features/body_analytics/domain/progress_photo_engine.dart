import 'dart:math';
import 'progress_photo_models.dart';

/// Pure Dart Deterministic Engine for Progress Photo Timeline Analysis & Comparative Pairing
class ProgressPhotoEngine {
  const ProgressPhotoEngine();

  /// Compiles photo entries into a comprehensive vault timeline and active comparative pair
  ProgressPhotoTimelineReport generateTimelineReport({
    required List<ProgressPhotoEntry> entries,
    ProgressPhotoEntry? selectedBefore,
    ProgressPhotoEntry? selectedAfter,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    if (entries.isEmpty) {
      return ProgressPhotoTimelineReport(
        entries: const [],
        activeComparison: null,
        totalPhotosCaptured: 0,
        totalDaysTracked: 0,
        totalWeightLossKg: 0.0,
        totalBodyFatLossPercent: 0.0,
        isVaultEncrypted: true,
        lastUpdated: now,
      );
    }

    // Sort chronologically ascending
    final sorted = List<ProgressPhotoEntry>.from(entries)
      ..sort((a, b) => a.capturedAt.compareTo(b.capturedAt));

    final firstEntry = sorted.first;
    final lastEntry = sorted.last;
    final daysTracked = max(1, lastEntry.capturedAt.difference(firstEntry.capturedAt).inDays);

    final totalWeightDelta = lastEntry.weightKgAtCapture - firstEntry.weightKgAtCapture;
    final totalFatDelta = lastEntry.bodyFatPercentAtCapture - firstEntry.bodyFatPercentAtCapture;

    // Determine comparative pair
    ComparativePhotoPair? comparison;
    if (selectedBefore != null && selectedAfter != null) {
      comparison = createComparativePair(selectedBefore, selectedAfter);
    } else if (sorted.length >= 2) {
      comparison = createComparativePair(sorted.first, sorted.last);
    }

    return ProgressPhotoTimelineReport(
      entries: sorted,
      activeComparison: comparison,
      totalPhotosCaptured: sorted.length,
      totalDaysTracked: daysTracked,
      totalWeightLossKg: double.parse((-totalWeightDelta).toStringAsFixed(1)),
      totalBodyFatLossPercent: double.parse((-totalFatDelta).toStringAsFixed(1)),
      isVaultEncrypted: true,
      lastUpdated: now,
    );
  }

  /// Creates a deterministic comparative pair between any two photo milestones
  ComparativePhotoPair createComparativePair(
    ProgressPhotoEntry before,
    ProgressPhotoEntry after,
  ) {
    final days = after.capturedAt.difference(before.capturedAt).inDays.abs();
    final weightDelta = after.weightKgAtCapture - before.weightKgAtCapture;
    final fatDelta = after.bodyFatPercentAtCapture - before.bodyFatPercentAtCapture;
    final waistDelta = (after.waistCmAtCapture ?? 0.0) - (before.waistCmAtCapture ?? 0.0);

    String summary;
    String regSummary;

    if (weightDelta < 0 && fatDelta < 0) {
      summary =
          '${(-weightDelta).toStringAsFixed(1)} kg reduction with ${(-fatDelta).toStringAsFixed(1)}% body fat drop over $days days. Outstanding Meda reduction.';
      regSummary =
          '$days दिनों में ${(-weightDelta).toStringAsFixed(1)} किग्रा भार व ${(-fatDelta).toStringAsFixed(1)}% वसा में कमी। उत्कृष्ट मेद क्षय एवं शारीरिक कसावट।';
    } else if (weightDelta >= 0 && fatDelta < 0) {
      summary =
          'Clean body recomposition: Lean muscle growth with ${(-fatDelta).toStringAsFixed(1)}% fat loss over $days days.';
      regSummary =
          'सकारात्मक शारीरिक पुनर्गठन: $days दिनों में मांसपेशी संवर्धन एवं ${(-fatDelta).toStringAsFixed(1)}% वसा में कमी।';
    } else {
      summary =
          'Weight shifted by ${weightDelta > 0 ? "+" : ""}${weightDelta.toStringAsFixed(1)} kg over $days days. Focus on consistent training and nutrition pacing.';
      regSummary =
          '$days दिनों में भार में ${weightDelta > 0 ? "+" : ""}${weightDelta.toStringAsFixed(1)} किग्रा परिवर्तन। नियमित व्यायाम व संतुलित आहार जारी रखें।';
    }

    return ComparativePhotoPair(
      beforePhoto: before,
      afterPhoto: after,
      daysElapsed: days,
      weightDeltaKg: double.parse(weightDelta.toStringAsFixed(1)),
      bodyFatDeltaPercent: double.parse(fatDelta.toStringAsFixed(1)),
      waistDeltaCm: double.parse(waistDelta.toStringAsFixed(1)),
      transformationSummary: summary,
      regionalTransformationSummary: regSummary,
    );
  }
}
