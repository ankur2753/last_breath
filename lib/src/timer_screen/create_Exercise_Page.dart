import 'package:flutter/material.dart';
import 'workout_model.dart';

class CreateExercisePage extends StatefulWidget {
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _repeat = 1;
  List<ExerciseSteps> _actions = [];

  String? _currentActionName;
  int _currentDuration = 30;
  ActionTypes _currentActionType = ActionTypes.Exercise;

  void _addAction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the current form state
      setState(() {
        _actions.add(ExerciseSteps(
          type: _currentActionType,
          duration: _currentDuration,
        ));
        // Reset to default or user-specified values after adding
        _currentDuration =
            30; // Optional: Reset duration field to default or keep it as it is
        _currentActionType =
            ActionTypes.Exercise; // Optional: Reset action type
      });
    }
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate() && _actions.isNotEmpty) {
      _formKey.currentState!.save();
      final exercise = Exercise(
        name: _name,
        actions: _actions,
        repeat: _repeat,
      );
      Navigator.pop(context, exercise);
    } else if (_actions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one action')),
      );
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
              decoration: InputDecoration(labelText: 'Repeat'),
              keyboardType: TextInputType.number,
              initialValue: _repeat.toString(),
              validator: (value) => int.tryParse(value!) == null
                  ? 'Please enter a valid number'
                  : null,
              onSaved: (value) => _repeat = int.parse(value!),
            ),
            Divider(),
            Text(
              'Add Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<ActionTypes>(
              value: _currentActionType,
              onChanged: (ActionTypes? value) {
                setState(() {
                  _currentActionType = value!;
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
              initialValue: _currentDuration.toString(),
              validator: (value) => int.tryParse(value!) == null
                  ? 'Please enter a valid number'
                  : null,
              onSaved: (value) => _currentDuration = int.parse(value!),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addAction,
              child: Text('Add Action'),
            ),
            SizedBox(height: 20),
            Text(
              'Actions List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _actions.length,
              itemBuilder: (context, index) {
                final action = _actions[index];
                return ListTile(
                  title: Text(
                      '${action.type.toShortString()} - ${action.duration} seconds'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _actions.removeAt(index);
                      });
                    },
                  ),
                );
              },
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
