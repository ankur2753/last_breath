import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_breath/src/constants/colors.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/v4.dart';
import 'workout_model.dart';

/*
* This page if only for creating a stage in a workout
* */
class CreateExercisePage extends StatefulWidget {
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  int _repeat = 1;
  int _duration = 10;
  String _exerciseName = "";
  List<ExerciseSteps> _actions = [];
  TextEditingController _controller = TextEditingController();
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

  void _showPicker(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate() && _actions.isNotEmpty) {
      _formKey.currentState!.save();
      final exercise = Exercise(
        name: _exerciseName,
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
      appBar: AppBar(title: const Text('Create Exercise')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Exercise Name",
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() => _exerciseName = value),
            ),
            // Text(
            //   'Add Actions',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Action Type :"),
                DropdownButton<ActionTypes>(
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
                  // decoration: const  InputDecoration(labelText: 'Action Type'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Duration (in seconds)"),
                TextButton(
                  onPressed: () => _showPicker(
                    NumberPicker(
                      minValue: 1,
                      maxValue: 60,
                      value: _duration,
                      onChanged: (value) => setState(() => _duration = value),
                    ),
                  ),
                  child: Text(_duration.toString()),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Repeat (in seconds)"),
                TextButton(
                    onPressed: () => _showPicker(
                          NumberPicker(
                              minValue: 0,
                              maxValue: 100,
                              value: _repeat,
                              onChanged: (value) =>
                                  setState(() => _repeat = value)),
                        ),
                    child: Text(_repeat.toString()))
              ],
            ),
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
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _saveExercise,
        icon: const Icon(Icons.save),
        label: const Text("Save"),
      ),
    );
  }
}
