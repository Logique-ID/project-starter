/// Represents a Mason variable block in a template file
class MasonBlock {
  final String variable;
  final String content;
  final int startLine;
  final int endLine;
  final bool isInverted; // {{^var}} vs {{#var}}
  final List<MasonBlock> nestedBlocks;

  MasonBlock({
    required this.variable,
    required this.content,
    required this.startLine,
    required this.endLine,
    this.isInverted = false,
    this.nestedBlocks = const [],
  });

  /// Get the full block text including tags
  String get fullBlock {
    final openTag = isInverted ? '{{^$variable}}' : '{{#$variable}}';
    final closeTag = '{{/$variable}}';
    return '$openTag\n$content\n$closeTag';
  }
}

/// Represents a simple Mason variable (not a block)
class MasonVariable {
  final String variable;
  final int line;
  final int column;

  MasonVariable({
    required this.variable,
    required this.line,
    required int col,
  }) : column = col;
}

/// Parses Mason/Mustache template files to extract variable blocks and simple variables
class MasonParser {
  /// Parse a template file and extract all Mason blocks and variables
  static Map<String, dynamic> parseFile(String content) {
    final blocks = <MasonBlock>[];
    final variables = <MasonVariable>[];
    final lines = content.split('\n');

    // Track open blocks with stack
    final blockStack = <({String variable, int startLine, bool isInverted})>[];
    final blockContent = <int, StringBuffer>{};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;

      // Check for opening block tags: {{#var}} or {{^var}}
      final openBlockMatch = RegExp(r'\{\{([#^])(\w+)\}\}').firstMatch(line);
      if (openBlockMatch != null) {
        final isInverted = openBlockMatch.group(1) == '^';
        final variable = openBlockMatch.group(2)!;
        blockStack.add((variable: variable, startLine: lineNum, isInverted: isInverted));
        blockContent[lineNum] = StringBuffer();
        continue;
      }

      // Check for closing block tags: {{/var}}
      final closeBlockMatch = RegExp(r'\{\{/(\w+)\}\}').firstMatch(line);
      if (closeBlockMatch != null) {
        final variable = closeBlockMatch.group(1)!;
        // Find matching open block
        for (int j = blockStack.length - 1; j >= 0; j--) {
          if (blockStack[j].variable == variable) {
            final openBlock = blockStack.removeAt(j);
            final content = blockContent.remove(openBlock.startLine)?.toString() ?? '';
            
            blocks.add(MasonBlock(
              variable: variable,
              content: content,
              startLine: openBlock.startLine,
              endLine: lineNum,
              isInverted: openBlock.isInverted,
            ));
            break;
          }
        }
        continue;
      }

      // Check for simple variables: {{var}}
      final simpleVarMatches = RegExp(r'\{\{(\w+)\}\}').allMatches(line);
      for (final match in simpleVarMatches) {
        final variable = match.group(1)!;
        // Only add if not part of a block tag
        if (!match.group(0)!.contains('#') && 
            !match.group(0)!.contains('^') && 
            !match.group(0)!.contains('/')) {
          variables.add(MasonVariable(
            variable: variable,
            line: lineNum,
            col: match.start,
          ));
        }
      }

      // Add line to current block content if inside a block
      if (blockStack.isNotEmpty) {
        final currentBlock = blockStack.last;
        final contentBuffer = blockContent[currentBlock.startLine];
        if (contentBuffer != null) {
          if (contentBuffer.isNotEmpty) {
            contentBuffer.writeln();
          }
          contentBuffer.write(line);
        }
      }
    }

    return {
      'blocks': blocks,
      'variables': variables,
    };
  }

  /// Extract all variable names used in blocks
  static Set<String> extractBlockVariables(String content) {
    final variables = <String>{};
    final blockRegex = RegExp(r'\{\{[#^](\w+)\}\}');
    
    for (final match in blockRegex.allMatches(content)) {
      variables.add(match.group(1)!);
    }
    
    return variables;
  }

  /// Check if content contains Mason variables
  static bool hasMasonVariables(String content) {
    return RegExp(r'\{\{.*?\}\}').hasMatch(content);
  }

  /// Get the raw content inside a block (without the tags)
  static String? getBlockContent(String templateContent, String variable, {bool inverted = false}) {
    final openTag = inverted ? '{{^$variable}}' : '{{#$variable}}';
    final closeTag = '{{/$variable}}';
    
    final openIndex = templateContent.indexOf(openTag);
    if (openIndex == -1) return null;
    
    final contentStart = openIndex + openTag.length;
    final closeIndex = templateContent.indexOf(closeTag, contentStart);
    if (closeIndex == -1) return null;
    
    return templateContent.substring(contentStart, closeIndex).trim();
  }
}
