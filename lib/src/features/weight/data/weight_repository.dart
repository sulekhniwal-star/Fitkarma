import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../../../utils/logger.dart';
import '../domain/weight_log.dart';


part 'weight_repository.g.dart';

@riverpod
WeightRepository weightRepository(Ref ref) {
  final pb = ref.watch(pocketBaseProvider);
  return WeightRepository(pb);
}


class WeightRepository {
  final PocketBase _pb;
  static final _logger = AppLogger('WeightRepository');

  WeightRepository(this._pb);


  // Get all weight logs for a user
  Future<List<WeightLog>> getWeightLogs(String userId, {int limit = 100}) async {
    try {
      final records = await _pb.collection('weight_logs').getList(
        filter: 'user = "$userId"',
        sort: '-date',
        perPage: limit,
      );

      return records.items.map(_recordToWeightLog).toList();
    } catch (e) {
      _logger.e('Error getting weight logs', error: e);
      return [];
    }

  }

  // Get weight logs for a date range
  Future<List<WeightLog>> getWeightLogsForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final records = await _pb.collection('weight_logs').getList(
        filter: 'user = "$userId" && date >= "${start.toIso8601String()}" && date <= "${end.toIso8601String()}"',
        sort: '-date',
      );

      return records.items.map(_recordToWeightLog).toList();
    } catch (e) {
      _logger.e('Error getting weight logs for date range', error: e);
      return [];
    }

  }

  // Get latest weight log
  Future<WeightLog?> getLatestWeight(String userId) async {
    try {
      final records = await _pb.collection('weight_logs').getList(
        filter: 'user = "$userId"',
        sort: '-date',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToWeightLog(records.items.first);
    } catch (e) {
      _logger.e('Error getting latest weight', error: e);
      return null;
    }

  }

  // Create weight log
  Future<WeightLog> createWeightLog(WeightLog log) async {
    try {
      final record = await _pb.collection('weight_logs').create(
        body: _weightLogToBody(log),
      );
      return _recordToWeightLog(record);
    } catch (e) {
      _logger.e('Error creating weight log', error: e);
      rethrow;
    }

  }

  // Update weight log
  Future<WeightLog> updateWeightLog(WeightLog log) async {
    try {
      final record = await _pb.collection('weight_logs').update(
        log.id,
        body: _weightLogToBody(log),
      );
      return _recordToWeightLog(record);
    } catch (e) {
      _logger.e('Error updating weight log', error: e);
      rethrow;
    }

  }

  // Delete weight log
  Future<void> deleteWeightLog(String logId) async {
    try {
      await _pb.collection('weight_logs').delete(logId);
    } catch (e) {
      _logger.e('Error deleting weight log', error: e);
      rethrow;
    }

  }

  // Get weight goals
  Future<WeightGoals?> getWeightGoals(String userId) async {
    try {
      final records = await _pb.collection('user_weight_goals').getList(
        filter: 'user = "$userId"',
        page: 1,
        perPage: 1,
      );

      if (records.items.isEmpty) return null;
      
      return _recordToWeightGoals(records.items.first);
    } catch (e) {
      _logger.e('Error getting weight goals', error: e);
      return null;
    }

  }

  // Create or update weight goals
  Future<WeightGoals> saveWeightGoals(WeightGoals goals) async {
    try {
      final body = {
        'user': goals.userId,
        'start_weight': goals.startWeight,
        'current_weight': goals.currentWeight,
        'goal_weight': goals.goalWeight,
        'goal_type': goals.goalType,
        'weekly_goal_kg': goals.weeklyGoalKg,
        'reminder_enabled': goals.reminderEnabled,
        'reminder_day': goals.reminderDay,
        'reminder_time': goals.reminderTime,
        'photo_reminders': goals.photoReminders,
        'notifications_enabled': goals.notificationsEnabled,
      };

      RecordModel record;
      if (goals.id.isEmpty) {
        record = await _pb.collection('user_weight_goals').create(body: body);
      } else {
        record = await _pb.collection('user_weight_goals').update(
          goals.id,
          body: body,
        );
      }

      return _recordToWeightGoals(record);
    } catch (e) {
      _logger.e('Error saving weight goals', error: e);
      rethrow;
    }

  }

  // Calculate weight trends
  Future<List<WeightTrend>> calculateTrends(String userId, {int days = 30}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    final logs = await getWeightLogsForDateRange(userId, startDate, endDate);
    
    if (logs.isEmpty) return [];

    // Sort by date ascending for trend calculation
    logs.sort((a, b) => a.date.compareTo(b.date));

    final trends = <WeightTrend>[];
    double? previousWeight;

    for (int i = 0; i < logs.length; i++) {
      final log = logs[i];
      final change = previousWeight != null ? log.weight - previousWeight : null;
      
      // Calculate 7-day moving average if enough data
      double? movingAvg;
      if (i >= 6) {
        final last7Days = logs.sublist(i - 6, i + 1);
        final sum = last7Days.fold<double>(0, (acc, l) => acc + l.weight);
        movingAvg = sum / 7;
      }

      trends.add(WeightTrend(
        date: log.date,
        weight: log.weight,
        movingAverage: movingAvg,
        changeFromPrevious: change,
      ));

      previousWeight = log.weight;
    }

    return trends;
  }

  // Get weight stats
  Future<Map<String, dynamic>> getWeightStats(String userId) async {
    final logs = await getWeightLogs(userId);
    
    if (logs.isEmpty) {
      return {
        'currentWeight': null,
        'startWeight': null,
        'totalChange': null,
        'averageChangePerWeek': null,
        'minWeight': null,
        'maxWeight': null,
      };
    }

    final sortedLogs = logs..sort((a, b) => a.date.compareTo(b.date));
    final firstLog = sortedLogs.first;
    final lastLog = sortedLogs.last;

    final totalChange = lastLog.weight - firstLog.weight;
    final daysDifference = lastLog.date.difference(firstLog.date).inDays;
    final weeksDifference = daysDifference / 7;
    final averageChangePerWeek = weeksDifference > 0 ? totalChange / weeksDifference : 0;

    final weights = logs.map((l) => l.weight).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    return {
      'currentWeight': lastLog.weight,
      'startWeight': firstLog.weight,
      'totalChange': totalChange,
      'averageChangePerWeek': averageChangePerWeek,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
    };
  }

  // Helper: Convert record to WeightLog
  WeightLog _recordToWeightLog(RecordModel record) {
    return WeightLog(
      id: record.id,
      userId: record.getStringValue('user'),
      date: DateTime.parse(record.getStringValue('date')),
      weight: record.getDoubleValue('weight'),
      note: record.data['note']?.toString(),
      photo: record.data['photo']?.toString(),
      bodyFatPercentage: record.getDoubleValue('body_fat_percentage'),
      muscleMass: record.getDoubleValue('muscle_mass'),
      measurements: record.data['measurements'] != null
          ? BodyMeasurements.fromJson(record.data['measurements'] as Map<String, dynamic>)
          : null,
      mood: record.data['mood']?.toString(),
      isSynced: record.getBoolValue('is_synced', false),
    );
  }

  // Helper: Convert WeightLog to body map
  Map<String, dynamic> _weightLogToBody(WeightLog log) {
    return {
      'user': log.userId,
      'date': log.date.toIso8601String(),
      'weight': log.weight,
      'note': log.note,
      'photo': log.photo,
      'body_fat_percentage': log.bodyFatPercentage,
      'muscle_mass': log.muscleMass,
      'measurements': log.measurements?.toJson(),
      'mood': log.mood,
      'is_synced': log.isSynced,
    };
  }

  // Helper: Convert record to WeightGoals
  WeightGoals _recordToWeightGoals(RecordModel record) {
    return WeightGoals(
      id: record.id,
      userId: record.getStringValue('user'),
      startWeight: record.getDoubleValue('start_weight'),
      currentWeight: record.getDoubleValue('current_weight'),
      goalWeight: record.getDoubleValue('goal_weight'),
      goalType: record.getStringValue('goal_type', 'maintain'),
      weeklyGoalKg: record.getDoubleValue('weekly_goal_kg', 0.5),
      reminderEnabled: record.getBoolValue('reminder_enabled', true),
      reminderDay: record.getStringValue('reminder_day', 'weekly'),
      reminderTime: record.getStringValue('reminder_time', '08:00'),
      photoReminders: record.getBoolValue('photo_reminders', true),
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
