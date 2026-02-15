import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../domain/dosha_question.dart';

part 'dosha_repository.g.dart';

class DoshaRepository {
  final PocketBase pb;
  DoshaRepository(this.pb);

  Future<List<DoshaQuestion>> getQuestions() async {
    final records = await pb
        .collection('ayurvedic_quiz_questions')
        .getFullList(sort: '+order');
    return records
        .map((record) => DoshaQuestion.fromJson(record.toJson()))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String dosha) async {
    final records = await pb
        .collection('ayurvedic_recommendations')
        .getFullList(filter: 'dosha = "$dosha"');
    return records.map((e) => e.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getRoutines(String dosha) async {
    final records = await pb
        .collection('daily_routines')
        .getFullList(filter: 'dosha = "$dosha"');
    return records.map((e) => e.toJson()).toList();
  }
}

@riverpod
DoshaRepository doshaRepository(Ref ref) {
  return DoshaRepository(ref.watch(pocketBaseProvider));
}
