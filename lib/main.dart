import 'package:fit_karma/data/models/steps_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fit_karma/presentation/providers/auth/auth_bloc.dart';
import 'package:fit_karma/presentation/screens/auth/login_screen.dart';
import 'package:fit_karma/presentation/screens/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart'; // For sl()

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await di.init();

  // Initialize Hive
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(StepsModelAdapter()); // Added this line
    // Open basic boxes if needed
    await Hive.openBox('settings');
    await Hive.openBox<StepsModel>('steps');
    AppLogger.info('Hive initialized');
  } catch (e, stack) {
    AppLogger.error('Failed to initialize Hive', e, stack);
  }

  runApp(const FitKarmaApp());
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(AppStarted()),
      child: MaterialApp(
        title: 'FitKarma',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const HomeScreen();
            } else if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
