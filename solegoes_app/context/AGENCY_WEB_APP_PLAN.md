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
│       │   ├── agency_signup_screen.dart
│       │   └── agency_pending_screen.dart
│       └── components/
│           ├── dashboard_sidebar.dart
│           ├── dashboard_topbar.dart
│           ├── dashboard_nav_rail.dart
│           ├── dashboard_bottom_nav.dart
│           ├── stats_card.dart
│           ├── data_table_card.dart
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

### Breakpoints

| Name | Width | Navigation | Grid Columns | Content Width |
|------|-------|------------|-------------|---------------|
| Mobile | < 600px | Bottom nav (4 tabs) | 1 | Full width |
| Tablet | 600-900px | Navigation rail (64px, icons only) | 2 | Full minus rail |
| Desktop | > 900px | Permanent sidebar (280px) | 3-4 | max 1200px, centered |

### DashboardScaffold — Adaptive Layout

The shell uses `LayoutBuilder` to render completely different layout trees at each breakpoint — not CSS-style media queries that hide/show elements.

```
Desktop (> 900px):
┌─────────────┬──────────────────────────────────────────┐
│             │  Topbar: breadcrumb + search + avatar     │
│  Sidebar    ├──────────────────────────────────────────┤
│  280px      │                                          │
│  permanent  │  Content Area                            │
│             │  ┌──────────────────────────────────┐    │
│  Logo       │  │  ConstrainedBox(maxWidth: 1200)  │    │
│  Nav items  │  │  Center-aligned on wide monitors  │    │
│  Divider    │  │                                    │   │
│  Settings   │  │  Adaptive grid inside              │   │
│  Logout     │  └──────────────────────────────────┘    │
│             │                                          │
└─────────────┴──────────────────────────────────────────┘
  - Hover states on nav items, table rows, cards
  - Mouse cursor changes on interactive elements
  - Scrollbar styling (thin, themed)

Tablet (600-900px):
┌──────┬─────────────────────────────────────────────────┐
│ Rail │  Topbar: page title + avatar                     │
│ 64px ├─────────────────────────────────────────────────┤
│      │                                                  │
│ Icons│  Content Area                                    │
│ only │  2-column grid                                   │
│      │  Touch-friendly tap targets (min 44px)           │
│      │                                                  │
└──────┴─────────────────────────────────────────────────┘
  - Tooltip on rail icons for labels
  - No hover states (touch device)

Mobile (< 600px):
┌────────────────────────────────────────────────────────┐
│  Topbar: hamburger + title + avatar                     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Content Area                                           │
│  Single column, full width                              │
│  Pull-to-refresh on lists                               │
│                                                         │
├────────────────────────────────────────────────────────┤
│  Bottom Nav: Home | Trips | Bookings | Profile          │
└────────────────────────────────────────────────────────┘
  - Hamburger opens modal drawer (overlay, not push)
  - Bottom sheet for actions instead of dropdown menus
  - Swipe gestures on cards where appropriate
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
          return _DesktopLayout(...);   // Row: [Sidebar, Expanded(Column: [Topbar, Content])]
        } else if (constraints.maxWidth > 600) {
          return _TabletLayout(...);    // Row: [NavigationRail, Expanded(Column: [Topbar, Content])]
        } else {
          return _MobileLayout(...);    // Scaffold(body: Column([Topbar, Content]), bottomNav: ...)
        }
      },
    );
  }
}
```

Each layout variant is a separate widget tree — not the same tree with conditional padding:
- Desktop: `Row` with sidebar + content
- Tablet: `Row` with rail + content
- Mobile: `Scaffold` with bottom nav
- Content area uses the same child widget, but the shell around it changes completely

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

**Purpose:** View all bookings across all agency trips.

**Layout:**
- Filter tabs — All / Confirmed / Pending / Cancelled
- Desktop — `DataTable`: Traveler Name, Trip, Package, Amount, Status, Date
- Mobile — Card list with traveler info + trip name + status badge
- Tap row/card — expands or navigates to booking detail

**Data:** `bookingRepository.getBookingsForAgency(agencyId)` — paginated

### 5.5 Agency Trip Bookings Screen

**Purpose:** Bookings for a specific trip (accessed from trips screen).

**Layout:** Same as bookings screen but filtered to one trip. Header shows trip name + total bookings + revenue.

**Data:** `bookingRepository.getBookingsForTrip(tripId)` — paginated

### 5.6 Agency Profile Screen

**Purpose:** Edit agency public profile.

**Layout:**
- Desktop — 2-column: left (logo upload + cover image upload), right (form fields)
- Mobile — single column: logo, cover, then form fields

**Fields:** Business name, email, phone, description, specialties (chips), team size, years experience

**Data:** `agencyRepository.watchAgency(agencyId)` for read, `agencyRepository.updateAgency()` for write

### 5.7 Agency Signup Screen

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

### 5.8 Agency Pending Screen

**Purpose:** Shown to agency users whose verification is pending.

**Layout:** Centered content. Illustration/icon + "Your application is under review" message + status indicator. No navigation shell — just a simple page with logout button.

**Behavior:** Listens to `agency.verificationStatus` stream. When it changes to `approved`, auto-redirects to `/agency`.

### 5.9 Admin Home Screen

**Purpose:** Platform overview.

**Layout:** Stats grid — Total Users, Total Agencies, Pending Approvals, Total Revenue, Active Trips

**Data:** Aggregate Firestore queries or denormalized counters doc

### 5.10 Admin Agencies Screen

**Purpose:** Agency verification queue.

**Layout:**
- Tabs — Pending / Approved / Rejected
- Card list — each card: agency name, logo, owner email, submission date, specialties
- Actions — Approve / Reject buttons (with confirmation dialog)

**On approve:** `agencyRepository.updateVerificationStatus(agencyId, 'approved')`
**On reject:** Same with `'rejected'` + reason text field

### 5.11 Admin Agency Detail Screen

**Purpose:** Full agency details for review before approval.

**Layout:** Two sections — agency info (name, description, documents, portfolio) + their trips list (if any)

---

## 6. Route Definitions

### New AppRoute Entries

```dart
enum AppRoute {
  // ... existing consumer routes ...

  // Agency
  agencySignup,
  agencyPending,
  agencyHome,
  agencyTrips,
  agencyAddTrip,
  agencyEditTrip,
  agencyBookings,
  agencyTripBookings,
  agencyProfile,

  // Admin
  adminHome,
  adminAgencies,
  adminAgencyDetail,
}
```

### Route Tree

```
// Auth (no shell)
/agency-signup              → AgencySignupScreen
/agency-pending             → AgencyPendingScreen

// Agency Dashboard (AgencyShell)
StatefulShellRoute(builder: AgencyShell)
  Branch 0: /agency         → AgencyHomeScreen
  Branch 1: /agency/trips   → AgencyTripsScreen
  Branch 2: /agency/bookings → AgencyBookingsScreen
  Branch 3: /agency/profile → AgencyProfileScreen

// Agency Detail Routes (full screen, no shell nav)
/agency/trips/add           → AgencyAddTripScreen
/agency/trips/:id/edit      → AgencyAddTripScreen (pre-filled, edit mode)
/agency/trips/:id/bookings  → AgencyTripBookingsScreen

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

### Phase 1: Foundation

**Goal:** Role-based auth working, agency model ready.

| Task | File | What |
|------|------|------|
| Update AppUser | `authentication/domain/app_user.dart` | Add `role` + `agencyId` fields |
| Regenerate | Run `build_runner` | Freezed + JSON serialization |
| Create Agency model | `agency/domain/agency.dart` | Freezed class matching schema |
| Create AgencyRepository | `agency/data/agency_repository.dart` | CRUD methods + Riverpod providers |
| Role-based redirect | `routing/app_router.dart` | Agency to `/agency`, Admin to `/admin`, Consumer to `/` |
| Checkpoint | | Login with `role: 'agency'` user redirects to `/agency` (placeholder) |

### Phase 2: Dashboard Shell

**Goal:** Responsive navigation working at all 3 breakpoints.

| Task | File | What |
|------|------|------|
| DashboardScaffold | `agency_dashboard/presentation/agency_shell.dart` | LayoutBuilder with desktop/tablet/mobile variants |
| Sidebar | `components/dashboard_sidebar.dart` | Logo, nav items, divider, logout |
| Nav Rail | `components/dashboard_nav_rail.dart` | Icon-only vertical nav for tablet |
| Bottom Nav | `components/dashboard_bottom_nav.dart` | 4-tab bottom bar for mobile |
| Topbar | `components/dashboard_topbar.dart` | Breadcrumb + search + user avatar |
| Shell routes | `routing/app_router.dart` | `StatefulShellRoute` with 4 branches |
| Placeholder screens | All 4 agency screens | Empty `Scaffold` with title text |
| Checkpoint | | Resize browser: shell adapts sidebar, rail, bottom nav. All 4 tabs navigate. |

### Phase 3: Agency Home + Profile

**Goal:** Real data on dashboard.

| Task | File | What |
|------|------|------|
| StatsCard widget | `components/stats_card.dart` | Reusable metric card with icon, value, label |
| Agency Home | `screens/agency_home_screen.dart` | Stats grid + recent trips + recent bookings |
| Agency Profile | `screens/agency_profile_screen.dart` | Edit form with logo/cover upload |
| Checkpoint | | Agency sees real stats from Firestore. Can edit profile and see changes. |

### Phase 4: Trip Management

**Goal:** Agency can create and manage trips.

| Task | File | What |
|------|------|------|
| Trip list screen | `screens/agency_trips_screen.dart` | DataTable (desktop) / Cards (mobile) with filters |
| Add Trip wizard | `screens/agency_add_trip_screen.dart` | 6-step stepper |
| Wizard steps | `components/trip_wizard/step_*.dart` | Individual step forms |
| TripRepository updates | `trips/data/trip_repository.dart` | `createTrip()`, `updateTrip()` |
| Checkpoint | | Create trip via wizard, appears in consumer Explore feed. Edit existing trip. |

### Phase 5: Booking Management

**Goal:** Agency can view bookings.

| Task | File | What |
|------|------|------|
| Bookings screen | `screens/agency_bookings_screen.dart` | All bookings with filters |
| Trip bookings screen | `screens/agency_trip_bookings_screen.dart` | Per-trip bookings |
| BookingRepository updates | `bookings/data/booking_repository.dart` | `getBookingsForTrip()`, `getBookingsForAgency()` |
| Checkpoint | | Agency views bookings across trips. Filter by status works. |

### Phase 6: Agency Signup

**Goal:** Self-serve agency registration.

| Task | File | What |
|------|------|------|
| Signup screen | `screens/agency_signup_screen.dart` | 3-step wizard |
| Pending screen | `screens/agency_pending_screen.dart` | Waiting for approval |
| AuthRepository updates | `authentication/data/auth_repository.dart` | `registerAgency()` method |
| Firebase Storage | | Document upload integration |
| Checkpoint | | New user registers as agency, sees pending screen. |

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

---

## 12. References

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
