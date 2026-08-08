import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/transformation_journey_engine.dart';

class ProgressPhotoRecord {
  final String id;
  final String weekLabel;
  final DateTime date;
  final String imagePath;

  const ProgressPhotoRecord({
    required this.id,
    required this.weekLabel,
    required this.date,
    required this.imagePath,
  });
}

class TransformationJourneyState {
  final List<WeightCheckpoint> weightHistory;
  final bool arePhotosUnlocked;
  final String biometricAuthError;
  final double currentAdherenceScore; // 0.0 to 100.0
  final double projectedWeightMin;
  final double projectedWeightMax;
  final double projectedBodyFatMin;
  final double projectedBodyFatMax;
  final int completedProgramWeeks;
  final List<ProgressPhotoRecord> progressPhotos;

  const TransformationJourneyState({
    required this.weightHistory,
    required this.arePhotosUnlocked,
    required this.biometricAuthError,
    required this.currentAdherenceScore,
    required this.projectedWeightMin,
    required this.projectedWeightMax,
    required this.projectedBodyFatMin,
    required this.projectedBodyFatMax,
    required this.completedProgramWeeks,
    required this.progressPhotos,
  });

  factory TransformationJourneyState.initial() {
    final memory = TransformationMemory.initial();
    final currentWeight = memory.weightHistory.last.weightKg;
    const adherence = 84.0;

    // 90-day prediction channel calculation (ADR-025 compliance bounds)
    final projectedDrop = (adherence / 100.0) * 6.0; // 6kg max drop for 90 days at 100%
    final minW = (currentWeight - projectedDrop - 0.8).clamp(50.0, 150.0);
    final maxW = (currentWeight - projectedDrop + 0.8).clamp(50.0, 150.0);

    return TransformationJourneyState(
      weightHistory: memory.weightHistory,
      arePhotosUnlocked: false,
      biometricAuthError: '',
      currentAdherenceScore: adherence,
      projectedWeightMin: double.parse(minW.toStringAsFixed(1)),
      projectedWeightMax: double.parse(maxW.toStringAsFixed(1)),
      projectedBodyFatMin: 17.5,
      projectedBodyFatMax: 19.0,
      completedProgramWeeks: 11,
      progressPhotos: [
        ProgressPhotoRecord(
          id: 'p1',
          weekLabel: 'Week 1',
          date: DateTime.now().subtract(const Duration(days: 75)),
          imagePath: 'assets/photos/w1.jpg',
        ),
        ProgressPhotoRecord(
          id: 'p4',
          weekLabel: 'Week 4',
          date: DateTime.now().subtract(const Duration(days: 50)),
          imagePath: 'assets/photos/w4.jpg',
        ),
        ProgressPhotoRecord(
          id: 'p8',
          weekLabel: 'Week 8',
          date: DateTime.now().subtract(const Duration(days: 20)),
          imagePath: 'assets/photos/w8.jpg',
        ),
      ],
    );
  }

  TransformationJourneyState copyWith({
    List<WeightCheckpoint>? weightHistory,
    bool? arePhotosUnlocked,
    String? biometricAuthError,
    double? currentAdherenceScore,
    double? projectedWeightMin,
    double? projectedWeightMax,
    double? projectedBodyFatMin,
    double? projectedBodyFatMax,
    int? completedProgramWeeks,
    List<ProgressPhotoRecord>? progressPhotos,
  }) {
    return TransformationJourneyState(
      weightHistory: weightHistory ?? this.weightHistory,
      arePhotosUnlocked: arePhotosUnlocked ?? this.arePhotosUnlocked,
      biometricAuthError: biometricAuthError ?? this.biometricAuthError,
      currentAdherenceScore: currentAdherenceScore ?? this.currentAdherenceScore,
      projectedWeightMin: projectedWeightMin ?? this.projectedWeightMin,
      projectedWeightMax: projectedWeightMax ?? this.projectedWeightMax,
      projectedBodyFatMin: projectedBodyFatMin ?? this.projectedBodyFatMin,
      projectedBodyFatMax: projectedBodyFatMax ?? this.projectedBodyFatMax,
      completedProgramWeeks: completedProgramWeeks ?? this.completedProgramWeeks,
      progressPhotos: progressPhotos ?? this.progressPhotos,
    );
  }
}

/// TransformationJourneyNotifier Riverpod Provider per §P8-B spec
class TransformationJourneyNotifier extends StateNotifier<TransformationJourneyState> {
  TransformationJourneyNotifier() : super(TransformationJourneyState.initial());

  void authenticateBiometrics({bool mockSuccess = true, String? mockError}) {
    if (mockSuccess) {
      state = state.copyWith(arePhotosUnlocked: true, biometricAuthError: '');
    } else {
      state = state.copyWith(
        arePhotosUnlocked: false,
        biometricAuthError: mockError ?? 'Biometric verification failed',
      );
    }
  }

  void addWeightCheckpoint(double weightKg) {
    final updatedHistory = [
      ...state.weightHistory,
      WeightCheckpoint(weightKg: weightKg, date: DateTime.now()),
    ];

    final projectedDrop = (state.currentAdherenceScore / 100.0) * 6.0;
    final minW = (weightKg - projectedDrop - 0.8).clamp(50.0, 150.0);
    final maxW = (weightKg - projectedDrop + 0.8).clamp(50.0, 150.0);

    state = state.copyWith(
      weightHistory: updatedHistory,
      projectedWeightMin: double.parse(minW.toStringAsFixed(1)),
      projectedWeightMax: double.parse(maxW.toStringAsFixed(1)),
    );
  }
}

final transformationJourneyProvider =
    StateNotifierProvider<TransformationJourneyNotifier, TransformationJourneyState>((ref) {
  return TransformationJourneyNotifier();
});
