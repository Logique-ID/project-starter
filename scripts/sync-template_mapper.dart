import 'dart:io';

/// Handles path and content transformations from reference to template
class PathMapper {
  /// Transform a file path from reference structure to template structure
  static String mapPath(String refPath) {
    String mapped = refPath;

    // Replace project-starter-ref directory name with {{project_name}}
    mapped = mapped.replaceAll('project-starter-ref', '{{project_name}}');

    // Handle conditional file names (e.g., {{#use_firebase}}file.sh{{/use_firebase}})
    // These are already in template, so we need to preserve them
    // For now, we'll handle this in the file sync logic

    return mapped;
  }

  /// Transform content from reference format to template format
  static String mapContent(String content, String filePath) {
    String mapped = content;

    // Replace project name references
    mapped = mapped.replaceAll('project-starter-ref', '{{project_name}}');

    // Replace app ID references
    mapped = mapped.replaceAll(RegExp(r'\bid\.logique\.trial\b'), '{{app_id}}');

    // Replace app name references (be careful with quotes and context)
    // Only replace when it's clearly an app name, not in comments or other contexts
    mapped = mapped.replaceAllMapped(
      RegExp(r'("Trial"|name:\s*"Trial"|name:\s*Trial)'),
      (match) {
        if (match.group(1)!.contains('name:')) {
          return match.group(1)!.replaceAll('Trial', '{{app_name}}');
        }
        return '"{{app_name}}"';
      },
    );

    // Handle flavorizr config app names
    mapped = mapped.replaceAllMapped(
      RegExp(r'name:\s*"Trial\s*\[(DEV|STG)\]"'),
      (match) => 'name: "{{app_name}} [${match.group(1)!}]"',
    );
    mapped = mapped.replaceAllMapped(
      RegExp(r'name:\s*"Trial"'),
      (match) => 'name: "{{app_name}}"',
    );

    // Replace package/application IDs in various formats
    mapped = mapped.replaceAll('id.logique.trial.dev', '{{app_id}}.dev');
    mapped = mapped.replaceAll('id.logique.trial.stg', '{{app_id}}.stg');
    mapped = mapped.replaceAll('id.logique.trial', '{{app_id}}');

    // Handle Kotlin package paths
    mapped = mapped.replaceAll(
      'package id.logique.trial',
      'package {{app_id}}',
    );
    mapped = mapped.replaceAll(
      RegExp(r'package\s+id\.logique\.trial'),
      'package {{app_id}}',
    );

    // Handle import paths (both single and double quotes)
    mapped = mapped.replaceAll(
      RegExp(r"import\s+'id\.logique\.trial"),
      "import '{{app_id}}",
    );
    mapped = mapped.replaceAll(
      RegExp(r'import\s+"id\.logique\.trial'),
      'import "{{app_id}}',
    );

    return mapped;
  }

  /// Get the relative path from reference root
  static String getRelativeRefPath(String fullPath, String refRoot) {
    final refPath = Directory(refRoot).absolute.path;
    final filePath = File(fullPath).absolute.path;

    if (!filePath.startsWith(refPath)) {
      throw ArgumentError('Path $filePath is not under $refRoot');
    }

    return filePath.substring(refPath.length + 1);
  }

  /// Get the corresponding template path for a reference path
  static String getTemplatePath(String refRelativePath) {
    // Replace project-starter-ref with {{project_name}} in path
    String templatePath = refRelativePath.replaceAll(
      'project-starter-ref',
      '{{project_name}}',
    );

    // Handle conditional file names - check if template has conditional version
    // This will be handled during file sync

    return templatePath;
  }

  /// Check if a file name in template is conditional (e.g., {{#var}}file{{/var}})
  static bool isConditionalFileName(String fileName) {
    return RegExp(r'\{\{[#^/].*?\}\}').hasMatch(fileName);
  }

  /// Extract the base file name from a conditional file name
  static String? extractBaseFileName(String conditionalFileName) {
    // Remove all Mason tags to get base name
    final cleaned = conditionalFileName.replaceAll(
      RegExp(r'\{\{[#^/].*?\}\}'),
      '',
    );
    return cleaned.isEmpty ? null : cleaned;
  }
}
