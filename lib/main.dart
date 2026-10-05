import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/database/app_database.dart';
import 'core/sync/outbox_sync_worker.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/auth_gate.dart';
import 'features/environmental/services/environmental_health_engine.dart';
import 'features/health_os/services/ai_routing_service.dart';
import 'features/health_os/services/health_os_brain.dart';
import 'features/metabolism/services/metabolism_engine.dart';

// Riverpod Global Providers
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final outboxSyncWorkerProvider = Provider<OutboxSyncWorker>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final client = ref.watch(supabaseClientProvider);
  final worker = OutboxSyncWorker(db: db, supabaseClient: client);
  ref.onDispose(() => worker.dispose());
  return worker;
});

final metabolismEngineProvider = Provider<MetabolismEngine>((ref) {
  return const MetabolismEngine();
});

final environmentalEngineProvider = Provider<EnvironmentalHealthEngine>((ref) {
  return const EnvironmentalHealthEngine();
});

final aiRoutingServiceProvider = Provider<AIRoutingService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AIRoutingService(supabaseClient: client);
});

final healthOSBrainProvider = Provider<HealthOSBrain>((ref) {
  return HealthOSBrain(
    metabolismEngine: ref.watch(metabolismEngineProvider),
    environmentalEngine: ref.watch(environmentalEngineProvider),
    aiRoutingService: ref.watch(aiRoutingServiceProvider),
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.anonKey,
  );
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
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}
