import 'package:flutter/material.dart';
import 'package:last_breath/src/constants/strings_values.dart';
import '../components/common_utils.dart';
import '../components/timer.dart';
import 'workout_model.dart';
import 'workout_timer.dart';

class WorkoutTimerPage extends StatefulWidget {
  final Workout workout;

  WorkoutTimerPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutTimerPageState createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<TimerState>(
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.workout.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = widget.workout.exercises[index];
                        final isCurrentExercise =
                            index == state.currentExerciseIndex;
                        return Card(
                          color: Colors.grey[800],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ...exercise.actions
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final actionIndex = entry.key;
                                  final action = entry.value;
                                  final isCurrentStep = isCurrentExercise &&
                                      actionIndex == state.currentStepIndex;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: action.type == ActionTypes.Exercise
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(action.type.name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            isCurrentStep
                                                ? formatTime(
                                                    state.remainingTime)
                                                : formatTime(action.duration),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Repeat',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text(
                                          isCurrentExercise
                                              ? '${state.currentRepetition}/${exercise.repeat}'
                                              : 'x${exercise.repeat}',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: fabHeroTag,
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutCountdownPage(workout: widget.workout),
                            ),
                          )
                        },
                        child: Icon(
                            state.isRunning ? Icons.pause : Icons.play_arrow),
                      ),
                      Text(
                        formatTime(widget.workout.totalTime),
                        style: const TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
