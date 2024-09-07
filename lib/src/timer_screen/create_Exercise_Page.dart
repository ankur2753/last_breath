import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int _repeat = 0;
  int _duration = 1;
  List<ExerciseSteps> _actions = [];
  ActionTypes _currentActionType = ActionTypes.Exercise;

  void _addAction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the current form state
      setState(() {
        _actions.add(ExerciseSteps(
          type: _currentActionType,
          duration: _duration,
        ));
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
          child: child,
        ),
      ),
    );
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate() && _actions.isNotEmpty) {
      _formKey.currentState!.save();
      final exercise = Exercise(
        // name: _exerciseName,
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
      appBar: AppBar(title: const Text('Create Exercise Set')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // TextField(
            //   controller: _controller,
            //   decoration: const InputDecoration(
            //     labelText: "Exercise Name",
            //     border: InputBorder.none,
            //   ),
            //   onChanged: (value) => setState(() => _exerciseName = value),
            // ),
            // Text(
            //   'Add Actions',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),

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
                    CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (value) =>
                          setState(() => _duration = value + 1),
                      children: List<Widget>.generate(200, (index) {
                        return Center(
                          child: Text(
                            (index + 1)
                                .toString(), // Display numbers from 1 to 60
                            style: const TextStyle(
                                fontSize: 20), // Customize text style as needed
                          ),
                        );
                      }),
                    ),
                  ),
                  child: Text(_duration.toString()),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Repeat"),
                TextButton(
                    onPressed: () => _showPicker(
                          CupertinoPicker(
                            itemExtent: 50,
                            onSelectedItemChanged: (value) =>
                                setState(() => _repeat = value),
                            looping: true,
                            children: List<Widget>.generate(60, (index) {
                              return Center(
                                child: Text(
                                  index
                                      .toString(), // Display numbers from 1 to 60
                                  style: const TextStyle(
                                      fontSize:
                                          20), // Customize text style as needed
                                ),
                              );
                            }),
                          ),
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
