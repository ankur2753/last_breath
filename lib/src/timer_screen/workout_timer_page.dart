import 'package:flutter/material.dart';
import 'package:last_breath/src/constants/strings_values.dart';
import 'package:last_breath/src/settings/settings_page.dart';

import '../components/common_utils.dart';
import '../components/timer.dart';
import 'workout_model.dart';
import 'workout_timer.dart';

class WorkoutTimerPage extends StatefulWidget {
  final Workout workout;

  const WorkoutTimerPage({super.key, required this.workout});

  @override
  WorkoutTimerPageState createState() => WorkoutTimerPageState();
}

class WorkoutTimerPageState extends State<WorkoutTimerPage> {
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

  Widget getActionContainer(ExerciseSteps step) {
    bool noCard =
        step.type == ActionTypes.Prepare || step.type == ActionTypes.CoolDown;
    double padding = noCard ? 18.0 : 8.0;
    EdgeInsets margin = noCard
        ? const EdgeInsets.symmetric(vertical: 10)
        : const EdgeInsets.only(top: 8);
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: padding),
      decoration: BoxDecoration(
        color: getBoxColor(step.type),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(step.type.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(formatTime(step.duration),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget getExerciseContainer(Exercise exercise) {
    if (exercise.actions.length == 1) {
      return getActionContainer(exercise.actions.first);
    }
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ...exercise.actions.asMap().entries.map((entry) {
              return getActionContainer(entry.value);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Repeat', style: TextStyle(color: Colors.white)),
                  Text(
                    'x${exercise.repeat}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const Drawer(child: SettingsPage()),
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
                        return getExerciseContainer(exercise);
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
