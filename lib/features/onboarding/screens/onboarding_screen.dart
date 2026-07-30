import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
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
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
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
                      backgroundColor: AppColors.bgSecondary,
                      color: AppColors.primaryCyan,
                      minHeight: 6.0,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${currentStep + 1}/7', style: AppTypography.labelSmall),
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
          Text('Welcome to FitKarma', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('What should we call you?', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            style: AppTypography.titleMedium,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: AppTypography.bodyMedium,
              filled: true,
              fillColor: AppColors.bgSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
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
          Text('Your Biometrics', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Local calculations only — privacy protected', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),

          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Height (cm)', style: AppTypography.titleMedium),
                    Text('${profile.heightCm.round()} cm', style: AppTypography.titleLarge),
                  ],
                ),
                Slider(
                  value: profile.heightCm,
                  min: 120,
                  max: 220,
                  activeColor: AppColors.primaryCyan,
                  onChanged: (val) {
                    ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(heightCm: val));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight (kg)', style: AppTypography.titleMedium),
                    Text('${profile.weightKg.toStringAsFixed(1)} kg', style: AppTypography.titleLarge),
                  ],
                ),
                Slider(
                  value: profile.weightKg,
                  min: 40,
                  max: 150,
                  activeColor: AppColors.primaryEmerald,
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
          Text('Primary Goal', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Choose your main focus for the program', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),

          ...PrimaryGoal.values.map((goal) {
            final isSelected = profile.primaryGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(primaryGoal: goal));
                },
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primaryCyan : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      goal.name.toUpperCase(),
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected ? AppColors.primaryCyan : AppColors.textPrimary,
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
          Text('Dietary Preference', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Tailored for Indian food intelligence', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),

          ...DietaryPreference.values.map((diet) {
            final isSelected = profile.dietaryPreference == diet;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(dietaryPreference: diet));
                },
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.restaurant : Icons.restaurant_menu,
                      color: isSelected ? AppColors.primaryEmerald : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      diet.name.toUpperCase(),
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected ? AppColors.primaryEmerald : AppColors.textPrimary,
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
          Text('Ayurveda Dosha Quiz', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Select your primary body constitution', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),

          ...DoshaType.values.map((dosha) {
            final isSelected = profile.doshaType == dosha;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateProfile(profile.copyWith(doshaType: dosha));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.spa,
                      color: isSelected ? AppColors.primaryViolet : AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      dosha.name.toUpperCase(),
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected ? AppColors.primaryViolet : AppColors.textPrimary,
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
            Text('Your Program Blueprint', style: AppTypography.displayLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('Locally computed metabolic baseline', style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.lg),

            GlassCard(
              child: Column(
                children: [
                  _buildMetricRow('BMI', profile.bmi.toStringAsFixed(1)),
                  const Divider(color: AppColors.glassBorder),
                  _buildMetricRow('BMR (Basal Rate)', '${profile.bmr.round()} kcal'),
                  const Divider(color: AppColors.glassBorder),
                  _buildMetricRow('TDEE (Daily Expenditure)', '${profile.tdee.round()} kcal'),
                  const Divider(color: AppColors.glassBorder),
                  _buildMetricRow('Target Daily Calories', '${profile.targetCalories} kcal'),
                  const Divider(color: AppColors.glassBorder),
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
          Text('Health Data Sync', style: AppTypography.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Connect Health Connect / HealthKit for step & sleep tracking', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xl),

          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.errorRed, size: 32.0),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Connect (Android)', style: AppTypography.titleMedium),
                      Text('Auto-sync steps, sleep, and vitals', style: AppTypography.labelSmall),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  activeThumbColor: AppColors.primaryEmerald,
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryCyan)),
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
          backgroundColor: AppColors.primaryCyan,
          foregroundColor: AppColors.bgPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
