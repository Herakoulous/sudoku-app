// widgets/sudoku/variant_overlay_manager.dart
import 'package:flutter/material.dart';
import '../../models/variants/variant_constraint.dart';
import 'variant_overlays/kropki_overlay.dart';
import 'variant_overlays/killer_overlay.dart';
import 'variant_overlays/xv_overlay.dart';
import 'variant_overlays/german_whispers_overlay.dart';
import 'variant_overlays/thermometer_overlay.dart';
import 'variant_overlays/sandwich_overlay.dart';

/// Manages all variant overlays and their rendering order
class VariantOverlayManager {
  static List<Widget> buildOverlays(
    List<VariantConstraint>? constraints,
    double gridSize,
  ) {
    if (constraints == null || constraints.isEmpty) return [];

    final overlays = <Widget>[];

    // Group constraints by type for better performance
    final kropkiConstraints = <KropkiConstraint>[];
    final killerConstraints = <KillerConstraint>[];
    final xvConstraints = <XVConstraint>[];
    final germanWhispersConstraints = <GermanWhispersConstraint>[];
    final thermometerConstraints = <ThermometerConstraint>[];
    final sandwichConstraints = <SandwichConstraint>[];

    for (final constraint in constraints) {
      switch (constraint.type) {
        case 'kropki':
          kropkiConstraints.add(constraint as KropkiConstraint);
          break;
        case 'killer':
          killerConstraints.add(constraint as KillerConstraint);
          break;
        case 'xv':
          xvConstraints.add(constraint as XVConstraint);
          break;
        case 'german_whispers':
          germanWhispersConstraints.add(constraint as GermanWhispersConstraint);
          break;
        case 'thermometer':
          thermometerConstraints.add(constraint as ThermometerConstraint);
          break;
        case 'sandwich':
          sandwichConstraints.add(constraint as SandwichConstraint);
          break;
      }
    }

    // Add overlays in rendering order (background to foreground)
    // 1. Killer cages (background outlines)
    if (killerConstraints.isNotEmpty) {
      overlays.add(IgnorePointer(
        child: KillerOverlay(
          constraints: killerConstraints,
          gridSize: gridSize,
        ),
      ));
    }

    // 2. Thermometers (lines with bulbs)
    if (thermometerConstraints.isNotEmpty) {
      overlays.add(IgnorePointer(
        child: ThermometerOverlay(
          constraints: thermometerConstraints,
          gridSize: gridSize,
        ),
      ));
    }

    // 3. German whispers (colored lines)
    if (germanWhispersConstraints.isNotEmpty) {
      overlays.add(IgnorePointer(
        child: GermanWhispersOverlay(
          constraints: germanWhispersConstraints,
          gridSize: gridSize,
        ),
      ));
    }

    // 4. Kropki dots (between cells)
    if (kropkiConstraints.isNotEmpty) {
      overlays.add(IgnorePointer(
        child: KropkiOverlay(
          constraints: kropkiConstraints,
          gridSize: gridSize,
        ),
      ));
    }

    // 5. XV marks (between cells, on top of dots)
    if (xvConstraints.isNotEmpty) {
      overlays.add(IgnorePointer(
        child: XVOverlay(
          constraints: xvConstraints,
          gridSize: gridSize,
        ),
      ));
    }

    // 6. Sandwich clues (outside grid, need positioned wrapper)
    if (sandwichConstraints.isNotEmpty) {
      overlays.add(Positioned.fill(
        child: IgnorePointer(
          child: SandwichOverlay(
            constraints: sandwichConstraints,
            gridSize: gridSize,
          ),
        ),
      ));
    }

    return overlays;
  }

  /// Check if constraints contain overlapping elements that might need special handling
  static bool hasOverlappingConstraints(List<VariantConstraint> constraints) {
    final cellPositions = <String, List<String>>{};

    for (final constraint in constraints) {
      switch (constraint.type) {
        case 'killer':
          final killer = constraint as KillerConstraint;
          for (final cell in killer.cells) {
            final key = '${cell[0]}-${cell[1]}';
            cellPositions[key] = (cellPositions[key] ?? [])..add('killer');
          }
          break;
        case 'thermometer':
          final thermo = constraint as ThermometerConstraint;
          for (final cell in thermo.line) {
            final key = '${cell[0]}-${cell[1]}';
            cellPositions[key] = (cellPositions[key] ?? [])..add('thermometer');
          }
          break;
        case 'german_whispers':
          final whispers = constraint as GermanWhispersConstraint;
          for (final cell in whispers.line) {
            final key = '${cell[0]}-${cell[1]}';
            cellPositions[key] = (cellPositions[key] ?? [])
              ..add('german_whispers');
          }
          break;
      }
    }

    return cellPositions.values.any((types) => types.length > 1);
  }

  /// Get summary of variant types present in constraints
  static List<String> getVariantTypes(List<VariantConstraint>? constraints) {
    if (constraints == null) return [];

    return constraints.map((c) => c.type).toSet().toList();
  }

  /// Validate constraints for common errors
  static List<String> validateConstraints(List<VariantConstraint> constraints) {
    final errors = <String>[];

    for (final constraint in constraints) {
      switch (constraint.type) {
        case 'kropki':
          final kropki = constraint as KropkiConstraint;
          if (!_isAdjacent(
              kropki.row1, kropki.col1, kropki.row2, kropki.col2)) {
            errors.add('Kropki constraint has non-adjacent cells');
          }
          break;
        case 'xv':
          final xv = constraint as XVConstraint;
          if (!_isAdjacent(xv.row1, xv.col1, xv.row2, xv.col2)) {
            errors.add('XV constraint has non-adjacent cells');
          }
          if (xv.symbol != 'X' && xv.symbol != 'V') {
            errors.add('XV constraint has invalid symbol: ${xv.symbol}');
          }
          break;
        case 'killer':
          final killer = constraint as KillerConstraint;
          if (killer.cells.isEmpty) {
            errors.add('Killer cage has no cells');
          }
          for (final cell in killer.cells) {
            if (cell[0] < 0 || cell[0] > 8 || cell[1] < 0 || cell[1] > 8) {
              errors.add(
                  'Killer cage has invalid cell position: ${cell[0]}, ${cell[1]}');
            }
          }
          break;
        case 'thermometer':
          final thermo = constraint as ThermometerConstraint;
          if (thermo.line.length < 2) {
            errors.add('Thermometer has fewer than 2 cells');
          }
          break;
        case 'german_whispers':
          final whispers = constraint as GermanWhispersConstraint;
          if (whispers.line.length < 2) {
            errors.add('German whispers line has fewer than 2 cells');
          }
          break;
        case 'sandwich':
          final sandwich = constraint as SandwichConstraint;
          if (sandwich.index < 0 || sandwich.index > 8) {
            errors.add(
                'Sandwich constraint has invalid index: ${sandwich.index}');
          }
          if (!['top', 'bottom', 'left', 'right'].contains(sandwich.position)) {
            errors.add(
                'Sandwich constraint has invalid position: ${sandwich.position}');
          }
          break;
      }
    }

    return errors;
  }

  static bool _isAdjacent(int row1, int col1, int row2, int col2) {
    final rowDiff = (row1 - row2).abs();
    final colDiff = (col1 - col2).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }
}
