# SoleGoes Flutter App

Solo travel social platform — trip discovery, booking, group chat, payments.


**before starting any task, always check the rule.md file**

## Tech Stack

| Layer | Tech |
|-------|------|
| Framework | Flutter (Dart) |
| State | Riverpod 2.0 (`@riverpod` codegen) |
| Backend | Firebase Auth, Firestore, Realtime DB |
| Routing | GoRouter + StatefulShellRoute |
| Models | Freezed (immutable, JSON) |
| Payments | Razorpay |
| Icons | `lucide_icons` |
| Font | Plus Jakarta Sans |
| Theme | Dark only — `lib/src/theme/app_theme.dart` |

## Commands

```bash
# Run app
flutter run

# Codegen (after changing @riverpod or @freezed files)
dart run build_runner build --delete-conflicting-outputs

# Seed test data (in-app)
# Navigate to /seed-lite route
```

## Project Structure

```
lib/src/
├── theme/app_theme.dart           # AppColors, AppTextStyles, AppSpacing, AppRadius
├── common_widgets/                # Reusable: AppButton, AppTextField, AppCard, AppSnackbar, AppShimmer, AppImage
├── utils/
│   ├── async_value_ui.dart        # AsyncValue → Snackbar extension
│   └── app_exception.dart         # Firebase error wrapper
├── routing/app_router.dart        # Routes, auth guards, redirects
└── features/
    ├── authentication/            # Login, Signup, Profile Setup, Preferences
    ├── onboarding/                # Onboarding carousel
    ├── home/                      # Home screen, bottom nav, trip cards
    ├── trips/                     # Trip listing, detail, explore, search
    ├── bookings/                  # 4-step booking flow, booking management
    ├── chat/                      # Realtime DB chat (trip group chats)
    ├── payments/                  # Razorpay integration, confirmation
    ├── profile/                   # User profile, edit, settings
    ├── search/                    # Trip filters
    └── admin/                     # Seed data screens
```

## HTML Design References

Each Flutter screen maps to an HTML prototype in `../../` (designs/ folder):

| Screen | HTML File |
|--------|-----------|
| Login | `option15_login.html` |
| OTP | `option15_otp.html` |
| Profile Setup | `option15_profile_setup.html` |
| Preferences | `option15_preferences.html` |
| Onboarding | `option15_onboarding.html` |
| Home | `option15_mobile.html` |
| Explore | `option15_explore.html` |
| Trip Detail | `option15_trip_detail.html` |
| My Trips | `option15_my_trips.html` |
| Chat List | `option15_chat_list.html` |
| Chat Detail | `option15_chat_detail.html` |
| Profile | `option15_profile_page.html` |
| Edit Profile | `option15_edit_profile.html` |
| Settings | `option15_settings.html` |
| Notifications | `option15_notifications.html` |
| Payment Method | `option15_payment_method.html` |
| Payment Confirmation | `option15_payment_confirmation.html` |

## Context Docs

| File | Contains |
|------|----------|
| `rule.md` | Enforceable coding rules (theming, reuse, errors) |
| `context/ARCHITECTURE_GUIDE.md` | Layers, Riverpod patterns, feature patterns |
| `context/THEME_SYSTEM_GUIDE.md` | All color, typography, spacing, radius tokens |
| `context/database_schema.md` | Firestore + Realtime DB collections & fields |
| `context/booking_and_pricing.md` | Pricing styles, 4-step booking flow |
| `context/chat_feature_analysis.md` | Chat backend/UI status |
| `context/incomplete_features_analysis.md` | Placeholder/stub audit across all screens |
| `context/FAILSAFE_ANALYSIS.md` | Risk assessment by priority |

## Key Patterns

- **Theming**: All styles from `AppColors.*` / `AppTextStyles.*` — zero hardcoded values
- **Errors**: `AppException.fromError()` → `AppSnackbar.showError()` → `AsyncValueUI.showSnackbarOnError()`
- **Firestore writes**: Always `SetOptions(merge: true)`
- **Navigation**: GoRouter with auth guards checking `isProfileComplete` / `isPreferencesComplete`
- **Chat**: Firebase Realtime Database (not Firestore) — chat access gated by confirmed booking
- **Widgets**: Check `common_widgets/` before creating new ones — reuse > create
