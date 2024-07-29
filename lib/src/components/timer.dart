import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:provider/provider.dart';

class TimerComponent extends StatefulWidget {
  final int duration;
  final String workoutId;

  const TimerComponent({
    super.key,
    required this.duration,
    required this.workoutId,
  });

  @override
  TimerComponentState createState() => TimerComponentState();
}

class TimerComponentState extends State<TimerComponent> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void didUpdateWidget(TimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.workoutId != widget.workoutId) {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
  }

  void _timerCallback(Timer timer) {
    final timerController =
        Provider.of<TimerController>(context, listen: false);
    if (timerController.isTimerRunning) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          timerController.nextWorkOut();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust font size
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.4; // Adjust percentage as needed

    return Text(
      _formatTime(_remainingTime),
      style: TextStyle(fontSize: fontSize),
    );
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> timeParts = [];
    if (hours > 0) timeParts.add(hours.toString().padLeft(2, '0'));
    if (hours > 0 || minutes > 0) {
      timeParts.add(minutes.toString().padLeft(2, '0'));
      timeParts.add(seconds.toString().padLeft(2, '0'));
    } else {
      timeParts.add(seconds.toString().padLeft(2, '0'));
    }

    return timeParts.join(':');
  }
}
