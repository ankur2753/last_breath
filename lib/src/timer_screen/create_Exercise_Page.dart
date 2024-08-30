import 'package:flutter/material.dart';
import 'workout_model.dart';

class CreateExercisePage extends StatefulWidget {
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int _duration = 30;
  int _repeat = 1;
  ActionTypes _actionType = ActionTypes.Exercise;

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final exercise = Exercise(
        name: _name,
        actions: [ExerciseSteps(type: _actionType, duration: _duration)],
        repeat: _repeat,
        description: _description,
      );
      Navigator.pop(context, exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Exercise')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Exercise Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            DropdownButtonFormField<ActionTypes>(
              value: _actionType,
              onChanged: (ActionTypes? value) {
                setState(() {
                  _actionType = value!;
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Duration (seconds)'),
              keyboardType: TextInputType.number,
              initialValue: _duration.toString(),
              validator: (value) => int.tryParse(value!) == null
                  ? 'Please enter a valid number'
                  : null,
              onSaved: (value) => _duration = int.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Repeat'),
              keyboardType: TextInputType.number,
              initialValue: _repeat.toString(),
              validator: (value) => int.tryParse(value!) == null
                  ? 'Please enter a valid number'
                  : null,
              onSaved: (value) => _repeat = int.parse(value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExercise,
              child: Text('Save Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
