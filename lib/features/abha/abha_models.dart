/// §P16-C ABHA Health ID Integration — Domain Models
///
/// Ayushman Bharat Health Account (NDHM) domain models matching §P16-C spec.
library;

class AbhaAccount {
  const AbhaAccount({
    required this.abhaHealthId,
    required this.abhaNumber,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.isLinked,
    required this.linkedAt,
  });

  final String abhaHealthId; // e.g. "14-8899-1234-5678" (encrypted at rest)
  final String abhaNumber;   // e.g. "91-1234-5678-9012"
  final String fullName;
  final String gender;
  final String dateOfBirth;
  final bool isLinked;
  final DateTime linkedAt;
}

enum DoctorSharingMode {
  passcodePdf,  // Default (unchanged per §P16-C spec)
  fhirLiteAbha, // Opt-in enhancement (ABHA linked per §P16-C spec)
}
