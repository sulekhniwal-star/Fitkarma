import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: FitkarmaApp()));
}

class FitkarmaApp extends ConsumerStatefulWidget {
  const FitkarmaApp({super.key});

  @override
  ConsumerState<FitkarmaApp> createState() => _FitkarmaAppState();
}

class _FitkarmaAppState extends ConsumerState<FitkarmaApp> {
  late final _router = AppRouter.create(ref);

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Fitkarma',
      debugShowCheckedModeBanner: false,
      theme: FitkarmaAppTheme.lightTheme,
      darkTheme: FitkarmaAppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
