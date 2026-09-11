import 'package:uuid/uuid.dart';

class SyncUtils {
  static const _uuid = Uuid();

  /// Generates a unique idempotency key for sync-sensitive events (e.g. workout completion)
  static String generateIdempotencyKey() {
    return _uuid.v4();
  }

  /// Creates payload with UTC timestamp for clock skew immunity
  static Map<String, dynamic> withTimestamp(Map<String, dynamic> data) {
    return {
      ...data,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
