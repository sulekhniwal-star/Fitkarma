import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/life_events_engine.dart';
import '../providers/life_events_provider.dart';

/// §P12-B Life Events Engine Selector & Adaptation Screen
/// Route: /lifestyle/events
class LifeEventsScreen extends ConsumerWidget {
  const LifeEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(lifeEventsProvider);
    final primary = eventState.primaryEvent;
    final adapt = eventState.activeAdaptation;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Life Events Engine 🌟', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Event Banner
              if (primary != null)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available, color: AppColors.teal, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ACTIVE LIFE EVENT', style: AppTypography.labelSmall.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold)),
                            Text(primary.title, style: AppTypography.h3),
                            Text('DIP Priority: ${adapt.DIPPriority}', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                        onPressed: () {
                          ref.read(lifeEventsProvider.notifier).clearPrimaryEvent();
                        },
                      ),
                    ],
                  ),
                ),

              // Cross-Module Target Adjustments BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Module Adaptations', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),

                    _EventRow(icon: Icons.timer, label: 'Max Workout', value: '${adapt.workoutDurationMins} mins/day (${adapt.workoutFocus})'),
                    _EventRow(icon: Icons.healing, label: 'Recovery Focus', value: adapt.isRecoveryFirst ? 'High (Recovery First)' : 'Standard progression'),
                    _EventRow(icon: Icons.restaurant, label: 'Nutrition Mode', value: adapt.simplifyNutrition ? 'Quick & Low Friction' : 'Standard tracking'),
                    _EventRow(icon: Icons.local_fire_department, label: 'Calorie Buffer', value: '${adapt.calorieBuffer >= 0 ? '+' : ''}${adapt.calorieBuffer} kcal'),
                    _EventRow(icon: Icons.water_drop, label: 'Hydration Target', value: '${adapt.hydrationMultiplier}x baseline'),
                    _EventRow(icon: Icons.bedtime, label: 'Sleep Strategy', value: adapt.sleepStrategy),
                    _EventRow(icon: Icons.psychology, label: 'Coach Tone', value: adapt.coachTone),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Life Event Type Selector Grid
              Text('Select Active Life Event', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              _LifeEventTile(
                title: 'Work / Office Deadline 💼',
                subtitle: '15-min quick workouts & stress management',
                onTap: () {
                  ref.read(lifeEventsProvider.notifier).setPrimaryEvent(
                    LifeEvent(id: 'le_deadline', title: 'Office Deadline', type: LifeEventType.officeDeadline, startDate: DateTime.now()),
                  );
                },
              ),
              _LifeEventTile(
                title: 'New Baby / Parenting 👶',
                subtitle: 'Polyphasic sleep support & home workouts',
                onTap: () {
                  ref.read(lifeEventsProvider.notifier).setPrimaryEvent(
                    LifeEvent(id: 'le_baby', title: 'New Baby', type: LifeEventType.newBaby, startDate: DateTime.now()),
                  );
                },
              ),
              _LifeEventTile(
                title: 'Injury Recovery 🩹',
                subtitle: 'Isolation workouts & healing nutrition',
                onTap: () {
                  ref.read(lifeEventsProvider.notifier).setPrimaryEvent(
                    LifeEvent(id: 'le_injury', title: 'Knee Injury Recovery', type: LifeEventType.injury, startDate: DateTime.now(), injuredRegion: 'Knee'),
                  );
                },
              ),
              _LifeEventTile(
                title: 'International Travel ✈️',
                subtitle: 'Jet lag hydration & hotel room circuits',
                onTap: () {
                  ref.read(lifeEventsProvider.notifier).setPrimaryEvent(
                    LifeEvent(id: 'le_travel', title: 'Travel to London', type: LifeEventType.travelAbroad, startDate: DateTime.now(), timezone: 'BST'),
                  );
                },
              ),
              _LifeEventTile(
                title: 'Exam Season 📚',
                subtitle: 'Cognitive energy focus & memory sleep cutoff',
                onTap: () {
                  ref.read(lifeEventsProvider.notifier).setPrimaryEvent(
                    LifeEvent(id: 'le_exam', title: 'Final Exams', type: LifeEventType.examSeason, startDate: DateTime.now()),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _EventRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.teal),
          const SizedBox(width: 10),
          SizedBox(width: 110, child: Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: AppTypography.labelLg)),
        ],
      ),
    );
  }
}

class _LifeEventTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LifeEventTile({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: AppTypography.labelLg),
            subtitle: Text(subtitle, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
