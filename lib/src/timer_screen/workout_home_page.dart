import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:last_breath/src/constants/strings_values.dart';
import 'package:last_breath/src/timer_screen/create_workout_page.dart';

import 'workout_model.dart';
import 'workout_timer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        automaticallyImplyLeading: true,
      ),
      // drawer: const Drawer(
      //   child: SettingsPage(),
      // ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Workout>('workouts').listenable(),
        builder: (context, Box<Workout> box, _) {
          if (box.values.isEmpty) {
            return Column(
              children: [
                SvgPicture.string(
                  notesListSVG,
                  allowDrawingOutsideViewBox: false,
                  height: MediaQuery.of(context).size.height - 200,
                  fit: BoxFit.contain,
                ),
                const Center(child: Text('No workouts yet. Create one!')),
              ],
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final workout = box.getAt(index);

              return Dismissible(
                key: Key(workout!.id),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.blueAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Delete workout
                    await box.deleteAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${workout.name} deleted')),
                    );
                  } else {
                    // Edit workout
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimerCreationPage(
                                  name: workout.name,
                                  work: workout.exercises
                                      .elementAt(1)
                                      .actions
                                      .first
                                      .duration,
                                  rest: workout.exercises
                                      .elementAt(1)
                                      .actions
                                      .last
                                      .duration,
                                  restBetweenSets: workout.exercises
                                      .elementAt(1)
                                      .restBetweenSets,
                                  sets: workout.exercises.elementAt(1).repeat,
                                  coolDown:
                                      workout.exercises.last.totalDuration,
                                  cycles: 1,
                                  prepare: workout
                                      .exercises.first.actions.first.duration,
                                )));
                  }
                },
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                      '${workout.exercises.length} exercises - ${Duration(seconds: workout.totalTime).inMinutes} mins'),
                  trailing: workout.isTemplate
                      ? const Icon(Icons.content_copy)
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkoutTimerPage(workout: workout),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: fabHeroTag,
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/create",
          );
        },
        tooltip: 'Create New Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}
