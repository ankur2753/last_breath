import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/workout_model.dart';

String formatTime(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

Color getBoxColor(ActionTypes type) {
  switch (type) {
    case ActionTypes.CoolDown:
      return Colors.lightBlue;
    case ActionTypes.Prepare:
      return Colors.blueAccent;
    case ActionTypes.Exercise:
      return Colors.green;
    case ActionTypes.Rest:
      return Colors.red;
  }
}
