import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/coach_escalation.dart';

class CoachEscalationRepository {
  final FirebaseFirestore _firestore;

  CoachEscalationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Submits a new human coach escalation ticket with structured dossier
  Future<void> submitEscalationTicket({
    required String uid,
    required CoachEscalationTicket ticket,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('coachEscalations')
        .doc(ticket.id);

    await docRef.set(ticket.toMap(), SetOptions(merge: true));
  }

  /// Fetches escalation tickets for the user
  Future<List<CoachEscalationTicket>> getEscalationTickets(String uid) async {
    try {
      final snap = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('coachEscalations')
          .orderBy('createdAt', descending: true)
          .get(const GetOptions(source: Source.serverAndCache));

      return snap.docs
          .map((doc) => CoachEscalationTicket.fromMap(doc.data(), doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
