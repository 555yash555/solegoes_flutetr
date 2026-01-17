# Theme System Guide - Colors & Text Styles

## 📚 Overview

The app now uses a **centralized theme system** defined in `lib/src/theme/app_theme.dart`. This makes the UI consistent, maintainable, and easy to modify globally.

---

## 🎨 How Colors Work

### Definition Location
**File:** `lib/src/theme/app_theme.dart`

All colors are defined as static constants in the `AppColors` class:

```dart
class AppColors {
  // Primary colors
  static const primary = Color(0xFF6366F1);        // Main brand color
  static const primaryDark = Color(0xFF4F46E5);    // Darker variant
  
  // Background colors
  static const bgDeep = Color(0xFF0A0A0A);         // Main background
  static const bgSurface = Color(0xFF111111);      // Cards, elevated surfaces
  static const bgCard = Color(0xFF1A1A1A);         // Card backgrounds
  
  // Text colors
  static const textPrimary = Color(0xFFFFFFFF);    // Main text (white)
  static const textSecondary = Color(0xFFB3B3B3);  // Secondary text (gray)
  static const textTertiary = Color(0xFF808080);   // Tertiary text (darker gray)
  static const textMuted = Color(0xFF666666);      // Muted text
  
  // And 30+ more semantic colors...
}
```

### How to Use Colors

#### ✅ CORRECT - Use theme colors:
```dart
Container(
  color: AppColors.bgSurface,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

#### ❌ WRONG - Don't hardcode colors:
```dart
Container(
  color: Color(0xFF111111),  // ❌ Don't do this!
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.white),  // ❌ Don't do this!
  ),
)
```

### Color Categories

**1. Primary & Accent Colors**
- `AppColors.primary` - Main brand color (indigo)
- `AppColors.accentRose` - Rose accent
- `AppColors.accentGreen` - Green accent
- `AppColors.accentBlue` - Blue accent

**2. Background Colors**
- `AppColors.bgDeep` - Deepest background (almost black)
- `AppColors.bgSurface` - Surface background (cards)
- `AppColors.bgCard` - Card backgrounds

**3. Surface States** (for interactive elements)
- `AppColors.surfaceOverlay` - Subtle overlay
- `AppColors.surfaceHover` - Hover state
- `AppColors.surfacePressed` - Pressed state
- `AppColors.surfaceSelected` - Selected state

**4. Text Colors**
- `AppColors.textPrimary` - Main text (white)
- `AppColors.textSecondary` - Secondary text (light gray)
- `AppColors.textTertiary` - Tertiary text (gray)
- `AppColors.textMuted` - Muted text (dark gray)

**5. Status Colors**
- `AppColors.success` / `AppColors.successBg` / `AppColors.successIcon`
- `AppColors.error` / `AppColors.errorBg` / `AppColors.errorIcon`
- `AppColors.warning` / `AppColors.warningBg` / `AppColors.warningIcon`

**6. UI Elements**
- `AppColors.borderSubtle` - Subtle borders
- `AppColors.borderGlass` - Glass-like borders
- `AppColors.divider` - Dividers
- `AppColors.shimmer` - Loading shimmer effect

---

## ✍️ How Text Styles Work

### Definition Location
**File:** `lib/src/theme/app_theme.dart`

All text styles are defined as static constants in the `AppTextStyles` class:

```dart
class AppTextStyles {
  // Headings
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  
  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  
  // Body text
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  // And 20+ more text styles...
}
```

### How to Use Text Styles

#### ✅ CORRECT - Use theme text styles:
```dart
// Use directly
Text(
  'Hello World',
  style: AppTextStyles.h2,
)

// Override color if needed
Text(
  'Hello World',
  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
)

// Override multiple properties
Text(
  'Hello World',
  style: AppTextStyles.body.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w700,
  ),
)
```

#### ❌ WRONG - Don't create custom TextStyles:
```dart
Text(
  'Hello World',
  style: TextStyle(  // ❌ Don't do this!
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
)
```

### Text Style Categories

**1. Headings** (for titles and headers)
- `AppTextStyles.h1` - 32px, w800 (extra bold)
- `AppTextStyles.h2` - 24px, w700 (bold)
- `AppTextStyles.h3` - 20px, w600 (semi-bold)
- `AppTextStyles.h4` - 18px, w600 (semi-bold)
- `AppTextStyles.h5` - 16px, w600 (semi-bold)

**2. Body Text** (for paragraphs and content)
- `AppTextStyles.bodyLarge` - 16px, w500 (medium)
- `AppTextStyles.body` - 15px, w500 (medium)
- `AppTextStyles.bodyMedium` - 14px, w500 (medium)
- `AppTextStyles.bodyRegular` - 14px, w400 (regular)

**3. Labels** (for buttons, tags, small text)
- `AppTextStyles.labelLarge` - 14px, w600 (semi-bold)
- `AppTextStyles.labelMedium` - 13px, w500 (medium)
- `AppTextStyles.labelSmall` - 12px, w500 (medium)

**4. Special Styles**
- `AppTextStyles.price` - 20px, w700 (for prices)
- `AppTextStyles.priceSmall` - 16px, w700 (for smaller prices)
- `AppTextStyles.sectionTitle` - 12px, w700, uppercase (for section headers)
- `AppTextStyles.caption` - 12px, w400 (for captions)
- `AppTextStyles.link` - 14px, w600, underlined (for links)

---

## 🔧 How to Modify the Theme

### Changing a Color Globally

**Example:** Change the primary brand color from indigo to purple

1. Open `lib/src/theme/app_theme.dart`
2. Find the color definition:
   ```dart
   static const primary = Color(0xFF6366F1);  // Current: Indigo
   ```
3. Change it:
   ```dart
   static const primary = Color(0xFF9333EA);  // New: Purple
   ```
4. **That's it!** All buttons, links, and primary elements will now be purple throughout the entire app.

### Changing a Text Style Globally

**Example:** Make all h2 headings slightly larger

1. Open `lib/src/theme/app_theme.dart`
2. Find the text style:
   ```dart
   static const h2 = TextStyle(
     fontSize: 24,  // Current size
     fontWeight: FontWeight.w700,
     color: AppColors.textPrimary,
   );
   ```
3. Change it:
   ```dart
   static const h2 = TextStyle(
     fontSize: 28,  // New size
     fontWeight: FontWeight.w700,
     color: AppColors.textPrimary,
   );
   ```
4. **That's it!** All h2 headings will now be 28px throughout the app.

---

## 📖 Common Patterns

### Pattern 1: Card with Title and Description
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.bgSurface,  // Card background
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.borderSubtle),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Card Title',
        style: AppTextStyles.h4,  // Heading style
      ),
      SizedBox(height: 8),
      Text(
        'Card description goes here',
        style: AppTextStyles.body,  // Body text style
      ),
    ],
  ),
)
```

### Pattern 2: Button with Custom Color
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,  // Use theme color
    foregroundColor: Colors.white,
  ),
  child: Text(
    'Click Me',
    style: AppTextStyles.labelLarge,  // Use theme text style
  ),
)
```

### Pattern 3: Text with Color Override
```dart
Text(
  'Success!',
  style: AppTextStyles.h3.copyWith(
    color: AppColors.successIcon,  // Override just the color
  ),
)
```

### Pattern 4: Interactive Element States
```dart
GestureDetector(
  onTap: () {},
  child: Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isSelected 
        ? AppColors.surfaceSelected  // Selected state
        : AppColors.surfaceOverlay,  // Default state
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      'Option',
      style: AppTextStyles.labelLarge.copyWith(
        color: isSelected 
          ? AppColors.primary 
          : AppColors.textSecondary,
      ),
    ),
  ),
)
```

---

## 🎯 Benefits of This System

### 1. **Consistency**
- All screens use the same colors and text styles
- No more "this button looks different from that button"

### 2. **Maintainability**
- Change one value, update the entire app
- No need to search through 100 files to change a color

### 3. **Clarity**
- `AppColors.textSecondary` is clearer than `Color(0xFFB3B3B3)`
- `AppTextStyles.h2` is clearer than `TextStyle(fontSize: 24, fontWeight: FontWeight.w700)`

### 4. **Scalability**
- Easy to add new colors or text styles
- Easy to create dark/light theme variants

### 5. **Team Collaboration**
- Designers and developers speak the same language
- "Use h2 for the title" instead of "Use 24px bold text"

---

## 🚀 Quick Reference

### Most Common Colors
```dart
AppColors.bgDeep          // Main background
AppColors.bgSurface       // Card backgrounds
AppColors.primary         // Brand color
AppColors.textPrimary     // Main text (white)
AppColors.textSecondary   // Secondary text (gray)
AppColors.borderSubtle    // Borders
```

### Most Common Text Styles
```dart
AppTextStyles.h2          // Page titles
AppTextStyles.h4          // Section titles
AppTextStyles.body        // Paragraph text
AppTextStyles.labelLarge  // Button text
AppTextStyles.caption     // Small helper text
```

---

## 📝 Migration Status

✅ **Colors:** 100% migrated (238 replacements)
✅ **Text Styles:** ~95% migrated (92 replacements)
✅ **All screens** now use the theme system

---

## 💡 Pro Tips

1. **Always use `.copyWith()` for overrides**
   ```dart
   // ✅ Good
   AppTextStyles.body.copyWith(color: AppColors.error)
   
   // ❌ Bad
   TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.error)
   ```

2. **Use semantic color names**
   ```dart
   // ✅ Good
   AppColors.successBg  // Clear purpose
   
   // ❌ Bad
   Color(0xFF10B981)  // What is this for?
   ```

3. **Don't use `const` with `.copyWith()`**
   ```dart
   // ✅ Good
   Text('Hello', style: AppTextStyles.h2.copyWith(color: Colors.white))
   
   // ❌ Bad - Won't compile!
   const Text('Hello', style: AppTextStyles.h2.copyWith(color: Colors.white))
   ```

4. **Check the theme file for available options**
   - Before creating a custom color, check if one already exists
   - Before creating a custom text style, check if one already exists

---

## 🔍 Where to Find Everything

- **Theme Definition:** `lib/src/theme/app_theme.dart`
- **Usage Examples:** Any screen in `lib/src/features/`
- **Migration Scripts:** `scripts/migrate_to_theme.dart` and `scripts/migrate_text_styles.dart`
- **Documentation:** This file!

---

**Last Updated:** 2026-01-17
**Version:** 1.0
