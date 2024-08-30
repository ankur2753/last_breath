import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_model.dart';
import 'workout_timer.dart';

class WorkoutTimerPage extends StatefulWidget {
  final Workout workout;

  WorkoutTimerPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutTimerPageState createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage>
    with WidgetsBindingObserver {
  late WorkoutTimer _workoutTimer;
  bool _isBackgroundAudioPaused = false;

  @override
  void initState() {
    super.initState();
    _workoutTimer = WorkoutTimer(widget.workout);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _workoutTimer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in the background
      _isBackgroundAudioPaused = true;
      _workoutTimer.pause();
    } else if (state == AppLifecycleState.resumed && _isBackgroundAudioPaused) {
      // App is in the foreground again
      _isBackgroundAudioPaused = false;
      _workoutTimer.resume();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //         themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
        //     onPressed: () {
        //       themeProvider.toggleTheme();
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder<TimerState>(
        stream: _workoutTimer.timerState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final state = snapshot.data!;

          if (state.countdownTime != null) {
            return Center(
              child: Text(
                'Starting in ${state.countdownTime}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.currentExercise.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  state.currentStep.type.toString().split('.').last,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  _formatTime(state.remainingTime),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Repetition: ${state.currentRepetition}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                LinearProgressIndicator(
                  value: state.totalProgress,
                  minHeight: 10,
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: state.isRunning
                          ? _workoutTimer.pause
                          : _workoutTimer.resume,
                      child: Text(state.isRunning ? 'Pause' : 'Resume'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _workoutTimer.stop,
                      child: Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _workoutTimer.skipCurrentStep,
                      child: Text('Skip Step'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _workoutTimer.skipCurrentExercise,
                      child: Text('Skip Exercise'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _workoutTimer.start,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
