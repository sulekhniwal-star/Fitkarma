/// §COMPLIANCE — Non-Diagnostic Shield Disclaimer Component
///
/// Reusable banner applied to all CGM, drug-interaction, and bio-age screens
/// to prevent clinical misinterpretation matching §P10-M compliance boundary.
library;

import 'package:flutter/material.dart';

enum NonDiagnosticContext {
  cgmReading, // CGM glucose readings screen
  medicationInteraction, // Drug-interaction warnings
  bioAge, // Estimated Movement Age / Recovery Age
  labBiomarker, // Lab results / biomarker screens
  doctorSharing, // Doctor Sharing Portal
}

class NonDiagnosticShield extends StatelessWidget {
  const NonDiagnosticShield({
    super.key,
    required this.context,
    this.compact = false,
  });

  final NonDiagnosticContext context;
  final bool compact;

  String get _disclaimerText {
    switch (context) {
      case NonDiagnosticContext.cgmReading:
        return 'CGM trends shown for wellness tracking only. Not a substitute for professional medical advice, diagnosis, or treatment. Consult your physician before acting on any glucose reading.';
      case NonDiagnosticContext.medicationInteraction:
        return 'Interaction flags are informational only. Always verify with a licensed pharmacist or physician before adjusting any medication.';
      case NonDiagnosticContext.bioAge:
        return 'Estimated movement and recovery age is an indicative wellness metric, not a clinical assessment. Results are not diagnostic.';
      case NonDiagnosticContext.labBiomarker:
        return 'Lab and biomarker values shown for personal health awareness. FitKarma does not interpret clinical test results. Consult your doctor.';
      case NonDiagnosticContext.doctorSharing:
        return 'Shared health data is for reference only. This export does not constitute a medical record or clinical report.';
    }
  }

  IconData get _icon {
    switch (context) {
      case NonDiagnosticContext.medicationInteraction:
        return Icons.medication_liquid_outlined;
      case NonDiagnosticContext.doctorSharing:
        return Icons.local_hospital_outlined;
      default:
        return Icons.health_and_safety_outlined;
    }
  }

  @override
  Widget build(BuildContext context2) {
    return Container(
      key: const Key('non_diagnostic_shield_banner'),
      margin: EdgeInsets.symmetric(
        horizontal: compact ? 0 : 16,
        vertical: compact ? 4 : 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9966FF).withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: const Color(0xFF9966FF), size: compact ? 16 : 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _disclaimerText,
              style: TextStyle(
                color: const Color(0xFF9E9EBF),
                fontSize: compact ? 11 : 12,
                fontFamily: 'Outfit',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
