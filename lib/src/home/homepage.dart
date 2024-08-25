import 'package:flutter/material.dart';
import 'package:last_breath/src/components/bottom_nav.dart';
import 'package:last_breath/src/components/timer.dart';
import 'package:last_breath/src/constants/colors.dart';
import 'package:last_breath/src/settings/settings_page.dart';
import 'package:last_breath/src/timer_screen/bottom_scroll_timers.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TimerController _timerController = TimerController();

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: SettingsPage(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _timerController.loadDefaultSession();
              },
              child: Text('Load Default Session'),
            ),
            ElevatedButton(
              onPressed: () async {
                // var workoutUniqueID = Uuid().v4();
                // await _timerController.saveWorkout(workoutUniqueID);
                Navigator.pushNamed(context, "/saveWorkout");
              },
              child: Text('Save Workout'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _timerController.loadWorkout('workout1');
              },
              child: Text('Load Workout'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _timerController.deleteWorkout('workout1');
              },
              child: Text('Delete Workout'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _timerController.deleteAllWorkouts();
              },
              child: Text('Delete All Workouts'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/completed');
              },
              child: Text('Go To workouts'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _timerController.getAllWorkoutIds();
              },
              child: Text('Get All Workouts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConcentricCirclesWidget(
                            color: redColor,
                            circleCount: 10,
                          )),
                );
              },
              child: const Text('Go to Timer Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkoutListView(
                            nextColor: redColor,
                          )),
                );
              },
              child: const Text('Go nosda'),
            ),
          ],
        ),
      ),
    );
  }
}
