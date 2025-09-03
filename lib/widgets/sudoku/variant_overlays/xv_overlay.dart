// widgets/sudoku/variant_overlays/xv_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class XVOverlay extends StatelessWidget {
  final List<XVConstraint> constraints;
  final double gridSize;

  const XVOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: XVPainter(constraints),
    );
  }
}

class XVPainter extends CustomPainter {
  final List<XVConstraint> constraints;

  XVPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;

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

      // Draw background circle
      final backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(midpoint, 8, backgroundPaint);
      canvas.drawCircle(midpoint, 8, borderPaint);

      // Draw X or V
      final textPainter = TextPainter(
        text: TextSpan(
          text: constraint.symbol,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      final textOffset = Offset(
        midpoint.dx - textPainter.width / 2,
        midpoint.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
