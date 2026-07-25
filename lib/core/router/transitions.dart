// lib/core/router/transitions.dart
// §P0-B — Page transition helpers using spring physics.
// All transitions use AppSprings curves — no linear easing anywhere.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// Duration constants for consistent page transitions.
class TransitionDuration {
  TransitionDuration._();
  static const standard = Duration(milliseconds: 350);
  static const fast = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 500);
}

/// §P0-B Slide Transition — slides in from the right (standard push).
CustomTransitionPage<T> slideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 350),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: AppSprings.smoothAnimationCurve),
      );
      final slideOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.3, 0.0),
      ).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: AppSprings.smoothAnimationCurve),
      );
      return SlideTransition(
        position: slideIn,
        child: SlideTransition(position: slideOut, child: child),
      );
    },
  );
}

/// §P0-B Fade Transition — cross-fade for tab/modal-style navigation.
CustomTransitionPage<T> fadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      );
    },
  );
}

/// §P0-B Scale + Fade Transition — spring-scale reveal for hero destinations.
CustomTransitionPage<T> scaleTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 400),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: AppSprings.touchResponseCurve),
      );
      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );
      return ScaleTransition(
        scale: scale,
        child: FadeTransition(opacity: fade, child: child),
      );
    },
  );
}

/// §P0-B Bottom Sheet Transition — slides up from the bottom (modal flow).
CustomTransitionPage<T> bottomSheetTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 380),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: AppSprings.logoRevealCurve),
      );
      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
