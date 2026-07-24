/// §P10-J Doctor Sharing Portal — UI Screen
///
/// Glassmorphic dark UI (0xFF0F172A palette) for managing doctor-share tokens,
/// creating passcode-protected PDF exports and FHIR-lite payloads, and the
/// §P10-K "Revoke All Clinical Access" emergency control.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'clinical_sharing_models.dart';
import 'clinical_disclaimer_shield.dart';
import 'doctor_sharing_engine.dart' show SharableReportContent;
import 'doctor_sharing_notifier.dart';
import 'monthly_report_models.dart';

class DoctorSharingPortalScreen extends ConsumerStatefulWidget {
  const DoctorSharingPortalScreen({super.key});

  @override
  ConsumerState<DoctorSharingPortalScreen> createState() =>
      _DoctorSharingPortalScreenState();
}

class _DoctorSharingPortalScreenState
    extends ConsumerState<DoctorSharingPortalScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  final _recipientCtrl = TextEditingController();

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _recipientCtrl.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final DoctorSharingState state =
        ref.watch<DoctorSharingState>(doctorSharingNotifierProvider);
    final DoctorSharingNotifier notifier =
        ref.read<DoctorSharingNotifier>(doctorSharingNotifierProvider.notifier);
    final MonthlyReportPayload? report =
        ref.watch<MonthlyReportPayload?>(latestMonthlyReportProvider);

    // Show success snack
    ref.listen<DoctorSharingState>(doctorSharingNotifierProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── AppBar ───────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: const Color(0xFF0F172A),
              expandedHeight: 120,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Doctor Sharing Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E3A5F), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Disclaimer ─────────────────────────────────────────
                  const NonDiagnosticShieldBanner(),
                  const SizedBox(height: 20),

                  // ── Active Shares Counter ──────────────────────────────
                  _buildStatCard(
                    icon: Icons.share_rounded,
                    label: 'Active Shares',
                    value: state.activeTokens.length.toString(),
                    color: const Color(0xFF38BDF8),
                  ),
                  const SizedBox(height: 20),

                  // ── Create Share Section ───────────────────────────────
                  _sectionTitle('Create New Share'),
                  const SizedBox(height: 12),
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipient label field
                        TextField(
                          controller: _recipientCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Recipient (e.g. "Dr. Sharma")',
                            labelStyle:
                                TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Buttons row
                        Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                label: '🔐 PDF + Passcode',
                                subtitle: 'Secure PDF share',
                                color: const Color(0xFF6366F1),
                                onTap: report == null
                                    ? null
                                    : () => _handleCreatePdf(notifier, report),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ActionButton(
                                label: '🏥 FHIR-lite',
                                subtitle: 'ABHA compatible',
                                color: const Color(0xFF0EA5E9),
                                onTap: report == null
                                    ? null
                                    : () => _handleCreateFhir(notifier, report),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── §P10-K Revoke All ──────────────────────────────────
                  _GlassCard(
                    borderColor: Colors.red.shade700.withValues(alpha: 0.5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.no_encryption_gmailerrorred_rounded,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🔒 Revoke All Clinical Access',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Instantly revokes all ${state.activeTokens.length} active sharing grants (§P10-K)',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: state.activeTokens.isEmpty
                              ? null
                              : () => _confirmRevokeAll(context, notifier),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Revoke All',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Active Tokens ──────────────────────────────────────
                  if (state.tokens.isNotEmpty) ...<Widget>[
                    _sectionTitle('Sharing History'),
                    const SizedBox(height: 12),
                    ...state.tokens.reversed.map<Widget>(
                      (SharingToken t) => _TokenCard(
                        token: t,
                        onRevoke: t.isActive
                            ? () => notifier.revokeToken(t.tokenId)
                            : null,
                        onCopy: () => _copyToken(t),
                      ),
                    ),
                  ],

                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _handleCreatePdf(
    DoctorSharingNotifier notifier,
    MonthlyReportPayload report,
  ) {
    final content = notifier.buildPdfContent(
      payload: report,
      recipientLabel: _recipientCtrl.text.trim().isEmpty
          ? null
          : _recipientCtrl.text.trim(),
    );
    _recipientCtrl.clear();
    _showShareSheet(content);
  }

  void _handleCreateFhir(
    DoctorSharingNotifier notifier,
    MonthlyReportPayload report,
  ) {
    final payload = notifier.buildFhirPayload(
      payload: report,
      patientId: 'user-local-001',
    );
    _recipientCtrl.clear();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FhirPreviewSheet(payload: payload),
    );
  }

  void _showShareSheet(SharableReportContent content) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PdfShareSheet(content: content),
    );
  }

  void _copyToken(SharingToken token) {
    Clipboard.setData(ClipboardData(
      text: 'Token: ${token.tokenId}  |  Passcode: ${token.passcode}',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Token & passcode copied to clipboard'),
        backgroundColor: Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmRevokeAll(
    BuildContext context,
    DoctorSharingNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Revoke All Clinical Access?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will instantly invalidate every active sharing token. '
          'Doctors or portals with existing links will no longer be able '
          'to access your wellness data.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Revoke All',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      notifier.revokeAll();
    }
  }

  // ─── UI Helpers ───────────────────────────────────────────────────────────

  Widget _sectionTitle(String label) => Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      );

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) =>
      _GlassCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

// ─── Reusable Glass Card ──────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.borderColor});
  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: child,
      );
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: onTap != null ? 0.8 : 0.3),
                color.withValues(alpha: onTap != null ? 0.5 : 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
}

// ─── Token Card ───────────────────────────────────────────────────────────────

class _TokenCard extends StatelessWidget {
  const _TokenCard({
    required this.token,
    this.onRevoke,
    this.onCopy,
  });

  final SharingToken token;
  final VoidCallback? onRevoke;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final isActive = token.isActive;
    final modeIcon =
        token.mode == SharingMode.passcodeProtectedPdf ? '🔐' : '🏥';
    final statusColor = isActive
        ? const Color(0xFF22C55E)
        : token.status == ShareStatus.revoked
            ? Colors.redAccent
            : Colors.orange;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _GlassCard(
        borderColor: statusColor.withValues(alpha: 0.3),
        child: Row(
          children: [
            Text(modeIcon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        token.recipientLabel ?? 'Unnamed Recipient',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(
                        label: token.status.name,
                        color: statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🔑 ${token.passcode}   …${token.tokenId.substring(token.tokenId.length - 6)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (token.expiresAt != null)
                    Text(
                      'Expires ${token.expiresAt!.toLocal().toString().substring(0, 16)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                if (onCopy != null)
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: Colors.white54,
                    onPressed: onCopy,
                    tooltip: 'Copy token',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (onRevoke != null) ...[
                  const SizedBox(height: 6),
                  IconButton(
                    icon: const Icon(Icons.block_rounded, size: 18),
                    color: Colors.redAccent,
                    onPressed: onRevoke,
                    tooltip: 'Revoke',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ─── PDF Share Bottom Sheet ───────────────────────────────────────────────────

class _PdfShareSheet extends StatelessWidget {
  const _PdfShareSheet({required this.content});
  final SharableReportContent content;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🔐 Passcode-Protected Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content.headline,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              // Passcode display
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.key_rounded,
                        color: Color(0xFF6366F1), size: 22),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Access Passcode',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          content.token.passcode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 6,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: Colors.white54),
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: content.token.passcode),
                      ),
                      tooltip: 'Copy passcode',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Section previews
              for (final s in content.sections.entries.take(3)) ...[
                Text(
                  s.key,
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.value,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              // Share button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share_rounded, color: Colors.white),
                  label: const Text(
                    'Share Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: content.toPlainText()),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report copied — paste into any chat/email'),
                        backgroundColor: Color(0xFF22C55E),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

// ─── FHIR Preview Bottom Sheet ────────────────────────────────────────────────

class _FhirPreviewSheet extends StatelessWidget {
  const _FhirPreviewSheet({required this.payload});
  final FhirLitePayload payload;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🏥 FHIR-lite Export (§P16-C ABHA)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${payload.entries.length} resources in Bundle  •  '
                'Generated ${payload.generatedAt.toLocal().toString().substring(0, 16)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              // Resource list
              ...payload.entries.take(4).map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Color(0xFF0EA5E9), size: 8),
                          const SizedBox(width: 10),
                          Text(
                            e['resource']['resourceType'] as String? ?? '—',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'id: ${e['resource']['id']}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amberAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  payload.disclaimerFooter,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded, color: Colors.white),
                  label: const Text(
                    'Export FHIR JSON',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {
                    // In production: write JSON to file/share using path_provider + share_plus
                    Clipboard.setData(
                      ClipboardData(text: payload.toJson().toString()),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('FHIR JSON copied to clipboard'),
                        backgroundColor: Color(0xFF0EA5E9),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
