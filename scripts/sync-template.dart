#!/usr/bin/env dart

import 'dart:io';
import 'sync-template_config.dart';
import 'sync-template_mapper.dart';
import 'sync-template_merger.dart';
import 'sync-template_impact.dart';
import 'sync-template_interactive.dart';
import 'sync-template_parser.dart';
import 'sync-template_colors.dart';

/// Main sync script for updating Mason template from reference project
void main(List<String> args) async {
  final dryRun = args.contains('--dry-run') || args.contains('-n');
  final verbose = args.contains('--verbose') || args.contains('-v');
  final showImpact =
      args.contains('--show-impact') || args.contains('--impact');
  final interactive = args.contains('--interactive') || args.contains('-i');

  // Parse --path argument
  String? specificPath;
  final pathIndex = args.indexOf('--path');
  if (pathIndex != -1 && pathIndex + 1 < args.length) {
    specificPath = args[pathIndex + 1];
  }

  // Resolve paths
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final projectRoot = scriptDir.parent;
  final refRoot = Directory(projectRoot.path + '/${SyncConfig.refPath}');
  final templateRoot = Directory(
    projectRoot.path + '/${SyncConfig.templatePath}',
  );

  if (!refRoot.existsSync()) {
    print('Error: Reference directory not found: ${refRoot.path}');
    exit(1);
  }

  if (!templateRoot.existsSync()) {
    print('Error: Template directory not found: ${templateRoot.path}');
    exit(1);
  }

  // If show impact only, run analysis and exit
  if (showImpact) {
    final analysis = await ImpactAnalyzer.analyzeImpact(
      refRoot: refRoot,
      templateRoot: templateRoot,
      specificPath: specificPath,
    );
    ImpactAnalyzer.printImpactAnalysis(analysis);
    return;
  }

  print('Mason Template Sync');
  print('===================');
  if (dryRun) {
    print('DRY RUN MODE - No files will be modified\n');
  }
  print('');
  print(
    'Note: Template files may contain Mason conditions (e.g., {{#use_firebase}}...{{/use_firebase}})',
  );
  print('      Files with Mason conditions are marked with 🔀');
  print(
    '      These conditions will be preserved during sync. Only content inside blocks will be updated.',
  );
  print('');

  print('Reference: ${refRoot.path}');
  print('Template:  ${templateRoot.path}');
  print('');

  // Discover files
  final refFiles = _discoverFiles(refRoot, specificPath: specificPath);
  final templateFiles = _discoverFiles(
    templateRoot,
    specificPath: specificPath,
  );

  print('Found ${refFiles.length} files in reference');
  print('Found ${templateFiles.length} files in template');
  print('');

  // Get list of files that will be processed (before filtering)
  final filesToProcess = <String>[];
  final filesToSync = <String>{};
  final filesWithMasonConditions = <String>{};

  // If interactive mode, use same detection logic as impact analysis
  if (interactive) {
    print('Analyzing files that will be changed...');
    print('');

    // Use same detection logic as impact analyzer
    for (final refFile in refFiles) {
      final relativePath = PathMapper.getRelativeRefPath(
        refFile.path,
        refRoot.path,
      );
      final templatePath = PathMapper.getTemplatePath(relativePath);
      final templateFile = File('${templateRoot.path}/$templatePath');

      if (SyncConfig.shouldIgnore(relativePath)) continue;

      // Check if binary
      bool isBinary = SyncConfig.isBinaryFile(relativePath);
      if (!isBinary) {
        try {
          await refFile.readAsString();
        } catch (e) {
          isBinary = true;
        }
      }

      if (isBinary) {
        // Binary files that will be updated or created
        if (templateFile.existsSync() || !templateFile.existsSync()) {
          filesToProcess.add(relativePath);
        }
        continue;
      }

      // Text file analysis
      if (!templateFile.existsSync()) {
        // New file
        filesToProcess.add(relativePath);
      } else {
        // Existing file - check for changes
        try {
          final refContent = await refFile.readAsString();
          final templateContent = await templateFile.readAsString();

          // Check if template has Mason conditional blocks
          final hasMasonConditions =
              MasonParser.hasMasonVariables(templateContent) &&
              (MasonParser.parseFile(templateContent)['blocks'] as List)
                  .isNotEmpty;
          if (hasMasonConditions) {
            filesWithMasonConditions.add(relativePath);
          }

          final mergeResult = SmartMerger.merge(
            refContent,
            templateContent,
            relativePath,
          );

          if (mergeResult.hasChanges) {
            filesToProcess.add(relativePath);
          }
        } catch (e) {
          // Skip files we can't analyze
        }
      }
    }

    if (filesToProcess.isNotEmpty) {
      final selectedFiles = InteractiveFileSelector.selectFilesToSync(
        filesToProcess,
        filesWithMasonConditions: filesWithMasonConditions,
      );

      if (selectedFiles.isEmpty) {
        print('No files selected. Sync cancelled.');
        return;
      }

      filesToSync.addAll(selectedFiles);

      if (!InteractiveFileSelector.confirmSync(
        filesToSync: filesToSync,
        allFiles: filesToProcess,
        filesWithMasonConditions: filesWithMasonConditions,
      )) {
        print('Sync cancelled.');
        return;
      }
    } else {
      print('No files will be changed. Nothing to sync.');
      return;
    }
  }

  // Statistics
  int filesUpdated = 0;
  int filesCreated = 0;
  int filesSkipped = 0;
  int filesUnchanged = 0;
  final warnings = <String>[];

  // Process each reference file
  for (final refFile in refFiles) {
    final relativePath = PathMapper.getRelativeRefPath(
      refFile.path,
      refRoot.path,
    );
    final templatePath = PathMapper.getTemplatePath(relativePath);
    final templateFile = File('${templateRoot.path}/$templatePath');

    // Check if should ignore (config-based)
    if (SyncConfig.shouldIgnore(relativePath)) {
      if (verbose) {
        print('Skipping (ignored): $relativePath');
      }
      filesSkipped++;
      continue;
    }

    // In interactive mode, only sync selected files
    if (interactive && !filesToSync.contains(relativePath)) {
      if (verbose || interactive) {
        print('Skipping (not selected): $relativePath');
      }
      filesSkipped++;
      continue;
    }

    // Check if binary file or try to read as text
    String? refContent;
    bool isBinary = false;

    if (SyncConfig.isBinaryFile(relativePath)) {
      isBinary = true;
    } else {
      // Try to read as text, catch encoding errors
      try {
        refContent = await refFile.readAsString();
      } catch (e) {
        // File might be binary even if extension doesn't indicate it
        isBinary = true;
      }
    }

    if (isBinary) {
      // Binary files: direct copy
      if (dryRun) {
        print(
          '${ConsoleColors.dryRun('[DRY RUN]')} Would copy binary: ${ConsoleColors.syncedFile(relativePath)}',
        );
      } else {
        if (!templateFile.parent.existsSync()) {
          templateFile.parent.createSync(recursive: true);
        }
        await refFile.copy(templateFile.path);
        print('${ConsoleColors.syncedFile('Copied binary:')} $relativePath');
      }
      filesUpdated++;
      continue;
    }

    // refContent is guaranteed to be non-null here
    final refContentFinal = refContent!;

    // Check if template file exists
    if (!templateFile.existsSync()) {
      // New file - copy as-is (with path mapping)
      final mappedContent = PathMapper.mapContent(
        refContentFinal,
        relativePath,
      );

      if (dryRun) {
        print(
          '${ConsoleColors.dryRun('[DRY RUN]')} Would create: ${ConsoleColors.syncedFile(templatePath)}',
        );
      } else {
        if (!templateFile.parent.existsSync()) {
          templateFile.parent.createSync(recursive: true);
        }
        await templateFile.writeAsString(mappedContent);
        print('${ConsoleColors.syncedFile(templatePath)}');
      }
      filesCreated++;
      continue;
    }

    // Existing file - smart merge
    String? templateContent;
    try {
      templateContent = await templateFile.readAsString();
    } catch (e) {
      // Template file might be binary - skip it
      if (verbose) {
        print('Skipping binary template file: $relativePath');
      }
      filesSkipped++;
      continue;
    }

    // Check if template has Mason conditional blocks
    final hasMasonConditions =
        MasonParser.hasMasonVariables(templateContent) &&
        (MasonParser.parseFile(templateContent)['blocks'] as List).isNotEmpty;
    final masonIndicator = hasMasonConditions
        ? ' ${ConsoleColors.mason('🔀')}'
        : '';

    // Use different color for file path when it has Mason conditions
    final filePathColor = hasMasonConditions
        ? ConsoleColors.info
        : ConsoleColors.syncedFile;

    final mergeResult = SmartMerger.merge(
      refContentFinal,
      templateContent,
      relativePath,
    );

    if (mergeResult.warnings.isNotEmpty) {
      warnings.addAll(mergeResult.warnings.map((w) => '$relativePath: $w'));
    }

    if (mergeResult.hasChanges) {
      if (dryRun) {
        print(
          '${ConsoleColors.dryRun('[DRY RUN]')} Would update: ${filePathColor(relativePath)}$masonIndicator',
        );
        if (verbose && mergeResult.warnings.isNotEmpty) {
          for (final warning in mergeResult.warnings) {
            print('  ${ConsoleColors.warning('Warning:')} $warning');
          }
        }
      } else {
        await templateFile.writeAsString(mergeResult.mergedContent);
        print('${filePathColor(relativePath)}$masonIndicator');
        if (verbose && mergeResult.warnings.isNotEmpty) {
          for (final warning in mergeResult.warnings) {
            print('  ${ConsoleColors.warning('Warning:')} $warning');
          }
        }
      }
      filesUpdated++;
    } else {
      if (verbose) {
        print('${filePathColor(relativePath)}$masonIndicator');
      }
      filesUnchanged++;
    }
  }

  // Summary
  print('');
  print('Summary');
  print('=======');
  print('Files updated:  $filesUpdated');
  print('Files created:  $filesCreated');
  print('Files unchanged: $filesUnchanged');
  print('Files skipped:  $filesSkipped');

  if (warnings.isNotEmpty) {
    print('');
    print('Warnings:');
    for (final warning in warnings) {
      print('  - $warning');
    }
  }

  // Add note about Mason conditions if any files were processed
  if (filesUpdated > 0 || filesCreated > 0) {
    print('');
    print(
      'Note: Mason conditions ({{#variable}}...{{/variable}}) in template files',
    );
    print(
      '      have been preserved. Only content within these blocks was updated.',
    );
  }

  if (dryRun) {
    print('');
    print('This was a dry run. Run without --dry-run to apply changes.');
  }
}

/// Discover all files in a directory (excluding ignored patterns)
List<File> _discoverFiles(Directory root, {String? specificPath}) {
  final files = <File>[];

  void traverse(Directory dir) {
    if (!dir.existsSync()) return;

    try {
      final entities = dir.listSync(recursive: false);

      for (final entity in entities) {
        if (entity is File) {
          final relativePath = entity.path.substring(root.path.length + 1);

          // Apply specific path filter if provided
          if (specificPath != null) {
            if (!relativePath.startsWith(specificPath)) {
              continue;
            }
          }

          if (!SyncConfig.shouldIgnore(relativePath)) {
            files.add(entity);
          }
        } else if (entity is Directory) {
          traverse(entity);
        }
      }
    } catch (e) {
      // Skip directories we can't read
    }
  }

  traverse(root);
  return files;
}
