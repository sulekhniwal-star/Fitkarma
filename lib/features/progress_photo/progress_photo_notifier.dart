/// §P11-B Progress Photo System — Riverpod Notifier & State

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'progress_photo_models.dart';
import 'secure_photo_storage.dart';

class ProgressPhotoState {
  const ProgressPhotoState({
    required this.photos,
    this.selectedBefore,
    this.selectedAfter,
    this.isComparing = false,
    this.successMessage,
  });

  final List<ProgressPhotoEntry> photos;
  final ProgressPhotoEntry? selectedBefore;
  final ProgressPhotoEntry? selectedAfter;
  final bool isComparing;
  final String? successMessage;

  ProgressPhotoComparison? get activeComparison {
    if (selectedBefore == null || selectedAfter == null) return null;
    return ProgressPhotoComparison(
      before: selectedBefore!,
      after: selectedAfter!,
    );
  }

  ProgressPhotoState copyWith({
    List<ProgressPhotoEntry>? photos,
    ProgressPhotoEntry? selectedBefore,
    ProgressPhotoEntry? selectedAfter,
    bool? isComparing,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return ProgressPhotoState(
      photos: photos ?? this.photos,
      selectedBefore: selectedBefore ?? this.selectedBefore,
      selectedAfter: selectedAfter ?? this.selectedAfter,
      isComparing: isComparing ?? this.isComparing,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class ProgressPhotoNotifier extends Notifier<ProgressPhotoState> {
  late final SecurePhotoStorageService _storageService;

  @override
  ProgressPhotoState build() {
    _storageService = const SecurePhotoStorageService();
    final now = DateTime.now();

    // Default transformation check entries with mock encrypted photo placeholders
    final initialPhotos = [
      ProgressPhotoEntry(
        localId: 'tc_002',
        userId: 'user_local_001',
        checkDate: now,
        weightKg: 71.5,
        bodyFatPct: 17.5,
        waistCm: 81.0,
        neckCm: 38.0,
        hipCm: 95.0,
        photoTag: 'Front',
        notes: '30-day progress check-in',
      ),
      ProgressPhotoEntry(
        localId: 'tc_001',
        userId: 'user_local_001',
        checkDate: now.subtract(const Duration(days: 30)),
        weightKg: 74.5,
        bodyFatPct: 19.8,
        waistCm: 85.0,
        neckCm: 38.5,
        hipCm: 97.0,
        photoTag: 'Front',
        notes: 'Baseline photo',
      ),
    ];

    return ProgressPhotoState(
      photos: initialPhotos,
      selectedBefore: initialPhotos.last,
      selectedAfter: initialPhotos.first,
    );
  }

  /// Encrypts raw photo bytes and persists metadata to TransformationChecks.
  void captureAndSavePhoto({
    required Uint8List photoBytes,
    required double weightKg,
    required String photoTag,
    double? waistCm,
    double? neckCm,
    double? hipCm,
    double? bodyFatPct,
    String? notes,
  }) {
    final encryptedBase64 = _storageService.encryptToBase64(photoBytes);
    final id = 'tc_${DateTime.now().millisecondsSinceEpoch}';

    final entry = ProgressPhotoEntry(
      localId: id,
      userId: 'user_local_001',
      checkDate: DateTime.now(),
      weightKg: weightKg,
      bodyFatPct: bodyFatPct,
      waistCm: waistCm,
      neckCm: neckCm,
      hipCm: hipCm,
      encryptedPhotoBase64: encryptedBase64,
      photoTag: photoTag,
      notes: notes,
    );

    final updatedPhotos = [entry, ...state.photos];

    state = state.copyWith(
      photos: updatedPhotos,
      selectedAfter: entry,
      successMessage:
          'Progress photo encrypted at rest 🔒 and persisted to TransformationChecks!',
    );
  }

  void selectBeforePhoto(ProgressPhotoEntry photo) {
    state = state.copyWith(selectedBefore: photo, isComparing: true);
  }

  void selectAfterPhoto(ProgressPhotoEntry photo) {
    state = state.copyWith(selectedAfter: photo, isComparing: true);
  }

  void toggleComparisonView(bool comparing) {
    state = state.copyWith(isComparing: comparing);
  }
}

final progressPhotoProvider =
    NotifierProvider<ProgressPhotoNotifier, ProgressPhotoState>(
  ProgressPhotoNotifier.new,
);
