import 'package:pocketbase/pocketbase.dart';
import '../domain/workout_model.dart';

class WorkoutRepository {
  final PocketBase pb;
  
  WorkoutRepository(this.pb);

  // Get all workouts from the server
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final records = await pb.collection('workouts').getFullList(
        sort: '-created',
      );
      
      return records.map((record) {
        final data = record.toJson();
        return WorkoutModel.fromJson(data);
      }).toList();
    } catch (e) {
      // Return local seed data if server fails
      return _getSeedWorkouts();
    }
  }

  // Get workouts by category
  Future<List<WorkoutModel>> getWorkoutsByCategory(WorkoutCategory category) async {
    try {
      final records = await pb.collection('workouts').getFullList(
        filter: 'category = "${category.name}"',
        sort: '-created',
      );
      
      return records.map((record) => WorkoutModel.fromJson(record.toJson())).toList();
    } catch (e) {
      return _getSeedWorkouts().where((w) => w.category == category).toList();
    }
  }

  // Get workout by ID
  Future<WorkoutModel?> getWorkoutById(String id) async {
    try {
      final record = await pb.collection('workouts').getOne(id);
      return WorkoutModel.fromJson(record.toJson());
    } catch (e) {
      return _getSeedWorkouts().firstWhere(
        (w) => w.id == id,
        orElse: () => _getSeedWorkouts().first,
      );
    }
  }

  // Log a workout
  Future<void> logWorkout(WorkoutLog log) async {
    await pb.collection('workout_logs').create(body: log.toJson());
  }

  // Get user's workout logs
  Future<List<WorkoutLog>> getWorkoutLogs(String oderId, {int limit = 30}) async {
    try {
      final records = await pb.collection('workout_logs').getList(
        filter: 'user = "$oderId"',
        sort: '-date',
      );
      
      return records.items.map((record) => WorkoutLog.fromJson(record.toJson())).toList();
    } catch (e) {
      return [];
    }
  }

  // Get today's workout count
  Future<int> getTodayWorkoutCount(String oderId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    try {
      final records = await pb.collection('workout_logs').getList(
        filter: 'user = "$oderId" && date >= "${startOfDay.toIso8601String()}" && date < "${endOfDay.toIso8601String()}"',
      );
      return records.totalItems;
    } catch (e) {
      return 0;
    }
  }

  // Seed data for offline/demo mode
  List<WorkoutModel> _getSeedWorkouts() {
    return [
      // Yoga Workouts
      const WorkoutModel(
        id: 'yoga_1',
        title: 'Surya Namaskar for Beginners',
        titleHindi: 'शुरुआती के लिए सूर्य नमस्कार',
        description: 'Start your day with 12 powerful poses that energize your entire body.',
        category: WorkoutCategory.yoga,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 50,
        benefits: ['Improves flexibility', 'Boosts metabolism', 'Calms mind'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'yoga_2',
        title: 'Yoga for Weight Loss',
        titleHindi: 'वजन घटाने के लिए योग',
        description: 'Dynamic yoga sequence designed to burn calories and build lean muscle.',
        category: WorkoutCategory.yoga,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 15,
        caloriesBurned: 100,
        benefits: ['Burns calories', 'Tones muscles', 'Reduces stress'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'yoga_3',
        title: 'Morning Energizing Flow',
        titleHindi: 'सुबह की ऊर्जावान क्रिया',
        description: 'Wake up your body with this invigorating morning yoga sequence.',
        category: WorkoutCategory.yoga,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 12,
        caloriesBurned: 60,
        benefits: ['Increases energy', 'Improves circulation', 'Boosts mood'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'yoga_4',
        title: 'Evening Relaxation Yoga',
        titleHindi: 'शाम का आराम योग',
        description: 'Unwind after a long day with gentle stretches and breathing exercises.',
        category: WorkoutCategory.yoga,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 30,
        benefits: ['Relaxes body', 'Reduces stress', 'Improves sleep'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'yoga_5',
        title: 'Pranayama Deep Dive',
        titleHindi: 'प्राणायाम गहन अभ्यास',
        description: 'Master the art of breathing with advanced pranayama techniques.',
        category: WorkoutCategory.yoga,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 8,
        caloriesBurned: 20,
        benefits: ['Improves lung capacity', 'Reduces anxiety', 'Balances energy'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),

      // Bollywood Dance Workouts
      const WorkoutModel(
        id: 'bollywood_1',
        title: 'Kala Chashma Cardio',
        titleHindi: 'काला चश्मा कार्डियो',
        description: 'High-energy dance workout inspired by the hit song Kala Chashma.',
        category: WorkoutCategory.bollywood,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 10,
        caloriesBurned: 80,
        benefits: ['Burns fat', 'Improves coordination', 'Fun workout'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'bollywood_2',
        title: 'Gallan Goodiyaan Dance',
        titleHindi: 'गल्लन गुडियां डांस',
        description: 'Get ready to shake a leg with this energetic Bollywood dance routine.',
        category: WorkoutCategory.bollywood,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 12,
        caloriesBurned: 95,
        benefits: ['Full body workout', 'Boosts energy', 'Great cardio'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'bollywood_3',
        title: 'Badtameez Dil Fitness',
        titleHindi: 'बद्तमीज दिल फिटनेस',
        description: 'A fun dance fitness routine that will get your heart pumping.',
        category: WorkoutCategory.bollywood,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 70,
        benefits: ['Fun cardio', 'Improves rhythm', 'Releases stress'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'bollywood_4',
        title: 'Bollywood Party Workout',
        titleHindi: 'बॉलीवुड पार्टी वर्कआउट',
        description: 'Dance like you are at a Bollywood party!',
        category: WorkoutCategory.bollywood,
        difficulty: WorkoutDifficulty.advanced,
        durationMinutes: 15,
        caloriesBurned: 120,
        benefits: ['Maximum calorie burn', 'Great for parties', 'Fun experience'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'bollywood_5',
        title: 'Sheila Ki Jawani Fat Burn',
        titleHindi: 'शीला की जवानी फैट बर्न',
        description: 'Sizzling dance workout to burn fat and have fun.',
        category: WorkoutCategory.bollywood,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 10,
        caloriesBurned: 85,
        benefits: ['Fat burning', 'Tones body', 'Entertaining'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),

      // Desi Workouts (Household Items)
      const WorkoutModel(
        id: 'desi_1',
        title: 'Bottle Bicep Curls',
        titleHindi: 'बोतल से बाइसेप कर्ल',
        description: 'Use water bottles as dumbbells for arm exercises.',
        category: WorkoutCategory.desi,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 8,
        caloriesBurned: 40,
        equipmentNeeded: ['2 water bottles (1-2L)'],
        benefits: ['Builds arm strength', 'No gym needed', 'Convenient'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'desi_2',
        title: 'Dupatta Resistance Band',
        titleHindi: 'दुपट्टा रेजिस्टेंस बैंड',
        description: 'Use your dupatta as a resistance band for full body toning.',
        category: WorkoutCategory.desi,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 50,
        equipmentNeeded: ['1 dupatta or scarf'],
        benefits: ['Tones muscles', 'Improves flexibility', 'No equipment needed'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'desi_3',
        title: 'Chawal ki Bori Squats',
        titleHindi: 'चावल की बोरी से स्क्वाट्स',
        description: 'Use a rice bag for weighted squats at home.',
        category: WorkoutCategory.desi,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 12,
        caloriesBurned: 70,
        equipmentNeeded: ['Rice bag (5-10 kg)'],
        benefits: ['Builds leg strength', 'Burns calories', 'No gym required'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'desi_4',
        title: 'Stairs Cardio HIIT',
        titleHindi: 'सीढ़ियों पर कार्डियो HIIT',
        description: 'High-intensity workout using staircase in your home.',
        category: WorkoutCategory.desi,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 15,
        caloriesBurned: 120,
        equipmentNeeded: ['Stairs or step'],
        benefits: ['Excellent cardio', 'Burns fat', 'Builds endurance'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'desi_5',
        title: 'Zameen pe Yoga',
        titleHindi: 'जमीन पर योग',
        description: 'Floor-based yoga and stretching exercises.',
        category: WorkoutCategory.desi,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 35,
        equipmentNeeded: ['Yoga mat or blanket'],
        benefits: ['Improves flexibility', 'Relaxes body', 'Beginner friendly'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),

      // HIIT Workouts
      const WorkoutModel(
        id: 'hiit_1',
        title: '7-Minute Full Body Blast',
        titleHindi: '7 मिनट फुल बॉडी ब्लास्ट',
        description: 'Quick but effective full body HIIT workout.',
        category: WorkoutCategory.hiit,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 7,
        caloriesBurned: 80,
        benefits: ['Efficient workout', 'Burns calories', 'No equipment'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'hiit_2',
        title: 'Tabata No Equipment',
        titleHindi: 'बिना उपकरण के टबाटा',
        description: 'Classic Tabata protocol - 20 seconds work, 10 seconds rest.',
        category: WorkoutCategory.hiit,
        difficulty: WorkoutDifficulty.advanced,
        durationMinutes: 10,
        caloriesBurned: 100,
        benefits: ['High calorie burn', 'Builds stamina', 'Quick workout'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'hiit_3',
        title: 'Core & Abs Destroyer',
        titleHindi: 'कोर और एब्स डिस्ट्रॉयर',
        description: 'Intense core workout to strengthen your midsection.',
        category: WorkoutCategory.hiit,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 8,
        caloriesBurned: 60,
        benefits: ['Stronger core', 'Better posture', 'Flatter stomach'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'hiit_4',
        title: 'Lower Body Burner',
        titleHindi: 'लोअर बॉडी बर्नर',
        description: 'Squat and lunge focused workout for legs and glutes.',
        category: WorkoutCategory.hiit,
        difficulty: WorkoutDifficulty.intermediate,
        durationMinutes: 12,
        caloriesBurned: 90,
        benefits: ['Tones legs', 'Builds glutes', 'Burns fat'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'hiit_5',
        title: 'Upper Body Strength',
        titleHindi: 'अपर बॉडी स्ट्रेंथ',
        description: 'Push-up and plank based upper body workout.',
        category: WorkoutCategory.hiit,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 55,
        benefits: ['Builds upper body', 'No weights needed', 'Tones arms'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),

      // Cardio Workouts
      const WorkoutModel(
        id: 'cardio_1',
        title: 'Morning Walk Routine',
        titleHindi: 'सुबह की सैर रूटीन',
        description: 'Start your day with a refreshing morning walk.',
        category: WorkoutCategory.cardio,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 20,
        caloriesBurned: 80,
        benefits: ['Low impact', 'Good for beginners', 'Energizing'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
      const WorkoutModel(
        id: 'cardio_2',
        title: 'Jumping Jacks & More',
        titleHindi: 'जंपिंग जैक्स और ज्यादा',
        description: 'Classic cardio exercises to get your heart rate up.',
        category: WorkoutCategory.cardio,
        difficulty: WorkoutDifficulty.beginner,
        durationMinutes: 10,
        caloriesBurned: 70,
        benefits: ['Full body cardio', 'No equipment', 'Fun'],
        youtubeVideoId: 'dQw4w9WgXcQ',
      ),
    ];
  }
}
