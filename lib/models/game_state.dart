import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sudoku_cell.dart';

class GameAction {
  final int row;
  final int col;
  final SudokuCell previousState;
  final SudokuCell newState;
  final ActionType type;
  final List<List<int>>? multiCells;

  GameAction({
    required this.row,
    required this.col,
    required this.previousState,
    required this.newState,
    required this.type,
    this.multiCells,
  });

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'previousState': previousState.toJson(),
      'newState': newState.toJson(),
      'type': type.toString(),
      'multiCells': multiCells,
    };
  }

  static GameAction fromJson(Map<String, dynamic> json) {
    return GameAction(
      row: json['row'],
      col: json['col'],
      previousState: SudokuCell.fromJson(json['previousState']),
      newState: SudokuCell.fromJson(json['newState']),
      type: ActionType.values.firstWhere((e) => e.toString() == json['type']),
      multiCells: json['multiCells']?.cast<List<int>>(),
    );
  }
}

enum ActionType { digit, cornerMark, centerMark, color, clear, multiAction }

class GameState {
  final List<List<SudokuCell>> grid;
  final int? selectedRow;
  final int? selectedCol;
  final Set<String> selectedCells;
  final Duration elapsedTime;
  final bool isCompleted;
  final bool isPuzzleSolved;
  final int puzzleId;
  final DateTime lastPlayedAt;

  GameState({
    required this.grid,
    this.selectedRow,
    this.selectedCol,
    this.selectedCells = const {},
    required this.elapsedTime,
    this.isCompleted = false,
    this.isPuzzleSolved = false,
    required this.puzzleId,
    DateTime? lastPlayedAt,
  }) : lastPlayedAt = lastPlayedAt ?? DateTime.now();

  GameState copyWith({
    List<List<SudokuCell>>? grid,
    int? selectedRow,
    int? selectedCol,
    Set<String>? selectedCells,
    Duration? elapsedTime,
    bool? isCompleted,
    bool? isPuzzleSolved,
    int? puzzleId,
    DateTime? lastPlayedAt,
  }) {
    return GameState(
      grid: grid ?? deepCopyGrid(this.grid),
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      selectedCells: selectedCells ?? Set.from(this.selectedCells),
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isPuzzleSolved: isPuzzleSolved ?? this.isPuzzleSolved,
      puzzleId: puzzleId ?? this.puzzleId,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  static List<List<SudokuCell>> deepCopyGrid(List<List<SudokuCell>> original) {
    return original
        .map(
          (row) => row.map((cell) {
            final newCell = SudokuCell(
              digit: cell.digit,
              isGiven: cell.isGiven,
            );
            newCell.cornerMarks = Set.from(cell.cornerMarks);
            newCell.centerMarks = Set.from(cell.centerMarks);
            newCell.hasConflict = cell.hasConflict;
            newCell.colorHighlight = cell.colorHighlight;
            return newCell;
          }).toList(),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'grid': grid
          .map((row) => row.map((cell) => cell.toJson()).toList())
          .toList(),
      'selectedRow': selectedRow,
      'selectedCol': selectedCol,
      'selectedCells': selectedCells.toList(),
      'elapsedTime': elapsedTime.inMilliseconds,
      'isCompleted': isCompleted,
      'isPuzzleSolved': isPuzzleSolved,
      'puzzleId': puzzleId,
      'lastPlayedAt': lastPlayedAt.toIso8601String(),
    };
  }

  static GameState fromJson(Map<String, dynamic> json) {
    return GameState(
      grid: (json['grid'] as List)
          .map(
            (row) =>
                (row as List).map((cell) => SudokuCell.fromJson(cell)).toList(),
          )
          .toList(),
      selectedRow: json['selectedRow'],
      selectedCol: json['selectedCol'],
      selectedCells: Set<String>.from(json['selectedCells'] ?? []),
      elapsedTime: Duration(milliseconds: json['elapsedTime'] ?? 0),
      isCompleted: json['isCompleted'] ?? false,
      isPuzzleSolved: json['isPuzzleSolved'] ?? false,
      puzzleId: json['puzzleId'],
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'])
          : DateTime.now(),
    );
  }

  Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'game_state_$puzzleId';
    await prefs.setString(key, jsonEncode(toJson()));

    // Also save as most recent
    await prefs.setInt('most_recent_puzzle_id', puzzleId);
    await prefs.setString(
      'last_played_at_$puzzleId',
      DateTime.now().toIso8601String(),
    );
  }

  static Future<GameState?> loadFromStorage(int puzzleId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'game_state_$puzzleId';
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        return GameState.fromJson(json);
      } catch (e) {
        print('Error loading game state: $e');
      }
    }
    return null;
  }

  static Future<void> clearSavedState(int puzzleId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'game_state_$puzzleId';
    await prefs.remove(key);
    await prefs.remove('last_played_at_$puzzleId');
  }

  static Future<int?> getMostRecentPuzzleId() async {
    final prefs = await SharedPreferences.getInstance();

    // First try to get the most recent puzzle
    final recentId = prefs.getInt('most_recent_puzzle_id');
    if (recentId != null) {
      final savedState = await loadFromStorage(recentId);
      if (savedState != null && !savedState.isPuzzleSolved) {
        return recentId;
      }
    }

    // If no recent puzzle or it's completed, find puzzle with most time
    final allPuzzleIds = [1, 2, 3, 4]; // Get from PuzzleRepository
    Duration maxTime = Duration.zero;
    int? bestPuzzleId;

    for (final id in allPuzzleIds) {
      final state = await loadFromStorage(id);
      if (state != null &&
          !state.isPuzzleSolved &&
          state.elapsedTime > maxTime) {
        maxTime = state.elapsedTime;
        bestPuzzleId = id;
      }
    }

    return bestPuzzleId ?? 3; // Default to puzzle 3 (Kropki with variants)
  }

  bool isGridComplete() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c].digit == null) return false;
      }
    }
    return true;
  }

  bool isValidSolution() {
    if (!isGridComplete()) return false;

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

  void updateConflicts() {
    // Clear all conflicts first
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        grid[r][c].hasConflict = false;
      }
    }

    // Check for conflicts
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = grid[r][c];
        if (cell.digit != null) {
          _checkCellConflicts(r, c, cell.digit!);
        }
      }
    }
  }

  void _checkCellConflicts(int row, int col, int digit) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && grid[row][c].digit == digit) {
        grid[row][col].hasConflict = true;
        grid[row][c].hasConflict = true;
      }
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (r != row && grid[r][col].digit == digit) {
        grid[row][col].hasConflict = true;
        grid[r][col].hasConflict = true;
      }
    }

    // Check 3x3 box
    final boxR = (row ~/ 3) * 3;
    final boxC = (col ~/ 3) * 3;
    for (int r = boxR; r < boxR + 3; r++) {
      for (int c = boxC; c < boxC + 3; c++) {
        if ((r != row || c != col) && grid[r][c].digit == digit) {
          grid[row][col].hasConflict = true;
          grid[r][c].hasConflict = true;
        }
      }
    }
  }
}
