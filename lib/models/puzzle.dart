// models/puzzle.dart
import 'variants/variant_constraint.dart';

class Puzzle {
  final int id;
  final String title;
  final String author;
  final String type;
  final String difficulty;
  final List<List<int>> initialGrid;
  final List<VariantConstraint>? variantConstraints;
  final bool isCompleted;
  final Duration? bestTime;

  const Puzzle({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.difficulty,
    required this.initialGrid,
    this.variantConstraints,
    this.isCompleted = false,
    this.bestTime,
  });

  Puzzle copyWith({
    int? id,
    String? title,
    String? author,
    String? type,
    String? difficulty,
    List<List<int>>? initialGrid,
    List<VariantConstraint>? variantConstraints,
    bool? isCompleted,
    Duration? bestTime,
  }) {
    return Puzzle(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      initialGrid: initialGrid ?? this.initialGrid,
      variantConstraints: variantConstraints ?? this.variantConstraints,
      isCompleted: isCompleted ?? this.isCompleted,
      bestTime: bestTime ?? this.bestTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'type': type,
      'difficulty': difficulty,
      'initialGrid': initialGrid,
      'variantConstraints': variantConstraints?.map((c) => c.toJson()).toList(),
      'isCompleted': isCompleted,
      'bestTime': bestTime?.inMilliseconds,
    };
  }

  static Puzzle fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      type: json['type'],
      difficulty: json['difficulty'],
      initialGrid: (json['initialGrid'] as List)
          .map((row) => (row as List).cast<int>())
          .toList(),
      variantConstraints: json['variantConstraints'] != null
          ? (json['variantConstraints'] as List)
              .map((c) => VariantConstraint.fromJson(c))
              .toList()
          : null,
      isCompleted: json['isCompleted'] ?? false,
      bestTime: json['bestTime'] != null
          ? Duration(milliseconds: json['bestTime'])
          : null,
    );
  }
}
