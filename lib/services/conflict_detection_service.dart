// services/conflict_detection_service.dart
import 'package:flutter/foundation.dart';
import '../models/sudoku_cell.dart';

class ConflictDetectionService {
  /// Detects conflicts in the Sudoku grid asynchronously
  static Future<Map<String, bool>> detectConflictsAsync(
    List<List<SudokuCell>> grid,
  ) async {
    return await compute(_detectConflicts, grid);
  }

  /// Static method that runs in a separate isolate
  static Map<String, bool> _detectConflicts(List<List<SudokuCell>> grid) {
    final conflicts = <String, bool>{};
    
    // Clear all conflicts first
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        conflicts['$r-$c'] = false;
      }
    }

    // Check for conflicts
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = grid[r][c];
        if (cell.digit != null) {
          _checkCellConflicts(r, c, cell.digit!, grid, conflicts);
        }
      }
    }

    return conflicts;
  }

  /// Check conflicts for a specific cell
  static void _checkCellConflicts(
    int row,
    int col,
    int digit,
    List<List<SudokuCell>> grid,
    Map<String, bool> conflicts,
  ) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && grid[row][c].digit == digit) {
        conflicts['$row-$col'] = true;
        conflicts['$row-$c'] = true;
      }
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (r != row && grid[r][col].digit == digit) {
        conflicts['$row-$col'] = true;
        conflicts['$r-$col'] = true;
      }
    }

    // Check 3x3 box
    final boxR = (row ~/ 3) * 3;
    final boxC = (col ~/ 3) * 3;
    for (int r = boxR; r < boxR + 3; r++) {
      for (int c = boxC; c < boxC + 3; c++) {
        if ((r != row || c != col) && grid[r][c].digit == digit) {
          conflicts['$row-$col'] = true;
          conflicts['$r-$c'] = true;
        }
      }
    }
  }

  /// Check if the grid is complete
  static Future<bool> isGridCompleteAsync(List<List<SudokuCell>> grid) async {
    return await compute(_isGridComplete, grid);
  }

  /// Static method for grid completion check
  static bool _isGridComplete(List<List<SudokuCell>> grid) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c].digit == null) return false;
      }
    }
    return true;
  }

  /// Validate the complete solution
  static Future<bool> isValidSolutionAsync(List<List<SudokuCell>> grid) async {
    return await compute(_isValidSolution, grid);
  }

  /// Static method for solution validation
  static bool _isValidSolution(List<List<SudokuCell>> grid) {
    if (!_isGridComplete(grid)) return false;

    // Check rows
    for (int r = 0; r < 9; r++) {
      final seen = <int>{};
      for (int c = 0; c < 9; c++) {
        final digit = grid[r][c].digit!;
        if (seen.contains(digit)) return false;
        seen.add(digit);
      }
    }

    // Check columns
    for (int c = 0; c < 9; c++) {
      final seen = <int>{};
      for (int r = 0; r < 9; r++) {
        final digit = grid[r][c].digit!;
        if (seen.contains(digit)) return false;
        seen.add(digit);
      }
    }

    // Check 3x3 boxes
    for (int boxR = 0; boxR < 9; boxR += 3) {
      for (int boxC = 0; boxC < 9; boxC += 3) {
        final seen = <int>{};
        for (int r = boxR; r < boxR + 3; r++) {
          for (int c = boxC; c < boxC + 3; c++) {
            final digit = grid[r][c].digit!;
            if (seen.contains(digit)) return false;
            seen.add(digit);
          }
        }
      }
    }

    return true;
  }
}
