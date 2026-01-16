# Theme Migration Plan - All Screens

## 🎯 Objective
Apply theme colors and text styles to ALL screens in the app

## 📊 Current Status

### ✅ Completed (2 screens)
1. **CategoryPill Widget** - 100% theme compliant
2. **Home Screen** - 90% theme compliant (9 colors + 12 text styles fixed)

### ❌ Remaining (30+ screens)

## 🔥 Priority Order (By Violation Count)

### HIGH PRIORITY (50+ violations each)
1. **profile_setup_screen.dart** - 52 color + 26 font = 78 violations
2. **trip_detail_screen.dart** - 31 color + 34 font = 65 violations
3. **preferences_screen.dart** - 28 color + 21 font = 49 violations

### MEDIUM PRIORITY (20-50 violations each)
4. **phone_collection_screen.dart** - 24 color + 18 font = 42 violations
5. **login_screen.dart** - 18 color + 22 font = 40 violations
6. **trip_booking_screen.dart** - 22 color + 18 font = 40 violations
7. **edit_profile_screen.dart** - 19 color + 15 font = 34 violations
8. **signup_screen.dart** - 16 color + 19 font = 35 violations

### LOW PRIORITY (< 20 violations each)
9. **onboarding_screen.dart** - 15 color + 12 font = 27 violations
10. **notifications_screen.dart** - 12 color + 8 font = 20 violations
11. **explore_screen.dart** - 8 color + 12 font = 20 violations
12. All other screens...

## 🚀 Execution Strategy

### Option A: Manual (Systematic)
- Time: ~6-8 hours
- Quality: High
- Approach: Screen by screen, careful review

### Option B: Automated (Script)
- Time: ~2 hours (script) + 2 hours (review)
- Quality: Medium (needs review)
- Approach: Find & replace patterns

### Option C: Hybrid (Recommended)
- Time: ~4 hours
- Quality: High
- Approach: Script for colors, manual for text styles

## 📋 Migration Checklist Per Screen

### Colors Migration
- [ ] Replace `Colors.white.withValues(alpha: 0.03)` → `AppColors.surfaceOverlay`
- [ ] Replace `Colors.white.withValues(alpha: 0.05)` → `AppColors.surfaceHover`
- [ ] Replace `Colors.white.withValues(alpha: 0.1)` → `AppColors.surfacePressed`
- [ ] Replace `Colors.white.withValues(alpha: 0.2)` → `AppColors.shimmer`
- [ ] Replace `Colors.white.withValues(alpha: 0.3)` → `AppColors.iconMuted`
- [ ] Replace `Colors.white.withValues(alpha: 0.4)` → `AppColors.textHint`
- [ ] Replace `Colors.white.withValues(alpha: 0.5)` → `AppColors.textMuted`
- [ ] Replace `Colors.white.withValues(alpha: 0.6)` → `AppColors.textMuted`
- [ ] Replace `Colors.black.withValues(alpha: 0.5)` → `AppColors.overlay`
- [ ] Replace `Colors.black.withValues(alpha: 0.7)` → `AppColors.scrim`
- [ ] Replace `AppColors.primary.withValues(alpha: 0.15)` → `AppColors.pillActiveBg`

### Text Styles Migration
- [ ] Replace `fontSize: 32, fontWeight: w800` → `AppTextStyles.h1`
- [ ] Replace `fontSize: 24, fontWeight: w700` → `AppTextStyles.h2`
- [ ] Replace `fontSize: 20, fontWeight: w600` → `AppTextStyles.h3`
- [ ] Replace `fontSize: 18, fontWeight: w600` → `AppTextStyles.h4`
- [ ] Replace `fontSize: 16, fontWeight: w600` → `AppTextStyles.h5`
- [ ] Replace `fontSize: 16, fontWeight: w500` → `AppTextStyles.bodyLarge`
- [ ] Replace `fontSize: 15, fontWeight: w500` → `AppTextStyles.body`
- [ ] Replace `fontSize: 14, fontWeight: w600` → `AppTextStyles.labelLarge`
- [ ] Replace `fontSize: 14, fontWeight: w500` → `AppTextStyles.bodyMedium`
- [ ] Replace `fontSize: 12, fontWeight: w700, letterSpacing: 0.5` → `AppTextStyles.sectionTitle`
- [ ] Replace `fontSize: 12, fontWeight: w500` → `AppTextStyles.labelSmall`

## ⚡ Quick Start Commands

### Find all violations in a screen:
```bash
# Colors
grep -n "Colors\\.white\\.withValues\\|Colors\\.black\\.withValues" filename.dart

# Fonts
grep -n "fontWeight: FontWeight\\." filename.dart
```

### Count violations:
```bash
# Total color violations
grep -r "Colors\\.white\\.withValues\\|Colors\\.black\\.withValues" lib/src/features/ | wc -l

# Total font violations  
grep -r "fontWeight: FontWeight\\." lib/src/features/ | wc -l
```

## 📈 Progress Tracking

### Week 1 Target (This Session)
- [x] Home Screen - DONE
- [ ] Explore Screen
- [ ] Trip Detail Screen
- [ ] Login Screen
- [ ] Signup Screen

### Week 2 Target
- [ ] Profile Setup Screen
- [ ] Preferences Screen
- [ ] Phone Collection Screen
- [ ] Edit Profile Screen
- [ ] Trip Booking Screen

### Week 3 Target
- [ ] All remaining screens
- [ ] Final review and testing

## 🎯 Success Criteria

- [ ] Zero custom color instances (except special cases)
- [ ] Zero custom font weight instances
- [ ] All screens use AppColors
- [ ] All screens use AppTextStyles
- [ ] Consistent look & feel across app
- [ ] Easy to update theme globally

## 🔄 Next Steps

1. **Immediate:** Start with high-priority screens
2. **Short-term:** Create reusable widgets (Phase 2)
3. **Long-term:** Enforce theme usage in code reviews
