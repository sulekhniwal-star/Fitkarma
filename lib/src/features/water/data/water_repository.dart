import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../../../utils/logger.dart';
import '../domain/water_log.dart';


part 'water_repository.g.dart';

@riverpod
WaterRepository waterRepository(Ref ref) {
  final pb = ref.watch(pocketBaseProvider);
  return WaterRepository(pb);
}


class WaterRepository {
  final PocketBase _pb;
  final AppLogger _logger = const AppLogger('WaterRepository');

  WaterRepository(this._pb);


  // Get today's water log for a user
  Future<WaterLog?> getTodayWater(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final records = await _pb.collection('water_logs').getList(
        filter: 'user = "$userId" && date >= "${startOfDay.toIso8601String()}" && date < "${startOfDay.add(const Duration(days: 1)).toIso8601String()}"',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToWaterLog(records.items.first);
    } catch (e) {
      _logger.e('Error getting today water', error: e);
      return null;
    }

  }

  // Get or create today's water log
  Future<WaterLog> getOrCreateTodayWater(String userId) async {
    final existing = await getTodayWater(userId);
    if (existing != null) return existing;

    // Create new empty log
    final newLog = WaterLog.empty(userId, DateTime.now());
    return await createWaterLog(newLog);
  }

  // Create water log
  Future<WaterLog> createWaterLog(WaterLog log) async {
    try {
      final record = await _pb.collection('water_logs').create(
        body: _waterLogToBody(log),
      );
      return _recordToWaterLog(record);
    } catch (e) {
      _logger.e('Error creating water log', error: e);
      rethrow;
    }

  }

  // Update water log
  Future<WaterLog> updateWaterLog(WaterLog log) async {
    try {
      final record = await _pb.collection('water_logs').update(
        log.id,
        body: _waterLogToBody(log),
      );
      return _recordToWaterLog(record);
    } catch (e) {
      _logger.e('Error updating water log', error: e);
      rethrow;
    }

  }

  // Add water entry
  Future<WaterLog> addWater(String userId, int amountMl, String type, {String? note}) async {
    final log = await getOrCreateTodayWater(userId);
    
    // Calculate glasses (assuming 250ml per glass)
    final glassesToAdd = (amountMl / 250).ceil();
    
    final entry = WaterEntry(
      time: DateTime.now(),
      amountMl: amountMl,
      type: type,
      note: note,
    );

    final updatedEntries = [...log.entries, entry];
    
    final updatedLog = log.copyWith(
      glasses: log.glasses + glassesToAdd,
      mlTotal: log.mlTotal + amountMl,
      entries: updatedEntries,
      lastEntryTime: DateTime.now(),
    );

    return await updateWaterLog(updatedLog);
  }

  // Quick add methods
  Future<WaterLog> addGlass(String userId, {int? customSizeMl}) async {
    final settings = await getWaterSettings(userId);
    final size = customSizeMl ?? settings?.glassSizeMl ?? 250;
    return await addWater(userId, size, 'glass');
  }

  Future<WaterLog> addBottle(String userId, {int? customSizeMl}) async {
    final settings = await getWaterSettings(userId);
    final size = customSizeMl ?? settings?.bottleSizeMl ?? 500;
    return await addWater(userId, size, 'bottle');
  }

  Future<WaterLog> addChai(String userId, {int? customSizeMl}) async {
    final settings = await getWaterSettings(userId);
    final size = customSizeMl ?? settings?.chaiSizeMl ?? 150;
    return await addWater(userId, size, 'chai');
  }

  // Get water settings
  Future<WaterSettings?> getWaterSettings(String userId) async {
    try {
      final records = await _pb.collection('user_water_settings').getList(
        filter: 'user = "$userId"',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToWaterSettings(records.items.first);
    } catch (e) {
      _logger.e('Error getting water settings', error: e);
      return null;
    }

  }

  // Create or update water settings
  Future<WaterSettings> saveWaterSettings(WaterSettings settings) async {
    try {
      final body = {
        'user': settings.userId,
        'daily_goal': settings.dailyGoal,
        'glass_size_ml': settings.glassSizeMl,
        'bottle_size_ml': settings.bottleSizeMl,
        'chai_size_ml': settings.chaiSizeMl,
        'reminder_enabled': settings.reminderEnabled,
        'reminder_interval_hours': settings.reminderIntervalHours,
        'reminder_start_time': settings.reminderStartTime,
        'reminder_end_time': settings.reminderEndTime,
        'smart_reminders': settings.smartReminders,
        'notifications_enabled': settings.notificationsEnabled,
      };

      RecordModel record;
      if (settings.id.isEmpty) {
        record = await _pb.collection('user_water_settings').create(body: body);
      } else {
        record = await _pb.collection('user_water_settings').update(
          settings.id,
          body: body,
        );
      }

      return _recordToWaterSettings(record);
    } catch (e) {
      _logger.e('Error saving water settings', error: e);
      rethrow;
    }

  }

  // Get hydration streak
  Future<int> getHydrationStreak(String userId) async {
    try {
      final records = await _pb.collection('water_logs').getList(
        filter: 'user = "$userId" && glasses >= goal',
        sort: '-date',
        page: 1,
        perPage: 100,
      );

      if (records.items.isEmpty) return 0;

      int streak = 0;
      DateTime checkDate = DateTime.now();

      for (final record in records.items) {
        final recordDate = DateTime.parse(record.getStringValue('date'));
        final expectedDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
        
        if (recordDate.year == expectedDate.year &&
            recordDate.month == expectedDate.month &&
            recordDate.day == expectedDate.day) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      _logger.e('Error getting hydration streak', error: e);
      return 0;
    }

  }

  // Get weekly hydration stats
  Future<Map<String, dynamic>> getWeeklyStats(String userId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final records = await _pb.collection('water_logs').getList(
      filter: 'user = "$userId" && date >= "${weekAgo.toIso8601String()}" && date <= "${now.toIso8601String()}"',
      sort: '-date',
    );

    if (records.items.isEmpty) {
      return {
        'averageGlasses': 0.0,
        'goalAchievementDays': 0,
        'totalGlasses': 0,
      };
    }

    final logs = records.items.map(_recordToWaterLog).toList();
    final totalGlasses = logs.fold<int>(0, (sum, log) => sum + log.glasses);
    final averageGlasses = totalGlasses / logs.length;
    final goalAchievementDays = logs.where((log) => log.isGoalAchieved).length;

    return {
      'averageGlasses': averageGlasses,
      'goalAchievementDays': goalAchievementDays,
      'totalGlasses': totalGlasses,
    };
  }

  // Helper: Convert record to WaterLog
  WaterLog _recordToWaterLog(RecordModel record) {
    return WaterLog(
      id: record.id,
      userId: record.getStringValue('user'),
      date: DateTime.parse(record.getStringValue('date')),
      glasses: record.getIntValue('glasses', 0),
      goal: record.getIntValue('goal', 8),
      mlTotal: record.getIntValue('ml_total', 0),
      entries: record.data['entries'] != null
          ? (record.data['entries'] as List)
              .map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      streakDays: record.getIntValue('streak_days', 0),
      lastEntryTime: record.data['last_entry_time'] != null
          ? DateTime.parse(record.getStringValue('last_entry_time'))
          : null,
      isSynced: record.getBoolValue('is_synced', false),
    );
  }

  // Helper: Convert WaterLog to body map
  Map<String, dynamic> _waterLogToBody(WaterLog log) {
    return {
      'user': log.userId,
      'date': log.date.toIso8601String(),
      'glasses': log.glasses,
      'goal': log.goal,
      'ml_total': log.mlTotal,
      'entries': log.entries.map((e) => {
        'time': e.time.toIso8601String(),
        'amount_ml': e.amountMl,
        'type': e.type,
        'note': e.note,
      }).toList(),
      'streak_days': log.streakDays,
      'last_entry_time': log.lastEntryTime?.toIso8601String(),
      'is_synced': log.isSynced,
    };
  }

  // Helper: Convert record to WaterSettings
  WaterSettings _recordToWaterSettings(RecordModel record) {
    return WaterSettings(
      id: record.id,
      userId: record.getStringValue('user'),
      dailyGoal: record.getIntValue('daily_goal', 8),
      glassSizeMl: record.getIntValue('glass_size_ml', 250),
      bottleSizeMl: record.getIntValue('bottle_size_ml', 500),
      chaiSizeMl: record.getIntValue('chai_size_ml', 150),
      reminderEnabled: record.getBoolValue('reminder_enabled', true),
      reminderIntervalHours: record.getIntValue('reminder_interval_hours', 2),
      reminderStartTime: record.getStringValue('reminder_start_time', '08:00'),
      reminderEndTime: record.getStringValue('reminder_end_time', '20:00'),
      smartReminders: record.getBoolValue('smart_reminders', true),
      notificationsEnabled: record.getBoolValue('notifications_enabled', true),
    );
  }
}

// Extension helpers for RecordModel
extension RecordModelHelpers on RecordModel {
  String getStringValue(String key, [String defaultValue = '']) {
    return (data[key] ?? defaultValue).toString();
  }

  int getIntValue(String key, [int defaultValue = 0]) {
    final value = data[key];
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  double getDoubleValue(String key, [double? defaultValue]) {
    final value = data[key];
    if (value == null) return defaultValue ?? 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue ?? 0.0;
  }

  bool getBoolValue(String key, [bool defaultValue = false]) {
    final value = data[key];
    if (value == null) return defaultValue;
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }
}
