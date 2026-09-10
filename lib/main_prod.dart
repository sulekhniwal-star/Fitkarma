import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/config/app_environment.dart';
import 'main.dart';

void main() async {
  AppConfig.initialize(AppConfig.prod);
  await AppBootstrap.initialize();

  runApp(
    const ProviderScope(
      child: FitKarmaApp(),
    ),
  );
}
