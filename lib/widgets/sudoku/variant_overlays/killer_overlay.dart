// widgets/sudoku/variant_overlays/killer_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class KillerOverlay extends StatelessWidget {
  final List<KillerConstraint> constraints;
  final double gridSize;

  const KillerOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: KillerPainter(constraints),
    );
  }
}

class KillerPainter extends CustomPainter {
  final List<KillerConstraint> constraints;

  KillerPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;

    for (final constraint in constraints) {
      final cageColor = _getCageColor(constraint.cageId);
      final paint = Paint()
        ..color = cageColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      // Create path for cage outline
      final path = Path();
      final cells = constraint.cells;

      if (cells.isEmpty) continue;

      // Find the outline of the cage
      final outline = _getCageOutline(cells, cellSize);
      path.addPath(outline, Offset.zero);

      canvas.drawPath(path, paint);

      // Draw sum clue in top-left corner of cage
      if (constraint.sum != null && cells.isNotEmpty) {
        final firstCell = cells[0];
        final textPainter = TextPainter(
          text: TextSpan(
            text: constraint.sum.toString(),
            style: TextStyle(
              color: cageColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        final offset = Offset(
          firstCell[1] * cellSize + 3,
          firstCell[0] * cellSize + 2,
        );

        textPainter.paint(canvas, offset);
      }
    }
  }

  Color _getCageColor(int cageId) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[cageId % colors.length];
  }

  Path _getCageOutline(List<List<int>> cells, double cellSize) {
    final path = Path();

    // Create a grid to mark which cells are in the cage
    final cageGrid = List.generate(9, (_) => List.generate(9, (_) => false));
    for (final cell in cells) {
      cageGrid[cell[0]][cell[1]] = true;
    }

    // For each cell, draw the borders that are on the cage edge
    for (final cell in cells) {
      final row = cell[0];
      final col = cell[1];
      final x = col * cellSize;
      final y = row * cellSize;

      // Top border
      if (row == 0 || !cageGrid[row - 1][col]) {
        path.moveTo(x, y);
        path.lineTo(x + cellSize, y);
      }

      // Bottom border
      if (row == 8 || !cageGrid[row + 1][col]) {
        path.moveTo(x, y + cellSize);
        path.lineTo(x + cellSize, y + cellSize);
      }

      // Left border
      if (col == 0 || !cageGrid[row][col - 1]) {
        path.moveTo(x, y);
        path.lineTo(x, y + cellSize);
      }

      // Right border
      if (col == 8 || !cageGrid[row][col + 1]) {
        path.moveTo(x + cellSize, y);
        path.lineTo(x + cellSize, y + cellSize);
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
