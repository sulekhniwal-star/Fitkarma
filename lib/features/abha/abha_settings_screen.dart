/// §P16-C "Link ABHA Health ID" Settings UI Screen
///
/// Route: `/settings/abha`
/// Glassmorphic UI (`0xFF0F172A`) providing NDHM ABHA OAuth linking flow, encrypted at rest status,
/// Doctor Sharing Portal mode selection (passcode PDF default vs FHIR-lite ABHA), and §P10-M compliance banner matching §P16-C spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'abha_controller.dart';
import 'abha_models.dart';

class AbhaSettingsScreen extends ConsumerStatefulWidget {
  const AbhaSettingsScreen({super.key});

  static const routeName = '/settings/abha';

  @override
  ConsumerState<AbhaSettingsScreen> createState() => _AbhaSettingsScreenState();
}

class _AbhaSettingsScreenState extends ConsumerState<AbhaSettingsScreen> {
  final _abhaInputCtrl = TextEditingController(text: '14-8899-1234-5678');
  final _otpInputCtrl = TextEditingController(text: '123456');

  @override
  void dispose() {
    _abhaInputCtrl.dispose();
    _otpInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abhaProvider);
    final notifier = ref.read(abhaProvider.notifier);

    ref.listen<AbhaState>(abhaProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF0EA5E9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${next.errorMessage!}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

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
          '🏥 ABHA Health ID Integration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. NDHM Hero Header Card
            _buildHeroCard(),
            const SizedBox(height: 20),

            // 2. ABHA Linking / Account Status Card
            _buildAccountStatusCard(state, notifier),
            const SizedBox(height: 24),

            // 3. Doctor Sharing Mode Selection Card
            const Text(
              '🩺 Doctor Sharing Portal Export Mode (§P10-J)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            _buildSharingModeCard(state, notifier),
            const SizedBox(height: 24),

            // 4. §P10-M Compliance Boundary Banner
            _buildComplianceBanner(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_rounded, color: Color(0xFF38BDF8), size: 28),
              SizedBox(width: 10),
              Text(
                'Ayushman Bharat Digital Mission (ABDM)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Link your 14-digit ABHA Health ID to enable ID-verified doctor sharing and export FHIR-lite structured health bundles.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusCard(AbhaState state, AbhaNotifier notifier) {
    if (state.account != null && state.account!.isLinked) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '✓ ABHA ID Linked & Verified',
                  style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, color: Colors.amberAccent, size: 12),
                      SizedBox(width: 4),
                      Text('SQLCipher Encrypted', style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('ABHA Health ID: ${state.account!.abhaHealthId}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Full Name: ${state.account!.fullName} | DOB: ${state.account!.dateOfBirth}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
              icon: const Icon(Icons.link_off_rounded, color: Colors.redAccent, size: 16),
              label: const Text('Unlink ABHA Health ID', style: TextStyle(color: Colors.redAccent)),
              onPressed: () => notifier.unlinkAbha(),
            ),
          ],
        ),
      );
    }

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Link your ABHA Health ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _abhaInputCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'ABHA Health ID (e.g. 14-8899-1234-5678 or name@abha)',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          if (!state.isOtpSent)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
              icon: const Icon(Icons.phonelink_ring_rounded, color: Colors.white, size: 16),
              label: const Text('Request NDHM OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () => notifier.requestOtp(_abhaInputCtrl.text.trim()),
            )
          else ...[
            TextField(
              controller: _otpInputCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter 6-digit NDHM OTP',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
              icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 16),
              label: const Text('Verify OTP & Link ABHA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                notifier.submitOtp(
                  otp: _otpInputCtrl.text.trim(),
                  abhaHealthId: _abhaInputCtrl.text.trim(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSharingModeCard(AbhaState state, AbhaNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: RadioListTile<DoctorSharingMode>(
              value: DoctorSharingMode.passcodePdf,
              groupValue: state.sharingMode,
              activeColor: const Color(0xFF0EA5E9),
              title: const Text('📄 Passcode PDF Export (Default)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Generates encrypted 6-digit PIN protected medical PDF report.', style: TextStyle(color: Colors.white60, fontSize: 11)),
              onChanged: (mode) {
                if (mode != null) notifier.setSharingMode(mode);
              },
            ),
          ),
          const Divider(color: Colors.white12),
          Material(
            color: Colors.transparent,
            child: RadioListTile<DoctorSharingMode>(
              value: DoctorSharingMode.fhirLiteAbha,
              groupValue: state.sharingMode,
              activeColor: const Color(0xFF0EA5E9),
              title: const Text('🏥 FHIR-lite ABHA Bundle Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Exports structured JSON bundle for NDHM network doctors.', style: TextStyle(color: Colors.white60, fontSize: 11)),
              onChanged: (mode) {
                if (mode != null) notifier.setSharingMode(mode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.amberAccent, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('§P10-M Compliance Boundary Applied', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 2),
                Text(
                  'FitKarma wellness logs shared via ABHA are for observational wellness tracking only and do not constitute formal medical diagnosis.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
