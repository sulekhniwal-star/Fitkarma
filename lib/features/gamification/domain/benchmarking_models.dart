enum BenchmarkCategory {
  strength(
    label: 'Relative Strength (xBW)',
    regionalLabel: 'शारीरिक भार सापेक्ष शक्ति',
    iconName: 'fitness_center',
  ),
  cardiorespiratory(
    label: 'Cardiovascular & VO2 Max',
    regionalLabel: 'हृदय व श्वसन क्षमता',
    iconName: 'favorite',
  ),
  metabolicBodyComp(
    label: 'Metabolic & WHtR (South Asian)',
    regionalLabel: 'मेटाबॉलिक स्वास्थ्य व कमर अनुपात',
    iconName: 'monitor_weight',
  ),
  workCapacity(
    label: 'Daily Work Capacity & Steps',
    regionalLabel: 'दैनिक सहनशक्ति व गतिशीलता',
    iconName: 'directions_walk',
  );

  final String label;
  final String regionalLabel;
  final String iconName;

  const BenchmarkCategory({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

enum FitnessPercentileTier {
  legendary(
    title: 'Top 1% (Shreshtha)',
    regionalTitle: 'सर्वश्रेष्ठ (शीर्ष १%)',
    minPercentile: 99.0,
    colorCode: 0xFFFFD700,
  ),
  elite(
    title: 'Top 10% (Ati-Uttam)',
    regionalTitle: 'अति-उत्तम (शीर्ष १०%)',
    minPercentile: 90.0,
    colorCode: 0xFF00E676,
  ),
  superior(
    title: 'Top 25% (Uttam)',
    regionalTitle: 'उत्तम (शीर्ष २५%)',
    minPercentile: 75.0,
    colorCode: 0xFF00B0FF,
  ),
  average(
    title: 'Top 50% (Madhyam)',
    regionalTitle: 'मध्यम (सामान्य स्तर)',
    minPercentile: 50.0,
    colorCode: 0xFFFF9100,
  ),
  developing(
    title: 'Developing (Abhyas Apekshit)',
    regionalTitle: 'अभ्यास अपेक्षित (सुधार क्षेत्र)',
    minPercentile: 0.0,
    colorCode: 0xFFFF5252,
  );

  final String title;
  final String regionalTitle;
  final double minPercentile;
  final int colorCode;

  const FitnessPercentileTier({
    required this.title,
    required this.regionalTitle,
    required this.minPercentile,
    required this.colorCode,
  });
}

class BenchmarkMetric {
  final String id;
  final String name;
  final String regionalName;
  final BenchmarkCategory category;
  final double userValue;
  final String unit;
  final double cohortMean;
  final double cohortStdDev;
  final double percentile; // 0.0 to 100.0
  final FitnessPercentileTier tier;
  final String contextualInsight;
  final String regionalContextualInsight;

  const BenchmarkMetric({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.category,
    required this.userValue,
    required this.unit,
    required this.cohortMean,
    required this.cohortStdDev,
    required this.percentile,
    required this.tier,
    required this.contextualInsight,
    required this.regionalContextualInsight,
  });
}

class DemographicCohortProfile {
  final int age;
  final String biologicalSex;
  final double bodyweightKg;
  final String cohortName;
  final String regionalCohortName;
  final int cohortSampleSize;

  const DemographicCohortProfile({
    required this.age,
    required this.biologicalSex,
    required this.bodyweightKg,
    required this.cohortName,
    required this.regionalCohortName,
    required this.cohortSampleSize,
  });
}

class FitnessBenchmarkReport {
  final DemographicCohortProfile cohortProfile;
  final double compositeFitnessPercentile; // 0.0 to 100.0
  final FitnessPercentileTier overallTier;
  final List<BenchmarkMetric> allMetrics;
  final String primaryStrengthDomain;
  final String primaryGrowthDomain;

  const FitnessBenchmarkReport({
    required this.cohortProfile,
    required this.compositeFitnessPercentile,
    required this.overallTier,
    required this.allMetrics,
    required this.primaryStrengthDomain,
    required this.primaryGrowthDomain,
  });
}
