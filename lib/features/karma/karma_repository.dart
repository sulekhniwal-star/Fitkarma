/// §P7-A Karma System Design — Repository
///
/// In-memory repository tracking logged KarmaEventRecord items and provider state.
library;

import 'package:fitkarma/features/karma/karma_engine.dart';
import 'package:fitkarma/features/karma/karma_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KarmaRepository {
  final List<KarmaEventRecord> _events = [];
  final KarmaEngine _engine = const KarmaEngine();

  /// Logs a new outcome achievement event and returns the awarded record.
  KarmaEventRecord recordOutcomeEvent(KarmaEventType eventType, {String? customDescription}) {
    final record = KarmaEventRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      eventType: eventType,
      xpAwarded: eventType.baseXp,
      timestamp: DateTime.now(),
      description: customDescription ?? eventType.displayName,
    );
    _events.add(record);
    return record;
  }

  /// Total cumulative XP across all logged events.
  int get totalXp {
    return _events.fold<int>(0, (sum, event) => sum + event.xpAwarded);
  }

  /// Profile summary derived from current total XP.
  KarmaProfileSummary get profileSummary {
    return _engine.calculateProfile(totalXp);
  }

  /// Unmodifiable history list of recorded events.
  List<KarmaEventRecord> get eventHistory => List.unmodifiable(_events);

  /// Clears in-memory storage (useful for testing).
  void clear() => _events.clear();
}

final karmaRepositoryProvider = Provider<KarmaRepository>((_) {
  return KarmaRepository();
});
