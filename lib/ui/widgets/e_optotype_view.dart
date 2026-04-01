import 'package:flutter/material.dart';
import '../../vision/domain/vision_enums.dart';
import 'e_optotype_painter.dart';

class EOptotypeView extends StatelessWidget {
  final double size;
  final OptotypeDirection direction;
  final Color color;
  final double? strokeWidth;

  const EOptotypeView({
    super.key,
    required this.size,
    required this.direction,
    this.color = Colors.black,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: EOptotypePainter(
          direction: direction,
          color: color,
          strokeWidth: strokeWidth ?? (size / 5),
        ),
      ),
    );
  }
}
