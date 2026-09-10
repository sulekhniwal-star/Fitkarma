import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/whatsapp_models.dart';
import '../providers/whatsapp_provider.dart';

/// Screen managing WhatsApp Business API integration, phone number verification,
/// automated nudge settings, and interactive conversational meal/water/workout logging simulation.
class WhatsAppLoggingScreen extends ConsumerStatefulWidget {
  const WhatsAppLoggingScreen({super.key});

  @override
  ConsumerState<WhatsAppLoggingScreen> createState() =>
      _WhatsAppLoggingScreenState();
}

class _WhatsAppLoggingScreenState extends ConsumerState<WhatsAppLoggingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(whatsappLoggingProvider);
    final notifier = ref.read(whatsappLoggingProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'WhatsApp Health OS',
          regionalText: 'व्हाट्सएप भोजन व फिटनेस लॉगिंग',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status feedback banner
            if (state.statusMessage != null)
              _buildStatusBanner(state.statusMessage!),

            // 1. WhatsApp Connection & Status Card
            _buildConnectionCard(state.profile, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. Automated Nudges & Briefings Card
            _buildPreferencesCard(state.profile, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Interactive Sandbox & Live Simulation Card
            _buildInteractiveSimulatorCard(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 4. WhatsApp Business Cloud Templates Gallery Card
            _buildTemplatesGalleryCard(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: AppColors.karmaGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(
      WhatsAppUserProfile profile, WhatsAppLoggingNotifier notifier) {
    final bool isLinked = profile.linkStatus == WhatsAppLinkStatus.activeLinked;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'WhatsApp Business Link',
                regionalText: 'व्हाट्सएप खाता संपर्क स्थिति',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isLinked
                      ? AppColors.karmaGreen.withValues(alpha: 0.15)
                      : AppColors.energyOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(
                    color: isLinked
                        ? AppColors.karmaGreen.withValues(alpha: 0.4)
                        : AppColors.energyOrange.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLinked ? Icons.verified : Icons.hourglass_top,
                      color: isLinked
                          ? AppColors.karmaGreen
                          : AppColors.energyOrange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.linkStatus.label,
                      style: TextStyle(
                        color: isLinked
                            ? AppColors.karmaGreen
                            : AppColors.energyOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF25D366)),
                ),
                child:
                    const Icon(Icons.chat, color: Color(0xFF25D366), size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.phoneNumber.isNotEmpty
                          ? profile.phoneNumber
                          : 'No phone linked',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isLinked
                          ? 'Send text or food photos to +91 80 4748 8800'
                          : 'Link your phone number to enable frictionless chat logging',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLinked
                      ? AppColors.surfaceElevated
                      : AppColors.karmaGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.sm)),
                ),
                onPressed: () =>
                    _showPhoneLinkModal(context, profile, notifier),
                child: Text(
                  isLinked ? 'Manage' : 'Link Phone',
                  style: TextStyle(
                    color:
                        isLinked ? AppColors.textPrimary : AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(
      WhatsAppUserProfile profile, WhatsAppLoggingNotifier notifier) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Automated Briefings & Nudges',
                regionalText: 'स्वचालित संदेश व स्मरण प्राथमिकताएं',
              ),
              Icon(Icons.tune, color: AppColors.focusBlue, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Configure daily contextual WhatsApp alerts synchronized with circadian and meal windows.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSwitchRow(
            title: 'Morning Readiness & Agni Briefing',
            subtitle:
                'Daily 07:00 AM readiness score & training window recommendations',
            value: profile.enableMorningBriefing,
            onChanged: (val) => notifier.togglePreference(morningBriefing: val),
          ),
          _buildSwitchRow(
            title: 'Meal & Nutrition NLP Logging',
            subtitle:
                'Instantly calculate calories and macros from text/photo food logs',
            value: profile.enableMealLogging,
            onChanged: (val) => notifier.togglePreference(mealLogging: val),
          ),
          _buildSwitchRow(
            title: 'Hydration & Nimbu-Pani Nudges',
            subtitle:
                'Smart midday water reminders based on heat index and sweat rate',
            value: profile.enableWaterNudges,
            onChanged: (val) => notifier.togglePreference(waterNudges: val),
          ),
          _buildSwitchRow(
            title: 'Post-Dinner Shatapadi Walk Alert',
            subtitle:
                '100-step post-meal walk reminder 15 minutes after logged dinner',
            value: profile.enablePostDinnerWalkAlert,
            onChanged: (val) => notifier.togglePreference(postDinnerWalk: val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.karmaGreen,
            activeTrackColor: AppColors.karmaGreen.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.surfaceElevated,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSimulatorCard(
      WhatsAppState state, WhatsAppLoggingNotifier notifier) {
    final quickChips = [
      '2 roti, dal tadka, salad',
      '500ml water',
      '1 plate chicken biryani',
      'Walked 45 mins 4000 steps',
      'weight 74.2 kg',
      'today summary',
    ];

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Live WhatsApp Chat Simulator',
                regionalText: 'व्हाट्सएप चैट सिमुलेशन सैंडबॉक्स',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Meta Graph API Sandbox',
                  style: TextStyle(
                      color: Color(0xFF25D366),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Test real-time Natural Language Processing (NLP) of Indian meals, hydration, and workouts.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: quickChips.map((chip) {
              return ActionChip(
                backgroundColor: AppColors.surfaceElevated,
                label: Text(chip,
                    style: const TextStyle(
                        color: AppColors.focusBlue, fontSize: 11)),
                onPressed: () {
                  _messageController.text = chip;
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type WhatsApp message (e.g. 2 roti dal curd)...',
                    hintStyle: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      notifier.simulateInboundMessage(val);
                      _messageController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.sm)),
                ),
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    notifier.simulateInboundMessage(_messageController.text);
                    _messageController.clear();
                  }
                },
                child: const Icon(Icons.send,
                    color: AppColors.background, size: 18),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Message Stream (Recent Inbound & Responses):',
            style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.messageHistory
              .take(4)
              .map((msg) => _buildMessageBubble(msg)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(WhatsAppMessageRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_pin,
                      color: AppColors.focusBlue, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'User Inbound: "${record.rawMessage}"',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF075E54).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: const Color(0xFF25D366).withValues(alpha: 0.3)),
            ),
            child: Text(
              record.botReplyText,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 11, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesGalleryCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Interactive WhatsApp Templates',
                regionalText: 'इंटरैक्टिव व्हाट्सएप टेम्प्लेट्स',
              ),
              Icon(Icons.dashboard_customize,
                  color: AppColors.karmaGreen, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pre-approved Meta Business interactive templates with quick action buttons.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTemplateItem(
            type: WhatsAppTemplateType.morningReadiness,
            description:
                'Contains morning readiness gauge, Agni state, and action buttons [🍳 Log Breakfast, 🏋️ View Workout].',
          ),
          _buildTemplateItem(
            type: WhatsAppTemplateType.postMealShatapadi,
            description:
                'Triggered 15 mins post-dinner with 1-tap walk initiation [✅ Walking Now, 💧 Log Water].',
          ),
          _buildTemplateItem(
            type: WhatsAppTemplateType.waterHydrationNudge,
            description:
                'Dynamic midday hydration prompt with quick add buttons [+250 mL, +500 mL].',
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateItem({
    required WhatsAppTemplateType type,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.3),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showPhoneLinkModal(
    BuildContext context,
    WhatsAppUserProfile profile,
    WhatsAppLoggingNotifier notifier,
  ) {
    _phoneController.text = profile.phoneNumber;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Link WhatsApp Mobile',
                        regionalText: 'व्हाट्सएप मोबाइल नंबर जोड़ें',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: '10-Digit Mobile Number (+91)',
                      labelStyle:
                          const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (profile.linkStatus ==
                      WhatsAppLinkStatus.pendingVerification) ...[
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Enter 6-Digit OTP',
                        labelStyle:
                            const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.surfaceElevated,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md)),
                      ),
                      onPressed: () {
                        if (profile.linkStatus ==
                            WhatsAppLinkStatus.pendingVerification) {
                          final success =
                              notifier.confirmOtp(_otpController.text);
                          if (success) Navigator.pop(ctx);
                        } else {
                          notifier.initiatePhoneLinking(_phoneController.text);
                          Navigator.pop(ctx);
                        }
                      },
                      child: Text(
                        profile.linkStatus ==
                                WhatsAppLinkStatus.pendingVerification
                            ? 'Verify OTP'
                            : 'Send OTP',
                        style: const TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              primaryText: 'WhatsApp Logging Architecture',
              regionalText: 'व्हाट्सएप लॉगिंग वास्तुकला व सुरक्षा',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma\'s WhatsApp Business integration enables friction-free health logging for Indian users. Send natural language text or food photos directly via WhatsApp to automatically record meals, water, and physical activity. Inbound messages are processed via pure-Dart deterministic NLP and synced securely to your user-scoped Firestore profile with end-to-end data ownership.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
