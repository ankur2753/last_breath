import 'dart:math';

import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workout_db_service.dart';
import 'package:numberpicker/numberpicker.dart';

import 'workout_model.dart';

class TimerCreationPage extends StatefulWidget {
  final int prepare;
  final int work;
  final int rest;
  final int cycles;
  final int sets;
  final int restBetweenSets;
  final int coolDown;
  final String name;
  const TimerCreationPage({
    super.key,
    this.restBetweenSets = 1,
    this.coolDown = 1,
    this.cycles = 10,
    this.prepare = 10,
    this.work = 10,
    this.rest = 1,
    this.sets = 1,
    required this.name,
  });

  @override
  TimerCreationPageState createState() => TimerCreationPageState();
}

class TimerCreationPageState extends State<TimerCreationPage> {
  int prepare = 10;
  int work = 1;
  int rest = 1;
  int cycles = 10;
  int sets = 3;
  int restBetweenSets = 1;
  int coolDown = 1;
  String name = "";

  @override
  void initState() {
    //get values from parent and set it for edit case.
    prepare = widget.prepare;
    work = widget.work;
    rest = widget.rest;
    cycles = widget.cycles;
    sets = widget.sets;
    restBetweenSets = widget.restBetweenSets;
    coolDown = widget.coolDown;
    name = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '${prepare + work + rest} sec • ${cycles * sets} reps • $cycles intervals • $sets sets',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildTimerRow('Prepare', prepare, Icons.accessibility_new),
          _buildTimerRow('Work', work, Icons.fitness_center),
          _buildTimerRow('Rest', rest, Icons.timer),
          _buildTimerRow('Cycles', cycles, Icons.loop),
          _buildTimerRow('Sets', sets, Icons.repeat),
          _buildTimerRow('Rest between sets', restBetweenSets, Icons.hotel),
          _buildTimerRow('Cool down', coolDown, Icons.ac_unit),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: _startWorkout,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          child: const Text('SAVE'),
        ),
      ),
    );
  }

  Widget _buildTimerRow(String label, int givenValue, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label),
          ),
          NumberPicker(
            axis: Axis.horizontal,
            value: givenValue,
            itemWidth: 60,
            minValue: 1,
            maxValue: 100,
            infiniteLoop: true,
            selectedTextStyle: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
            textStyle: TextStyle(
              fontSize: 10,
            ),
            onChanged: (value) => _updateValue(label, value),
          ),
        ],
      ),
    );
  }

  void _updateValue(String label, int newValue) {
    setState(() {
      switch (label) {
        case 'Prepare':
          prepare = newValue;
          break;
        case 'Work':
          work = newValue;
          break;
        case 'Rest':
          rest = newValue;
          break;
        case 'Cycles':
          cycles = newValue;
          break;
        case 'Sets':
          sets = newValue;
          break;
        case 'Rest between sets':
          restBetweenSets = newValue;
          break;
        case 'Cool down':
          coolDown = newValue;
          break;
      }
    });
  }

  void _startWorkout() {
    final workout = Workout(
      name: name,
      id: Random().nextInt(5000).toString(),
      exercises: [
        Exercise(
          repeat: 1,
          actions: [
            ExerciseSteps(type: ActionTypes.Prepare, duration: prepare),
          ],
        ),
        Exercise(
          repeat: sets,
          actions: [
            ExerciseSteps(type: ActionTypes.Exercise, duration: work),
            ExerciseSteps(type: ActionTypes.Rest, duration: rest),
          ],
          restBetweenSets: restBetweenSets,
        ),
        Exercise(
          repeat: 1,
          actions: [
            ExerciseSteps(type: ActionTypes.CoolDown, duration: coolDown),
          ],
        ),
      ],
    );
    WorkoutDatabase.addWorkout(workout);
  }
}
