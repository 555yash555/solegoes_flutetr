# Tech Debt Report — Presentation Layer

**Generated:** 2026-02-02
**Scope:** All 38 presentation-layer files in `lib/src/features/*/presentation/`
**Categories:** Hardcoded Colors | Hardcoded TextStyles | Non-Modular Widgets | Error Handling

---

## Overall Compliance Summary

| Category | Violations | Files Affected | Severity |
|----------|-----------|----------------|----------|
| Hardcoded Colors | **73** | 15 / 38 | Medium |
| Hardcoded TextStyles | **183** (+18 PDF) | 23 / 38 | High |
| Non-Modular Widgets | **51** | 17 / 38 | Medium |
| Error Handling | **19** | 11 / 38 | High |
| **Total** | **326** | **27 / 38** | — |

**Clean files (0 violations):** `login_screen.dart`, `scaffold_with_nav_bar.dart`, `bottom_nav_island.dart` (1 minor color only), `category_card.dart`, `trip_card.dart`

### Compliance by Feature Area

| Feature | Screens | Color | Text | Widget | Error | Total |
|---------|---------|-------|------|--------|-------|-------|
| Authentication | 5 | 0 | 25 | 12 | 0 | **37** |
| Trips | 3 | 15 | 36 | 6 | 6 | **63** |
| Bookings | 2 | 5 | 21 | 6 | 3 | **35** |
| Chat | 2 | 5 | 29 | 4 | 5 | **43** |
| Payments | 2 | 16 | 35 | 3 | 2 | **56** |
| Profile | 4 | 2 | 23 | 5 | 1 | **31** |
| Home | 3 | 1 | 3 | 1 | 5 | **10** |
| Explore | 2 | 2 | 1 | 1 | 2 | **6** |
| Search | 2 | 2 | 1 | 0 | 1 | **4** |
| Admin | 2 | 10 | 0 | 0 | 0 | **10** |
| Other | 3 | 1 | 2 | 2 | 0 | **5** |

---

## Screen-Wise Report

### 1. `trips/presentation/trip_detail_screen.dart`

**Worst offender — 82 total violations**

#### Colors (14 violations)
| Line | Code | Fix |
|------|------|-----|
| 282, 314 | `TextStyle(color: Colors.white)` | `AppColors.textPrimary` |
| 312 | `Icon(..., color: Colors.red)` | `AppColors.error` |
| 499, 539 | `Icon(..., color: Colors.white)` | `AppColors.textPrimary` |
| 932 | `Color(0xFFA855F7)` | `AppColors.violet` |
| 934, 1208 | `Color(0xFF06B6D4)` | Add `AppColors.accentCyan` |
| 936, 1205 | `Color(0xFFF59E0B)` | `AppColors.accentYellow` |
| 937, 1206 | `Color(0xFF3B82F6)` | `AppColors.accentBlue` |
| 938, 1210 | `Color(0xFFEF4444)` | `AppColors.error` |
| 1428 | `Colors.grey` | `AppColors.textTertiary` |
| 1492 | `Color(0xFF3B82F6)` | `AppColors.accentBlue` |
| 1549 | `Color(0xFF050505).withValues(alpha: 0.85)` | `AppColors.bgDeep.withValues(alpha: 0.85)` |

#### TextStyles (~33 violations)
- 6x `TextStyle(fontSize: 18, fontWeight: FontWeight.w600/w700)` → `AppTextStyles.h4`
- 8x `TextStyle(fontSize: 12, ...)` → `AppTextStyles.caption` / `AppTextStyles.badgeText`
- 5x `TextStyle(fontSize: 14, ...)` → `AppTextStyles.bodyMedium`
- Lines 422-425: `TextStyle(fontSize: 32, fontWeight: FontWeight.w700)` → `AppTextStyles.heroTitle`
- Lines 839-842: `TextStyle(fontSize: 13, fontWeight: FontWeight.w500)` → `AppTextStyles.labelMedium`
- Lines 971-973: `TextStyle(fontSize: 15, fontWeight: FontWeight.w600)` → `AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)`
- Plus ~10 more scattered `TextStyle(color: AppColors.xxx)` missing base token

#### Widgets (5 violations)
- Line 172, 306: `CircularProgressIndicator` → shimmer skeleton / keep spinner in dialog
- Line 199: `TextButton` in dialog → `AppButton(variant: text)`
- Line 249-254: `ScaffoldMessenger.showSnackBar()` → `AppSnackbar.showError()`
- Line 316-319: `ElevatedButton` for retry → `AppButton(variant: primary)`

#### Error Handling (6 violations)
- Line 66, 74, 127: `debugPrint()` in screen — remove or use logging service
- Line 168-174: `showDialog()` for loading spinner — use Riverpod state
- Line 186-213: Custom `AlertDialog` for info — standardize with `AppConfirmDialog`
- Line 244-255: `ScaffoldMessenger` + raw `$e` — use `AppSnackbar.showError()`

---

### 2. `payments/presentation/payment_confirmation_screen.dart`

**56 total violations**

#### Colors (12 violations)
| Line | Code | Fix |
|------|------|-----|
| 127, 604, 985 | `Colors.white` | `AppColors.textPrimary` |
| 734, 866, 879 | `Colors.white70` | `AppColors.textMuted` |
| 601, 768 | `Color(0xFFEF4444)` | `AppColors.error` |
| 603, 770 | `Color(0xFFEAB308)` | `AppColors.statusPending` |
| 771 | `Color(0xFF4CAF50)` | `AppColors.accentGreen` |
| 845, 919, 955 | `Color(0xFF4ADE80)`, `Color(0xFF22C55E)`, `Color(0xFFEF4444)` | `AppColors.badgeGreen`, `AppColors.statusConfirmed`, `AppColors.error` |

#### TextStyles (~28 Flutter + ~18 PDF)
- ~18 PDF `pw.TextStyle(...)` violations — need a parallel `PdfTextStyles` class
- Multiple `TextStyle(fontSize: 11, fontWeight: FontWeight.w700)` → `AppTextStyles.caption.copyWith(fontSize: 11, fontWeight: FontWeight.w700)`
- 3x `fontFamily: 'monospace'` violations (lines 733, 865, 878)
- Lines 1020-1022, 1188-1190: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`

#### Widgets (2 violations)
- Line 123-135: `ScaffoldMessenger.showSnackBar()` → `AppSnackbar.showSuccess()`
- Line 540: `CircularProgressIndicator` → shimmer skeleton

#### Error Handling (1 violation)
- Line 123-135: `ScaffoldMessenger` for success feedback → `AppSnackbar.showSuccess()`

---

### 3. `bookings/presentation/trip_booking_screen.dart`

**35 total violations**

#### Colors (0 violations) — clean

#### TextStyles (~20 violations)
- Lines 332-334: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- Lines 355-357: `TextStyle(fontSize: 22, fontWeight: FontWeight.w700)` → `AppTextStyles.price.copyWith(fontSize: 22)`
- Lines 245-247, 363-364: `TextStyle(fontSize: 11, ...)` → `AppTextStyles.caption.copyWith(fontSize: 11, ...)`
- Multiple `TextStyle(fontSize: 13/14, ...)` → `AppTextStyles.labelMedium` / `AppTextStyles.bodyMedium`
- Lines 670-672: `TextStyle(fontSize: 14, fontWeight: FontWeight.w700)` → `AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)`

#### Widgets (5 violations)
- Line 137: `CircularProgressIndicator()` → shimmer skeleton (also fix missing `color: AppColors.primary`)
- Lines 727-741: `OutlinedButton` → `AppButton(variant: outline)`
- Lines 746-758: `ElevatedButton` → `AppButton(variant: primary)`
- Line 982: `TextButton` in dialog → `AppButton(variant: ghost)`
- Lines 986-991: `ElevatedButton` in dialog → `AppButton(variant: primary)`

#### Error Handling (3 violations)
- Line 59, 886: `debugPrint()` in screen — remove
- Lines 954-995: Custom `showDialog()` for payment failure — use `AppConfirmDialog`
- Line 138: Raw `$err` in Text widget — use `AppException.fromError()`

---

### 4. `chat/presentation/chat_detail_screen.dart`

**25 total violations**

#### Colors (3 violations)
| Line | Code | Fix |
|------|------|-----|
| 465 | `[Color(0xFF8B5CF6), Color(0xFF6366F1)]` | `AppColors.primaryGradient` |
| 470 | `Color(0xFF8B5CF6).withValues(alpha: 0.2)` | `AppColors.violet.withValues(alpha: 0.2)` |
| 502 | `Color(0xFF22C55E)` | `AppColors.statusConfirmed` |

#### TextStyles (~14 violations)
- Lines 690-693, 753-757, 852-855: `TextStyle(fontSize: 15, ...)` → `AppTextStyles.body`
- Lines 781-785: `TextStyle(fontSize: 10, ...)` → `AppTextStyles.overline.copyWith(...)`
- Lines 614-616: `TextStyle(fontSize: 12, ...)` → `AppTextStyles.badgeText.copyWith(...)`
- Lines 859-862: hint style → `AppTextStyles.body.copyWith(color: AppColors.textHint)`

#### Widgets (2 violations)
- Lines 118-120, 291-296: `ScaffoldMessenger.showSnackBar()` → `AppSnackbar.showError()`

#### Error Handling (5 violations)
- Lines 94-122, 276-298: ScaffoldMessenger + raw catch → use controller + `AppSnackbar`
- Lines 158-186, 225, 316-328: Custom error Text widgets showing raw errors → use `AppException.fromError()`

---

### 5. `chat/presentation/chat_list_screen.dart`

**19 total violations**

#### Colors (2 violations)
- Line 288: `[Color(0xFF8B5CF6), Color(0xFF6366F1)]` → `AppColors.primaryGradient`
- Line 493: `Color(0xFF22C55E)` → `AppColors.statusConfirmed`

#### TextStyles (~15 violations)
- 4x `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- 3x `TextStyle(fontSize: 12)` → `AppTextStyles.caption`
- 2x `TextStyle(fontSize: 14)` → `AppTextStyles.bodyMedium`
- Lines 422-424: `TextStyle(fontSize: 10, fontWeight: FontWeight.w700)` → `AppTextStyles.overline`
- Multiple `TextStyle(color: AppColors.textMuted)` → `AppTextStyles.body.copyWith(color: AppColors.textMuted)`

#### Widgets (2 violations)
- Line 193: `CircularProgressIndicator` → shimmer skeleton
- Lines 476-480: `Image.network()` → `AppImage.avatar()`

#### Error Handling (0 violations) — clean

---

### 6. `payments/presentation/payment_method_screen.dart`

**13 total violations**

#### Colors (4 violations)
- Lines 231, 233: `Colors.amber.withValues(...)` → `AppColors.accentYellow.withValues(...)`
- Lines 241, 248: `Colors.amber.shade300` → `AppColors.accentYellow`

#### TextStyles (7 violations)
- Lines 331-333, 514-516, 525-527: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- Lines 246-249, 347-349: `TextStyle(fontSize: 12, ...)` → `AppTextStyles.labelSmall` / `AppTextStyles.badgeText`

#### Widgets (2 violations)
- Line 288: `CircularProgressIndicator` → shimmer skeleton
- Line 506: `CircularProgressIndicator` inside CTA → adopt `BottomActionButton` (has built-in loading)

#### Error Handling (2 violations)
- Lines 158, 177: `debugPrint()` in screen — remove

---

### 7. `profile/presentation/profile_screen.dart`

**11 total violations**

#### Colors (0) — clean
#### TextStyles (8 violations)
- Lines 134-136: `TextStyle(fontSize: 36, fontWeight: FontWeight.w800)` → `AppTextStyles.h1.copyWith(fontSize: 36)`
- Lines 177-178: `TextStyle(fontSize: 14)` → `AppTextStyles.bodyMedium`
- Lines 310-312: `TextStyle(fontSize: 12, fontWeight: FontWeight.w700)` → `AppTextStyles.badgeText`
- Multiple `TextStyle(color: ...)` without base token

#### Widgets (3 violations)
- Line 44: `CircularProgressIndicator` → shimmer skeleton
- Lines 401, 410: Duplicate logout dialog → `AppConfirmDialog`

#### Error Handling (0) — clean

---

### 8. `profile/presentation/settings_screen.dart`

**10 total violations**

#### Colors (1 violation)
- Line 424: `TextStyle(color: Colors.white)` → `AppColors.textPrimary`

#### TextStyles (8 violations)
- Lines 77-79: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- Lines 196-198: `TextStyle(fontSize: 12, fontWeight: FontWeight.w700)` → `AppTextStyles.badgeText`
- Multiple `TextStyle(color: ...)` without base token

#### Widgets (2 violations)
- Lines 431, 440: Duplicate logout dialog → `AppConfirmDialog`

#### Error Handling (0) — clean

---

### 9. `profile/presentation/edit_profile_screen.dart`

**11 total violations**

#### Colors (0) — clean
#### TextStyles (7 violations)
- Lines 173-175: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- Lines 186-188, 280-282: `TextStyle(fontSize: 14, fontWeight: FontWeight.w700)` → `AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)`
- Lines 304-306: `TextStyle(fontSize: 12, fontWeight: FontWeight.w700)` → `AppTextStyles.badgeText`
- Lines 321-322, 352-353: `TextStyle(fontSize: 16)` → `AppTextStyles.bodyLarge`

#### Widgets (3 violations)
- Lines 291-334: `_buildTextField()` duplicates `AppTextField` — replace with upgraded `AppTextField`
- Line 235: `Image.network()` → `AppImage.avatar()`

#### Error Handling (1 violation)
- Lines 61-77: Raw `try`/`finally` with no error handling — use auth controller's `updateProfile()`

---

### 10. `profile/presentation/notifications_screen.dart`

**8 total violations**

#### Colors (1 violation)
- Line 308: `Color(0xFF22C55E)` → `AppColors.statusConfirmed`

#### TextStyles (7 violations)
- Lines 128-130: `TextStyle(fontSize: 18, fontWeight: FontWeight.w700)` → `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)`
- Lines 154-156: `TextStyle(fontSize: 12, fontWeight: FontWeight.w700)` → `AppTextStyles.badgeText`
- Lines 216-217, 279-280: `TextStyle(fontSize: 12/14)` → `AppTextStyles.caption` / `AppTextStyles.bodyMedium`

#### Widgets (0) — clean
#### Error Handling (0) — clean

---

### 11. `home/presentation/home_screen.dart`

**8 total violations**

#### Colors (0) — clean
#### TextStyles (2 violations)
- Line 310: `TextStyle(fontSize: 48)` — emoji sizing, borderline
- Line 384: `TextStyle(color: AppColors.textSecondary)` → `AppTextStyles.body.copyWith(color: AppColors.textSecondary)`

#### Widgets (1 violation)
- Lines 264-269: `ScaffoldMessenger.showSnackBar()` → `AppSnackbar.showInfo()`

#### Error Handling (5 violations)
- Lines 255-263: 4x `print()` debug statements — remove
- Lines 264-269: `ScaffoldMessenger` → `AppSnackbar.showInfo()`

---

### 12. `authentication/presentation/signup_screen.dart`

**9 total violations**

#### Colors (0) — clean
#### TextStyles (5 violations)
- Lines 320-323, 468-471: hint styles → `AppTextStyles.body.copyWith(color: AppColors.iconMuted)`
- Lines 303-304: `TextStyle(fontSize: 36, fontWeight: FontWeight.w800)` → `AppTextStyles.h1.copyWith(fontSize: 36)`

#### Widgets (4 violations)
- Lines 389-432: `_buildTextField()` duplicates `AppTextField` — delete, use `AppTextField`
- Line 403: `TextField(...)` → `AppTextField`
- Line 478: `TextField(...)` inside phone field — keep as specialized `PhoneTextField`
- Line 300: `Image.network(...)` → `AppImage`

#### Error Handling (0) — clean

---

### 13. `authentication/presentation/profile_setup_screen.dart`

**11 total violations**

#### Colors (0) — clean
#### TextStyles (6 violations)
- Lines 475-509: hint styles in `_buildTextField` → delete helper, use `AppTextField`
- Lines 393-397: `TextStyle(fontSize: 36, fontWeight: FontWeight.w800)` → `AppTextStyles.h1.copyWith(fontSize: 36)`

#### Widgets (5 violations)
- Lines 475-509: `_buildTextField()` → `AppTextField`
- Line 611: `TextField()` for bio → `AppTextField(maxLines: 5)` (after upgrade)
- Lines 323-357: Custom gradient button → `BottomActionButton`
- Line 346: `CircularProgressIndicator` inside button → `BottomActionButton(isLoading: true)`

#### Error Handling (0) — clean

---

### 14. `authentication/presentation/phone_collection_screen.dart`

**7 total violations**

#### Colors (0) — clean
#### TextStyles (6 violations)
- Lines 106-108, 143-146, 189-191: `TextStyle(fontSize: 36/14/16)` → mapped tokens
- Hint style: `TextStyle(color: AppColors.iconMuted)` → `AppTextStyles.body.copyWith(color: AppColors.iconMuted)`

#### Widgets (1 violation)
- Line 241: `TextField(...)` inside phone field — keep as specialized composite

#### Error Handling (0) — clean

---

### 15. `authentication/presentation/preferences_screen.dart`

**4 total violations**

#### Colors (0) — clean
#### TextStyles (3 violations)
- Lines 161-164, 171-174: `TextStyle(fontSize: 22/14)` → `AppTextStyles.h2.copyWith(fontSize: 22)` / `AppTextStyles.bodyMedium`

#### Widgets (1 violation)
- Lines 245-264: Custom gradient button with loading → `BottomActionButton`

#### Error Handling (0) — clean

---

### 16. `admin/presentation/seed_trips_screen.dart`

**7 total violations (all colors)**

#### Colors (7 violations)
| Line | Code | Fix |
|------|------|-----|
| 8051 | `Color(0xFF050505)` | `AppColors.bgDeep` |
| 8054 | `Color(0xFF0A0A0A)` | `AppColors.bgDeep` |
| 8074 | `Colors.white60` | `AppColors.textMuted` |
| 8081 | `Color(0xFF6366F1)` | `AppColors.primary` |
| 8097 | `Colors.white` | `AppColors.textPrimary` |
| 8117 | `Color(0xFF18181B)` | `AppColors.bgSurface` |
| 8137 | `Color(0xFF0A0A0A)` | `AppColors.bgDeep` |

---

### 17. `admin/presentation/seed_lite_screen.dart`

**3 total violations (all colors)**

#### Colors (3 violations)
- Line 148: `Colors.black` → add `AppColors.textOnAccent`
- Line 170: `Colors.black` → `AppColors.bgDeep`
- Line 182: `Colors.greenAccent` → `AppColors.successIcon`

---

### 18. `bookings/presentation/booking_card.dart`

**6 total violations**

#### Colors (5 violations)
- Line 29: `Color(0xFF22C55E)` → `AppColors.statusConfirmed`
- Line 31: `Color(0xFFEAB308)` → `AppColors.statusPending`
- Line 97: `Colors.grey` → `AppColors.textTertiary`
- Line 116: `Colors.black.withOpacity(0.1)` → define in AppColors
- Line 126: `Colors.black` → `AppColors.textOnAccent` or `AppColors.bgDeep`

#### TextStyles (1 violation)
- Lines 123-125: `TextStyle(fontSize: 12, fontWeight: FontWeight.w700)` → `AppTextStyles.badgeText`

---

### 19. `explore/presentation/explore_screen.dart`

**4 total violations**

#### Colors (1 violation)
- Line 287: `Colors.white54` → `AppColors.textMuted`

#### TextStyles (1 violation)
- Line 287: `TextStyle(color: Colors.white54)` → `AppTextStyles.body.copyWith(color: AppColors.textMuted)`

#### Widgets (1 violation)
- Line 197: `CircularProgressIndicator()` → shimmer skeleton (also missing `color`)

#### Error Handling (2 violations)
- Lines 71-73: Silent catch-all → catch specific exception
- Line 328: Raw `$err` in Text → `AppException.fromError()`

---

### 20. `explore/presentation/category_trips_screen.dart`

**2 total violations**

#### Colors (1) — Line 38: `Colors.white` → `AppColors.textPrimary`
#### Error Handling (1) — Lines 112-117: Raw `$err` → `AppException.fromError()`

---

### 21. `search/presentation/search_results_screen.dart`

**2 total violations**

#### Colors (1) — Line 149: `Colors.white` → `AppColors.textPrimary`
#### Error Handling (1) — Lines 148-150: Raw `$err` → user-friendly message

---

### 22. `search/presentation/search_filter_screen.dart`

**1 violation** — Line 152: `Colors.white54` → `AppColors.textMuted`

---

### 23. `splash/presentation/splash_screen.dart`

**3 total violations**

#### TextStyles (2) — Lines 80-83, 90-93: mapped tokens
#### Error Handling (1) — Lines 49-64: Silent error swallow → log with `AppException.fromError()`

---

### 24. `onboarding/presentation/onboarding_screen.dart`

**6 total violations**

#### TextStyles (5) — mapped tokens
#### Widgets (1) — Line 285: `Image.network(...)` → `AppImage`

---

### 25-28. Minor screens (1-2 violations each)

- `globe_spin_animation_screen.dart` — 1 text (emoji sizing, borderline)
- `demo/design_demo_screen.dart` — 6 (widgets + text)
- `my_trips_screen.dart` — 2 (color + widget)
- `bottom_nav_island.dart` — 1 (color)

---

## Common Widget Deep-Dive

### Widget Inventory

| Widget | File | Status | Usages | Note |
|--------|------|--------|--------|------|
| `AppButton` | `app_button.dart` | **Used** | 12 correct | Missing `destructive` + `ghost` variants |
| `AppTextField` | `app_text_field.dart` | **Used** | 8 correct | Missing `maxLines`, `label`, `textPrefix` |
| `AppCard` | `app_card.dart` | Used | several | OK |
| `AppSnackbar` | `app_snackbar.dart` | **Used** | ~20 correct | 5 raw `ScaffoldMessenger` stragglers |
| `AppImage` | `app_image.dart` | **Used** | ~10 correct | 5 raw `Image.network` stragglers |
| `AppShimmer` | `app_shimmer.dart` | Available | — | Should replace 7 full-page `CircularProgressIndicator` |
| `BottomActionButton` | `bottom_action_button.dart` | **DEAD CODE** | 0 | 3 screens manually rebuild it |
| `CircularIconButton` | `circular_icon_button.dart` | **DEAD CODE** | 0 | 25+ hand-rolled copies exist |
| `SocialSignInButton` | `social_sign_in_button.dart` | Used | 4 | Well adopted |

---

### TextField Analysis — Are They Similar or Different?

**19 total TextField instances found.** Verdict: **mostly identical, 3 genuinely different.**

#### Group A: Already using `AppTextField` (8 instances) — no changes
- login_screen (email, password)
- signup_screen (name, email, password, confirm password)
- home_screen (search bar)
- explore_screen (search bar)

#### Group B: Nearly identical to `AppTextField` — direct replacement after upgrade (8 instances)

Three files have private `_buildTextField()` helpers that **duplicate** `AppTextField`:

| File | Helper | Difference from AppTextField |
|------|--------|------------------------------|
| `signup_screen.dart:389` | `_buildTextField()` | Missing `isDense`, no error state. Otherwise identical. |
| `profile_setup_screen.dart:475` | `_buildTextField()` | prefixIcon uses `iconMuted` vs `textTertiary`. Otherwise identical. |
| `profile_setup_screen.dart:611` | `_buildTextArea()` | Same + `maxLines: 5` — **needs `maxLines` param** |
| `edit_profile_screen.dart:291` | `_buildTextField()` | Has label above field, string prefix (`@`), maxLines — **needs `label`, `textPrefix`, `maxLines` params** |
| `phone_collection_screen.dart:241` | inline `TextField` | Adds `letterSpacing: 1`. Otherwise same. |
| `demo_screen.dart:411` | `_buildInputWithIcon()` | Uses `textPlaceholder` for hint. Otherwise same. |

**Action:** Add 4 params to `AppTextField`, delete all private helpers.

#### Group C: Genuinely different — keep as specialized widgets (3 instances)

**Chat message input** (`chat_detail_screen.dart:850`):
- borderRadius 20 (not 16), auto-expanding `maxLines: null`, embedded send + attach buttons, `maxHeight: 100`, `onSubmitted`, compact vertical padding (10 not 16)
- **Verdict:** Too specialized for `AppTextField`. Keep as standalone or create `ChatMessageInput` in chat feature.

**Phone field with country picker** (signup + phone_collection):
- Composite `Row` layout with country code selector + input
- **Verdict:** Keep as-is. Only 2 usages, not worth complicating `AppTextField`.

#### `AppTextField` Upgrade Needed

| New Param | Type | Default | Needed By |
|-----------|------|---------|-----------|
| `maxLines` | `int?` | `1` | edit_profile (3), profile_setup bio (5) |
| `label` | `String?` | `null` | edit_profile (label above each field) |
| `textPrefix` | `String?` | `null` | edit_profile `@username` |
| `onSubmitted` | `ValueChanged<String>?` | `null` | search bars |

---

### Button Analysis — What Variants Are Missing?

**Current `AppButton` variants:** `primary`, `secondary`, `outline`, `text`

#### Missing Variants

| Variant | Background | Text Color | Where Needed |
|---------|-----------|-----------|--------------|
| `destructive` | transparent | `accentRose` | Logout/Delete confirm dialogs (profile, settings — 4 places) |
| `ghost` | transparent | `textSecondary`/`textMuted` | Cancel in dialogs, "Skip" links, "Back to Home" (10+ places) |

#### Missing Params

| Param | Type | Why |
|-------|------|-----|
| `textColor` | `Color?` | Override for special cases (skip buttons use `textPrimary * 0.6`) |
| `trailingIcon` | `IconData?` | Onboarding "Continue →" has trailing arrow |

#### Ad-Hoc Button Patterns Found

| Pattern | Count | Files | Action |
|---------|-------|-------|--------|
| Hand-rolled circular icon buttons | **25+** | 15 files | Adopt `CircularIconButton` |
| GestureDetector gradient CTAs | 6 | onboarding, profile_setup, preferences, payment_method, payment_confirmation, demo | Adopt `AppButton` or `BottomActionButton` |
| TextButton in dialogs | 8 | profile, settings, trip_detail, trip_booking, search_filter, demo | Use `AppButton(variant: ghost/destructive)` |
| ElevatedButton/OutlinedButton | 6 | seed screens, trip_detail, trip_booking | Replace with `AppButton` |

---

### Loading State Analysis — Shimmer vs Spinner

**`AppShimmer` = skeleton placeholder for content loading (replaces layout shapes)**
**`CircularProgressIndicator` = indeterminate spinner for actions/processing**

#### Use `AppShimmer` skeletons (7 instances)

Full-page `.when(loading:)` states that should show content placeholders:

| File | Line | Context |
|------|------|---------|
| `trip_detail_screen.dart` | 306 | Trip loading → shimmer (image + text blocks) |
| `my_trips_screen.dart` | 115 | Bookings loading → shimmer (card list) |
| `chat_list_screen.dart` | 193 | Chat list loading → shimmer (chat rows) |
| `profile_screen.dart` | 44 | Profile loading → shimmer (avatar + info) |
| `payment_method_screen.dart` | 288 | Trip data loading → shimmer |
| `payment_confirmation_screen.dart` | 540 | Booking loading → shimmer |
| `explore_screen.dart` | 197 | Explore loading → shimmer (cards grid) |

Each needs a screen-specific skeleton layout composed from `AppShimmer` blocks.

#### Keep as spinner but fix (3 instances)

| File | Line | Context | Fix |
|------|------|---------|-----|
| `trip_booking_screen.dart` | 137 | Full-page load (no color!) | Add `color: AppColors.primary` or replace with shimmer |
| `splash_screen.dart` | 108 | App startup | Keep spinner — appropriate for splash |
| `trip_detail_screen.dart` | 172 | Dialog overlay during chat join | Keep spinner — appropriate for overlay |

#### Solved by adopting existing widgets (3 instances)

| File | Line | Context | Fix |
|------|------|---------|-----|
| `profile_setup_screen.dart` | 346 | Button loading | Adopt `BottomActionButton(isLoading: true)` |
| `preferences_screen.dart` | 268 | Button loading | Adopt `BottomActionButton(isLoading: true)` |
| `payment_method_screen.dart` | 506 | Button loading | Adopt `BottomActionButton(isLoading: true)` |

**No new loading widget needed.** `AppShimmer` + `AppButton`/`BottomActionButton` cover everything.

---

### Image & Snackbar Stragglers

#### 5 raw `Image.network()` → `AppImage`

| File | Line | Context | Replace With |
|------|------|---------|-------------|
| `onboarding_screen.dart` | 285 | Slide bg | `AppImage(url, fit: cover)` |
| `login_screen.dart` | 248 | Hero bg | `AppImage(url, fit: cover)` |
| `signup_screen.dart` | 300 | Hero bg | `AppImage(url, fit: cover)` |
| `chat_list_screen.dart` | 476 | Chat avatar | `AppImage.avatar(url, name)` |
| `edit_profile_screen.dart` | 235 | Profile photo | `AppImage.avatar(url, name, size: 96)` |

#### 5 raw `ScaffoldMessenger.showSnackBar()` → `AppSnackbar`

| File | Line | Replace With |
|------|------|-------------|
| `home_screen.dart` | 264 | `AppSnackbar.showInfo(context, 'No trips available...')` |
| `payment_confirmation_screen.dart` | 123 | `AppSnackbar.showSuccess(context, 'Receipt copied')` |
| `trip_detail_screen.dart` | 249 | `AppSnackbar.showError(context, 'Failed to join chat')` |
| `chat_detail_screen.dart` | 118 | `AppSnackbar.showError(context, 'Failed to send message')` |
| `chat_detail_screen.dart` | 291 | `AppSnackbar.showError(context, 'Failed to create chat')` |

---

### Dialog Duplication

The logout dialog is **copy-pasted** between `profile_screen.dart:385` and `settings_screen.dart:415`. Trip detail and booking screen also have bespoke dialogs.

**Create `AppConfirmDialog`:**

```dart
AppConfirmDialog.show(
  context: context,
  title: 'Logout',
  message: 'Are you sure you want to log out?',
  confirmText: 'Logout',
  confirmColor: AppColors.accentRose,  // or primary for non-destructive
  onConfirm: () => ...,
);
```

Screens affected: profile, settings, trip_detail, trip_booking — **4 files, 4 dialogs**.

---

## Missing AppColors Tokens

| Token | Hex | Used In |
|-------|-----|---------|
| `accentCyan` | `#06B6D4` | trip_detail itinerary badges |
| `textOnAccent` | `#000000` | Text on bright accent backgrounds |

`accentAmber` (#F59E0B) maps to existing `accentYellow`. `accentPurple` (#A855F7) maps to existing `violet`.

---

## Most Common TextStyle Patterns to Fix

| Pattern | Count | Correct Token |
|---------|-------|---------------|
| `TextStyle(fontSize: 18, fontWeight: w700)` | ~12 | `AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)` |
| `TextStyle(fontSize: 12, ...)` | ~25 | `AppTextStyles.caption` / `badgeText` / `labelSmall` |
| `TextStyle(fontSize: 14, ...)` | ~15 | `AppTextStyles.bodyMedium` / `bodyRegular` |
| `TextStyle(color: AppColors.xxx)` only | ~30 | `AppTextStyles.body.copyWith(color: ...)` |
| `hintStyle: TextStyle(color: ...)` | ~6 | `AppTextStyles.body.copyWith(color: AppColors.textPlaceholder)` |

---

## PDF TextStyles (Separate Category)

`payment_confirmation_screen.dart` has ~18 `pw.TextStyle(...)` violations for PDF receipt generation. These use the `pdf` package, not Flutter, so `AppTextStyles` cannot be used directly.

**Recommendation:** Create a `PdfTextStyles` class in `lib/src/theme/` that mirrors `AppTextStyles` for the `pdf` package.

---

## Action Plan — Priority Order

### Phase 1: Adopt existing dead-code widgets (0 new code to write)

| # | Action | Impact |
|---|--------|--------|
| 1 | Adopt `CircularIconButton` across 15 files | 25+ inline replacements |
| 2 | Adopt `BottomActionButton` in profile_setup, preferences, payment_method | 3 screens, ~100 lines deleted |
| 3 | Replace 5 raw `Image.network` → `AppImage` | 5 files, adds caching + shimmer |
| 4 | Replace 5 raw `ScaffoldMessenger` → `AppSnackbar` | 5 files, consistent styling |

### Phase 2: Small upgrades to existing widgets

| # | Action | Impact |
|---|--------|--------|
| 5 | Add `maxLines`, `label`, `textPrefix`, `onSubmitted` to `AppTextField` | Unblocks 6 screens to delete `_buildTextField` |
| 6 | Add `destructive` + `ghost` variants + `textColor` to `AppButton` | Covers 14 inline buttons across 6 files |
| 7 | Add `accentCyan` + `textOnAccent` to `AppColors` | Unblocks color fixes |

### Phase 3: Create one new widget

| # | Action | Impact |
|---|--------|--------|
| 8 | Create `AppConfirmDialog` | 4 dialogs, kills copy-paste |

### Phase 4: Mechanical replacements

| # | Action | Impact |
|---|--------|--------|
| 9 | Remove all `print()`/`debugPrint()` from screens | 9 deletions across 4 files |
| 10 | Fix 73 hardcoded colors → `AppColors` tokens | 15 files |
| 11 | Fix 183 hardcoded text styles → `AppTextStyles` tokens | 23 files |
| 12 | Replace 7 full-page `CircularProgressIndicator` → `AppShimmer` skeletons | 7 files (screen-specific layouts) |
| 13 | Replace raw buttons (ElevatedButton/OutlinedButton/TextButton) → `AppButton` | 6 files |

### Phase 5: Architectural

| # | Action | Impact |
|---|--------|--------|
| 14 | Move chat send/create logic into a controller | 2 violations |
| 15 | Create `PdfTextStyles` for PDF receipt generation | 18 PDF violations |
| 16 | Fix raw `$err` in error Text widgets → `AppException.fromError()` | 5 files |
