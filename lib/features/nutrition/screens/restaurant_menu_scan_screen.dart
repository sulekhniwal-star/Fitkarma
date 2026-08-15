import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/restaurant_intelligence_models.dart';
import '../models/restaurant_database_service.dart';

/// §P5-E Indian Restaurant Intelligence 2.0 Screen
/// Route: /food/restaurant-scanner
class RestaurantMenuScanScreen extends StatefulWidget {
  const RestaurantMenuScanScreen({super.key});

  @override
  State<RestaurantMenuScanScreen> createState() =>
      _RestaurantMenuScanScreenState();
}

class _RestaurantMenuScanScreenState extends State<RestaurantMenuScanScreen> {
  final _service = RestaurantDatabaseService();
  List<ParsedMenuItemOverlay> _scannedOverlays = [];
  bool _hasScanned = false;
  String _selectedChain = "Haldiram's";

  void _simulateMenuScan() {
    // Sample OCR menu text lines extracted from a photo
    final rawOcrLines = [
      "Paneer Tikka Platter",
      "Chole Bhature Special",
      "Sprouted Moong Chaat",
      "Butter Naan",
      "Yellow Dal Tadka",
      "Grilled Soya Chaap",
      "Special Thali",
    ];

    final results = _service.parseMenuText(rawOcrLines);
    setState(() {
      _scannedOverlays = results;
      _hasScanned = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Restaurant Intelligence 2.0', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu OCR Scan Action Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.document_scanner,
                          color: AppColors.primary, size: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Menu OCR Scanner', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Scan or upload any Indian restaurant menu to automatically color-code items based on your fitness goals.',
                    style: AppTypography.bodySm,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.cardRadius),
                        ),
                      ),
                      onPressed: _simulateMenuScan,
                      icon: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                      label: Text('Scan Menu Photo / OCR',
                          style: AppTypography.labelLg
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Color Category Legend
            Text('Goal Overlay Legend:', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final cat in MenuGoalOverlayCategory.values)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: cat.color.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      cat.label,
                      style: AppTypography.bodySm.copyWith(
                          color: cat.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Scanned Menu Results with Goal Overlay Badges
            if (_hasScanned) ...[
              Text('Scanned Menu Overlay Results:', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final overlay in _scannedOverlays)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: overlay.colorOverlay.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color:
                            overlay.colorOverlay.color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(overlay.dishName, style: AppTypography.labelLg),
                          const SizedBox(height: 2),
                          Text(
                            '${overlay.calories} kcal · ${overlay.proteinG}g protein',
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: overlay.colorOverlay.color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          overlay.colorOverlay.name,
                          style: AppTypography.bodySm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Major Chain Menu Presets Section per §P5-E Table
            Text('Major Indian Chain Optimization Presets:',
                style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            DropdownButton<String>(
              value: _selectedChain,
              dropdownColor: AppColors.surface0,
              items: MajorChainPresetsDatabase.presets.map((preset) {
                return DropdownMenuItem<String>(
                  value: preset.chainName,
                  child: Text(preset.chainName, style: AppTypography.labelLg),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedChain = val);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            _ChainPresetCard(
              preset: MajorChainPresetsDatabase.presets
                  .firstWhere((p) => p.chainName == _selectedChain),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ChainPresetCard extends StatelessWidget {
  final MajorChainPreset preset;

  const _ChainPresetCard({required this.preset});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(preset.chainName,
              style: AppTypography.h3.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSpacing.sm),
          _PresetRow(
            icon: '🟢',
            title: 'Best Protein Pick',
            detail: preset.bestProteinPick,
            color: MenuGoalOverlayCategory.greenHighProtein.color,
          ),
          const SizedBox(height: 8),
          _PresetRow(
            icon: '🔴',
            title: 'Avoid / Alert Item',
            detail: preset.avoidAlertItem,
            color: MenuGoalOverlayCategory.redAvoidAlert.color,
          ),
          const SizedBox(height: 8),
          _PresetRow(
            icon: '🟠',
            title: 'Diabetic / PCOS Pick',
            detail: preset.diabeticPcosPick,
            color: MenuGoalOverlayCategory.orangeDiabeticPcos.color,
          ),
        ],
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  final String icon;
  final String title;
  final String detail;
  final Color color;

  const _PresetRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTypography.bodySm
                    .copyWith(color: color, fontWeight: FontWeight.bold)),
            Text(detail, style: AppTypography.labelLg.copyWith(fontSize: 13)),
          ],
        ),
      ],
    );
  }
}
