/// §P12-F Smart Calendar Sync Settings & Analysis Preview UI Screen
///
/// Route: `/calendar/sync`
/// Glassmorphic UI (`0xFF0F172A`) providing device calendar sync toggles (Google, Outlook, Apple),
/// auto-adaptation switches, and live daily meeting schedule analysis preview matching §P12-F spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calendar_controller.dart';
import 'calendar_models.dart';

class CalendarSyncScreen extends ConsumerWidget {
  const CalendarSyncScreen({super.key});

  static const routeName = '/calendar/sync';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final insight = state.insight;

    ref.listen<CalendarState>(calendarProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF0EA5E9),
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
          '📅 Smart Calendar Sync',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Calendar Sync Connections Box
            const Text(
              '🔗 Connected Calendar Accounts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildSyncAccountCard(
              title: 'Google Calendar',
              subtitle: 'Google Workspace / Gmail Sync',
              icon: Icons.g_mobiledata_rounded,
              iconColor: const Color(0xFF4285F4),
              value: state.isGoogleSynced,
              onChanged: (val) => notifier.toggleSource(CalendarSource.google, val),
            ),
            const SizedBox(height: 8),
            _buildSyncAccountCard(
              title: 'Microsoft Outlook',
              subtitle: 'Office 365 / Outlook Sync',
              icon: Icons.mark_email_unread_rounded,
              iconColor: const Color(0xFF0078D4),
              value: state.isOutlookSynced,
              onChanged: (val) => notifier.toggleSource(CalendarSource.outlook, val),
            ),
            const SizedBox(height: 8),
            _buildSyncAccountCard(
              title: 'Apple / Device Calendar',
              subtitle: 'Local Device Calendar API',
              icon: Icons.calendar_month_rounded,
              iconColor: const Color(0xFFA259FF),
              value: state.isAppleSynced,
              onChanged: (val) => notifier.toggleSource(CalendarSource.apple, val),
            ),
            const SizedBox(height: 20),

            // 2. Calendar Auto-Adaptation Toggle
            _buildAutoAdaptationCard(state, notifier),
            const SizedBox(height: 24),

            // 3. Live Day Calendar Analysis Preview Card
            const Text(
              '📊 Today\'s Calendar Analysis & Adaptation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildAnalysisPreviewCard(insight),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncAccountCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildGlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF0EA5E9),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAdaptationCard(CalendarState state, CalendarNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_mode_rounded, color: Color(0xFF38BDF8), size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto-Shorten Workouts on Heavy Days',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  'Automatically recommends 20-min express sessions on heavy meeting days (>5 hrs).',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: state.isAutoAdaptationEnabled,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (val) => notifier.toggleAutoAdaptation(val),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisPreviewCard(DayCalendarInsight insight) {
    final meetingHrs = insight.meetingHours.toStringAsFixed(1);
    final isBusy = insight.isBusyDay;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBusy ? const Color(0xFFF97316) : const Color(0xFF22C55E).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '⏱️ $meetingHrs hrs Meetings',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isBusy ? const Color(0xFFF97316).withValues(alpha: 0.15) : const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBusy ? const Color(0xFFF97316) : const Color(0xFF22C55E),
                  ),
                ),
                child: Text(
                  isBusy ? '💼 HEAVY SCHEDULE' : '✅ BALANCED',
                  style: TextStyle(
                    color: isBusy ? const Color(0xFFF97316) : const Color(0xFF22C55E),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Workout Recommendation
          _sectionTitle('🏋️ Recommended Workout Adaptation'),
          const SizedBox(height: 4),
          Text(
            insight.workoutRecommendation.type,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            insight.workoutRecommendation.rationale,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Nutrition Strategy
          _sectionTitle('🥗 Nutrition Strategy'),
          const SizedBox(height: 4),
          Text(
            insight.nutritionNote,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Scheduling Suggestions
          _sectionTitle('💡 Smart Scheduling Suggestions'),
          const SizedBox(height: 6),
          ...insight.schedulingSuggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                  Expanded(child: Text(s, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w700, fontSize: 12),
      );

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
}
