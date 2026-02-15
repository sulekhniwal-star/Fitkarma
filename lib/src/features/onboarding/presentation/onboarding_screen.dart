import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_router.dart';
import '../../../constants/app_colors.dart';
import '../application/onboarding_controller.dart';
import '../application/dosha_quiz_controller.dart';
import 'dosha_quiz_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int get _totalSteps => 8;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Progress Indicator
              Row(
                children: List.generate(
                  _totalSteps,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= state.currentStep
                            ? AppColors.primary
                            : AppColors.textHint.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: index == state.currentStep
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _LanguageStep(onNext: _nextPage),
                    _BasicInfoStep(onNext: _nextPage),
                    _PhysicalStep(onNext: _nextPage),
                    _GoalStep(onNext: _nextPage),
                    _ActivityLevelStep(onNext: _nextPage),
                    _DietaryStep(onNext: _nextPage),
                    _WorkoutPreferenceStep(onNext: _nextPage),
                    _DoshaPlaceholderStep(
                      onFinish: () async {
                        try {
                          await ref
                              .read(onboardingControllerProvider.notifier)
                              .completeOnboarding();
                          if (context.mounted) {
                            context.goNamed(AppRoute.dashboard.name);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to save profile: ${e.toString()}',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _LanguageStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Bengali'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your language',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'नमस्ते! अपनी भाषा चुनें',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: languages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lang = languages[index];
              return ListTile(
                title: Text(
                  lang,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.textHint.withValues(alpha: 0.2),
                  ),
                ),
                onTap: () {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .updateLanguage(lang);
                  ref.read(onboardingControllerProvider.notifier).nextStep();
                  onNext();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BasicInfoStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _BasicInfoStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us about yourself',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        TextField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) => ref
              .read(onboardingControllerProvider.notifier)
              .updateBasicInfo(name: val),
        ),
        const SizedBox(height: 24),
        // Simple Gender Toggle
        Row(
          children: [
            Expanded(
              child: _GenderCard(
                label: 'Male',
                isSelected:
                    ref.watch(onboardingControllerProvider).gender == 'Male',
                onTap: () => ref
                    .read(onboardingControllerProvider.notifier)
                    .updateBasicInfo(gender: 'Male'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GenderCard(
                label: 'Female',
                isSelected:
                    ref.watch(onboardingControllerProvider).gender == 'Female',
                onTap: () => ref
                    .read(onboardingControllerProvider.notifier)
                    .updateBasicInfo(gender: 'Female'),
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            ref.read(onboardingControllerProvider.notifier).nextStep();
            onNext();
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

class _PhysicalStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _PhysicalStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Physical Stats',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Text(
          'Height: ${state.height.toInt()} cm',
          style: const TextStyle(fontSize: 18),
        ),
        Slider(
          value: state.height,
          min: 100,
          max: 250,
          onChanged: (val) => ref
              .read(onboardingControllerProvider.notifier)
              .updateBasicInfo(height: val),
        ),
        const SizedBox(height: 24),
        Text(
          'Weight: ${state.weight.toInt()} kg',
          style: const TextStyle(fontSize: 18),
        ),
        Slider(
          value: state.weight,
          min: 30,
          max: 200,
          onChanged: (val) => ref
              .read(onboardingControllerProvider.notifier)
              .updateBasicInfo(weight: val),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            ref.read(onboardingControllerProvider.notifier).nextStep();
            onNext();
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

class _GoalStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _GoalStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ['Weight Loss', 'Muscle Gain', 'Stay Fit', 'Manage Health'];
    final state = ref.watch(onboardingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your goal?',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = goals[index];
              final isSelected = state.goal == goal;
              return ListTile(
                title: Text(goal),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                tileColor: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint.withValues(alpha: 0.2),
                  ),
                ),
                onTap: () {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .updateGoal(goal);
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(onboardingControllerProvider.notifier).nextStep();
            onNext();
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

class _ActivityLevelStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _ActivityLevelStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = [
      {'label': 'Sedentary', 'desc': 'Office job, little to no exercise'},
      {
        'label': 'Lightly Active',
        'desc': 'Light exercise/sports 1-3 days/week',
      },
      {
        'label': 'Moderately Active',
        'desc': 'Moderate exercise/sports 3-5 days/week',
      },
      {'label': 'Very Active', 'desc': 'Hard exercise/sports 6-7 days/week'},
      {
        'label': 'Extra Active',
        'desc': 'Very hard daily exercise or physical job',
      },
    ];
    final state = ref.watch(onboardingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active level',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'How active is your daily lifestyle?',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: levels.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final level = levels[index];
              final isSelected = state.activityLevel == level['label'];
              return ListTile(
                title: Text(level['label']!),
                subtitle: Text(level['desc']!),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                tileColor: isSelected
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                onTap: () {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .updateActivityLevel(level['label']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(onboardingControllerProvider.notifier).nextStep();
              onNext();
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class _DietaryStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _DietaryStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = [
      {'label': 'Veg (Satvik)', 'desc': 'No meat, onion, or garlic'},
      {
        'label': 'Veg (Onion/Garlic)',
        'desc': 'No meat, but includes onion/garlic',
      },
      {'label': 'Vegetarian (Jain)', 'desc': 'Strict Jain dietary rules'},
      {'label': 'Non-Vegetarian', 'desc': 'Includes meat and eggs'},
      {'label': 'Eggetarian', 'desc': 'Vegetarian including eggs'},
      {'label': 'Vegan', 'desc': 'No animal products'},
    ];
    final state = ref.watch(onboardingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary preference',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us suggest the right Indian meals for you.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: prefs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pref = prefs[index];
              final isSelected = state.dietaryPreference == pref['label'];
              return ListTile(
                title: Text(pref['label']!),
                subtitle: Text(pref['desc']!),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                tileColor: isSelected
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                onTap: () {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .updateDietaryPreference(pref['label']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(onboardingControllerProvider.notifier).nextStep();
              onNext();
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class _WorkoutPreferenceStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _WorkoutPreferenceStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = [
      {'label': 'Yoga', 'icon': Icons.self_improvement},
      {'label': 'Bollywood Dance', 'icon': Icons.music_note},
      {'label': 'Home Workouts', 'icon': Icons.home},
      {'label': 'Gym Training', 'icon': Icons.fitness_center},
      {'label': 'Walking/Running', 'icon': Icons.directions_run},
      {'label': 'Sports', 'icon': Icons.sports_cricket},
    ];
    final state = ref.watch(onboardingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout style',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Pick types of activities you enjoy.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              final isSelected = state.workoutPreferences.contains(
                workout['label'],
              );
              return GestureDetector(
                onTap: () {
                  final current = List<String>.from(state.workoutPreferences);
                  if (isSelected) {
                    current.remove(workout['label']);
                  } else {
                    current.add(workout['label'] as String);
                  }
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .updateWorkoutPreferences(current);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textHint.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        workout['icon'] as IconData,
                        size: 40,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        workout['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(onboardingControllerProvider.notifier).nextStep();
              onNext();
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class _DoshaPlaceholderStep extends StatefulWidget {
  final VoidCallback onFinish;
  const _DoshaPlaceholderStep({required this.onFinish});

  @override
  State<_DoshaPlaceholderStep> createState() => _DoshaPlaceholderStepState();
}

class _DoshaPlaceholderStepState extends State<_DoshaPlaceholderStep> {
  bool _showQuiz = false;

  @override
  Widget build(BuildContext context) {
    if (_showQuiz) {
      return Consumer(
        builder: (context, ref, child) {
          return DoshaQuizWidget(
            onFinished: () {
              final resultDosha = ref
                  .read(doshaQuizControllerProvider)
                  .value
                  ?.resultDosha;
              if (resultDosha != null) {
                ref
                    .read(onboardingControllerProvider.notifier)
                    .updateDosha(resultDosha);
              }
              widget.onFinish();
            },
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.psychology, size: 100, color: AppColors.primary),
        const SizedBox(height: 32),
        Text(
          'Discover your Dosha',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'FitKarma uses Ayurvedic principles to personalize your nutrition. Find out if you are Vata, Pitta, or Kapha with a quick quiz.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _showQuiz = true),
            child: const Text('Take Quiz Now'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.onFinish,
          child: const Text('Skip for now'),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textHint.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
