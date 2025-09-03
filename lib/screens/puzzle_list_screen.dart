import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../models/puzzle_repository.dart';

class PuzzleListScreen extends StatefulWidget {
  final bool filterByType;
  final bool filterByDifficulty;
  final Function(Puzzle)? onPuzzleSelected;

  const PuzzleListScreen({
    Key? key,
    this.filterByType = false,
    this.filterByDifficulty = false,
    this.onPuzzleSelected,
  }) : super(key: key);

  @override
  State<PuzzleListScreen> createState() => _PuzzleListScreenState();
}

class _PuzzleListScreenState extends State<PuzzleListScreen> {
  List<Puzzle> puzzles = [];
  String? selectedFilter;
  List<String> filterOptions = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.filterByType) {
      filterOptions = PuzzleRepository.getAvailableTypes();
      selectedFilter = filterOptions.first;
      puzzles = PuzzleRepository.getPuzzlesByType(selectedFilter!);
    } else if (widget.filterByDifficulty) {
      filterOptions = PuzzleRepository.getAvailableDifficulties();
      selectedFilter = filterOptions.first;
      puzzles = PuzzleRepository.getPuzzlesByDifficulty(selectedFilter!);
    } else {
      puzzles = PuzzleRepository.getAllPuzzles();
    }
  }

  void _updateFilter(String? newFilter) {
    if (newFilter == null) return;

    setState(() {
      selectedFilter = newFilter;
      if (widget.filterByType) {
        puzzles = PuzzleRepository.getPuzzlesByType(newFilter);
      } else if (widget.filterByDifficulty) {
        puzzles = PuzzleRepository.getPuzzlesByDifficulty(newFilter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (filterOptions.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: _updateFilter,
              itemBuilder: (context) => filterOptions
                  .map(
                    (option) => PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          if (selectedFilter == option)
                            const Icon(Icons.check, size: 16)
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(option),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.filter_list),
              ),
            ),
        ],
      ),
      body: puzzles.isEmpty
          ? const Center(
              child: Text(
                'No puzzles found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPuzzleCard(context, puzzle),
                );
              },
            ),
    );
  }

  String _getTitle() {
    if (widget.filterByType) return 'Browse by Type';
    if (widget.filterByDifficulty) return 'Browse by Difficulty';
    return 'All Puzzles';
  }

  Widget _buildPuzzleCard(BuildContext context, Puzzle puzzle) {
    return GestureDetector(
      onTap: () {
        if (widget.onPuzzleSelected != null) {
          widget.onPuzzleSelected!(puzzle);
        } else {
          Navigator.pushNamed(context, '/game', arguments: puzzle.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        puzzle.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${puzzle.author}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (puzzle.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildChip(puzzle.type, _getTypeColor(puzzle.type)),
                const SizedBox(width: 8),
                _buildChip(
                  puzzle.difficulty,
                  _getDifficultyColor(puzzle.difficulty),
                ),
                const Spacer(),
                if (puzzle.bestTime != null)
                  Text(
                    _formatDuration(puzzle.bestTime!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'classic':
        return Colors.blue;
      case 'thermo':
        return Colors.red;
      case 'killer':
        return Colors.purple;
      case 'sandwich':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      case 'expert':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
