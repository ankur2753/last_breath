import 'package:flutter/material.dart';
import 'package:last_breath/src/components/timer.dart';
import 'package:last_breath/src/settings/settings_controller.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:provider/provider.dart';

class WorkoutTimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(builder: (context, timerProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Timer Page'),
          actions: [
            IconButton.filled(
                onPressed: () {
                  final settingsController =
                      Provider.of<SettingsController>(context, listen: false);
                  final currentThemeMode = settingsController.themeMode;
                  final newThemeMode = currentThemeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                  settingsController.updateThemeMode(newThemeMode);
                },
                icon: const Icon(Icons.sunny))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TimerComponent(
                  duration: timerProvider.currenntWorkOut.duration.inSeconds),
              Expanded(
                child: ListView.builder(
                  itemCount: timerProvider.workoutList.length,
                  itemBuilder: (context, index) {
                    final workout = timerProvider.workoutList[index];
                    return GestureDetector(
                      onTap: () {
                        timerProvider.currentStage = index;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(workout.name),
                                Text('${workout.duration.inSeconds} seconds'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            timerProvider.toggleTimerState();
          },
          child: Icon(
            timerProvider.timerState ? Icons.pause : Icons.play_arrow,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
