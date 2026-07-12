import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/style_guide_screen.dart';

void main() {
  runApp(const FitkarmaApp());
}

class FitkarmaApp extends StatelessWidget {
  const FitkarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitkarma',
      debugShowCheckedModeBanner: false,
      theme: FitkarmaAppTheme.darkTheme,
      home: const StyleGuideScreen(),
    );
  }
}
