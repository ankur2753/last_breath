import 'dart:async';

import 'workout_model.dart';

class WorkoutTimerService {
  List<ExerciseInterval> stages = [];
  int currentStageIndex = 0;
  Timer? _timer;

  void startWorkout() {
    if (stages.isEmpty) return;
    currentStageIndex = 0;
    _startStage(stages[currentStageIndex]);
  }

  void _startStage(ExerciseInterval stage) {
    _timer?.cancel(); // Cancel any existing timer if it exists
    _timer = Timer(Duration(seconds: stage.duration), _nextStage);
  }

  void _nextStage() {
    if (currentStageIndex < stages.length - 1) {
      currentStageIndex++;
      _startStage(stages[currentStageIndex]);
    } else {
      print("Workout complete!");
      // Handle workout completion
    }
  }

  void addStage(ExerciseInterval stage) {
    stages.add(stage);
  }

  void cancelWorkout() {
    _timer?.cancel();
  }
}
