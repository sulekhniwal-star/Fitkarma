import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/chat_message.dart';
import '../providers/coach_provider.dart';

import '../../../core/brain/ai_roast_mode_engine.dart';
import '../providers/coach_tone_provider.dart';

class CoachChatScreen extends ConsumerStatefulWidget {
  const CoachChatScreen({super.key});

  @override
  ConsumerState<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends ConsumerState<CoachChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<String> _suggestedPrompts = [
    'Why am I plateauing?',
    'Adjust my macro splits',
    'What should I eat after training?',
    'Review my sleep debt recovery plan',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      // Evaluate for distress / crisis triggers before dispatching
      final isDistress = ref
          .read(coachToneProvider.notifier)
          .evaluateDistressTrigger(userMessage: text);

      final toneState = ref.read(coachToneProvider);
      final effectiveTone = toneState.effectiveTone;

      ref.read(aiCoachChatProvider.notifier).sendMessage(
            text,
            tone: effectiveTone,
            isDistress: isDistress,
          );
      _inputController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onToneSelected(CoachTone tone) {
    final toneState = ref.read(coachToneProvider);
    if (tone == CoachTone.roast && !toneState.isRoastOptedIn) {
      _showRoastOptInDialog();
    } else {
      ref.read(coachToneProvider.notifier).setTone(tone);
    }
  }

  void _showRoastOptInDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Row(
          children: [
            const Text('🔥 ', style: TextStyle(fontSize: 22)),
            Text('Enable AI Roast Mode?', style: AppTypography.h3),
          ],
        ),
        content: Text(
          'Roast Mode delivers witty, sarcastic, and bluntly honest feedback on your diet and workouts. '
          'It is strictly for motivation and will automatically disable if distress or crisis is detected.\n\n'
          'Example: "You burned 400 calories and then attacked 900 calories of biryani. Respect the hustle. Your goals don\'t."',
          style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ref.read(coachToneProvider.notifier).optInToRoast();
              Navigator.of(ctx).pop();
            },
            child: const Text('I Can Take It'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachChatProvider);
    final toneState = ref.watch(coachToneProvider);

    // Apply suggested prompt to text field when set
    ref.listen<AiCoachChatState>(aiCoachChatProvider, (prev, next) {
      if (next.pendingSuggestedPrompt != null &&
          next.pendingSuggestedPrompt != prev?.pendingSuggestedPrompt) {
        _inputController.text = next.pendingSuggestedPrompt!;
        ref.read(aiCoachChatProvider.notifier).clearSuggestedPrompt();
      }
      // Auto-scroll on new messages
      if ((next.messages.length) > (prev?.messages.length ?? 0)) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // §P3-C Context Banner: Readiness · Streak · Goal
            _ContextBanner(readinessScore: 82, streak: 12, goal: 'Recomp'),

            // §P12-D Coach Tone Selector Strip [Gentle] [Motivational] [Roast] [No Nonsense]
            _ToneSelectorBar(
              selectedTone: toneState.selectedTone,
              effectiveTone: toneState.effectiveTone,
              onToneSelected: _onToneSelected,
            ),

            // §P12-D Crisis Mode Suppression Notice
            if (toneState.isRoastSuppressedByCrisis)
              _CrisisSuppressionBanner(
                reason: toneState.distressTriggerReason,
                onDismiss: () =>
                    ref.read(coachToneProvider.notifier).clearDistress(),
              ),

            // Chat messages list
            Expanded(
              child: state.messages.isEmpty
                  ? _EmptyStateView()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.messages.length,
                      itemBuilder: (ctx, i) =>
                          _MessageBubble(message: state.messages[i]),
                    ),
            ),

            // Typing indicator
            if (state.isAiTyping) const _TypingIndicator(),

            // Suggested prompts strip
            if (!state.isAiTyping && state.messages.length <= 2)
              _SuggestedPromptsStrip(
                prompts: _suggestedPrompts,
                onTap: (p) => ref
                    .read(aiCoachChatProvider.notifier)
                    .applySuggestedPrompt(p),
              ),

            // Error banner
            if (state.errorOccurred)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off,
                        color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Text('Connection error. Check your network.',
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.error)),
                  ],
                ),
              ),

            // Input bar
            _InputBar(
              controller: _inputController,
              onSend: _send,
              isEnabled: !state.isAiTyping,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.teal, AppColors.secondary],
              ),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Karma Coach', style: AppTypography.h3),
              Text('Powered by Groq · llama-3.3-70b',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.teal, fontSize: 10)),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
            ),
            child: Text('Online',
                style: AppTypography.labelMd.copyWith(color: AppColors.teal)),
          ),
        ),
      ],
    );
  }
}

// ── Context Banner ──────────────────────────────────────────────────────────

class _ContextBanner extends StatelessWidget {
  final int readinessScore;
  final int streak;
  final String goal;

  const _ContextBanner({
    required this.readinessScore,
    required this.streak,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.glassBgMid,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BannerChip(
              icon: Icons.bolt,
              label: 'Readiness',
              value: '$readinessScore',
              color: AppColors.teal),
          _Divider(),
          _BannerChip(
              icon: Icons.local_fire_department,
              label: 'Streak',
              value: '$streak days',
              color: AppColors.warning),
          _Divider(),
          _BannerChip(
              icon: Icons.flag,
              label: 'Goal',
              value: goal,
              color: AppColors.secondary),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.glassBorder,
    );
  }
}

class _BannerChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _BannerChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelMd.copyWith(fontSize: 9)),
            Text(value,
                style:
                    AppTypography.labelLg.copyWith(color: color, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

// ── Message Bubble ──────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source indicator chips (AI only)
                  if (!isUser && message.sources.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Wrap(
                        spacing: 6,
                        children: message.sources
                            .map((s) => _SourceChip(label: s))
                            .toList(),
                      ),
                    ),
                  Text(
                    message.text,
                    style: AppTypography.bodyMd.copyWith(
                      color: isUser ? AppColors.teal : AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Model tier badge (AI only)
            if (!isUser && message.modelTierUsed != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'MODEL: ${message.modelTierUsed!.toUpperCase()}',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.secondary, fontSize: 9),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  final String label;
  const _SourceChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTypography.labelMd
              .copyWith(color: AppColors.teal, fontSize: 9)),
    );
  }
}

// ── Typing Indicator ────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Opacity(
            opacity: _anim.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.psychology, color: AppColors.teal, size: 16),
                const SizedBox(width: 8),
                Text('AI Coach is thinking...',
                    style:
                        AppTypography.bodyMd.copyWith(color: AppColors.teal)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Suggested Prompts Strip ──────────────────────────────────────────────────

class _SuggestedPromptsStrip extends StatelessWidget {
  final List<String> prompts;
  final void Function(String) onTap;

  const _SuggestedPromptsStrip({required this.prompts, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(prompts[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassBgMid,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              prompts[i],
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Input Bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
        top: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Mic icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.glassBgMid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.mic_none,
                color: AppColors.textMuted, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Camera icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.glassBgMid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.camera_alt_outlined,
                color: AppColors.textMuted, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Text field
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEnabled,
              style:
                  AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: AppTypography.bodyMd,
                filled: true,
                fillColor: AppColors.bgSecondary,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.teal),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Send button
          GestureDetector(
            onTap: isEnabled ? onSend : null,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: isEnabled
                      ? [AppColors.teal, AppColors.secondary]
                      : [AppColors.glassBgMid, AppColors.glassBgMid],
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────────────────

class _EmptyStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology_outlined,
              size: 60, color: AppColors.teal.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Ask your AI Coach anything',
              style: AppTypography.h3.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Every response references your Health Snapshot',
              style: AppTypography.bodyMd),
        ],
      ),
    );
  }
}

// ── §P12-D Tone Selector Bar ─────────────────────────────────────────────────

class _ToneSelectorBar extends StatelessWidget {
  final CoachTone selectedTone;
  final CoachTone effectiveTone;
  final ValueChanged<CoachTone> onToneSelected;

  const _ToneSelectorBar({
    required this.selectedTone,
    required this.effectiveTone,
    required this.onToneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.glassBgMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: CoachTone.values.map((tone) {
          final isSelected = selectedTone == tone;
          final isEffective = effectiveTone == tone;

          Color activeColor = AppColors.teal;
          if (tone == CoachTone.roast) {
            activeColor = AppColors.warning;
          } else if (tone == CoachTone.noNonsense) {
            activeColor = AppColors.secondary;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onToneSelected(tone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: activeColor.withValues(alpha: 0.6))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tone == CoachTone.roast)
                      const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text('🔥', style: TextStyle(fontSize: 12)),
                      ),
                    Text(
                      tone.displayName,
                      style: AppTypography.labelMd.copyWith(
                        color: isSelected ? activeColor : AppColors.textMuted,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── §P12-D Crisis Suppression Banner ─────────────────────────────────────────

class _CrisisSuppressionBanner extends StatelessWidget {
  final String? reason;
  final VoidCallback onDismiss;

  const _CrisisSuppressionBanner({
    this.reason,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Safety Safeguard Active',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Roast mode auto-adjusted to Gentle for your well-being (${reason ?? 'distress detected'}).',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textMuted, size: 16),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
