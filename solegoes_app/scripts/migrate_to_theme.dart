#!/usr/bin/env dart

/// Theme Migration Script
/// Automatically migrates custom colors and text styles to use AppColors and AppTextStyles
/// 
/// Usage: dart scripts/migrate_to_theme.dart

import 'dart:io';

void main() {
  print('🎨 Theme Migration Script Starting...\n');
  
  // Find all Dart files in features directory
  final featuresDir = Directory('lib/src/features');
  final dartFiles = featuresDir
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();
  
  print('Found ${dartFiles.length} Dart files to process\n');
  
  int totalFilesModified = 0;
  int totalReplacements = 0;
  
  for (final file in dartFiles) {
    final result = migrateFile(file);
    if (result.modified) {
      totalFilesModified++;
      totalReplacements += result.replacementCount;
      print('✅ ${file.path}: ${result.replacementCount} replacements');
    }
  }
  
  print('\n🎉 Migration Complete!');
  print('Files modified: $totalFilesModified');
  print('Total replacements: $totalReplacements');
}

class MigrationResult {
  final bool modified;
  final int replacementCount;
  
  MigrationResult(this.modified, this.replacementCount);
}

MigrationResult migrateFile(File file) {
  String content = file.readAsStringSync();
  final originalContent = content;
  int replacements = 0;
  
  // ========================================
  // PHASE 1: COLOR MIGRATIONS
  // ========================================
  
  final colorMigrations = {
    // Surface states
    r'Colors\.white\.withValues\(alpha: 0\.03\)': 'AppColors.surfaceOverlay',
    r'Colors\.white\.withValues\(alpha: 0\.05\)': 'AppColors.surfaceHover',
    r'Colors\.white\.withValues\(alpha: 0\.08\)': 'AppColors.surfaceOverlay',
    r'Colors\.white\.withValues\(alpha: 0\.1\)': 'AppColors.surfacePressed',
    r'Colors\.white\.withValues\(alpha: 0\.15\)': 'AppColors.surfaceSelected',
    
    // Text variations
    r'Colors\.white\.withValues\(alpha: 0\.2\)': 'AppColors.shimmer',
    r'Colors\.white\.withValues\(alpha: 0\.3\)': 'AppColors.iconMuted',
    r'Colors\.white\.withValues\(alpha: 0\.4\)': 'AppColors.textHint',
    r'Colors\.white\.withValues\(alpha: 0\.5\)': 'AppColors.textMuted',
    r'Colors\.white\.withValues\(alpha: 0\.6\)': 'AppColors.textMuted',
    r'Colors\.white\.withValues\(alpha: 0\.7\)': 'AppColors.textPrimary',
    r'Colors\.white\.withValues\(alpha: 0\.8\)': 'AppColors.textPrimary',
    
    // Overlays & scrims
    r'Colors\.black\.withValues\(alpha: 0\.2\)': 'AppColors.shimmer',
    r'Colors\.black\.withValues\(alpha: 0\.3\)': 'AppColors.iconMuted',
    r'Colors\.black\.withValues\(alpha: 0\.4\)': 'AppColors.scrimLight',
    r'Colors\.black\.withValues\(alpha: 0\.5\)': 'AppColors.overlay',
    r'Colors\.black\.withValues\(alpha: 0\.6\)': 'AppColors.scrim',
    r'Colors\.black\.withValues\(alpha: 0\.7\)': 'AppColors.scrim',
    r'Colors\.black\.withValues\(alpha: 0\.8\)': 'AppColors.scrim',
    
    // Category pills
    r'AppColors\.primary\.withValues\(alpha: 0\.15\)': 'AppColors.pillActiveBg',
  };
  
  for (final entry in colorMigrations.entries) {
    final pattern = RegExp(entry.key);
    final matches = pattern.allMatches(content).length;
    if (matches > 0) {
      content = content.replaceAll(pattern, entry.value);
      replacements += matches;
    }
  }
  
  // ========================================
  // PHASE 2: TEXT STYLE MIGRATIONS
  // ========================================
  
  // This is more complex - need to match entire TextStyle blocks
  // For now, we'll do simple font weight replacements
  
  final textStylePatterns = [
    // H1: fontSize: 32, fontWeight: w800
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*32,?\s*fontWeight:\s*FontWeight\.w800',
      'replacement': 'AppTextStyles.h1',
      'needsCopyWith': true,
    },
    
    // H2: fontSize: 24, fontWeight: w700
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*24,?\s*fontWeight:\s*FontWeight\.w700',
      'replacement': 'AppTextStyles.h2',
      'needsCopyWith': true,
    },
    
    // H3: fontSize: 20, fontWeight: w600
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*20,?\s*fontWeight:\s*FontWeight\.w600',
      'replacement': 'AppTextStyles.h3',
      'needsCopyWith': true,
    },
    
    // H4: fontSize: 18, fontWeight: w600
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*18,?\s*fontWeight:\s*FontWeight\.w600',
      'replacement': 'AppTextStyles.h4',
      'needsCopyWith': true,
    },
    
    // Body: fontSize: 15, fontWeight: w500
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*15,?\s*fontWeight:\s*FontWeight\.w500',
      'replacement': 'AppTextStyles.body',
      'needsCopyWith': true,
    },
    
    // Label Large: fontSize: 14, fontWeight: w600
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*14,?\s*fontWeight:\s*FontWeight\.w600',
      'replacement': 'AppTextStyles.labelLarge',
      'needsCopyWith': true,
    },
    
    // Section Title: fontSize: 12, fontWeight: w700, letterSpacing: 0.5
    {
      'pattern': r'TextStyle\(\s*fontSize:\s*12,?\s*fontWeight:\s*FontWeight\.w700,?\s*color:\s*AppColors\.textTertiary,?\s*letterSpacing:\s*0\.5',
      'replacement': 'AppTextStyles.sectionTitle',
      'needsCopyWith': false,
    },
  ];
  
  // Note: Full text style migration is complex and risky
  // Better to do manually or with more sophisticated parsing
  // For now, we'll just do color migrations
  
  // ========================================
  // SAVE FILE IF MODIFIED
  // ========================================
  
  if (content != originalContent) {
    file.writeAsStringSync(content);
    return MigrationResult(true, replacements);
  }
  
  return MigrationResult(false, 0);
}
