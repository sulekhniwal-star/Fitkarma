import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/coach_escalation.dart';

class CoachEscalationRepository {
  final SupabaseClient? _supabase;

  CoachEscalationRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Submits a new human coach escalation ticket with structured dossier
  Future<void> submitEscalationTicket({
    required String uid,
    required CoachEscalationTicket ticket,
  }) async {
    final draftKey = 'escalation_${uid}_${ticket.id}';
    await LocalStorageService.saveDraft(draftKey, ticket.toMap());

    try {
      await _client.from('doctor_access_grants').upsert({
        'patient_id': uid,
        'doctor_email': 'coach-support@fitkarma.in',
        'notes': ticket.dossier.summaryNotes,
        'access_level': 'read_dossier',
        'valid_until': DateTime.now().add(const Duration(days: 7)).toUtc().toIso8601String(),
      });
    } catch (_) {
      // Handled via local storage
    }
  }

  /// Fetches escalation tickets for the user
  Future<List<CoachEscalationTicket>> getEscalationTickets(String uid) async {
    try {
      final response = await _client
          .from('doctor_access_grants')
          .select()
          .eq('patient_id', uid)
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => CoachEscalationTicket.fromMap(
                Map<String, dynamic>.from(row),
                row['id'] as String,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
