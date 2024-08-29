import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../constants/enums.dart';
import 'workout_model.dart';
import 'timer_db_service.dart';

class TimerController extends ChangeNotifier {
  final _uuid = const Uuid();
  List<ExerciseInterval> _sets = [];
  int currentStageIndex = 0;
  bool _isTimerRunning = false;
  bool isWorkoutCompleted = false;

  final WorkoutPlanService _storageService = WorkoutPlanService();

  TimerController() {
    _storageService.init();
    loadDefaultSession();
  }

  List<ExerciseInterval> get workoutList => _sets;
  ExerciseInterval get currentWorkout => _sets[currentStageIndex];
  bool get isTimerRunning => _isTimerRunning;

  List<ExerciseInterval> get workoutStages => _sets;

  void setCurrentStageIndex(int value) {
    if (value >= 0 && value < _sets.length) {
      currentStageIndex = value;
      notifyListeners();
    }
  }

  void addNewWorkout() {
    // Add logic to create a new workout plan
  }

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
      ExerciseInterval(
          type: WorkoutTypes.prepare, duration: 100, repeatCount: 1),
      ExerciseInterval(type: WorkoutTypes.rest, duration: 100, repeatCount: 1),
      ExerciseInterval(
          type: WorkoutTypes.coolDown, duration: 100, repeatCount: 1),
    ];
    currentStageIndex = 0;
    _isTimerRunning = false;
    isWorkoutCompleted = false;
    notifyListeners();
  }

  Future<void> saveWorkout(String workoutId) async {
    String id = workoutId.isNotEmpty ? workoutId : _uuid.v4();
    print("lekn");
    print(_sets.length);
    WorkoutPlan workoutPlan = WorkoutPlan(
        id: id,
        name: "Custom Workout Plan",
        intervals: _sets,
        totalDuration: _sets.fold(0, (sum, item) => sum + item.duration),
        repeatCount: 1);
    await _storageService.createWorkoutPlan(
      id: id,
      name: workoutPlan.name,
      intervals: workoutPlan.intervals,
      repeatCount: workoutPlan.repeatCount,
    );
  }

  Future<void> loadWorkout(String workoutId) async {
    WorkoutPlan? workoutPlan = await _storageService.getWorkoutPlan(workoutId);
    if (workoutPlan != null) {
      _sets = workoutPlan.intervals;
      currentStageIndex = 0;
      _isTimerRunning = false;
      isWorkoutCompleted = false;
      notifyListeners();
    }
  }

  Future<List<String>> getAllWorkoutIds() async {
    List<WorkoutPlan> workouts = await _storageService.getAllWorkoutPlans();
    print(workouts.map((plan) => plan.id).toList());
    return workouts.map((plan) => plan.id).toList();
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _storageService.deleteWorkoutPlan(workoutId);
  }

  Future<void> deleteAllWorkouts() async {
    await _storageService.clearAllWorkoutPlans();
  }

  void endWorkout() {
    // Implementation for ending the workout
  }

  void resetWorkout() {
    loadDefaultSession();
  }
}
