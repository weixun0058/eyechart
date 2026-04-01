import 'package:flutter/material.dart';
import '../../vision/domain/vision_enums.dart';

class EOptotypePainter extends CustomPainter {
  final OptotypeDirection direction;
  final Color color;
  final double strokeWidth;

  EOptotypePainter({
    required this.direction,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final unit = size.width / 5;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    switch (direction) {
      case OptotypeDirection.right:
        break;
      case OptotypeDirection.left:
        canvas.rotate(3.141592653589793);
        break;
      case OptotypeDirection.up:
        canvas.rotate(-1.5707963267948966);
        break;
      case OptotypeDirection.down:
        canvas.rotate(1.5707963267948966);
        break;
    }

    canvas.translate(-size.width / 2, -size.height / 2);

    _drawVerticalBar(canvas, paint, unit);
    _drawHorizontalBar(canvas, paint, unit, 0);
    _drawHorizontalBar(canvas, paint, unit, 2);
    _drawHorizontalBar(canvas, paint, unit, 4);

    canvas.restore();
  }

  void _drawVerticalBar(Canvas canvas, Paint paint, double unit) {
    final rect = Rect.fromLTWH(0, 0, unit, 5 * unit);
    canvas.drawRect(rect, paint);
  }

  void _drawHorizontalBar(Canvas canvas, Paint paint, double unit, int rowIndex) {
    final rect = Rect.fromLTWH(0, rowIndex * unit, 5 * unit, unit);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant EOptotypePainter oldDelegate) {
    return oldDelegate.direction != direction ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
