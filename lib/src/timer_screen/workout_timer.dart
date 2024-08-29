import 'dart:async';
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
      _timer = Timer.periodic(Duration(seconds: 1), _tick);
      _emitState();
    }
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
    } else {
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
    _exercises = workout.exercises;
    _currentExerciseSteps = _exercises[0].actions;
    _remainingTime = _currentExerciseSteps[0].duration;
  }

  void _emitState() {
    if (!_stateController.isClosed) {
      _stateController.add(TimerState(
        isRunning: _isRunning,
        currentExercise: _exercises[_currentExerciseIndex],
        currentStep: _currentExerciseSteps[_currentStepIndex],
        currentRepetition: _currentRepetition,
        remainingTime: _remainingTime,
        totalProgress: _calculateTotalProgress(),
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
  }
}

class TimerState {
  final bool isRunning;
  final Exercise currentExercise;
  final ExerciseSteps currentStep;
  final int currentRepetition;
  final int remainingTime;
  final double totalProgress;

  TimerState({
    required this.isRunning,
    required this.currentExercise,
    required this.currentStep,
    required this.currentRepetition,
    required this.remainingTime,
    required this.totalProgress,
  });
}
