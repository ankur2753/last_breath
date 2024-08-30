import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'workout_model.dart';

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<WorkoutHistory>('workoutHistory').listenable(),
        builder: (context, Box<WorkoutHistory> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No workout history yet.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final history = box.getAt(index);
              return ListTile(
                title: Text(history!
                    .workoutId), // You might want to store and display the workout name instead
                subtitle: Text(
                    '${history.date} - ${Duration(seconds: history.duration).inMinutes} mins'),
              );
            },
          );
        },
      ),
    );
  }
}
