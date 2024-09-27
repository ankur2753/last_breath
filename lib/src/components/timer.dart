import 'package:flutter/material.dart';
import 'package:last_breath/src/components/common_utils.dart';
import 'package:last_breath/src/constants/strings_values.dart';

import '../timer_screen/workout_model.dart';
import '../timer_screen/workout_timer.dart';

class WorkoutCountdownPage extends StatefulWidget {
  final Workout workout;

  WorkoutCountdownPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutCountdownPageState createState() => _WorkoutCountdownPageState();
}

class _WorkoutCountdownPageState extends State<WorkoutCountdownPage> {
  late WorkoutTimer _workoutTimer;

  @override
  void initState() {
    super.initState();
    _workoutTimer = WorkoutTimer(widget.workout, context);
  }

  @override
  void dispose() {
    _workoutTimer.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TimerState>(
      stream: _workoutTimer.timerState,
      initialData: TimerState(
        isRunning: false,
        currentExerciseIndex: 0,
        currentExercise: widget.workout.exercises[0],
        currentStepIndex: 0,
        currentStep: widget.workout.exercises[0].actions[0],
        currentRepetition: 1,
        remainingTime: widget.workout.exercises[0].actions[0].duration,
        totalProgress: 0.0,
      ),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        print("tp${state.totalProgress}");
        if (state.totalProgress >= 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, "/completed");
          });
        }
        double progress =
            1 - (state.remainingTime / state.currentStep.duration);
        Color gradientBottom = getBoxColor(state.currentStep.type);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(state.currentStep.type.toShortString()),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  gradientBottom,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: state.totalProgress,
                  minHeight: 5,
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: CircularProgressIndicator(
                            value: 1 - progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                        Text(
                          _formatTime(state.remainingTime),
                          style: const TextStyle(
                            fontSize: 82,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: FloatingActionButton(
                  heroTag: "reset",
                  shape: const CircleBorder(),
                  onPressed: () => _workoutTimer.stop(),
                  child: const Icon(Icons.restart_alt),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: FloatingActionButton.large(
                  onPressed: () => {
                    state.isRunning
                        ? _workoutTimer.pause()
                        : _workoutTimer.start()
                  },
                  heroTag: fabHeroTag,
                  shape: const CircleBorder(),
                  child: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  heroTag: "skip",
                  onPressed: () => _workoutTimer.moveToNextStep(),
                  child: const Icon(Icons.keyboard_double_arrow_right_sharp),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
