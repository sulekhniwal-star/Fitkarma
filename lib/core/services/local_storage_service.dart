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
  static Box get activeWorkoutBox => Hive.box(AppConstants.hiveActiveWorkoutBox);

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

  static Future<void> clearActiveWorkoutState() async {
    await activeWorkoutBox.delete('current_session');
  }
}
