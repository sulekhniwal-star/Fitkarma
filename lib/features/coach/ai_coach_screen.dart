import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/coach/ai_coach_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class AICoachScreen extends ConsumerStatefulWidget {
  const AICoachScreen({super.key, required this.userId, this.conversationId});

  final String userId;
  final String? conversationId;

  @override
  ConsumerState<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends ConsumerState<AICoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final db = ref.read(databaseProvider);
      if (widget.conversationId != null) {
        ref
            .read(aiCoachChatProvider.notifier)
            .loadCachedConversation(
              userId: widget.userId,
              conversationId: widget.conversationId!,
              db: db,
            );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messageController.clear();

    final db = ref.read(databaseProvider);
    final notifier = ref.read(aiCoachChatProvider.notifier);

    // In widget tests or production, we can mock/fetch online state.
    // For general UI operations, we default to online unless state says offline.
    await notifier.sendMessage(
      userId: widget.userId,
      text: text,
      db: db,
      isOnline: true,
    );

    // Delay slightly to allow the UI to expand and then scroll down.
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachChatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final cardBgColor = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;

    // Trigger scroll on typing/new messages
    ref.listen(aiCoachChatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          prev?.isAiTyping != next.isAiTyping) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI Karma Coach',
          style: AppTypography.h3.copyWith(color: textPrimary),
        ),
        actions: [
          // Tier Switcher
          PopupMenuButton<String>(
            icon: Icon(Icons.verified_user_rounded, color: accentColor),
            tooltip: "Switch Tier",
            onSelected: (tier) {
              ref
                  .read(aiCoachChatProvider.notifier)
                  .updateSubscriptionTier(
                    tier,
                    widget.userId,
                    ref.read(databaseProvider),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'free', child: Text('Free Tier')),
              const PopupMenuItem(value: 'pro', child: Text('Pro Tier')),
              const PopupMenuItem(
                value: 'eliteCoach',
                child: Text('Elite Tier'),
              ),
            ],
          ),
          // Toggle offline mode switch for demo/testing convenience
          Row(
            children: [
              Text(
                'Offline',
                style: AppTypography.bodySm.copyWith(color: textSecondary),
              ),
              Switch(
                value: state.isOffline,
                activeThumbColor: accentColor,
                onChanged: (val) {
                  ref.read(aiCoachChatProvider.notifier).setOfflineStatus(val);
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Stats Bento Card ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
              ),
              child: BentoCard(
                customBgColor: cardBgColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Readiness', '73', accentColor),
                    _buildStatDivider(isDark),
                    _buildStatItem('Streak', '12 days', primaryColor),
                    _buildStatDivider(isDark),
                    _buildStatItem('Goal', 'Recomp', Colors.purpleAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Elite Tier Human Handoff Trigger Button
            if (state.subscriptionTier == 'eliteCoach' && !state.isEscalated)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                  vertical: 4,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                    label: const Text('Talk to a Human Coach'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showEscalationBottomSheet(
                      context,
                      state,
                      ref.read(aiCoachChatProvider.notifier),
                    ),
                  ),
                ),
              ),

            // Escalation status banner
            if (state.isEscalated)
              Container(
                width: double.infinity,
                color: Colors.blue.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Plan under human review. A certified coach will respond shortly.',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Offline banner
            if (state.isOffline)
              Container(
                width: double.infinity,
                color: Colors.amber.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Running in offline mode. Live AI responses will fail.',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.amber[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Messages Area ──
            Expanded(
              child: state.messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ask me anything about your fitness, recovery, or diet!',
                            style: AppTypography.bodyMd.copyWith(
                              color: textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenH,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isUser = msg.senderType == 'user';
                        return _buildMessageBubble(
                          message: msg,
                          isUser: isUser,
                          isDark: isDark,
                          primaryColor: primaryColor,
                          cardBg: cardBgColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        );
                      },
                    ),
            ),

            // Typing Indicator
            if (state.isAiTyping)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Karma Coach is writing...',
                      style: AppTypography.bodySm.copyWith(
                        color: textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Suggested Prompts ──
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                ),
                children: [
                  _buildPromptChip(
                    "Why am I plateauing?",
                    textPrimary,
                    cardBgColor,
                  ),
                  _buildPromptChip(
                    "Adjust my macro splits",
                    textPrimary,
                    cardBgColor,
                  ),
                  _buildPromptChip(
                    "How can I adapt my calories?",
                    textPrimary,
                    cardBgColor,
                  ),
                  _buildPromptChip(
                    "Check my circadian sync",
                    textPrimary,
                    cardBgColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Input Bar ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.all(AppSpacing.screenH),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: textSecondary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  // Attachment Icon
                  IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: textSecondary,
                    ),
                    onPressed: () {
                      // Mock attachment behavior
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mock photo attachment selected.'),
                        ),
                      );
                    },
                  ),
                  // Mic Icon
                  IconButton(
                    icon: Icon(Icons.mic_none_rounded, color: textSecondary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mock voice recording active.'),
                        ),
                      );
                    },
                  ),
                  // Input text field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask anything...',
                        hintStyle: TextStyle(
                          color: textSecondary.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  // Send Button
                  IconButton(
                    icon: Icon(Icons.send_rounded, color: primaryColor),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.bodySm.copyWith(
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 32,
      width: 1,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
    );
  }

  Widget _buildPromptChip(String label, Color textColor, Color bg) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        labelStyle: AppTypography.bodySm.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: bg,
        onPressed: () => _sendMessage(label),
      ),
    );
  }

  Widget _buildMessageBubble({
    required ChatMessage message,
    required bool isUser,
    required bool isDark,
    required Color primaryColor,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? primaryColor.withValues(alpha: 0.85) : cardBg;

    // Decode sources if present
    final List<String> sources = [];
    if (message.sourcesJson != null) {
      try {
        final decoded = jsonDecode(message.sourcesJson!);
        if (decoded is List) {
          sources.addAll(decoded.map((e) => e.toString()));
        }
      } catch (_) {}
    }

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sources badge block
            if (!isUser && sources.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: sources
                      .map(
                        (s) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            // Message content text
            Text(
              message.messageContent,
              style: AppTypography.bodyMd.copyWith(
                color: isUser ? Colors.white : textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEscalationBottomSheet(
    BuildContext context,
    AiCoachChatState state,
    AiCoachChatNotifier notifier,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
        final textPrimary = isDark
            ? AppColorsDark.textPrimary
            : AppColorsLight.textPrimary;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Human Coach Handoff',
                style: AppTypography.h3.copyWith(color: textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Your health coach will review your full plan and respond within 24 hours via in-app message.',
                style: AppTypography.bodyMd.copyWith(
                  color: textPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue with AI Coach'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsDark.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await notifier.escalateToHumanCoach(
                          userId: widget.userId,
                          reason:
                              "User requested human review via handoff button.",
                          db: ref.read(databaseProvider),
                        );
                      },
                      child: const Text('Request Review'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
