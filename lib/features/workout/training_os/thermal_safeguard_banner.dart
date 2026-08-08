import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_typography.dart';
import 'thermal_frame_processor.dart';

/// §P6-F UX Transparency Safeguard Banner
class ThermalSafeguardBanner extends ConsumerWidget {
  const ThermalSafeguardBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(thermalProcessorProvider);

    if (state == ThermalWorkloadState.normal) {
      return const SizedBox.shrink();
    }

    String message = '';
    IconData icon = Icons.bolt;
    Color badgeColor = AppColors.warning;

    switch (state) {
      case ThermalWorkloadState.moderate:
        message = '⚡ Optimization Active: Device temperature moderate. Skips 1:2 frames to preserve battery.';
        badgeColor = AppColors.warning;
        break;
      case ThermalWorkloadState.severe:
        message = '🔥 Thermal Safeguard Active: High temperature detected. Tracking core 11 skeletal joints at 10 fps.';
        badgeColor = AppColors.accent;
        break;
      case ThermalWorkloadState.critical:
        message = '⚠️ Critical Thermal Protection: Extreme device heat. Switched to minimal depth tracing at 5 fps.';
        badgeColor = AppColors.error;
        icon = Icons.local_fire_department;
        break;
      case ThermalWorkloadState.normal:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: badgeColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
