import 'package:flutter/material.dart';
import 'package:last_breath/src/constants/enums.dart';
import 'package:uuid/uuid.dart';
import 'workoutstage.dart';
import 'timer_db_service.dart';

class TimerController extends ChangeNotifier {
  final _uuid = const Uuid();
  List<WorkoutStage> _sets = [];
  int currentStageIndex = 0;
  bool _isTimerRunning = false;
  bool isWorkoutCompleted = false;

  TimerController() {
    loadDefaultSession();
  }

  List<WorkoutStage> get workoutList => _sets;
  WorkoutStage get currentWorkout => _sets[currentStageIndex];
  bool get isTimerRunning => _isTimerRunning;

  final WorkoutStageStorageService _storageService =
      WorkoutStageStorageService();

  List<WorkoutStage> get workoutStages => _sets;

  void setCurrentStageIndex(int value) {
    if (value >= 0 && value < _sets.length) {
      currentStageIndex = value;
      notifyListeners();
    }
  }

  void addNewWorkout() {}

  void nextWorkOut() {
    if (currentStageIndex < _sets.length - 1) {
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
    _sets = [
      WorkoutStage(
        type: WorkoutTypes.prepare,
        duration: const Duration(seconds: 100),
      ),
      WorkoutStage(
        type: WorkoutTypes.rest,
        duration: const Duration(seconds: 100),
      ),
      WorkoutStage(
        type: WorkoutTypes.prepare,
        duration: const Duration(seconds: 100),
      ),
      WorkoutStage(
        type: WorkoutTypes.prepare,
        duration: const Duration(seconds: 100),
      ),
    ];
    currentStageIndex = 0;
    _isTimerRunning = false;
    isWorkoutCompleted = false;
    notifyListeners();
  }

  Future<void> saveWorkout(String workoutId) async {
    await _storageService.storeWorkout(workoutId, _sets);
  }

  Future<void> loadWorkout(String workoutId) async {
    _sets = await _storageService.retrieveWorkout(workoutId);
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
