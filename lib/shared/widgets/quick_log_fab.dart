// lib/shared/widgets/quick_log_fab.dart
// §P0-D2 — FAB with expandable radial menu for quick logging.
// Rule of Two: gradient + shadow (no blur, no glow on every item).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// A quick-log action item in the FAB menu.
class QuickLogItem {
  const QuickLogItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
}

/// Radially expanding FAB for quick-logging (food, water, workout, vitals).
/// Tapping the main FAB expands a vertical stack of action items.
class QuickLogFab extends StatefulWidget {
  const QuickLogFab({super.key, required this.items});
  final List<QuickLogItem> items;

  @override
  State<QuickLogFab> createState() => _QuickLogFabState();
}

class _QuickLogFabState extends State<QuickLogFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Action items — appear above the FAB
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final items = <Widget>[];
            for (int i = 0; i < widget.items.length; i++) {
              final item = widget.items[i];
              final delay = i * 0.12;
              final t = (_controller.value - delay).clamp(0.0, 1.0 - delay) /
                  (1.0 - delay);
              items.add(
                Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - t)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _QuickLogItemRow(item: item, onClose: _toggle),
                    ),
                  ),
                ),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.reversed.toList(),
            );
          },
        ),
        // Main FAB
        GestureDetector(
          onTap: _toggle,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColorsDark.primary, AppColorsDark.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsDark.primary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: _isOpen ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 250),
                curve: AppSprings.smoothAnimationCurve,
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickLogItemRow extends StatelessWidget {
  const _QuickLogItemRow({required this.item, required this.onClose});
  final QuickLogItem item;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? AppColorsDark.primary;
    return GestureDetector(
      onTap: () {
        onClose();
        item.onTap();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColorsDark.surface1,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColorsDark.glassBorder),
            ),
            child: Text(item.label, style: AppTypography.bodyMd.copyWith(color: AppColorsDark.textPrimary)),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              border: Border.all(color: color.withOpacity(0.4), width: 1.5),
            ),
            child: Icon(item.icon, size: 18, color: color),
          ),
        ],
      ),
    );
  }
}
