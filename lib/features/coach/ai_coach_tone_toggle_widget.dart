/// §P12-D AI Roast Mode & Persona Tone Toggle UI Widget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_coach_tone_controller.dart';

class AiCoachToneToggleWidget extends ConsumerWidget {
  const AiCoachToneToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toneState = ref.watch(aiCoachToneProvider);
    final notifier = ref.read(aiCoachToneProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: toneState.isRoastEnabled
              ? const Color(0xFFF97316).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 8),
              const Text(
                'AI Coach Persona & Tone',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (toneState.isRoastEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFF97316)),
                  ),
                  child: const Text(
                    '🌶️ ROAST ACTIVE',
                    style: TextStyle(
                      color: Color(0xFFF97316),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Tone Choice Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AiCoachTone.values.map((tone) {
                final isSelected = toneState.selectedTone == tone;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tone.displayName),
                    selected: isSelected,
                    selectedColor: tone == AiCoachTone.roast
                        ? const Color(0xFFF97316)
                        : const Color(0xFF0EA5E9),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    onSelected: (_) => notifier.setTone(tone),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Roast Mode Opt-in Switch
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌶️ Opt-In AI Roast Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Playful, witty, tough-love feedback. Auto-disables if distress is detected.',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: toneState.selectedTone == AiCoachTone.roast,
                  activeColor: const Color(0xFFF97316),
                  onChanged: (enabled) => notifier.toggleRoastMode(enabled),
                ),
              ],
            ),
          ),

          // Crisis Override Safety Banner
          if (toneState.isCrisisOverrideActive) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: Color(0xFF6366F1), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '🔒 Safety Guardrail Active: Reverted to Gentle tone (${toneState.lastDistressKeyword ?? "distress detected"}).',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
