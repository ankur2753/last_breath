import 'dart:async';

import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';

class TimerController extends ChangeNotifier {
  late List<WorkoutStage> _workoutStage = [
    WorkoutStage(name: "warmup", duration: const Duration(seconds: 10)),
    WorkoutStage(name: "chest", duration: const Duration(seconds: 100)),
    WorkoutStage(name: "biceps", duration: const Duration(seconds: 200)),
    WorkoutStage(name: "legs", duration: const Duration(seconds: 10)),
    WorkoutStage(name: "pecs", duration: const Duration(seconds: 100)),
    WorkoutStage(name: "lats", duration: const Duration(seconds: 200)),
    WorkoutStage(name: "forearms", duration: const Duration(seconds: 10)),
    WorkoutStage(name: "core", duration: const Duration(seconds: 100)),
    WorkoutStage(name: "glutes", duration: const Duration(seconds: 200)),
  ];
  int _currentStage = 0;
  List<WorkoutStage> get workoutList => _workoutStage;
  WorkoutStage get currenntWorkOut => _workoutStage[currentStage];
  bool _isTimmerRunning = false;

  bool get timerState => _isTimmerRunning;
  int get currentStage => _currentStage;

  set currentStage(int value) {
    _currentStage = value;
    notifyListeners();
  }

  void nextWorkOut() {
    currentStage++;
    notifyListeners();
  }

  void toggleTimerState() {
    _isTimmerRunning = !_isTimmerRunning;
    notifyListeners();
  }

  void loadSession() {
    //load the list of workout stages
    _workoutStage = [
      WorkoutStage(name: "warmup", duration: const Duration(seconds: 10)),
      WorkoutStage(name: "test", duration: const Duration(seconds: 100)),
      WorkoutStage(name: "asd", duration: const Duration(seconds: 200)),
    ];
    notifyListeners();
  }
}
