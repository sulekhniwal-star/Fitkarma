/// §P16-A WhatsApp Settings UI Screen (Settings → Link WhatsApp)
///
/// Route: `/settings/whatsapp`
/// Glassmorphic UI (`0xFF0F172A`) providing in-app opt-in/opt-out toggle (off by default),
/// phone number linking, and interactive WhatsApp reply testing matching §P16-A spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'whatsapp_controller.dart';
import 'whatsapp_models.dart';

class WhatsAppSettingsScreen extends ConsumerStatefulWidget {
  const WhatsAppSettingsScreen({super.key});

  static const routeName = '/settings/whatsapp';

  @override
  ConsumerState<WhatsAppSettingsScreen> createState() => _WhatsAppSettingsScreenState();
}

class _WhatsAppSettingsScreenState extends ConsumerState<WhatsAppSettingsScreen> {
  final _phoneCtrl = TextEditingController(text: '+919876543210');
  final _testMsgCtrl = TextEditingController(text: '2 roti, dal, sabzi');

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _testMsgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(whatsAppProvider);
    final notifier = ref.read(whatsAppProvider.notifier);

    ref.listen<WhatsAppState>(whatsAppProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF25D366), // Official WhatsApp Green
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
          '💬 Link WhatsApp Logging',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WhatsApp Hero Header Card
            _buildHeroCard(),
            const SizedBox(height: 20),

            // 2. Opt-In / Opt-Out Toggle Card (Off by Default §P16-A spec)
            _buildOptInToggleCard(state, notifier),
            const SizedBox(height: 20),

            // 3. Phone Number Linking Section
            _buildPhoneLinkCard(state, notifier),
            const SizedBox(height: 24),

            // 4. Interactive Webhook Tester
            const Text(
              '🧪 Test WhatsApp Message Parsing',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildTesterCard(state, notifier),

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
          colors: [Color(0xFF128C7E), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.4)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 26),
              SizedBox(width: 10),
              Text(
                'Log Meals via WhatsApp',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Text "2 roti, dal, sabzi" or send a photo of your plate on WhatsApp. FitKarma automatically parses macros and logs to your daily diary.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildOptInToggleCard(WhatsAppState state, WhatsAppNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app_rounded, color: Color(0xFF25D366), size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WhatsApp Logging (Opt-In)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  'Off by default. Enable to allow fitkarma-whatsapp webhook message processing.',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: state.isOptedIn,
            activeColor: const Color(0xFF25D366),
            onChanged: (val) => notifier.toggleOptIn(val),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLinkCard(WhatsAppState state, WhatsAppNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Linked Phone Number',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: state.isPhoneVerified
                      ? const Color(0xFF25D366).withValues(alpha: 0.15)
                      : Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.isPhoneVerified ? '✓ LINKED' : '⚠️ UNLINKED',
                  style: TextStyle(
                    color: state.isPhoneVerified ? const Color(0xFF25D366) : Colors.amber,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'WhatsApp Phone Number (+91)',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
                  icon: const Icon(Icons.link_rounded, color: Colors.white, size: 18),
                  label: const Text('Link Phone Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => notifier.linkPhoneNumber(_phoneCtrl.text.trim()),
                ),
              ),
              if (state.isPhoneVerified) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.link_off_rounded, color: Colors.redAccent),
                  onPressed: () => notifier.unlinkWhatsApp(),
                  tooltip: 'Unlink Account',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTesterCard(WhatsAppState state, WhatsAppNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _testMsgCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Simulate WhatsApp Message Input',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
                  icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                  label: const Text('Send Text Msg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    notifier.simulateIncomingWebhook(
                      WhatsAppMessage(
                        messageId: 'msg_${DateTime.now().millisecondsSinceEpoch}',
                        fromPhoneNumber: _phoneCtrl.text.trim(),
                        type: WhatsAppMessageType.text,
                        textBody: _testMsgCtrl.text.trim(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA259FF)),
                icon: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                label: const Text('Send Meal Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  notifier.simulateIncomingWebhook(
                    WhatsAppMessage(
                      messageId: 'msg_photo_${DateTime.now().millisecondsSinceEpoch}',
                      fromPhoneNumber: _phoneCtrl.text.trim(),
                      type: WhatsAppMessageType.image,
                      imageId: 'photo_plate_101',
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Message Log Output
          const Text('💬 Instant WhatsApp Bot Response:', style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),

          if (state.messageLogHistory.isEmpty)
            const Text('No responses yet. Send a test message above.', style: TextStyle(color: Colors.white54, fontSize: 12))
          else
            ...state.messageLogHistory.map(
              (res) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF054C44),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(res, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace')),
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
