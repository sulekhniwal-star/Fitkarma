import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../../../utils/logger.dart';
import '../domain/step_log.dart';


part 'steps_repository.g.dart';

@riverpod
StepsRepository stepsRepository(Ref ref) {
  final pb = ref.watch(pocketBaseProvider);
  return StepsRepository(pb);
}


class StepsRepository {
  final PocketBase _pb;
  final _logger = const AppLogger('StepsRepository');

  StepsRepository(this._pb);


  // Get today's step log for a user
  Future<StepLog?> getTodaySteps(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final records = await _pb.collection('steps_logs').getList(
        filter: 'user = "$userId" && date >= "${startOfDay.toIso8601String()}" && date < "${startOfDay.add(const Duration(days: 1)).toIso8601String()}"',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToStepLog(records.items.first);
    } catch (e) {
      _logger.e('Error getting today steps', error: e);
      return null;
    }

  }

  // Get step logs for a date range
  Future<List<StepLog>> getStepsForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final records = await _pb.collection('steps_logs').getList(
        filter: 'user = "$userId" && date >= "${start.toIso8601String()}" && date <= "${end.toIso8601String()}"',
        sort: '-date',
      );

      return records.items.map(_recordToStepLog).toList();
    } catch (e) {
      _logger.e('Error getting steps for date range', error: e);
      return [];
    }

  }

  // Get or create today's step log
  Future<StepLog> getOrCreateTodaySteps(String userId) async {
    final existing = await getTodaySteps(userId);
    if (existing != null) return existing;

    // Create new empty log
    final newLog = StepLog.empty(userId, DateTime.now());
    return await createStepLog(newLog);
  }

  // Create step log
  Future<StepLog> createStepLog(StepLog log) async {
    try {
      final record = await _pb.collection('steps_logs').create(
        body: _stepLogToBody(log),
      );
      return _recordToStepLog(record);
    } catch (e) {
      _logger.e('Error creating step log', error: e);
      rethrow;
    }

  }

  // Update step log
  Future<StepLog> updateStepLog(StepLog log) async {
    try {
      final record = await _pb.collection('steps_logs').update(
        log.id,
        body: _stepLogToBody(log),
      );
      return _recordToStepLog(record);
    } catch (e) {
      _logger.e('Error updating step log', error: e);
      rethrow;
    }

  }

  // Add steps to today's log
  Future<StepLog> addSteps(String userId, int stepsToAdd, {String source = 'manual'}) async {
    final log = await getOrCreateTodaySteps(userId);
    
    // Update hourly data if available
    final now = DateTime.now();
    final hour = now.hour;
    final updatedHourlyData = List<int>.from(log.hourlyData);
    if (hour < updatedHourlyData.length) {
      updatedHourlyData[hour] = updatedHourlyData[hour] + stepsToAdd;
    }

    final updatedLog = log.copyWith(
      steps: log.steps + stepsToAdd,
      hourlyData: updatedHourlyData,
      source: source,
    );

    return await updateStepLog(updatedLog);
  }

  // Get step settings
  Future<StepSettings?> getStepSettings(String userId) async {
    try {
      final records = await _pb.collection('user_steps_settings').getList(
        filter: 'user = "$userId"',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToStepSettings(records.items.first);
    } catch (e) {
      _logger.e('Error getting step settings', error: e);
      return null;
    }

  }

  // Create or update step settings
  Future<StepSettings> saveStepSettings(StepSettings settings) async {
    try {
      final body = {
        'user': settings.userId,
        'daily_goal': settings.dailyGoal,
        'reminder_enabled': settings.reminderEnabled,
        'reminder_time': settings.reminderTime,
        'cricket_mode': settings.cricketMode,
        'notifications_enabled': settings.notificationsEnabled,
      };

      RecordModel record;
      if (settings.id.isEmpty) {
        record = await _pb.collection('user_steps_settings').create(body: body);
      } else {
        record = await _pb.collection('user_steps_settings').update(
          settings.id,
          body: body,
        );
      }

      return _recordToStepSettings(record);
    } catch (e) {
      _logger.e('Error saving step settings', error: e);
      rethrow;
    }

  }

  // Get weekly stats
  Future<Map<String, dynamic>> getWeeklyStats(String userId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final logs = await getStepsForDateRange(userId, weekAgo, now);
    
    if (logs.isEmpty) {
      return {
        'totalSteps': 0,
        'averageSteps': 0,
        'bestDay': null,
        'goalAchievement': 0.0,
      };
    }

    final totalSteps = logs.fold<int>(0, (sum, log) => sum + log.steps);
    final averageSteps = totalSteps / logs.length;
    final bestDay = logs.reduce((a, b) => a.steps > b.steps ? a : b);
    final daysGoalAchieved = logs.where((log) => log.isGoalAchieved).length;
    final goalAchievement = daysGoalAchieved / logs.length;

    return {
      'totalSteps': totalSteps,
      'averageSteps': averageSteps.round(),
      'bestDay': bestDay,
      'goalAchievement': goalAchievement,
    };
  }

  // Helper: Convert record to StepLog
  StepLog _recordToStepLog(RecordModel record) {
    return StepLog(
      id: record.id,
      userId: record.getStringValue('user'),
      date: DateTime.parse(record.getStringValue('date')),
      steps: record.getIntValue('steps', 0),
      goal: record.getIntValue('goal', 8000),
      distanceKm: record.getDoubleValue('distance_km'),
      calories: record.getDoubleValue('calories'),
      hourlyData: record.data['hourly_data'] != null
          ? List<int>.from(record.data['hourly_data'])
          : List.filled(24, 0),
      source: record.getStringValue('source', 'pedometer'),
      isSynced: record.getBoolValue('is_synced', false),
    );
  }

  // Helper: Convert StepLog to body map
  Map<String, dynamic> _stepLogToBody(StepLog log) {
    return {
      'user': log.userId,
      'date': log.date.toIso8601String(),
      'steps': log.steps,
      'goal': log.goal,
      'distance_km': log.calculatedDistanceKm,
      'calories': log.calculatedCalories,
      'hourly_data': log.hourlyData,
      'source': log.source,
      'is_synced': log.isSynced,
    };
  }

  // Helper: Convert record to StepSettings
  StepSettings _recordToStepSettings(RecordModel record) {
    return StepSettings(
      id: record.id,
      userId: record.getStringValue('user'),
      dailyGoal: record.getIntValue('daily_goal', 8000),
      reminderEnabled: record.getBoolValue('reminder_enabled', true),
      reminderTime: record.getStringValue('reminder_time', '18:00'),
      cricketMode: record.getBoolValue('cricket_mode', false),
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
