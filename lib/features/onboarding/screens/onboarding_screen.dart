import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../models/user_profile.dart';
import '../providers/onboarding_provider.dart';

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
    ref.read(onboardingProvider.notifier).nextStep();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _prevPage() {
    ref.read(onboardingProvider.notifier).previousStep();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final currentStep = onboardingState.currentStep;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              child: Row(
                children: [
                  if (currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: _prevPage,
                    ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / 7,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.primary,
                      minHeight: 6.0,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('${currentStep + 1}/7', style: AppTypography.labelMd),
                ],
              ),
            ),

            // Page View Container
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(context),
                  _buildBiometricsStep(context),
                  _buildGoalsStep(context),
                  _buildDietStep(context),
                  _buildDoshaStep(context),
                  _buildBlueprintStep(context),
                  _buildPermissionsStep(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Welcome Step
  Widget _buildWelcomeStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Welcome to FitKarma',
            hindiText: 'फिटकर्मा में आपका स्वागत है',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('What should we call you?', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            style: AppTypography.h2,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: AppTypography.bodyMd,
              filled: true,
              fillColor: AppColors.surface1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
            ),
            onChanged: (val) {
              ref.read(onboardingProvider.notifier).updateProfile(
                    state.profile.copyWith(name: val),
                  );
            },
          ),
          const Spacer(),
          _buildActionButton('Continue', _nextPage),
        ],
      ),
    );
  }

  // 2. Biometrics Step
  Widget _buildBiometricsStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final profile = state.profile;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Your Biometrics',
            hindiText: 'आपका शारीरिक विवरण',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Local calculations only — privacy protected', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.lg),

          BentoCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Height (cm)', style: AppTypography.h2),
                    Text('${profile.heightCm.round()} cm', style: AppTypography.h1),
                  ],
                ),
                Slider(
                  value: profile.heightCm,
                  min: 120,
                  max: 220,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(heightCm: val));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          BentoCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight (kg)', style: AppTypography.h2),
                    Text('${profile.weightKg.toStringAsFixed(1)} kg', style: AppTypography.h1),
                  ],
                ),
                Slider(
                  value: profile.weightKg,
                  min: 40,
                  max: 150,
                  activeColor: AppColors.accent,
                  onChanged: (val) {
                    ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(weightKg: val));
                  },
                ),
              ],
            ),
          ),

          const Spacer(),
          _buildActionButton('Next', _nextPage),
        ],
      ),
    );
  }

  // 3. Goals Step
  Widget _buildGoalsStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final profile = state.profile;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Primary Goal',
            hindiText: 'मुख्य लक्ष्य',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Choose your main focus for the program', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.lg),

          ...PrimaryGoal.values.map((goal) {
            final isSelected = profile.primaryGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BentoCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(primaryGoal: goal));
                },
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      goal.name.toUpperCase(),
                      style: AppTypography.h2.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Spacer(),
          _buildActionButton('Next', _nextPage),
        ],
      ),
    );
  }

  // 4. Diet Step
  Widget _buildDietStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final profile = state.profile;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Dietary Preference',
            hindiText: 'आहार प्राथमिकता',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Tailored for Indian food intelligence', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.lg),

          ...DietaryPreference.values.map((diet) {
            final isSelected = profile.dietaryPreference == diet;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BentoCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(dietaryPreference: diet));
                },
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.restaurant : Icons.restaurant_menu,
                      color: isSelected ? AppColors.success : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      diet.name.toUpperCase(),
                      style: AppTypography.h2.copyWith(
                        color: isSelected ? AppColors.success : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Spacer(),
          _buildActionButton('Next', _nextPage),
        ],
      ),
    );
  }

  // 5. Dosha Step
  Widget _buildDoshaStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final profile = state.profile;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Ayurveda Dosha Quiz',
            hindiText: 'आयुर्वेद दोष प्रश्नोत्तरी',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Select your primary body constitution', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.lg),

          ...DoshaType.values.map((dosha) {
            final isSelected = profile.doshaType == dosha;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BentoCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(doshaType: dosha));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.spa,
                      color: isSelected ? AppColors.secondary : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      dosha.name.toUpperCase(),
                      style: AppTypography.h2.copyWith(
                        color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Spacer(),
          _buildActionButton('Generate Program Blueprint', _nextPage),
        ],
      ),
    );
  }

  // 6. Program Blueprint Step
  Widget _buildBlueprintStep(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final profile = state.profile;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              englishText: 'Your Program Blueprint',
              hindiText: 'आपका प्रोग्राम ब्लूप्रिंट',
              englishStyle: AppTypography.displayLg,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Locally computed metabolic baseline', style: AppTypography.bodyMd),
            const SizedBox(height: AppSpacing.lg),

            BentoCard(
              child: Column(
                children: [
                  _buildMetricRow('BMI', profile.bmi.toStringAsFixed(1)),
                  const Divider(color: AppColors.divider),
                  _buildMetricRow('BMR (Basal Rate)', '${profile.bmr.round()} kcal'),
                  const Divider(color: AppColors.divider),
                  _buildMetricRow('TDEE (Daily Expenditure)', '${profile.tdee.round()} kcal'),
                  const Divider(color: AppColors.divider),
                  _buildMetricRow('Target Daily Calories', '${profile.targetCalories} kcal'),
                  const Divider(color: AppColors.divider),
                  _buildMetricRow('Target Daily Protein', '${profile.targetProteinGrams} g'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildActionButton('Continue to Permissions', _nextPage),
          ],
        ),
      ),
    );
  }

  // 7. Permissions Step
  Widget _buildPermissionsStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'Health Data Sync',
            hindiText: 'हेल्थ डेटा सिंक',
            englishStyle: AppTypography.displayLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Connect Health Connect / HealthKit for step & sleep tracking', style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.xl),

          BentoCard(
            child: Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.error, size: 32.0),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Connect (Android)', style: AppTypography.h2),
                      Text('Auto-sync steps, sleep, and vitals', style: AppTypography.labelMd),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  activeThumbColor: AppColors.success,
                  onChanged: (val) {},
                ),
              ],
            ),
          ),

          const Spacer(),
          _buildActionButton('Complete Onboarding', () {
            ref.read(onboardingProvider.notifier).nextStep();
          }),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMd),
          Text(value, style: AppTypography.h2.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.bg0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppTypography.h2.copyWith(color: AppColors.bg0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
