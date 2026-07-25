/// §P12-C Wedding Transformation Mode UI Screen
///
/// Route: `/wedding/dashboard`
/// Festive glassmorphic UI (`0xFF0F172A`) featuring dynamic countdown timer,
/// phase progression indicators, skin glow nutrition targets, and prep checklist.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wedding_notifier.dart';
import 'wedding_program_generator.dart';

class WeddingDashboardScreen extends ConsumerWidget {
  const WeddingDashboardScreen({super.key});

  static const routeName = '/wedding/dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weddingTransformationProvider);
    final notifier = ref.read(weddingTransformationProvider.notifier);
    final plan = state.programPlan;

    ref.listen<WeddingTransformationState>(weddingTransformationProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFFE11D48),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '💍 Wedding Prep Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: Color(0xFFF43F5E)),
            onPressed: () => _selectWeddingDate(context, state.weddingDate, notifier),
            tooltip: 'Set Wedding Date',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Dynamic Countdown UI Banner Card
            _buildCountdownCard(context, state, plan, notifier),
            const SizedBox(height: 20),

            // 2. Phase Badge & Target Macros Grid
            _buildPhaseAndMacrosCard(plan),
            const SizedBox(height: 20),

            // 3. Skin Glow Superfoods Section
            _buildSkinGlowSection(plan),
            const SizedBox(height: 20),

            // 4. Daily Wedding Transformation Checklist
            Row(
              children: [
                const Text(
                  '📋 Daily Wedding Prep Checklist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.completedChecklistCount}/${state.checklist.length} Done',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.checklist.map((item) => _buildChecktile(item, notifier)),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard(
    BuildContext context,
    WeddingTransformationState state,
    WeddingProgramPlan plan,
    WeddingTransformationNotifier notifier,
  ) {
    final dateStr = state.weddingDate.toLocal().toString().substring(0, 10);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF881337), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨ ', style: TextStyle(fontSize: 18)),
              Text(
                '${state.daysRemaining}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 54,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAYS',
                    style: TextStyle(
                      color: Color(0xFFFDA4AF),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'UNTIL THE BIG DAY 💍',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar across 90-day phase journey
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: ((90 - state.daysRemaining).clamp(0, 90) / 90.0),
              backgroundColor: Colors.black26,
              color: const Color(0xFFF43F5E),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Target Date: $dateStr',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _selectWeddingDate(context, state.weddingDate, notifier),
                child: const Text(
                  'Change Date ✏️',
                  style: TextStyle(
                    color: Color(0xFFFDA4AF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseAndMacrosCard(WeddingProgramPlan plan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.4)),
            ),
            child: Text(
              plan.phaseName,
              style: const TextStyle(
                color: Color(0xFFFDA4AF),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _macroTile('Calories', '${plan.dailyCalorieTarget} kcal', const Color(0xFF38BDF8)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroTile('Protein', '${plan.dailyProteinG}g', const Color(0xFF22C55E)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroTile('Hydration', '${plan.dailyHydrationL}L', const Color(0xFF818CF8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSkinGlowSection(WeddingProgramPlan plan) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: Color(0xFFF43F5E), size: 20),
              SizedBox(width: 8),
              Text(
                'Skin Glow & Radiance Protocol',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: plan.skinGlowNutrients
                .map((n) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        n,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChecktile(
    WeddingChecklistItem item,
    WeddingTransformationNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _buildGlassCard(
        child: InkWell(
          onTap: () => notifier.toggleCheckitem(item.id),
          child: Row(
            children: [
              Checkbox(
                value: item.isCompleted,
                activeColor: const Color(0xFFF43F5E),
                onChanged: (_) => notifier.toggleCheckitem(item.id),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: item.isCompleted ? Colors.white38 : Colors.white,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  Future<void> _selectWeddingDate(
    BuildContext context,
    DateTime currentDate,
    WeddingTransformationNotifier notifier,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      notifier.updateWeddingDate(picked);
    }
  }
}
