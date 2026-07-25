// lib/shared/widgets/encryption_badge.dart
// §P0-D2 — AES-256 encryption status badge.
// Rule of Two: border + icon only (no glow, no gradient).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// A small badge indicating that the current screen's data is AES-256 encrypted.
/// Shown on clinical reports, doctor sharing portal, and progress photo screens.
class EncryptionBadge extends StatelessWidget {
  const EncryptionBadge({super.key, this.compact = false});

  /// If true, shows icon only (no text). For use in tight spaces.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: AppColorsDark.teal.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColorsDark.teal.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: compact ? 0 : 5,
        children: [
          Icon(
            Icons.lock_rounded,
            size: 11,
            color: AppColorsDark.teal,
          ),
          if (!compact)
            Text(
              'AES-256 Encrypted',
              style: AppTypography.labelMd.copyWith(
                color: AppColorsDark.teal,
                letterSpacing: 0.1,
              ),
            ),
        ],
      ),
    );
  }
}
