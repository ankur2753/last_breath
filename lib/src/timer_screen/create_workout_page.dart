import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'workout_model.dart';
import 'create_Exercise_Page.dart';

class CreateWorkoutPage extends StatefulWidget {
  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  List<Exercise> _exercises = [];

  void _addExercise() async {
    final exercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (context) => CreateExercisePage()),
    );
    if (exercise != null) {
      setState(() {
        _exercises.add(exercise);
      });
    }
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate() && _exercises.isNotEmpty) {
      _formKey.currentState!.save();
      final workout = Workout(
        id: Uuid().v4(), // Generate a unique ID
        name: _name,
        exercises: _exercises,
      );
      final box = Hive.box<Workout>('workouts');
      box.add(workout);
      Navigator.pop(context);
    } else if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one exercise')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Workout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Workout Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            SizedBox(height: 20),
            Text('Exercises:', style: Theme.of(context).textTheme.titleLarge),
            ..._exercises.map((exercise) => ListTile(
                  title: Text(exercise.name),
                  subtitle: Text('${exercise.actions.length} steps'),
                )),
            ElevatedButton(
              onPressed: _addExercise,
              child: Text('Add Exercise'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
