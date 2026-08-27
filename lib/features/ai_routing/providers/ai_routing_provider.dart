import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_routing_repository.dart';

final aiRoutingRepositoryProvider = Provider<AiRoutingRepository>((ref) {
  return AiRoutingRepository();
});

// Family provider to send AI coaching queries with optimistic / async handling
final askCoachProvider = FutureProvider.family<String, String>((ref, prompt) async {
  final repo = ref.watch(aiRoutingRepositoryProvider);
  return await repo.askCoach(prompt: prompt);
});
