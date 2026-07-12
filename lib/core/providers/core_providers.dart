import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/device_tier.dart';
import '../config/user_experience_stage.dart';

/// Notifier class for managing graphics capabilities.
class DeviceTierNotifier extends Notifier<DeviceTier> {
  @override
  DeviceTier build() {
    // Defaults to medium, but can be customized/inferred based on device specs
    return DeviceTier.medium;
  }

  void setTier(DeviceTier tier) {
    state = tier;
  }
}

/// Provider for the client device graphics and performance tier.
final deviceTierProvider = NotifierProvider<DeviceTierNotifier, DeviceTier>(DeviceTierNotifier.new);

/// Notifier class for the user experience stage.
class UxStageNotifier extends Notifier<UserExperienceStage> {
  @override
  UserExperienceStage build() {
    // Starts with active for development and presentation sandbox purposes
    return UserExperienceStage.active;
  }

  void setStage(UserExperienceStage stage) {
    state = stage;
  }
}

/// Provider tracking the user's current progression stage in the app.
final uxStageProvider = NotifierProvider<UxStageNotifier, UserExperienceStage>(UxStageNotifier.new);

/// Notifier class for low data/bandwidth mode.
class LowDataModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle(bool val) {
    state = val;
  }
}

/// Provider for low data/bandwidth optimization settings.
final lowDataModeProvider = NotifierProvider<LowDataModeNotifier, bool>(LowDataModeNotifier.new);

/// Notifier class for selecting light/dark theme.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.dark; // Default to dark theme mode
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

/// Provider managing the active theme mode of the application.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
