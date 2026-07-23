import 'package:fitkarma/core/ai/ai_cache.dart';
import 'package:fitkarma/core/ai/insight_template_engine.dart';
import 'package:fitkarma/core/ai/rule_engine.dart';
import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/sync/connectivity_service.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AIComplexity { classification, dailyInsight, coaching, planning }

class AIRequest {
  AIRequest({
    required this.userId,
    required this.prompt,
    required this.promptHash,
    required this.complexity,
  });

  final String userId;
  final String prompt;
  final String promptHash;
  final AIComplexity complexity;
}

// Model Tiers for Groq API selection
enum GroqModel {
  llama3_8b, // Tiny (Classification, Category Labeling)
  llama3_70b_medium, // Medium (Daily insights, Program adaptations)
  llama3_70b_full, // Large (AI Coach chats, Transformation planning)
}

final aiRouterProvider = Provider<AIRouter>((ref) {
  final db = ref.watch(databaseProvider);
  final rule = RuleEngine(db);
  final template = InsightTemplateEngine(db);
  final cache = AICache(db);
  return AIRouter(
    rule,
    template,
    cache,
    () async => ref.read(connectivityProvider),
  );
});

class AIRouter {
  AIRouter(
    this._ruleEngine,
    this._templateEngine,
    this._cache,
    this._checkOnline,
  );

  final RuleEngine _ruleEngine;
  final InsightTemplateEngine _templateEngine;
  final AICache _cache;
  final Future<bool> Function() _checkOnline;

  // Custom mock configurations for local Gemma execution
  bool isLocalModelLoaded = true;
  DeviceTier deviceHardwareTier = DeviceTier.medium;

  // Simulates flaky Groq endpoint behavior for retry policy validations
  bool simulateFlakyGroq = false;
  int _groqFailuresCount = 0;

  /// Main routing method checking layers sequentially
  Future<String> route(AIRequest request) async {
    // Layer 1: Rule Engine
    final ruleResult = await _ruleEngine.tryHandle(request);
    if (ruleResult != null) return ruleResult;

    // Layer 2: Template Engine
    final templateResult = await _templateEngine.tryHandle(request);
    if (templateResult != null) return templateResult;

    // Layer 3: Cache lookup (Composite key matching userId + promptHash)
    final cachedResponse = await _cache.get(request.userId, request.promptHash);
    if (cachedResponse != null) return cachedResponse;

    // Layer 4: Connectivity check & Offline fallback
    final isOnline = await _checkOnline();
    if (!isOnline) {
      if (deviceHardwareTier == DeviceTier.high && isLocalModelLoaded) {
        return "[Local Gemma-2B Offline Response] I analyzed your query locally: Since you are currently offline, I recommend performing light stretches or moderate bodyweight exercises. Avoid starting new high-intensity programs until internet connection is restored to sync your logs.";
      } else {
        return "Offline System Message: You are offline, and local model inference is unsupported or not downloaded on this device. Reconnect to the internet to resume AI coaching.";
      }
    }

    // Layer 5: Select model tier and invoke Groq with 3x retry policy
    final model = _selectModel(request.complexity);
    final response = await _callGroqWithRetry(model, request);

    // Cache the successful response
    await _cache.set(request.userId, request.promptHash, response);

    return response;
  }

  /// Classifies complexity into model tiers
  GroqModel _selectModel(AIComplexity complexity) {
    return switch (complexity) {
      AIComplexity.classification => GroqModel.llama3_8b,
      AIComplexity.dailyInsight => GroqModel.llama3_70b_medium,
      AIComplexity.coaching => GroqModel.llama3_70b_full,
      AIComplexity.planning => GroqModel.llama3_70b_full,
    };
  }

  /// Simulates calling Groq API using a 3x retry policy with backoff
  Future<String> _callGroqWithRetry(GroqModel model, AIRequest request) async {
    int attempts = 0;
    const int maxAttempts = 3;
    int delayMs = 100; // Exponential backoff starts at 100ms

    while (attempts < maxAttempts) {
      attempts++;
      try {
        if (simulateFlakyGroq && _groqFailuresCount < 2) {
          _groqFailuresCount++;
          throw Exception(
            "HTTP 503: Groq Service Temporarily Unavailable (Flaky Demo)",
          );
        }

        // Reset count on success
        _groqFailuresCount = 0;
        return "Mock Groq Response from ${model.name}: Verified primary insights successfully computed.";
      } catch (e) {
        if (attempts >= maxAttempts) {
          rethrow; // Throws after 3 failures
        }
        // Wait with backoff
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        delayMs *= 2; // Double delay
      }
    }
    throw Exception("Failed to execute cloud AI inference after 3 attempts.");
  }
}
