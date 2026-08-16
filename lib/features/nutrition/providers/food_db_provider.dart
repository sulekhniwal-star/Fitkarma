// §P5-D Food Database Providers — Offline-First Food Search & Logging
// Source: §P5-D Smart Indian Meal Intelligence

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/fitkarma_database.dart';
import '../data/food_db_repository.dart';
import '../data/food_log_repository.dart';

// ── Worker URL constant ────────────────────────────────────────────────────────
// Override per environment via --dart-define=WORKER_BASE_URL=https://...
// Staging is the safe default; prod URL is set via CI/CD --dart-define.
const String _kWorkerBaseUrl = String.fromEnvironment(
  'WORKER_BASE_URL',
  defaultValue: 'https://fitkarma-api-staging.workers.dev',
);

// ── Database provider ─────────────────────────────────────────────────────────
// The real FitKarmaDatabase singleton — override in ProviderScope overrides
// at app startup (main.dart) once the DB is opened.
final fitKarmaDatabaseProvider = Provider<FitKarmaDatabase>((ref) {
  throw UnimplementedError(
    'fitKarmaDatabaseProvider must be overridden with an open FitKarmaDatabase '
    'instance in the root ProviderScope.',
  );
});

// ── User ID provider ──────────────────────────────────────────────────────────
// Replace with real session user ID once auth is wired.
final currentUserIdProvider = Provider<String>((ref) => 'usr_local');

// ── Repository providers ──────────────────────────────────────────────────────
final foodDbRepositoryProvider = Provider<FoodDbRepository>((ref) {
  final db = ref.watch(fitKarmaDatabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return FoodDbRepository(
    db: db,
    workerBaseUrl: _kWorkerBaseUrl,
    userId: userId,
  );
});

final foodLogRepositoryProvider = Provider<FoodLogRepository>((ref) {
  final db = ref.watch(fitKarmaDatabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return FoodLogRepository(
    db: db,
    workerBaseUrl: _kWorkerBaseUrl,
    userId: userId,
  );
});

// ── Food search — FutureProvider.family ──────────────────────────────────────
/// Live food search — query must be >= 2 chars.
/// Returns local Drift results instantly, with Worker fallback when online.
final foodSearchProvider =
    FutureProvider.family<List<FoodReferenceItem>, String>((ref, query) async {
  if (query.trim().length < 2) return [];
  final repo = ref.watch(foodDbRepositoryProvider);
  return repo.searchFood(query.trim());
});

/// All food categories available in local Drift (populated after seed).
final foodCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(foodDbRepositoryProvider);
  return repo.getCategories();
});

/// Today's food logs for the current user (from local Drift).
final todaysFoodLogsProvider =
    FutureProvider<List<FoodLog>>((ref) async {
  final repo = ref.watch(foodLogRepositoryProvider);
  return repo.getTodaysLogs();
});
