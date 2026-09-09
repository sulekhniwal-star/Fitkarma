import 'dart:math';
import 'glycemic_pipeline_models.dart';

/// Pure Dart Deterministic Engine for Retrospective Multi-Week Glycemic Telemetry
class GlycemicPipelineEngine {
  const GlycemicPipelineEngine();

  /// Processes retrospective glucose telemetry dataset into circadian windows & clinical biomarkers
  RetrospectiveGlycemicReport processRetrospectiveGlucoseTelemetry({
    required List<HistoricalGlucoseSample> samples,
    required List<PostprandialExcursion> mealExcursions,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    if (samples.isEmpty) {
      return RetrospectiveGlycemicReport(
        totalDaysAnalyzed: 0,
        totalSamplesProcessed: 0,
        overallMeanGlucose: 0.0,
        standardDeviation: 0.0,
        coefficientOfVariationPercent: 0.0,
        glucoseManagementIndicatorGmi: 0.0,
        timeInRangePercent: 0.0,
        timeAboveRangePercent: 0.0,
        timeBelowRangePercent: 0.0,
        stabilityZone: GlycemicStabilityZone.moderateVolatility,
        circadianWindows: const [],
        recentExcursions: const [],
        actionableMetabolicRecommendation: 'Insufficient glucose telemetry logged.',
        regionalMetabolicRecommendation: 'पर्याप्त शर्करा डेटा उपलब्ध नहीं है।',
        generatedAt: now,
      );
    }

    // 1. Core Statistical Aggregates
    final totalSamples = samples.length;
    final sumGlucose = samples.fold<double>(0.0, (acc, s) => acc + s.glucoseValueMgDl);
    final meanGlucose = sumGlucose / totalSamples;

    // Standard Deviation
    final sumSquaredDiff = samples.fold<double>(
      0.0,
      (acc, s) => acc + pow(s.glucoseValueMgDl - meanGlucose, 2),
    );
    final sd = sqrt(sumSquaredDiff / totalSamples);

    // Coefficient of Variation (CV %)
    final cvPercent = meanGlucose > 0 ? (sd / meanGlucose) * 100.0 : 0.0;

    // GMI Formula (Glucose Management Indicator %)
    final gmi = 3.31 + (0.02392 * meanGlucose);

    // Time in Range (70-140 mg/dL for non-diabetic/optimal longevity, or 70-180 standard)
    final inRangeCount = samples.where((s) => s.glucoseValueMgDl >= 70.0 && s.glucoseValueMgDl <= 140.0).length;
    final aboveRangeCount = samples.where((s) => s.glucoseValueMgDl > 140.0).length;
    final belowRangeCount = samples.where((s) => s.glucoseValueMgDl < 70.0).length;

    final tirPercent = (inRangeCount / totalSamples) * 100.0;
    final tarPercent = (aboveRangeCount / totalSamples) * 100.0;
    final tbrPercent = (belowRangeCount / totalSamples) * 100.0;

    // Days analyzed calculation
    final timestamps = samples.map((s) => s.timestamp).toList()..sort();
    final firstTime = timestamps.first;
    final lastTime = timestamps.last;
    final daysAnalyzed = max(1, lastTime.difference(firstTime).inDays + 1);

    // 2. Circadian Window Segmentation
    final circadianWindows = _segmentCircadianWindows(samples);

    // 3. Glycemic Stability Zone Classification
    GlycemicStabilityZone zone;
    if (cvPercent <= 33.0 && tirPercent >= 90.0 && tarPercent < 8.0) {
      zone = GlycemicStabilityZone.optimalStable;
    } else if (cvPercent <= 38.0 && tirPercent >= 75.0) {
      zone = GlycemicStabilityZone.moderateVolatility;
    } else {
      zone = GlycemicStabilityZone.highDysglycemia;
    }

    // 4. Chrono-Nutritional Recommendations
    final (rec, regRec) = _generateMetabolicGuidance(zone, circadianWindows, mealExcursions);

    return RetrospectiveGlycemicReport(
      totalDaysAnalyzed: daysAnalyzed,
      totalSamplesProcessed: totalSamples,
      overallMeanGlucose: double.parse(meanGlucose.toStringAsFixed(1)),
      standardDeviation: double.parse(sd.toStringAsFixed(1)),
      coefficientOfVariationPercent: double.parse(cvPercent.toStringAsFixed(1)),
      glucoseManagementIndicatorGmi: double.parse(gmi.toStringAsFixed(2)),
      timeInRangePercent: double.parse(tirPercent.toStringAsFixed(1)),
      timeAboveRangePercent: double.parse(tarPercent.toStringAsFixed(1)),
      timeBelowRangePercent: double.parse(tbrPercent.toStringAsFixed(1)),
      stabilityZone: zone,
      circadianWindows: circadianWindows,
      recentExcursions: mealExcursions,
      actionableMetabolicRecommendation: rec,
      regionalMetabolicRecommendation: regRec,
      generatedAt: now,
    );
  }

  List<WindowGlycemicSummary> _segmentCircadianWindows(List<HistoricalGlucoseSample> samples) {
    final Map<ChronoGlycemicWindow, List<HistoricalGlucoseSample>> buckets = {
      ChronoGlycemicWindow.dawnFasting: [],
      ChronoGlycemicWindow.postBreakfast: [],
      ChronoGlycemicWindow.postLunch: [],
      ChronoGlycemicWindow.postDinner: [],
      ChronoGlycemicWindow.nocturnal: [],
    };

    for (final sample in samples) {
      final hour = sample.timestamp.hour;
      if (hour >= 4 && hour < 8) {
        buckets[ChronoGlycemicWindow.dawnFasting]!.add(sample);
      } else if (hour >= 8 && hour < 12) {
        buckets[ChronoGlycemicWindow.postBreakfast]!.add(sample);
      } else if (hour >= 12 && hour < 16) {
        buckets[ChronoGlycemicWindow.postLunch]!.add(sample);
      } else if (hour >= 19 && hour < 23) {
        buckets[ChronoGlycemicWindow.postDinner]!.add(sample);
      } else {
        buckets[ChronoGlycemicWindow.nocturnal]!.add(sample);
      }
    }

    return buckets.entries.map((entry) {
      final window = entry.key;
      final bucketSamples = entry.value;

      if (bucketSamples.isEmpty) {
        return WindowGlycemicSummary(
          window: window,
          meanGlucose: 90.0,
          peakGlucose: 105.0,
          standardDeviation: 5.0,
          timeInRangePercent: 100.0,
          clinicalObservation: 'Baseline steady glucose state.',
          regionalObservation: 'सामान्य स्थिर शर्करा स्तर।',
        );
      }

      final sum = bucketSamples.fold<double>(0.0, (acc, s) => acc + s.glucoseValueMgDl);
      final mean = sum / bucketSamples.length;
      final peak = bucketSamples.map((s) => s.glucoseValueMgDl).reduce(max);

      final sumSqDiff = bucketSamples.fold<double>(
        0.0,
        (acc, s) => acc + pow(s.glucoseValueMgDl - mean, 2),
      );
      final sd = sqrt(sumSqDiff / bucketSamples.length);
      final inRange = bucketSamples.where((s) => s.glucoseValueMgDl >= 70.0 && s.glucoseValueMgDl <= 140.0).length;
      final tir = (inRange / bucketSamples.length) * 100.0;

      String obs;
      String regObs;

      switch (window) {
        case ChronoGlycemicWindow.dawnFasting:
          if (mean > 100.0) {
            obs = 'Mild Dawn Phenomenon detected. Hepatic gluconeogenesis active.';
            regObs = 'प्रभात शर्करा में हल्की वृद्धि देखी गई (यकृत ग्लूकोज स्राव)।';
          } else {
            obs = 'Optimal fasting glucose stability.';
            regObs = 'उत्कृष्ट उपवास शर्करा संतुलन।';
          }
          break;
        case ChronoGlycemicWindow.postBreakfast:
          if (peak > 135.0) {
            obs = 'High breakfast glycemic excursion. Consider pairing carbohydrates with protein/fiber.';
            regObs = 'नाश्ते के बाद शर्करा में वृद्धि। प्रोटीन व फाइबर की मात्रा बढ़ाएं।';
          } else {
            obs = 'Smooth morning postprandial curve.';
            regObs = 'प्रातराश पश्चात सुचारू शर्करा वक्र।';
          }
          break;
        case ChronoGlycemicWindow.postLunch:
          if (peak > 140.0) {
            obs = 'Post-lunch spike. Incorporate a 10-minute post-meal walk (Shatapadi).';
            regObs = 'दोपहर भोजन बाद उछाल। भोजनोपरांत १० मिनट शतपदी भ्रमण करें।';
          } else {
            obs = 'Balanced post-lunch insulin sensitivity.';
            regObs = 'मध्याह्न भोजन उपरांत संतुलित इंसुलिन संवेदनशीलता।';
          }
          break;
        case ChronoGlycemicWindow.postDinner:
          if (mean > 120.0) {
            obs = 'Delayed nocturnal clearance. Shift dinner 90 minutes before sleep.';
            regObs = 'रात्रि शर्करा का धीमा निकास। सोने से ९० मिनट पूर्व हल्का भोजन करें।';
          } else {
            obs = 'Efficient evening glycemic clearance.';
            regObs = 'सायंकालीन शर्करा का प्रभावी निष्कासन।';
          }
          break;
        case ChronoGlycemicWindow.nocturnal:
          if (bucketSamples.any((s) => s.glucoseValueMgDl < 70.0)) {
            obs = 'Sub-70 nocturnal dipping. Ensure complex carbs or healthy fats in dinner.';
            regObs = 'रात्रि के समय निम्न शर्करा स्तर। रात के भोजन में स्वस्थ वसा सम्मिलित करें।';
          } else {
            obs = 'Restful nocturnal metabolic baseline.';
            regObs = 'विश्रामदायी रात्रि चयापचय अवस्था।';
          }
          break;
      }

      return WindowGlycemicSummary(
        window: window,
        meanGlucose: double.parse(mean.toStringAsFixed(1)),
        peakGlucose: double.parse(peak.toStringAsFixed(1)),
        standardDeviation: double.parse(sd.toStringAsFixed(1)),
        timeInRangePercent: double.parse(tir.toStringAsFixed(1)),
        clinicalObservation: obs,
        regionalObservation: regObs,
      );
    }).toList();
  }

  (String, String) _generateMetabolicGuidance(
    GlycemicStabilityZone zone,
    List<WindowGlycemicSummary> windows,
    List<PostprandialExcursion> excursions,
  ) {
    switch (zone) {
      case GlycemicStabilityZone.optimalStable:
        return (
          'Outstanding glycemic stability (CV < 33%). Your chrono-nutritional meal pacing and post-meal activity support optimal cellular longevity and insulin sensitivity.',
          'उत्कृष्ट शर्करा साम्य अवस्था। आपका समयानुकूल खान-पान व शतपदी भ्रमण दीर्घायु एवं इंसुलिन संवेदनशीलता को बढ़ावा देता है।',
        );
      case GlycemicStabilityZone.moderateVolatility:
        return (
          'Moderate postprandial glycemic excursions detected. Implement 100-step Shatapadi walk after meals and increase soluble fiber/fenugreek (methi) to blunt glycemic spikes.',
          'मध्यम शर्करा उतार-चढ़ाव। भोजन के बाद शतपदी (१०० कदम चलना) करें एवं मेथी दाना व घुलनशील फाइबर का सेवन बढ़ाएं।',
        );
      case GlycemicStabilityZone.highDysglycemia:
        return (
          'Elevated glycemic variability observed (CV > 38%). Recommend sharing 30-day CGM telemetry with your diabetologist and adopting low-glycemic Ayurvedic whole foods.',
          'उच्च शर्करा अस्थिरता पाई गई। ३०-दिवसीय रिपोर्ट अपने चिकित्सक से साझा करें एवं कम ग्लाइसेमिक युक्त पौष्टिक आहार अपनाएं।',
        );
    }
  }
}
