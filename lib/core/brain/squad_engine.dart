import 'dart:math';
import '../brain/daily_intelligence_package.dart';

/// Privacy-Filtered Squad Readiness Status (No raw score shared)
class SquadReadinessStatus {
  final String memberName;
  final ReadinessTier tier;
  final String statusLabel; // e.g. "Peak", "Moderate", "Resting"

  const SquadReadinessStatus({
    required this.memberName,
    required this.tier,
    required this.statusLabel,
  });
}

/// Squad & Social Engine
class SquadEngine {
  const SquadEngine();

  /// Generate 6-character uppercase alphanumeric squad invite code
  String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Convert raw readiness into privacy-filtered tier-only status
  SquadReadinessStatus filterReadinessPrivacy({
    required String memberName,
    required int readinessScore,
    required ReadinessTier tier,
  }) {
    String status;
    if (readinessScore >= 80) {
      status = 'Peak Readiness';
    } else if (readinessScore >= 50) {
      status = 'Moderate Active';
    } else {
      status = 'Active Recovery';
    }

    return SquadReadinessStatus(
      memberName: memberName,
      tier: tier,
      statusLabel: status,
    );
  }
}
