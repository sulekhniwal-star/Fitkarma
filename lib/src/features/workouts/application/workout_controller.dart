import 'package:flutter/foundation.dart';
import '../domain/workout_model.dart';
import '../data/workout_repository.dart';

// Simple ChangeNotifier for workout state
class WorkoutController extends ChangeNotifier {
  final WorkoutRepository _repository;
  
  List<WorkoutModel> _workouts = [];
  List<WorkoutLog> _workoutLogs = [];
  WorkoutCategory? _selectedCategory;
  bool _isLoading = false;
  String? _error;
  
  // Active workout state
  WorkoutModel? _activeWorkout;
  int _elapsedSeconds = 0;
  bool _isWorkoutRunning = false;
  bool _isWorkoutCompleted = false;

  WorkoutController(this._repository);

  // Getters
  List<WorkoutModel> get workouts => _workouts;
  List<WorkoutLog> get workoutLogs => _workoutLogs;
  WorkoutCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  WorkoutModel? get activeWorkout => _activeWorkout;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isWorkoutRunning => _isWorkoutRunning;
  bool get isWorkoutCompleted => _isWorkoutCompleted;

  List<WorkoutModel> get filteredWorkouts {
    if (_selectedCategory == null) return _workouts;
    return _workouts.where((w) => w.category == _selectedCategory).toList();
  }

  // Load all workouts
  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workouts = await _repository.getWorkouts();
    } catch (e) {
      _error = 'Failed to load workouts: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Select category
  void selectCategory(WorkoutCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Start workout
  void startWorkout(WorkoutModel workout) {
    _activeWorkout = workout;
    _elapsedSeconds = 0;
    _isWorkoutRunning = true;
    _isWorkoutCompleted = false;
    notifyListeners();
  }

  // Toggle pause
  void toggleWorkoutPause() {
    _isWorkoutRunning = !_isWorkoutRunning;
    notifyListeners();
  }

  // Increment time (called by timer)
  void incrementTime() {
    if (_isWorkoutRunning) {
      _elapsedSeconds++;
      notifyListeners();
    }
  }

  // Complete workout
  void completeWorkout() {
    _isWorkoutRunning = false;
    _isWorkoutCompleted = true;
    notifyListeners();
  }

  // Reset workout
  void resetWorkout() {
    _activeWorkout = null;
    _elapsedSeconds = 0;
    _isWorkoutRunning = false;
    _isWorkoutCompleted = false;
    notifyListeners();
  }

  // Log completed workout
  Future<void> logCompletedWorkout({
    required String oderId,
    String note = '',
    int rating = 0,
  }) async {
    if (_activeWorkout == null) return;

    final actualMinutes = (_elapsedSeconds / 60).ceil();
    final calories = _calculateCalories(_activeWorkout!, actualMinutes);

    final log = WorkoutLog(
      id: '',
      oderId: oderId,
      workoutId: _activeWorkout!.id,
      date: DateTime.now(),
      durationMinutes: actualMinutes,
      caloriesBurned: calories,
      note: note,
      rating: rating,
    );

    await _repository.logWorkout(log);
    resetWorkout();
  }

  int _calculateCalories(WorkoutModel workout, int actualMinutes) {
    if (actualMinutes >= workout.durationMinutes) {
      return workout.caloriesBurned;
    }
    return ((workout.caloriesBurned / workout.durationMinutes) * actualMinutes).round();
  }

  // Get elapsed time formatted
  String get formattedTime {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
