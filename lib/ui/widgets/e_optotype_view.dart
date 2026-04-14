import 'package:flutter/material.dart';
import '../../vision/domain/vision_enums.dart';
import 'e_optotype_painter.dart';

class EOptotypeView extends StatelessWidget {
  final double size;
  final OptotypeDirection direction;
  final Color color;
  final double? strokeWidth;
  final TestMode testMode;

  const EOptotypeView({
    super.key,
    required this.size,
    required this.direction,
    this.color = Colors.black,
    this.strokeWidth,
    this.testMode = TestMode.isolated,
  });

  @override
  Widget build(BuildContext context) {
    if (testMode == TestMode.crowded) {
      return _buildCrowdedOptotype();
    }

    return _buildIsolatedOptotype();
  }

  Widget _buildIsolatedOptotype() {
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

  Widget _buildCrowdedOptotype() {
    final effectiveStrokeWidth = strokeWidth ?? (size / 5);
    final flankerThickness = effectiveStrokeWidth.clamp(1.0, size);
    final flankerGap = size / 5;
    final crowdedExtent = size + ((flankerGap + flankerThickness) * 2);
    final centerOffset = flankerGap + flankerThickness;

    return SizedBox(
      width: crowdedExtent,
      height: crowdedExtent,
      child: Stack(
        children: [
          Positioned(
            left: centerOffset,
            top: centerOffset,
            child: _buildIsolatedOptotype(),
          ),
          _buildFlankerBar(
            left: centerOffset,
            top: 0,
            width: size,
            height: flankerThickness,
          ),
          _buildFlankerBar(
            left: centerOffset,
            top: crowdedExtent - flankerThickness,
            width: size,
            height: flankerThickness,
          ),
          _buildFlankerBar(
            left: 0,
            top: centerOffset,
            width: flankerThickness,
            height: size,
          ),
          _buildFlankerBar(
            left: crowdedExtent - flankerThickness,
            top: centerOffset,
            width: flankerThickness,
            height: size,
          ),
        ],
      ),
    );
  }

  Widget _buildFlankerBar({
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
        ),
      ),
    );
  }
}
