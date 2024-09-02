import 'package:flutter/material.dart';
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
    _workoutTimer = WorkoutTimer(widget.workout);
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
          Color gradientBottom = state.currentStep.type == ActionTypes.Prepare
              ? Colors.red
              : Colors.blueAccent;
          return Scaffold(
            body: Container(
              width: double.maxFinite,
              height: double.maxFinite,
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
                  Expanded(
                    child: Center(
                      child: Text(
                        _formatTime(state.remainingTime),
                        style: const TextStyle(
                            fontSize: 82, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  ///
                  ///
                  ///
                  ///BELOW IS  THE CODE FOR SHOWING PLAY BUTTON , SKIP BUTTON AND THE STATUS OF OTHER EXERCISES
                  ///
                  //
                  // SizedBox(
                  //   height: 100,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: widget.workout.exercises.length,
                  //     itemBuilder: (context, index) {
                  //       final isCurrentExercise =
                  //           index == state.currentExerciseIndex;
                  //       if (isCurrentExercise) {
                  //         return FloatingActionButton.large(
                  //           onPressed: () => {
                  //             state.isRunning
                  //                 ? _workoutTimer.pause()
                  //                 : _workoutTimer.start()
                  //           },
                  //           heroTag: fabHeroTag,
                  //           shape: const CircleBorder(),
                  //           child: Icon(state.isRunning
                  //               ? Icons.pause
                  //               : Icons.play_arrow),
                  //         );
                  //       } else if (index == (state.currentExerciseIndex + 1)) {
                  //         return FloatingActionButton(
                  //           shape: const CircleBorder(),
                  //           onPressed: () => _workoutTimer.skipToNextExercise(),
                  //           child: const Icon(
                  //               Icons.keyboard_double_arrow_right_sharp),
                  //         );
                  //       } else if (index < state.currentExerciseIndex) {
                  //         return FloatingActionButton(
                  //           onPressed: () => {},
                  //           shape: const CircleBorder(),
                  //           backgroundColor: Colors.green,
                  //           child: const Icon(
                  //             Icons.check,
                  //             color: Colors.white,
                  //           ),
                  //         );
                  //       } else {
                  //         return Container(
                  //           width: 50, // Adjust the size as needed
                  //           height: 50,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             border: Border.all(
                  //               color: Colors.purple,
                  //               width: 3.0, // Customize the border width
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //     height: 250,
                  //     child: ListView.builder(
                  //         padding: const EdgeInsets.all(10),
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: widget.workout.exercises.length,
                  //         itemBuilder: (context, index) {
                  //           if (state.currentExerciseIndex <= index) {
                  //             return Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Container(
                  //                 width: 50, // Adjust the size as needed
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   border: Border.all(
                  //                     color: Colors.green,
                  //                     width: 3.0, // Customize the border width
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           } else {
                  //             return Container(
                  //               width: 50, // Adjust the size as needed
                  //               height: 50,
                  //
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: Colors.green,
                  //                 border: Border.all(
                  //                   color: Colors.green,
                  //                   width: 3.0, // Customize the border width
                  //                 ),
                  //               ),
                  //
                  //               child: const Icon(
                  //                 Icons.check,
                  //                 color: Colors.white,
                  //               ),
                  //             );
                  //           }
                  //         }))
                ],
              ),
            ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: FloatingActionButton.large(
                    onPressed: () => {
                      state.isRunning
                          ? _workoutTimer.pause()
                          : _workoutTimer.start()
                    },
                    heroTag: fabHeroTag,
                    shape: const CircleBorder(),
                    child:
                        Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () => _workoutTimer.skipToNextExercise(),
                    child: const Icon(Icons.keyboard_double_arrow_right_sharp),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        });
  }
}
