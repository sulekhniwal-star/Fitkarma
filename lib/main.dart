import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/constants/app_constants.dart';
import 'features/health_os/providers/health_os_provider.dart';
import 'features/health_os/presentation/health_os_briefing_card.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  await AppBootstrap.initialize();
  runApp(
    const ProviderScope(
      child: FitKarmaApp(),
    ),
  );
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dipAsync = ref.watch(dailyIntelligenceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dipAsync.when(
                data: (package) => HealthOsBriefingCard(package: package),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => Text('Error loading Health OS: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
