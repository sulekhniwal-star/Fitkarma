import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/core_providers.dart';
import 'core/theme/app_theme.dart';
import 'screens/style_guide_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FitkarmaApp(),
    ),
  );
}

class FitkarmaApp extends ConsumerWidget {
  const FitkarmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'Fitkarma',
      debugShowCheckedModeBanner: false,
      theme: FitkarmaAppTheme.lightTheme,
      darkTheme: FitkarmaAppTheme.darkTheme,
      themeMode: themeMode,
      home: const StyleGuideScreen(),
    );
  }
}
