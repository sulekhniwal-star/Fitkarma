import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/compliance_engine.dart';
import '../../domain/compliance_models.dart';

final complianceProvider =
    StateNotifierProvider<ComplianceNotifier, ComplianceFrameworkReport>((ref) {
  return ComplianceNotifier();
});

class ComplianceNotifier extends StateNotifier<ComplianceFrameworkReport> {
  ComplianceNotifier() : super(_buildInitialReport());

  static final ComplianceEngine _engine = const ComplianceEngine();

  static ComplianceFrameworkReport _buildInitialReport() {
    final defaultConsents = _engine.generateDefaultStatutoryConsents();
    return _engine.evaluateCompliance(
      userConsents: defaultConsents,
      encryptionAtRestVerified: true,
      auditLoggingActive: true,
      dataErasureSupported: true,
    );
  }

  void revokeConsent(String consentId) {
    final updatedConsents = state.activeConsents.where((c) => c.consentId != consentId).toList();
    state = _engine.evaluateCompliance(
      userConsents: updatedConsents,
      encryptionAtRestVerified: state.encryptionAtRestVerified,
      auditLoggingActive: state.auditLoggingActive,
      dataErasureSupported: state.dataErasureSupported,
    );
  }

  void restoreBaselineConsents() {
    final defaultConsents = _engine.generateDefaultStatutoryConsents();
    state = _engine.evaluateCompliance(
      userConsents: defaultConsents,
      encryptionAtRestVerified: state.encryptionAtRestVerified,
      auditLoggingActive: state.auditLoggingActive,
      dataErasureSupported: state.dataErasureSupported,
    );
  }

  void toggleEncryptionAtRest(bool isVerified) {
    state = _engine.evaluateCompliance(
      userConsents: state.activeConsents,
      encryptionAtRestVerified: isVerified,
      auditLoggingActive: state.auditLoggingActive,
      dataErasureSupported: state.dataErasureSupported,
    );
  }
}
