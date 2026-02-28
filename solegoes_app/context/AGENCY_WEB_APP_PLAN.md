# Agency & Superadmin Web Dashboard — Implementation Plan

**Last Updated:** 2026-02-02
**Priority:** Agency-first, then Superadmin
**Platform:** Flutter Web + Desktop + Mobile (single codebase)

---

## 1. Current State — What Already Exists

Before building, here's what we can reuse from the consumer app:

### Models (ready to use)

| Model | File | Key Fields for Agency |
|-------|------|-----------------------|
| `Trip` | `trips/domain/trip.dart` | `agencyId`, `agencyName`, `pricingStyles`, `boardingPoints`, `droppingPoints`, `status` |
| `TripStyle` | `trips/domain/trip.dart` | `styleId`, `price`, `accommodationType`, `mealOptions`, `inclusions` |
| `TripPoint` | `trips/domain/trip.dart` | `name`, `address`, `dateTime` |
| `Booking` | `bookings/domain/booking.dart` | `selectedStyleId`, `selectedStyleName`, `selectedBoardingPoint`, `selectedDroppingPoint` |
| `TripChat` | `chat/domain/trip_chat.dart` | `tripId`, `participantIds`, `participantCount` |

### Models (need changes)

| Model | File | What's Missing |
|-------|------|----------------|
| `AppUser` | `authentication/domain/app_user.dart` | `role` field (`consumer`/`agency`/`superAdmin`), `agencyId` field |
| `Agency` | Does not exist yet | Full model needed — schema defined in `context/database_schema.md` |

### Repositories (ready to use)

| Repository | File | Useful Methods |
|------------|------|----------------|
| `TripRepository` | `trips/data/trip_repository.dart` | `getTripsByAgency(agencyId)`, `getTripById()`, `watchAllTrips()` |
| `BookingRepository` | `bookings/data/booking_repository.dart` | `getUserBookings()`, `getBookingByPaymentId()`, `updateBookingStatus()` |
| `AuthRepository` | `authentication/data/auth_repository.dart` | `signInWithEmailAndPassword()`, `signInWithGoogle()`, `getUserProfile()` |
| `ChatRepository` | `chat/data/chat_repository.dart` | `watchTripChat()`, `sendMessage()` |

### Routing (needs update)

Current: `GoRouter` with `StatefulShellRoute` for consumer bottom nav (5 tabs: Home, Explore, My Trips, Chat, Profile). No role-based redirect. No agency/admin routes in `AppRoute` enum.

### Seed Data

`seed_lite.dart` already creates a sample agency, trip with pricing styles, booking, and chat. The `_promoteToAgency()` function sets `role: 'agency'` on the current user — useful for testing.

---

## 2. What Needs Building

### New Files

```
lib/src/features/
├── agency/                              ← Shared agency domain + data
│   ├── domain/
│   │   └── agency.dart                  ← Freezed model
│   └── data/
│       └── agency_repository.dart       ← Firestore CRUD
│
├── agency_dashboard/                    ← Agency UI
│   └── presentation/
│       ├── agency_shell.dart            ← Responsive scaffold (sidebar + topbar + content)
│       ├── screens/
│       │   ├── agency_home_screen.dart
│       │   ├── agency_trips_screen.dart
│       │   ├── agency_add_trip_screen.dart
│       │   ├── agency_bookings_screen.dart
│       │   ├── agency_trip_bookings_screen.dart
│       │   ├── agency_profile_screen.dart
│       │   ├── agency_settings_screen.dart
│       │   ├── agency_messages_screen.dart
│       │   ├── agency_trip_detail_screen.dart
│       │   ├── agency_booking_detail_screen.dart
│       │   ├── agency_payouts_screen.dart
│       │   ├── agency_signup_screen.dart
│       │   └── agency_pending_screen.dart
│       └── components/
│           ├── dashboard_sidebar.dart
│           ├── dashboard_topbar.dart
│           ├── stats_card.dart
│           ├── data_table_card.dart
│           ├── notification_popover.dart
│           └── trip_wizard/
│               ├── step_basic_info.dart
│               ├── step_media.dart
│               ├── step_pricing.dart
│               ├── step_itinerary.dart
│               ├── step_logistics.dart
│               └── step_review.dart
│
└── admin_dashboard/                     ← Superadmin UI
    └── presentation/
        ├── admin_shell.dart             ← Reuses DashboardScaffold pattern
        └── screens/
            ├── admin_home_screen.dart
            ├── admin_agencies_screen.dart
            └── admin_agency_detail_screen.dart
```

### Files to Modify

| File | Change |
|------|--------|
| `authentication/domain/app_user.dart` | Add `@Default('consumer') String role` + `String? agencyId` |
| `authentication/data/auth_repository.dart` | Read/write `role` field, add `registerAgency()` method |
| `routing/app_router.dart` | Role-based redirect logic + agency/admin route branches |
| `trips/data/trip_repository.dart` | Add `createTrip()`, `updateTrip()`, `deleteTripDraft()` |
| `bookings/data/booking_repository.dart` | Add `getBookingsForTrip(tripId)`, `getBookingsForAgency(agencyId)` |

---

## 3. Agency Model

Freezed class matching `context/database_schema.md` agencies collection:

```dart
@freezed
abstract class Agency with _$Agency {
  const factory Agency({
    required String agencyId,
    required String ownerUid,
    required String businessName,
    required String email,
    required String phone,
    @Default('') String description,
    @Default('') String logoUrl,
    @Default('') String coverImageUrl,
    @Default('pending') String verificationStatus, // pending, approved, rejected
    @Default('') String gstin,
    @Default('') String teamSize,
    @Default(0) int yearsExperience,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int totalTrips,
    @Default(0) int totalBookings,
    @Default([]) List<String> specialties,
    @Default({}) Map<String, dynamic> stats, // { totalRevenue, activeBookings, completedTrips }
    @Default({}) Map<String, dynamic> documents, // { gstCertificate, portfolioPhotos }
    DateTime? createdAt,
  }) = _Agency;

  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);
}
```

### AgencyRepository Methods

```dart
class AgencyRepository {
  // Read
  Future<Agency> getAgencyById(String agencyId);
  Stream<Agency> watchAgency(String agencyId);
  Future<List<Agency>> getPendingAgencies(); // For admin

  // Write
  Future<String> createAgency(Agency agency); // Returns agencyId
  Future<void> updateAgency(String agencyId, Map<String, dynamic> updates);
  Future<void> updateVerificationStatus(String agencyId, String status); // Admin only

  // Stats (denormalized)
  Future<void> incrementTripCount(String agencyId);
  Future<void> incrementBookingCount(String agencyId);
}
```

---

## 4. Responsive Layout Strategy

### Breakpoints (matching HTML mockups)

| Name | Width | Navigation | Grid Columns | Content Width |
|------|-------|------------|-------------|---------------|
| Mobile | < 900px | Hamburger → drawer overlay | 1-2 | Full width |
| Desktop | > 900px | Permanent sidebar (240px) | 2-4 | Full minus sidebar |

**Note:** The approved HTML mockups (`03`–`06`) use a **two-breakpoint system** — fixed sidebar on desktop, drawer overlay on mobile. No bottom nav or navigation rail. Data tables switch to card lists at 768px. Stats grids go from 4-col to 2-col at 600px.

### DashboardScaffold — Adaptive Layout

Reference: Shell components designed in `design_mockups/03_agency_dashboard.html` (reused across `04`, `06`).

```
Desktop (> 900px):
┌─────────────┬──────────────────────────────────────────┐
│  Sidebar    │  Topbar: greeting + date + bell + avatar  │
│  240px      ├──────────────────────────────────────────┤
│  fixed      │                                          │
│             │  Content Area                            │
│  Logo       │  Padded, scrollable                      │
│  Nav items: │  Adaptive grid inside                    │
│   Dashboard │                                          │
│   My Trips  │                                          │
│   Bookings  │                                          │
│   Messages  │                                          │
│   Payouts   │                                          │
│  ─────────  │                                          │
│  Profile    │                                          │
│  Settings   │                                          │
│  Sign out   │                                          │
└─────────────┴──────────────────────────────────────────┘
  - Hover states on nav items, table rows, cards
  - Mouse cursor changes on interactive elements
  - Scrollbar styling (thin, themed)

Mobile (< 900px):
┌────────────────────────────────────────────────────────┐
│  Topbar: hamburger ☰ + page title + bell + avatar      │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Content Area                                           │
│  Single/two column, full width                          │
│  Pull-to-refresh on lists                               │
│  Data tables → card lists at 768px                      │
│                                                         │
└────────────────────────────────────────────────────────┘
  ☰ opens drawer overlay (same sidebar content, slides in from left)
  - Touch-friendly tap targets (min 44px)
  - Bottom sheet for actions instead of dropdown menus
```

### Implementation Pattern

```dart
class DashboardScaffold extends StatelessWidget {
  final Widget content;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return _DesktopLayout(...);   // Row: [Sidebar(240px), Expanded(Column: [Topbar, Content])]
        } else {
          return _MobileLayout(...);   // Scaffold(drawer: Sidebar, body: Column([Topbar, Content]))
        }
      },
    );
  }
}
```

Two layout variants — same sidebar widget used in both (permanent vs drawer):
- Desktop: `Row` with permanent sidebar + content
- Mobile: `Scaffold` with drawer sidebar + hamburger topbar
- Content area uses the same child widget, the shell around it changes

### Adaptive Content Grids

Screens that show grids (stats, trips, bookings) use a responsive grid helper:

```dart
int _getColumnCount(double width) {
  if (width > 1200) return 4;
  if (width > 900) return 3;
  if (width > 600) return 2;
  return 1;
}
```

Combined with `GridView.builder` or `Wrap` with calculated item widths — content reflows smoothly at any width, not just at the 3 breakpoints.

---

## 5. Screen Specifications

### 5.1 Agency Home Screen

**Reference Mockup:** `design_mockups/03_agency_dashboard.html`
**Purpose:** Dashboard overview with key metrics and recent activity.

**Layout:**
- Stats row — 4 cards: Total Revenue, Active Bookings, Live Trips, Rating
  - Desktop: 4 columns
  - Tablet: 2x2 grid
  - Mobile: horizontal scroll or 1 column
- Recent trips section — last 5 trips as compact cards with status badges
- Recent bookings section — last 5 bookings as list rows

**Data:**
- `agency.stats` map (denormalized, no aggregate queries)
- `tripRepository.getTripsByAgency(agencyId)` with `limit(5)`
- `bookingRepository.getBookingsForAgency(agencyId)` with `limit(5)`

### 5.2 Agency Trips Screen

**Reference Mockup:** `design_mockups/04_agency_trips.html`
**Purpose:** Full trip management — view, filter, create, edit.

**Layout:**
- Header — "My Trips" title + "Add Trip" button (FAB on mobile)
- Filter tabs — All / Live / Pending / Draft / Completed
- Desktop — `DataTable` with columns: Image, Title, Status, Price, Bookings, Date, Actions
  - Sortable columns (click header)
  - Hover highlight on rows
  - Actions column: Edit / View Bookings / Delete Draft
- Mobile — Card list with trip image, title, status badge, price
  - Tap to open detail
  - Swipe-left for actions

**Data:** `tripRepository.getTripsByAgency(agencyId)` — paginated, 20 per page

### 5.3 Agency Add Trip Screen (Wizard)

**Reference Mockup:** `design_mockups/05_agency_add_trip.html`
**Purpose:** Multi-step form to create a new trip.

**Layout:** Full-screen (exits the shell navigation). Content centered at `maxWidth: 720px`.

**Steps:**

| Step | Name | Fields |
|------|------|--------|
| 1 | Basic Info | Title, description, location, duration (days), categories (multi-select), group size, start date, end date |
| 2 | Media | Primary image upload + gallery images (drag-and-drop grid). Firebase Storage. Max 10 images. |
| 3 | Pricing Styles | Dynamic list of packages. Each: name, price, accommodation type, meal options, inclusions. Min 1, max 5. |
| 4 | Itinerary | Day-by-day breakdown. Each day: title, description, activities (list). Auto-generates days from duration. |
| 5 | Logistics | Boarding points + dropping points. Each: name, address, date/time picker. |
| 6 | Review | Read-only summary of all steps. "Publish" button. |

**Navigation:** Linear stepper with back/next. Can save as draft at any step. Progress persisted in local state (not Firestore) until publish.

**On publish:** Calls `tripRepository.createTrip(trip)` with `status: 'live'`. Sets `agencyId` and `agencyName` from current user's agency.

### 5.4 Agency Bookings Screen

**Reference Mockup:** `design_mockups/06_agency_bookings.html`
**Purpose:** View all bookings across all agency trips.

**Layout:**
- Filter tabs — All / Confirmed / Pending / Cancelled
- Desktop — `DataTable`: Traveler Name, Trip, Package, Amount, Status, Date
- Mobile — Card list with traveler info + trip name + status badge
- Tap row/card — expands or navigates to booking detail

**Data:** `bookingRepository.getBookingsForAgency(agencyId)` — paginated

### 5.5 Agency Trip Bookings Screen

**Reference Mockup:** None — derive layout from `06_agency_bookings.html` with trip-specific header
**Purpose:** Bookings for a specific trip (accessed from trips screen).

**Layout:** Same as bookings screen but filtered to one trip. Header shows trip name + total bookings + revenue.

**Data:** `bookingRepository.getBookingsForTrip(tripId)` — paginated

### 5.6 Agency Profile Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Edit agency public profile.

**Layout:**
- Desktop — 2-column: left (logo upload + cover image upload), right (form fields)
- Mobile — single column: logo, cover, then form fields

**Fields:** Business name, email, phone, description, specialties (chips), team size, years experience

**Data:** `agencyRepository.watchAgency(agencyId)` for read, `agencyRepository.updateAgency()` for write

### 5.7 Agency Login Screen

**Purpose:** Dedicated agency login, web-optimized and responsive.
**Reference Mockup:** `design_mockups/00_agency_login.html`

**Layout:**
- Desktop (> 900px): Two-column split — left: hero image with gradient overlay + brand copy ("Scale your travel business"), right: login form in centered card (`maxWidth: 400px`)
- Mobile (< 900px): Stacked — hero collapses to 250px top section, form below full-width

**Components:**
- Logo row with "Agency" badge (top-left on hero panel)
- "Back to Traveler App" ghost button (top-right) → `/login`
- "Agency Portal" title + "Sign in to your agency dashboard" subtitle
- Email/phone + password fields with icons
- Password visibility toggle
- "Forgot Password?" link → `FirebaseAuth.sendPasswordResetEmail()` via dialog/bottom sheet
- Primary gradient "Sign In" button
- Divider: "or continue with"
- Social buttons row: Google + Apple
- "Not a SoleGoes partner yet? Apply now" → `/agency-signup`

**Data:** Same `authRepository.signInWithEmailAndPassword()` / `signInWithGoogle()` — role-based redirect handles post-login routing.

### 5.8 Agency Signup Screen

**Reference Mockup:** `design_mockups/01_agency_signup.html`
**Purpose:** Self-serve agency registration (3-step wizard).

**Layout:** Centered single column, `maxWidth: 520px`. Progress stepper at top.

**Steps:**

| Step | Name | Fields |
|------|------|--------|
| 1 | Company Details | Business name, email, phone, description, specialties, team size, years experience |
| 2 | Documents | GST certificate upload, portfolio photos (up to 5). Firebase Storage. |
| 3 | Bank Details | Account holder name, account number, IFSC code, bank name (for future payouts) |

**On submit:**
1. Upload documents to Firebase Storage, get URLs
2. Create `agencies/{agencyId}` with `verificationStatus: 'pending'`
3. Update `users/{uid}` with `role: 'agency'`, `agencyId`
4. Navigate to `/agency-pending`

### 5.9 Agency Pending Screen

**Reference Mockup:** `design_mockups/02_agency_pending.html`
**Purpose:** Shown to agency users whose verification is pending.

**Layout:** Centered content. Illustration/icon + "Your application is under review" message + status indicator. No navigation shell — just a simple page with logout button.

**Behavior:** Listens to `agency.verificationStatus` stream. When it changes to `approved`, auto-redirects to `/agency`.

### 5.10 Admin Home Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Platform overview.

**Layout:** Stats grid — Total Users, Total Agencies, Pending Approvals, Total Revenue, Active Trips

**Data:** Aggregate Firestore queries or denormalized counters doc

### 5.11 Admin Agencies Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Agency verification queue.

**Layout:**
- Tabs — Pending / Approved / Rejected
- Card list — each card: agency name, logo, owner email, submission date, specialties
- Actions — Approve / Reject buttons (with confirmation dialog)

**On approve:** `agencyRepository.updateVerificationStatus(agencyId, 'approved')`
**On reject:** Same with `'rejected'` + reason text field

### 5.12 Admin Agency Detail Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Full agency details for review before approval.

**Layout:** Two sections — agency info (name, description, documents, portfolio) + their trips list (if any)

### 5.13 Agency Messages Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Agency-side chat hub for trip-specific group conversations and traveler inquiries.

**Layout:**
- Desktop — 2-pane: conversation list (left, 320px) + active chat (right)
- Mobile — conversation list → tap to open chat (push navigation)
- Each conversation tied to a trip (trip name as chat header)
- Unread badge count on sidebar nav item

**Data:** Reuses existing `ChatRepository` — `watchTripChat()`, `sendMessage()`. Filtered to chats for agency's trips.

### 5.14 Notifications Center

**Reference Mockup:** None — needs HTML mockup design (popover visible in `03`–`06` topbar bell icon but no expanded view)
**Purpose:** Inform agency of new bookings, application status changes, pending payouts, unread messages.

**Layout:**
- Desktop — popover dropdown from topbar bell icon (max 5 recent, "View All" link)
- Mobile — full-screen notifications list (push from topbar bell tap)
- Each notification: icon + title + body + timestamp + read/unread state
- Mark as read on tap, "Mark all as read" action

**Data:** `notifications` collection filtered by `userId` (agency owner UID). Real-time stream.

### 5.15 Agency Trip Detail Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Read-only analytical view of a single trip (distinct from the add/edit wizard).

**Layout:**
- Header — trip image + title + status badge + "Edit" button
- Stats row — total bookings, revenue generated, conversion rate, average rating
- Sections: itinerary summary, pricing styles breakdown, boarding/dropping points, bookings list (last 10)
- "View All Bookings" → navigates to `/agency/trips/:id/bookings`

**Data:** `tripRepository.getTripById(tripId)` + `bookingRepository.getBookingsForTrip(tripId)`

### 5.16 Agency Booking Detail Screen

**Reference Mockup:** None — needs HTML mockup design (drawer or modal)
**Purpose:** Manage a specific traveler's reservation — view full details, process actions.

**Layout:**
- Desktop — slide-out drawer (400px) or modal overlay
- Mobile — full-screen push
- Sections: traveler info (name, email, phone), trip + package selected, boarding/dropping points, payment info (amount, method, status), booking timeline
- Actions: cancel booking (with confirmation), contact traveler (WhatsApp/email link)

**Data:** `bookingRepository.getBookingById(bookingId)`

### 5.17 Agency Settings Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Account settings separate from public profile — security, banking, team management.

**Layout:** Single column, sectioned cards.

**Sections:**
- Account Security — change password, manage linked social accounts
- Bank Details — view/update account holder, account number, IFSC, bank name (submitted during signup)
- GST & Documents — view/re-upload GST certificate
- Notifications Preferences — toggle email/push notifications for bookings, messages, payouts
- Danger Zone — deactivate agency account

**Data:** `agencyRepository.watchAgency(agencyId)` for read, `agencyRepository.updateAgency()` for write. Password change via `FirebaseAuth.updatePassword()`.

### 5.18 Agency Payouts Screen

**Reference Mockup:** None — needs HTML mockup design
**Purpose:** Financial ledger showing revenue, platform fee deductions, and payout history.

**Layout:**
- Summary cards — Total Revenue, Platform Fees, Net Payouts, Pending Payout
- Payout history table — date, amount, status (processed/pending/failed), reference ID
- Desktop: DataTable with sortable columns
- Mobile: Card list
- Filter by date range

**Data:** Future `payouts` collection or computed from bookings. Initially can show aggregated booking revenue from `bookingRepository.getBookingsForAgency(agencyId)`.

---

## 6. Route Definitions

### New AppRoute Entries

```dart
enum AppRoute {
  // ... existing consumer routes ...

  // Agency
  agencyLogin,
  agencySignup,
  agencyPending,
  agencyHome,
  agencyTrips,
  agencyAddTrip,
  agencyEditTrip,
  agencyTripDetail,
  agencyBookings,
  agencyTripBookings,
  agencyBookingDetail,
  agencyMessages,
  agencyProfile,
  agencySettings,
  agencyPayouts,
  agencyNotifications,

  // Admin
  adminHome,
  adminAgencies,
  adminAgencyDetail,
}
```

### Route Tree

```
// Auth (no shell)
/agency-login               → AgencyLoginScreen (web-optimized)
/agency-signup              → AgencySignupScreen
/agency-pending             → AgencyPendingScreen

// Agency Dashboard (AgencyShell)
StatefulShellRoute(builder: AgencyShell)
  Branch 0: /agency           → AgencyHomeScreen
  Branch 1: /agency/trips     → AgencyTripsScreen
  Branch 2: /agency/bookings  → AgencyBookingsScreen
  Branch 3: /agency/messages  → AgencyMessagesScreen
  Branch 4: /agency/profile   → AgencyProfileScreen

// Agency Detail Routes (full screen, no shell nav)
/agency/trips/add             → AgencyAddTripScreen
/agency/trips/:id/edit        → AgencyAddTripScreen (pre-filled, edit mode)
/agency/trips/:id             → AgencyTripDetailScreen (read-only analytics)
/agency/trips/:id/bookings    → AgencyTripBookingsScreen
/agency/bookings/:id          → AgencyBookingDetailScreen
/agency/settings              → AgencySettingsScreen
/agency/payouts               → AgencyPayoutsScreen
/agency/notifications         → AgencyNotificationsScreen

// Admin Dashboard (AdminShell)
StatefulShellRoute(builder: AdminShell)
  Branch 0: /admin          → AdminHomeScreen
  Branch 1: /admin/agencies → AdminAgenciesScreen

// Admin Detail Routes
/admin/agencies/:id         → AdminAgencyDetailScreen
```

### Role-Based Redirect

Added to existing `GoRouter.redirect` — AFTER existing auth and profile-completion checks:

```dart
// After confirming user is logged in and profile is complete:
final user = await authRepository.getUserProfile(uid);

if (user.role == 'agency') {
  if (!path.startsWith('/agency')) {
    final agency = await agencyRepository.getAgencyById(user.agencyId!);
    if (agency.verificationStatus == 'approved') {
      return '/agency';
    } else {
      return '/agency-pending';
    }
  }
}

if (user.role == 'superAdmin') {
  if (!path.startsWith('/admin')) {
    return '/admin';
  }
}

// Consumer (default) — existing routing unchanged
```

---

## 7. Data Flow

### Agency Signup Flow

```
User (login screen) → "Register as Agency Partner"
  → /agency-signup
    Step 1: Company details form
    Step 2: Document uploads → Firebase Storage
    Step 3: Bank details
    → Submit:
      1. Create agencies/{uuid} doc (verificationStatus: 'pending')
      2. Update users/{uid} (role: 'agency', agencyId: uuid)
      3. Navigate → /agency-pending
        → Listens to agency.verificationStatus
        → On 'approved' → auto-redirect to /agency
```

### Admin Approval Flow

```
Admin → /admin/agencies (Pending tab)
  → Selects agency card → /admin/agencies/:id
    → Reviews details + documents
    → Approve: verificationStatus → 'approved', isVerified → true
    → Reject: verificationStatus → 'rejected' + reason
```

### Trip Creation Flow

```
Agency → /agency/trips → "Add Trip" button
  → /agency/trips/add (6-step wizard)
    Step 1-5: Collect all trip data
    Step 6: Review → "Publish"
      → tripRepository.createTrip(trip) with:
        - agencyId: current user's agencyId
        - agencyName: current agency's businessName
        - isVerifiedAgency: current agency's isVerified
        - status: 'live' (auto-approved for now)
      → Navigate back to /agency/trips
      → Trip appears in consumer Explore feed
```

### Booking View Flow (Agency Side)

```
Agency → /agency/bookings (all bookings for all their trips)
  OR
Agency → /agency/trips → tap trip → /agency/trips/:id/bookings
  → DataTable/Cards showing: traveler name, package, amount, status
  → Data: bookingRepository.getBookingsForTrip(tripId)
```

---

## 8. Performance Guidelines

### Firestore Query Efficiency

- Always use `.where()` + `.orderBy()` with composite indexes — never fetch full collections
- Paginate trip and booking lists: `limit(20)` + `startAfterDocument()` cursor
- Denormalize stats — agency home reads `agency.stats` map (pre-computed), not aggregate queries
- Stream providers for real-time data (dashboard stats, booking status), future providers for one-time reads (trip detail)

### Widget Performance

- Provider scoping — agency providers use `autoDispose` so they clean up on logout or role switch
- Selective watching — use `ref.watch(provider.select((state) => state.specificField))` to avoid full-screen rebuilds
- Image optimization — compress uploads (max 1200px width) before Firebase Storage. Display via `AppImage` (wraps `CachedNetworkImage`)
- Lazy loading — wizard steps render only the active step, not all 6 in a `Stack`
- Const constructors — all stateless components use `const` where possible

### Web-Specific

- URL strategy — `usePathUrlStrategy()` for clean URLs (`/agency/trips` not `/#/agency/trips`)
- Deferred loading — agency/admin feature imports should not bloat the consumer app bundle
- Scrollbar theming — visible, thin scrollbars on web (not the default thick ones)
- Keyboard navigation — Tab through form fields, Enter to submit

---

## 9. Auth Safety — Backward Compatibility

Adding role-based access must NOT break the existing consumer app.

### AppUser Model Changes

```dart
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    // ... existing fields unchanged ...
    @Default('consumer') String role,  // NEW — defaults protect existing docs
    String? agencyId,                  // NEW — nullable, no migration needed
  }) = _AppUser;
}
```

**Why this is safe:**
- Existing Firestore `users/` docs don't have `role` or `agencyId` fields
- Freezed's `fromJson` uses `@Default('consumer')` when field is missing — all existing users stay consumer
- `agencyId` is nullable — no crash when missing
- No Firestore data migration needed

### Router Changes

Existing redirect logic stays untouched. New role check added AFTER profile-completion checks:

```dart
// Existing: onboarding check → login check → profile-completion check
// NEW: role-based redirect (only triggers for non-consumer roles)
if (user.role == 'agency' && !path.startsWith('/agency')) { ... }
if (user.role == 'superAdmin' && !path.startsWith('/admin')) { ... }
// Consumer: falls through to existing logic — zero change
```

### Firestore Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }

    match /agencies/{agencyId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null &&
        (resource.data.ownerUid == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'superAdmin');
    }

    match /trips/{tripId} {
      allow read: if true;
      allow create: if request.auth != null &&
        request.resource.data.agencyId != null;
      allow update, delete: if request.auth != null &&
        resource.data.agencyId ==
          get(/databases/$(database)/documents/users/$(request.auth.uid)).data.agencyId;
    }

    match /bookings/{bookingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null &&
        request.auth.uid == request.resource.data.userId;
      allow update: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## 10. Branding & Animation

Follow existing app patterns. No new design system, no new colors.

### Theme Usage

All styling from existing tokens — no hardcoded values:
- Colors: `AppColors` — bgDeep, bgSurface, bgCard, primary, textPrimary, textSecondary, etc.
- Text: `AppTextStyles` — h1-h4, body, bodyMedium, caption, label, button, etc.
- Spacing: `AppSpacing` — xs, sm, md, lg, xl
- Radii: `AppRadius` — sm, md, lg, full
- Shadows: `AppShadows` — sm, md, lg
- Icons: `lucide_icons` package exclusively
- Font: Plus Jakarta Sans (already configured)
- Full reference: `context/branding.md`

### Animation Specs

| Element | Animation | Duration | Easing |
|---------|-----------|----------|--------|
| Page transitions (tabs) | Fade | 200ms | easeInOut |
| Page transitions (push) | Slide up | 300ms | easeOut |
| Sidebar collapse/expand | Width + opacity | 200ms | easeInOut |
| Stats cards (desktop hover) | Scale 1.0 to 1.02 + shadow | 150ms | easeOut |
| Table row (desktop hover) | Background to `surfaceHover` | 100ms | linear |
| Wizard step transition | Slide left/right | 300ms | easeInOut |
| FAB appear | Scale 0 to 1 | 200ms | elasticOut |
| Status badge change | Color cross-fade | 300ms | easeInOut |

### Loading States

- All data loading: `AppShimmer` skeleton layouts (rectangles + circles matching content shape)
- Button loading: `AppButton(isLoading: true)` built-in spinner
- No raw `CircularProgressIndicator` anywhere except splash screen
- No raw `ScaffoldMessenger` — use `AppSnackbar.showSuccess/showError/showInfo`

---

## 11. Phased Roadmap

### Phase 1: Agency Signup & Login

**Goal:** Agency entry point from consumer app, dedicated login, self-serve registration.
**Approach:** Convert approved HTML mockups → Flutter. Follow `rule.md` for theming, reuse `common_widgets/`, match `design_mockups/shared/design-system.css` tokens to `AppColors`/`AppTextStyles`.

| Task | File | What |
|------|------|------|
| "Are you an agency?" link | `login_screen.dart` + `signup_screen.dart` | Link on consumer auth screens → `/agency-login` |
| Convert `00_agency_login.html` → Flutter | `screens/agency_login_screen.dart` | HTML→Flutter: split layout, hero image, form card, social login, responsive |
| Convert `01_agency_signup.html` → Flutter | `screens/agency_signup_screen.dart` | HTML→Flutter: 3-step wizard with brand panel, form fields, upload zones |
| Convert `02_agency_pending.html` → Flutter | `screens/agency_pending_screen.dart` | HTML→Flutter: animated status rings, submitted details pills, timeline, support links |
| WhatsApp support link | Pending screen | Hard-link `wa.me` URL for partner support team on pending + rejected states |
| AuthRepository updates | `authentication/data/auth_repository.dart` | `registerAgency()` method |
| Firebase Storage | | Document upload integration |
| Add routes | `routing/app_router.dart` | `/agency-login`, `/agency-signup`, `/agency-pending` |
| Checkpoint | | "Are you an agency?" → agency login → signup → pending screen. Works on web + mobile. |

### Phase 2: Foundation

**Goal:** Role-based auth working, agency model ready.

| Task | File | What |
|------|------|------|
| Update AppUser | `authentication/domain/app_user.dart` | Add `role` + `agencyId` fields |
| Regenerate | Run `build_runner` | Freezed + JSON serialization |
| Create Agency model | `agency/domain/agency.dart` | Freezed class matching schema |
| Create AgencyRepository | `agency/data/agency_repository.dart` | CRUD methods + Riverpod providers |
| Role-based redirect | `routing/app_router.dart` | Agency to `/agency`, Admin to `/admin`, Consumer to `/` |
| Checkpoint | | Login with `role: 'agency'` user redirects to `/agency` (placeholder) |

### Phase 3: Dashboard Shell

**Goal:** Responsive navigation working at both breakpoints (sidebar ↔ drawer).
**Approach:** Extract shell components from `design_mockups/03_agency_dashboard.html` → Flutter. Sidebar, topbar, and drawer pattern is consistent across mockups `03`–`06`.

| Task | File | What |
|------|------|------|
| DashboardScaffold | `agency_dashboard/presentation/agency_shell.dart` | LayoutBuilder: permanent sidebar (>900px) / drawer (<900px) — convert from HTML shell |
| Convert sidebar from HTML → Flutter | `components/dashboard_sidebar.dart` | 240px fixed sidebar: logo, nav items (Dashboard, My Trips, Bookings, Messages, Payouts), Profile, Settings, Sign out |
| Convert topbar from HTML → Flutter | `components/dashboard_topbar.dart` | Greeting + date (desktop) / hamburger + title (mobile) + notification bell + avatar |
| Notification popover | `components/notification_popover.dart` | Bell icon dropdown — placeholder data initially, wired to real data in Phase 8 |
| Shell routes | `routing/app_router.dart` | `StatefulShellRoute` with branches for dashboard nav items |
| Placeholder screens | All agency screens | Empty `Scaffold` with title text |
| Checkpoint | | Resize browser: sidebar ↔ drawer transition. All nav items route correctly. Bell icon shows popover. |

### Phase 4: Agency Home + Profile + Settings

**Goal:** Real data on dashboard. Profile and account settings working.
**Approach:** Convert `03_agency_dashboard.html` content area → Flutter. Profile + Settings have no mockup yet (design or build from plan spec).

| Task | File | What |
|------|------|------|
| StatsCard widget | `components/stats_card.dart` | Reusable metric card — convert from `03` HTML stats grid |
| Convert `03_agency_dashboard.html` content → Flutter | `screens/agency_home_screen.dart` | HTML→Flutter: stats grid, recent trips, recent bookings, quick actions |
| Agency Profile | `screens/agency_profile_screen.dart` | Edit form with logo/cover upload (no mockup — build from plan spec 5.6) |
| Agency Settings | `screens/agency_settings_screen.dart` | Account security, bank details, GST docs, notification prefs (no mockup — build from plan spec 5.17) |
| Checkpoint | | Agency sees real stats from Firestore. Can edit profile, update bank details, change password. |

### Phase 5: Trip Management

**Goal:** Agency can create and manage trips.
**Approach:** Convert `04_agency_trips.html` and `05_agency_add_trip.html` → Flutter. Trip detail viewer has no mockup yet.

| Task | File | What |
|------|------|------|
| Convert `04_agency_trips.html` → Flutter | `screens/agency_trips_screen.dart` | HTML→Flutter: filter tabs, data table (desktop), card list (mobile), action buttons |
| Convert `05_agency_add_trip.html` → Flutter | `screens/agency_add_trip_screen.dart` | HTML→Flutter: 6-step wizard with stepper, form fields, upload zones, chip selects |
| Wizard steps | `components/trip_wizard/step_*.dart` | Individual step forms — convert each wizard step from HTML |
| TripRepository updates | `trips/data/trip_repository.dart` | `createTrip()`, `updateTrip()` |
| Trip Detail Viewer | `screens/agency_trip_detail_screen.dart` | Read-only analytics view — stats, bookings, revenue, itinerary (no mockup — build from plan spec 5.15) |
| Checkpoint | | Create trip via wizard, appears in consumer Explore feed. Edit existing trip. View trip analytics. |

### Phase 6: Booking Management

**Goal:** Agency can view bookings.
**Approach:** Convert `06_agency_bookings.html` → Flutter. Booking detail has no mockup yet.

| Task | File | What |
|------|------|------|
| Convert `06_agency_bookings.html` → Flutter | `screens/agency_bookings_screen.dart` | HTML→Flutter: filter tabs, data table (desktop), card list (mobile) |
| Trip bookings screen | `screens/agency_trip_bookings_screen.dart` | Per-trip bookings |
| BookingRepository updates | `bookings/data/booking_repository.dart` | `getBookingsForTrip()`, `getBookingsForAgency()` |
| Booking Detail | `screens/agency_booking_detail_screen.dart` | Drawer/modal with traveler info, package, payment, timeline (no mockup — build from plan spec 5.16) |
| Checkpoint | | Agency views bookings across trips. Filter by status works. Tap booking to see full details. |

### Phase 7: Superadmin

**Goal:** Admin can approve agencies.

| Task | File | What |
|------|------|------|
| AdminShell | `admin_dashboard/presentation/admin_shell.dart` | Reuses DashboardScaffold |
| Admin Home | `screens/admin_home_screen.dart` | Platform stats |
| Admin Agencies | `screens/admin_agencies_screen.dart` | Pending queue with approve/reject |
| Agency Detail | `screens/admin_agency_detail_screen.dart` | Full review page |
| Admin routes | `routing/app_router.dart` | `StatefulShellRoute` for admin |
| Checkpoint | | Admin approves agency, agency auto-redirects to dashboard. |

### Phase 8: Messages, Notifications & Payouts

**Goal:** Agency can chat with travelers, receive notifications, and view financials.

| Task | File | What |
|------|------|------|
| Messages screen | `screens/agency_messages_screen.dart` | 2-pane chat hub (desktop) / list→detail (mobile). Reuses `ChatRepository` |
| Notifications screen | `screens/agency_notifications_screen.dart` | Full notification list with read/unread, mark all read |
| Notification popover (wire up) | `components/notification_popover.dart` | Connect bell icon popover to real notification data |
| Payouts screen | `screens/agency_payouts_screen.dart` | Revenue summary cards + payout history table/cards |
| Notifications collection | Firestore | Create `notifications` collection, agency-filtered stream provider |
| Payouts data | Firestore or computed | Payout records or aggregated from bookings |
| Checkpoint | | Agency can chat with travelers, see real-time notifications, view revenue & payout history. |

---

## 12. HTML → Flutter Conversion Guidelines

The approved HTML mockups (`design_mockups/00`–`06`) are the source of truth for **layout, styling, responsiveness, and visual structure**. However, they are **not** the source of truth for data fields.

### What to trust from the HTML mockups
- Layout structure (split views, grids, card vs table breakpoints)
- Visual hierarchy (spacing, typography scale, color usage)
- Responsive behavior (breakpoints, stacking, drawer transitions)
- Component patterns (filter tabs, status badges, upload zones, wizard steppers)
- Interactions (hover states, toggles, collapsible sections)

### What NOT to blindly copy from the HTML mockups
- **Field names** — HTML may use display labels like "Company Name" but the model field is `businessName`. Always map to actual Freezed model fields.
- **Data values** — HTML contains placeholder/demo data. Flutter screens must use **zero static data**. All values come from Riverpod providers backed by Firestore.
- **Extra fields** — HTML may show fields not in `database_schema.md` or the Freezed models. Do not invent fields. If an HTML field has no model equivalent, **ask the user** whether to add it to the schema or skip it.
- **Missing fields** — the model may have fields not shown in the HTML. Only display what the mockup shows unless the user requests otherwise.
- **Field grouping** — HTML may group data differently than the model. Follow the model structure for data fetching, use the HTML for visual grouping.

### Conversion rules
1. **No static data** — every text, number, badge, and list item must come from a provider. Use `AsyncValue` loading/error/data pattern.
2. **Match model fields** — before converting a screen, cross-reference the HTML fields against the relevant Freezed model (`Trip`, `Booking`, `Agency`, `AppUser`) and `database_schema.md`.
3. **Flag mismatches** — if the HTML shows a field that doesn't exist in the model (e.g. "conversion rate" on a trip card, "withdrawal history" in payouts), pause and ask the user with an alternative suggestion (e.g. "HTML shows X, model has Y — should I use Y or add X to the schema?").
4. **Shimmer loading** — use `AppShimmer` skeletons matching the HTML layout shape, never raw `CircularProgressIndicator`.
5. **Error states** — use `AppSnackbar` and `AsyncValueUI` extension, never raw `ScaffoldMessenger`.
6. **Theming** — map HTML CSS vars from `design-system.css` to existing `AppColors`/`AppTextStyles` tokens. Do not hardcode hex values.

### Data source mapping

| HTML Screen | Primary Model(s) | Repository | Key Fields |
|-------------|-------------------|------------|------------|
| `00_agency_login` | `AppUser` | `AuthRepository` | email, password (auth only, no model display) |
| `01_agency_signup` | `Agency` | `AgencyRepository` | businessName, email, phone, description, specialties, teamSize, yearsExperience, documents |
| `02_agency_pending` | `Agency` | `AgencyRepository.watchAgency()` | verificationStatus, businessName, gstin, documents |
| `03_agency_dashboard` | `Agency`, `Trip`, `Booking` | `AgencyRepository`, `TripRepository`, `BookingRepository` | agency.stats, recent trips, recent bookings |
| `04_agency_trips` | `Trip` | `TripRepository.getTripsByAgency()` | title, status, price, imageUrl, startDate, categories |
| `05_agency_add_trip` | `Trip`, `TripStyle`, `TripPoint` | `TripRepository.createTrip()` | All trip fields + pricingStyles + boardingPoints + droppingPoints + itinerary |
| `06_agency_bookings` | `Booking` | `BookingRepository.getBookingsForAgency()` | userName, tripTitle, selectedStyleName, amount, status, bookingDate |

---

## 13. References

| Resource | Location |
|----------|----------|
| Theme tokens | `lib/src/theme/app_theme.dart` |
| Branding guide | `context/branding.md` |
| Database schema | `context/database_schema.md` |
| Seed data | `features/admin/presentation/seed_lite.dart` |
| Common widgets | `lib/src/common_widgets/` (AppButton, AppTextField, AppCard, AppImage, AppShimmer, AppSnackbar) |
| Existing routing | `routing/app_router.dart` |
| Existing auth | `authentication/data/auth_repository.dart` |
| Trip model | `trips/domain/trip.dart` |
| Booking model | `bookings/domain/booking.dart` |
