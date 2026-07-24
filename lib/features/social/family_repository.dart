/// §P9-D Family Health Hub — Persistence Repository
///
/// In-memory repository for managing familyUnitId household accounts and privacy consents.
library;

import 'package:fitkarma/features/social/family_engine.dart';
import 'package:fitkarma/features/social/family_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyRepository {
  FamilyRepository() {
    _initializeDefaultFamily();
  }

  final FamilyEngine _engine = const FamilyEngine();
  late FamilyHubData _hubData;

  void _initializeDefaultFamily() {
    const defaultMembers = [
      FamilyMemberProfile(
        memberId: 'mem_dad',
        familyUnitId: 'fam_sharma_123',
        name: 'Dad (Ramesh)',
        age: 54,
        role: FamilyMemberRole.parent,
        healthScore: 71,
        bpStatus: '⚠️ Moderate',
        stepsToday: 4200,
        sleepHours: 6.1,
        weightKg: 82.0,
        riskWatch: 'Hypertension watch',
        consentSettings: FamilyPrivacyConsent(shareWeight: false),
      ),
      FamilyMemberProfile(
        memberId: 'mem_mom',
        familyUnitId: 'fam_sharma_123',
        name: 'Mom (Sunita)',
        age: 51,
        role: FamilyMemberRole.parent,
        healthScore: 78,
        bpStatus: 'Normal',
        stepsToday: 6100,
        sleepHours: 7.4,
        programName: 'Menopause Wellness',
        consentSettings: FamilyPrivacyConsent(shareWeight: false),
      ),
      FamilyMemberProfile(
        memberId: 'mem_son',
        familyUnitId: 'fam_sharma_123',
        name: 'Son (Arjun)',
        age: 28,
        role: FamilyMemberRole.primaryAccount,
        healthScore: 84,
        bpStatus: 'Normal',
        stepsToday: 9400,
        sleepHours: 7.8,
        weightKg: 74.0,
        isCurrentUser: true,
      ),
      FamilyMemberProfile(
        memberId: 'mem_daughter',
        familyUnitId: 'fam_sharma_123',
        name: 'Daughter (Priya)',
        age: 24,
        role: FamilyMemberRole.child,
        healthScore: 79,
        bpStatus: 'Normal',
        stepsToday: 4800,
        sleepHours: 8.1,
        programName: 'Nutritional Boost',
        consentSettings: FamilyPrivacyConsent(shareWeight: false),
      ),
    ];

    final alerts = _engine.aggregateFamilyAlerts(defaultMembers);

    _hubData = FamilyHubData(
      familyUnitId: 'fam_sharma_123',
      familyName: 'The Sharma Family',
      primaryUserId: 'mem_son',
      members: defaultMembers,
      familyAlerts: alerts,
    );
  }

  FamilyHubData get hubData => _hubData;

  /// Returns permission-gated member profiles.
  List<FamilyMemberProfile> get permissionGatedMembers {
    return _hubData.members.map((m) => _engine.filterMemberForView(m)).toList();
  }

  /// Adds a new household member (up to max 6).
  void addMember(FamilyMemberProfile newMember) {
    _engine.validateAddMember(_hubData.members.length);
    final updatedList = List<FamilyMemberProfile>.from(_hubData.members)..add(newMember);
    final updatedAlerts = _engine.aggregateFamilyAlerts(updatedList);

    _hubData = FamilyHubData(
      familyUnitId: _hubData.familyUnitId,
      familyName: _hubData.familyName,
      primaryUserId: _hubData.primaryUserId,
      members: updatedList,
      familyAlerts: updatedAlerts,
    );
  }

  /// Updates privacy consent for a member.
  void updateConsent(String memberId, FamilyPrivacyConsent newConsent) {
    final index = _hubData.members.indexWhere((m) => m.memberId == memberId);
    if (index != -1) {
      final updatedList = List<FamilyMemberProfile>.from(_hubData.members);
      updatedList[index] = updatedList[index].copyWith(consentSettings: newConsent);
      final updatedAlerts = _engine.aggregateFamilyAlerts(updatedList);

      _hubData = FamilyHubData(
        familyUnitId: _hubData.familyUnitId,
        familyName: _hubData.familyName,
        primaryUserId: _hubData.primaryUserId,
        members: updatedList,
        familyAlerts: updatedAlerts,
      );
    }
  }
}

final familyRepositoryProvider = Provider<FamilyRepository>((_) {
  return FamilyRepository();
});
