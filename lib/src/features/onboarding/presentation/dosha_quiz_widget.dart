import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../application/dosha_quiz_controller.dart';
import '../domain/dosha_question.dart';

class DoshaQuizWidget extends ConsumerWidget {
  final VoidCallback onFinished;

  const DoshaQuizWidget({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(doshaQuizControllerProvider);

    return quizState.when(
      data: (state) {
        if (state.resultDosha != null) {
          return _ResultView(dosha: state.resultDosha!, onFinished: onFinished);
        }

        if (state.questions.isEmpty) {
          return const Center(child: Text('No questions found.'));
        }

        final question = state.questions[state.currentIndex];
        return _QuestionView(
          question: question,
          currentIndex: state.currentIndex,
          totalQuestions: state.questions.length,
          selectedDosha: state.answers[question.id],
          onOptionSelected: (dosha) {
            ref
                .read(doshaQuizControllerProvider.notifier)
                .selectAnswer(question.id, dosha);
          },
          onNext: () {
            ref.read(doshaQuizControllerProvider.notifier).nextQuestion();
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final DoshaQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final String? selectedDosha;
  final Function(String) onOptionSelected;
  final VoidCallback onNext;

  const _QuestionView({
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    this.selectedDosha,
    required this.onOptionSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${currentIndex + 1}/$totalQuestions',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          question.question,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: question.options.entries.map((entry) {
              final isSelected = selectedDosha == entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => onOptionSelected(entry.key),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textHint.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedDosha != null ? onNext : null,
            child: Text(
              currentIndex == totalQuestions - 1
                  ? 'Finish Quiz'
                  : 'Next Question',
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  final String dosha;
  final VoidCallback onFinished;

  const _ResultView({required this.dosha, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    final doshaTitle = dosha[0].toUpperCase() + dosha.substring(1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_awesome, size: 80, color: AppColors.primary),
        const SizedBox(height: 24),
        Text(
          'Your Primary Dosha is',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          doshaTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Based on your answers, you have a dominant $doshaTitle personality. We will personalize your diet and workout plans accordingly.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onFinished,
            child: const Text('Great! Let\'s go'),
          ),
        ),
      ],
    );
  }
}
