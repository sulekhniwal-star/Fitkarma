enum OnboardingFlowStep {
  welcome(title: 'Welcome', canSkip: false),
  goals(title: 'Your Goals', canSkip: false),
  demographics(title: 'Demographics', canSkip: false),
  doshaQuiz(title: 'Ayurvedic Dosha Quiz', canSkip: true),
  womensHealth(title: 'Women\'s Health', canSkip: true),
  aiDietResults(title: 'AI Diet Blueprint', canSkip: false),
  blueprintSelection(title: 'Workout Blueprint', canSkip: false);

  final String title;
  final bool canSkip;

  const OnboardingFlowStep({
    required this.title,
    required this.canSkip,
  });

  /// Computes linear progress (0.0 to 1.0)
  double get progressPercentage => (index + 1) / OnboardingFlowStep.values.length;
}
