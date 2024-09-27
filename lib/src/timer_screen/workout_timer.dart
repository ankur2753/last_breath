import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_breath/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

import 'workout_model.dart';

class WorkoutTimer {
  final Workout workout;
  late List<Exercise> _exercises;
  int _currentExerciseIndex = 0;
  int _currentStepIndex = 0;
  int _currentRepetition = 1;
  int _remainingTime = 0;
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  BuildContext context;

  StreamController<TimerState> _stateController =
      StreamController<TimerState>.broadcast();
  Stream<TimerState> get timerState => _stateController.stream;

  WorkoutTimer(this.workout, this.context) {
    _exercises = workout.exercises;
    _remainingTime = _exercises[0].actions[0].duration;
  }

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _startCountdown();
    }
  }

  void _startCountdown() {
    int countdown = 0;
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

  void _tick(Timer timer) {
    if (_remainingTime > 0) {
      _remainingTime--;
      if (_remainingTime <= 3 && _remainingTime > 0) {
        _playSound('countdown');
      }
    } else {
      _playSound('beep');
      if (_currentExerciseIndex < _exercises.length - 1) {
        moveToNextStep();
      }
    }
    _emitState();
  }

  void moveToNextStep() {
    _currentStepIndex++;
    if (_currentStepIndex >= _exercises[_currentExerciseIndex].actions.length) {
      //all steps in current exercise are done
      _currentStepIndex = 0;
      _currentRepetition++;
      //TODO: ADD some way to utilize the rest between sets here.
      if (_currentRepetition > _exercises[_currentExerciseIndex].repeat) {
        //all the repetition is completed
        _moveToNextExercise();
      }
    }
    _emitState();
  }

  void _moveToNextExercise() {
    _currentExerciseIndex++;
    _currentRepetition = 1;
    _currentStepIndex = 0;
    if (_currentExerciseIndex < _exercises.length) {
      _remainingTime =
          _exercises[_currentExerciseIndex].actions[_currentStepIndex].duration;
    } else {
      _isRunning = false;
      _timer?.cancel();
    }
  }

  void _reset() {
    _currentExerciseIndex = 0;
    _currentStepIndex = 0;
    _currentRepetition = 1;
    if (_exercises.isNotEmpty) {
      _remainingTime = _exercises[0].actions[0].duration;
    } else {
      _remainingTime = 0;
    }
    _isRunning = false;
  }

  void _emitState({int? countdownTime}) {
    if (!_stateController.isClosed) {
      double progress = _calculateTotalProgress();
      _stateController.add(TimerState(
        isRunning: _isRunning,
        currentExerciseIndex: _currentExerciseIndex,
        currentExercise: _exercises[_currentExerciseIndex],
        currentStepIndex: _currentStepIndex,
        currentStep:
            _exercises[_currentExerciseIndex].actions[_currentStepIndex],
        currentRepetition: _currentRepetition,
        remainingTime: _remainingTime,
        totalProgress: progress,
        countdownTime: countdownTime,
      ));
    }
  }

  double _calculateTotalProgress() {
    int totalTime = workout.totalTime;
    int elapsedTime = 0;

    for (int i = 0; i < _currentExerciseIndex; i++) {
      elapsedTime += _exercises[i].totalDuration * _exercises[i].repeat;
    }

    elapsedTime += (_exercises[_currentExerciseIndex].totalDuration *
        (_currentRepetition - 1));

    for (int i = 0; i < _currentStepIndex; i++) {
      elapsedTime += _exercises[_currentExerciseIndex].actions[i].duration;
    }

    elapsedTime +=
        _exercises[_currentExerciseIndex].actions[_currentStepIndex].duration -
            _remainingTime;

    return totalTime > 0 ? elapsedTime / totalTime : 0.0;
  }

  Future<void> _playSound(String soundName) async {
    if (Provider.of<SettingsController>(context, listen: false)
        .isAudioEnabled) {
      String audioAsset = 'sounds/$soundName.mp3';
      await _audioPlayer.play(AssetSource(audioAsset));
    }
  }

  void dispose() {
    _timer?.cancel();
    _stateController.close();
    _audioPlayer.dispose();
  }
}

class TimerState {
  final bool isRunning;
  final int currentExerciseIndex;
  final Exercise currentExercise;
  final int currentStepIndex;
  final ExerciseSteps currentStep;
  final int currentRepetition;
  final int remainingTime;
  final double totalProgress;
  final int? countdownTime;
  final int restBetweenSets;

  TimerState({
    required this.isRunning,
    required this.currentExerciseIndex,
    required this.currentExercise,
    required this.currentStepIndex,
    required this.currentStep,
    required this.currentRepetition,
    required this.remainingTime,
    required this.totalProgress,
    this.countdownTime,
    this.restBetweenSets = 0,
  });
}
