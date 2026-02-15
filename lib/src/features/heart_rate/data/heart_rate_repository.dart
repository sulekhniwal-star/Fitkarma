import 'package:pocketbase/pocketbase.dart';
import '../domain/heart_rate_log.dart';

class HeartRateRepository {
  final PocketBase pb;
  
  HeartRateRepository(this.pb);

  // Log a heart rate reading
  Future<void> logHeartRate(HeartRateLog log) async {
    await pb.collection('heart_rate_logs').create(body: log.toJson());
  }

  // Get user's heart rate logs
  Future<List<HeartRateLog>> getHeartRateLogs(String oderId, {int limit = 30}) async {
    try {
      final records = await pb.collection('heart_rate_logs').getList(
        filter: 'user = "$oderId"',
        sort: '-date',
      );
      
      return records.items.map((record) => HeartRateLog.fromJson(record.toJson())).toList();
    } catch (e) {
      return [];
    }
  }

  // Get today's heart rate readings
  Future<List<HeartRateLog>> getTodayHeartRateLogs(String oderId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    try {
      final records = await pb.collection('heart_rate_logs').getList(
        filter: 'user = "$oderId" && date >= "${startOfDay.toIso8601String()}" && date < "${endOfDay.toIso8601String()}"',
        sort: '-date',
      );
      
      return records.items.map((record) => HeartRateLog.fromJson(record.toJson())).toList();
    } catch (e) {
      return [];
    }
  }

  // Get latest heart rate
  Future<HeartRateLog?> getLatestHeartRate(String oderId) async {
    try {
      final records = await pb.collection('heart_rate_logs').getList(
        filter: 'user = "$oderId"',
        sort: '-date',
      );
      
      if (records.items.isEmpty) return null;
      return HeartRateLog.fromJson(records.items.first.toJson());
    } catch (e) {
      return null;
    }
  }

  // Get resting heart rate (average of morning readings)
  Future<int?> getRestingHeartRate(String oderId) async {
    final logs = await getHeartRateLogs(oderId, limit: 7);
    if (logs.isEmpty) return null;
    
    // Get readings from early morning (5-9 AM)
    final morningLogs = logs.where((log) {
      final hour = log.date.hour;
      return hour >= 5 && hour <= 9;
    }).toList();
    
    if (morningLogs.isEmpty) return null;
    
    final total = morningLogs.fold<int>(0, (sum, log) => sum + log.bpm);
    return (total / morningLogs.length).round();
  }

  // Delete a heart rate log
  Future<void> deleteHeartRateLog(String id) async {
    await pb.collection('heart_rate_logs').delete(id);
  }
}
