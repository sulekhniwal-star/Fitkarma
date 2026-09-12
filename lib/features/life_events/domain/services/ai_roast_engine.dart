import '../models/life_event_models.dart';

class AIRoastEngine {
  const AIRoastEngine();

  /// Generates culturally hilarious, witty Indian AI coach roasts for missed health goals
  AIRoastMessage generateRoast({
    required String triggerType, // 'missed_steps', 'missed_workout', 'swiggy_binge', 'broken_streak'
    required RoastIntensity intensity,
    required String userName,
  }) {
    String headline;
    String body;
    String bodyHi;
    String punchline;

    switch (triggerType.toLowerCase()) {
      case 'missed_steps':
        if (intensity == RoastIntensity.savage) {
          headline = 'Sharma Ji Ka Beta Already Did 15k Steps! 🚶‍♂️🔥';
          body = '$userName, your fitness band is crying in the corner. Even your phone\'s battery lost more percentage today than calories you burned!';
          bodyHi = '$userName, आपकी स्मार्टवॉच कोने में रो रही है। आपसे ज्यादा एक्टिव तो आपका वाई-फाई राउटर है! उठिए और चलिए।';
          punchline = 'Sofa se utho, Bharat aage badh raha hai!';
        } else if (intensity == RoastIntensity.spicy) {
          headline = 'Target: 10,000 steps. Reality: 840 steps? 🛋️';
          body = 'Did you walk only from the bed to the fridge, $userName? Those footsteps wouldn\'t even scare an ant.';
          bodyHi = '$userName, क्या आप सिर्फ बिस्तर से फ्रिज तक ही चले हैं? थोड़ा शतपावली टहलना शुरू करें।';
          punchline = 'Kal se pakka nahi, abhi se chalo!';
        } else {
          headline = 'Friendly Nudge: Your Steps Need Love ❤️';
          body = 'A quick 15-minute evening walk will get you right back on track, $userName!';
          bodyHi = '$userName, बस १५ मिनट टहलने से आप अपने लक्ष्य के करीब पहुँच जाएंगे!';
          punchline = 'Small steps build great Yogi streaks.';
        }
        break;

      case 'missed_workout':
        if (intensity == RoastIntensity.savage) {
          headline = 'Dumbbells Are Wondering If You Broke Up With Them 💔';
          body = '$userName, skipping gym because "Mummy made Aloo Paratha"? Muscles don\'t grow on nostalgia, bro.';
          bodyHi = '$userName, "आज मूड नहीं है" बोलने से पेट की चर्बी कम नहीं होगी। डंबल आपका इंतजार कर रहे हैं!';
          punchline = 'Aloo paratha in belly, zero pump in biceps.';
        } else {
          headline = 'Workout Missed: Quick 15-Min Desi Dand Protocol? ⚡';
          body = 'No gym? No problem. 25 Hindu pushups and 50 squats right now in your room!';
          bodyHi = 'जिम नहीं जा पाए? कोई बात नहीं। कमरे में ही २५ देसी दंड और ५० बैठक लगाएं!';
          punchline = 'Discipline beats motivation every time.';
        }
        break;

      case 'swiggy_binge':
        headline = 'Midnight Biryani Alert! 🚨🍗';
        body = '$userName, your midnight delivery driver knows your address better than your relatives. Time for a 20-hour fasting reset!';
        bodyHi = '$userName, आधी रात की बिरयानी और स्वीगी का प्यार छोड़िए, सुबह गर्म नींबू पानी से बॉडी डिटॉक्स करें!';
        punchline = 'Calories don\'t sleep just because it\'s midnight.';
        break;

      default:
        headline = 'Streak Broken? The Yogi Always Rises! 🧘‍♂️✨';
        body = 'Every great master reset their routine multiple times. Today is Day 1 of your best streak yet!';
        bodyHi = 'स्ट्रीक टूटी? कोई बात नहीं। एक नया संकल्प लें और आज से फिर नई शुरुआत करें!';
        punchline = 'Karma restarts with the next right choice.';
    }

    return AIRoastMessage(
      headline: headline,
      body: body,
      bodyHindi: bodyHi,
      intensity: intensity,
      punchline: punchline,
    );
  }
}
