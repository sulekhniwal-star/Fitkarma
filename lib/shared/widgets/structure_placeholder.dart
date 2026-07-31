import 'package:flutter/material.dart';

/// Placeholder stub widget for FitKarma UI modularity
class StructurePlaceholder extends StatelessWidget {
  final String title;

  const StructurePlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Module: $title'),
      ),
    );
  }
}
