import 'dart:math';

import 'package:flutter/material.dart';

import '../models/survey_status.dart';

class PieChartPainter extends CustomPainter {
  final Map<SurveyStatus, int> statusCounts;

  PieChartPainter(this.statusCounts);

  @override
  void paint(Canvas canvas, Size size) {
    final total = statusCounts.values.reduce((a, b) => a + b);
    final arcPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
    final circlePaint = Paint()..color = Colors.black54;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    var startAngle = -pi / 2;

    canvas.drawCircle(center, radius, circlePaint);

    for (final entry in statusCounts.entries) {
      if (entry.value > 0) {
        final sweepAngle = (entry.value / total) * 2 * pi;
        arcPaint.color = entry.key.color;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          arcPaint,
        );
        startAngle += sweepAngle;
      }
    }

    final textPainter = TextPainter(
      text: TextSpan(text: total.toString()),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
