/// §P16-D Corporate Wellness & Insurer HR Dashboard Screen
///
/// Route: `/corporate-dashboard`
/// Glassmorphic UI (`0xFF0F172A`) providing corporate plan seat management (corporate_basic/corporate_plus),
/// enrollment code linking (opt-in, reversible), aggregate adherence distribution chart,
/// and privacy shield minimum cohort size enforcement (§P7-F reuse) matching §P16-D spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'corporate_controller.dart';
import 'corporate_models.dart';

class CorporateDashboardScreen extends ConsumerStatefulWidget {
  const CorporateDashboardScreen({super.key});

  static const routeName = '/corporate-dashboard';

  @override
  ConsumerState<CorporateDashboardScreen> createState() => _CorporateDashboardScreenState();
}

class _CorporateDashboardScreenState extends ConsumerState<CorporateDashboardScreen> {
  final _codeCtrl = TextEditingController(text: 'TECH-CORP-2026');

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(corporateProvider);
    final notifier = ref.read(corporateProvider.notifier);

    ref.listen<CorporateState>(corporateProvider, (_, next) {
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
          '🏢 Corporate Wellness HR Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Corporate Plan Tier Header Card
            _buildOrgHeaderCard(state, notifier),
            const SizedBox(height: 20),

            // 2. Employee Enrollment Code Join Card
            _buildEmployeeEnrollmentCard(state, notifier),
            const SizedBox(height: 24),

            // 3. Seat Utilization & Enrollment Meter
            const Text(
              '📊 Seat Utilization & Enrollment Metrics',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            _buildSeatMeterCard(state),
            const SizedBox(height: 24),

            // 4. Anonymized Aggregate Adherence Distribution Chart
            const Text(
              '📈 Aggregate Health Adherence Distribution',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            _buildAdherenceDistributionCard(state),
            const SizedBox(height: 24),

            // 5. Privacy Shield Audit Safeguard Banner
            _buildPrivacyShieldCard(state),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgHeaderCard(CorporateState state, CorporateNotifier notifier) {
    final org = state.currentOrg;
    if (org == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                org.organizationName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  org.planTier.displayName.toUpperCase(),
                  style: const TextStyle(color: Color(0xFFC7D2FE), fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enrollment Code: ${org.enrollmentCode} | Seats: ${org.seatLimit}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),

          // Plan Tier Selector
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Switch Tier: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ChoiceChip(
                label: const Text('Corporate Basic (250 Seats)'),
                selected: org.planTier == CorporatePlanTier.corporateBasic,
                selectedColor: const Color(0xFF6366F1),
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
                onSelected: (_) => notifier.updatePlanTier(CorporatePlanTier.corporateBasic, 250),
              ),
              ChoiceChip(
                label: const Text('Corporate Plus (1000 Seats)'),
                selected: org.planTier == CorporatePlanTier.corporatePlus,
                selectedColor: const Color(0xFF6366F1),
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
                onSelected: (_) => notifier.updatePlanTier(CorporatePlanTier.corporatePlus, 1000),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeEnrollmentCard(CorporateState state, CorporateNotifier notifier) {
    final isEnrolled = state.userEnrollment != null && state.userEnrollment!.isActive;

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Join Corporate Wellness Program',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isEnrolled ? const Color(0xFF10B981).withValues(alpha: 0.15) : Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isEnrolled ? '✓ ENROLLED' : 'NOT LINKED',
                  style: TextStyle(
                    color: isEnrolled ? const Color(0xFF10B981) : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (!isEnrolled) ...[
            TextField(
              controller: _codeCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Organization Enrollment Code',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              icon: const Icon(Icons.group_add_rounded, color: Colors.white, size: 16),
              label: const Text('Join Program with Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () => notifier.enrollUserWithCode(_codeCtrl.text.trim()),
            ),
          ] else ...[
            const Text(
              'Your FitKarma account is linked to your organization. Personal health data is never visible to HR.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent, size: 16),
              label: const Text('Opt-Out & Unlink Program', style: TextStyle(color: Colors.redAccent)),
              onPressed: () => notifier.unenrollUser(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeatMeterCard(CorporateState state) {
    final m = state.aggregateMetrics;
    if (m == null) return const SizedBox.shrink();

    final pct = (m.enrollmentPercentage / 100.0).clamp(0.0, 1.0);

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${m.totalEnrolled} / ${m.seatLimit} Seats Enrolled',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '${m.enrollmentPercentage.toStringAsFixed(1)}%',
                style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 12,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdherenceDistributionCard(CorporateState state) {
    final m = state.aggregateMetrics;
    if (m == null) return const SizedBox.shrink();

    if (!m.isCohortThresholdMet) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
        ),
        child: const Column(
          children: [
            Icon(Icons.shield_rounded, color: Colors.amberAccent, size: 30),
            SizedBox(height: 8),
            Text(
              'Not enough participants yet',
              style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Minimum cohort size of 5 participants required before rendering any aggregate metrics to prevent re-identification in small teams.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Adherence Breakdown (Group Aggregate)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...m.adherenceDistribution.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('${entry.value}%', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: entry.value / 100.0,
                      minHeight: 8,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyShieldCard(CorporateState state) {
    final m = state.aggregateMetrics;
    final isPassed = m?.privacyAuditPassed ?? true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPassed ? '🔒 Privacy Shield Audit Passed (§P16-D)' : '⚠️ Privacy Audit Warning',
                  style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 2),
                const Text(
                  'No per-user health logs, names, or individual identifiers are queryable from org endpoints.',
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
