import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../main.dart';
import '../../data/readiness_repository.dart';
import '../../domain/models/readiness_input.dart';
import '../../domain/models/readiness_result.dart';
import '../../domain/services/readiness_calculation_engine.dart';
import '../widgets/body_soreness_map.dart';

final readinessCalculationEngineProvider = Provider<ReadinessCalculationEngine>((ref) {
  return const ReadinessCalculationEngine();
});

final readinessRepositoryProvider = Provider<ReadinessRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  final engine = ref.watch(readinessCalculationEngineProvider);
  return ReadinessRepository(db: db, syncWorker: syncWorker, engine: engine);
});

class RecoveryLogScreen extends ConsumerStatefulWidget {
  final ValueChanged<ReadinessResult>? onReadinessComputed;

  const RecoveryLogScreen({super.key, this.onReadinessComputed});

  @override
  ConsumerState<RecoveryLogScreen> createState() => _RecoveryLogScreenState();
}

class _RecoveryLogScreenState extends ConsumerState<RecoveryLogScreen> {
  final Map<String, int> _sorenessMap = {'traps_neck': 2, 'quads': 3};
  double _sleepDuration = 7.5;
  int _perceivedEnergy = 4;
  int _perceivedStress = 2;
  bool _isSaving = false;

  void _toggleSoreness(String key, int severity) {
    setState(() {
      if (severity == 0) {
        _sorenessMap.remove(key);
      } else {
        _sorenessMap[key] = severity;
      }
    });
  }

  Future<void> _submitMorningCheckIn() async {
    setState(() => _isSaving = true);

    final List<MuscleSorenessEntry> sorenessList = _sorenessMap.entries
        .map((e) => MuscleSorenessEntry(muscleGroup: e.key, severity: e.value))
        .toList();

    final input = ReadinessInput(
      sleepDurationHours: _sleepDuration,
      sleepTargetHours: 8.0,
      perceivedEnergy: _perceivedEnergy,
      perceivedStress: _perceivedStress,
      sorenessList: sorenessList,
    );

    final repo = ref.read(readinessRepositoryProvider);
    final result = await repo.calculateAndSaveReadiness(
      userId: 'local-user-demo-1',
      input: input,
      chronologicalAge: 27,
    );

    setState(() => _isSaving = false);

    if (widget.onReadinessComputed != null) {
      widget.onReadinessComputed!(result);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Readiness updated: ${result.score} (${result.stateTitle})'),
            backgroundColor: result.stateColor.withAlpha(200),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          english: 'Morning Recovery Ritual',
          hindi: 'दैनिक रिकवरी चेक-इन',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Sleep Duration Slider Bento
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        english: 'Last Night Sleep Duration',
                        hindi: 'बीती रात की नींद',
                      ),
                      Text(
                        '${_sleepDuration.toStringAsFixed(1)} hrs',
                        style: AppTypography.h3.copyWith(color: AppColors.primaryCyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: _sleepDuration,
                    min: 3.0,
                    max: 12.0,
                    divisions: 18,
                    activeColor: AppColors.primaryCyan,
                    inactiveColor: AppColors.surfaceDark,
                    onChanged: (val) => setState(() => _sleepDuration = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Perceived Energy & Stress Bento
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        english: 'Waking Energy Level',
                        hindi: 'सुबह उठने पर ऊर्जा',
                      ),
                      Text('$_perceivedEnergy / 5', style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      final val = index + 1;
                      final isSelected = _perceivedEnergy == val;
                      return ChoiceChip(
                        label: Text('$val ⚡'),
                        selected: isSelected,
                        selectedColor: AppColors.primaryEmerald,
                        onSelected: (_) => setState(() => _perceivedEnergy = val),
                      );
                    }),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        english: 'Mental Stress / Fatigue',
                        hindi: 'मानसिक तनाव / थकान',
                      ),
                      Text('$_perceivedStress / 5', style: AppTypography.h3.copyWith(color: AppColors.accentCoral)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      final val = index + 1;
                      final isSelected = _perceivedStress == val;
                      return ChoiceChip(
                        label: Text('$val 🧠'),
                        selected: isSelected,
                        selectedColor: AppColors.accentCoral,
                        onSelected: (_) => setState(() => _perceivedStress = val),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Body Soreness Map Bento
            BentoCard(
              child: BodySorenessMap(
                sorenessMap: _sorenessMap,
                onSorenessToggled: _toggleSoreness,
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSaving ? null : _submitMorningCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: AppColors.background)
                  : Text(
                      'Compute Readiness Score  •  स्कोर गणना करें',
                      style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
