import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_typography.dart';
import 'shared/widgets/glass_card.dart';

void main() {
  runApp(const ProviderScope(child: FitKarmaApp()));
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryCyan,
          secondary: AppColors.primaryEmerald,
          surface: AppColors.bgSecondary,
        ),
      ),
      home: const FoundationHomePage(),
    );
  }
}

class FoundationHomePage extends StatelessWidget {
  const FoundationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FitKarma', style: AppTypography.displayLarge),
              const SizedBox(height: 8.0),
              Text(
                'India\'s Intelligent Health Operating System',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24.0),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.primaryEmerald),
                        const SizedBox(width: 8.0),
                        Text('Phase 0 Foundation Ready', style: AppTypography.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Modular folders, sub-directory READMEs, design system tokens, and Health OS models initialized.',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
