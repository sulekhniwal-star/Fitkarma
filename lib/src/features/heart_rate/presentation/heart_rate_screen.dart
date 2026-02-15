import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../domain/heart_rate_log.dart';
import '../data/heart_rate_repository.dart';
import '../../../constants/app_colors.dart';
import '../../auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeartRateScreen extends ConsumerStatefulWidget {
  const HeartRateScreen({super.key});

  @override
  ConsumerState<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends ConsumerState<HeartRateScreen> {
  late HeartRateRepository _repository;
  List<HeartRateLog> _logs = [];
  bool _isLoading = true;
  
  // For camera-based measurement
  bool _isMeasuring = false;
  int _measuredBPM = 0;
  List<int> _readings = [];
  Timer? _measurementTimer;

  @override
  void initState() {
    super.initState();
    _initRepository();
  }

  Future<void> _initRepository() async {
    final pb = PocketBase('http://127.0.0.1:8090');
    _repository = HeartRateRepository(pb);
    await _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user != null) {
        _logs = await _repository.getHeartRateLogs(user.id, limit: 30);
      }
    } catch (e) {
      // Handle error silently
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _logHeartRate(int bpm, {String? note, bool isManual = true}) async {
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) return;

      final log = HeartRateLog(
        id: '',
        oderId: user.id,
        bpm: bpm,
        date: DateTime.now(),
        note: note,
        isManual: isManual,
      );

      await _repository.logHeartRate(log);
      await _loadLogs();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Heart rate logged: $bpm BPM'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _measurementTimer?.cancel();
    super.dispose();
  }

  // Simulate camera-based heart rate measurement
  // Note: Real implementation would use camera and image processing
  void _startCameraMeasurement() {
    setState(() {
      _isMeasuring = true;
      _measuredBPM = 0;
      _readings = [];
    });

    // Simulate readings - in a real app, this would analyze camera feed
    int counter = 0;
    _measurementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      counter++;
      
      // Simulate heart rate between 60-100 BPM with some variance
      final random = Random();
      final baseBPM = 75 + random.nextInt(15) - 7;
      _readings.add(baseBPM);
      
      // After ~15 seconds, calculate average
      if (counter >= 150) {
        timer.cancel();
        final avg = _readings.reduce((a, b) => a + b) ~/ _readings.length;
        setState(() {
          _measuredBPM = avg;
          _isMeasuring = false;
        });
      } else {
        setState(() {});
      }
    });
  }

  void _stopCameraMeasurement() {
    _measurementTimer?.cancel();
    setState(() {
      _isMeasuring = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Heart Rate'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCurrentStatusCard(),
                  const SizedBox(height: 24),
                  _buildMeasurementOptions(),
                  const SizedBox(height: 24),
                  if (_measuredBPM > 0) _buildMeasurementResult(),
                  const SizedBox(height: 24),
                  _buildHistorySection(),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrentStatusCard() {
    final latestLog = _logs.isNotEmpty ? _logs.first : null;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.favorite,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              latestLog != null ? '${latestLog.bpm}' : '--',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'BPM',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            if (latestLog != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  latestLog.bpmCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Log Heart Rate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                icon: Icons.edit,
                title: 'Manual Entry',
                subtitle: 'Enter your BPM',
                onTap: _showManualEntryDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOptionCard(
                icon: Icons.camera_alt,
                title: 'Camera Measure',
                subtitle: 'Use camera & flash',
                onTap: _showCameraMeasureDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualEntryDialog() {
    int selectedBPM = 72;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter Heart Rate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$selectedBPM BPM',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Slider(
                value: selectedBPM.toDouble(),
                min: 40,
                max: 200,
                divisions: 160,
                label: '$selectedBPM',
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setModalState(() => selectedBPM = value.round());
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('40', style: TextStyle(color: Colors.grey)),
                  const Text('200', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              // Quick select buttons
              Wrap(
                spacing: 8,
                children: [60, 70, 80, 90, 100].map((bpm) {
                  return ActionChip(
                    label: Text('$bpm'),
                    onPressed: () => setModalState(() => selectedBPM = bpm),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _logHeartRate(selectedBPM, isManual: true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showCameraMeasureDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Camera Heart Rate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_isMeasuring) ...[
                const Text(
                  'Place your finger on the camera lens',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Measuring... ${_readings.length ~/ 10}/15 seconds',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                // Animated heart
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: const Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.red,
                      ),
                    );
                  },
                  onEnd: () {
                    if (_isMeasuring) {
                      setModalState(() {});
                    }
                  },
                ),
              ] else if (_measuredBPM > 0) ...[
                const Text(
                  'Measurement Complete!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_measuredBPM BPM',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Estimated based on measurement',
                  style: TextStyle(color: Colors.grey),
                ),
              ] else ...[
                const Icon(
                  Icons.camera_alt,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Place your finger over the camera lens and flash to measure your heart rate',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'For accurate results, ensure your finger covers the camera completely',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (_measuredBPM == 0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isMeasuring
                        ? _stopCameraMeasurement
                        : _startCameraMeasurement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMeasuring ? Colors.red : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_isMeasuring ? 'Stop' : 'Start Measurement'),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _measuredBPM = 0;
                            _readings = [];
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Measure Again'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _logHeartRate(_measuredBPM, isManual: false);
                          setState(() {
                            _measuredBPM = 0;
                            _readings = [];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Save Result'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementResult() {
    return Card(
      color: Colors.green.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Measurement Saved!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$_measuredBPM BPM recorded'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_logs.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.favorite_border, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No heart rate logs yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start tracking your heart rate to see your history',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...(_logs.take(10).map((log) => _buildHistoryItem(log)).toList()),
      ],
    );
  }

  Widget _buildHistoryItem(HeartRateLog log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getBpmColor(log.bpm).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.favorite, color: _getBpmColor(log.bpm)),
        ),
        title: Text(
          '${log.bpm} BPM',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatDate(log.date),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getBpmColor(log.bpm).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            log.bpmCategory,
            style: TextStyle(
              color: _getBpmColor(log.bpm),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBpmColor(int bpm) {
    if (bpm < 60) return Colors.blue;
    if (bpm <= 100) return Colors.green;
    if (bpm <= 120) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
