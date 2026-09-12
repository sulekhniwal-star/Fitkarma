import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/coach/data/coach_repository.dart';
import 'package:fitkarma/features/coach/data/coach_service.dart';
import 'package:fitkarma/features/coach/domain/models/coach_message.dart';
import 'package:fitkarma/features/coach/domain/services/coach_context_builder.dart';
import 'package:fitkarma/features/coach/domain/services/proactive_insights_engine.dart';
import 'package:fitkarma/features/onboarding/domain/models/onboarding_state.dart';

void main() {
  group('CoachContextBuilder', () {
    const builder = CoachContextBuilder();

    test('Assembles multi-modal context snapshot without PII leaks', () {
      final profile = LocalProfile(
        userId: 'user-secret-123',
        name: 'Aarav Sharma', // Not exported in context snapshot
        age: 28,
        gender: 'male',
        heightCm: 178.0,
        weightKg: 74.0,
        primaryGoal: 'fat_loss',
        updatedAt: DateTime.now(),
      );

      final dosha = LocalDoshaScore(
        id: 'dosha-1',
        userId: 'user-secret-123',
        vataScore: 10,
        pittaScore: 30,
        kaphaScore: 10,
        dominantDosha: 'pitta',
        assessedAt: DateTime.now(),
      );

      final snapshot = builder.buildContextSnapshot(
        profile: profile,
        dosha: dosha,
        blueprint: ProgramBlueprint.hypertrophyAesthetics,
      );

      expect(snapshot['user_meta']['age'], equals(28));
      expect(snapshot['ayurvedic_prakriti']['dominant_dosha'], equals('pitta'));
      expect(snapshot['user_meta'].containsKey('name'), isFalse); // Privacy check
    });

    test('buildSystemPrompt formats structured instructions with Indian dietary rules', () {
      final snapshot = {
        'user_meta': {'gender': 'male', 'age': 28, 'weight_kg': 74.0, 'primary_goal': 'fat_loss', 'program_blueprint': 'hypertrophyAesthetics'},
        'ayurvedic_prakriti': {'dominant_dosha': 'pitta'},
        'daily_readiness': {'score': 82, 'state': 'prime'},
        'metabolic_targets': {'target_calories': 2200, 'protein_grams': 148},
      };

      final prompt = builder.buildSystemPrompt(snapshot);
      expect(prompt, contains('FitKarma Coach'));
      expect(prompt, contains('Indian dietary patterns'));
      expect(prompt, contains('pitta dominant'));
    });
  });

  group('ProactiveInsightsEngine', () {
    const engine = ProactiveInsightsEngine();

    test('Triggers low readiness alert when score drops below 55', () {
      final insights = engine.evaluateTriggers(
        readinessScore: 48,
        sleepDebtHours: 0.5,
        soreMuscleCount: 0,
        hasPcos: false,
        cyclePhase: null,
        isEliteTier: false,
      );

      expect(insights.any((i) => i.triggerKey == 'low_readiness'), isTrue);
    });

    test('Triggers sleep debt alert and Pranayama recommendation when debt > 1.5h', () {
      final insights = engine.evaluateTriggers(
        readinessScore: 75,
        sleepDebtHours: 2.0,
        soreMuscleCount: 0,
        hasPcos: false,
        cyclePhase: null,
        isEliteTier: false,
      );

      expect(insights.any((i) => i.triggerKey == 'sleep_debt'), isTrue);
      expect(insights.firstWhere((i) => i.triggerKey == 'sleep_debt').suggestion, contains('Pranayama'));
    });
  });

  group('CoachRepository (Drift Caching & Outbox Sync)', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late CoachService coachService;
    late CoachRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db);
      coachService = CoachService(); // Uses offline fallback
      repo = CoachRepository(db: db, syncWorker: syncWorker, coachService: coachService);
    });

    tearDown(() async {
      syncWorker.dispose();
      await db.close();
    });

    test('getOrCreateActiveSession creates and caches session in Drift', () async {
      final sessionId = await repo.getOrCreateActiveSession('user-coach-test');
      expect(sessionId, isNotEmpty);

      final sessions = await db.select(db.localCoachSessions).get();
      expect(sessions.length, equals(1));
      expect(sessions.first.id, equals(sessionId));

      // Verify session queued in outbox
      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((m) => m.targetTable == 'coach_sessions'), isTrue);
    });

    test('sendUserMessage inserts user message optimistically and saves coach response', () async {
      final sessionId = await repo.getOrCreateActiveSession('user-coach-test');

      final reply = await repo.sendUserMessage(
        userId: 'user-coach-test',
        sessionId: sessionId,
        text: 'What are good high protein Indian foods?',
        contextSnapshot: {},
      );

      expect(reply.content, contains('Sattu'));
      expect(reply.sender, equals(MessageSender.coach));

      // Verify messages stored in Drift
      final messages = await repo.loadSessionMessages(sessionId);
      expect(messages.length, equals(2)); // User message + Coach reply
      expect(messages.first.sender, equals(MessageSender.user));
      expect(messages.last.sender, equals(MessageSender.coach));

      // Verify outbox queued for messages
      final pending = await db.select(db.pendingMutations).get();
      final messageMutations = pending.where((m) => m.targetTable == 'coach_messages').toList();
      expect(messageMutations.length, equals(2));
    });
  });
}
