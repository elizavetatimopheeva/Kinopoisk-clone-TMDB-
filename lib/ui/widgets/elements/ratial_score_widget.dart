import 'dart:math';
import 'package:flutter/material.dart';

class RadialPercentWidget extends StatelessWidget {
  final Widget child;

  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  const RadialPercentWidget({
    super.key,
    required this.child,
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            fillColor: fillColor,
            lineColor: lineColor,
            freeColor: freeColor,
            lineWidth: lineWidth,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(lineWidth * 1.5),
            child: child,
          ),
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  MyPainter({
    super.repaint,
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculateArcsRect(size);

    drawBackground(canvas, size);

    drawFreeArc(canvas, arcRect);

    drawFilledArc(canvas, arcRect);
  }

  void drawFilledArc(Canvas canvas, Rect arcRect) {
    final fillPaint = Paint();
    fillPaint.color = lineColor;
    fillPaint.style = PaintingStyle.stroke;
    fillPaint.strokeWidth = lineWidth;
    fillPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, -pi / 2, pi * 2 * percent, false, fillPaint);
  }

  void drawFreeArc(Canvas canvas, Rect arcRect) {
    final filledPaint = Paint();
    filledPaint.color = freeColor;
    filledPaint.style = PaintingStyle.stroke;
    filledPaint.strokeWidth = lineWidth;
    canvas.drawArc(
      arcRect,
      (-pi / 2) + pi * 2 * percent,
      pi * 2 * (1.0 - percent),
      false,
      filledPaint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = fillColor;
    backgroundPaint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, backgroundPaint);
  }

  Rect calculateArcsRect(Size size) {
    final linesMargin = 3;
    final offset = lineWidth / 2 + linesMargin;
    final arcRect =
        Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
