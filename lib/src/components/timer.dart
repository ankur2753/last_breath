import 'dart:async';
import 'package:flutter/material.dart';

class TimerComponent extends StatefulWidget {
  final int duration;

  const TimerComponent({super.key, required this.duration});

  @override
  TimerComponentState createState() => TimerComponentState();
}

class TimerComponentState extends State<TimerComponent> {
  late int _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_remainingTime',
      style: const TextStyle(fontSize: 150),
    );
  }
}
