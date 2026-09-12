import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/main.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/onboarding_repository.dart';
import '../../domain/models/onboarding_state.dart';
import 'welcome_step.dart';
import 'goals_step.dart';
import 'demographics_step.dart';
import 'dosha_quiz_step.dart';
import 'womens_health_step.dart';
import 'blueprint_step.dart';
import 'diet_plan_results_step.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  return OnboardingRepository(db: db, syncWorker: syncWorker);
});

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingFlowScreen({super.key, this.onComplete});

  @override
  ConsumerState<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  OnboardingState _state = const OnboardingState();

  final int _totalSteps = 7;

  void _nextPage() {
    if (_state.currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_state.currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _state = _state.copyWith(isSubmitting: true));

    final repo = ref.read(onboardingRepositoryProvider);
    // Persist to local Drift database & outbox queue
    await repo.saveCompleteOnboarding(
      userId: 'local-user-demo-1',
      state: _state,
    );

    setState(() => _state = _state.copyWith(isSubmitting: false));

    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FoundationDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_state.currentStep + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: _state.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: _previousPage,
              )
            : null,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryCyan),
            minHeight: 6,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${_state.currentStep + 1}/$_totalSteps',
                style: AppTypography.label.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Controlled progression
          onPageChanged: (index) {
            setState(() => _state = _state.copyWith(currentStep: index));
          },
          children: [
            // 0: Welcome
            WelcomeStep(onNext: _nextPage),

            // 1: Goals
            GoalsStep(
              selectedGoal: _state.goal!,
              onGoalSelected: (g) => setState(() => _state = _state.copyWith(goal: g)),
              onNext: _nextPage,
            ),

            // 2: Demographics
            DemographicsStep(
              age: _state.age,
              gender: _state.gender,
              heightCm: _state.heightCm,
              weightKg: _state.weightKg,
              activityLevel: _state.activityLevel,
              onAgeChanged: (a) => setState(() => _state = _state.copyWith(age: a)),
              onGenderChanged: (g) => setState(() => _state = _state.copyWith(gender: g)),
              onHeightChanged: (h) => setState(() => _state = _state.copyWith(heightCm: h)),
              onWeightChanged: (w) => setState(() => _state = _state.copyWith(weightKg: w)),
              onActivityChanged: (act) => setState(() => _state = _state.copyWith(activityLevel: act)),
              onNext: _nextPage,
            ),

            // 3: Dosha Quiz
            DoshaQuizStep(
              onDoshaCalculated: (d) => setState(() => _state = _state.copyWith(doshaProfile: d)),
              onNext: _nextPage,
            ),

            // 4: Women's Health Layer
            WomensHealthStep(
              enableWomensHealth: _state.enableWomensHealth,
              onToggleEnable: (val) => setState(() => _state = _state.copyWith(enableWomensHealth: val)),
              onProfileChanged: (prof) => setState(() => _state = _state.copyWith(cycleProfile: prof)),
              onNext: _nextPage,
            ),

            // 5: Blueprint Selection
            BlueprintStep(
              selectedBlueprint: _state.selectedBlueprint!,
              onBlueprintSelected: (b) => setState(() => _state = _state.copyWith(selectedBlueprint: b)),
              onNext: _nextPage,
            ),

            // 6: AI Diet Plan Results
            DietPlanResultsStep(
              state: _state,
              onFinish: _finishOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}
