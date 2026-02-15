import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/dosha_repository.dart';
import '../domain/dosha_question.dart';

part 'dosha_quiz_controller.freezed.dart';
part 'dosha_quiz_controller.g.dart';

@freezed
abstract class DoshaQuizState with _$DoshaQuizState {
  const factory DoshaQuizState({
    @Default([]) List<DoshaQuestion> questions,
    @Default(0) int currentIndex,
    @Default({})
    Map<String, String> answers, // questionId -> dosha (vata/pitta/kapha)
    @Default(false) bool isLoading,
    String? resultDosha,
  }) = _DoshaQuizState;
}

@riverpod
class DoshaQuizController extends _$DoshaQuizController {
  @override
  FutureOr<DoshaQuizState> build() async {
    final repo = ref.read(doshaRepositoryProvider);
    final questions = await repo.getQuestions();
    return DoshaQuizState(questions: questions);
  }

  void selectAnswer(String questionId, String doshaOption) {
    state.whenData((currentState) {
      final newAnswers = Map<String, String>.from(currentState.answers);
      newAnswers[questionId] = doshaOption;
      state = AsyncData(currentState.copyWith(answers: newAnswers));
    });
  }

  bool nextQuestion() {
    bool isFinished = false;
    state.whenData((currentState) {
      if (currentState.currentIndex < currentState.questions.length - 1) {
        state = AsyncData(
          currentState.copyWith(currentIndex: currentState.currentIndex + 1),
        );
      } else {
        calculateResult();
        isFinished = true;
      }
    });
    return isFinished;
  }

  void calculateResult() {
    state.whenData((currentState) {
      final counts = {'vata': 0, 'pitta': 0, 'kapha': 0};
      for (final dosha in currentState.answers.values) {
        counts[dosha] = (counts[dosha] ?? 0) + 1;
      }

      String maxDosha = 'vata';
      int maxCount = -1;
      counts.forEach((dosha, count) {
        if (count > maxCount) {
          maxCount = count;
          maxDosha = dosha;
        }
      });

      state = AsyncData(currentState.copyWith(resultDosha: maxDosha));
    });
  }
}
