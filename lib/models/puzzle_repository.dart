// models/puzzle_repository.dart
import 'puzzle.dart';
import 'variants/variant_constraint.dart';

class PuzzleRepository {
  static final List<Puzzle> _puzzles = [
    // Classic Beginner - No variants
    Puzzle(
      id: 1,
      title: 'Classic Beginner',
      author: 'System',
      type: 'Classic',
      difficulty: 'Easy',
      initialGrid: [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ],
    ),

    // Thermometer Challenge
    Puzzle(
      id: 2,
      title: 'Thermo Challenge',
      author: 'Sam Cappleman-Lynes',
      type: 'Thermometer',
      difficulty: 'Medium',
      initialGrid: [
        [8, 0, 1, 0, 7, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 4, 0, 6, 0],
        [0, 0, 0, 0, 0, 0, 3, 0, 0],
        [0, 0, 0, 8, 0, 1, 0, 0, 0],
        [0, 0, 2, 0, 0, 0, 0, 0, 0],
        [0, 4, 0, 0, 0, 0, 0, 5, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 6, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // Top-left thermo
        ThermometerConstraint(
          line: [
            [0, 2],
            [1, 2],
            [2, 2],
            [2, 3],
            [2, 4]
          ],
          thermoId: 0,
        ),
        // Top-right thermo
        ThermometerConstraint(
          line: [
            [0, 5],
            [0, 6],
            [1, 6],
            [2, 6]
          ],
          thermoId: 1,
        ),
        // Middle-left thermo
        ThermometerConstraint(
          line: [
            [3, 1],
            [4, 1],
            [5, 1],
            [5, 2],
            [5, 3]
          ],
          thermoId: 2,
        ),
        // Center thermo
        ThermometerConstraint(
          line: [
            [3, 4],
            [3, 5],
            [4, 5],
            [5, 5],
            [5, 6]
          ],
          thermoId: 3,
        ),
        // Bottom-left thermo
        ThermometerConstraint(
          line: [
            [6, 1],
            [7, 1],
            [8, 1],
            [8, 2],
            [8, 3]
          ],
          thermoId: 4,
        ),
        // Bottom-right thermo
        ThermometerConstraint(
          line: [
            [6, 7],
            [7, 7],
            [8, 7],
            [8, 6],
            [8, 5]
          ],
          thermoId: 0,
        ),
      ],
    ),

    // Kropki Dots Challenge
    Puzzle(
      id: 3,
      title: 'Kropki Dots',
      author: 'Puzzle Master',
      type: 'Kropki',
      difficulty: 'Hard',
      initialGrid: [
        [0, 0, 0, 6, 0, 0, 4, 0, 0],
        [7, 0, 0, 0, 0, 3, 6, 0, 0],
        [0, 0, 0, 0, 9, 1, 0, 8, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 5, 0, 1, 8, 0, 0, 0, 3],
        [0, 0, 0, 3, 0, 6, 0, 4, 5],
        [0, 4, 0, 2, 0, 0, 0, 6, 0],
        [9, 0, 3, 0, 0, 0, 0, 0, 0],
        [0, 2, 0, 0, 0, 0, 1, 0, 0],
      ],
      variantConstraints: [
        // Black dots (consecutive)
        KropkiConstraint(row1: 0, col1: 3, row2: 0, col2: 4, isBlack: true),
        KropkiConstraint(row1: 1, col1: 2, row2: 1, col2: 3, isBlack: true),
        KropkiConstraint(row1: 3, col1: 4, row2: 4, col2: 4, isBlack: true),
        KropkiConstraint(row1: 6, col1: 3, row2: 7, col2: 3, isBlack: true),

        // White dots (ratio 1:2)
        KropkiConstraint(row1: 2, col1: 1, row2: 2, col2: 2, isBlack: false),
        KropkiConstraint(row1: 4, col1: 6, row2: 5, col2: 6, isBlack: false),
        KropkiConstraint(row1: 7, col1: 5, row2: 7, col2: 6, isBlack: false),
      ],
    ),

    // Killer Sudoku
    Puzzle(
      id: 4,
      title: 'Killer Cages',
      author: 'Daily Puzzle',
      type: 'Killer',
      difficulty: 'Medium',
      initialGrid: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // Top-left cage
        KillerConstraint(
          cells: [
            [0, 0],
            [0, 1],
            [1, 0]
          ],
          sum: 15,
          cageId: 0,
        ),
        // Top-right cage
        KillerConstraint(
          cells: [
            [0, 7],
            [0, 8],
            [1, 8]
          ],
          sum: 12,
          cageId: 1,
        ),
        // Center cage
        KillerConstraint(
          cells: [
            [3, 3],
            [3, 4],
            [4, 3],
            [4, 4],
            [4, 5]
          ],
          sum: 25,
          cageId: 2,
        ),
        // L-shaped cage
        KillerConstraint(
          cells: [
            [6, 0],
            [7, 0],
            [8, 0],
            [8, 1],
            [8, 2]
          ],
          sum: 20,
          cageId: 3,
        ),
        // Small cage
        KillerConstraint(
          cells: [
            [2, 6],
            [2, 7]
          ],
          sum: 9,
          cageId: 4,
        ),
      ],
    ),

    // XV Sudoku
    Puzzle(
      id: 5,
      title: 'XV Marks',
      author: 'Variant Puzzle',
      type: 'XV',
      difficulty: 'Medium',
      initialGrid: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 5, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // X marks (sum = 10)
        XVConstraint(row1: 1, col1: 1, row2: 1, col2: 2, symbol: 'X'),
        XVConstraint(row1: 3, col1: 6, row2: 4, col2: 6, symbol: 'X'),
        XVConstraint(row1: 7, col1: 4, row2: 7, col2: 5, symbol: 'X'),

        // V marks (sum = 5)
        XVConstraint(row1: 2, col1: 3, row2: 3, col2: 3, symbol: 'V'),
        XVConstraint(row1: 5, col1: 5, row2: 6, col2: 5, symbol: 'V'),
        XVConstraint(row1: 0, col1: 7, row2: 1, col2: 7, symbol: 'V'),
      ],
    ),

    // German Whispers
    Puzzle(
      id: 6,
      title: 'German Whispers',
      author: 'Line Puzzle',
      type: 'German Whispers',
      difficulty: 'Hard',
      initialGrid: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // First whisper line
        GermanWhispersConstraint(
          line: [
            [1, 1],
            [2, 1],
            [3, 1],
            [3, 2],
            [3, 3]
          ],
          lineId: 0,
        ),
        // Second whisper line
        GermanWhispersConstraint(
          line: [
            [5, 5],
            [5, 6],
            [4, 6],
            [3, 6],
            [2, 6]
          ],
          lineId: 1,
        ),
        // Diagonal line
        GermanWhispersConstraint(
          line: [
            [6, 2],
            [7, 3],
            [8, 4]
          ],
          lineId: 2,
        ),
      ],
    ),

    // Sandwich Sudoku
    Puzzle(
      id: 7,
      title: 'Sandwich Clues',
      author: 'Edge Master',
      type: 'Sandwich',
      difficulty: 'Hard',
      initialGrid: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // Top row clues (sum between 1 and 9 in columns)
        SandwichConstraint(position: 'top', index: 0, clue: 35),
        SandwichConstraint(position: 'top', index: 1, clue: 28),
        SandwichConstraint(position: 'top', index: 2, clue: null), // Empty clue
        SandwichConstraint(position: 'top', index: 3, clue: 15),
        SandwichConstraint(position: 'top', index: 4, clue: 22),
        SandwichConstraint(position: 'top', index: 5, clue: null), // Empty clue
        SandwichConstraint(position: 'top', index: 6, clue: 18),
        SandwichConstraint(position: 'top', index: 7, clue: 30),
        SandwichConstraint(position: 'top', index: 8, clue: 12),

        // Left side clues (sum between 1 and 9 in rows)
        SandwichConstraint(position: 'left', index: 0, clue: 20),
        SandwichConstraint(position: 'left', index: 1, clue: 25),
        SandwichConstraint(
            position: 'left', index: 2, clue: null), // Empty clue
        SandwichConstraint(position: 'left', index: 3, clue: 14),
        SandwichConstraint(position: 'left', index: 4, clue: 18),
        SandwichConstraint(position: 'left', index: 5, clue: 27),
        SandwichConstraint(
            position: 'left', index: 6, clue: null), // Empty clue
        SandwichConstraint(position: 'left', index: 7, clue: 16),
        SandwichConstraint(position: 'left', index: 8, clue: 23),

        // Bottom row clues
        SandwichConstraint(position: 'bottom', index: 0, clue: 32),
        SandwichConstraint(position: 'bottom', index: 2, clue: 19),
        SandwichConstraint(position: 'bottom', index: 4, clue: 26),
        SandwichConstraint(position: 'bottom', index: 6, clue: 21),
        SandwichConstraint(position: 'bottom', index: 8, clue: 17),

        // Right side clues
        SandwichConstraint(position: 'right', index: 1, clue: 24),
        SandwichConstraint(position: 'right', index: 3, clue: 13),
        SandwichConstraint(position: 'right', index: 5, clue: 29),
        SandwichConstraint(position: 'right', index: 7, clue: 11),
      ],
    ),

    // Multi-variant puzzle combining several types
    Puzzle(
      id: 8,
      title: 'Mixed Variants',
      author: 'Variant Master',
      type: 'Mixed',
      difficulty: 'Expert',
      initialGrid: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 5, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ],
      variantConstraints: [
        // Thermometers
        ThermometerConstraint(
          line: [
            [0, 0],
            [1, 0],
            [2, 0],
            [2, 1]
          ],
          thermoId: 0,
        ),
        ThermometerConstraint(
          line: [
            [6, 8],
            [7, 8],
            [8, 8],
            [8, 7]
          ],
          thermoId: 1,
        ),

        // Kropki dots
        KropkiConstraint(row1: 3, col1: 3, row2: 3, col2: 4, isBlack: true),
        KropkiConstraint(row1: 5, col1: 4, row2: 5, col2: 5, isBlack: false),

        // XV constraints
        XVConstraint(row1: 1, col1: 6, row2: 2, col2: 6, symbol: 'X'),
        XVConstraint(row1: 7, col1: 2, row2: 7, col2: 3, symbol: 'V'),

        // German whispers
        GermanWhispersConstraint(
          line: [
            [4, 0],
            [4, 1],
            [4, 2],
            [3, 2],
            [2, 2]
          ],
          lineId: 0,
        ),

        // Small killer cage
        KillerConstraint(
          cells: [
            [6, 4],
            [6, 5],
            [7, 4]
          ],
          sum: 18,
          cageId: 0,
        ),
      ],
    ),
  ];

  static List<Puzzle> getAllPuzzles() {
    return List.unmodifiable(_puzzles);
  }

  static List<Puzzle> getPuzzlesByType(String type) {
    return _puzzles.where((puzzle) => puzzle.type == type).toList();
  }

  static List<Puzzle> getPuzzlesByDifficulty(String difficulty) {
    return _puzzles.where((puzzle) => puzzle.difficulty == difficulty).toList();
  }

  static Puzzle? getPuzzleById(int id) {
    try {
      return _puzzles.firstWhere((puzzle) => puzzle.id == id);
    } catch (e) {
      return null;
    }
  }

  static void updatePuzzle(Puzzle updatedPuzzle) {
    final index = _puzzles.indexWhere((p) => p.id == updatedPuzzle.id);
    if (index != -1) {
      _puzzles[index] = updatedPuzzle;
    }
  }

  static List<String> getAvailableTypes() {
    return _puzzles.map((p) => p.type).toSet().toList();
  }

  static List<String> getAvailableDifficulties() {
    return _puzzles.map((p) => p.difficulty).toSet().toList();
  }
}
