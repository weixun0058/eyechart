import 'package:flutter/material.dart';
import '../../vision/domain/vision_enums.dart';

class DirectionPad extends StatelessWidget {
  final ValueChanged<OptotypeDirection> onDirectionSelected;
  final bool enabled;
  final double buttonSize;
  final double spacing;

  const DirectionPad({
    super.key,
    required this.onDirectionSelected,
    this.enabled = true,
    this.buttonSize = 64.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDirectionButton(
          direction: OptotypeDirection.up,
          icon: Icons.keyboard_arrow_up,
          color: buttonColor,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDirectionButton(
              direction: OptotypeDirection.left,
              icon: Icons.keyboard_arrow_left,
              color: buttonColor,
            ),
            SizedBox(width: buttonSize + spacing * 2),
            _buildDirectionButton(
              direction: OptotypeDirection.right,
              icon: Icons.keyboard_arrow_right,
              color: buttonColor,
            ),
          ],
        ),
        _buildDirectionButton(
          direction: OptotypeDirection.down,
          icon: Icons.keyboard_arrow_down,
          color: buttonColor,
        ),
      ],
    );
  }

  Widget _buildDirectionButton({
    required OptotypeDirection direction,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onDirectionSelected(direction) : null,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: buttonSize * 0.6,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
