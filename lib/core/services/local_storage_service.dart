import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// LocalStorageService manages high-frequency, transient, or draft data
/// that should not round-trip directly to Firestore.
class LocalStorageService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.hiveDraftBox);
    await Hive.openBox(AppConstants.hiveActiveWorkoutBox);
    debugPrint('FitKarma LocalStorageService (Hive) initialized.');
  }

  static Box get draftsBox => Hive.box(AppConstants.hiveDraftBox);
  static Box get activeWorkoutBox =>
      Hive.box(AppConstants.hiveActiveWorkoutBox);

  // Draft operations
  static Future<void> saveDraft(String key, dynamic value) async {
    await draftsBox.put(key, value);
  }

  static dynamic getDraft(String key) {
    return draftsBox.get(key);
  }

  static Future<void> deleteDraft(String key) async {
    await draftsBox.delete(key);
  }

  // Active workout operations (local-only high frequency state)
  static Future<void> saveActiveWorkoutState(Map<String, dynamic> state) async {
    await activeWorkoutBox.put('current_session', state);
  }

  static Map<String, dynamic>? getActiveWorkoutState() {
    final data = activeWorkoutBox.get('current_session');
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  // Key-Value String operations (Offline sync queues, cached payloads)
  static Future<void> setString(String key, String value) async {
    await draftsBox.put(key, value);
  }

  static String? getString(String key) {
    final value = draftsBox.get(key);
    return value is String ? value : null;
  }

  static Future<void> deleteString(String key) async {
    await draftsBox.delete(key);
  }

  // Instance methods for dependency injection
  Future<void> setStringInstance(String key, String value) => setString(key, value);
  String? getStringInstance(String key) => getString(key);
  Future<void> deleteStringInstance(String key) => deleteString(key);

  String? get(String key) => getString(key);
  Future<void> set(String key, String value) => setString(key, value);
}
