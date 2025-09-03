// models/variants/variant_constraint.dart
abstract class VariantConstraint {
  final String type;
  const VariantConstraint({required this.type});

  Map<String, dynamic> toJson();
  static VariantConstraint fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'kropki':
        return KropkiConstraint.fromJson(json);
      case 'killer':
        return KillerConstraint.fromJson(json);
      case 'xv':
        return XVConstraint.fromJson(json);
      case 'german_whispers':
        return GermanWhispersConstraint.fromJson(json);
      case 'thermometer':
        return ThermometerConstraint.fromJson(json);
      case 'sandwich':
        return SandwichConstraint.fromJson(json);
      default:
        throw Exception('Unknown variant type: ${json['type']}');
    }
  }
}

// Kropki dots (black/white) between cells
class KropkiConstraint extends VariantConstraint {
  final int row1, col1, row2, col2;
  final bool isBlack; // true = black (consecutive), false = white (ratio 1:2)

  const KropkiConstraint({
    required this.row1,
    required this.col1,
    required this.row2,
    required this.col2,
    required this.isBlack,
  }) : super(type: 'kropki');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'row1': row1,
        'col1': col1,
        'row2': row2,
        'col2': col2,
        'isBlack': isBlack,
      };

  static KropkiConstraint fromJson(Map<String, dynamic> json) =>
      KropkiConstraint(
        row1: json['row1'],
        col1: json['col1'],
        row2: json['row2'],
        col2: json['col2'],
        isBlack: json['isBlack'],
      );
}

// Killer cages with sum clues
class KillerConstraint extends VariantConstraint {
  final List<List<int>> cells; // [[row, col], [row, col], ...]
  final int? sum;
  final int cageId; // For coloring different cages

  const KillerConstraint({
    required this.cells,
    this.sum,
    required this.cageId,
  }) : super(type: 'killer');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'cells': cells,
        'sum': sum,
        'cageId': cageId,
      };

  static KillerConstraint fromJson(Map<String, dynamic> json) =>
      KillerConstraint(
        cells: (json['cells'] as List)
            .map((e) => (e as List).cast<int>())
            .toList(),
        sum: json['sum'],
        cageId: json['cageId'],
      );
}

// XV constraints between cells
class XVConstraint extends VariantConstraint {
  final int row1, col1, row2, col2;
  final String symbol; // 'X' or 'V'

  const XVConstraint({
    required this.row1,
    required this.col1,
    required this.row2,
    required this.col2,
    required this.symbol,
  }) : super(type: 'xv');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'row1': row1,
        'col1': col1,
        'row2': row2,
        'col2': col2,
        'symbol': symbol,
      };

  static XVConstraint fromJson(Map<String, dynamic> json) => XVConstraint(
        row1: json['row1'],
        col1: json['col1'],
        row2: json['row2'],
        col2: json['col2'],
        symbol: json['symbol'],
      );
}

// German whispers lines
class GermanWhispersConstraint extends VariantConstraint {
  final List<List<int>> line; // [[row, col], [row, col], ...]
  final int lineId; // For multiple lines

  const GermanWhispersConstraint({
    required this.line,
    required this.lineId,
  }) : super(type: 'german_whispers');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'line': line,
        'lineId': lineId,
      };

  static GermanWhispersConstraint fromJson(Map<String, dynamic> json) =>
      GermanWhispersConstraint(
        line:
            (json['line'] as List).map((e) => (e as List).cast<int>()).toList(),
        lineId: json['lineId'],
      );
}

// Thermometer constraints
class ThermometerConstraint extends VariantConstraint {
  final List<List<int>> line; // [[row, col], [row, col], ...] bulb first
  final int thermoId; // For multiple thermos

  const ThermometerConstraint({
    required this.line,
    required this.thermoId,
  }) : super(type: 'thermometer');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'line': line,
        'thermoId': thermoId,
      };

  static ThermometerConstraint fromJson(Map<String, dynamic> json) =>
      ThermometerConstraint(
        line:
            (json['line'] as List).map((e) => (e as List).cast<int>()).toList(),
        thermoId: json['thermoId'],
      );
}

// Sandwich constraints on grid edges
class SandwichConstraint extends VariantConstraint {
  final String position; // 'top', 'bottom', 'left', 'right'
  final int index; // which row/column (0-8)
  final int? clue; // null for empty clues

  const SandwichConstraint({
    required this.position,
    required this.index,
    this.clue,
  }) : super(type: 'sandwich');

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'position': position,
        'index': index,
        'clue': clue,
      };

  static SandwichConstraint fromJson(Map<String, dynamic> json) =>
      SandwichConstraint(
        position: json['position'],
        index: json['index'],
        clue: json['clue'],
      );
}
