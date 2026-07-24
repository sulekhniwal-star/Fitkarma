/// §P10-K Non-Diagnostic Shield Disclaimer Banner
///
/// Reusable disclaimer banner enforcing mandatory non-diagnostic health insights disclaimer
/// matching §P10-K and §P10-F specifications.
library;

import 'package:flutter/material.dart';

class NonDiagnosticShieldBanner extends StatelessWidget {
  const NonDiagnosticShieldBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel_rounded, color: Colors.amberAccent, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🔒 Non-Diagnostic Health Insights Disclaimer (§P10-K):\n'
              'FitKarma provides wellness intelligence and fitness optimization insights, not medical diagnosis. '
              'Always consult a qualified healthcare professional before making clinical or medical decisions.',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
