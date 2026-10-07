import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/core/widgets/bilingual_label.dart';
import 'package:fitkarma/main.dart';
import '../../data/coach_repository.dart';
import '../../data/coach_service.dart';
import '../../domain/models/coach_message.dart';
import '../../domain/services/proactive_insights_engine.dart';
import 'package:fitkarma/features/health_os/presentation/providers/dashboard_providers.dart';

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
  final ProactiveInsightsEngine _insightsEngine = const ProactiveInsightsEngine();

  final List<CoachMessage> _messages = [];
  String? _sessionId;
  bool _isTyping = false;
  bool _isDostMode = true;

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
  }

  Future<void> _initializeChatSession() async {
    final userId = ref.read(activeUserIdProvider);
    final repo = ref.read(coachRepositoryProvider);
    final sessionId = await repo.getOrCreateActiveSession(userId);
    final history = await repo.loadSessionMessages(sessionId);

    setState(() {
      _sessionId = sessionId;
      _messages.addAll(history);

      if (_messages.isEmpty) {
        _messages.add(
          CoachMessage(
            id: 'welcome-1',
            sessionId: sessionId,
            sender: MessageSender.coach,
            content: _isDostMode
                ? 'Arre namaste bhai! FitKarma AI Dost yahan hai. Kal ka workout kaisa raha? Aaj gym phodna hai ya recovery session rakhein?'
                : 'Namaste! I am your FitKarma Adaptive AI Coach. I analyze your live readiness, workouts, and nutrition in real-time. How can I guide your health today?',
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

  List<String> _getDynamicPrompts(DashboardState stats) {
    if (_isDostMode) {
      return [
        'Bhai, aaj mera workout plan kya hai? 🏋️',
        'High protein desi lunch batao (Paneer/Soya) 🥗',
        'Kal thoda fast food kha liya tha, ab kya karoon? 🍕',
        'Sharma Ji ke bete se zyada fit banna hai! 🔥',
        'Readiness score analyse karo bhai 📊',
      ];
    }

    final List<String> prompts = [];
    final score = stats.readinessScore;

    if (score != null && score >= 85) {
      prompts.add('Maximize my $score score workout 🔥');
    } else if (score != null && score < 60) {
      prompts.add('Low readiness workout adjustment ⚡');
    } else {
      prompts.add('Optimal workout for today 🏋️');
    }

    prompts.add('Fix my lunch for high protein 🥗');
    prompts.add('Ayurvedic cooling food suggestions 🌿');
    prompts.add('Analyze my daily health stats 📊');

    return prompts;
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

    final dashboardState = ref.read(dashboardStateProvider);
    final profile = ref.read(userProfileStreamProvider).value;

    final contextSnapshot = {
      'user_meta': {
        'gender': profile?.gender ?? 'male',
        'age': profile?.age ?? 26,
        'weight_kg': profile?.weightKg ?? 70.0,
        'primary_goal': profile?.primaryGoal ?? 'fat_loss',
        'program_blueprint': 'adaptivePerformance',
      },
      'ayurvedic_prakriti': {'dominant_dosha': 'pitta'},
      'daily_readiness': {
        'score': dashboardState.readinessScore ?? 80,
        'state': dashboardState.readinessLabel.toLowerCase(),
      },
      'metabolic_targets': {
        'target_calories': dashboardState.targetCalories.round(),
        'protein_grams': dashboardState.targetProteinGrams.round(),
        'consumed_calories': dashboardState.consumedCalories.round(),
        'consumed_protein': dashboardState.consumedProteinGrams.round(),
      },
      'live_telemetry': {
        'today_steps': dashboardState.todaySteps,
        'step_goal': dashboardState.stepGoal,
        'workout_minutes': dashboardState.workoutDurationMinutes,
      },
    };

    final userId = ref.read(activeUserIdProvider);
    final repo = ref.read(coachRepositoryProvider);
    final reply = await repo.sendUserMessage(
      userId: userId,
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
    final dashboardState = ref.watch(dashboardStateProvider);
    final sleepSample = ref.watch(latestSleepStreamProvider).value;

    final liveInsights = _insightsEngine.evaluateTriggers(
      readinessScore: dashboardState.readinessScore,
      sleepDebtHours: sleepSample != null ? (8.0 - (sleepSample.value / 60)).clamp(0.0, 5.0) : 0.0,
      todaySteps: dashboardState.todaySteps,
      stepGoal: dashboardState.stepGoal,
      consumedCalories: dashboardState.consumedCalories,
      targetCalories: dashboardState.targetCalories,
      consumedProteinGrams: dashboardState.consumedProteinGrams,
      targetProteinGrams: dashboardState.targetProteinGrams,
      workoutDurationMinutes: dashboardState.workoutDurationMinutes,
    );

    final primaryInsight = liveInsights.isNotEmpty ? liveInsights.first : null;
    final dynamicPrompts = _getDynamicPrompts(dashboardState);

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterChip(
              avatar: Icon(
                _isDostMode ? Icons.sentiment_very_satisfied : Icons.school_outlined,
                size: 16,
                color: _isDostMode ? AppColors.accentAmber : AppColors.primaryCyan,
              ),
              label: Text(
                _isDostMode ? 'Dost Mode' : 'Guru Mode',
                style: AppTypography.label.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _isDostMode ? AppColors.accentAmber : AppColors.primaryCyan,
                ),
              ),
              selected: _isDostMode,
              selectedColor: AppColors.accentAmber.withAlpha(40),
              backgroundColor: AppColors.surfaceCard,
              side: BorderSide(
                color: _isDostMode ? AppColors.accentAmber : AppColors.borderGlass,
              ),
              onSelected: (val) {
                setState(() => _isDostMode = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(val ? 'Switched to Hinglish Dost Mode! 🤝' : 'Switched to Professional Guru Mode 🧘'),
                    backgroundColor: val ? AppColors.accentAmber : AppColors.primaryCyan,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Proactive Live Insights Banner
            if (primaryInsight != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: BentoCard(
                  isGlowing: true,
                  glowColor: primaryInsight.glowColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryInsight.glowColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(primaryInsight.icon, color: primaryInsight.glowColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BilingualLabel(
                              english: primaryInsight.title,
                              hindi: primaryInsight.titleHindi,
                              primaryStyle: AppTypography.bodySmall.copyWith(
                                color: primaryInsight.glowColor,
                                fontWeight: FontWeight.bold,
                              ),
                              secondaryStyle: AppTypography.bilingualSub.copyWith(
                                color: primaryInsight.glowColor.withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 3),
                            BilingualLabel(
                              english: primaryInsight.suggestion,
                              hindi: primaryInsight.suggestionHindi,
                              primaryStyle: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                              ),
                              secondaryStyle: AppTypography.bilingualSub.copyWith(
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryInsight.glowColor),
                        tooltip: 'Apply Insight',
                        onPressed: () => _handleSendMessage(primaryInsight.promptShortcut),
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
                itemCount: dynamicPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = dynamicPrompts[index];
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
