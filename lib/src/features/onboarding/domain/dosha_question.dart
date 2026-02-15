import 'package:freezed_annotation/freezed_annotation.dart';

part 'dosha_question.freezed.dart';
part 'dosha_question.g.dart';

@freezed
abstract class DoshaQuestion with _$DoshaQuestion {
  const factory DoshaQuestion({
    required String id,
    required String question,
    required Map<String, String> options,
    required String category,
    required int order,
  }) = _DoshaQuestion;

  factory DoshaQuestion.fromJson(Map<String, dynamic> json) =>
      _$DoshaQuestionFromJson(json);
}
