import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AzureSyncClient {
  bool simulateNetworkFailures = false;
  final _random = Random();

  /// Mock endpoint posting local delta updates to Azure SQL
  Future<bool> postSyncPayload(String entityType, String payload) async {
    // Artificial network latency
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (simulateNetworkFailures) {
      // Simulate flaky network connection for testing retry logic
      return _random.nextDouble() > 0.6; // 60% failure rate
    }

    return true;
  }
}

final azureSyncClientProvider = Provider<AzureSyncClient>((ref) {
  return AzureSyncClient();
});
