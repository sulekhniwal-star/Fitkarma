import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/abha_engine.dart';
import '../domain/abha_models.dart';

@immutable
class AbhaState {
  final AbhaProfile profile;
  final List<AbhaConsentGrant> activeConsents;
  final AbhaFhirRecordBundle? latestFhirBundle;
  final bool isSyncingWithGateway;
  final String? pendingOtp;
  final String? statusMessage;

  const AbhaState({
    required this.profile,
    required this.activeConsents,
    this.latestFhirBundle,
    this.isSyncingWithGateway = false,
    this.pendingOtp,
    this.statusMessage,
  });

  AbhaState copyWith({
    AbhaProfile? profile,
    List<AbhaConsentGrant>? activeConsents,
    AbhaFhirRecordBundle? latestFhirBundle,
    bool? isSyncingWithGateway,
    String? pendingOtp,
    String? statusMessage,
  }) {
    return AbhaState(
      profile: profile ?? this.profile,
      activeConsents: activeConsents ?? this.activeConsents,
      latestFhirBundle: latestFhirBundle ?? this.latestFhirBundle,
      isSyncingWithGateway: isSyncingWithGateway ?? this.isSyncingWithGateway,
      pendingOtp: pendingOtp ?? this.pendingOtp,
      statusMessage: statusMessage,
    );
  }
}

final abhaIntegrationProvider =
    StateNotifierProvider<AbhaIntegrationNotifier, AbhaState>((ref) {
  return AbhaIntegrationNotifier();
});

class AbhaIntegrationNotifier extends StateNotifier<AbhaState> {
  AbhaIntegrationNotifier() : super(_buildInitialState());

  static const AbhaEngine _engine = AbhaEngine();

  static AbhaState _buildInitialState() {
    final initialProfile = _engine.synthesizeVerifiedProfile(
      aadhaarOrAbhaNumber: '14882249128734',
      fullName: 'Rahul Sharma',
      mobileNumber: '+919876543210',
      preferredAbhaAddress: 'rahul.sharma@abdm',
      gender: 'M',
      dateOfBirth: '1992-06-15',
      stateName: 'Karnataka',
      districtName: 'Bengaluru Urban',
    );

    final initialConsents = [
      AbhaConsentGrant(
        consentRequestId: 'cr_apollo_001',
        requesterEntityName: 'Apollo Hospitals (Indiranagar, BLR)',
        purpose: AbdmPurposeCode.clinicalConsult,
        hiTypes: const ['DiagnosticReport', 'Observation', 'WellnessRecord'],
        status: AbhaConsentStatus.granted,
        requestedAt: DateTime.now().subtract(const Duration(days: 4)),
        validUntil: DateTime.now().add(const Duration(days: 26)),
      ),
      AbhaConsentGrant(
        consentRequestId: 'cr_aiims_002',
        requesterEntityName: 'AIIMS New Delhi (Cardiology OPD)',
        purpose: AbdmPurposeCode.careManagement,
        hiTypes: const ['Observation', 'WellnessRecord'],
        status: AbhaConsentStatus.granted,
        requestedAt: DateTime.now().subtract(const Duration(days: 12)),
        validUntil: DateTime.now().add(const Duration(days: 18)),
      ),
    ];

    final initialBundle = AbhaFhirRecordBundle(
      bundleId: 'fitkarma-fhir-bundle-1725900000',
      abhaAddress: 'rahul.sharma@abdm',
      observationCount: 4,
      latestBiologicalAge: 29.2,
      latestLongevityScore: 88.5,
      prakritiConstitution: 'Pitta-Vata Balanced',
      averageVo2Max: 44.5,
      weeklyStepsAverage: 10450,
      generatedAt: DateTime(2026, 9, 9, 10, 30),
    );

    return AbhaState(
      profile: initialProfile,
      activeConsents: initialConsents,
      latestFhirBundle: initialBundle,
    );
  }

  void initiateAadhaarKyc(String aadhaarOrMobile) {
    if (aadhaarOrMobile.trim().isEmpty) {
      state = state.copyWith(statusMessage: 'Please enter valid 12-digit Aadhaar or 10-digit mobile number.');
      return;
    }

    final otp = _engine.generateKycOtp(aadhaarOrMobile);
    state = state.copyWith(
      pendingOtp: otp,
      statusMessage: 'ABDM Aadhaar OTP sent: $otp (Demo Simulation)',
      profile: state.profile.copyWith(verificationStatus: AbhaVerificationStatus.pendingOtp),
    );
  }

  bool verifyOtp(String enteredOtp) {
    if (state.pendingOtp == null) return false;

    final isValid = _engine.verifyKycOtp(
      enteredOtp: enteredOtp,
      expectedOtp: state.pendingOtp!,
    );

    if (isValid) {
      final verified = _engine.synthesizeVerifiedProfile(
        aadhaarOrAbhaNumber: state.profile.abhaNumber,
        fullName: state.profile.fullName,
        mobileNumber: state.profile.mobileNumber,
        preferredAbhaAddress: state.profile.abhaAddress,
      );

      state = state.copyWith(
        profile: verified,
        pendingOtp: null,
        statusMessage: 'ABHA Health ID verified successfully via ABDM Gateway! 🇮🇳',
      );
      return true;
    } else {
      state = state.copyWith(statusMessage: 'Incorrect OTP. Please check and try again.');
      return false;
    }
  }

  void approveConsent(String consentRequestId) {
    final updated = state.activeConsents.map((c) {
      if (c.consentRequestId == consentRequestId) {
        return c.copyWith(status: AbhaConsentStatus.granted);
      }
      return c;
    }).toList();

    state = state.copyWith(
      activeConsents: updated,
      statusMessage: 'ABDM Consent granted. Healthcare provider authorized.',
    );
  }

  void revokeConsent(String consentRequestId) {
    final updated = state.activeConsents.map((c) {
      if (c.consentRequestId == consentRequestId) {
        return c.copyWith(status: AbhaConsentStatus.revoked);
      }
      return c;
    }).toList();

    state = state.copyWith(
      activeConsents: updated,
      statusMessage: 'ABDM Consent instantly revoked. Access terminated.',
    );
  }

  void syncFhirRecordsWithAbdm() {
    state = state.copyWith(isSyncingWithGateway: true);

    final bundle = AbhaFhirRecordBundle(
      bundleId: 'fitkarma-fhir-bundle-${DateTime.now().millisecondsSinceEpoch}',
      abhaAddress: state.profile.abhaAddress,
      observationCount: 4,
      latestBiologicalAge: 29.2,
      latestLongevityScore: 88.5,
      prakritiConstitution: 'Pitta-Vata Balanced',
      averageVo2Max: 44.5,
      weeklyStepsAverage: 10450,
      generatedAt: DateTime.now(),
    );

    state = state.copyWith(
      latestFhirBundle: bundle,
      isSyncingWithGateway: false,
      statusMessage: 'FitKarma health records synced with ABDM PHR Gateway (FHIR R4).',
    );
  }

  void unlinkAbha() {
    state = state.copyWith(
      profile: state.profile.copyWith(verificationStatus: AbhaVerificationStatus.unlinked),
      statusMessage: 'ABHA account unlinked from FitKarma.',
    );
  }
}
