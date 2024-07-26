import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:provider/provider.dart';

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
  void didUpdateWidget(TimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _remainingTime = widget.duration;
      _timer.cancel();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final timerController =
            Provider.of<TimerController>(context, listen: false);
        if (timerController.timerState) {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _timer.cancel();
            timerController.nextWorkOut();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (context, timerController, child) {
        return Text(
          '${_remainingTime >= 3600 ? '${(_remainingTime ~/ 3600).toString().padLeft(2, '0')}:' : ''}${_remainingTime >= 60 ? '${((_remainingTime % 3600) ~/ 60).toString()}:' : ''}${(_remainingTime % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 150),
        );
      },
    );
  }
}
