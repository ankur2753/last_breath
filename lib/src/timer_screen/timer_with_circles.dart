import 'dart:math';

import 'package:flutter/material.dart';

class ConcentricCirclesBackground extends StatelessWidget {
  final Color color;
  final int circleCount;

  const ConcentricCirclesBackground({
    super.key,
    this.color = Colors.blue,
    this.circleCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.2),
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
    final center = Offset(size.width / 2, size.height / 2);
    final radiusStep = min(size.width, size.height) / (circleCount * 2);

    for (int i = 0; i < circleCount; i++) {
      final radius = (i + 1) * radiusStep;
      final opacity = 1 - (i / circleCount);
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radiusStep;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
