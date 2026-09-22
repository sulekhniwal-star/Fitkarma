import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../coach/presentation/screens/ai_coach_screen.dart';
import '../../../health_tracking/presentation/screens/health_dashboard_screen.dart';
import '../../../nutrition/presentation/screens/food_home_screen.dart';
import '../../../workout/presentation/screens/workout_home_screen.dart';
import 'health_os_home_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HealthOSHomeScreen(onTabSelected: _onTabSelected),
      const WorkoutHomeScreen(showBackButton: false),
      const FoodHomeScreen(showBackButton: false),
      const HealthDashboardScreen(showBackButton: false),
      const AICoachScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard.withAlpha(240),
          border: const Border(
            top: BorderSide(color: AppColors.borderGlass, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Today',
                  hindi: 'आज',
                  activeColor: AppColors.primaryCyan,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.fitness_center_outlined,
                  activeIcon: Icons.fitness_center_rounded,
                  label: 'Workout',
                  hindi: 'व्यायाम',
                  activeColor: AppColors.primaryEmerald,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.restaurant_outlined,
                  activeIcon: Icons.restaurant_rounded,
                  label: 'Food',
                  hindi: 'आहार',
                  activeColor: AppColors.accentAmber,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Vitals',
                  hindi: 'स्वास्थ्य',
                  activeColor: AppColors.accentCoral,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.smart_toy_outlined,
                  activeIcon: Icons.smart_toy_rounded,
                  label: 'AI Coach',
                  hindi: 'गुरु',
                  activeColor: AppColors.accentPurple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String hindi,
    required Color activeColor,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: activeColor.withAlpha(80)) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
