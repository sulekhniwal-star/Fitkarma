import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/chat_message.dart';
import '../providers/coach_provider.dart';

class CoachChatScreen extends ConsumerStatefulWidget {
  const CoachChatScreen({super.key});

  @override
  ConsumerState<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends ConsumerState<CoachChatScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      ref.read(coachProvider.notifier).sendMessage(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final coachState = ref.watch(coachProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('AI Adaptive Coach', style: AppTypography.titleLarge),
        actions: [
          Chip(
            backgroundColor: AppColors.glassBgMid,
            side: const BorderSide(color: AppColors.glassBorder),
            label: Text('Groq Multi-Model', style: AppTypography.labelSmall),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Message List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: coachState.messages.length,
                itemBuilder: (context, index) {
                  final msg = coachState.messages[index];
                  final isUser = msg.sender == MessageSender.user;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.78,
                        child: GlassCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isUser && msg.modelTierUsed != null) ...[
                                Text(
                                  'MODEL: ${msg.modelTierUsed!.toUpperCase()}',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan),
                                ),
                                const SizedBox(height: 4.0),
                              ],
                              Text(
                                msg.text,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isUser ? AppColors.primaryCyan : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (coachState.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(color: AppColors.primaryCyan),
              ),

            // Input Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask your AI Coach...',
                        hintStyle: AppTypography.bodyMedium,
                        filled: true,
                        fillColor: AppColors.bgSecondary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                          borderSide: const BorderSide(color: AppColors.glassBorder),
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primaryCyan),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
