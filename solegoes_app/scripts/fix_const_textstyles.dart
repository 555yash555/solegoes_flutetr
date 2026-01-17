import 'dart:io';

/// Script to remove 'const' keyword from AppTextStyles usages
/// This is needed because .copyWith() is not a const constructor
void main() async {
  print('🔧 Fixing const AppTextStyles issues...\n');

  final directory = Directory('lib/src/features');
  final files = await _findDartFiles(directory);

  int totalFiles = 0;
  int totalFixes = 0;

  for (final file in files) {
    final result = await _fixFile(file);
    if (result > 0) {
      totalFiles++;
      totalFixes += result;
      print('✅ ${file.path}: $result fixes');
    }
  }

  print('\n✨ Fix complete!');
  print('📊 Modified $totalFiles files');
  print('🔄 Made $totalFixes fixes');
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

Future<int> _fixFile(File file) async {
  String content = await file.readAsString();
  final originalContent = content;
  int fixes = 0;

  // Remove 'const ' before 'AppTextStyles.xxx.copyWith'
  final regex1 = RegExp(r'const\s+(AppTextStyles\.\w+\.copyWith)');
  final matches1 = regex1.allMatches(content).toList();
  for (final match in matches1.reversed) {
    content = content.replaceRange(match.start, match.end, match.group(1)!);
    fixes++;
  }

  // Remove 'const ' before standalone 'AppTextStyles.xxx,'
  final regex2 = RegExp(r'const\s+(AppTextStyles\.\w+),');
  final matches2 = regex2.allMatches(content).toList();
  for (final match in matches2.reversed) {
    content = content.replaceRange(match.start, match.end, '${match.group(1)},');
    fixes++;
  }

  // Also handle cases without trailing comma
  final regex3 = RegExp(r'const\s+(AppTextStyles\.\w+)\s*\)');
  final matches3 = regex3.allMatches(content).toList();
  for (final match in matches3.reversed) {
    content = content.replaceRange(match.start, match.end, '${match.group(1)})');
    fixes++;
  }

  // Write back if changed
  if (content != originalContent) {
    await file.writeAsString(content);
  }

  return fixes;
}
