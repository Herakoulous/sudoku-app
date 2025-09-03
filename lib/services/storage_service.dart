// services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _gameStatePrefix = 'game_state_';
  static const String _mostRecentPuzzleKey = 'most_recent_puzzle_id';
  static const String _lastPlayedPrefix = 'last_played_at_';

  /// Save game state to storage
  static Future<bool> saveGameState(GameState gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_gameStatePrefix${gameState.puzzleId}';
      
      // Save game state
      final success = await prefs.setString(key, jsonEncode(gameState.toJson()));
      
      if (success) {
        // Update most recent puzzle
        await prefs.setInt(_mostRecentPuzzleKey, gameState.puzzleId);
        
        // Update last played timestamp
        final lastPlayedKey = '$_lastPlayedPrefix${gameState.puzzleId}';
        await prefs.setString(lastPlayedKey, gameState.lastPlayedAt.toIso8601String());
      }
      
      return success;
    } catch (e) {
      print('Error saving game state: $e');
      return false;
    }
  }

  /// Load game state from storage
  static Future<GameState?> loadGameState(int puzzleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_gameStatePrefix$puzzleId';
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return GameState.fromJson(json);
      }
      
      return null;
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }

  /// Delete game state from storage
  static Future<bool> deleteGameState(int puzzleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_gameStatePrefix$puzzleId';
      final lastPlayedKey = '$_lastPlayedPrefix$puzzleId';
      
      final success = await prefs.remove(key);
      await prefs.remove(lastPlayedKey);
      
      return success;
    } catch (e) {
      print('Error deleting game state: $e');
      return false;
    }
  }

  /// Get the most recent puzzle ID
  static Future<int?> getMostRecentPuzzleId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentId = prefs.getInt(_mostRecentPuzzleKey);
      
      if (recentId != null) {
        final savedState = await loadGameState(recentId);
        if (savedState != null && !savedState.isPuzzleSolved) {
          return recentId;
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting most recent puzzle ID: $e');
      return null;
    }
  }

  /// Get puzzle ID with most play time
  static Future<int?> getPuzzleWithMostTime() async {
    try {
      final allPuzzleIds = [1, 2, 3, 4]; // Get from PuzzleRepository
      Duration maxTime = Duration.zero;
      int? bestPuzzleId;

      for (final id in allPuzzleIds) {
        final state = await loadGameState(id);
        if (state != null &&
            !state.isPuzzleSolved &&
            state.elapsedTime > maxTime) {
          maxTime = state.elapsedTime;
          bestPuzzleId = id;
        }
      }

      return bestPuzzleId;
    } catch (e) {
      print('Error getting puzzle with most time: $e');
      return null;
    }
  }

  /// Clear all game data
  static Future<bool> clearAllGameData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_gameStatePrefix) || 
            key.startsWith(_lastPlayedPrefix) ||
            key == _mostRecentPuzzleKey) {
          await prefs.remove(key);
        }
      }
      
      return true;
    } catch (e) {
      print('Error clearing all game data: $e');
      return false;
    }
  }

  /// Get storage statistics
  static Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      int gameStates = 0;
      int totalSize = 0;
      
      for (final key in keys) {
        if (key.startsWith(_gameStatePrefix)) {
          gameStates++;
          final data = prefs.getString(key);
          if (data != null) {
            totalSize += data.length;
          }
        }
      }
      
      return {
        'gameStates': gameStates,
        'totalSizeBytes': totalSize,
        'totalSizeKB': (totalSize / 1024).toStringAsFixed(2),
      };
    } catch (e) {
      print('Error getting storage stats: $e');
      return {};
    }
  }
}
