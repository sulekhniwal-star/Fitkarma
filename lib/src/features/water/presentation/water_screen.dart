import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../application/water_controller.dart';
import '../domain/water_log.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWater = ref.watch(todayWaterProvider);
    final goal = 8; // Default goal - glasses

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWaterProgressCard(todayWater, goal),
            const SizedBox(height: 24),
            _buildQuickAddButtons(ref, goal),
            const SizedBox(height: 24),
            _buildHydrationTips(),
            const SizedBox(height: 24),
            _buildTodayLog(todayWater),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterProgressCard(AsyncValue<WaterLog?> todayWater, int goal) {
    return todayWater.when(
      data: (data) {
        final current = data?.glasses ?? 0;
        final percentage = (current / goal).clamp(0.0, 1.0);
        
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.cyan, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$current',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of $goal glasses',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (current >= goal)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Goal reached! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '${goal - current} more glasses to reach your goal',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading water data')),
    );
  }

  Widget _buildQuickAddButtons(WidgetRef ref, int goal) {
    final waterController = ref.read(waterLogControllerProvider.notifier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAddButton(
              icon: Icons.local_drink,
              label: 'Glass',
              sublabel: '250ml',
              onTap: () => waterController.addWater(1),
              color: Colors.cyan,
            ),
            _buildAddButton(
              icon: Icons.water_drop,
              label: 'Bottle',
              sublabel: '500ml',
              onTap: () => waterController.addWater(2),
              color: Colors.blue,
            ),
            _buildAddButton(
              icon: Icons.coffee,
              label: 'Chai',
              sublabel: '150ml',
              onTap: () => waterController.addWater(1),
              color: Colors.brown,
            ),
            _buildAddButton(
              icon: Icons.add_circle,
              label: 'Custom',
              sublabel: '',
              onTap: () => _showCustomAmountDialog(ref),
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (sublabel.isNotEmpty)
            Text(
              sublabel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHydrationTips() {
    final tips = [
      '💧 Drink a glass of water first thing in the morning',
      '🌿 Add lemon or mint for natural flavor',
      '🚫 Avoid drinking water with meals - wait 30 mins',
      '🍉 Eat water-rich foods like cucumber and watermelon',
      '⏰ Set regular intervals to drink water',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Hydration Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(tip, style: const TextStyle(fontSize: 13)),
          )),
        ],
      ),
    );
  }

  Widget _buildTodayLog(AsyncValue<WaterLog?> todayWater) {
    return todayWater.when(
      data: (data) {
        final logs = data?.entries ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (logs.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'No water logged yet today.\nTap the buttons above to log!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...logs.take(5).map((log) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.cyan, size: 20),
                    const SizedBox(width: 12),
                    Text('${log.amountMl} ml'),
                    const Spacer(),
                    Text(
                      _formatTime(log.time),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showCustomAmountDialog(WidgetRef ref) {
    // This would show a dialog - for now we'll skip implementation
    // In a real app, you'd show a modal bottom sheet with amount selector
  }
}
