// widgets/sudoku/variant_overlays/thermometer_overlay.dart
import 'package:flutter/material.dart';
import '../../../models/variants/variant_constraint.dart';

class ThermometerOverlay extends StatelessWidget {
  final List<ThermometerConstraint> constraints;
  final double gridSize;

  const ThermometerOverlay({
    Key? key,
    required this.constraints,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize, gridSize),
      painter: ThermometerPainter(constraints),
    );
  }
}

class ThermometerPainter extends CustomPainter {
  final List<ThermometerConstraint> constraints;

  ThermometerPainter(this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;

    for (final constraint in constraints) {
      final line = constraint.line;
      if (line.length < 2) continue;

      // Draw the thermometer line with gradient
      _drawThermometerLine(canvas, line, cellSize, constraint.thermoId);

      // Draw the bulb at the start
      _drawThermometerBulb(canvas, line[0], cellSize, constraint.thermoId);
    }
  }

  void _drawThermometerLine(
      Canvas canvas, List<List<int>> line, double cellSize, int thermoId) {
    if (line.length < 2) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Use grey colors for thermometers
    final colors = _getThermoColors(thermoId);

    for (int i = 0; i < line.length - 1; i++) {
      final fromCell = line[i];
      final toCell = line[i + 1];

      final fromPoint = Offset(
        (fromCell[1] + 0.5) * cellSize,
        (fromCell[0] + 0.5) * cellSize,
      );
      final toPoint = Offset(
        (toCell[1] + 0.5) * cellSize,
        (toCell[0] + 0.5) * cellSize,
      );

      // Calculate color based on position along thermometer
      final progress = i / (line.length - 1);
      paint.color = Color.lerp(colors.cool, colors.warm, progress)!;

      canvas.drawLine(fromPoint, toPoint, paint);
    }
  }

  void _drawThermometerBulb(
      Canvas canvas, List<int> bulbCell, double cellSize, int thermoId) {
    final center = Offset(
      (bulbCell[1] + 0.5) * cellSize,
      (bulbCell[0] + 0.5) * cellSize,
    );

    final colors = _getThermoColors(thermoId);

    // Draw outer circle
    final outerPaint = Paint()
      ..color = colors.cool
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, outerPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..color = colors.cool.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, innerPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = colors.cool.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, 8, borderPaint);
  }

  ThermoColors _getThermoColors(int thermoId) {
    final colorSets = [
      ThermoColors(Colors.grey.shade400, Colors.grey.shade600),
      ThermoColors(Colors.grey.shade500, Colors.grey.shade700),
      ThermoColors(Colors.grey.shade400, Colors.grey.shade600),
      ThermoColors(Colors.grey.shade500, Colors.grey.shade700),
      ThermoColors(Colors.grey.shade400, Colors.grey.shade600),
    ];
    return colorSets[thermoId % colorSets.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThermoColors {
  final Color cool;
  final Color warm;

  ThermoColors(this.cool, this.warm);
}
