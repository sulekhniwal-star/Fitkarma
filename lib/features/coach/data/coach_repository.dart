import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/coach_message.dart';
import 'coach_service.dart';

/// CoachRepository — Local-First Message Caching with Optimistic UI & Remote Sync
class CoachRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final CoachService coachService;
  final _uuid = const Uuid();

  CoachRepository({
    required this.db,
    required this.syncWorker,
    required this.coachService,
  });

  /// Get or create today's active session
  Future<String> getOrCreateActiveSession(String userId) async {
    final existing = await (db.select(db.localCoachSessions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      return existing.id;
    }

    final newSessionId = _uuid.v4();
    final now = DateTime.now();

    await db.into(db.localCoachSessions).insert(
          LocalCoachSessionsCompanion.insert(
            id: newSessionId,
            userId: userId,
            title: const Value('Daily Health & Fitness Coaching'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    // Queue session mutation
    await syncWorker.enqueueMutation(
      tableName: 'coach_sessions',
      action: 'INSERT',
      payload: {
        'id': newSessionId,
        'user_id': userId,
        'title': 'Daily Health & Fitness Coaching',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    );

    return newSessionId;
  }

  /// Load session message history from local Drift
  Future<List<CoachMessage>> loadSessionMessages(String sessionId) async {
    final rows = await (db.select(db.localCoachMessages)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
        .get();

    return rows.map((r) {
      return CoachMessage(
        id: r.id,
        sessionId: r.sessionId,
        sender: MessageSender.values.firstWhere(
          (s) => s.name == r.sender,
          orElse: () => MessageSender.coach,
        ),
        content: r.content,
        modelUsed: r.modelUsed,
        timestamp: r.timestamp,
      );
    }).toList();
  }

  /// Send user message optimistically, cache locally, and invoke CoachService
  Future<CoachMessage> sendUserMessage({
    required String userId,
    required String sessionId,
    required String text,
    required Map<String, dynamic> contextSnapshot,
  }) async {
    final userMsgId = _uuid.v4();
    final now = DateTime.now();

    // 1. Optimistic Local Insert for User Message
    await db.into(db.localCoachMessages).insert(
          LocalCoachMessagesCompanion.insert(
            id: userMsgId,
            sessionId: sessionId,
            sender: MessageSender.user.name,
            content: text,
            timestamp: Value(now),
          ),
        );

    // 2. Queue Outbox for User Message
    await syncWorker.enqueueMutation(
      tableName: 'coach_messages',
      action: 'INSERT',
      payload: {
        'id': userMsgId,
        'session_id': sessionId,
        'user_id': userId,
        'sender': 'user',
        'content': text,
        'created_at': now.toIso8601String(),
      },
    );

    // 3. Request Coach Response from Edge Function
    final responseMsg = await coachService.sendMessage(
      sessionId: sessionId,
      userMessage: text,
      contextSnapshot: contextSnapshot,
    );

    // 4. Save Coach Response in Drift
    await db.into(db.localCoachMessages).insert(
          LocalCoachMessagesCompanion.insert(
            id: responseMsg.id,
            sessionId: sessionId,
            sender: MessageSender.coach.name,
            content: responseMsg.content,
            modelUsed: Value(responseMsg.modelUsed),
            timestamp: Value(responseMsg.timestamp),
          ),
        );

    // 5. Queue Outbox for Coach Message
    await syncWorker.enqueueMutation(
      tableName: 'coach_messages',
      action: 'INSERT',
      payload: {
        'id': responseMsg.id,
        'session_id': sessionId,
        'user_id': userId,
        'sender': 'coach',
        'content': responseMsg.content,
        'model_used': responseMsg.modelUsed,
        'created_at': responseMsg.timestamp.toIso8601String(),
      },
    );

    return responseMsg;
  }
}
