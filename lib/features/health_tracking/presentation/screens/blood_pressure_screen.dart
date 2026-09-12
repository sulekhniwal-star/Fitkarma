import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/services/preventive_intelligence_engine.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final _systolicController = TextEditingController(text: '122');
  final _diastolicController = TextEditingController(text: '78');
  final _pulseController = TextEditingController(text: '72');
  final _engine = const PreventiveIntelligenceEngine();

  late BPStagingResult _staging;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final sys = int.tryParse(_systolicController.text) ?? 120;
    final dia = int.tryParse(_diastolicController.text) ?? 80;
    setState(() {
      _staging = _engine.classifyBloodPressure(
        systolicMmHg: sys,
        diastolicMmHg: dia,
      );
    });
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Vascular & Blood Pressure',
          hindi: 'रक्तचाप व हृदय स्वास्थ्य',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Classification Hero Card
            BentoCard(
              isGlowing: true,
              glowColor: _staging.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_systolicController.text}/${_diastolicController.text}',
                            style: AppTypography.h1.copyWith(
                              color: _staging.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('mmHg', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _staging.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _staging.color),
                        ),
                        child: Text(
                          _staging.label,
                          style: AppTypography.label.copyWith(color: _staging.color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_staging.labelHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: AppColors.accentCoral, size: 18),
                      const SizedBox(width: 8),
                      Text('Pulse Pressure: ${_staging.pulsePressure} mmHg', style: AppTypography.label),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _staging.clinicalInsight,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Log New Reading Inputs
            Text('Record New Measurement', style: AppTypography.h3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _systolicController,
                    label: 'Systolic (Top)',
                    hint: '120',
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _diastolicController,
                    label: 'Diastolic (Bottom)',
                    hint: '80',
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _pulseController,
                    label: 'Pulse (BPM)',
                    hint: '72',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Indian Dietary / Lifestyle Guidelines
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primaryCyan, size: 20),
                      const SizedBox(width: 8),
                      Text('Cardiovascular Action Plan', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGuidelineBullet('Reduce pickle, papad, and packaged namkeen sodium content.'),
                  _buildGuidelineBullet('Hydrate with tender coconut water (natural potassium source).'),
                  _buildGuidelineBullet('Practice 10 mins Anulom Vilom Pranayama morning and night.'),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassHover,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: AppColors.textMuted)),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTypography.h3,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTypography.h3.copyWith(color: AppColors.textMuted),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryCyan, fontSize: 16)),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
