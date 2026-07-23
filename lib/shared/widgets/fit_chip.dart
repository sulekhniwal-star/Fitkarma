import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:flutter/material.dart';

class FitChip extends StatefulWidget {
  const FitChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeText,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badgeText;
  final IconData? icon;

  @override
  State<FitChip> createState() => _FitChipState();
}

class _FitChipState extends State<FitChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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

    final glassColor = isDark ? AppColorsDark.glass : AppColorsLight.glass;
    final glassBorderColor = isDark
        ? AppColorsDark.glassBorder
        : AppColorsLight.glassBorder;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;

    Color bgCol = glassColor;
    Color borderCol = glassBorderColor;
    Color txtCol = textSecondary;

    if (widget.isSelected) {
      bgCol = primaryColor.withOpacity(0.12);
      borderCol = primaryColor.withOpacity(0.4);
      txtCol = primaryColor;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: bgCol,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: borderCol, width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 14, color: txtCol),
                  const SizedBox(width: 6.0),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected ? primaryColor : textPrimary,
                  ),
                ),
                if (widget.badgeText != null) ...[
                  const SizedBox(width: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? primaryColor.withOpacity(0.2)
                          : (isDark
                                ? AppColorsDark.surface1
                                : AppColorsLight.surface1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      widget.badgeText!,
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w800,
                        color: widget.isSelected ? primaryColor : textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
