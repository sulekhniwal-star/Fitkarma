/// §P11-A Body Analytics Screen
///
/// Route: `/body/analytics`
/// Glassmorphic UI (`0xFF0F172A`) rendering body circumference measurements,
/// WHR (Waist-to-Hip Ratio), Navy body fat % estimates, site-by-site trends,
/// and persisting entries to `BodyMeasurements` table matching §P11-A specification.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'body_analytics_models.dart';
import 'body_analytics_notifier.dart';

class BodyAnalyticsScreen extends ConsumerStatefulWidget {
  const BodyAnalyticsScreen({super.key});

  static const routeName = '/body/analytics';

  @override
  ConsumerState<BodyAnalyticsScreen> createState() => _BodyAnalyticsScreenState();
}

class _BodyAnalyticsScreenState extends ConsumerState<BodyAnalyticsScreen> {
  final _neckCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _bicepsCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _hipsCtrl = TextEditingController();
  final _thighCtrl = TextEditingController();
  final _calvesCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _neckCtrl.dispose();
    _chestCtrl.dispose();
    _bicepsCtrl.dispose();
    _waistCtrl.dispose();
    _hipsCtrl.dispose();
    _thighCtrl.dispose();
    _calvesCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bodyAnalyticsProvider);
    final notifier = ref.read(bodyAnalyticsProvider.notifier);
    final latest = state.latestEntry;
    final trends = state.trends;

    ref.listen<BodyAnalyticsState>(bodyAnalyticsProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF22C55E),
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
          '📐 Body Analytics & Trends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF38BDF8)),
            onPressed: () => _showAddMeasurementDialog(context, notifier),
            tooltip: 'Log Measurements',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Key Metrics Summary Card (WHR & Body Fat %)
            _buildKeyMetricsCard(latest),
            const SizedBox(height: 20),

            // 2. Add Measurement Action Button Card
            _buildActionCard(context, notifier),
            const SizedBox(height: 20),

            // 3. Circumference Trends Section
            const Text(
              '📊 Circumference Trends (vs Previous Log)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            if (trends.isEmpty)
              _buildGlassCard(
                child: const Text(
                  'Log at least 2 measurements to view site-by-site trends.',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              )
            else
              ...trends.map((t) => _buildTrendRow(t)),
            const SizedBox(height: 24),

            // 4. Measurement Log History
            const Text(
              '📜 Measurement History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            ...state.history.map((entry) => _buildHistoryCard(entry)),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsCard(BodyMeasurementEntry? entry) {
    final whr = entry?.waistToHipRatio;
    final whrCat = entry?.whrCategory ?? 'N/A';
    final bodyFat = entry?.estimatedBodyFatPct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color(0xFF38BDF8), size: 26),
              const SizedBox(width: 10),
              const Text(
                'Body Composition Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Waist-to-Hip Ratio',
                  value: whr != null ? whr.toStringAsFixed(2) : '—',
                  subtext: whrCat,
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  label: 'Est. Body Fat',
                  value: bodyFat != null ? '${bodyFat.toStringAsFixed(1)}%' : '—',
                  subtext: 'US Navy Method',
                  color: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subtext,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, BodyAnalyticsNotifier notifier) {
    return _buildGlassCard(
      child: Row(
        children: [
          const Icon(Icons.square_foot_rounded, color: Color(0xFF38BDF8), size: 28),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Body Circumferences',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Track waist, chest, biceps, hips, thigh & calves',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showAddMeasurementDialog(context, notifier),
            child: const Text('Log Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendRow(BodyMeasurementTrend trend) {
    final isMinus = trend.deltaCm < 0;
    final isZero = trend.deltaCm == 0;
    final deltaText = isZero
        ? '0.0 cm'
        : '${isMinus ? "" : "+"}${trend.deltaCm.toStringAsFixed(1)} cm';
    final badgeColor = isMinus
        ? const Color(0xFF22C55E)
        : isZero
            ? Colors.white54
            : Colors.amberAccent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _buildGlassCard(
        child: Row(
          children: [
            Text(
              trend.siteName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${trend.currentCm.toStringAsFixed(1)} cm',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
              ),
              child: Text(
                deltaText,
                style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BodyMeasurementEntry entry) {
    final dateStr = entry.logDate.toLocal().toString().substring(0, 10);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _buildGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '📅 $dateStr',
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                if (entry.weightKg != null)
                  Text(
                    '⚖️ ${entry.weightKg!.toStringAsFixed(1)} kg',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (entry.waistCm != null) _chip('Waist: ${entry.waistCm} cm'),
                if (entry.chestCm != null) _chip('Chest: ${entry.chestCm} cm'),
                if (entry.bicepsCm != null) _chip('Biceps: ${entry.bicepsCm} cm'),
                if (entry.hipsCm != null) _chip('Hips: ${entry.hipsCm} cm'),
                if (entry.thighCm != null) _chip('Thigh: ${entry.thighCm} cm'),
                if (entry.calvesCm != null) _chip('Calves: ${entry.calvesCm} cm'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      );

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

  void _showAddMeasurementDialog(BuildContext context, BodyAnalyticsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Log Body Measurements (cm)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _inputField('Neck (cm)', _neckCtrl),
              _inputField('Chest (cm)', _chestCtrl),
              _inputField('Biceps (cm)', _bicepsCtrl),
              _inputField('Waist (cm)', _waistCtrl),
              _inputField('Hips (cm)', _hipsCtrl),
              _inputField('Thigh (cm)', _thighCtrl),
              _inputField('Calves (cm)', _calvesCtrl),
              _inputField('Weight (kg)', _weightCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
            onPressed: () {
              final newEntry = BodyMeasurementEntry(
                localId: 'bm_${DateTime.now().millisecondsSinceEpoch}',
                userId: 'user_local_001',
                logDate: DateTime.now(),
                neckCm: double.tryParse(_neckCtrl.text),
                chestCm: double.tryParse(_chestCtrl.text),
                bicepsCm: double.tryParse(_bicepsCtrl.text),
                waistCm: double.tryParse(_waistCtrl.text),
                hipsCm: double.tryParse(_hipsCtrl.text),
                thighCm: double.tryParse(_thighCtrl.text),
                calvesCm: double.tryParse(_calvesCtrl.text),
                weightKg: double.tryParse(_weightCtrl.text),
              );

              notifier.addMeasurement(newEntry);

              _neckCtrl.clear();
              _chestCtrl.clear();
              _bicepsCtrl.clear();
              _waistCtrl.clear();
              _hipsCtrl.clear();
              _thighCtrl.clear();
              _calvesCtrl.clear();
              _weightCtrl.clear();

              Navigator.pop(ctx);
            },
            child: const Text('Save Log', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF38BDF8)),
          ),
        ),
      ),
    );
  }
}
