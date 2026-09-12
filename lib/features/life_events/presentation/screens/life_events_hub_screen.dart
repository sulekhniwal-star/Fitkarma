import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/life_events/domain/models/life_event_models.dart';
import 'package:fitkarma/features/life_events/domain/services/festival_intelligence_engine.dart';
import 'package:fitkarma/features/life_events/domain/services/ai_roast_engine.dart';
import 'package:fitkarma/features/life_events/presentation/screens/wedding_mode_screen.dart';
import 'package:fitkarma/features/life_events/presentation/screens/travel_mode_screen.dart';

class LifeEventsHubScreen extends ConsumerStatefulWidget {
  const LifeEventsHubScreen({super.key});

  @override
  ConsumerState<LifeEventsHubScreen> createState() => _LifeEventsHubScreenState();
}

class _LifeEventsHubScreenState extends ConsumerState<LifeEventsHubScreen> {
  final _festivalEngine = const FestivalIntelligenceEngine();
  final _roastEngine = const AIRoastEngine();

  int _selectedFestivalIndex = 0;
  RoastIntensity _roastIntensity = RoastIntensity.spicy;
  final String _roastTrigger = 'missed_steps';
  late AIRoastMessage _latestRoast;

  @override
  void initState() {
    super.initState();
    _generateRoast();
  }

  void _generateRoast() {
    setState(() {
      _latestRoast = _roastEngine.generateRoast(
        triggerType: _roastTrigger,
        intensity: _roastIntensity,
        userName: 'Rahul',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final protocols = _festivalEngine.getAllProtocols();
    final selectedProtocol = protocols[_selectedFestivalIndex.clamp(0, protocols.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Life Events & Festivals', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selectors (Wedding & Travel)
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeddingModeScreen()),
                      );
                    },
                    padding: const EdgeInsets.all(16),
                    glowColor: AppColors.accentCoral,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.favorite, color: AppColors.accentCoral, size: 28),
                        const SizedBox(height: 8),
                        Text('Shaadi Mode', style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text('Garment fit & 12w peaking plan', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TravelModeScreen()),
                      );
                    },
                    padding: const EdgeInsets.all(16),
                    glowColor: AppColors.primaryCyan,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.flight_takeoff, color: AppColors.primaryCyan, size: 28),
                        const SizedBox(height: 8),
                        Text('Travel Mode', style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text('Hotel HIIT & digestion shields', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // AI Roast Section
            Text('AI Coach Roast (Sharma Ji Ka AI)', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              glowColor: AppColors.accentCoral,
              isGlowing: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: AppColors.accentCoral),
                          const SizedBox(width: 8),
                          Text('Accountability Roast', style: AppTypography.h3),
                        ],
                      ),
                      DropdownButton<RoastIntensity>(
                        value: _roastIntensity,
                        dropdownColor: AppColors.surfaceCard,
                        underline: const SizedBox(),
                        items: RoastIntensity.values.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s.name.toUpperCase(), style: AppTypography.label),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _roastIntensity = val);
                            _generateRoast();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentCoral.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_latestRoast.headline, style: AppTypography.h3.copyWith(color: AppColors.accentCoral)),
                        const SizedBox(height: 6),
                        Text(_latestRoast.body, style: AppTypography.bodyMedium),
                        const SizedBox(height: 6),
                        Text(_latestRoast.bodyHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.accentAmber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Punchline: ${_latestRoast.punchline}',
                          style: AppTypography.label.copyWith(color: AppColors.accentAmber, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Festival Fasting & Feast Intelligence
            Text('Festival Protocols & Fasting Guidance', style: AppTypography.h2),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(protocols.length, (index) {
                  final item = protocols[index];
                  final isSelected = index == _selectedFestivalIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item.name.split(' ').first),
                      selected: isSelected,
                      selectedColor: AppColors.primaryEmerald,
                      backgroundColor: AppColors.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedFestivalIndex = index);
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedProtocol.name, style: AppTypography.h2),
                  Text(selectedProtocol.nameHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(selectedProtocol.seasonDescription, style: AppTypography.bodyMedium),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Text('Nutrition Guidelines:', style: AppTypography.h3),
                  const SizedBox(height: 6),
                  ...selectedProtocol.nutritionGuidelines.map((guide) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.primaryEmerald)),
                            Expanded(child: Text(guide, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  Text('Workout Adaptation:', style: AppTypography.h3),
                  const SizedBox(height: 6),
                  ...selectedProtocol.workoutAdaptations.map((wo) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.primaryCyan)),
                            Expanded(child: Text(wo, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  Text('Feast Damage Control:', style: AppTypography.h3),
                  const SizedBox(height: 6),
                  Text(selectedProtocol.feastBufferAdvice, style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
