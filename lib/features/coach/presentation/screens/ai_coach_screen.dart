import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../main.dart';
import '../../data/coach_repository.dart';
import '../../data/coach_service.dart';
import '../../domain/models/coach_message.dart';
import '../../domain/services/proactive_insights_engine.dart';

final coachServiceProvider = Provider<CoachService>((ref) {
  return CoachService();
});

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  final service = ref.watch(coachServiceProvider);
  return CoachRepository(db: db, syncWorker: syncWorker, coachService: service);
});

class AICoachScreen extends ConsumerStatefulWidget {
  const AICoachScreen({super.key});

  @override
  ConsumerState<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends ConsumerState<AICoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<CoachMessage> _messages = [];
  String? _sessionId;
  bool _isTyping = false;

  final _insightsEngine = const ProactiveInsightsEngine();
  List<ProactiveInsight> _activeInsights = [];

  static const List<String> _quickPrompts = [
    'Fix my lunch for high protein 🥗',
    'Low readiness workout adjustment ⚡',
    'Ayurvedic cooling food suggestions 🌿',
    'How to recover from sleep debt 🌙',
  ];

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
  }

  Future<void> _initializeChatSession() async {
    final repo = ref.read(coachRepositoryProvider);
    final sessionId = await repo.getOrCreateActiveSession('local-user-demo-1');
    final history = await repo.loadSessionMessages(sessionId);

    final insights = _insightsEngine.evaluateTriggers(
      readinessScore: 54, // Example alert
      sleepDebtHours: 1.8,
      soreMuscleCount: 2,
      hasPcos: false,
      cyclePhase: null,
      isEliteTier: false,
    );

    setState(() {
      _sessionId = sessionId;
      _messages.addAll(history);
      _activeInsights = insights;

      if (_messages.isEmpty) {
        _messages.add(
          CoachMessage(
            id: 'welcome-1',
            sessionId: sessionId,
            sender: MessageSender.coach,
            content: 'Namaste! I am your FitKarma Adaptive Coach. How can I optimize your training, Indian nutrition, or recovery today?',
            timestamp: DateTime.now(),
          ),
        );
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty || _sessionId == null) return;
    _textController.clear();

    final userMsg = CoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: _sessionId!,
      sender: MessageSender.user,
      content: text,
      timestamp: DateTime.now(),
      isOptimistic: true,
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });
    _scrollToBottom();

    final contextSnapshot = {
      'user_meta': {'gender': 'male', 'age': 27, 'weight_kg': 72.0, 'primary_goal': 'fat_loss'},
      'ayurvedic_prakriti': {'dominant_dosha': 'pitta'},
      'daily_readiness': {'score': 84, 'state': 'prime'},
      'metabolic_targets': {'target_calories': 2100, 'protein_grams': 140},
    };

    final repo = ref.read(coachRepositoryProvider);
    final reply = await repo.sendUserMessage(
      userId: 'local-user-demo-1',
      sessionId: _sessionId!,
      text: text,
      contextSnapshot: contextSnapshot,
    );

    setState(() {
      _messages.add(reply);
      _isTyping = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.readinessGradient,
              ),
              child: const Icon(Icons.psychology_rounded, size: 20, color: AppColors.background),
            ),
            const SizedBox(width: 12),
            const BilingualLabel(
              english: 'FitKarma AI Coach',
              hindi: 'एआई एडाप्टिव कोच',
              primaryStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Proactive Insights Banner
            if (_activeInsights.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: BentoCard(
                  isGlowing: true,
                  glowColor: AppColors.accentAmber,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.offline_bolt_rounded, color: AppColors.accentAmber, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeInsights.first.title,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accentAmber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _activeInsights.first.suggestion,
                              style: AppTypography.bilingualSub,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.accentAmber),
                        onPressed: () => _handleSendMessage(_activeInsights.first.promptShortcut),
                      ),
                    ],
                  ),
                ),
              ),

            // Chat Messages Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final msg = _messages[index];
                  final isUser = msg.sender == MessageSender.user;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primaryCyan : AppColors.surfaceCard,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 18),
                        ),
                        border: Border.all(
                          color: isUser ? Colors.transparent : AppColors.borderGlass,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.content,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isUser ? AppColors.background : AppColors.textPrimary,
                              fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          if (!isUser && msg.modelUsed != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              '⚡ ${msg.modelUsed}',
                              style: AppTypography.bilingualSub.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quick Prompt Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _quickPrompts[index];
                  return ActionChip(
                    backgroundColor: AppColors.surfaceDark,
                    label: Text(prompt, style: AppTypography.bodySmall),
                    onPressed: () => _handleSendMessage(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Input Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderGlass),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: AppTypography.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'Ask your coach anything... (e.g. dinner swap)',
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        onSubmitted: _handleSendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.readinessGradient,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.background, size: 20),
                      onPressed: () => _handleSendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryCyan),
            ),
            const SizedBox(width: 8),
            Text('Coach is thinking...', style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}
