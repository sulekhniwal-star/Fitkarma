import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_typography.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/bilingual_label.dart';

void main() {
  runApp(const ProviderScope(child: FitKarmaApp()));
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.darkTheme,
    );
  }
}
