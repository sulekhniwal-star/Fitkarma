/// §P5-C Meal Vision Service
///
/// Analyzes a meal photo (as raw bytes) through a three-tier pipeline:
///   1. AICache hit   — identical photo already analyzed within 24 h
///   2. Offline match — known Indian meal recognized locally (≥ 0.80 confidence)
///   3. Mock Azure Function call — `fitkarma-meal-vision` (simulated Groq Vision)
///
/// No real network calls are made — the Azure Function slot is a deterministic
/// mock that returns structured nutrition data. The caching and SHA-256 keying
/// logic are fully functional.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fitkarma/core/ai/ai_cache.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Domain types
// ─────────────────────────────────────────────────────────────────────────────

/// Indicates where the nutrition data came from.
enum VisionSource {
  /// Matched from the local offline catalog — no API call made.
  offlineMatch,

  /// Restored from the 24-hour AICache — no API call made.
  cached,

  /// Returned by the `fitkarma-meal-vision` Azure Function (Groq Vision).
  apiCall,
}

/// Structured response from the meal vision pipeline.
class GroqVisionResponse {
  const GroqVisionResponse({
    required this.detectedMeal,
    required this.confidence,
    required this.totalCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.glycemicIndex,
    required this.source,
  });

  /// Deserialises from a cached JSON string.
  factory GroqVisionResponse.fromJson(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return GroqVisionResponse(
      detectedMeal: map['detectedMeal'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      totalCalories: (map['totalCalories'] as num).toDouble(),
      proteinG: (map['proteinG'] as num).toDouble(),
      carbsG: (map['carbsG'] as num).toDouble(),
      fatG: (map['fatG'] as num).toDouble(),
      fiberG: (map['fiberG'] as num).toDouble(),
      glycemicIndex: map['glycemicIndex'] as int,
      source: VisionSource.cached,
    );
  }

  /// Primary human-readable meal name (e.g. "Dal Makhani + 2 Rotis").
  final String detectedMeal;

  /// Model confidence [0.0–1.0].
  final double confidence;

  final double totalCalories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final int glycemicIndex;
  final VisionSource source;

  /// Serialises to JSON for caching.
  String toJson() => jsonEncode({
    'detectedMeal': detectedMeal,
    'confidence': confidence,
    'totalCalories': totalCalories,
    'proteinG': proteinG,
    'carbsG': carbsG,
    'fatG': fatG,
    'fiberG': fiberG,
    'glycemicIndex': glycemicIndex,
    'source': source.name,
  });

  GroqVisionResponse copyWith({VisionSource? source}) => GroqVisionResponse(
    detectedMeal: detectedMeal,
    confidence: confidence,
    totalCalories: totalCalories,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
    fiberG: fiberG,
    glycemicIndex: glycemicIndex,
    source: source ?? this.source,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Offline known-meal catalog (no API needed for these common dishes)
// ─────────────────────────────────────────────────────────────────────────────

/// A single offline-recognizable meal entry.
class _OfflineMealEntry {
  const _OfflineMealEntry({
    required this.name,
    required this.keywords,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.glycemicIndex,
  });

  final String name;
  final List<String>
  keywords; // matched against the mock "label" derived from byte length bucket
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final int glycemicIndex;
}

// 12 common Indian meals pre-seeded for offline recognition.
const List<_OfflineMealEntry> _offlineCatalog = [
  _OfflineMealEntry(
    name: 'Poha',
    keywords: ['poha', 'beaten rice'],
    calories: 220,
    proteinG: 3.5,
    carbsG: 42,
    fatG: 4.0,
    fiberG: 2.8,
    glycemicIndex: 68,
  ),
  _OfflineMealEntry(
    name: 'Idli + Sambar',
    keywords: ['idli', 'sambar'],
    calories: 230,
    proteinG: 7.0,
    carbsG: 44,
    fatG: 2.2,
    fiberG: 6.0,
    glycemicIndex: 58,
  ),
  _OfflineMealEntry(
    name: 'Plain Dosa',
    keywords: ['dosa', 'dosai'],
    calories: 165,
    proteinG: 3.2,
    carbsG: 32,
    fatG: 2.5,
    fiberG: 1.2,
    glycemicIndex: 75,
  ),
  _OfflineMealEntry(
    name: 'Dal + 2 Rotis',
    keywords: ['dal', 'roti', 'chapati'],
    calories: 320,
    proteinG: 14.5,
    carbsG: 58,
    fatG: 4.0,
    fiberG: 11.0,
    glycemicIndex: 52,
  ),
  _OfflineMealEntry(
    name: 'Rajma Chawal',
    keywords: ['rajma', 'rice', 'chawal'],
    calories: 420,
    proteinG: 14.0,
    carbsG: 76,
    fatG: 6.0,
    fiberG: 10.0,
    glycemicIndex: 54,
  ),
  _OfflineMealEntry(
    name: 'Upma',
    keywords: ['upma', 'rava', 'semolina'],
    calories: 190,
    proteinG: 4.0,
    carbsG: 34,
    fatG: 3.5,
    fiberG: 2.0,
    glycemicIndex: 65,
  ),
  _OfflineMealEntry(
    name: 'Chole Bhature',
    keywords: ['chole', 'bhature', 'puri'],
    calories: 620,
    proteinG: 16.0,
    carbsG: 88,
    fatG: 22.0,
    fiberG: 12.0,
    glycemicIndex: 58,
  ),
  _OfflineMealEntry(
    name: 'Moong Dal Khichdi',
    keywords: ['khichdi', 'moong'],
    calories: 210,
    proteinG: 7.2,
    carbsG: 38,
    fatG: 3.0,
    fiberG: 4.0,
    glycemicIndex: 55,
  ),
  _OfflineMealEntry(
    name: 'Paneer Butter Masala + Roti',
    keywords: ['paneer', 'butter masala'],
    calories: 500,
    proteinG: 21.0,
    carbsG: 46,
    fatG: 24.0,
    fiberG: 3.5,
    glycemicIndex: 48,
  ),
  _OfflineMealEntry(
    name: 'Tandoori Chicken',
    keywords: ['chicken', 'tandoori', 'murgh'],
    calories: 260,
    proteinG: 32.0,
    carbsG: 3,
    fatG: 12.0,
    fiberG: 0.5,
    glycemicIndex: 15,
  ),
  _OfflineMealEntry(
    name: 'Masala Dosa',
    keywords: ['masala dosa'],
    calories: 350,
    proteinG: 6.0,
    carbsG: 55,
    fatG: 12.0,
    fiberG: 2.5,
    glycemicIndex: 70,
  ),
  _OfflineMealEntry(
    name: 'Aloo Paratha + Curd',
    keywords: ['paratha', 'aloo paratha'],
    calories: 430,
    proteinG: 10.5,
    carbsG: 65,
    fatG: 14.0,
    fiberG: 4.0,
    glycemicIndex: 62,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Mock Azure Function response table
// (Simulates fitkarma-meal-vision Groq Vision API)
// ─────────────────────────────────────────────────────────────────────────────

/// Deterministic mock responses keyed by the low 4 bits of the image checksum.
/// In production this slot is replaced by a real HTTPS call to the Azure Function.
GroqVisionResponse _mockAzureResponse(Uint8List bytes) {
  // Use sum-of-bytes mod catalog length to select a mock meal deterministically.
  final checksum = bytes.fold<int>(0, (acc, b) => acc + b);
  final index = checksum % _offlineCatalog.length;
  final entry = _offlineCatalog[index];
  return GroqVisionResponse(
    detectedMeal: entry.name,
    confidence: 0.75 + (checksum % 20) / 100.0, // 0.75–0.94
    totalCalories: entry.calories,
    proteinG: entry.proteinG,
    carbsG: entry.carbsG,
    fatG: entry.fatG,
    fiberG: entry.fiberG,
    glycemicIndex: entry.glycemicIndex,
    source: VisionSource.apiCall,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// MealVisionService
// ─────────────────────────────────────────────────────────────────────────────

/// Orchestrates the three-tier meal photo analysis pipeline.
class MealVisionService {
  const MealVisionService(this._cache);

  final AICache _cache;

  /// Analyzes [imageBytes] for [userId] and returns a [GroqVisionResponse].
  ///
  /// Pipeline:
  ///   1. Cache hit   → deserialise and return immediately.
  ///   2. Offline match → known Indian meal, confidence ≥ 0.80.
  ///   3. Mock Azure Function call → `fitkarma-meal-vision`.
  ///   4. Cache the result for 24 h.
  Future<GroqVisionResponse> analyzePhoto({
    required Uint8List imageBytes,
    required String userId,
  }) async {
    // 1. Compute SHA-256 hash as cache key
    final digest = sha256.convert(imageBytes);
    final cacheKey = digest.toString();

    // 2. Cache lookup
    final cached = await _cache.get(userId, cacheKey);
    if (cached != null) {
      return GroqVisionResponse.fromJson(cached);
    }

    // 3. Offline pattern match
    final offlineHit = _tryOfflineMatch(imageBytes);
    if (offlineHit != null) {
      // Cache the offline result so subsequent identical photos are instant
      await _cache.set(userId, cacheKey, offlineHit.toJson());
      return offlineHit;
    }

    // 4. Mock Azure Function call
    final apiResponse = _mockAzureResponse(imageBytes);

    // 5. Cache the API result
    await _cache.set(userId, cacheKey, apiResponse.toJson());

    return apiResponse;
  }

  /// Attempts to match against the offline catalog.
  /// Uses a simple keyword heuristic on the byte-length bucket label.
  /// In production, a client-side image classifier would replace this.
  GroqVisionResponse? _tryOfflineMatch(Uint8List bytes) {
    // Derive a deterministic "label" from bytes for test predictability.
    final bucketLabel = _byteBucketLabel(bytes);

    for (final entry in _offlineCatalog) {
      for (final kw in entry.keywords) {
        if (bucketLabel.contains(kw)) {
          return GroqVisionResponse(
            detectedMeal: entry.name,
            confidence: 0.92,
            totalCalories: entry.calories,
            proteinG: entry.proteinG,
            carbsG: entry.carbsG,
            fatG: entry.fatG,
            fiberG: entry.fiberG,
            glycemicIndex: entry.glycemicIndex,
            source: VisionSource.offlineMatch,
          );
        }
      }
    }
    return null;
  }

  /// Maps byte content to a label string for offline matching in tests.
  /// Tests embed known keywords in the byte array via UTF-8 encoding.
  String _byteBucketLabel(Uint8List bytes) {
    try {
      return utf8.decode(bytes, allowMalformed: true).toLowerCase();
    } catch (_) {
      return '';
    }
  }
}
