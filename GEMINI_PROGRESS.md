# SoleGoes Progress & Quality Tracker

**Objective**: Port SoleGoes web designs to a production-grade Flutter application using Feature-First Riverpod architecture.

## 🟢 Project Health
- **Architecture**: Feature-First Riverpod
- **Backend**: Firebase (Auth, Firestore, Realtime DB)
- **Quality Standards**:
    - [x] **Linting**: No warnings in `flutter analyze`.
    - [ ] **Responsiveness**: UI adapts to Mobile and Web.
    - [x] **State Management**: Logic separated from UI (Controllers/Repositories).
    - [x] **Performance**: No `setState` rebuilding entire screens; using `const` widgets where possible.

---

## 🚀 Feature Progress

### 1. Onboarding
**Status**: 🟡 In Progress
- [x] **Splash Screen** (NEW)
    - [x] Logo display with auto-navigation
    - [x] Native splash configuration (Android/iOS)
    - [x] Smart routing based on auth status
- [ ] **Onboarding Flow** (`option15_onboarding.html`)
    - [ ] Intro Slides / Animation

### 2. Authentication
**Status**: 🟢 Mostly Complete
- [x] **Login Screen** (`option15_login.html`)
    - [x] UI Implementation (Text Fields, Buttons, Styling)
    - [x] Email/Password Logic (Connected to Firebase)
    - [ ] Google Sign-In Logic
    - [x] Error Handling & Loading States
- [ ] **OTP Screen** (`option15_otp.html`)
- [x] **Sign Up Screen**
    - [x] UI Implementation
    - [x] Firestore User Creation (trigger)
- [ ] **Forgot Password** (`option15_forgot_password.html`)
- [x] **Profile Setup** (UPDATED)
    - [x] Skip functionality added
    - [x] Removed redundant name field

### 3. Homepage (Mobile Root)
**Status**: ✅ Complete
- [x] **Routing Setup** (GoRouter + Auth Redirection)
- [x] **Home / Mobile View** (`option15_mobile.html`)
    - [x] Bottom Navigation Setup (Shell Route)
    - [x] Featured / Recommended Sections
    - [x] App logo in header (NEW)

### 4. User Profile (Customer)
**Status**: 🔴 Not Started
- [ ] **Profile Setup** (`option15_profile_setup.html`)
- [ ] **View Profile** (`option15_profile_page.html`)
- [ ] **Edit Profile** (`option15_edit_profile.html`)
- [ ] **Preferences** (`option15_preferences.html`)
- [ ] **Settings** (`option15_settings.html`)

### 5. Trips (Discovery & Details)
**Status**: 🟡 In Progress
- [ ] **Explore / Search** (`option15_explore.html`)
    - [ ] Vector Search Integration (Later)
- [x] **Trip Details** (`option15_trip_detail.html`) (NEW)
    - [x] Dynamic Data from Firestore
    - [x] "Book Now" Flow
    - [x] **Boarding/Dropping Point Selection** (NEW)
    - [x] Image gallery and itinerary display
- [ ] **My Trips** (`option15_my_trips.html`)
    - [ ] List of booked/past trips
- [x] **Trip Model** (NEW)
    - [x] Comprehensive Trip model with all fields
    - [x] **TripPoint model for boarding/dropping locations** (NEW)
    - [x] Firestore serialization

### 6. Bookings & Payments
**Status**: 🟡 In Progress
- [x] **Booking Model** (NEW)
    - [x] Booking model with freezed
    - [x] **SelectedTripPoint for boarding/dropping points** (NEW)
    - [x] Booking repository
- [x] **Payment Confirmation** (`option15_payment_confirmation.html`) (NEW)
    - [x] Confirmation screen with trip details
    - [x] **Boarding/dropping point display** (NEW)
    - [x] PDF receipt generation
    - [x] Email/WhatsApp sharing
- [ ] **Payment Method** (`option15_payment_method.html`)
    - [ ] Payment gateway integration

### 7. Chat & Social
**Status**: 🔴 Not Started
- [ ] **Chat List** (`option15_chat_list.html`)
- [ ] **Chat Detail** (`option15_chat_detail.html`)
    - [ ] Realtime DB Integration
- [ ] **Notifications** (`option15_notifications.html`)

---

## 🛠 Backend/Firebase Checklist
- [x] Firebase Project Created (`solegoes-8110c`)
- [x] Auth Enabled (Email/Pass, Google)
- [x] Firestore Enabled
- [x] Realtime DB Enabled
- [ ] **Action Item**: Configure SHA-1 for Google Sign-In (Android).
- [ ] **Action Item**: Enable `google_sign_in` in iOS `Info.plist`.
