import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/india_trust/domain/models/india_trust_models.dart';
import 'package:fitkarma/features/india_trust/domain/services/vernacular_voice_engine.dart';
import 'package:fitkarma/features/india_trust/domain/services/whatsapp_logging_engine.dart';

class WhatsappVoiceLoggingScreen extends ConsumerStatefulWidget {
  const WhatsappVoiceLoggingScreen({super.key});

  @override
  ConsumerState<WhatsappVoiceLoggingScreen> createState() => _WhatsappVoiceLoggingScreenState();
}

class _WhatsappVoiceLoggingScreenState extends ConsumerState<WhatsappVoiceLoggingScreen> {
  final _voiceEngine = const VernacularVoiceEngine();
  final _whatsappEngine = const WhatsAppLoggingEngine();
  final _textController = TextEditingController(text: 'Maine lunch me 2 roti, 1 katori dal aur 100g paneer khaya');
  ParsedVernacularEntry? _parsedEntry;
  Map<String, dynamic>? _whatsappReply;

  @override
  void initState() {
    super.initState();
    _processInput();
  }

  void _processInput() {
    setState(() {
      _parsedEntry = _voiceEngine.parseTranscript(_textController.text);
      _whatsappReply = _whatsappEngine.processInboundMessage(
        fromPhoneNumber: '+919876543210',
        textMessage: _textController.text,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('WhatsApp & Voice Logging', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voice Input & Hinglish Text Field
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vernacular Voice / WhatsApp Log', style: AppTypography.h3),
                      IconButton(
                        icon: const Icon(Icons.mic, color: AppColors.primaryEmerald, size: 28),
                        onPressed: () {
                          _textController.text = 'Aaj subah 50 desi dand aur 20 Surya Namaskar kiya';
                          _processInput();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    maxLines: 2,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Speak or type in Hinglish / Hindi / English...',
                      hintStyle: AppTypography.bodySmall,
                      filled: true,
                      fillColor: AppColors.surfaceGlassHover,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => _processInput(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AI Entity Extraction Result
            if (_parsedEntry != null) ...[
              Text('Extracted Nutrition & Workout Entities', style: AppTypography.h2),
              const SizedBox(height: 8),
              BentoCard(
                padding: const EdgeInsets.all(16),
                glowColor: AppColors.primaryCyan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TYPE: ${_parsedEntry!.entryType.toUpperCase()}', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                        Text('Confidence: ${_parsedEntry!.confidencePct}%', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                      ],
                    ),
                    const Divider(color: AppColors.borderGlass, height: 20),
                    ..._parsedEntry!.extractedEntities.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.key.replaceAll('_', ' ').toUpperCase(), style: AppTypography.bodySmall),
                            Text('${e.value}', style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // WhatsApp Reply Simulation
            if (_whatsappReply != null) ...[
              Text('WhatsApp Automated Reply Preview', style: AppTypography.h2),
              const SizedBox(height: 8),
              BentoCard(
                padding: const EdgeInsets.all(16),
                glowColor: AppColors.primaryEmerald,
                isGlowing: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, color: AppColors.primaryEmerald),
                        const SizedBox(width: 8),
                        Text('FitKarma WhatsApp Assistant', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _whatsappReply!['reply_message'] as String,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
