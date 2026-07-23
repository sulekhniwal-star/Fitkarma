import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:flutter/material.dart';

enum FitButtonType { primary, secondary, accent }

class FitButton extends StatefulWidget {
  const FitButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = FitButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 48.0,
    this.padding,
    this.borderRadius = AppRadius.md,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final FitButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  State<FitButton> createState() => _FitButtonState();
}

class _FitButtonState extends State<FitButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppSprings.touchResponseCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active =
        !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

    Color btnColor;
    Color textColor;
    Color borderCol = Colors.transparent;

    switch (widget.type) {
      case FitButtonType.primary:
        btnColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;
        textColor = isDark ? Colors.black : Colors.white;
        break;
      case FitButtonType.secondary:
        btnColor = isDark ? AppColorsDark.glass : AppColorsLight.glass;
        textColor = isDark
            ? (isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary)
            : (isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary);
        borderCol = isDark
            ? AppColorsDark.glassBorder
            : AppColorsLight.glassBorder;
        break;
      case FitButtonType.accent:
        btnColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
        textColor = isDark ? Colors.black : Colors.white;
        break;
    }

    if (!active) {
      btnColor = isDark ? AppColorsDark.surface1 : AppColorsLight.surface1;
      textColor = isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted;
      borderCol = Colors.transparent;
    }

    final Widget content = widget.isLoading
        ? SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : DefaultTextStyle(
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            child: widget.child,
          );

    return GestureDetector(
      onTapDown: active ? (_) => _controller.forward() : null,
      onTapUp: active ? (_) => _controller.reverse() : null,
      onTapCancel: active ? () => _controller.reverse() : null,
      onTap: active ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          cursor: active ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            padding:
                widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: borderCol, width: 1.0),
              boxShadow: (widget.type == FitButtonType.primary && active)
                  ? (isDark
                        ? AppElevation.primaryGlowDark
                        : AppElevation.primaryGlowLight)
                  : null,
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
