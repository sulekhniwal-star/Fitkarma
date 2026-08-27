import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/daily_intelligence_package.dart';
import '../data/health_os_repository.dart';

final healthOsRepositoryProvider = Provider<HealthOsRepository>((ref) {
  return HealthOsRepository();
});

// Current selected date provider (defaults to today)
final selectedDateProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

// Current user ID provider (will integrate with FirebaseAuth in Auth phase)
final currentUserIdProvider = StateProvider<String>((ref) {
  return 'demo_user_uid';
});

// Daily Intelligence Package Provider
final dailyIntelligenceProvider = FutureProvider.autoDispose<DailyIntelligencePackage>((ref) async {
  final repository = ref.watch(healthOsRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  return await repository.getDailyPackage(uid: uid, dateStr: date);
});
