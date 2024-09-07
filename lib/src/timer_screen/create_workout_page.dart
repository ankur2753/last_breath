import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive/hive.dart';
import 'package:last_breath/src/components/common_utils.dart';
import 'package:last_breath/src/components/expandable_fab.dart';
import 'package:last_breath/src/timer_screen/workout_db_service.dart';
import 'package:uuid/uuid.dart';
import 'workout_model.dart';
import 'create_Exercise_Page.dart';

/*
* THIS REUSABLE PAGE FOR CREATING AND EDITING A WORKOUT AS A WHOLE
* */
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
      MaterialPageRoute(
        builder: (context) => CreateExercisePage(),
        fullscreenDialog: true,
        maintainState: true,
      ),
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
      WorkoutDatabase.addWorkout(workout);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout Saved')),
      );
      Navigator.pop(context);
    } else if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one exercise')),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 900,
                child: ListView.builder(
                  itemCount: _exercises.isEmpty ? 1 : _exercises.length,
                  itemBuilder: (context, index) {
                    if (_exercises.isEmpty) {
                      return const Card(
                        color: Colors.blueGrey,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "NO EXERCISE SET FOUND, \n try adding exercises by clicking on the + icon",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }
                    final exercise = _exercises[index];
                    return Card(
                      color: Colors.grey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ...exercise.actions.asMap().entries.map((entry) {
                              final action = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: action.type == ActionTypes.Exercise
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(action.type.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Text(formatTime(action.duration),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Repeat',
                                      style: TextStyle(color: Colors.white)),
                                  Text('x${exercise.repeat}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        initialOpen: false,
        overlayStyle: const ExpandableFabOverlayStyle(blur: 5),
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: _addExercise,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: _saveWorkout,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
