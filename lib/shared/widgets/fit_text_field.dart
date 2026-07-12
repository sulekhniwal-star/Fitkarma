import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:flutter/material.dart';

class FitTextField extends StatefulWidget {
  const FitTextField({
    super.key,
    required this.controller,
    required this.englishLabel,
    this.hindiLabel,
    this.hintText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String englishLabel;
  final String? hindiLabel;
  final String? hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  State<FitTextField> createState() => _FitTextFieldState();
}

class _FitTextFieldState extends State<FitTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final glassColor = isDark ? AppColorsDark.glass : AppColorsLight.glass;
    final glassBorderColor = isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder;
    final primaryColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final errorColor = isDark ? AppColorsDark.error : AppColorsLight.error;

    Color currentBorderColor = glassBorderColor;
    if (_isFocused) {
      currentBorderColor = primaryColor;
    } else if (widget.errorText != null) {
      currentBorderColor = errorColor;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BilingualLabel(
          englishText: widget.englishLabel,
          hindiText: widget.hindiLabel,
          englishStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _isFocused ? primaryColor : textSecondary,
          ),
        ),
        const SizedBox(height: 6.0),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: currentBorderColor, width: 1.0),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                    )
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 14.0,
              color: textPrimary,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: textSecondary.withOpacity(0.5),
                fontSize: 14.0,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              border: InputBorder.none,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6.0),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontSize: 11.0,
              color: errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
