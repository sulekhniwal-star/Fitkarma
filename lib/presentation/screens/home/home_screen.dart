import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/auth/auth_bloc.dart';
import '../../../core/constants/app_colors.dart';

import 'package:fit_karma/core/di/injection_container.dart';
import 'package:fit_karma/presentation/providers/fitness/steps_bloc.dart';
import 'package:fit_karma/presentation/providers/food/food_bloc.dart';
import 'package:fit_karma/presentation/screens/food/food_search_screen.dart';
import 'package:fit_karma/presentation/providers/medical/medical_report_bloc.dart';
import 'package:fit_karma/presentation/screens/medical/medical_report_screen.dart';
import 'package:fit_karma/presentation/providers/workout/workout_bloc.dart';
import 'package:fit_karma/presentation/screens/workout/workout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as Authenticated).user;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StepsBloc(repository: sl(), userId: user.id)
                ..add(StartStepTracking()),
        ),
        BlocProvider(
          create: (context) =>
              FoodBloc(repository: sl())..add(GetFoodLogsRequested(user.id)),
        ),
        BlocProvider(
          create: (context) =>
              WorkoutBloc(repository: sl())..add(GetWorkoutsRequested(user.id)),
        ),
        BlocProvider(
          create: (context) =>
              MedicalReportBloc(repository: sl())
                ..add(GetReportsRequested(user.id)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FitKarma Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, ${user.name ?? 'Friend'}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Step Tracking Card
              BlocBuilder<StepsBloc, StepsState>(
                builder: (context, state) {
                  int steps = 0;
                  bool isTracking = false;

                  if (state is StepsTracking) {
                    steps = state.todaySteps;
                    isTracking = true;
                  }

                  return Card(
                    color: AppColors.saffron.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_walk,
                            size: 40,
                            color: AppColors.saffron,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$steps',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.saffron,
                                    ),
                              ),
                              const Text('Steps Today'),
                            ],
                          ),
                          const Spacer(),
                          if (isTracking)
                            const Icon(
                              Icons.sync,
                              color: AppColors.indianGreen,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.restaurant,
                      label: 'Food',
                      color: AppColors.indianGreen,
                      onTap: (ctx) {
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: ctx.read<FoodBloc>(),
                              child: const FoodSearchScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.fitness_center,
                      label: 'Workout',
                      color: AppColors.saffron,
                      onTap: (ctx) {
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: ctx.read<WorkoutBloc>(),
                              child: const WorkoutScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.medical_services,
                      label: 'Reports',
                      color: Colors.blue,
                      onTap: (ctx) {
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: ctx.read<MedicalReportBloc>(),
                              child: const MedicalReportScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Food Logging Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Food Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<FoodBloc, FoodState>(
                        builder: (context, state) {
                          if (state is FoodLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is FoodLogsSuccess) {
                            if (state.logs.isEmpty) {
                              return const Text('No food logged today');
                            }
                            double totalCals = state.logs.fold(
                              0,
                              (sum, log) => sum + log.calories,
                            );
                            return Text(
                              'Total Calories: ${totalCals.toStringAsFixed(0)} kcal',
                            );
                          }
                          return const Text('Start logging your meals!');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Workout Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Workouts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<WorkoutBloc, WorkoutState>(
                        builder: (context, state) {
                          if (state is WorkoutLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is WorkoutsLoaded) {
                            if (state.workouts.isEmpty) {
                              return const Text('No workouts logged recently');
                            }
                            return Column(
                              children: state.workouts
                                  .take(2)
                                  .map(
                                    (w) => ListTile(
                                      dense: true,
                                      title: Text(w.title),
                                      subtitle: Text(
                                        '${w.durationMinutes} mins',
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: AppColors.indianGreen,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          }
                          return const Text('Time to hit the gym!');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Karma Points: 0', // Placeholder
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              const Text('Keep moving to earn more Karma points!'),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function(BuildContext) onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
