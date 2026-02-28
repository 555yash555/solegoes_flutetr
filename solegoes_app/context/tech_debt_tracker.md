# Tech Debt Tracker — Screen-Wise

**Total:** 326 violations across 27 files
**Last Updated:** 2026-02-02
**Reference:** `context/tech_debt.md` (full analysis)

---

## Prerequisites (do these first)

Before touching screens, upgrade shared widgets and tokens:

- [x] Add `accentCyan`, `textOnAccent` to `AppColors` in `app_theme.dart`
- [x] Add `maxLines`, `label`, `textPrefix`, `onSubmitted` params to `AppTextField`
- [x] Add `destructive` + `ghost` variants + `textColor` + `trailingIcon` to `AppButton`
- [x] Create `AppConfirmDialog` in `common_widgets/`
- [x] Create `PdfTextStyles` class in `lib/src/theme/`

---

## Screen Tracker

### Screen 1: trip_detail_screen.dart — 82 violations ✅ COMPLETE

**File:** `lib/src/features/trips/presentation/trip_detail_screen.dart`

- [x] Colors (14/14) — all hex codes replaced with AppColors tokens ✅
- [x] TextStyles (33/33) — all inline styles replaced with AppTextStyles ✅
- [x] Widgets (5/5) — AppSnackbar, AppConfirmDialog, AppButton ✅
- [x] Error handling (6/6) — removed debugPrint, AppSnackbar, AppConfirmDialog ✅
- [x] Added missing colors: accentPurple, accentAmber to AppColors ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 2: payment_confirmation_screen.dart — 56 violations ✅ COMPLETE

**File:** `lib/src/features/payments/presentation/payment_confirmation_screen.dart`

- [x] Colors (12/12) — fixed Colors.white/white70, hex codes for status colors ✅
- [x] TextStyles (28/28 Flutter) — fixed all Flutter inline styles ✅
- [x] TextStyles (18/18 PDF) — replaced all pw.TextStyle with PdfTextStyles ✅
- [x] Widgets (2/2) — AppSnackbar for success ✅
- [x] Error handling (1/1) — ScaffoldMessenger to AppSnackbar ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 3: trip_booking_screen.dart — 35 violations ✅ COMPLETE

**File:** `lib/src/features/bookings/presentation/trip_booking_screen.dart`

- [x] Colors (0/0) — already clean ✅
- [x] TextStyles (20/20) — all inline styles replaced with AppTextStyles ✅
- [x] Widgets (5/5) — AppShimmer, AppButton (replaced ElevatedButton, OutlinedButton, TextButton) ✅
- [x] Error handling (3/3) — removed all debugPrint statements ✅
- [x] Other (7/7) — fixed unused imports, dead null-aware expressions ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 4: chat_detail_screen.dart — 25 violations ✅ COMPLETE

**File:** `lib/src/features/chat/presentation/chat_detail_screen.dart`

- [x] Colors (3/3) — gradient + status color replaced with AppColors tokens ✅
- [x] TextStyles (14/14) — all inline styles replaced with AppTextStyles ✅
- [x] Widgets (2/2) — ScaffoldMessenger replaced with AppSnackbar ✅
- [x] Error handling (5/5) — improved error messages, removed raw error display ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 5: chat_list_screen.dart — 19 violations ✅ COMPLETE

**File:** `lib/src/features/chat/presentation/chat_list_screen.dart`

- [x] Colors (2/2) — gradient + status color replaced with AppColors tokens ✅
- [x] TextStyles (15/15) — all inline styles replaced with AppTextStyles ✅
- [x] Widgets (2/2) — shimmer skeleton implemented, removed unused Image.network ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 6: payment_method_screen.dart — 13 violations ✅ COMPLETE

**File:** `lib/src/features/payments/presentation/payment_method_screen.dart`

- [x] Colors (4/4) — Colors.amber replaced with AppColors.accentYellow ✅
- [x] TextStyles (7/7) — all inline styles replaced with AppTextStyles ✅
- [x] Widgets (2/2) — loading indicator properly styled ✅
- [x] Error handling (2/2) — removed debugPrint statements ✅
- [x] **Verified compiles** ✅
- [x] **STATUS: 100% COMPLETE** 🎉

---

### Screen 7: profile_setup_screen.dart — 11 violations

**File:** `lib/src/features/authentication/presentation/profile_setup_screen.dart`

- [ ] TextStyles (6) — inline styles + delete _buildTextField helper
- [ ] Widgets (5) — AppTextField for fields, BottomActionButton for CTA
- [ ] **Verified compiles**

---

### Screen 8: edit_profile_screen.dart — 11 violations

**File:** `lib/src/features/profile/presentation/edit_profile_screen.dart`

- [ ] TextStyles (7) — inline styles to AppTextStyles
- [ ] Widgets (3) — AppTextField (with label/textPrefix), AppImage.avatar
- [ ] Error handling (1) — use auth controller's updateProfile
- [ ] **Verified compiles**

---

### Screen 9: profile_screen.dart — 11 violations

**File:** `lib/src/features/profile/presentation/profile_screen.dart`

- [ ] TextStyles (8) — inline styles to AppTextStyles
- [ ] Widgets (3) — shimmer skeleton, AppConfirmDialog for logout
- [ ] **Verified compiles**

---

### Screen 10: settings_screen.dart — 10 violations

**File:** `lib/src/features/profile/presentation/settings_screen.dart`

- [ ] Colors (1) — Colors.white to AppColors.textPrimary
- [ ] TextStyles (8) — inline styles to AppTextStyles
- [ ] Widgets (2) — AppConfirmDialog for logout
- [ ] **Verified compiles**

---

### Screen 11: signup_screen.dart — 9 violations

**File:** `lib/src/features/authentication/presentation/signup_screen.dart`

- [ ] TextStyles (5) — hint styles + heading
- [ ] Widgets (4) — delete _buildTextField, use AppTextField, AppImage
- [ ] **Verified compiles**

---

### Screen 12: notifications_screen.dart — 8 violations

**File:** `lib/src/features/profile/presentation/notifications_screen.dart`

- [ ] Colors (1) — status color
- [ ] TextStyles (7) — inline styles to AppTextStyles
- [ ] **Verified compiles**

---

### Screen 13: home_screen.dart — 8 violations

**File:** `lib/src/features/home/presentation/home_screen.dart`

- [ ] TextStyles (2) — emoji sizing + body style
- [ ] Widgets (1) — ScaffoldMessenger to AppSnackbar
- [ ] Error handling (5) — remove print statements, AppSnackbar
- [ ] **Verified compiles**

---

### Screen 14: seed_trips_screen.dart — 7 violations

**File:** `lib/src/features/admin/presentation/seed_trips_screen.dart`

- [ ] Colors (7) — hex codes to AppColors tokens
- [ ] **Verified compiles**

---

### Screen 15: phone_collection_screen.dart — 7 violations

**File:** `lib/src/features/authentication/presentation/phone_collection_screen.dart`

- [ ] TextStyles (6) — inline styles to AppTextStyles
- [ ] Widgets (1) — keep phone field as specialized
- [ ] **Verified compiles**

---

### Screen 16: onboarding_screen.dart — 6 violations

**File:** `lib/src/features/onboarding/presentation/onboarding_screen.dart`

- [ ] TextStyles (5) — inline styles to AppTextStyles
- [ ] Widgets (1) — Image.network to AppImage
- [ ] **Verified compiles**

---

### Screen 17: booking_card.dart — 6 violations

**File:** `lib/src/features/bookings/presentation/booking_card.dart`

- [ ] Colors (5) — hex status colors + Colors.grey/black
- [ ] TextStyles (1) — badgeText
- [ ] **Verified compiles**

---

### Screen 18: design_demo_screen.dart — 6 violations

**File:** `lib/src/features/demo/presentation/design_demo_screen.dart`

- [ ] Widgets (4) — _buildInputWithIcon to AppTextField, buttons
- [ ] TextStyles (2) — inline styles
- [ ] **Verified compiles**

---

### Screen 19: explore_screen.dart — 4 violations

**File:** `lib/src/features/explore/presentation/explore_screen.dart`

- [ ] Colors (1) — Colors.white54
- [ ] TextStyles (1) — inline style
- [ ] Widgets (1) — shimmer skeleton
- [ ] Error handling (2) — silent catch, raw $err
- [ ] **Verified compiles**

---

### Screen 20: preferences_screen.dart — 4 violations

**File:** `lib/src/features/authentication/presentation/preferences_screen.dart`

- [ ] TextStyles (3) — inline styles
- [ ] Widgets (1) — adopt BottomActionButton
- [ ] **Verified compiles**

---

### Screen 21: splash_screen.dart — 3 violations

**File:** `lib/src/features/splash/presentation/splash_screen.dart`

- [ ] TextStyles (2) — inline styles
- [ ] Error handling (1) — silent error swallow
- [ ] **Verified compiles**

---

### Screen 22: seed_lite_screen.dart — 3 violations

**File:** `lib/src/features/admin/presentation/seed_lite_screen.dart`

- [ ] Colors (3) — Colors.black, Colors.greenAccent
- [ ] **Verified compiles**

---

### Screen 23: category_trips_screen.dart — 2 violations

**File:** `lib/src/features/explore/presentation/category_trips_screen.dart`

- [ ] Colors (1) — Colors.white
- [ ] Error handling (1) — raw $err
- [ ] **Verified compiles**

---

### Screen 24: search_results_screen.dart — 2 violations

**File:** `lib/src/features/search/presentation/search_results_screen.dart`

- [ ] Colors (1) — Colors.white
- [ ] Error handling (1) — raw $err
- [ ] **Verified compiles**

---

### Screen 25: my_trips_screen.dart — 2 violations

**File:** `lib/src/features/trips/presentation/my_trips_screen.dart`

- [ ] Colors (1) — one color fix
- [ ] Widgets (1) — shimmer skeleton or widget fix
- [ ] **Verified compiles**

---

### Screen 26: search_filter_screen.dart — 1 violation

**File:** `lib/src/features/search/presentation/search_filter_screen.dart`

- [ ] Colors (1) — Colors.white54
- [ ] **Verified compiles**

---

### Screen 27: bottom_nav_island.dart — 1 violation

**File:** `lib/src/features/home/presentation/widgets/bottom_nav_island.dart`

- [ ] Colors (1) — minor color fix
- [ ] **Verified compiles**

---

### Screen 28: globe_spin_animation_screen.dart — 1 violation

**File:** `lib/src/features/home/presentation/globe_spin_animation_screen.dart`

- [ ] TextStyles (1) — emoji sizing (borderline)
- [ ] **Verified compiles**

---

## Cross-Cutting Tasks (after all screens)

- [ ] Adopt `CircularIconButton` across 15 files (25+ hand-rolled copies)
- [ ] Verify no remaining `Image.network` in any screen
- [ ] Verify no remaining raw `ScaffoldMessenger` in any screen
- [ ] Verify no remaining `debugPrint`/`print` in any screen
- [ ] Run `flutter analyze` — 0 warnings
- [ ] Run app — spot-check 5 screens visually

---

## Progress

**Screens completed:** 6 / 28
**Prerequisites done:** 5 / 5
**Cross-cutting done:** 0 / 6
