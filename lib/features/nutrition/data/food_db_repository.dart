// §P5-D FoodDbRepository — Offline-First Food Database Lookup
// Source: §P5-D Smart Indian Meal Intelligence

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../data/local/fitkarma_database.dart';

/// Full model returned from food_references (matches Drift table v18)
class FoodReferenceItem {
  final String foodId;
  final String foodName;
  final String defaultServing;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int glycemicIndex;
  final double fiberG;
  final int satietyIndex;
  final String category;
  final String region;
  final double servingGrams;
  final String sourceTag;

  const FoodReferenceItem({
    required this.foodId,
    required this.foodName,
    required this.defaultServing,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.glycemicIndex,
    required this.fiberG,
    required this.satietyIndex,
    required this.category,
    required this.region,
    required this.servingGrams,
    required this.sourceTag,
  });

  factory FoodReferenceItem.fromJson(Map<String, dynamic> j) => FoodReferenceItem(
        foodId: j['foodId'] as String,
        foodName: j['foodName'] as String,
        defaultServing: (j['defaultServing'] as String?) ?? '100g',
        calories: (j['calories'] as num).toDouble(),
        proteinG: (j['proteinG'] as num).toDouble(),
        carbsG: (j['carbsG'] as num).toDouble(),
        fatG: (j['fatG'] as num).toDouble(),
        glycemicIndex: (j['glycemicIndex'] as num?)?.toInt() ?? 50,
        fiberG: (j['fiberG'] as num?)?.toDouble() ?? 0.0,
        satietyIndex: (j['satietyIndex'] as num?)?.toInt() ?? 60,
        category: (j['category'] as String?) ?? 'Indian',
        region: (j['region'] as String?) ?? '',
        servingGrams: (j['servingGrams'] as num?)?.toDouble() ?? 100.0,
        sourceTag: (j['sourceTag'] as String?) ?? 'unknown',
      );

  FoodReferencesCompanion toCompanion() => FoodReferencesCompanion.insert(
        foodId: foodId,
        foodName: foodName,
        defaultServing: defaultServing,
        calories: calories,
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
        glycemicIndex: glycemicIndex,
        fiberG: Value(fiberG),
        satietyIndex: satietyIndex,
        category: Value(category),
        region: Value(region),
        servingGrams: Value(servingGrams),
        sourceTag: Value(sourceTag),
      );
}

class FoodDbRepository {
  final FitKarmaDatabase _db;
  final String _workerBaseUrl;
  final String _userId;

  /// Asset path for the bundled food seed.
  static const _kSeedAsset = 'assets/food_db/food_seed_5000.json';

  FoodDbRepository({
    required FitKarmaDatabase db,
    required String workerBaseUrl,
    required String userId,
  })  : _db = db,
        _workerBaseUrl = workerBaseUrl,
        _userId = userId;

  // ── First-run seed ────────────────────────────────────────────────────────────
  /// Call once on app start (guarded by SharedPreferences flag).
  /// Reads assets/food_db/food_seed_5000.json and bulk-inserts into local Drift.
  Future<void> ensureSeedLoaded() async {
    // Check if already seeded by counting rows
    final count = await (_db.selectOnly(_db.foodReferences)
          ..addColumns([_db.foodReferences.foodId.count()]))
        .map((row) => row.read(_db.foodReferences.foodId.count()) ?? 0)
        .getSingleOrNull();

    if ((count ?? 0) > 100) return; // Already has data

    try {
      final jsonStr = await rootBundle.loadString(_kSeedAsset);
      final List<dynamic> data = jsonDecode(jsonStr) as List<dynamic>;

      // Batch insert in chunks of 200 to avoid transaction size issues
      const chunkSize = 200;
      for (int i = 0; i < data.length; i += chunkSize) {
        final chunk = data.sublist(i, (i + chunkSize).clamp(0, data.length));
        await _db.batch((batch) {
          for (final raw in chunk) {
            final item = FoodReferenceItem.fromJson(raw as Map<String, dynamic>);
            batch.insert(
              _db.foodReferences,
              FoodReferencesCompanion.insert(
                foodId: item.foodId,
                foodName: item.foodName,
                defaultServing: item.defaultServing,
                calories: item.calories,
                proteinG: item.proteinG,
                carbsG: item.carbsG,
                fatG: item.fatG,
                glycemicIndex: item.glycemicIndex,
                fiberG: Value(item.fiberG),
                satietyIndex: item.satietyIndex,
                category: Value(item.category),
                region: Value(item.region),
                servingGrams: Value(item.servingGrams),
                sourceTag: Value(item.sourceTag),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }
    } catch (e) {
      // Non-fatal — local DB will be empty but online search still works
      // ignore: avoid_print
      print('[FoodDbRepository] Seed load failed: $e');
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────────
  /// Offline-first search. Local Drift first; fetches from Worker if sparse and online.
  Future<List<FoodReferenceItem>> searchFood(String query, {int limit = 20}) async {
    if (query.trim().length < 2) return [];

    final likeQuery = '%${query.trim()}%';
    final localRows = await (_db.select(_db.foodReferences)
          ..where((t) => t.foodName.like(likeQuery))
          ..limit(limit))
        .get();

    final localItems = localRows.map(_rowToItem).toList();

    // If we have decent local results or are offline, return local immediately
    if (localItems.length >= 5 || !await _isOnline()) {
      return localItems;
    }

    // Online fallback — fetch from Worker and upsert new results locally
    try {
      final remoteItems = await _searchWorker(query, limit: limit);
      await _upsertRemoteItems(remoteItems);

      // Merge: remote first, then local not already in remote set
      final remoteIds = remoteItems.map((i) => i.foodId).toSet();
      final merged = [
        ...remoteItems,
        ...localItems.where((i) => !remoteIds.contains(i.foodId)),
      ];
      return merged.take(limit).toList();
    } catch (_) {
      // Worker call failed — return local results as-is
      return localItems;
    }
  }

  /// Lookup a single food item by ID — local first, Worker fallback.
  Future<FoodReferenceItem?> getFoodItem(String foodId) async {
    final local = await (_db.select(_db.foodReferences)
          ..where((t) => t.foodId.equals(foodId)))
        .getSingleOrNull();
    if (local != null) return _rowToItem(local);

    if (!await _isOnline()) return null;

    try {
      final resp = await http.get(
        Uri.parse('$_workerBaseUrl/food-db/item/$foodId'),
        headers: {'x-user-id': _userId},
      ).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        final item = FoodReferenceItem.fromJson(json['item'] as Map<String, dynamic>);
        await _upsertRemoteItems([item]);
        return item;
      }
    } catch (_) {
      // pass
    }
    return null;
  }

  /// Fetch distinct food categories — local first.
  Future<List<String>> getCategories() async {
    final rows = await (_db.selectOnly(_db.foodReferences)
          ..addColumns([_db.foodReferences.category])
          ..groupBy([_db.foodReferences.category])
          ..orderBy([OrderingTerm.asc(_db.foodReferences.category)]))
        .map((row) => row.read(_db.foodReferences.category) ?? '')
        .get();
    return rows.where((c) => c.isNotEmpty).toList();
  }

  // ── Private helpers ───────────────────────────────────────────────────────────
  Future<List<FoodReferenceItem>> _searchWorker(String query, {int limit = 20}) async {
    final uri = Uri.parse('$_workerBaseUrl/food-db/search')
        .replace(queryParameters: {'q': query, 'limit': '$limit'});
    final resp = await http.get(uri, headers: {'x-user-id': _userId})
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode != 200) return [];
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return itemsJson
        .map((e) => FoodReferenceItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _upsertRemoteItems(List<FoodReferenceItem> items) async {
    if (items.isEmpty) return;
    await _db.batch((batch) {
      for (final item in items) {
        batch.insert(
          _db.foodReferences,
          FoodReferencesCompanion.insert(
            foodId: item.foodId,
            foodName: item.foodName,
            defaultServing: item.defaultServing,
            calories: item.calories,
            proteinG: item.proteinG,
            carbsG: item.carbsG,
            fatG: item.fatG,
            glycemicIndex: item.glycemicIndex,
            fiberG: Value(item.fiberG),
            satietyIndex: item.satietyIndex,
            category: Value(item.category),
            region: Value(item.region),
            servingGrams: Value(item.servingGrams),
            sourceTag: Value(item.sourceTag),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  FoodReferenceItem _rowToItem(FoodReference row) => FoodReferenceItem(
        foodId: row.foodId,
        foodName: row.foodName,
        defaultServing: row.defaultServing,
        calories: row.calories,
        proteinG: row.proteinG,
        carbsG: row.carbsG,
        fatG: row.fatG,
        glycemicIndex: row.glycemicIndex,
        fiberG: row.fiberG,
        satietyIndex: row.satietyIndex,
        category: row.category,
        region: row.region,
        servingGrams: row.servingGrams,
        sourceTag: row.sourceTag,
      );

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
