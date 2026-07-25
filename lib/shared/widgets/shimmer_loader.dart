// lib/shared/widgets/shimmer_loader.dart
// §P0-D2 — Shimmer loading skeleton.
// Anti-pattern prevention: never show empty state before first data load.
// Rule of Two: gradient + animation only (no glow/blur).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Animated shimmer skeleton for loading states.
/// Use instead of empty state or spinner while Drift data is loading.
class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({
    super.key,
    this.width,
    this.height = 60.0,
    this.borderRadius = AppRadius.md,
    this.lines = 1,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final int lines;

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmer = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lines > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.lines,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i < widget.lines - 1 ? 8.0 : 0),
            child: _buildSingle(
              width: i == widget.lines - 1
                  ? (widget.width != null ? widget.width! * 0.65 : null)
                  : widget.width,
            ),
          ),
        ),
      );
    }
    return _buildSingle(width: widget.width);
  }

  Widget _buildSingle({double? width}) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_shimmer.value - 1, 0),
              end: Alignment(_shimmer.value + 1, 0),
              colors: const [
                AppColorsDark.surface0,
                AppColorsDark.surface2,
                AppColorsDark.surface0,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// A full-card shimmer placeholder matching BentoCard dimensions.
class BentoShimmer extends StatelessWidget {
  const BentoShimmer({super.key, this.height = 120.0});
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(height: height, borderRadius: AppRadius.bentoOuter);
  }
}
