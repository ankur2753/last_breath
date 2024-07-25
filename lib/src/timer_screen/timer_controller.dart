import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';

class TimerController extends ChangeNotifier {
  late List<WorkoutStage> _workoutStage;
  int currentStage = 0;
  WorkoutStage get currentWorkout => _workoutStage[currentStage];
  bool isTimmerRunning = false;

  void nextWorkOut() {
    currentStage++;
    notifyListeners();
  }
}
