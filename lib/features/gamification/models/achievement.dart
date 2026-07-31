/// Achievement Badge Model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isUnlocked;
  final String category;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.isUnlocked,
    required this.category,
  });
}

/// Demographic Cohort Benchmark Item
class CohortBenchmark {
  final String metricName;
  final String userPercentile; // e.g. "Top 15%"
  final String cohortName; // e.g. "Male, 25-30 Indian Cohort"

  const CohortBenchmark({
    required this.metricName,
    required this.userPercentile,
    required this.cohortName,
  });
}
