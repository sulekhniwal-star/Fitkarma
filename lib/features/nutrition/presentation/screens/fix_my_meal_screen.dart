import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class FixMyMealScreen extends StatefulWidget {
  const FixMyMealScreen({super.key});

  @override
  State<FixMyMealScreen> createState() => _FixMyMealScreenState();
}

class _FixMyMealScreenState extends State<FixMyMealScreen> {
  bool _isFixed = false;

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
          english: 'Fix My Meal (AI Vision)',
          hindi: 'एआई थाली सुधार व विश्लेषण',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Scanner Visual Box
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassHover,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined, color: AppColors.primaryCyan, size: 48),
                      const SizedBox(height: 10),
                      Text('Scanned: Punjabi Chole Bhature Thali', style: AppTypography.h3),
                      const SizedBox(height: 4),
                      Text('Vision Confidence: 94.8% (Offline Cached Model)', style: AppTypography.bilingualSub),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accentPurple),
                      ),
                      child: Text('AI Cost-Optimized', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.accentPurple)),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            if (!_isFixed) ...[
              // Current Unhealthy Breakdown Card
              BentoCard(
                isGlowing: true,
                glowColor: AppColors.accentCoral,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Original Meal Analysis', style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentCoral.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accentCoral),
                          ),
                          child: Text('Score 38/100', style: AppTypography.label.copyWith(color: AppColors.accentCoral)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMacroBadge('860 kcal', 'Calories', AppColors.accentCoral),
                        _buildMacroBadge('14.2g', 'Protein', AppColors.textPrimary),
                        _buildMacroBadge('108g', 'Carbs (Maida)', AppColors.accentCoral),
                        _buildMacroBadge('38g', 'Deep Fat', AppColors.accentCoral),
                      ],
                    ),
                    const Divider(color: AppColors.borderGlass, height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.accentCoral, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'High Glycemic Excursion: Deep-fried maida bhature causes rapid glucose spike followed by an energy crash within 90 minutes.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 20),

              // AI 1-Tap Transformation Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: AppColors.textOnAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    setState(() => _isFixed = true);
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: Text('Fix My Meal (Apply Smart Indian Swaps)', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textOnAccent)),
                ),
              ),
            ] else ...[
              // Fixed Healthy Thali Card
              BentoCard(
                isGlowing: true,
                glowColor: AppColors.primaryEmerald,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AI Optimized High-Protein Thali', style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryEmerald),
                          ),
                          child: Text('Score 91/100', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMacroBadge('520 kcal (-340)', 'Calories', AppColors.primaryEmerald),
                        _buildMacroBadge('28.5g (+14.3g)', 'Protein', AppColors.primaryCyan),
                        _buildMacroBadge('54g (-54g)', 'Complex Carbs', AppColors.accentAmber),
                        _buildMacroBadge('14g (-24g)', 'Healthy Fats', AppColors.primaryEmerald),
                      ],
                    ),
                    const Divider(color: AppColors.borderGlass, height: 24),
                    Text('Swaps Applied:', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    _buildSwapCheck('Replaced 2 Fried Bhature with 2 Roasted Jowar Bhakris.'),
                    _buildSwapCheck('Added 60g Raw Paneer Cubes & Cucumber Kachumber Salad.'),
                    _buildSwapCheck('Glycemic index blunted from 82 to 46 (Zero energy crash).'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    foregroundColor: AppColors.textOnAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Optimized meal saved to your daily log!'),
                        backgroundColor: AppColors.primaryEmerald,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('Log Optimized Meal', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textOnAccent)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBadge(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.bodyMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(label, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildSwapCheck(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryEmerald, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
