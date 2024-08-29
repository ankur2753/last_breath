import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/timer_db_service.dart';
import 'workout_model.dart';
import 'workout_timer_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await WorkoutDatabase.getAllWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  void _navigateToWorkoutTimer(Workout workout) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutTimerPage(workout: workout),
      ),
    );
  }

  void _showCreateWorkoutDialog() {
    final nameController = TextEditingController();
    final exerciseNameController = TextEditingController();
    final durationController = TextEditingController();
    int repeat = 1;
    ActionTypes selectedActionType = ActionTypes.Exercise;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Create New Workout'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Workout Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: exerciseNameController,
                    decoration: InputDecoration(labelText: 'Exercise Name'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<ActionTypes>(
                    value: selectedActionType,
                    onChanged: (ActionTypes? newValue) {
                      setState(() {
                        selectedActionType = newValue!;
                      });
                    },
                    items: ActionTypes.values.map((ActionTypes type) {
                      return DropdownMenuItem<ActionTypes>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Action Type'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration:
                        InputDecoration(labelText: 'Duration (seconds)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Repeat: '),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => setState(() {
                          if (repeat > 1) repeat--;
                        }),
                      ),
                      Text('$repeat'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() {
                          repeat++;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      exerciseNameController.text.isNotEmpty &&
                      durationController.text.isNotEmpty) {
                    final newWorkout = Workout(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      exercises: [
                        Exercise(
                          name: exerciseNameController.text,
                          actions: [
                            ExerciseSteps(
                              type: selectedActionType,
                              duration: int.parse(durationController.text),
                            ),
                          ],
                          repeat: repeat,
                        ),
                      ],
                    );
                    await WorkoutDatabase.addWorkout(newWorkout);
                    Navigator.of(context).pop();
                    _loadWorkouts();
                  }
                },
                child: Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditWorkoutDialog(Workout workout) {
    // For simplicity, we'll just allow editing the name here.
    // You can expand this to edit exercises and other properties as needed.
    final nameController = TextEditingController(text: workout.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Workout'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Workout Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                workout.name = nameController.text;
                await WorkoutDatabase.updateWorkout(workout);
                Navigator.of(context).pop();
                _loadWorkouts();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return ListTile(
            title: Text(workout.name),
            subtitle: Text(
                '${workout.exercises.length} exercises - ${Duration(seconds: workout.totalTime).inMinutes} mins'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditWorkoutDialog(workout),
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => _navigateToWorkoutTimer(workout),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateWorkoutDialog,
        child: Icon(Icons.add),
        tooltip: 'Create New Workout',
      ),
    );
  }
}
