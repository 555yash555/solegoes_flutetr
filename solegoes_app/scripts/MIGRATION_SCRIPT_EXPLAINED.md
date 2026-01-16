# Migration Script Logic Explained

## 🎯 Overview

The script automatically finds and replaces custom colors and text styles with theme equivalents across all Dart files.

## 📋 How It Works

### Step 1: Find All Dart Files
```dart
// Recursively scan lib/src/features/ directory
final dartFiles = Directory('lib/src/features')
    .listSync(recursive: true)
    .where((file) => file.path.endsWith('.dart'))
    .toList();
```

**Result:** List of ~50 Dart files to process

---

### Step 2: Process Each File

For each file:
1. Read content
2. Apply regex replacements
3. Count changes
4. Write back if modified

---

### Step 3: Color Migrations (Safe & Simple)

Uses **regex pattern matching** to replace exact color values:

```dart
// Example: Replace white with 3% opacity
Pattern: r'Colors\.white\.withValues\(alpha: 0\.03\)'
Replace: 'AppColors.surfaceOverlay'

// Before:
color: Colors.white.withValues(alpha: 0.03)

// After:
color: AppColors.surfaceOverlay
```

**All Color Mappings:**
```dart
0.03 → AppColors.surfaceOverlay    // Card backgrounds
0.05 → AppColors.surfaceHover       // Hover states
0.08 → AppColors.surfaceOverlay     // Alternative surface
0.1  → AppColors.surfacePressed     // Pressed states
0.15 → AppColors.surfaceSelected    // Selected states
0.2  → AppColors.shimmer            // Loading shimmer
0.3  → AppColors.iconMuted          // Muted icons
0.4  → AppColors.textHint           // Placeholder text
0.5  → AppColors.textMuted          // Secondary text
0.6  → AppColors.textMuted          // Tertiary text
0.7  → AppColors.textPrimary        // Primary text
0.8  → AppColors.textPrimary        // Primary text

// Black colors
0.5 → AppColors.overlay             // Modal overlays
0.6 → AppColors.scrim               // Image scrims
0.7 → AppColors.scrim               // Dark scrims
0.8 → AppColors.scrim               // Very dark scrims
```

---

### Step 4: Text Style Migrations (Complex - Manual Recommended)

**Why Complex?**

Text styles have multiple properties that need to match:

```dart
// This is EASY to detect:
TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
)

// This is HARD to detect:
TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: AppColors.primary,  // Extra property!
  letterSpacing: 0.5,        // Extra property!
)
```

**Solution:** Script handles simple cases, manual review for complex ones.

---

## 🔍 Script Logic Flow

```
START
  ↓
Find all .dart files in lib/src/features/
  ↓
For each file:
  ↓
  Read file content
  ↓
  Apply Color Regex Replacements (18 patterns)
  ├─ Colors.white.withValues(alpha: 0.03) → AppColors.surfaceOverlay
  ├─ Colors.white.withValues(alpha: 0.05) → AppColors.surfaceHover
  ├─ Colors.white.withValues(alpha: 0.1)  → AppColors.surfacePressed
  └─ ... (15 more patterns)
  ↓
  Count replacements made
  ↓
  If modified:
    ├─ Write file back
    └─ Log changes
  ↓
Next file
  ↓
Print summary:
  ├─ Files modified: X
  └─ Total replacements: Y
  ↓
END
```

---

## ⚡ Execution Example

```bash
$ dart scripts/migrate_to_theme.dart

🎨 Theme Migration Script Starting...

Found 47 Dart files to process

✅ lib/src/features/home/presentation/home_screen.dart: 9 replacements
✅ lib/src/features/explore/presentation/explore_screen.dart: 8 replacements
✅ lib/src/features/trips/presentation/trip_detail_screen.dart: 31 replacements
✅ lib/src/features/profile/presentation/edit_profile_screen.dart: 19 replacements
... (43 more files)

🎉 Migration Complete!
Files modified: 35
Total replacements: 284
```

---

## ✅ Advantages

1. **Fast:** Processes 50 files in ~2 seconds
2. **Consistent:** Same replacement logic everywhere
3. **Safe:** Only replaces exact matches
4. **Reversible:** Git can revert if needed
5. **Auditable:** Shows exactly what changed

---

## ⚠️ Limitations

1. **Text Styles:** Complex patterns need manual review
2. **Context:** Doesn't understand semantic meaning
3. **Edge Cases:** May miss unusual formatting
4. **No Validation:** Doesn't check if replacement makes sense

---

## 🎯 Recommended Approach

### Phase 1: Run Script (Automated)
```bash
dart scripts/migrate_to_theme.dart
```
**Result:** ~280 color violations fixed automatically

### Phase 2: Manual Review (Careful)
1. Check git diff
2. Look for any issues
3. Fix edge cases manually

### Phase 3: Text Styles (Manual)
1. Update text styles screen by screen
2. Use AppTextStyles where appropriate
3. Test each screen

### Phase 4: Test & Commit
1. Run app and test all screens
2. Fix any visual issues
3. Commit changes

---

## 📊 Expected Results

**Before Script:**
- 384 custom color violations
- 260 custom font violations
- Total: 644 violations

**After Script:**
- ~100 custom color violations (edge cases)
- 260 custom font violations (manual)
- Total: ~360 violations

**After Manual Cleanup:**
- 0 custom color violations ✅
- 0 custom font violations ✅
- Total: 0 violations ✅

---

## 🚀 Alternative: Simpler Bash Script

If you prefer a simpler approach, here's a bash version:

```bash
#!/bin/bash

# Simple find & replace using sed

find lib/src/features -name "*.dart" -type f -exec sed -i '' \
  -e 's/Colors\.white\.withValues(alpha: 0\.03)/AppColors.surfaceOverlay/g' \
  -e 's/Colors\.white\.withValues(alpha: 0\.05)/AppColors.surfaceHover/g' \
  -e 's/Colors\.white\.withValues(alpha: 0\.1)/AppColors.surfacePressed/g' \
  -e 's/Colors\.black\.withValues(alpha: 0\.5)/AppColors.overlay/g' \
  -e 's/Colors\.black\.withValues(alpha: 0\.7)/AppColors.scrim/g' \
  {} +

echo "Migration complete!"
```

**Pros:** Even simpler, no Dart needed  
**Cons:** Less control, no reporting

---

## 💡 Recommendation

**For Your Case:**

Given you have 30+ screens with 370+ violations:

1. ✅ **Use the Dart script for colors** (safe, fast, effective)
2. ✅ **Manual migration for text styles** (needs judgment)
3. ✅ **Review and test thoroughly**

**Timeline:**
- Script run: 5 minutes
- Review: 30 minutes
- Manual text styles: 3-4 hours
- Testing: 1 hour
- **Total: ~5 hours** (vs 8 hours fully manual)

---

## 🎯 Next Steps

1. Review the script logic
2. Decide: Run script or manual?
3. If script: I'll execute it
4. Review changes together
5. Manual cleanup as needed

What do you think? Should we run the script? 🚀
