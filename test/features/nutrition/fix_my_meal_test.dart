import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/nutrition/models/meal_photo_analyzer.dart';
import 'package:fitkarma/features/nutrition/screens/fix_my_meal_result_screen.dart';

void main() {
  group('§P5-C Fix My Meal — AI Meal Photo Analysis & Cost Optimization Tests',
      () {
    const analyzer = MealPhotoAnalyzer();

    test(
        'MealPhotoAnalyzer uses cache-first pattern recognition for common Indian meals without AI API call',
        () async {
      final samplePhoto = File('sample_poha.jpg');
      final result = await analyzer.analyze(samplePhoto);

      expect(result.isAiFallbackUsed, isFalse); // Cost optimized: 0 API cost
      expect(result.foodItem.name, equals('Poha with Peanuts'));
      expect(result.totalCalories, equals(250.0));
      expect(result.fixSuggestions, isNotEmpty);
    });

    test(
        'MealPhotoAnalyzer triggers Vision AI fallback for unrecognized complex meals',
        () async {
      final novelPhoto = File('unknown_exotic_dish.jpg');
      final result = await analyzer.analyze(novelPhoto);

      expect(result.isAiFallbackUsed, isTrue); // Fallback used
      expect(result.foodItem.name, contains('Dal Makhani'));
      expect(result.fixSuggestions.any((s) => s.contains('curd or paneer')),
          isTrue);
    });

    testWidgets(
        'FixMyMealResultScreen renders full analysis breakdown and portion slider',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FixMyMealResultScreen(photoFile: File('sample_paneer.jpg')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fix My Meal — Vision AI'), findsOneWidget);
      expect(find.textContaining('Detected: Paneer Tikka'), findsOneWidget);
      expect(find.text('Meal Quality Breakdown:'), findsOneWidget);
      expect(find.text('Smart Meal Fix Suggestions:'), findsOneWidget);
      expect(find.text('Log This Meal'), findsOneWidget);
    });
  });
}
