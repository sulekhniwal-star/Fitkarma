// §P5-D FoodLogRepository — Offline-First Food Logging

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../data/local/fitkarma_database.dart';
import '../../../core/brain/nutrition_engine.dart';

class FoodLogEntry {
  final String foodName;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double processingTier;
  final MealType mealType;
  final DateTime consumeTime;

  const FoodLogEntry({
    required this.foodName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG = 0.0,
    this.processingTier = 1.0,
    required this.mealType,
    required this.consumeTime,
  });
}

class FoodLogRepository {
  final FitKarmaDatabase _db;
  final String _workerBaseUrl;
  final String _userId;
  final _uuid = const Uuid();

  FoodLogRepository({
    required FitKarmaDatabase db,
    required String workerBaseUrl,
    required String userId,
  })  : _db = db,
        _workerBaseUrl = workerBaseUrl,
        _userId = userId;

  // ── Log a food entry (offline-first) ─────────────────────────────────────────
  Future<String> logFood(FoodLogEntry entry) async {
    final localId = 'flog_${_uuid.v4()}';

    // Step 1: Write to local Drift immediately (always succeeds, even offline)
    await _db.into(_db.foodLogs).insert(
          FoodLogsCompanion.insert(
            localId: localId,
            userId: _userId,
            consumeTime: entry.consumeTime,
            foodName: entry.foodName,
            calories: entry.calories,
            protein: entry.proteinG,
            carbs: entry.carbsG,
            fat: entry.fatG,
            processingTier: Value(entry.processingTier),
            syncStatus: const Value('pending'),
          ),
        );

    // Step 2: Sync to Worker if online (fire-and-forget via unawaited)
    _syncLogToWorker(localId, entry);

    return localId;
  }

  // ── Fetch today's food logs for the user ──────────────────────────────────────
  Future<List<FoodLog>> getTodaysLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.foodLogs)
          ..where((t) =>
              t.userId.equals(_userId) &
              t.consumeTime.isBiggerOrEqualValue(startOfDay) &
              t.consumeTime.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.consumeTime)]))
        .get();
  }

  // ── Delete a food log (local only; syncStatus marks deletion) ─────────────────
  Future<void> removeLog(String localId) async {
    await (_db.delete(_db.foodLogs)..where((t) => t.localId.equals(localId))).go();
  }

  // ── Retry pending syncs ───────────────────────────────────────────────────────
  /// Call this from the sync layer when connectivity is restored.
  Future<void> syncPendingLogs() async {
    if (!await _isOnline()) return;

    final pending = await (_db.select(_db.foodLogs)
          ..where((t) =>
              t.userId.equals(_userId) & t.syncStatus.equals('pending')))
        .get();

    for (final log in pending) {
      try {
        final resp = await http.post(
          Uri.parse('$_workerBaseUrl/food-db/log'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': _userId,
          },
          body: jsonEncode({
            'localId': log.localId,
            'foodName': log.foodName,
            'calories': log.calories,
            'protein': log.protein,
            'carbs': log.carbs,
            'fat': log.fat,
            'consumeTime': log.consumeTime.toIso8601String(),
            'processingTier': log.processingTier,
          }),
        ).timeout(const Duration(seconds: 10));

        if (resp.statusCode == 201 || resp.statusCode == 200) {
          // Mark as synced
          await (_db.update(_db.foodLogs)
                ..where((t) => t.localId.equals(log.localId)))
              .write(const FoodLogsCompanion(syncStatus: Value('synced')));
        }
      } catch (_) {
        // Leave as 'pending' — will retry on next connectivity
      }
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────────
  Future<void> _syncLogToWorker(String localId, FoodLogEntry entry) async {
    if (!await _isOnline()) return;

    try {
      final resp = await http.post(
        Uri.parse('$_workerBaseUrl/food-db/log'),
        headers: {
          'Content-Type': 'application/json',
          'x-user-id': _userId,
        },
        body: jsonEncode({
          'localId': localId,
          'foodName': entry.foodName,
          'calories': entry.calories,
          'protein': entry.proteinG,
          'carbs': entry.carbsG,
          'fat': entry.fatG,
          'consumeTime': entry.consumeTime.toIso8601String(),
          'processingTier': entry.processingTier,
        }),
      ).timeout(const Duration(seconds: 10));

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        await (_db.update(_db.foodLogs)
              ..where((t) => t.localId.equals(localId)))
            .write(const FoodLogsCompanion(syncStatus: Value('synced')));
      }
    } catch (_) {
      // Stays as 'pending' — will be retried on next sync pass
    }
  }

  Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('cloudflare.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
