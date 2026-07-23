import 'dart:async';

import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// §P1-B — Welcome Screen
///
/// Full-bleed dark gradient splash screen with spring-reveal logo animation,
/// value proposition copy, and two CTAs.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  Timer? _startTimer;

  // Logo animations (300ms delay then spring-reveal)
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  // Content (tagline + buttons) fades in after logo settles
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Logo: plays for 900ms, starts from scale 0.6 → 1.0 with spring bounce
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 1.0, curve: AppSprings.logoRevealCurve),
      ),
    );

    // Content: fades + slides up after logo at 400ms delay for 550ms
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Sequence: wait 300ms, play logo, then play content
    _startTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoController.forward().then((_) {
          if (mounted) _contentController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onGetStarted() {
    final next = ref.read(onboardingFlowProvider.notifier).advance();
    if (next != null) context.go(pathForStep(next));
  }

  void _onLogin() {
    context.go(AppRoutes.login);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColorsDark.heroDeep,
      body: Stack(
        children: [
          // ── Full-bleed gradient background ────────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppColorsDark.heroGradient,
              ),
            ),
          ),

          // ── Ambient glow behind the logo ─────────────────────────────────
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.5 - 140,
            child: AnimatedBuilder(
              animation: _logoOpacity,
              builder: (context, _) => Opacity(
                opacity: _logoOpacity.value * 0.6,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColorsDark.primary.withValues(alpha: 0.35),
                        AppColorsDark.secondary.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Main content column ───────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo block
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, _) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: const _FitkarmaLogo(),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Tagline + body copy
                FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            'Your health, your karma.',
                            textAlign: TextAlign.center,
                            style: AppTypography.displayMd.copyWith(
                              color: AppColorsDark.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Track steps, food, sleep, and vitals.\nEarn karma. Build habits that last.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColorsDark.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // CTA buttons
                FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          // Get Started primary CTA
                          SizedBox(
                            width: double.infinity,
                            child: FitButton(
                              key: const Key('welcome_get_started_btn'),
                              onPressed: _onGetStarted,
                              height: 54,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: AppTypography.h3.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Already have account — text link
                          TextButton(
                            key: const Key('welcome_login_btn'),
                            onPressed: _onLogin,
                            child: Text(
                              'I already have an account',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColorsDark.textSecondary,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColorsDark.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FitkarmaLogo ──────────────────────────────────────────────────────────────

/// Inline logo widget: flame icon + "FitKarma" wordmark.
/// Kept self-contained so the animation wrapper can scale/fade it easily.
class _FitkarmaLogo extends StatelessWidget {
  const _FitkarmaLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flame icon with radial glow
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColorsDark.primary.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Icon(
              Icons.local_fire_department_rounded,
              size: 64,
              color: AppColorsDark.primary,
              shadows: [
                Shadow(color: AppColorsDark.primaryGlow, blurRadius: 24),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Wordmark
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Fit',
                style: AppTypography.displayLg.copyWith(
                  color: AppColorsDark.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'Karma',
                style: AppTypography.displayLg.copyWith(
                  color: AppColorsDark.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
