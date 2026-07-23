import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/wearable/device_reliability_engine.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class WearableComparisonScreen extends StatefulWidget {
  const WearableComparisonScreen({super.key});

  @override
  State<WearableComparisonScreen> createState() =>
      _WearableComparisonScreenState();
}

class _WearableComparisonScreenState extends State<WearableComparisonScreen> {
  WearableSource _selectedSource = WearableSource.whoop;
  double _rawHrv = 58.0;
  double _rawHr = 72.0;

  final double _baselineHrv = 62.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final successColor = isDark
        ? AppColorsDark.success
        : AppColorsLight.success;

    final engine = DeviceReliabilityEngine();
    final result = engine.applyConfidence(
      source: _selectedSource,
      rawHRV: _rawHrv,
      rawHR: _rawHr,
    );

    // Baseline comparison
    final double baselineDiff =
        ((_rawHrv - _baselineHrv) / _baselineHrv) * 100.0;
    final diffSign = baselineDiff >= 0 ? '+' : '';
    final diffColor = baselineDiff >= 0 ? successColor : Colors.redAccent;

    // Confidence stars representation
    final int stars = (result.hrvConfidence * 5.0).round();
    final String starsText = '★' * stars + '☆' * (5 - stars);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Wearable Comparison',
          style: AppTypography.h3.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Dropdown Selector
            BentoCard(
              customBgColor: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Primary Device Source',
                    style: AppTypography.bodySm.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<WearableSource>(
                    key: const Key('wearable_source_dropdown'),
                    dropdownColor: cardBg,
                    value: _selectedSource,
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    iconEnabledColor: textPrimary,
                    underline: Container(height: 1, color: Colors.white24),
                    isExpanded: true,
                    items: WearableSource.values.map((source) {
                      return DropdownMenuItem(
                        value: source,
                        child: Text(source.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSource = val;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.bentoGap),

            // 2. Main Wearable Source Card
            BentoCard(
              key: const Key('wearable_primary_source_card'),
              customBgColor: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⌚ HRV Source: ${_selectedSource.displayName}',
                        style: AppTypography.bodyMd.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        starsText,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s HRV',
                            style: AppTypography.labelMd.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_rawHrv.round()} ms',
                            style: AppTypography.h3.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Your Baseline',
                            style: AppTypography.labelMd.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_baselineHrv.round()} ms ($diffSign${baselineDiff.round()}%)',
                            style: AppTypography.bodyLg.copyWith(
                              color: diffColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  Text(
                    'ℹ️ ${_selectedSource.displayName} data is weighted at ${(result.readinessWeight * 100).round()}% confidence in your readiness score.',
                    style: AppTypography.bodySm.copyWith(
                      color: textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.bentoGap),

            // 3. Comparison Matrix Grid Table
            BentoCard(
              customBgColor: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device Confidence Matrix',
                    style: AppTypography.h3.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.white10,
                      ),
                      horizontalMargin: 8,
                      columnSpacing: 16,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Device',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'HRV Conf.',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'HR Conf.',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Weight',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: WearableSource.values.map((src) {
                        final p = DeviceReliabilityEngine.deviceProfiles[src]!;
                        final w = engine
                            .applyConfidence(source: src, rawHRV: 60, rawHR: 60)
                            .readinessWeight;
                        final isSelected = src == _selectedSource;
                        return DataRow(
                          selected: isSelected,
                          color: MaterialStateProperty.resolveWith<Color?>((
                            states,
                          ) {
                            if (isSelected)
                              return primaryColor.withOpacity(0.2);
                            return null;
                          }),
                          cells: [
                            DataCell(
                              Text(
                                src.displayName,
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${(p.hrvConfidence * 100).round()}%',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${(p.hrConfidence * 100).round()}%',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${(w * 100).round()}%',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
