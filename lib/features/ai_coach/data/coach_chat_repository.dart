import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/coach_message.dart';

class CoachChatRepository {
  final FirebaseFirestore _firestore;

  CoachChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches conversation messages for the current date with offline cache support
  Future<List<CoachMessage>> getConversationMessages({
    required String uid,
    required String dateStr,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('aiConversations')
          .doc(dateStr);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data()?['messages'] != null) {
        final list = snapshot.data()!['messages'] as List;
        return list
            .map((item) => CoachMessage.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {
      // Offline fallback
    }

    // Default welcome message from Karma Coach
    return [
      CoachMessage(
        id: 'msg_welcome',
        text: 'Namaste! I am Karma Coach. How can I support your nutrition, recovery, or training today?',
        sender: MessageSender.coach,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  /// Persists full conversation thread to Firestore
  Future<void> saveConversation({
    required String uid,
    required String dateStr,
    required List<CoachMessage> messages,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('aiConversations')
        .doc(dateStr);

    await docRef.set({
      'messages': messages.map((m) => m.toMap()).toList(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
