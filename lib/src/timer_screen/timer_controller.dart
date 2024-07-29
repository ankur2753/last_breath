import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';
import 'package:uuid/uuid.dart';

class TimerController extends ChangeNotifier {
  final _uuid = const Uuid();
  List<WorkoutStage> _workoutStages = [];
  int _currentStageIndex = 0;
  bool _isTimerRunning = false;
  bool _isWorkoutCompleted = false;

  TimerController() {
    loadDefaultSession();
  }

  List<WorkoutStage> get workoutList => _workoutStages;
  WorkoutStage get currentWorkout => _workoutStages[_currentStageIndex];
  bool get isTimerRunning => _isTimerRunning;
  int get currentStageIndex => _currentStageIndex;
  bool get isWorkoutCompleted => _isWorkoutCompleted;

  set currentStageIndex(int value) {
    if (value >= 0 && value < _workoutStages.length) {
      _currentStageIndex = value;
      notifyListeners();
    }
  }

  void nextWorkOut() {
    if (_currentStageIndex < _workoutStages.length - 1) {
      _currentStageIndex++;
      notifyListeners();
    } else {
      endWorkout();
      resetWorkout();
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
      // ... add other stages
    ];
    _currentStageIndex = 0;
    _isTimerRunning = false;
    _isWorkoutCompleted = false;
    notifyListeners();
  }

  void loadCustomSession(List<WorkoutStage> stages) {
    _workoutStages = stages;
    _currentStageIndex = 0;
    _isTimerRunning = false;
    _isWorkoutCompleted = false; // Reset workout completed flag
    notifyListeners();
  }

  void endWorkout() {
    _isTimerRunning = false;
    _isWorkoutCompleted = true;
    notifyListeners();
  }

  void resetWorkout() {
    loadDefaultSession(); // Reset to default session
  }
}
