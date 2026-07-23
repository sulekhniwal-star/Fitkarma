import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true; // Default to online
  }

  void setOnline(bool online) {
    state = online;
  }
}

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(
  ConnectivityNotifier.new,
);
