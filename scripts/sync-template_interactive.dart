import 'dart:io';
import 'sync-template_colors.dart';

/// Interactive file selector for choosing files to sync
class InteractiveFileSelector {
  /// Prompt user to select files to sync from a list
  static Set<String> selectFilesToSync(
    List<String> filePaths, {
    Set<String>? filesWithMasonConditions,
  }) {
    if (filePaths.isEmpty) {
      return {};
    }

    print('\nAvailable files:');
    print('─' * 60);
    
    // Display files with numbers
    final fileMap = <int, String>{};
    int index = 1;
    for (final filePath in filePaths) {
      fileMap[index] = filePath;
      final hasMason = filesWithMasonConditions?.contains(filePath) ?? false;
      final masonIndicator = hasMason
          ? ' ${ConsoleColors.mason('🔀')}'
          : '';
      // Use different color for file path when it has Mason conditions
      final filePathColor = hasMason
          ? ConsoleColors.info
          : ConsoleColors.syncedFile;
      print('  [${ConsoleColors.info('$index')}] ${filePathColor(filePath)}$masonIndicator');
      index++;
    }
    
    print('\nSelect files to SYNC:');
    print('  - Enter numbers separated by commas (e.g., 1,3,5)');
    print('  - Enter ranges (e.g., 1-5)');
    print('  - Enter "all" to sync all files');
    print('  - Enter "none" or press Enter to cancel');
    print('  - Enter "q" to quit');
    print('');
    stdout.write('Your selection: ');
    
    final input = stdin.readLineSync()?.trim() ?? '';
    
    if (input.isEmpty || input.toLowerCase() == 'none') {
      return {};
    }
    
    if (input.toLowerCase() == 'q' || input.toLowerCase() == 'quit') {
      exit(0);
    }
    
    if (input.toLowerCase() == 'all') {
      return filePaths.toSet();
    }
    
    // Parse comma-separated numbers
    final selectedIndices = <int>{};
    final parts = input.split(',');
    
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      
      // Check for ranges (e.g., "1-5")
      if (trimmed.contains('-')) {
        final rangeParts = trimmed.split('-');
        if (rangeParts.length == 2) {
          final start = int.tryParse(rangeParts[0].trim());
          final end = int.tryParse(rangeParts[1].trim());
          if (start != null && end != null) {
            for (int i = start; i <= end; i++) {
              if (fileMap.containsKey(i)) {
                selectedIndices.add(i);
              }
            }
          }
        }
      } else {
        final num = int.tryParse(trimmed);
        if (num != null && fileMap.containsKey(num)) {
          selectedIndices.add(num);
        }
      }
    }
    
    // Convert indices to file paths
    final selectedFiles = <String>{};
    for (final idx in selectedIndices) {
      final filePath = fileMap[idx];
      if (filePath != null) {
        selectedFiles.add(filePath);
      }
    }
    
    if (selectedFiles.isNotEmpty) {
      print('\n${ConsoleColors.success('Files selected to sync:')}');
      for (final file in selectedFiles) {
        final hasMason = filesWithMasonConditions?.contains(file) ?? false;
        final masonIndicator = hasMason
            ? ' ${ConsoleColors.mason('🔀')}'
            : '';
        // Use different color for file path when it has Mason conditions
        final filePathColor = hasMason
            ? ConsoleColors.info
            : ConsoleColors.syncedFile;
        print('  ${ConsoleColors.success('-')} ${filePathColor(file)}$masonIndicator');
      }
      print('');
    }
    
    return selectedFiles;
  }

  /// Show preview of files that will be synced and get confirmation
  static bool confirmSync({
    required Set<String> filesToSync,
    required List<String> allFiles,
    Set<String>? filesWithMasonConditions,
  }) {
    print('\nSync Preview');
    print('─' * 60);
    print('Files to sync: ${filesToSync.length}');
    print('Files to skip: ${allFiles.length - filesToSync.length}');
    
    if (filesToSync.isNotEmpty) {
      print('\n${ConsoleColors.success('Files that will be synced:')}');
      for (final file in filesToSync) {
        final hasMason = filesWithMasonConditions?.contains(file) ?? false;
        final masonIndicator = hasMason
            ? ' ${ConsoleColors.mason('🔀')}'
            : '';
        // Use different color for file path when it has Mason conditions
        final filePathColor = hasMason
            ? ConsoleColors.info
            : ConsoleColors.syncedFile;
        print('  ${ConsoleColors.success('-')} ${filePathColor(file)}$masonIndicator');
      }
    }
    
    if (filesToSync.length < allFiles.length) {
      final skippedFiles = allFiles.where((f) => !filesToSync.contains(f)).toList();
      if (skippedFiles.isNotEmpty) {
        print('\n${ConsoleColors.warning('Files that will be skipped:')}');
        for (final file in skippedFiles) {
          final hasMason = filesWithMasonConditions?.contains(file) ?? false;
          final masonIndicator = hasMason
              ? ' ${ConsoleColors.mason('🔀')}'
              : '';
          // Use different color for file path when it has Mason conditions
          final filePathColor = hasMason
              ? ConsoleColors.info
              : ConsoleColors.syncedFile;
          print('  ${ConsoleColors.warning('-')} ${filePathColor(file)}$masonIndicator');
        }
      }
    }
    
    print('\nProceed with sync? (y/n): ');
    final response = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    return response == 'y' || response == 'yes';
  }
}