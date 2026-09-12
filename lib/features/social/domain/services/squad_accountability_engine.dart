import '../models/social_models.dart';

class SquadAccountabilityEngine {
  const SquadAccountabilityEngine();

  /// Calculate combined squad adherence percentage (0.0 to 1.0)
  double calculateSquadDailyAdherence(List<SquadMember> members) {
    if (members.isEmpty) return 0.0;
    final loggedCount = members.where((m) => m.todayLogged).length;
    return loggedCount / members.length;
  }

  /// Calculates squad bonus streak multiplier (up to 1.5x)
  double calculateSquadStreakMultiplier(int streakDays) {
    if (streakDays >= 30) return 1.50;
    if (streakDays >= 14) return 1.35;
    if (streakDays >= 7) return 1.20;
    if (streakDays >= 3) return 1.10;
    return 1.0;
  }

  /// Generate gentle accountability nudges for squad members who haven't logged
  List<SquadNudge> generatePendingNudges({
    required String senderId,
    required List<SquadMember> members,
    required DateTime currentTime,
  }) {
    final List<SquadNudge> nudges = [];

    for (final member in members) {
      if (!member.todayLogged && member.userId != senderId) {
        // Formulate friendly desi culturally resonant nudge
        final hour = currentTime.hour;
        String msgEn;
        String msgHi;

        if (hour < 12) {
          msgEn = 'Good morning ${member.displayName}! Ready to crush your morning session?';
          msgHi = 'सुप्रभात ${member.displayName}! आज का मॉर्निंग सेशन शुरू करें?';
        } else if (hour < 18) {
          msgEn = '${member.displayName}, have you logged your nutritious lunch today?';
          msgHi = '${member.displayName}, क्या आपने आज का पौष्टिक भोजन लॉग किया?';
        } else {
          msgEn = 'Hey ${member.displayName}, our squad streak depends on you! Log your daily mission.';
          msgHi = 'अरे ${member.displayName}, हमारे स्क्वाड का स्ट्रीक आपके हाथ में है! आज का मिशन पूरा करें।';
        }

        nudges.add(SquadNudge(
          senderId: senderId,
          recipientId: member.userId,
          recipientName: member.displayName,
          message: msgEn,
          messageHindi: msgHi,
          sentAt: currentTime,
        ));
      }
    }

    return nudges;
  }
}
