import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bilingual_label.dart';

class ShareableProgressCardScreen extends StatefulWidget {
  final int streakDays;
  final int readinessScore;
  final int todaySteps;
  final int caloriesBurned;
  final String doshaType;

  const ShareableProgressCardScreen({
    super.key,
    this.streakDays = 14,
    this.readinessScore = 88,
    this.todaySteps = 9420,
    this.caloriesBurned = 580,
    this.doshaType = 'Pitta-Vata',
  });

  @override
  State<ShareableProgressCardScreen> createState() => _ShareableProgressCardScreenState();
}

class _ShareableProgressCardScreenState extends State<ShareableProgressCardScreen> {
  int _selectedCardThemeIndex = 0;

  final List<Map<String, dynamic>> _cardThemes = [
    {
      'title': 'Readiness & Streak',
      'subtitle': 'Longevity & Habit Master',
      'colors': [const Color(0xFF0D1B2A), const Color(0xFF1B4965)],
      'accent': AppColors.primaryCyan,
    },
    {
      'title': 'Desi Beast Mode',
      'subtitle': 'Strength & Calorie Burn',
      'colors': [const Color(0xFF1F1113), const Color(0xFF4A151C)],
      'accent': AppColors.accentCoral,
    },
    {
      'title': 'Sangha Walker',
      'subtitle': '10k Steps & Vitality',
      'colors': [const Color(0xFF0B2518), const Color(0xFF14532D)],
      'accent': AppColors.primaryEmerald,
    },
  ];

  void _shareToPlatform(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing 9:16 Story Card to $platform... 📸'),
        backgroundColor: AppColors.primaryEmerald,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = _cardThemes[_selectedCardThemeIndex];

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
          english: 'Shareable Story Card',
          hindi: 'इंस्टाग्राम व व्हाट्सएप स्टोरी कार्ड',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Theme Selector Tabs
            Row(
              children: List.generate(_cardThemes.length, (index) {
                final isSelected = _selectedCardThemeIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < _cardThemes.length - 1 ? 8.0 : 0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCardThemeIndex = index),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryCyan.withAlpha(30) : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryCyan : AppColors.borderGlass,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _cardThemes[index]['title'],
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // 9:16 Aspect Ratio Preview Story Card
            Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 460),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: activeTheme['colors'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: (activeTheme['accent'] as Color).withAlpha(120), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: (activeTheme['accent'] as Color).withAlpha(60),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Brand Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: (activeTheme['accent'] as Color).withAlpha(40),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.bolt, color: activeTheme['accent'] as Color, size: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'FITKARMA',
                                style: AppTypography.label.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(60),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Day ${widget.streakDays} Streak 🔥',
                              style: AppTypography.label.copyWith(color: AppColors.accentAmber, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ],
                      ),

                      // Center Hero Metric
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: activeTheme['accent'] as Color, width: 3),
                              color: Colors.black.withAlpha(40),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedCardThemeIndex == 0
                                      ? '${widget.readinessScore}'
                                      : (_selectedCardThemeIndex == 1
                                          ? '${widget.caloriesBurned}'
                                          : '${widget.todaySteps}'),
                                  style: AppTypography.heroMetric.copyWith(
                                    fontSize: 42,
                                    color: activeTheme['accent'] as Color,
                                  ),
                                ),
                                Text(
                                  _selectedCardThemeIndex == 0
                                      ? 'Readiness Score'
                                      : (_selectedCardThemeIndex == 1 ? 'Calories Burned' : 'Steps Taken'),
                                  style: AppTypography.label.copyWith(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            activeTheme['subtitle'] as String,
                            style: AppTypography.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"Har Roz Ek Naya Kadam • Consistency is My Dharma"',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white60, fontStyle: FontStyle.italic, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      // Bottom Stats Grid & Tag
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(70),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStoryStat('Dosha', widget.doshaType),
                                _buildStoryStat('Steps', '${widget.todaySteps}'),
                                _buildStoryStat('Burned', '${widget.caloriesBurned} cal'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AI-Powered Indian Health OS • fitkarma.app',
                            style: AppTypography.label.copyWith(fontSize: 10, color: Colors.white54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 20),

            // Share Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), // WhatsApp
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _shareToPlatform('WhatsApp Status'),
                    icon: const Icon(Icons.share, color: Colors.white, size: 18),
                    label: Text('WhatsApp Status', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1306C), // Instagram Pink
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _shareToPlatform('Instagram Stories'),
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    label: Text('Instagram Story', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
