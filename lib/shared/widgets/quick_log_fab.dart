import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Floating Action Button with speed-dial quick logging options
class QuickLogFab extends StatefulWidget {
  final VoidCallback onLogFood;
  final VoidCallback onLogWorkout;
  final VoidCallback onLogWater;

  const QuickLogFab({
    super.key,
    required this.onLogFood,
    required this.onLogWorkout,
    required this.onLogWater,
  });

  @override
  State<QuickLogFab> createState() => _QuickLogFabState();
}

class _QuickLogFabState extends State<QuickLogFab> {
  bool _isOpen = false;

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          _buildOptionFab(Icons.local_hospital, 'Water', widget.onLogWater, AppColors.infoBlue),
          const SizedBox(height: AppSpacing.sm),
          _buildOptionFab(Icons.fitness_center, 'Workout', widget.onLogWorkout, AppColors.primaryEmerald),
          const SizedBox(height: AppSpacing.sm),
          _buildOptionFab(Icons.restaurant, 'Food', widget.onLogFood, AppColors.warningAmber),
          const SizedBox(height: AppSpacing.md),
        ],
        FloatingActionButton(
          backgroundColor: AppColors.primaryCyan,
          foregroundColor: AppColors.bgPrimary,
          shape: const CircleBorder(),
          onPressed: _toggle,
          child: Icon(_isOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }

  Widget _buildOptionFab(IconData icon, String tooltip, VoidCallback onTap, Color color) {
    return FloatingActionButton.small(
      heroTag: tooltip,
      backgroundColor: color,
      foregroundColor: AppColors.bgPrimary,
      onPressed: () {
        _toggle();
        onTap();
      },
      child: Icon(icon),
    );
  }
}
