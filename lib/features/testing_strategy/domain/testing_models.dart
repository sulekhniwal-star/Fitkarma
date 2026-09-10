import 'package:flutter/foundation.dart';

/// Testing pyramid layers in FitKarma Health OS
enum TestLayer {
  unit(
    name: 'Pure Dart Unit Tests',
    regionalName: 'यूनिट परीक्षण (गणितीय एल्गोरिदम)',
    targetCoverage: 95,
    description:
        'Deterministic pure Dart domain engines with zero external dependencies.',
  ),
  widget(
    name: 'Widget & UI Component Tests',
    regionalName: 'विजेट व यूआई घटक परीक्षण',
    targetCoverage: 85,
    description:
        'Bento cards, BilingualLabel rendering, GlowingMetric states, and themes.',
  ),
  integration(
    name: 'End-to-End Integration Flows',
    regionalName: 'एकीकृत उपयोगकर्ता प्रवाह परीक्षण',
    targetCoverage: 80,
    description:
        'Onboarding to workout completion and offline recovery pipelines.',
  ),
  securityRules(
    name: 'Firestore & Storage Security Tests',
    regionalName: 'सुरक्षा नियम व प्रमाणीकरण परीक्षण',
    targetCoverage: 100,
    description:
        'Strict UID owner isolation and client immutability validations.',
  ),
  golden(
    name: 'Golden Snapshot Visual Tests',
    regionalName: 'गोल्डन विजुअल स्नैपशॉट परीक्षण',
    targetCoverage: 75,
    description:
        'Pixel-perfect glassmorphic dark-mode regression verification.',
  );

  final String name;
  final String regionalName;
  final int targetCoverage;
  final String description;

  const TestLayer({
    required this.name,
    required this.regionalName,
    required this.targetCoverage,
    required this.description,
  });
}

/// Execution status of a test suite
enum TestExecutionStatus {
  passed(name: 'Passed', regionalName: 'सफल'),
  failed(name: 'Failed', regionalName: 'विफल'),
  running(name: 'Executing', regionalName: 'प्रक्रियाधीन');

  final String name;
  final String regionalName;

  const TestExecutionStatus({
    required this.name,
    required this.regionalName,
  });
}

/// Feature-specific test suite breakdown
@immutable
class FeatureTestSuite {
  final String featureName;
  final String regionalFeatureName;
  final TestLayer layer;
  final int testCount;
  final int passedCount;
  final double executionTimeMs;
  final double coveragePercent;
  final TestExecutionStatus status;

  const FeatureTestSuite({
    required this.featureName,
    required this.regionalFeatureName,
    required this.layer,
    required this.testCount,
    required this.passedCount,
    required this.executionTimeMs,
    required this.coveragePercent,
    required this.status,
  });

  bool get isAllPassed =>
      passedCount == testCount && status == TestExecutionStatus.passed;
}

/// Overall Testing Pyramid Report across FitKarma
@immutable
class TestingPyramidReport {
  final int totalTestsCount;
  final int totalPassedTests;
  final double overallCoveragePercent;
  final double totalExecutionTimeMs;
  final List<FeatureTestSuite> featureSuites;
  final DateTime generatedAt;

  const TestingPyramidReport({
    required this.totalTestsCount,
    required this.totalPassedTests,
    required this.overallCoveragePercent,
    required this.totalExecutionTimeMs,
    required this.featureSuites,
    required this.generatedAt,
  });

  bool get isAllGreen => totalPassedTests == totalTestsCount;
}
