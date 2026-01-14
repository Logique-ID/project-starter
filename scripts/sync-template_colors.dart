import 'dart:io';

/// ANSI color codes for terminal output
class ConsoleColors {
  // Reset
  static const String reset = '\x1B[0m';
  
  // Colors
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String cyan = '\x1B[36m';
  static const String red = '\x1B[31m';
  static const String brightCyan = '\x1B[96m';
  static const String magenta = '\x1B[35m';
  
  /// Check if colors should be enabled
  static bool get shouldUseColors {
    try {
      return stdout.hasTerminal;
    } catch (e) {
      return false;
    }
  }
  
  /// Apply color to text
  static String colorize(String text, String color) {
    if (!shouldUseColors) return text;
    return '$color$text$reset';
  }
  
  /// Color for Mason condition indicator (red for visibility in lists)
  static String mason(String text) => colorize(text, red);
  
  /// Color for files that are synced/updated
  static String syncedFile(String text) => colorize(text, green);
  
  /// Color for success messages
  static String success(String text) => colorize(text, green);
  
  /// Color for dry run messages
  static String dryRun(String text) => colorize(text, magenta);
  
  /// Color for info messages
  static String info(String text) => colorize(text, cyan);
  
  /// Color for warnings
  static String warning(String text) => colorize(text, yellow);
}
