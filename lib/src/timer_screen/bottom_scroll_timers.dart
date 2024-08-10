import 'package:flutter/material.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';
import 'package:provider/provider.dart';

class WorkoutListView extends StatelessWidget {
  final Color nextColor;
  const WorkoutListView({super.key, required this.nextColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (context, timerController, child) {
        return Scrollable(
          axisDirection: AxisDirection.left,
          viewportBuilder: (context, position) => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timerController.workoutStages.length,
            itemBuilder: (context, index) {
              Color circleColor;
              if (index < timerController.currentStageIndex) {
                circleColor = Colors.green;
              } else if (index == timerController.currentStageIndex) {
                circleColor = Colors.blue;
              } else {
                circleColor = nextColor;
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 50, // Set a fixed width for each item
                  child: Center(
                    child: CircleButtom(
                      circleColor: circleColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CircleButtom extends StatelessWidget {
  const CircleButtom({super.key, required this.circleColor});
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: circleColor,
              width: 2.0, // Set the width of the border
            ),
          ),
          child: IconButton(
            onPressed: Provider.of<TimerController>(context).toggleTimerState,
            icon: Icon(
              Provider.of<TimerController>(context).isTimerRunning
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
          ),
        ));
  }
}
