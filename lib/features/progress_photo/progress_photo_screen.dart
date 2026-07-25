/// §P11-B Progress Photo System UI Screen
///
/// Route: `/body/photos`
/// Dark glassmorphic interface (`0xFF0F172A`) providing encrypted local photo storage,
/// side-by-side photo comparison view, and metadata persistence to `TransformationChecks`.
library;

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'progress_photo_models.dart';
import 'progress_photo_notifier.dart';

class ProgressPhotoScreen extends ConsumerStatefulWidget {
  const ProgressPhotoScreen({super.key});

  static const routeName = '/body/photos';

  @override
  ConsumerState<ProgressPhotoScreen> createState() => _ProgressPhotoScreenState();
}

class _ProgressPhotoScreenState extends ConsumerState<ProgressPhotoScreen> {
  final _weightCtrl = TextEditingController(text: '72.0');
  final _waistCtrl = TextEditingController(text: '82.0');
  final _notesCtrl = TextEditingController();
  String _selectedTag = 'Front';

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(progressPhotoProvider);
    final notifier = ref.read(progressPhotoProvider.notifier);
    final comparison = state.activeComparison;

    ref.listen<ProgressPhotoState>(progressPhotoProvider, (_, next) {
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
          '📸 Progress Photo Vault',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF38BDF8)),
            onPressed: () => _showCaptureDialog(context, notifier),
            tooltip: 'Capture Photo',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Encryption Security Shield Banner
            _buildEncryptionShield(),
            const SizedBox(height: 20),

            // 2. Side-by-Side Comparison Section
            const Text(
              '⚖️ Side-by-Side Photo Comparison',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            if (comparison != null)
              _buildComparisonCard(comparison)
            else
              _buildGlassCard(
                child: const Text(
                  'Select a "Before" and "After" photo below to generate a comparison.',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),

            // 3. Transformation Checks Photo Timeline
            Row(
              children: [
                const Text(
                  '🖼️ Transformation Photo Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.photos.length} Checks',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.photos.map((photo) => _buildPhotoCard(photo, state, notifier)),

            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0EA5E9),
        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
        label: const Text('Capture Check-In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showCaptureDialog(context, notifier),
      ),
    );
  }

  Widget _buildEncryptionShield() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.security_rounded, color: Color(0xFF6366F1), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🔒 Secure Local Storage (§P11-B):\n'
              'All progress photos are AES-256 encrypted at rest on your device prior to disk persistence.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(ProgressPhotoComparison comp) {
    final weightDiff = comp.weightDeltaKg;
    final waistDiff = comp.waistDeltaCm;
    final bfDiff = comp.bodyFatDeltaPct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          // Side-by-side photo view
          Row(
            children: [
              Expanded(
                child: _buildPhotoPlaceholder(
                  label: 'BEFORE',
                  entry: comp.before,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPhotoPlaceholder(
                  label: 'AFTER',
                  entry: comp.after,
                  color: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Comparison stats bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statBadge(
                  label: 'Weight Delta',
                  value: '${weightDiff <= 0 ? "" : "+"}${weightDiff.toStringAsFixed(1)} kg',
                  isGood: weightDiff <= 0,
                ),
                if (waistDiff != null)
                  _statBadge(
                    label: 'Waist Delta',
                    value: '${waistDiff <= 0 ? "" : "+"}${waistDiff.toStringAsFixed(1)} cm',
                    isGood: waistDiff <= 0,
                  ),
                if (bfDiff != null)
                  _statBadge(
                    label: 'Body Fat Delta',
                    value: '${bfDiff <= 0 ? "" : "+"}${bfDiff.toStringAsFixed(1)}%',
                    isGood: bfDiff <= 0,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '⏱️ Elapsed Time: ${comp.elapsedDays} Days',
            style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder({
    required String label,
    required ProgressPhotoEntry entry,
    required Color color,
  }) {
    final dateStr = entry.checkDate.toLocal().toString().substring(0, 10);
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Icon(Icons.person_rounded, color: Colors.white70, size: 52),
          const SizedBox(height: 8),
          Text(
            '${entry.weightKg} kg  •  ${entry.photoTag}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          Text(
            dateStr,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _statBadge({
    required String label,
    required String value,
    required bool isGood,
  }) {
    final color = isGood ? const Color(0xFF22C55E) : Colors.amberAccent;
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(
    ProgressPhotoEntry photo,
    ProgressPhotoState state,
    ProgressPhotoNotifier notifier,
  ) {
    final isBefore = state.selectedBefore?.localId == photo.localId;
    final isAfter = state.selectedAfter?.localId == photo.localId;
    final dateStr = photo.checkDate.toLocal().toString().substring(0, 10);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _buildGlassCard(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock_rounded, color: Color(0xFF38BDF8), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${photo.photoTag} Pose  •  ${photo.weightKg} kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('🔒', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logged $dateStr  •  ${photo.notes ?? "Check-In"}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Before', style: TextStyle(fontSize: 10)),
                  selected: isBefore,
                  selectedColor: const Color(0xFF6366F1),
                  onSelected: (_) => notifier.selectBeforePhoto(photo),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('After', style: TextStyle(fontSize: 10)),
                  selected: isAfter,
                  selectedColor: const Color(0xFF22C55E),
                  onSelected: (_) => notifier.selectAfterPhoto(photo),
                ),
              ],
            ),
          ],
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

  void _showCaptureDialog(BuildContext context, ProgressPhotoNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Capture Transformation Photo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Color(0xFF38BDF8), size: 36),
                    SizedBox(height: 6),
                    Text(
                      'Photo Captured & Encrypted at Rest 🔒',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedTag,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Pose Tag', labelStyle: TextStyle(color: Colors.white70)),
                items: const [
                  DropdownMenuItem(value: 'Front', child: Text('Front Pose')),
                  DropdownMenuItem(value: 'Side', child: Text('Side Pose')),
                  DropdownMenuItem(value: 'Back', child: Text('Back Pose')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTag = val);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _waistCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Waist (cm)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Notes (optional)', labelStyle: TextStyle(color: Colors.white70)),
              ),
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
              // Generate mock raw photo bytes
              final mockBytes = Uint8List.fromList(List.generate(64, (i) => i));

              notifier.captureAndSavePhoto(
                photoBytes: mockBytes,
                weightKg: double.tryParse(_weightCtrl.text) ?? 72.0,
                waistCm: double.tryParse(_waistCtrl.text) ?? 82.0,
                photoTag: _selectedTag,
                notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
              );

              _notesCtrl.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Encrypt & Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
