import 'dart:convert';
import 'package:fitkarma/core/database/app_database.dart';

extension DailyIntelligencePackageExtension on DailyIntelligencePackage {
  List<String> get parsedActiveRisks {
    try {
      final decoded = jsonDecode(activeRisks);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }
}
