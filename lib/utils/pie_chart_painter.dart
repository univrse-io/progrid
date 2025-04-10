import 'dart:math';

import 'package:flutter/material.dart';

// paints a pie chart, used specifically for map marker clusters
class PieChartPainter extends CustomPainter {
  final Map<String, int> statusCounts; // counts of each category in pie chart
  final int total; // sum of all values
  final Map<String, Color> statusColors; // colors associated with each status

  PieChartPainter(this.statusCounts, this.total, this.statusColors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // pie chart edge size

    final center = Offset(size.width / 2, size.height / 2); // get center
    final radius = min(size.width / 2, size.height / 2); // get radius

    var startAngle = -pi / 2; // start at the top of the circle, -π/2 radians

    // center (circle)
    final centerPaint = Paint()..color = Colors.black.withValues(alpha: 0.7);
    canvas.drawCircle(center, radius, centerPaint); // Fill center with grey

    for (final entry in statusCounts.entries) {
      if (entry.value > 0) {
        // sweep angle is the portion of the circle this segment will cover
        // wherein (value / total) gives the proportion, multiplied by 2π to scale to full circle
        final sweepAngle = (entry.value / total) * 2 * pi;
        paint.color = statusColors[entry.key]!;

        // draw slice using arc method (edges only)
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle, // slice start
          sweepAngle, // slice size
          false, // No fill, just the edge
          paint, // color
        );

        // move the start angle for the next slice to the end of previous slice
        startAngle += sweepAngle;
      }
    }

    // show cluster text count in the middle
    final textPainter = TextPainter(
      text: TextSpan(
        text: total.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      false; // set to true if data changes dynamically
}
