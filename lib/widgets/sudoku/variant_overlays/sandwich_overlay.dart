// widgets/sudoku/variant_overlays/sandwich_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class SandwichOverlay extends StatelessWidget {
  final List<SandwichConstraint> constraints;
  final double gridSize;

  const SandwichOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: SandwichPainter(constraints),
    );
  }
}

class SandwichPainter extends CustomPainter {
  final List<SandwichConstraint> constraints;

  SandwichPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;
    const clueSize = 24.0;

    for (final constraint in constraints) {
      if (constraint.clue == null) continue; // Skip empty clues

      Offset position;

      switch (constraint.position) {
        case 'top':
          position = Offset(
            (constraint.index + 0.5) * cellSize - clueSize / 2,
            -clueSize - 5,
          );
          break;
        case 'left':
          position = Offset(
            -clueSize - 5,
            (constraint.index + 0.5) * cellSize - clueSize / 2,
          );
          break;
        default:
          continue; // Skip bottom and right positions
      }

      // Draw background circle
      final backgroundPaint = Paint()
        ..color = Colors.yellow.shade100
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.orange.shade600
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final center =
          Offset(position.dx + clueSize / 2, position.dy + clueSize / 2);
      canvas.drawCircle(center, clueSize / 2, backgroundPaint);
      canvas.drawCircle(center, clueSize / 2, borderPaint);

      // Draw clue text
      final textPainter = TextPainter(
        text: TextSpan(
          text: constraint.clue.toString(),
          style: TextStyle(
            color: Colors.orange.shade800,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      final textOffset = Offset(
        position.dx + (clueSize - textPainter.width) / 2,
        position.dy + (clueSize - textPainter.height) / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
