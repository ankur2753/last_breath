import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:last_breath/src/constants/svg_strings.dart';
import 'package:last_breath/src/settings/settings_page.dart';
import 'workout_db_service.dart';
import 'create_workout_page.dart';
import 'workout_model.dart';
import 'workout_timer_page.dart';
import 'workout_history_page.dart';

/*
* THIS PAGE IS THE PLACE TO DO CRUD OPERATIONS ON A WORKOUT
* DOES NOT CONTAINS FUNCTIONALITY RELATED TO ACTUALLY RUNNING THE TIMERS
* */
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutHistoryPage()),
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: SettingsPage(),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Workout>('workouts').listenable(),
        builder: (context, Box<Workout> box, _) {
          if (box.values.isEmpty) {
            return Column(
              children: [
                SvgPicture.string(notesListSVG),
                const Center(child: Text('No workouts yet. Create one!')),
              ],
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final workout = box.getAt(index);

              return Dismissible(
                key: Key(workout!.id), // Unique key for each item
                direction: DismissDirection.horizontal, //
                secondaryBackground: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ), // Swipe from right to left
                background: Container(
                  color: Colors.blueAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await box
                        .deleteAt(index); // Delete using the database method
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${workout.name} deleted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('navigate to edit here')));
                    //navigate to edit page here
                  }
                },
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                      '${workout.exercises.length} exercises - ${Duration(seconds: workout.totalTime).inMinutes} mins'),
                  trailing:
                      workout.isTemplate ? Icon(Icons.content_copy) : null,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateWorkoutPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create New Workout',
      ),
    );
  }
}
