// lib/shared/widgets/bottom_nav_bar.dart
// §P0-D2 — FitKarma custom bottom navigation bar.
// Rule of Two: gradient + glow on active tab only.

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// Navigation item definition.
class FitNavItem {
  const FitNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// FitKarma bottom navigation bar with spring-animated active tab indicator.
/// Active tab shows an orange glow dot and highlighted icon color.
class FitBottomNavBar extends StatefulWidget {
  const FitBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<FitNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<FitBottomNavBar> createState() => _FitBottomNavBarState();
}

class _FitBottomNavBarState extends State<FitBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _itemControllers;

  @override
  void initState() {
    super.initState();
    _itemControllers = List.generate(
      widget.items.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        value: i == widget.currentIndex ? 1.0 : 0.0,
      ),
    );
  }

  @override
  void didUpdateWidget(FitBottomNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _itemControllers[old.currentIndex].reverse();
      _itemControllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColorsDark.surface0,
        border: Border(
          top: BorderSide(color: AppColorsDark.divider, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(widget.items.length, (i) {
          final item = widget.items[i];
          final isActive = widget.currentIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedBuilder(
                animation: _itemControllers[i],
                builder: (context, _) {
                  final t = _itemControllers[i].value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.0 + 0.12 * t,
                        child: Icon(
                          isActive ? item.activeIcon : item.icon,
                          size: 24,
                          color: Color.lerp(
                            AppColorsDark.textMuted,
                            AppColorsDark.primary,
                            t,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: AppTypography.labelMd.copyWith(
                          color: Color.lerp(
                            AppColorsDark.textMuted,
                            AppColorsDark.primary,
                            t,
                          ),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Active dot indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 4 : 0,
                        height: isActive ? 4 : 0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorsDark.primary,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColorsDark.primaryGlow,
                                    blurRadius: 6,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Default FitKarma navigation items.
const List<FitNavItem> defaultNavItems = [
  FitNavItem(
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view_rounded,
    label: 'Home',
  ),
  FitNavItem(
    icon: Icons.track_changes_outlined,
    activeIcon: Icons.track_changes_rounded,
    label: 'Mission',
  ),
  FitNavItem(
    icon: Icons.restaurant_outlined,
    activeIcon: Icons.restaurant_rounded,
    label: 'Nutrition',
  ),
  FitNavItem(
    icon: Icons.fitness_center_outlined,
    activeIcon: Icons.fitness_center_rounded,
    label: 'Workout',
  ),
  FitNavItem(
    icon: Icons.people_outline_rounded,
    activeIcon: Icons.people_rounded,
    label: 'Social',
  ),
];
