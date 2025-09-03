// widgets/sudoku/variant_overlays/german_whispers_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class GermanWhispersOverlay extends StatelessWidget {
  final List<GermanWhispersConstraint> constraints;
  final double gridSize;

  const GermanWhispersOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: GermanWhispersPainter(constraints),
    );
  }
}

class GermanWhispersPainter extends CustomPainter {
  final List<GermanWhispersConstraint> constraints;

  GermanWhispersPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;

    for (final constraint in constraints) {
      final lineColor = _getLineColor(constraint.lineId);
      final paint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final line = constraint.line;
      if (line.length < 2) continue;

      final path = Path();

      // Start at first cell center
      final firstCell = line[0];
      final startPoint = Offset(
        (firstCell[1] + 0.5) * cellSize,
        (firstCell[0] + 0.5) * cellSize,
      );
      path.moveTo(startPoint.dx, startPoint.dy);

      // Connect to subsequent cell centers
      for (int i = 1; i < line.length; i++) {
        final cell = line[i];
        final point = Offset(
          (cell[1] + 0.5) * cellSize,
          (cell[0] + 0.5) * cellSize,
        );
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  Color _getLineColor(int lineId) {
    final colors = [
      Colors.green.shade600,
      Colors.purple.shade600,
      Colors.orange.shade600,
      Colors.teal.shade600,
      Colors.pink.shade600,
      Colors.indigo.shade600,
      Colors.brown.shade600,
      Colors.cyan.shade600,
    ];
    return colors[lineId % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
