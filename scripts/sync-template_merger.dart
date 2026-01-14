import 'sync-template_parser.dart';
import 'sync-template_mapper.dart';

/// Result of a merge operation
class MergeResult {
  final String mergedContent;
  final bool hasChanges;
  final List<String> warnings;

  MergeResult({
    required this.mergedContent,
    this.hasChanges = false,
    this.warnings = const [],
  });
}

/// Smart merger that preserves Mason variables while syncing content
class SmartMerger {
  /// Normalize content for comparison by removing whitespace-only differences
  /// - Normalizes line endings to \n
  /// - Trims trailing whitespace from each line
  /// - Preserves leading indentation and meaningful whitespace
  static String _normalizeForComparison(String content) {
    return content
        .split('\n')
        .map(
          (line) => line.replaceAll(RegExp(r'[ \t]+$'), ''),
        ) // Trim trailing spaces/tabs
        .join('\n')
        .replaceAll(RegExp(r'\r\n'), '\n') // Normalize line endings
        .replaceAll(RegExp(r'\r'), '\n');
  }

  /// Compare two strings ignoring whitespace-only differences
  static bool _hasContentChanges(String content1, String content2) {
    final normalized1 = _normalizeForComparison(content1);
    final normalized2 = _normalizeForComparison(content2);
    return normalized1 != normalized2;
  }

  /// Merge reference content into template while preserving Mason variables
  static MergeResult merge(
    String refContent,
    String templateContent,
    String filePath,
  ) {
    // If template has no Mason variables, just map and return ref content
    if (!MasonParser.hasMasonVariables(templateContent)) {
      final mapped = PathMapper.mapContent(refContent, filePath);
      return MergeResult(
        mergedContent: mapped,
        hasChanges: _hasContentChanges(mapped, templateContent),
      );
    }

    // Parse template to extract all blocks and variables
    final templateParse = MasonParser.parseFile(templateContent);
    final templateBlocks = templateParse['blocks'] as List<MasonBlock>;
    final templateVariables = templateParse['variables'] as List<MasonVariable>;

    // Map reference content
    String mappedRefContent = PathMapper.mapContent(refContent, filePath);

    // If template has blocks, we need to preserve them
    if (templateBlocks.isNotEmpty) {
      return _mergeWithBlocks(
        mappedRefContent,
        templateContent,
        templateBlocks,
        filePath,
      );
    }

    // If template only has simple variables, preserve them
    if (templateVariables.isNotEmpty) {
      return _mergeWithVariables(
        mappedRefContent,
        templateContent,
        templateVariables,
        filePath,
      );
    }

    // Fallback: just return mapped ref content
    return MergeResult(
      mergedContent: mappedRefContent,
      hasChanges: _hasContentChanges(mappedRefContent, templateContent),
    );
  }

  /// Merge when template has conditional blocks
  static MergeResult _mergeWithBlocks(
    String refContent,
    String templateContent,
    List<MasonBlock> blocks,
    String filePath,
  ) {
    String result = templateContent;
    final warnings = <String>[];

    // Sort blocks by start line (descending) to process from end to start
    final sortedBlocks = List<MasonBlock>.from(blocks)
      ..sort((a, b) => b.startLine.compareTo(a.startLine));

    // For each block, try to find corresponding content in ref
    for (final block in sortedBlocks) {
      final blockContent = block.content;
      final blockLines = blockContent.split('\n');

      // Try to find this content in ref (with some flexibility)
      final refLines = refContent.split('\n');

      // Look for the block content in ref
      int? refStartIndex;
      int? refEndIndex;

      // Try to find matching content - look for key lines from the block
      // First, extract meaningful lines (non-empty, non-comment-only)
      final meaningfulBlockLines = blockLines
          .where((line) {
            final cleaned = _removeMasonVars(line.trim());
            return cleaned.isNotEmpty &&
                !cleaned.startsWith('//') &&
                !cleaned.startsWith('#');
          })
          .map((line) => _removeMasonVars(line.trim()))
          .toList();

      if (meaningfulBlockLines.isNotEmpty) {
        // Look for the first meaningful line in ref
        final firstKeyLine = meaningfulBlockLines.first;
        for (int i = 0; i < refLines.length; i++) {
          final refLineClean = _removeMasonVars(refLines[i].trim());
          if (refLineClean == firstKeyLine) {
            // Found potential match - check if subsequent lines match
            int matchCount = 0;
            for (
              int j = 0;
              j < meaningfulBlockLines.length && i + j < refLines.length;
              j++
            ) {
              final refLine = _removeMasonVars(refLines[i + j].trim());
              if (refLine == meaningfulBlockLines[j]) {
                matchCount++;
              }
            }

            // If at least 70% of meaningful lines match, consider it a match
            if (matchCount >= (meaningfulBlockLines.length * 0.7).ceil()) {
              // Find the actual block boundaries by looking for surrounding context
              refStartIndex = i;
              // Estimate end - look for similar structure
              refEndIndex = i + blockLines.length;
              if (refEndIndex > refLines.length) {
                refEndIndex = refLines.length;
              }
              break;
            }
          }
        }
      }

      // Fallback: if no match found, try exact matching (original approach)
      if (refStartIndex == null) {
        for (int i = 0; i <= refLines.length - blockLines.length; i++) {
          bool allMatch = true;
          for (int j = 0; j < blockLines.length; j++) {
            final templateLine = blockLines[j].trim();
            final refLine = refLines[i + j].trim();

            // Compare lines, ignoring Mason variables
            final templateLineClean = _removeMasonVars(templateLine);
            final refLineClean = _removeMasonVars(refLine);

            if (templateLineClean != refLineClean &&
                templateLineClean.isNotEmpty) {
              allMatch = false;
              break;
            }
          }

          if (allMatch && blockLines.isNotEmpty) {
            refStartIndex = i;
            refEndIndex = i + blockLines.length;
            break;
          }
        }
      }

      // If we found matching content, update it
      if (refStartIndex != null && refEndIndex != null) {
        final newBlockContent = refLines
            .sublist(refStartIndex, refEndIndex)
            .join('\n');

        // Map the content
        final mappedContent = PathMapper.mapContent(newBlockContent, filePath);

        // Replace the block content in result
        final openTag = block.isInverted
            ? '{{^${block.variable}}}'
            : '{{#${block.variable}}}';
        final closeTag = '{{/${block.variable}}}';
        final oldBlock = '$openTag\n$blockContent\n$closeTag';
        final newBlock = '$openTag\n$mappedContent\n$closeTag';

        result = result.replaceFirst(oldBlock, newBlock);
      } else {
        // Couldn't find matching content - keep template block as-is
        warnings.add(
          'Could not find matching content for block {{#${block.variable}}} in ref, keeping template version',
        );
      }
    }

    // Now handle content outside blocks - replace with ref content
    // This is tricky - we need to preserve block structure but update non-block content
    result = _updateNonBlockContent(result, refContent, blocks, filePath);

    return MergeResult(
      mergedContent: result,
      hasChanges: _hasContentChanges(result, templateContent),
      warnings: warnings,
    );
  }

  /// Merge when template only has simple variables
  static MergeResult _mergeWithVariables(
    String refContent,
    String templateContent,
    List<MasonVariable> variables,
    String filePath,
  ) {
    // Map ref content
    String mappedRef = PathMapper.mapContent(refContent, filePath);

    // Merge line by line, preserving Mason variables from template
    final refLines = mappedRef.split('\n');
    final templateLines = templateContent.split('\n');
    final resultLines = <String>[];

    // Create a map of line numbers to variables for quick lookup
    final variablesByLine = <int, List<MasonVariable>>{};
    for (final variable in variables) {
      variablesByLine.putIfAbsent(variable.line, () => []).add(variable);
    }

    final maxLines = refLines.length > templateLines.length
        ? refLines.length
        : templateLines.length;

    for (int i = 0; i < maxLines; i++) {
      final lineNum = i + 1;
      final templateLine = i < templateLines.length ? templateLines[i] : '';
      final refLine = i < refLines.length ? refLines[i] : '';

      // If this line has Mason variables in the template, preserve the template line
      if (variablesByLine.containsKey(lineNum)) {
        resultLines.add(templateLine);
      } else if (i >= templateLines.length) {
        // Template is shorter, add ref lines
        resultLines.add(refLine);
      } else if (i >= refLines.length) {
        // Ref is shorter, keep template lines
        resultLines.add(templateLine);
      } else {
        // Both exist - use ref line (which is already mapped)
        resultLines.add(refLine);
      }
    }

    final result = resultLines.join('\n');

    return MergeResult(
      mergedContent: result,
      hasChanges: _hasContentChanges(result, templateContent),
    );
  }

  /// Update content that's not inside Mason blocks
  static String _updateNonBlockContent(
    String template,
    String refContent,
    List<MasonBlock> blocks,
    String filePath,
  ) {
    // Create a set of line numbers that are inside blocks
    final blockLineNumbers = <int>{};
    for (final block in blocks) {
      for (int i = block.startLine; i <= block.endLine; i++) {
        blockLineNumbers.add(i);
      }
    }

    final templateLines = template.split('\n');
    final mappedRefLines = PathMapper.mapContent(
      refContent,
      filePath,
    ).split('\n');
    final resultLines = <String>[];

    // For lines outside blocks, use ref content
    // For lines inside blocks, keep template (blocks are already updated above)
    for (int i = 0; i < templateLines.length; i++) {
      final lineNum = i + 1;
      final templateLine = templateLines[i];

      if (blockLineNumbers.contains(lineNum)) {
        // Inside a block - keep template line (block content was already updated)
        resultLines.add(templateLine);
      } else if (MasonParser.hasMasonVariables(templateLine)) {
        // Has Mason variables but not in a block - keep template
        resultLines.add(templateLine);
      } else {
        // Outside block - use ref content if available
        if (i < mappedRefLines.length) {
          final refLine = mappedRefLines[i];
          // Only use ref line if it doesn't have unexpected Mason vars
          if (!MasonParser.hasMasonVariables(refLine) ||
              refLine.contains('{{project_name}}') ||
              refLine.contains('{{app_id}}') ||
              refLine.contains('{{app_name}}')) {
            resultLines.add(refLine);
          } else {
            resultLines.add(templateLine);
          }
        } else {
          resultLines.add(templateLine);
        }
      }
    }

    return resultLines.join('\n');
  }

  /// Remove Mason variable syntax from a line for comparison
  static String _removeMasonVars(String line) {
    return line.replaceAll(RegExp(r'\{\{.*?\}\}'), '').trim();
  }
}
