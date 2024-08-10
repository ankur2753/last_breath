import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'workoutstage.dart';
import 'timer_db_service.dart';

class TimerController extends ChangeNotifier {
  final _uuid = const Uuid();
  List<WorkoutStage> _workoutStages = [];
  int currentStageIndex = 0;
  bool _isTimerRunning = false;
  bool isWorkoutCompleted = false;

  TimerController() {
    loadDefaultSession();
  }

  List<WorkoutStage> get workoutList => _workoutStages;
  WorkoutStage get currentWorkout => _workoutStages[currentStageIndex];
  bool get isTimerRunning => _isTimerRunning;

  final WorkoutStageStorageService _storageService =
      WorkoutStageStorageService();

  List<WorkoutStage> get workoutStages => _workoutStages;

  void setCurrentStageIndex(int value) {
    if (value >= 0 && value < _workoutStages.length) {
      currentStageIndex = value;
      notifyListeners();
    }
  }

  void nextWorkOut() {
    if (currentStageIndex < _workoutStages.length - 1) {
      currentStageIndex++;
      notifyListeners();
    } else {
      endWorkout();
      //resetWorkout();
    }
  }

  void toggleTimerState() {
    _isTimerRunning = !_isTimerRunning;
    notifyListeners();
  }

  void loadDefaultSession() {
    _workoutStages = [
      WorkoutStage(
          id: _uuid.v4(),
          name: "Warm-up",
          duration: const Duration(seconds: 10)),
      WorkoutStage(
          id: _uuid.v4(),
          name: "Chest",
          duration: const Duration(seconds: 100)),
      WorkoutStage(
          id: _uuid.v4(),
          name: "Biceps",
          duration: const Duration(seconds: 200)),
      WorkoutStage(
          id: _uuid.v4(), name: "legs", duration: const Duration(seconds: 10)),
      WorkoutStage(
          id: _uuid.v4(), name: "pecs", duration: const Duration(seconds: 100)),
      WorkoutStage(
          id: _uuid.v4(), name: "lats", duration: const Duration(seconds: 200)),
      WorkoutStage(
          id: _uuid.v4(),
          name: "forearms",
          duration: const Duration(seconds: 10)),
      WorkoutStage(
          id: _uuid.v4(), name: "core", duration: const Duration(seconds: 10)),
      WorkoutStage(
          id: _uuid.v4(),
          name: "glutes",
          duration: const Duration(seconds: 20)),
    ];
    currentStageIndex = 0;
    _isTimerRunning = false;
    isWorkoutCompleted = false;
    notifyListeners();
  }

  Future<void> saveWorkout(String workoutId) async {
    await _storageService.storeWorkout(workoutId, _workoutStages);
  }

  Future<void> loadWorkout(String workoutId) async {
    _workoutStages = await _storageService.retrieveWorkout(workoutId);
    currentStageIndex = 0;
    _isTimerRunning = false;
    isWorkoutCompleted = false;
    notifyListeners();
  }

  Future<List<String>> getAllWorkoutIds() async {
    List<String> wokouts = await _storageService.retrieveAllWorkoutIds();
    print(wokouts);
    return wokouts;
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _storageService.clearWorkout(workoutId);
  }

  Future<void> deleteAllWorkouts() async {
    await _storageService.clearAllWorkouts();
  }

  void endWorkout() {
    // Implementation for ending the workout
  }

  void resetWorkout() {
    loadDefaultSession();
  }
}
