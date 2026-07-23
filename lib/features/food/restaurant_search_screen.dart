/// §P5-E Indian Restaurant Intelligence 2.0 Screen
///
/// Restaurant search/browse UI with major chain optimization presets carousel,
/// goal-based color overlays (High Protein, Low Calorie, Diabetic Safe, Avoid),
/// menu OCR text parser tab, and direct dish logging.
library;

import 'package:fitkarma/features/food/restaurant_controller.dart';
import 'package:fitkarma/features/food/restaurant_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0E0F14);
const _surfaceColor = Color(0xFF1A1C26);
const _cardColor = Color(0xFF222434);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentRed = Color(0xFFF87171);
const _accentBlue = Color(0xFF60A5FA);
const _accentYellow = Color(0xFFFBBF24);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2D2F45);

class RestaurantSearchScreen extends ConsumerStatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  ConsumerState<RestaurantSearchScreen> createState() =>
      _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends ConsumerState<RestaurantSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _ocrCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    _ocrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Restaurant Intelligence',
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accentOrange,
          labelColor: _accentOrange,
          unselectedLabelColor: _textSecondary,
          labelStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Browse Chains & Dishes'),
            Tab(text: 'Menu OCR Scanner'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BrowseTab(state: state, searchCtrl: _searchCtrl),
          _OcrTab(state: state, ocrCtrl: _ocrCtrl),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Browse Chains & Dishes
// ─────────────────────────────────────────────────────────────────────────────

class _BrowseTab extends ConsumerWidget {
  const _BrowseTab({required this.state, required this.searchCtrl});

  final RestaurantState state;
  final TextEditingController searchCtrl;

  static const _chainChips = [
    'All',
    "Haldiram's",
    'Bikanervala',
    "Domino's India",
    "McDonald's India",
    'Barbeque Nation',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(restaurantProvider.notifier);
    final service = ref.read(restaurantDatabaseServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Search Input ──
          TextField(
            key: const Key('restaurant_search_input'),
            controller: searchCtrl,
            style: const TextStyle(color: _textPrimary),
            onChanged: (val) => notifier.setSearchQuery(val),
            decoration: InputDecoration(
              hintText: 'Search dish name, chain or category…',
              hintStyle: const TextStyle(color: _textSecondary),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: _accentOrange,
              ),
              suffixIcon: searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: _textSecondary,
                      ),
                      onPressed: () {
                        searchCtrl.clear();
                        notifier.setSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: _surfaceColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _accentOrange),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Top Chain Presets Carousel ──
          const Text(
            'Major Chain Optimization Presets',
            style: TextStyle(
              color: _textPrimary,
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.chainPresets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final preset = state.chainPresets[index];
                final isSelected = state.selectedChain == preset.chainName;
                return _ChainPresetCard(
                  preset: preset,
                  isSelected: isSelected,
                  onTap: () {
                    final target = isSelected ? 'All' : preset.chainName;
                    notifier.setSelectedChain(target);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Chain Filter Chips ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _chainChips.map((chain) {
                final active = state.selectedChain == chain;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    key: Key('restaurant_chain_chip_$chain'),
                    label: Text(chain),
                    selected: active,
                    onSelected: (_) => notifier.setSelectedChain(chain),
                    selectedColor: _accentOrange.withAlpha(50),
                    backgroundColor: _surfaceColor,
                    checkmarkColor: _accentOrange,
                    labelStyle: TextStyle(
                      color: active ? _accentOrange : _textSecondary,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: active ? _accentOrange : _borderColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Goal Overlay Color Legend ──
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: const Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _LegendBadge(
                  color: _accentGreen,
                  label: '🟢 High Protein (>20g)',
                ),
                _LegendBadge(
                  color: _accentBlue,
                  label: '🔵 Low Cal (<300 kcal)',
                ),
                _LegendBadge(color: _accentYellow, label: '🟠 Diabetic Safe'),
                _LegendBadge(color: _accentRed, label: '🔴 Avoid / Fried'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Menu Items List ──
          if (state.items.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: const Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    color: _textSecondary,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No restaurant dishes match your search',
                    style: TextStyle(color: _textSecondary, fontSize: 14),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.items[index];
                final overlay = service.computeGoalOverlay(
                  item,
                  isPcosOrDiabetic: state.isPcosOrDiabetic,
                );
                return _MenuItemCard(
                  item: item,
                  overlay: overlay,
                  onLog: () => notifier.logDish(item),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _LegendBadge extends StatelessWidget {
  const _LegendBadge({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: _textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _ChainPresetCard extends StatelessWidget {
  const _ChainPresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final ChainPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 240,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _cardColor : _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _accentOrange : _borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    preset.chainName,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _accentOrange,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _HighlightRow(
              icon: Icons.fitness_center_rounded,
              color: _accentGreen,
              label: 'Protein Pick: ',
              value: preset.bestProteinPick,
            ),
            const SizedBox(height: 4),
            _HighlightRow(
              icon: Icons.health_and_safety_rounded,
              color: _accentYellow,
              label: 'Diabetic Pick: ',
              value: preset.diabeticPick,
            ),
            const SizedBox(height: 4),
            _HighlightRow(
              icon: Icons.warning_amber_rounded,
              color: _accentRed,
              label: 'Avoid Item: ',
              value: preset.avoidItem,
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(color: _textSecondary, fontSize: 11),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    required this.item,
    required this.overlay,
    required this.onLog,
  });

  final RestaurantMenuItem item;
  final OverlayColor overlay;
  final VoidCallback onLog;

  Color get _overlayColor {
    return switch (overlay) {
      OverlayColor.green => _accentGreen,
      OverlayColor.blue => _accentBlue,
      OverlayColor.orange => _accentYellow,
      OverlayColor.red => _accentRed,
      OverlayColor.none => _borderColor,
    };
  }

  String get _overlayBadgeText {
    return switch (overlay) {
      OverlayColor.green => '🟢 High Protein',
      OverlayColor.blue => '🔵 Low Calorie',
      OverlayColor.orange => '🟠 Diabetic Safe',
      OverlayColor.red => '🔴 Avoid / Fried',
      OverlayColor.none => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('restaurant_item_card_${item.id}'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: overlay != OverlayColor.none
              ? _overlayColor.withAlpha(120)
              : _borderColor,
          width: overlay != OverlayColor.none ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.restaurantName} · ${item.category}',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (overlay != OverlayColor.none)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _overlayColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _overlayColor.withAlpha(100)),
                  ),
                  child: Text(
                    _overlayBadgeText,
                    style: TextStyle(
                      color: _overlayColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Macro Pill Strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NutrientPill(
                label: 'Calories',
                value: '${item.calories.round()} kcal',
                color: _accentOrange,
              ),
              _NutrientPill(
                label: 'Protein',
                value: '${item.proteinG.round()}g',
                color: _accentGreen,
              ),
              _NutrientPill(
                label: 'Carbs',
                value: '${item.carbsG.round()}g',
                color: _accentYellow,
              ),
              _NutrientPill(
                label: 'GI Index',
                value: '${item.glycemicIndex}',
                color: _accentBlue,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.isDeepFried)
                const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: _accentRed,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Deep Fried',
                      style: TextStyle(color: _accentRed, fontSize: 11),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              ElevatedButton.icon(
                key: Key('restaurant_log_item_${item.id}'),
                onPressed: onLog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Log Dish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 32),
                  textStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientPill extends StatelessWidget {
  const _NutrientPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: _textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Menu OCR Scanner
// ─────────────────────────────────────────────────────────────────────────────

class _OcrTab extends ConsumerWidget {
  const _OcrTab({required this.state, required this.ocrCtrl});

  final RestaurantState state;
  final TextEditingController ocrCtrl;

  static const _sampleOcrMenu = '''
Paneer Tikka Platter
Chole Bhature
Sprouted Moong Chaat
Special Thali
Tandoori Roti
Mix Veg
Butter Naan
Dal Makhani
''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(restaurantProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.document_scanner_rounded,
                      color: _accentOrange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Menu OCR Scanner Simulator',
                      style: TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Paste raw menu lines below — our Levenshtein matcher instantly parses dishes & applies goal overlays.',
                  style: TextStyle(color: _textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('restaurant_ocr_input'),
                  controller: ocrCtrl,
                  maxLines: 5,
                  style: const TextStyle(color: _textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Enter or paste OCR menu text lines…',
                    hintStyle: const TextStyle(color: _textSecondary),
                    filled: true,
                    fillColor: _cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        key: const Key('restaurant_parse_ocr_btn'),
                        onPressed: () {
                          notifier.parseOcrText(ocrCtrl.text);
                        },
                        icon: const Icon(Icons.analytics_rounded),
                        label: const Text('Parse Menu OCR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      key: const Key('restaurant_load_sample_ocr'),
                      onPressed: () {
                        ocrCtrl.text = _sampleOcrMenu.trim();
                        notifier.parseOcrText(ocrCtrl.text);
                      },
                      child: const Text(
                        'Sample Menu',
                        style: TextStyle(color: _accentBlue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── OCR Parsed Highlights List ──
          if (state.ocrResults.isNotEmpty) ...[
            Text(
              'Parsed Menu Overlays (${state.ocrResults.length} items)',
              style: const TextStyle(
                color: _textPrimary,
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.ocrResults.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final res = state.ocrResults[index];
                return _OcrOverlayTile(
                  overlay: res,
                  onLog: res.matchedItem != null
                      ? () => notifier.logDish(res.matchedItem!)
                      : null,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _OcrOverlayTile extends StatelessWidget {
  const _OcrOverlayTile({required this.overlay, required this.onLog});

  final ParsedMenuItemOverlay overlay;
  final VoidCallback? onLog;

  Color get _color {
    return switch (overlay.colorOverlay) {
      OverlayColor.green => _accentGreen,
      OverlayColor.blue => _accentBlue,
      OverlayColor.orange => _accentYellow,
      OverlayColor.red => _accentRed,
      OverlayColor.none => _borderColor,
    };
  }

  String get _tag {
    return switch (overlay.colorOverlay) {
      OverlayColor.green => 'High Protein',
      OverlayColor.blue => 'Low Calorie',
      OverlayColor.orange => 'Diabetic Safe',
      OverlayColor.red => 'Avoid / Deep Fried',
      OverlayColor.none => 'Matched',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withAlpha(140), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overlay.dishName,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${overlay.calories.round()} kcal · ${overlay.proteinG.round()}g Pro · $_tag',
                  style: TextStyle(color: _color, fontSize: 12),
                ),
              ],
            ),
          ),
          if (onLog != null)
            IconButton(
              icon: const Icon(Icons.add_circle_rounded, color: _accentOrange),
              onPressed: onLog,
            ),
        ],
      ),
    );
  }
}
