import 'dart:io';

/// Script to migrate custom TextStyle declarations to AppTextStyles
/// 
/// This script finds and replaces common TextStyle patterns with theme equivalents.
/// It handles multi-line TextStyle declarations and preserves color overrides.
void main() async {
  print('🎨 Starting text style migration...\n');

  final directory = Directory('lib/src/features');
  final files = await _findDartFiles(directory);

  int totalFiles = 0;
  int totalReplacements = 0;

  for (final file in files) {
    final result = await _migrateFile(file);
    if (result > 0) {
      totalFiles++;
      totalReplacements += result;
      print('✅ ${file.path}: $result replacements');
    }
  }

  print('\n✨ Migration complete!');
  print('📊 Modified $totalFiles files');
  print('🔄 Made $totalReplacements text style replacements');
}

Future<List<File>> _findDartFiles(Directory dir) async {
  final files = <File>[];
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }
  return files;
}

Future<int> _migrateFile(File file) async {
  String content = await file.readAsString();
  final originalContent = content;
  int replacements = 0;

  // Define text style patterns and their replacements
  final patterns = [
    // Headings
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*32,?\s*fontWeight:\s*FontWeight\.w800,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null 
            ? 'AppTextStyles.h1.copyWith(color: $color)'
            : 'AppTextStyles.h1';
      },
      description: 'h1 (32px, w800)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*28,?\s*fontWeight:\s*FontWeight\.w700,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h2.copyWith(color: $color)'
            : 'AppTextStyles.h2';
      },
      description: 'h2 (28px, w700)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*24,?\s*fontWeight:\s*FontWeight\.w700,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h2.copyWith(color: $color)'
            : 'AppTextStyles.h2';
      },
      description: 'h2 (24px, w700)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*20,?\s*fontWeight:\s*FontWeight\.w600,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h3.copyWith(color: $color)'
            : 'AppTextStyles.h3';
      },
      description: 'h3 (20px, w600)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*18,?\s*fontWeight:\s*FontWeight\.w600,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h4.copyWith(color: $color)'
            : 'AppTextStyles.h4';
      },
      description: 'h4 (18px, w600)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*16,?\s*fontWeight:\s*FontWeight\.w700,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h5.copyWith(color: $color)'
            : 'AppTextStyles.h5';
      },
      description: 'h5 (16px, w700)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*16,?\s*fontWeight:\s*FontWeight\.w600,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.h5.copyWith(color: $color)'
            : 'AppTextStyles.h5';
      },
      description: 'h5 (16px, w600)',
    ),
    
    // Body text
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*16,?\s*fontWeight:\s*FontWeight\.w500,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.bodyLarge.copyWith(color: $color)'
            : 'AppTextStyles.bodyLarge';
      },
      description: 'bodyLarge (16px, w500)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*15,?\s*fontWeight:\s*FontWeight\.w500,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.body.copyWith(color: $color)'
            : 'AppTextStyles.body';
      },
      description: 'body (15px, w500)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*14,?\s*fontWeight:\s*FontWeight\.w500,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.bodyMedium.copyWith(color: $color)'
            : 'AppTextStyles.bodyMedium';
      },
      description: 'bodyMedium (14px, w500)',
    ),
    
    // Labels
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*14,?\s*fontWeight:\s*FontWeight\.w600,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.labelLarge.copyWith(color: $color)'
            : 'AppTextStyles.labelLarge';
      },
      description: 'labelLarge (14px, w600)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*13,?\s*fontWeight:\s*FontWeight\.w500,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.labelMedium.copyWith(color: $color)'
            : 'AppTextStyles.labelMedium';
      },
      description: 'labelMedium (13px, w500)',
    ),
    _Pattern(
      regex: RegExp(
        r'TextStyle\s*\(\s*fontSize:\s*12,?\s*fontWeight:\s*FontWeight\.w500,?\s*(?:color:\s*([^,)]+),?\s*)?\)',
        multiLine: true,
      ),
      replacement: (match) {
        final color = match.group(1);
        return color != null
            ? 'AppTextStyles.labelSmall.copyWith(color: $color)'
            : 'AppTextStyles.labelSmall';
      },
      description: 'labelSmall (12px, w500)',
    ),
  ];

  // Apply all patterns
  for (final pattern in patterns) {
    final matches = pattern.regex.allMatches(content);
    if (matches.isNotEmpty) {
      for (final match in matches) {
        final replacement = pattern.replacement(match);
        content = content.replaceFirst(match.group(0)!, replacement);
        replacements++;
      }
    }
  }

  // Write back if changed
  if (content != originalContent) {
    await file.writeAsString(content);
  }

  return replacements;
}

class _Pattern {
  final RegExp regex;
  final String Function(RegExpMatch) replacement;
  final String description;

  _Pattern({
    required this.regex,
    required this.replacement,
    required this.description,
  });
}
