// utils/constants.dart

/// App-wide constants
class AppConstants {
  // Grid dimensions
  static const int gridSize = 9;
  static const int boxSize = 3;
  
  // UI dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Colors
  static const int primaryColorValue = 0xFF1976D2;
  static const int secondaryColorValue = 0xFF90CAF9;
  static const int backgroundColorValue = 0xFFFCFCFC;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Game settings
  static const int maxUndoActions = 100;
  static const int maxRedoActions = 100;
  static const Duration autoSaveInterval = Duration(seconds: 30);
  
  // Storage keys
  static const String gameStatePrefix = 'game_state_';
  static const String mostRecentPuzzleKey = 'most_recent_puzzle_id';
  static const String lastPlayedPrefix = 'last_played_at_';
  
  // Variant constraint types
  static const String kropkiType = 'kropki';
  static const String killerType = 'killer';
  static const String xvType = 'xv';
  static const String germanWhispersType = 'german_whispers';
  static const String thermometerType = 'thermometer';
  static const String sandwichType = 'sandwich';
  
  // Error messages
  static const String genericError = 'An error occurred. Please try again.';
  static const String saveError = 'Failed to save game progress.';
  static const String loadError = 'Failed to load game progress.';
  static const String networkError = 'Network error. Please check your connection.';
  
  // Success messages
  static const String saveSuccess = 'Game progress saved successfully.';
  static const String puzzleComplete = 'Congratulations! Puzzle completed!';
  
  // Validation messages
  static const String invalidInput = 'Invalid input. Please check your entry.';
  static const String conflictDetected = 'Conflict detected. Please resolve before continuing.';
}

/// Theme constants
class ThemeConstants {
  // Text styles
  static const double titleFontSize = 18.0;
  static const double subtitleFontSize = 14.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 12.0;
  
  // Border radius
  static const double smallRadius = 4.0;
  static const double mediumRadius = 8.0;
  static const double largeRadius = 16.0;
  
  // Elevation
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;
}

/// Game constants
class GameConstants {
  // Cell states
  static const int emptyCell = 0;
  static const int minDigit = 1;
  static const int maxDigit = 9;
  
  // Input modes
  static const int normalMode = 0;
  static const int cornerMode = 1;
  static const int centerMode = 2;
  static const int colorMode = 3;
  static const int multiSelectMode = 4;
  
  // Color highlights
  static const int noColor = 0;
  static const int redColor = 1;
  static const int blueColor = 2;
  static const int greenColor = 3;
  static const int yellowColor = 4;
  static const int orangeColor = 5;
  static const int purpleColor = 6;
  static const int pinkColor = 7;
  static const int greyColor = 8;
  static const int brownColor = 9;
  
  // Timer intervals
  static const Duration timerUpdateInterval = Duration(seconds: 1);
  static const Duration conflictCheckDelay = Duration(milliseconds: 500);
  static const Duration autoSaveDelay = Duration(seconds: 30);
}
