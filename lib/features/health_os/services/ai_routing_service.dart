import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/dip_package.dart';

/// AIRoutingService — Secure client interface to Supabase Edge Functions
/// Never contains Groq API keys or direct LLM calls client-side.
class AIRoutingService {
  final SupabaseClient? supabaseClient;

  AIRoutingService({this.supabaseClient});

  /// Request Daily Intelligence Package synthesis from backend Edge Function
  Future<DipPackage?> fetchSynthesizedDIP({
    required String userId,
    required Map<String, dynamic> contextSnapshot,
  }) async {
    if (supabaseClient == null) return null;

    try {
      final response = await supabaseClient!.functions.invoke(
        'health-os-brain',
        body: {
          'user_id': userId,
          'context': contextSnapshot,
        },
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return DipPackage.fromJson(data);
      }
      return null;
    } catch (_) {
      // Degrade gracefully to local deterministic synthesis
      return null;
    }
  }
}
