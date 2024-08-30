import 'dart:async';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'workout_model.dart';

class WorkoutTimer {
  final Workout workout;
  late List<Exercise> _exercises;
  late List<ExerciseSteps> _currentExerciseSteps;
  int _currentExerciseIndex = 0;
  int _currentStepIndex = 0;
  int _currentRepetition = 1;
  int _remainingTime = 0;
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamController<TimerState> _stateController =
      StreamController<TimerState>.broadcast();
  Stream<TimerState> get timerState => _stateController.stream;

  WorkoutTimer(this.workout) {
    _exercises = workout.exercises;
    _currentExerciseSteps = _exercises[0].actions;
    _remainingTime = _currentExerciseSteps[0].duration;
  }

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _startCountdown();
    }
  }

  void _startCountdown() {
    int countdown = 5;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        _playSound('countdown');
        _emitState(countdownTime: countdown);
        countdown--;
      } else {
        timer.cancel();
        _playSound('start');
        _timer = Timer.periodic(Duration(seconds: 1), _tick);
        _emitState();
      }
    });
  }

  void pause() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
      _emitState();
    }
  }

  void resume() {
    start();
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _reset();
    _emitState();
  }

  Future<void> _playSound(String soundName) async {
    String audioAsset = 'assets/sounds/$soundName.mp3';
    await _audioPlayer.play(AssetSource(audioAsset));
  }

  void _tick(Timer timer) {
    if (_remainingTime > 0) {
      _remainingTime--;
      if (_remainingTime <= 3 && _remainingTime > 0) {
        _playSound('countdown');
      }
    } else {
      _playSound('beep');
      _moveToNextStep();
    }
    _emitState();
  }

  void _moveToNextStep() {
    _currentStepIndex++;
    if (_currentStepIndex >= _currentExerciseSteps.length) {
      _currentStepIndex = 0;
      _currentRepetition++;
      if (_currentRepetition > _exercises[_currentExerciseIndex].repeat) {
        _moveToNextExercise();
      }
    }
    if (_currentExerciseIndex < _exercises.length) {
      _remainingTime = _currentExerciseSteps[_currentStepIndex].duration;
    } else {
      stop(); // Workout completed
    }
  }

  void _moveToNextExercise() {
    _currentExerciseIndex++;
    _currentRepetition = 1;
    if (_currentExerciseIndex < _exercises.length) {
      _currentExerciseSteps = _exercises[_currentExerciseIndex].actions;
      _currentStepIndex = 0;
    }
  }

  void _reset() {
    _currentExerciseIndex = 0;
    _currentStepIndex = 0;
    _currentRepetition = 1;
    if (_exercises.isNotEmpty) {
      _currentExerciseSteps = _exercises[0].actions;
      _remainingTime = _currentExerciseSteps[0].duration;
    } else {
      _remainingTime = 0;
    }
    _isRunning = false;
  }

  void skipCurrentExercise() {
    _moveToNextExercise();
    _emitState();
  }

  void skipCurrentStep() {
    _moveToNextStep();
    _emitState();
  }

  void _emitState({int? countdownTime}) {
    if (!_stateController.isClosed) {
      _stateController.add(TimerState(
        isRunning: _isRunning,
        currentExercise: _exercises[_currentExerciseIndex],
        currentStep: _currentExerciseSteps[_currentStepIndex],
        currentRepetition: _currentRepetition,
        remainingTime: _remainingTime,
        totalProgress: _calculateTotalProgress(),
        countdownTime: countdownTime,
      ));
    }
  }

  double _calculateTotalProgress() {
    int totalTime = workout.totalTime;
    int elapsedTime = 0;

    for (int i = 0; i < _currentExerciseIndex; i++) {
      elapsedTime += _exercises[i].totalDuration;
    }

    elapsedTime += (_exercises[_currentExerciseIndex].totalDuration ~/
            _exercises[_currentExerciseIndex].repeat) *
        (_currentRepetition - 1);

    for (int i = 0; i < _currentStepIndex; i++) {
      elapsedTime += _currentExerciseSteps[i].duration;
    }

    elapsedTime +=
        _currentExerciseSteps[_currentStepIndex].duration - _remainingTime;

    return elapsedTime / totalTime;
  }

  void dispose() {
    _timer?.cancel();
    _stateController.close();
    _audioPlayer.dispose();
  }
}

class TimerState {
  final bool isRunning;
  final Exercise currentExercise;
  final ExerciseSteps currentStep;
  final int currentRepetition;
  final int remainingTime;
  final double totalProgress;
  final int? countdownTime;

  TimerState({
    required this.isRunning,
    required this.currentExercise,
    required this.currentStep,
    required this.currentRepetition,
    required this.remainingTime,
    required this.totalProgress,
    this.countdownTime,
  });
}
