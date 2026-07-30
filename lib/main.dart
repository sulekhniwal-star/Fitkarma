import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_colors.dart';

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryCyan,
          secondary: AppColors.primaryEmerald,
          surface: AppColors.bgSecondary,
        ),
      ),
    );
  }
}

class FoundationHomePage extends StatelessWidget {
  const FoundationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
