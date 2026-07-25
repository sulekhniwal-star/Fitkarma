// lib/shared/widgets/sync_status_banner.dart
// §P0-D2 — Sync status indicator (syncing / synced / offline).
// Rule of Two: gradient + icon (no blur, no glow).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

enum SyncStatus { synced, syncing, offline, error }

/// A thin banner displayed at the top of any screen that needs to show sync state.
/// Automatically animates in/out with the sync status.
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key, required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced) return const SizedBox.shrink();

    final (color, icon, label) = _resolve();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      color: color.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          status == SyncStatus.syncing
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: color,
                  ),
                )
              : Icon(icon, size: 14, color: color),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  (Color, IconData, String) _resolve() {
    return switch (status) {
      SyncStatus.syncing => (AppColorsDark.accent, Icons.sync_rounded, 'Syncing…'),
      SyncStatus.offline => (
          AppColorsDark.warning,
          Icons.cloud_off_rounded,
          'Offline — changes saved locally'
        ),
      SyncStatus.error => (
          AppColorsDark.error,
          Icons.sync_problem_rounded,
          'Sync failed — will retry'
        ),
      SyncStatus.synced => (AppColorsDark.success, Icons.cloud_done_rounded, 'Synced'),
    };
  }
}
