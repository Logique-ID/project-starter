import 'dart:io';
import 'sync-template_config.dart';
import 'sync-template_mapper.dart';
import 'sync-template_merger.dart';

/// Represents the impact of a file change
enum ImpactType {
  direct, // File is directly updated/created
  dependency, // File depends on a changed file
  breaking, // Potential breaking change
}

/// Represents an impacted file
class ImpactedFile {
  final String path;
  final ImpactType type;
  final String reason;
  final List<String> dependencies; // Files this depends on
  final List<String> dependents = []; // Files that depend on this

  ImpactedFile({
    required this.path,
    required this.type,
    required this.reason,
    this.dependencies = const [],
  });
}

/// Impact analysis result
class ImpactAnalysis {
  final List<ImpactedFile> directChanges;
  final List<ImpactedFile> indirectImpacts;
  final Map<String, List<String>> dependencyGraph;

  ImpactAnalysis({
    required this.directChanges,
    required this.indirectImpacts,
    required this.dependencyGraph,
  });

  int get totalImpact => directChanges.length + indirectImpacts.length;
}

/// Analyzes file impacts during sync process
class ImpactAnalyzer {
  /// Analyze impact of sync operation
  static Future<ImpactAnalysis> analyzeImpact({
    required Directory refRoot,
    required Directory templateRoot,
    String? specificPath,
  }) async {
    final directChanges = <ImpactedFile>[];
    final indirectImpacts = <ImpactedFile>[];
    final dependencyGraph = <String, List<String>>{};

    // Discover files
    final refFiles = _discoverFiles(refRoot, specificPath: specificPath);

    // Build dependency graph for Dart files
    final dartFiles = refFiles.where((f) => f.path.endsWith('.dart')).toList();
    for (final dartFile in dartFiles) {
      final relativePath = PathMapper.getRelativeRefPath(
        dartFile.path,
        refRoot.path,
      );
      if (SyncConfig.shouldIgnore(relativePath)) continue;

      try {
        final content = await dartFile.readAsString();
        final imports = _extractImports(content, relativePath);
        dependencyGraph[relativePath] = imports;
      } catch (e) {
        // Skip files we can't read
      }
    }

    // Analyze each reference file
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
        if (templateFile.existsSync()) {
          // Binary file will be updated
          directChanges.add(
            ImpactedFile(
              path: relativePath,
              type: ImpactType.direct,
              reason: 'Binary file will be copied',
            ),
          );
        } else {
          // New binary file
          directChanges.add(
            ImpactedFile(
              path: relativePath,
              type: ImpactType.direct,
              reason: 'New binary file will be created',
            ),
          );
        }
        continue;
      }

      // Text file analysis
      if (!templateFile.existsSync()) {
        // New file
        directChanges.add(
          ImpactedFile(
            path: relativePath,
            type: ImpactType.direct,
            reason: 'New file will be created',
          ),
        );
      } else {
        // Existing file - check for changes
        try {
          final refContent = await refFile.readAsString();
          final templateContent = await templateFile.readAsString();
          final mergeResult = SmartMerger.merge(
            refContent,
            templateContent,
            relativePath,
          );

          if (mergeResult.hasChanges) {
            directChanges.add(
              ImpactedFile(
                path: relativePath,
                type: ImpactType.direct,
                reason: 'File content will be updated',
                dependencies: dependencyGraph[relativePath] ?? [],
              ),
            );
          }
        } catch (e) {
          // Skip files we can't analyze
        }
      }
    }

    // Find indirect impacts (files that depend on changed files)
    final changedPaths = directChanges.map((f) => f.path).toSet();
    for (final entry in dependencyGraph.entries) {
      final filePath = entry.key;
      final imports = entry.value;

      // Check if this file imports any changed file
      final hasDependency = imports.any((imp) => changedPaths.contains(imp));
      if (hasDependency && !changedPaths.contains(filePath)) {
        final dependentOn = imports
            .where((imp) => changedPaths.contains(imp))
            .toList();
        indirectImpacts.add(
          ImpactedFile(
            path: filePath,
            type: ImpactType.dependency,
            reason: 'Depends on changed files: ${dependentOn.join(", ")}',
            dependencies: dependentOn,
          ),
        );
      }
    }

    // Mark dependents for direct changes
    for (final directChange in directChanges) {
      final dependents = dependencyGraph.entries
          .where((e) => e.value.contains(directChange.path))
          .map((e) => e.key)
          .toList();
      directChange.dependents.addAll(dependents);
    }

    return ImpactAnalysis(
      directChanges: directChanges,
      indirectImpacts: indirectImpacts,
      dependencyGraph: dependencyGraph,
    );
  }

  /// Extract import statements from Dart file
  static List<String> _extractImports(String content, String filePath) {
    final imports = <String>[];
    final lines = content.split('\n');

    for (final line in lines) {
      // Match: import 'package:...' or import '...'
      // Try single quotes first
      final singleQuoteMatch = RegExp(r"import\s+'([^']+)'").firstMatch(line);
      if (singleQuoteMatch != null) {
        final importPath = singleQuoteMatch.group(1);
        if (importPath != null) {
          _processImport(importPath, filePath, imports);
        }
        continue;
      }
      // Try double quotes
      final doubleQuoteMatch = RegExp(r'import\s+"([^"]+)"').firstMatch(line);
      if (doubleQuoteMatch != null) {
        final importPath = doubleQuoteMatch.group(1);
        if (importPath != null) {
          _processImport(importPath, filePath, imports);
        }
      }
    }

    return imports;
  }

  /// Process a single import path
  static void _processImport(
    String importPath,
    String filePath,
    List<String> imports,
  ) {
    // Convert package import to relative path
    if (importPath.startsWith('package:')) {
      // Extract package name and path
      final packagePath = importPath.substring(8); // Remove 'package:'
      final parts = packagePath.split('/');

      // Try to map to file path (simplified - assumes standard structure)
      if (parts.isNotEmpty) {
        // For project-starter-ref, map to relative path
        if (parts[0] == 'project-starter-ref' ||
            parts[0].contains('project-starter-ref')) {
          final relativeImport = parts.sublist(1).join('/') + '.dart';
          imports.add(relativeImport);
        }
      }
    } else {
      // Relative import - convert to absolute relative path
      final currentDir = filePath.substring(0, filePath.lastIndexOf('/'));
      final resolvedPath = _resolveRelativePath(currentDir, importPath);
      if (resolvedPath != null) {
        imports.add(resolvedPath);
      }
    }
  }

  /// Resolve relative import path to absolute relative path
  static String? _resolveRelativePath(String currentDir, String importPath) {
    if (importPath.startsWith('../')) {
      final parts = importPath.split('/');
      var resolved = currentDir;
      for (final part in parts) {
        if (part == '..') {
          final lastSlash = resolved.lastIndexOf('/');
          if (lastSlash == -1) return null;
          resolved = resolved.substring(0, lastSlash);
        } else if (part != '.' && part.isNotEmpty) {
          resolved = '$resolved/$part';
        }
      }
      return resolved.replaceAll('.dart', '') + '.dart';
    } else if (importPath.startsWith('./')) {
      return '$currentDir/${importPath.substring(2)}';
    } else {
      return '$currentDir/$importPath';
    }
  }

  /// Discover files (same as in sync-template.dart)
  static List<File> _discoverFiles(Directory root, {String? specificPath}) {
    final files = <File>[];

    void traverse(Directory dir) {
      if (!dir.existsSync()) return;

      try {
        final entities = dir.listSync(recursive: false);

        for (final entity in entities) {
          if (entity is File) {
            final relativePath = entity.path.substring(root.path.length + 1);

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

  /// Format impact analysis for display
  static void printImpactAnalysis(ImpactAnalysis analysis) {
    print('Impact Analysis');
    print('===============');
    print('');

    print('Direct Changes (${analysis.directChanges.length}):');
    print('─' * 50);
    for (final change in analysis.directChanges) {
      print('  📝 ${change.path}');
      print('     Reason: ${change.reason}');
      if (change.dependencies.isNotEmpty) {
        print('     Dependencies: ${change.dependencies.join(", ")}');
      }
      if (change.dependents.isNotEmpty) {
        print('     Used by: ${change.dependents.length} file(s)');
      }
      print('');
    }

    if (analysis.indirectImpacts.isNotEmpty) {
      print('');
      print('Indirect Impacts (${analysis.indirectImpacts.length}):');
      print('─' * 50);
      for (final impact in analysis.indirectImpacts) {
        print('  ⚠️  ${impact.path}');
        print('     Reason: ${impact.reason}');
        print('');
      }
    }

    print('');
    print('Summary');
    print('─' * 50);
    print('Total files impacted: ${analysis.totalImpact}');
    print('  - Direct changes: ${analysis.directChanges.length}');
    print('  - Indirect impacts: ${analysis.indirectImpacts.length}');
    print('');
  }
}
