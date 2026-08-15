// §P16-C ABHA Riverpod Provider & State Management
// Cross-reference: §P16-C in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/abha_integration_engine.dart';
import '../../../core/brain/doctor_sharing_service.dart';

class AbhaNotifier extends StateNotifier<AbhaHealthProfile> {
  final AbhaIntegrationEngine _engine;

  AbhaNotifier([AbhaIntegrationEngine? engine])
      : _engine = engine ?? const AbhaIntegrationEngine(),
        super(const AbhaHealthProfile());

  /// Links user ABHA Health ID with verification
  bool linkAbha({
    required String rawAbhaNumber,
    required String abhaAddress,
  }) {
    if (!_engine.validateAbhaNumber(rawAbhaNumber) ||
        !_engine.validateAbhaAddress(abhaAddress)) {
      return false;
    }

    final formattedNumber = _engine.formatAbhaNumber(rawAbhaNumber);
    state = state.copyWith(
      abhaNumber: formattedNumber,
      abhaAddress: abhaAddress,
      isLinked: true,
      isKycVerified: true,
      linkedAt: DateTime.now(),
      encryptedToken: 'enc_abha_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    return true;
  }

  /// Unlinks ABHA ID
  void unlinkAbha() {
    state = const AbhaHealthProfile();
  }

  /// Exports FHIR-Lite structured bundle for connected doctor
  FhirLiteBundle exportFhirBundle(DoctorReportSummary reportSummary) {
    return _engine.generateFhirLiteBundle(
      profile: state,
      reportSummary: reportSummary,
    );
  }
}

final abhaEngineProvider =
    Provider<AbhaIntegrationEngine>((ref) => const AbhaIntegrationEngine());

final abhaProvider =
    StateNotifierProvider<AbhaNotifier, AbhaHealthProfile>((ref) {
  final engine = ref.watch(abhaEngineProvider);
  return AbhaNotifier(engine);
});
