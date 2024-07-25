import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';

class WorkoutTimerPage extends StatefulWidget {
  const WorkoutTimerPage({super.key});

  @override
  WorkoutTimerPageState createState() => WorkoutTimerPageState();
}

class WorkoutTimerPageState extends State<WorkoutTimerPage> {
  final WorkoutTimerService _timerService = WorkoutTimerService();

  @override
  void initState() {
    super.initState();
    // Example workout stages
    _timerService.addStage(
        WorkoutStage(name: "Warmup", duration: const Duration(seconds: 10)));
    _timerService.addStage(
        WorkoutStage(name: "Chest", duration: const Duration(seconds: 20)));
    _timerService.addStage(
        WorkoutStage(name: "Biceps", duration: const Duration(seconds: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_timerService.stages.isNotEmpty)
              Text(
                  "Current Stage: ${_timerService.stages[_timerService.currentStageIndex].name}"),
            ElevatedButton(
              onPressed: () => setState(() {
                _timerService.startWorkout();
              }),
              child: Text("Start Workout"),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                _timerService.cancelWorkout();
              }),
              child: Text("Cancel Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
