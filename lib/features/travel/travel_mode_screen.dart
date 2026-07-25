/// §P12-E Travel Mode UI Screen
///
/// Route: `/travel/dashboard`
/// Glassmorphic UI (`0xFF0F172A`) rendering active travel adaptations,
/// hotel bodyweight workouts, nutrition buffers, and jet lag protocols.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'travel_controller.dart';
import 'travel_models.dart';

class TravelModeScreen extends ConsumerStatefulWidget {
  const TravelModeScreen({super.key});

  static const routeName = '/travel/dashboard';

  @override
  ConsumerState<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends ConsumerState<TravelModeScreen> {
  final _originCtrl = TextEditingController(text: 'Delhi');
  final _destCtrl = TextEditingController(text: 'London');

  @override
  void dispose() {
    _originCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(travelProvider);
    final notifier = ref.read(travelProvider.notifier);
    final adaptation = state.adaptation;
    final ctx = state.activeContext;

    ref.listen<TravelState>(travelProvider, (_, next) {
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
          '✈️ Travel Intelligence Mode',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flight_takeoff_rounded, color: Color(0xFF38BDF8)),
            onPressed: () => _showActivateDialog(context, notifier),
            tooltip: 'Log Travel',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Active Travel Mode Status Banner
            if (state.isTravelModeActive && ctx != null)
              _buildTravelStatusBanner(ctx, notifier)
            else
              _buildInactiveBanner(context, notifier),
            const SizedBox(height: 20),

            // 2. Travel Adaptation Details
            if (adaptation != null) ...[
              const Text(
                '🎯 Adapted Travel Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              _buildAdaptationCard(adaptation),
              const SizedBox(height: 16),

              // Jet lag protocol card
              if (adaptation.jetLagProtocol != null)
                _buildJetLagCard(adaptation.jetLagProtocol!),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelStatusBanner(TravelContext ctx, TravelNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flight_takeoff_rounded, color: Color(0xFF38BDF8), size: 24),
              const SizedBox(width: 10),
              Text(
                '✈️ Travel Mode Active (${ctx.mode.name.toUpperCase()})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${ctx.origin} ➔ ${ctx.destination}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.flight_land_rounded, size: 16),
            label: const Text('End Travel Mode'),
            onPressed: () => notifier.endTravelMode(),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveBanner(BuildContext context, TravelNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏠 Home Location Active',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'Traveling soon? Activate Travel Mode to adapt workouts, nutrition buffers & jetlag schedules.',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
            icon: const Icon(Icons.flight, color: Colors.white, size: 18),
            label: const Text('Log Upcoming Travel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () => _showActivateDialog(context, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptationCard(TravelAdaptation adapt) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tile('🏋️ Workout', adapt.workoutTitle, adapt.workoutDetails),
          const Divider(color: Colors.white10),
          _tile('🥗 Nutrition', adapt.calorieBufferNote, adapt.nutritionStrategy),
          const Divider(color: Colors.white10),
          _tile('💧 Hydration', '${adapt.hydrationTargetL}L Target', 'Cabin & travel dehydration flush'),
          const Divider(color: Colors.white10),
          _tile('📊 Readiness Adjustment', '${adapt.readinessAdjustment}% Expectation', adapt.sleepNote),
        ],
      ),
    );
  }

  Widget _tile(String title, String subtitle, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 2),
          Text(description, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildJetLagCard(JetLagProtocol proto) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_rounded, color: Colors.amberAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                '🌍 ${proto.direction}bound Jetlag Protocol',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...proto.recommendations.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(r, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  void _showActivateDialog(BuildContext context, TravelNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Activate Travel Mode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _originCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Origin City/Country', labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _destCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Destination City/Country', labelStyle: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
            onPressed: () {
              final isIntl = _destCtrl.text.toLowerCase().contains('london') || _destCtrl.text.toLowerCase().contains('us') || _destCtrl.text.toLowerCase().contains('dubai');
              notifier.activateTravelMode(
                origin: _originCtrl.text.trim(),
                destination: _destCtrl.text.trim(),
                originOffsetMinutes: 330, // IST (+5:30)
                destinationOffsetMinutes: isIntl ? 0 : 330, // GMT (+0:00) vs IST
              );
              Navigator.pop(ctx);
            },
            child: const Text('Activate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
