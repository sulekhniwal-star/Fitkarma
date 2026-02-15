import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../auth/application/auth_controller.dart';
import '../application/dosha_routine_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildKarmaCard(context, ref),
                const SizedBox(height: 24),
                _buildDoshaRoutineSection(context, ref),
                const SizedBox(height: 24),
                _buildHealthGrid(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 80), // Space for bottom nav
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    String subGreeting;

    if (hour < 12) {
      greeting = 'सुप्रभात'; // Good Morning
      subGreeting = 'Ready to earn Karma today?';
    } else if (hour < 17) {
      greeting = 'नमस्ते'; // Namaste
      subGreeting = 'Time for a quick wellness break?';
    } else {
      greeting = 'शुभ संध्या'; // Good Evening
      subGreeting = 'Finish the day mindfully!';
    }

    final userName = user?.fullName?.split(' ').first ?? 'Seeker';

    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        centerTitle: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $userName!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              user?.dosha != null
                  ? 'Your ${user!.dosha!.toUpperCase()} balance is key today'
                  : subGreeting,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.textPrimary),
          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.surface,
            radius: 18,
            child: Icon(
              Icons.person_outline,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKarmaCard(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final karma = user?.karmaPoints ?? 0;
    final streak = user?.streakDays ?? 0;

    return GestureDetector(
      onTap: () => context.pushNamed(AppRoute.karma.name),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.karmaGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Karma',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      karma.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'pts',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak Day Streak',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaRoutineSection(BuildContext context, WidgetRef ref) {
    final routineState = ref.watch(doshaRoutineControllerProvider);
    final user = ref.watch(authControllerProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended Routine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (user?.dosha != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user!.dosha!.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        routineState.when(
          data: (routines) {
            if (routines.isEmpty) {
              return _buildInspirationCard();
            }
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return _buildRoutineCard(routine);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _buildInspirationCard(),
        ),
      ],
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine) {
    final timeEmoji = switch (routine['time_of_day']) {
      'early_morning' => '🌅',
      'morning' => '☀️',
      'afternoon' => '🕛',
      'evening' => '🌆',
      'night' => '🌙',
      _ => '✨',
    };

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textHint.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(timeEmoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                routine['time_of_day']
                        ?.toString()
                        .replaceAll('_', ' ')
                        .toUpperCase() ??
                    '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            routine['activity'] ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            routine['description'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textHint.withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.spa, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Complete your Dosha quiz to see personalized daily routines!',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          context,
          title: 'Steps',
          value: '4,523',
          goal: '8,000',
          icon: Icons.directions_walk,
          color: Colors.blue,
          progress: 4523 / 8000,
        ),
        _buildMetricCard(
          context,
          title: 'Calories',
          value: '1,243',
          goal: '1,800',
          icon: Icons.restaurant,
          color: Colors.orange,
          progress: 1243 / 1800,
        ),
        _buildMetricCard(
          context,
          title: 'Water',
          value: '5/8',
          goal: 'glasses',
          icon: Icons.water_drop,
          color: Colors.cyan,
          progress: 5 / 8,
        ),
        _buildMetricCard(
          context,
          title: 'Workout',
          value: '15',
          goal: 'min done',
          icon: Icons.fitness_center,
          color: Colors.green,
          progress: 0.5,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String goal,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                goal,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(Icons.camera_alt_outlined, 'Log Meal', onTap: () => context.pushNamed(AppRoute.foodLog.name)),
        _buildActionItem(Icons.water_drop_outlined, 'Log Water', onTap: () => context.pushNamed(AppRoute.water.name)),
        _buildActionItem(Icons.fitness_center, 'Workouts', onTap: () => context.pushNamed(AppRoute.workout.name)),
        _buildActionItem(Icons.monitor_weight_outlined, 'Log Weight', onTap: () => context.pushNamed(AppRoute.weight.name)),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
