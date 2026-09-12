import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class GroceryOptimizerScreen extends StatefulWidget {
  const GroceryOptimizerScreen({super.key});

  @override
  State<GroceryOptimizerScreen> createState() => _GroceryOptimizerScreenState();
}

class _GroceryOptimizerScreenState extends State<GroceryOptimizerScreen> {
  final List<Map<String, dynamic>> _groceryList = [
    {
      'name': 'Jowar & Ragi Flour (Millets)',
      'nameHindi': 'ज्वार व रागी का आटा',
      'category': 'Grains & Millets',
      'qty': '2 kg',
      'cost': 140.0,
      'checked': false,
    },
    {
      'name': 'Yellow Moong Dal & Chana Dal',
      'nameHindi': 'मूंग व चना दाल',
      'category': 'Dals & Pulses',
      'qty': '1.5 kg',
      'cost': 195.0,
      'checked': false,
    },
    {
      'name': 'Fresh Cow Milk Paneer',
      'nameHindi': 'ताज़ा पनीर',
      'category': 'Dairy & Protein',
      'qty': '500 g',
      'cost': 180.0,
      'checked': false,
    },
    {
      'name': 'Raw Foxnuts (Makhana)',
      'nameHindi': 'कच्चा मखाना',
      'category': 'Healthy Snacks',
      'qty': '250 g',
      'cost': 220.0,
      'checked': false,
    },
    {
      'name': 'Green Leafy Spinach (Palak) & Cucumber',
      'nameHindi': 'पालक व खीरा',
      'category': 'Vegetables',
      'qty': '1 kg',
      'cost': 85.0,
      'checked': false,
    },
    {
      'name': 'Whole Spices (Jeera, Dalchini, Haldi)',
      'nameHindi': 'खड़े मसाले (जीरा, दालचीनी)',
      'category': 'Spices & Immunity',
      'qty': '100 g',
      'cost': 95.0,
      'checked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    for (final item in _groceryList) {
      totalCost += (item['cost'] as num).toDouble();
    }

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
          english: 'Grocery & Mandi Optimizer',
          hindi: 'किराना व बाज़ार बजट सूची',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: Column(
        children: [
          // Total Estimated Budget Card
          Padding(
            padding: const EdgeInsets.all(20),
            child: BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Healthy Thali Budget', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text('₹${totalCost.toInt()}', style: AppTypography.h1.copyWith(color: AppColors.primaryEmerald)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryEmerald),
                    ),
                    child: Text('₹130 / day', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          // Grocery Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                final item = _groceryList[index];
                final isChecked = item['checked'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          activeColor: AppColors.primaryEmerald,
                          onChanged: (val) {
                            setState(() {
                              item['checked'] = val ?? false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isChecked ? AppColors.textMuted : AppColors.textPrimary,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              Text(item['nameHindi'] as String, style: AppTypography.bilingualSub),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${(item['cost'] as num).toInt()}', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                            Text(item['qty'] as String, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Commerce Sync Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surfaceCard,
              border: Border(top: BorderSide(color: AppColors.borderGlass)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryCyan,
                        side: const BorderSide(color: AppColors.primaryCyan),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart copied to quick commerce clipboard!')),
                        );
                      },
                      child: const Text('Export List'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: AppColors.textOnAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Basket optimized for lowest INR price!'),
                            backgroundColor: AppColors.primaryEmerald,
                          ),
                        );
                      },
                      child: const Text('Optimize Price'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
