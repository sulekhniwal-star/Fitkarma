import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/india_trust/domain/services/abha_integration_engine.dart';

class AbhaLinkScreen extends ConsumerStatefulWidget {
  const AbhaLinkScreen({super.key});

  @override
  ConsumerState<AbhaLinkScreen> createState() => _AbhaLinkScreenState();
}

class _AbhaLinkScreenState extends ConsumerState<AbhaLinkScreen> {
  final _engine = const AbhaIntegrationEngine();
  final _abhaController = TextEditingController(text: '14-8842-1940-5521');
  bool _isLinked = true;
  String _statusMessage = 'Linked with Ayushman Bharat Digital Mission (ABDM)';

  @override
  void dispose() {
    _abhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('ABHA & ABDM Integration', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ABDM Official Banner Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.primaryEmerald,
              isGlowing: _isLinked,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_user, color: AppColors.primaryEmerald, size: 28),
                          const SizedBox(width: 8),
                          Text('ABHA HEALTH ID', style: AppTypography.h3),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isLinked
                              ? AppColors.primaryEmerald.withValues(alpha: 0.2)
                              : AppColors.accentAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _isLinked ? 'VERIFIED & LINKED' : 'NOT LINKED',
                          style: AppTypography.label.copyWith(
                            color: _isLinked ? AppColors.primaryEmerald : AppColors.accentAmber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Text('14-Digit ABHA Number:', style: AppTypography.label),
                  const SizedBox(height: 4),
                  Text(
                    _engine.formatAbhaNumber(_abhaController.text),
                    style: AppTypography.heroMetric.copyWith(fontSize: 24, color: AppColors.primaryCyan),
                  ),
                  const SizedBox(height: 8),
                  Text('ABHA Address (PHR): rahul.sharma@abdm', style: AppTypography.bodySmall),
                  const SizedBox(height: 4),
                  Text(_statusMessage, style: AppTypography.bilingualSub.copyWith(color: AppColors.primaryEmerald)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FHIR Records Sync Section
            Text('FHIR Clinical Records Sync', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sync, color: AppColors.primaryCyan),
                      const SizedBox(width: 8),
                      Text('Diagnostic Report (HL7 FHIR R4)', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Biomarkers, blood glucose, and cellular longevity age are automatically formatted and encrypted into HL7 FHIR bundles for seamless consent-based sharing with your doctor.',
                    style: AppTypography.bodySmall,
                  ),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last ABDM Gateway Sync:', style: AppTypography.label),
                      Text('Today, 10:45 AM', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Consent Management
            Text('DPDP Act 2023 Consent Controls', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ABDM Gateway Health Linkage', style: AppTypography.h3),
                      Switch(
                        value: _isLinked,
                        activeThumbColor: AppColors.primaryEmerald,
                        onChanged: (val) {
                          setState(() {
                            _isLinked = val;
                            _statusMessage = val ? 'Linked with ABDM' : 'ABDM linkage paused';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You maintain 100% ownership of your health records. You can revoke doctor access or disconnect ABHA anytime.',
                    style: AppTypography.bilingualSub,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
