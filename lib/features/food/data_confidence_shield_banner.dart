/// §P5-O Data Confidence Shield UI Banner Widget
///
/// Interactive UI Card displaying rolling 7-day nutrition reliability score %,
/// color-coded lockout status badge ("🔒 Target Lock Active" <70%),
/// and low-confidence warning messages to prevent starvation cascades.
library;

import 'package:fitkarma/features/food/data_confidence_shield_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _surfaceColor = Color(0xFF191B28);
const _accentGreen = Color(0xFF4ADE80);
const _accentRed = Color(0xFFF87171);
const _accentYellow = Color(0xFFFBBF24);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2E324A);

class DataConfidenceShieldBanner extends ConsumerWidget {
  const DataConfidenceShieldBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataConfidenceShieldProvider);
    final result = state.result;

    final isLockout = result.isLockoutActive;
    final badgeColor = isLockout ? _accentRed : _accentGreen;

    return Container(
      key: const Key('data_confidence_shield_banner'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLockout ? _accentRed.withAlpha(20) : _surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLockout ? _accentRed.withAlpha(100) : _borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isLockout ? Icons.lock_rounded : Icons.verified_user_rounded,
                color: badgeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Data Confidence Shield',
                  style: TextStyle(
                    color: _textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeColor.withAlpha(100)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLockout ? '🔒 Target Lock' : '🟢 Unlocked',
                      key: const Key('shield_lockout_badge'),
                      style: TextStyle(
                        color: badgeColor,
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Reliability Score Bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '7-Day Rolling Log Reliability',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${result.reliabilityScorePct.round()}% / 70% Target',
                key: const Key('shield_reliability_score_text'),
                style: TextStyle(
                  color: isLockout ? _accentYellow : _accentGreen,
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (result.reliabilityScorePct / 100.0).clamp(0.0, 1.0),
              backgroundColor: _borderColor,
              valueColor: AlwaysStoppedAnimation(
                isLockout ? _accentYellow : _accentGreen,
              ),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 10),

          // ── Shield Warning / Info Message ──
          Text(
            result.shieldMessage,
            key: const Key('shield_message_text'),
            style: TextStyle(
              color: isLockout ? _textPrimary : _textSecondary,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
