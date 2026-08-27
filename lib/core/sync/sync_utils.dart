import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SyncUtils {
  static const _uuid = Uuid();

  /// Generates a unique idempotency key for sync-sensitive events (e.g. workout completion)
  static String generateIdempotencyKey() {
    return _uuid.v4();
  }

  /// Creates atomic increment map for cumulative metrics (steps, hydration, karma)
  static Map<String, dynamic> atomicIncrement(String field, num value) {
    return {
      field: FieldValue.increment(value),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Wraps document data with serverTimestamp to guarantee clock skew immunity
  static Map<String, dynamic> withServerTimestamp(Map<String, dynamic> data) {
    return {
      ...data,
      'serverTimestamp': FieldValue.serverTimestamp(),
    };
  }
}
