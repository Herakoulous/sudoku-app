// widgets/sudoku/variant_overlays/kropki_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class KropkiOverlay extends StatelessWidget {
  final List<KropkiConstraint> constraints;
  final double gridSize;

  const KropkiOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: KropkiPainter(constraints),
    );
  }
}

class KropkiPainter extends CustomPainter {
  final List<KropkiConstraint> constraints;

  KropkiPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;
    const dotRadius = 4.0;

    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final constraint in constraints) {
      final cell1Center = Offset(
        (constraint.col1 + 0.5) * cellSize,
        (constraint.row1 + 0.5) * cellSize,
      );
      final cell2Center = Offset(
        (constraint.col2 + 0.5) * cellSize,
        (constraint.row2 + 0.5) * cellSize,
      );

      // Calculate midpoint between cells
      final midpoint = Offset(
        (cell1Center.dx + cell2Center.dx) / 2,
        (cell1Center.dy + cell2Center.dy) / 2,
      );

      // Draw the dot
      if (constraint.isBlack) {
        // Black dot (consecutive constraint)
        canvas.drawCircle(midpoint, dotRadius, blackPaint);
      } else {
        // White dot with black border (ratio constraint)
        canvas.drawCircle(midpoint, dotRadius, whitePaint);
        canvas.drawCircle(midpoint, dotRadius, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
