class SudokuCell {
  int? digit;
  Set<int> cornerMarks = {};
  Set<int> centerMarks = {};
  bool isGiven = false;
  bool hasConflict = false;
  int colorHighlight = 0;

  SudokuCell({this.digit, this.isGiven = false});

  void clearAll() {
    if (!isGiven) {
      digit = null;
      cornerMarks.clear();
      centerMarks.clear();
      colorHighlight = 0;
    }
  }

  SudokuCell copy() {
    final newCell = SudokuCell(digit: digit, isGiven: isGiven);
    newCell.cornerMarks = Set.from(cornerMarks);
    newCell.centerMarks = Set.from(centerMarks);
    newCell.hasConflict = hasConflict;
    newCell.colorHighlight = colorHighlight;
    return newCell;
  }

  Map<String, dynamic> toJson() {
    return {
      'digit': digit,
      'cornerMarks': cornerMarks.toList(),
      'centerMarks': centerMarks.toList(),
      'isGiven': isGiven,
      'hasConflict': hasConflict,
      'colorHighlight': colorHighlight,
    };
  }

  static SudokuCell fromJson(Map<String, dynamic> json) {
    final cell = SudokuCell(
      digit: json['digit'],
      isGiven: json['isGiven'] ?? false,
    );
    cell.cornerMarks = Set<int>.from(json['cornerMarks'] ?? []);
    cell.centerMarks = Set<int>.from(json['centerMarks'] ?? []);
    cell.hasConflict = json['hasConflict'] ?? false;
    cell.colorHighlight = json['colorHighlight'] ?? 0;
    return cell;
  }
}
