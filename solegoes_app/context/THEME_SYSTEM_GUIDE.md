# Theme System Guide

**File:** `lib/src/theme/app_theme.dart`
**Status:** Migration complete (99.8% compliant, 330+ replacements across 40+ files)

---

## Colors (AppColors)

### Backgrounds
| Token | Hex | Usage |
|-------|-----|-------|
| bgDeep | #09090B | Main background |
| bgSurface | #18181B | Cards, elevated surfaces |
| bgCard | #111111 | Card backgrounds |
| bgGlass | #B318181B | 70% opacity glass |
| bgGlassLight | #08FFFFFF | 3% white |

### Text
| Token | Usage |
|-------|-------|
| textPrimary | #FAFAFA - Main text |
| textSecondary | #A1A1AA - Secondary |
| textTertiary | #52525B - Captions/icons |
| textMuted | 50% white |
| textHint | 40% white |
| textPlaceholder | 30% white |

### Accent
| Token | Hex | Usage |
|-------|-----|-------|
| primary | #6366F1 | Brand indigo |
| violet | #8B5CF6 | Gradient end |
| accentBlue | #3B82F6 | Blue accent |
| accentTeal | #14B8A6 | Teal accent |
| accentRose | #F43F5E | Rose accent |
| accentGreen | #4CAF50 | Green accent |
| accentPink | #EC4899 | Calendar icons |
| accentYellow | #FACC15 | Highlights |

### Status
| Token | Hex |
|-------|-----|
| error | #EF4444 |
| success | #10B981 |
| statusPending | #EAB308 |
| statusConfirmed | #22C55E |

### Surface States
| Token | Usage |
|-------|-------|
| surfaceOverlay | 3% white |
| surfaceHover | 5% white |
| surfacePressed | 10% white |
| surfaceSelected | 15% white |

### Borders
| Token | Usage |
|-------|-------|
| borderSubtle | 6% white |
| borderGlass | 10% white |
| borderFocus | 30% white |
| divider | 10% white |

---

## Typography (AppTextStyles)

**Font:** Plus Jakarta Sans

### Headings
| Style | Size | Weight |
|-------|------|--------|
| h1 | 32px | w800 |
| h2 | 24px | w700 |
| h3 | 20px | w600 |
| h4 | 18px | w600 |
| h5 | 16px | w600 |

### Body
| Style | Size | Weight |
|-------|------|--------|
| bodyLarge | 16px | w500 |
| body | 15px | w500 |
| bodyMedium | 14px | w500 |
| bodyRegular | 14px | w400 |
| bodySmall | 14px | w400 |

### Labels & Special
| Style | Size | Weight | Notes |
|-------|------|--------|-------|
| label | 14px | w600 | |
| labelSmall | 12px | w500 | |
| sectionTitle | 12px | w700 | 0.5 letter-spacing |
| button | 16px | w600 | |
| caption | 12px | w400 | |
| price | 18px | w700 | |
| link | 14px | w500 | Underlined |

---

## Spacing (AppSpacing)

| Token | Value |
|-------|-------|
| xs | 8 |
| sm | 12 |
| md | 16 |
| lg | 24 |
| xl | 32 |
| xxl | 48 |

## Radius (AppRadius)

| Token | Value |
|-------|-------|
| sm | 8 |
| md | 16 |
| lg | 24 |
| full | 9999 |

## Durations (AppDuration)

| Token | Value |
|-------|-------|
| fast | 150ms |
| normal | 200ms |
| slow | 300ms |
| slower | 500ms |

---

## Usage Rules

```dart
// CORRECT
Container(color: AppColors.bgSurface)
Text('Title', style: AppTextStyles.h2)
Text('Custom', style: AppTextStyles.body.copyWith(color: AppColors.primary))

// WRONG
Container(color: Color(0xFF111111))
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700))
```

- Always use `AppColors.*` for colors
- Always use `AppTextStyles.*` for text styles
- Use `.copyWith()` when overriding a property
- Check the theme file before creating any custom style
