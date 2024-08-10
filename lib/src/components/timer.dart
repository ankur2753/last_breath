import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:provider/provider.dart';

class TimerComponent extends StatefulWidget {
  final int duration;
  final String workoutId;
  final Color color;

  const TimerComponent({
    super.key,
    required this.duration,
    required this.workoutId,
    required this.color,
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
    final baseFontSize = screenWidth * 0.3; // Base font size
    final text = _formatTime(_remainingTime);
    final adjustedFontSize = baseFontSize /
        (text.length / 10)
            .clamp(1.0, 2.0); // Adjust font size based on text length

    return Text(
      text,
      style: TextStyle(
          fontSize: adjustedFontSize,
          color: widget.color,
          decoration: TextDecoration.none),
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
