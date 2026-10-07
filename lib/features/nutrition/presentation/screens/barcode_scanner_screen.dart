import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import '../../domain/services/barcode_scan_engine.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final BarcodeScanEngine _engine = const BarcodeScanEngine();
  BarcodeScanResult? _selectedResult;
  double _servingMultiplier = 1.0;
  bool _isScanning = true;
  String _scanStatusText = 'Align barcode inside viewfinder';

  // Popular Indian packaged foods for quick simulation / instant scanning
  final List<Map<String, String>> _popularIndianProducts = [
    {'name': 'Amul Paneer (100g)', 'code': '8901058025082', 'brand': 'Amul'},
    {'name': 'Amul Butter', 'code': '8901058000102', 'brand': 'Amul'},
    {'name': 'Britannia Marie Gold', 'code': '8901063020002', 'brand': 'Britannia'},
    {'name': 'Parle-G Gold Biscuits', 'code': '8901719101019', 'brand': 'Parle'},
    {'name': 'Maggi Masala Noodles', 'code': '8901058852336', 'brand': 'Nestlé India'},
    {'name': 'Haldiram Aloo Bhujia', 'code': '8904004400102', 'brand': 'Haldiram\'s'},
    {'name': 'Tata Sampann Chana Dal', 'code': '8904063200150', 'brand': 'Tata Consumer'},
    {'name': 'Epigamia High Protein Curd', 'code': '8906078740112', 'brand': 'Epigamia'},
  ];

  @override
  void initState() {
    super.initState();
    // Default load first item for instant review
    _onBarcodeIdentified('8901058025082');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBarcodeIdentified(String code) {
    final result = _engine.lookupBarcode(code);
    setState(() {
      _selectedResult = result;
      _servingMultiplier = 1.0;
      _isScanning = false;
      _scanStatusText = result != null ? 'Barcode detected!' : 'Barcode not in local cache';
    });
  }

  Future<void> _logProductAsMeal() async {
    if (_selectedResult == null) return;
    final r = _selectedResult!;
    final totalCalories = r.caloriesPerServing * _servingMultiplier;
    final totalProtein = r.proteinPerServing * _servingMultiplier;
    final totalCarbs = r.carbsPerServing * _servingMultiplier;
    final totalFat = r.fatPerServing * _servingMultiplier;

    final repo = ref.read(nutritionRepositoryProvider);
    final userId = ref.read(activeUserIdProvider);

    await repo.logDirectMeal(
      userId: userId,
      name: '${r.brand} ${r.productName}',
      mealType: 'Snack / Packaged',
      calories: totalCalories,
      protein: totalProtein,
      carbs: totalCarbs,
      fat: totalFat,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged ${r.productName} (${totalCalories.toInt()} kcal, ${totalProtein.toStringAsFixed(1)}g Protein)!'),
        backgroundColor: AppColors.primaryEmerald,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Indian Barcode Scanner',
          hindi: 'बारकोड स्कैनर पोषण',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Viewfinder Camera Simulation
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryCyan.withAlpha(120), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Viewfinder corners
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryCyan, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // Animated Scanning Laser Line
                  if (_isScanning)
                    Positioned(
                      top: 40,
                      left: 30,
                      right: 30,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.accentCoral,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentCoral.withAlpha(180),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .moveY(begin: 0, end: 110, duration: 1400.ms, curve: Curves.easeInOut),
                    ),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(160),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isScanning ? Icons.camera_alt_outlined : Icons.check_circle_outline,
                            color: _isScanning ? AppColors.primaryCyan : AppColors.primaryEmerald,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _scanStatusText,
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              color: _isScanning ? AppColors.textPrimary : AppColors.primaryEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Barcode search / code entry
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: AppTypography.bodySmall,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter 13-digit EAN/Barcode...',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        border: InputBorder.none,
                        icon: Icon(Icons.qr_code, color: AppColors.textMuted, size: 20),
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          _onBarcodeIdentified(val.trim());
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColors.primaryCyan.withAlpha(40)),
                  icon: const Icon(Icons.refresh, color: AppColors.primaryCyan),
                  onPressed: () => setState(() => _isScanning = true),
                  tooltip: 'Rescan',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quick Tap Popular Indian Packaged Foods
            Text('Quick Scan Popular Indian Items', style: AppTypography.h3),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _popularIndianProducts.map((prod) {
                  final isCurrent = _selectedResult?.barcode == prod['code'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(prod['name']!),
                      selected: isCurrent,
                      selectedColor: AppColors.primaryCyan.withAlpha(50),
                      backgroundColor: AppColors.surfaceCard,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isCurrent ? AppColors.primaryCyan : AppColors.textSecondary,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(color: isCurrent ? AppColors.primaryCyan : AppColors.borderGlass),
                      onSelected: (selected) {
                        if (selected) {
                          _onBarcodeIdentified(prod['code']!);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Scan Result Card
            if (_selectedResult != null) ...[
              _buildNutritionResultCard(_selectedResult!),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _logProductAsMeal,
                  icon: const Icon(Icons.add_task, color: Colors.black),
                  label: Text(
                    'Log to Today\'s Diet (${(_selectedResult!.caloriesPerServing * _servingMultiplier).toInt()} kcal)',
                    style: AppTypography.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              BentoCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.barcode_reader, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 8),
                        Text(
                          'No product scanned yet',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          'Select one of the sample Indian products above or enter a barcode.',
                          style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionResultCard(BarcodeScanResult result) {
    final calories = (result.caloriesPerServing * _servingMultiplier).toInt();
    final protein = (result.proteinPerServing * _servingMultiplier).toStringAsFixed(1);
    final carbs = (result.carbsPerServing * _servingMultiplier).toStringAsFixed(1);
    final fat = (result.fatPerServing * _servingMultiplier).toStringAsFixed(1);

    return BentoCard(
      isGlowing: true,
      glowColor: AppColors.primaryCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.productName,
                      style: AppTypography.h2.copyWith(fontSize: 18),
                    ),
                    Text(
                      'Brand: ${result.brand} • Barcode: ${result.barcode}',
                      style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryEmerald.withAlpha(80)),
                ),
                child: Text(
                  result.healthLabel,
                  style: AppTypography.label.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.borderGlass, height: 24),
          // Serving size stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Serving Size: ${(result.servingSizeG * _servingMultiplier).toInt()}g (${result.servingSizeLabel ?? "Standard"})',
                style: AppTypography.bodySmall,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryCyan, size: 20),
                    onPressed: () {
                      if (_servingMultiplier > 0.5) {
                        setState(() => _servingMultiplier -= 0.5);
                      }
                    },
                  ),
                  Text('${_servingMultiplier}x', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryCyan, size: 20),
                    onPressed: () {
                      if (_servingMultiplier < 5.0) {
                        setState(() => _servingMultiplier += 0.5);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Macro grid
          Row(
            children: [
              _buildMacroItem('Calories', '$calories kcal', AppColors.primaryEmerald),
              const SizedBox(width: 8),
              _buildMacroItem('Protein', '${protein}g', AppColors.primaryCyan),
              const SizedBox(width: 8),
              _buildMacroItem('Carbs', '${carbs}g', AppColors.accentAmber),
              const SizedBox(width: 8),
              _buildMacroItem('Fats', '${fat}g', AppColors.accentCoral),
            ],
          ),
          if (result.allergens.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.accentAmber),
                const SizedBox(width: 6),
                Text(
                  'Contains: ${result.allergens.join(', ').toUpperCase()}',
                  style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.accentAmber),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlassHover,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Text(label, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.label.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
