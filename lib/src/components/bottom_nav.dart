import 'package:flutter/material.dart';
import 'dart:math';

import 'package:last_breath/src/components/timer.dart';
import 'package:last_breath/src/constants/colors.dart';
import 'package:last_breath/src/timer_screen/bottom_scroll_timers.dart';

class ConcentricCirclesBackground extends StatelessWidget {
  final Color color;
  final int circleCount;

  const ConcentricCirclesBackground({
    super.key,
    required this.color,
    this.circleCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _ConcentricCirclesPainter(color, circleCount),
      ),
    );
  }
}

class _ConcentricCirclesPainter extends CustomPainter {
  final Color color;
  final int circleCount;

  _ConcentricCirclesPainter(this.color, this.circleCount);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
        size.width / 2, size.height / 2.6); // Move center to top 3/4 of screen
    final radiusStep = min(size.width, size.height) / (circleCount * 2);

    for (int i = 0; i < circleCount; i++) {
      final radius = (i + 1) * radiusStep + 50;
      final opacity = (i / circleCount) * 0.7;
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ConcentricCirclesWidget extends StatelessWidget {
  final Color color;
  final int circleCount;

  const ConcentricCirclesWidget({
    super.key,
    required this.color,
    required this.circleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // CustomPaint(
          //   size: const Size(double.infinity, double.infinity),
          //   painter: _ConcentricCirclesPainter(color, circleCount),
          // ),
          const Align(
            alignment: Alignment(
                0, -0.3), // Adjust alignment to match the circle center
            child: TimerComponent(
              duration: 63,
              workoutId: "sadsad",
              color: redColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment
                  .bottomCenter, // Adjust alignment to match the circle center
              child: CircleButtom(circleColor: redColor),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const WorkoutListView(
      //   nextColor: Colors.white,
      // ),
    );
  }
}
