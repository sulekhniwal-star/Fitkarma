import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/coach/ai_coach_controller.dart';
import 'package:fitkarma/features/coach/coach_escalation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CoachEscalationService escalationService;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
    escalationService = CoachEscalationService();
  });

  tearDown(() async {
    await db.close();
  });

  group('CoachEscalationService Triggers Tests', () {
    test('shouldEscalate is true when high severity risk exists', () {
      final state = const UserState(
        activeRisks: [
          ActiveRisk(label: 'Severe Chest Pain', severity: RiskSeverity.high),
        ],
      );
      expect(escalationService.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate is true when plateau weeks >= 4 and adaptive calories adjusted', () {
      final state = const UserState(
        plateauWeeks: 4,
        adaptiveCaloriesAlreadyAdjusted: true,
      );
      expect(escalationService.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate is false when plateau weeks >= 4 but adaptive calories not adjusted', () {
      final state = const UserState(
        plateauWeeks: 4,
        adaptiveCaloriesAlreadyAdjusted: false,
      );
      expect(escalationService.shouldEscalate(state), isFalse);
    });

    test('shouldEscalate is true when consecutive relapse attempts >= 3', () {
      final state = const UserState(
        consecutiveRelapseAttempts: 3,
      );
      expect(escalationService.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate is true when user explicitly requests human coach', () {
      final state = const UserState(
        userRequestedHumanCoach: true,
      );
      expect(escalationService.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate is false under normal state', () {
      final state = const UserState(
        activeRisks: [
          ActiveRisk(label: 'Mild Soreness', severity: RiskSeverity.low),
        ],
        plateauWeeks: 2,
        adaptiveCaloriesAlreadyAdjusted: true,
        consecutiveRelapseAttempts: 1,
        userRequestedHumanCoach: false,
      );
      expect(escalationService.shouldEscalate(state), isFalse);
    });
  });

  group('Database Logging and Briefing Tests', () {
    test('escalate writes to db and formats a briefing', () async {
      // Seed user profile
      await db.into(db.users).insert(UsersCompanion.insert(
        id: 'test_user_id',
        name: const Value('Arjun Kumar'),
        goals: const Value('["weight_loss"]'),
        currentProgram: const Value('Wedding Transformation'),
        subscriptionTier: const Value('eliteCoach'),
      ));

      await escalationService.escalate(
        userId: 'test_user_id',
        reason: 'Plateau threshold exceeded',
        db: db,
      );

      final loggedEvents = await db.getEscalationEvents('test_user_id');
      expect(loggedEvents, hasLength(1));
      expect(loggedEvents.first.reason, 'Plateau threshold exceeded');
      expect(loggedEvents.first.briefing, contains('Arjun Kumar'));
      expect(loggedEvents.first.briefing, contains('Wedding Transformation'));
      expect(loggedEvents.first.resolvedAt, isNull);
    });
  });

  group('AiCoachChatNotifier Escalation Flow Tests', () {
    test('keyword triggers automated escalation only for eliteCoach tier', () async {
      // Seed user profile with eliteCoach tier
      await db.into(db.users).insert(UsersCompanion.insert(
        id: 'user_1',
        name: const Value('Dev Patel'),
        subscriptionTier: const Value('eliteCoach'),
      ));

      final container = ProviderContainer(
        overrides: [],
      );
      final notifier = container.read(aiCoachChatProvider.notifier);

      // Load conversation
      await notifier.loadCachedConversation(userId: 'user_1', conversationId: 'conv_1', db: db);
      expect(notifier.state.subscriptionTier, 'eliteCoach');
      expect(notifier.state.isEscalated, isFalse);

      // Send message containing "plateau" keyword
      await notifier.sendMessage(
        userId: 'user_1',
        text: 'I have hit a plateau for 4 weeks.',
        db: db,
      );

      expect(notifier.state.isEscalated, isTrue);
      expect(notifier.state.messages.last.messageContent, contains('Plan under human review.'));
      
      final dbEvents = await db.getEscalationEvents('user_1');
      expect(dbEvents, hasLength(1));
      expect(dbEvents.first.reason, contains('plateau'));
    });

    test('keyword triggers do not escalate for free tier', () async {
      // Seed user profile with free tier
      await db.into(db.users).insert(UsersCompanion.insert(
        id: 'user_2',
        name: const Value('Rohan Sharma'),
        subscriptionTier: const Value('free'),
      ));

      final container = ProviderContainer();
      final notifier = container.read(aiCoachChatProvider.notifier);

      await notifier.loadCachedConversation(userId: 'user_2', conversationId: 'conv_2', db: db);
      expect(notifier.state.subscriptionTier, 'free');

      await notifier.sendMessage(
        userId: 'user_2',
        text: 'I have hit a plateau for 4 weeks.',
        db: db,
      );

      expect(notifier.state.isEscalated, isFalse);
    });
  });
}
