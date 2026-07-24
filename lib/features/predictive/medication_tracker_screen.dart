/// §P10-I Medication Tracker UI Screen
///
/// Route: /medications
/// Dark glassmorphic layout displaying:
/// - App Bar: [←] 💊 Medication Tracker & Warnings
/// - 🔒 Non-Diagnostic Shield Banner (§P10-K)
/// - Active Scheduled Medications List (dose time pills, RxNorm badges, requires food tags)
/// - Active Interaction Warnings Section (color-coded severity pills, linter-verified copy, actionable advice)
/// - Add Medication modal trigger button
library;

import 'package:fitkarma/features/predictive/clinical_disclaimer_shield.dart';
import 'package:fitkarma/features/predictive/medication_engine.dart';
import 'package:fitkarma/features/predictive/medication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicationTrackerScreen extends ConsumerWidget {
  const MedicationTrackerScreen({super.key});

  static const routeName = '/medications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medState = ref.watch(medicationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '💊 Medication Tracker & Warnings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicationDialog(context, ref),
        backgroundColor: Colors.indigoAccent,
        icon: const Icon(Icons.add),
        label: const Text('Add Medication'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mandatory Non-Diagnostic Shield Banner (§P10-K)
            const NonDiagnosticShieldBanner(),
            const SizedBox(height: 20),

            // 2. Active Scheduled Medications List
            _buildMedicationsCard(medState.scheduledMedications),
            const SizedBox(height: 20),

            // 3. Active Interaction Warnings Section
            _buildWarningsCard(medState.activeWarnings),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsCard(List<MedicationSchedule> list) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scheduled Medications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: list.map((med) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.medicationName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Dose: ${med.dosage}',
                              style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                            ),
                            if (med.rxcui != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RxNorm: ${med.rxcui}',
                                  style: const TextStyle(color: Colors.indigoAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          med.scheduledTimes.join(', '),
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (med.requiresFood)
                          const Text(
                            '🍚 Take with food',
                            style: TextStyle(color: Colors.amberAccent, fontSize: 11),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsCard(List<InteractionWarning> warnings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ Active Interaction Warnings:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          if (warnings.isEmpty)
            const Text(
              'No active drug-nutrient or drug-workout conflicts detected.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            )
          else
            Column(
              children: warnings.map((w) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _getSeverityColor(w.severity).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${w.severity.indicatorEmoji} ${w.type.displayName}',
                              style: TextStyle(
                                color: _getSeverityColor(w.severity),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            'Source: ${w.sourceMedication}',
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        w.lintedMessage,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.low:
        return Colors.amberAccent;
      case InteractionSeverity.moderate:
        return Colors.orangeAccent;
      case InteractionSeverity.high:
        return Colors.redAccent;
    }
  }

  void _showAddMedicationDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController(text: 'Thyronorm 50 (Levothyroxine)');
    final doseCtrl = TextEditingController(text: '50 mcg');

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Medication Schedule', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Medication Name', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: doseCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Dosage', labelStyle: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                final engine = DrugInteractionEngine();
                final rxcui = engine.resolveRxcui(nameCtrl.text);

                final newMed = MedicationSchedule(
                  medicationId: 'm_${DateTime.now().millisecondsSinceEpoch}',
                  medicationName: nameCtrl.text,
                  rxcui: rxcui,
                  dosage: doseCtrl.text,
                  scheduledTimes: ['07:00 AM'],
                  requiresFood: false,
                  startDate: DateTime.now(),
                );

                ref.read(medicationProvider.notifier).addMedication(newMed);
                Navigator.pop(ctx);
              },
              child: const Text('Save Medication'),
            ),
          ],
        );
      },
    );
  }
}
