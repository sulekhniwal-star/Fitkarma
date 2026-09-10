import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/benchmarking_engine.dart';
import '../../domain/benchmarking_models.dart';

final benchmarkingProvider =
    StateNotifierProvider<BenchmarkingNotifier, FitnessBenchmarkReport>((ref) {
  return BenchmarkingNotifier();
});

class BenchmarkingNotifier extends StateNotifier<FitnessBenchmarkReport> {
  BenchmarkingNotifier() : super(_getInitialReport());

  static FitnessBenchmarkReport _getInitialReport() {
    const cohortProfile = DemographicCohortProfile(
      age: 28,
      biologicalSex: 'Male',
      bodyweightKg: 72.0,
      cohortName: 'Indian Urban Active Males (25–34y, 72kg)',
      regionalCohortName: 'भारतीय सक्रिय पुरुष (२५-३४ वर्ष, ७२ किग्रा)',
      cohortSampleSize: 48250,
    );

    final metrics = [
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_squat',
        name: 'Back Squat / Desi Baithak (1RM)',
        regionalName: 'बारबेल स्क्वैट / देसी बैठक (१ अधिकतम वजन)',
        category: BenchmarkCategory.strength,
        userValue: 110.0,
        unit: 'kg (1.53x BW)',
        cohortMean: 75.0,
        cohortStdDev: 18.0,
        contextualInsight:
            'Top 8% strength relative to South Asian demographic cohort.',
        regionalContextualInsight: 'समान आयु वर्ग में शीर्ष ८% शक्ति क्षमता।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_press',
        name: 'Flat Bench Press (1RM)',
        regionalName: 'फ्लैट बेंच प्रेस (१ अधिकतम वजन)',
        category: BenchmarkCategory.strength,
        userValue: 85.0,
        unit: 'kg (1.18x BW)',
        cohortMean: 62.0,
        cohortStdDev: 14.0,
        contextualInsight:
            'Superior pectoral power output; safe rotator cuff mechanics.',
        regionalContextualInsight: 'उत्कृष्ट चेस्ट शक्ति और सुरक्षित तकनीक।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_deadlift',
        name: 'Conventional Deadlift (1RM)',
        regionalName: 'पारंपरिक डेडलिफ्ट (१ अधिकतम वजन)',
        category: BenchmarkCategory.strength,
        userValue: 135.0,
        unit: 'kg (1.87x BW)',
        cohortMean: 95.0,
        cohortStdDev: 22.0,
        contextualInsight:
            'Elite posterior chain force development; low lumbar shear risk.',
        regionalContextualInsight: 'शीर्ष श्रेणी की रीढ़ व हैमस्ट्रिंग शक्ति।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_vo2max',
        name: 'Estimated VO2 Max',
        regionalName: 'अनुमानित VO2 Max (हृदय-श्वसन क्षमता)',
        category: BenchmarkCategory.cardiorespiratory,
        userValue: 46.8,
        unit: 'ml/kg/min',
        cohortMean: 38.5,
        cohortStdDev: 5.2,
        contextualInsight:
            'Cardiorespiratory fitness exceeds 89% of urban Indian peers.',
        regionalContextualInsight:
            'हृदय व फेफड़ों की कार्यक्षमता ८९% साथियों से बेहतर।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_rhr',
        name: 'Resting Heart Rate (RHR)',
        regionalName: 'विश्राम हृदय गति (RHR)',
        category: BenchmarkCategory.cardiorespiratory,
        userValue: 58.0,
        unit: 'BPM',
        cohortMean: 72.0,
        cohortStdDev: 8.5,
        lowerIsBetter: true,
        contextualInsight:
            'Strong vagal tone and high parasympathetic autonomic recovery.',
        regionalContextualInsight: 'मजबूत हृदय स्वास्थ्य और त्वरित रिकवरी दर।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_whtr',
        name: 'Waist-to-Height Ratio (WHtR)',
        regionalName: 'कमर-ऊंचाई अनुपात (मेटाबॉलिक सुरक्षा)',
        category: BenchmarkCategory.metabolicBodyComp,
        userValue: 0.46,
        unit: 'Ratio (<0.50 Target)',
        cohortMean: 0.52,
        cohortStdDev: 0.045,
        lowerIsBetter: true,
        contextualInsight:
            'Optimal cardiometabolic protection against visceral adiposity.',
        regionalContextualInsight:
            'पेट की आंतरिक चर्बी से पूर्ण मेटाबॉलिक सुरक्षा।',
      ),
      BenchmarkingEngine.evaluateMetric(
        id: 'bench_steps',
        name: 'Daily Active Step Volume',
        regionalName: 'दैनिक सक्रिय कदम संख्या',
        category: BenchmarkCategory.workCapacity,
        userValue: 11400.0,
        unit: 'Steps/Day',
        cohortMean: 6800.0,
        cohortStdDev: 2400.0,
        contextualInsight:
            'High non-exercise physical activity (NEAT) and insulin sensitivity.',
        regionalContextualInsight:
            'उत्कृष्ट दैनिक सक्रियता और इंसुलिन संवेदनशीलता।',
      ),
    ];

    return BenchmarkingEngine.generateCohortReport(
      cohortProfile: cohortProfile,
      evaluatedMetrics: metrics,
    );
  }
}
