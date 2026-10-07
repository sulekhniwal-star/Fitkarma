import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class EventNutritionGuideScreen extends StatefulWidget {
  const EventNutritionGuideScreen({super.key});

  @override
  State<EventNutritionGuideScreen> createState() => _EventNutritionGuideScreenState();
}

class _EventNutritionGuideScreenState extends State<EventNutritionGuideScreen> {
  int _selectedEventIndex = 0;

  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Shaadi / Wedding Reception',
      'hindiTitle': 'शादी व दावत गाइड',
      'icon': Icons.celebration,
      'color': AppColors.accentCoral,
      'preEvent': 'Eat a 25g protein snack (1 cup Greek yogurt, scoop of whey, or 100g paneer) 1 hour before leaving so you never arrive at the venue ravenous.',
      'buffetTactic': 'Fill 50% of your first plate with Tandoori items (Paneer Tikka, Chicken Tikka, Tandoori Broccoli) and fresh salads before approaching the gravies and naan.',
      'sweetRule': 'Pick ONE marquee dessert you genuinely love (e.g. 1 hot Gulab Jamun or Rasgulla) and savor it slowly without drinking excess sugar syrup.',
      'drinkRule': 'Alternate any alcoholic drink or soda with a large glass of sparkling water or fresh lime soda with rock salt (Nimbu Soda).',
      'nextMorning': 'Start tomorrow with warm Saunf-Ajwain water and keep breakfast light (Papaya + Moong Dal Chilla) to give your liver and gut a rest.',
    },
    {
      'title': 'Festival Feast / Pooja',
      'hindiTitle': 'त्योहार व पूजा भोग',
      'icon': Icons.temple_hindu,
      'color': AppColors.accentAmber,
      'preEvent': 'Drink 500ml water with lemon before morning prasad to stay hydrated and prevent blood glucose spikes from dry fruits and laddus.',
      'buffetTactic': 'Take a small portion of prasad with reverence. For the main festival thali, prioritize sabzis (pumpkin, arbi, paneer) over deep-fried puris.',
      'sweetRule': 'Savor kheer or halwa in a small katori (50-60g). Eat it after fiber and protein, never on an empty stomach.',
      'drinkRule': 'Opt for digestive Thandai made with almond milk or unsweetened Chaas infused with mint and roasted cumin.',
      'nextMorning': 'Digestive ginger-tulsi tea followed by a 30-minute brisk morning walk to re-sensitize insulin receptors.',
    },
    {
      'title': 'Office Party / Friday Buffet',
      'hindiTitle': 'ऑफिस पार्टी व बफ़े',
      'icon': Icons.business_center,
      'color': AppColors.primaryCyan,
      'preEvent': 'Do not "starve all day to save calories" — this guarantees overeating pizza or biryani. Eat your normal high-protein breakfast and lunch.',
      'buffetTactic': 'Skip bread baskets and nachos. Head straight for grilled proteins and roasted vegetables.',
      'sweetRule': 'Share desserts with a colleague — half the sugar, all the enjoyment.',
      'drinkRule': 'Limit sugary cocktails. Choose dry red wine or Gin with diet tonic / fresh lime.',
      'nextMorning': 'Black coffee, electrolyte water, and a standard workout to burn off stored glycogen.',
    },
    {
      'title': 'Late-Night Street Food',
      'hindiTitle': 'स्ट्रीट फूड व लेट नाइट',
      'icon': Icons.nightlife,
      'color': AppColors.accentPurple,
      'preEvent': 'Have 2 boiled eggs or a glass of sattu buttermilk before heading out to prevent mindless bingeing.',
      'buffetTactic': 'Favor Pav Bhaji with 1 pav (extra bhaji), Paneer Frankie with whole wheat wrap, or Tandoori Momos over deep-fried bhature.',
      'sweetRule': 'Avoid ice creams and thick milkshakes late at night; choose a fresh coconut water instead.',
      'drinkRule': 'Warm water with pinch of hing and black salt right before sleeping to ease night-time gastric reflux.',
      'nextMorning': 'Intermittent fast for 14 hours — take your first meal at noon to allow full gastrointestinal transit.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final active = _events[_selectedEventIndex];

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
          english: 'Tonight\'s Event Food Strategy',
          hindi: 'आज रात का दावत व पार्टी प्लान',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event selector row
            Text('Select Tonight\'s Occasion', style: AppTypography.h3),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_events.length, (index) {
                  final ev = _events[index];
                  final isSelected = _selectedEventIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      avatar: Icon(ev['icon'] as IconData, size: 16, color: isSelected ? Colors.black : ev['color'] as Color),
                      label: Text(ev['title'] as String),
                      selected: isSelected,
                      selectedColor: ev['color'] as Color,
                      backgroundColor: AppColors.surfaceCard,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedEventIndex = index);
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (active['color'] as Color).withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (active['color'] as Color).withAlpha(80)),
              ),
              child: Row(
                children: [
                  Icon(active['icon'] as IconData, color: active['color'] as Color, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(active['title'] as String, style: AppTypography.h3),
                        Text(active['hindiTitle'] as String, style: AppTypography.bilingualSub),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // 4 Pillars of Guilt-Free Social Eating
            _buildStrategyCard(
              phase: '1. PRE-EVENT PREP',
              title: 'Protein Pre-Load Defense',
              hindi: 'पार्टी से पहले प्रोटीन लोड',
              description: active['preEvent'] as String,
              icon: Icons.shield_outlined,
              accentColor: AppColors.primaryCyan,
            ),
            const SizedBox(height: 10),

            _buildStrategyCard(
              phase: '2. AT THE BUFFET',
              title: 'Tandoori & Salad Priority',
              hindi: 'तंदूरी व सलाद पहले खाएं',
              description: active['buffetTactic'] as String,
              icon: Icons.restaurant,
              accentColor: AppColors.primaryEmerald,
            ),
            const SizedBox(height: 10),

            _buildStrategyCard(
              phase: '3. SWEETS & DRINKS',
              title: 'Conscious Indulgence Rule',
              hindi: 'मीठा व ड्रिंक्स सावधानी',
              description: '${active['sweetRule']}\n\n${active['drinkRule']}',
              icon: Icons.icecream_outlined,
              accentColor: AppColors.accentAmber,
            ),
            const SizedBox(height: 10),

            _buildStrategyCard(
              phase: '4. NEXT MORNING',
              title: 'Ayurvedic Gut Reset',
              hindi: 'अगली सुबह पाचन रीसेट',
              description: active['nextMorning'] as String,
              icon: Icons.spa_outlined,
              accentColor: AppColors.accentPurple,
            ),

            const SizedBox(height: 20),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event strategy set! We will remind you to drink water and pre-load protein tonight! 🎉'),
                      backgroundColor: AppColors.primaryEmerald,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.alarm_on, color: Colors.black),
                label: Text(
                  'Set Event Reminder & Pre-Load Plan',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyCard({
    required String phase,
    required String title,
    required String hindi,
    required String description,
    required IconData icon,
    required Color accentColor,
  }) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(phase, style: AppTypography.label.copyWith(color: accentColor, fontWeight: FontWeight.bold, fontSize: 10)),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          Text(hindi, style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
