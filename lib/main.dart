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
import 'features/health_os/presentation/providers/dashboard_providers.dart';
import 'features/health_os/services/ai_routing_service.dart';
import 'features/health_os/services/health_os_brain.dart';
import 'features/health_tracking/services/google_health_sync_service.dart';
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

class FitKarmaApp extends ConsumerStatefulWidget {
  const FitKarmaApp({super.key});

  @override
  ConsumerState<FitKarmaApp> createState() => _FitKarmaAppState();
}

class _FitKarmaAppState extends ConsumerState<FitKarmaApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Trigger an initial sync on startup (after first frame so providers are ready)
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerWearableSync());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _triggerWearableSync();
    }
  }

  /// Pulls latest data from Health Connect / HealthKit → Drift → Outbox.
  /// Fire-and-forget: errors are handled inside GoogleHealthSyncService.
  void _triggerWearableSync() {
    final userId = ref.read(activeUserIdProvider);
    if (userId == 'local-user-demo-1') return; // not authenticated yet
    ref
        .read(googleHealthSyncServiceProvider.notifier)
        .syncData(userId: userId);
  }

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
