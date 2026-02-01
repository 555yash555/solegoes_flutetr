# Agency Dashboard — Implementation Tracker

**Reference:** `context/AGENCY_WEB_APP_PLAN.md` (full plan)
**Last Updated:** 2026-02-02
**Priority:** Agency-first, Superadmin after

---

## Phase 1: Foundation

**Goal:** Role-based auth working, agency model ready.

- [ ] **1.1** Update `AppUser` model — add `@Default('consumer') String role` + `String? agencyId`
  - File: `lib/src/features/authentication/domain/app_user.dart`
- [ ] **1.2** Run `build_runner` — regenerate Freezed + JSON
  - Command: `dart run build_runner build --delete-conflicting-outputs`
- [ ] **1.3** Create `Agency` model (Freezed) matching `database_schema.md`
  - File: `lib/src/features/agency/domain/agency.dart` (NEW)
- [ ] **1.4** Run `build_runner` again for Agency model
- [ ] **1.5** Create `AgencyRepository` with CRUD + Riverpod providers
  - File: `lib/src/features/agency/data/agency_repository.dart` (NEW)
  - Methods: `getAgencyById`, `watchAgency`, `createAgency`, `updateAgency`, `getPendingAgencies`, `updateVerificationStatus`
- [ ] **1.6** Add role-based redirect to `GoRouter`
  - File: `lib/src/routing/app_router.dart`
  - Logic: agency + approved → `/agency`, agency + pending → `/agency-pending`, superAdmin → `/admin`, consumer → `/`
- [ ] **1.7** Add new `AppRoute` enum entries (agencyHome, agencyTrips, etc.)
  - File: `lib/src/routing/app_router.dart`
- [ ] **1.8** Verify: login with `role: 'agency'` user (via seed_lite promote) → redirects correctly
- [ ] **1.9** Verify: existing consumer login still works unchanged

**Checkpoint:** Login → redirect based on role field. Consumer flow unbroken.

---

## Phase 2: Dashboard Shell

**Goal:** Responsive navigation working at all 3 breakpoints.

- [ ] **2.1** Create `DashboardSidebar` component
  - File: `lib/src/features/agency_dashboard/presentation/components/dashboard_sidebar.dart` (NEW)
  - Logo, nav items (Home/Trips/Bookings/Profile), divider, logout
- [ ] **2.2** Create `DashboardTopbar` component
  - File: `components/dashboard_topbar.dart` (NEW)
  - Breadcrumb + search + user avatar
- [ ] **2.3** Create `DashboardNavRail` component (tablet)
  - File: `components/dashboard_nav_rail.dart` (NEW)
  - Icon-only vertical nav, tooltips on hover
- [ ] **2.4** Create `DashboardBottomNav` component (mobile)
  - File: `components/dashboard_bottom_nav.dart` (NEW)
  - 4-tab bottom bar: Home, Trips, Bookings, Profile
- [ ] **2.5** Create `AgencyShell` — responsive scaffold using LayoutBuilder
  - File: `lib/src/features/agency_dashboard/presentation/agency_shell.dart` (NEW)
  - > 900px: sidebar layout
  - 600-900px: rail layout
  - < 600px: bottom nav layout
- [ ] **2.6** Create 4 placeholder screens (empty Scaffold with title)
  - `screens/agency_home_screen.dart`
  - `screens/agency_trips_screen.dart`
  - `screens/agency_bookings_screen.dart`
  - `screens/agency_profile_screen.dart`
- [ ] **2.7** Wire `StatefulShellRoute` for agency in `app_router.dart`
  - Branches: /agency, /agency/trips, /agency/bookings, /agency/profile
- [ ] **2.8** Verify: resize browser → sidebar ↔ rail ↔ bottom nav transitions
- [ ] **2.9** Verify: all 4 tabs navigate correctly, selected state highlights

**Checkpoint:** Agency user sees responsive shell. Navigation works at all sizes.

---

## Phase 3: Agency Home + Profile

**Goal:** Real data displayed on dashboard.

- [ ] **3.1** Create `StatsCard` reusable widget
  - File: `components/stats_card.dart` (NEW)
  - Icon, value, label, optional trend indicator
  - Desktop: hover scale 1.02 + shadow
- [ ] **3.2** Build Agency Home Screen
  - File: `screens/agency_home_screen.dart`
  - Stats grid: Total Revenue, Active Bookings, Live Trips, Rating
  - Responsive grid: 4 cols desktop → 2 tablet → 1 mobile
  - Recent trips section (last 5)
  - Recent bookings section (last 5)
  - Data: `agency.stats` + `tripRepository.getTripsByAgency()` + `bookingRepository.getBookingsForAgency()`
- [ ] **3.3** Add `getBookingsForAgency(agencyId)` to BookingRepository
  - File: `lib/src/features/bookings/data/booking_repository.dart`
- [ ] **3.4** Build Agency Profile Screen
  - File: `screens/agency_profile_screen.dart`
  - Desktop: 2-col (logo+cover left, form right)
  - Mobile: single column
  - Fields: business name, email, phone, description, specialties, team size, years experience
  - Logo + cover image upload to Firebase Storage
- [ ] **3.5** Verify: agency sees real stats from Firestore
- [ ] **3.6** Verify: agency can edit profile, changes persist

**Checkpoint:** Agency sees real stats. Can edit profile.

---

## Phase 4: Trip Management

**Goal:** Agency can create and manage trips.

- [ ] **4.1** Add `createTrip()` to TripRepository
  - File: `lib/src/features/trips/data/trip_repository.dart`
  - Sets agencyId, agencyName, isVerifiedAgency, status from agency context
- [ ] **4.2** Add `updateTrip()` to TripRepository
- [ ] **4.3** Add `deleteTripDraft()` to TripRepository (only drafts)
- [ ] **4.4** Build Agency Trips Screen
  - File: `screens/agency_trips_screen.dart`
  - Filter tabs: All / Live / Pending / Draft / Completed
  - Desktop: DataTable with sortable columns, hover rows, actions
  - Mobile: Card list, tap to detail
  - "Add Trip" button (FAB on mobile)
  - Paginated: 20 per page
- [ ] **4.5** Create Trip Wizard — Step 1: Basic Info
  - File: `components/trip_wizard/step_basic_info.dart` (NEW)
  - Fields: title, description, location, duration, categories, group size, start/end dates
- [ ] **4.6** Create Trip Wizard — Step 2: Media
  - File: `components/trip_wizard/step_media.dart` (NEW)
  - Primary image + gallery (max 10), Firebase Storage upload
- [ ] **4.7** Create Trip Wizard — Step 3: Pricing Styles
  - File: `components/trip_wizard/step_pricing.dart` (NEW)
  - Dynamic list: name, price, accommodation, meals, inclusions (min 1, max 5)
- [ ] **4.8** Create Trip Wizard — Step 4: Itinerary
  - File: `components/trip_wizard/step_itinerary.dart` (NEW)
  - Day-by-day: title, description, activities. Auto-generates from duration.
- [ ] **4.9** Create Trip Wizard — Step 5: Logistics
  - File: `components/trip_wizard/step_logistics.dart` (NEW)
  - Boarding + dropping points: name, address, date/time
- [ ] **4.10** Create Trip Wizard — Step 6: Review
  - File: `components/trip_wizard/step_review.dart` (NEW)
  - Read-only summary. "Publish" button.
- [ ] **4.11** Build Agency Add Trip Screen (orchestrates wizard)
  - File: `screens/agency_add_trip_screen.dart` (NEW)
  - Full-screen, maxWidth: 720px centered
  - Linear stepper, back/next, save draft
  - Route: /agency/trips/add
- [ ] **4.12** Build edit mode (pre-fill wizard from existing trip)
  - Route: /agency/trips/:id/edit
- [ ] **4.13** Add routes for add/edit trip in app_router.dart
- [ ] **4.14** Verify: create trip via wizard → appears in consumer Explore feed
- [ ] **4.15** Verify: edit existing trip → changes reflected

**Checkpoint:** Full trip CRUD working. Trips visible to consumers.

---

## Phase 5: Booking Management

**Goal:** Agency can view bookings for their trips.

- [ ] **5.1** Add `getBookingsForTrip(tripId)` to BookingRepository
  - File: `lib/src/features/bookings/data/booking_repository.dart`
- [ ] **5.2** Build Agency Bookings Screen
  - File: `screens/agency_bookings_screen.dart`
  - Filter tabs: All / Confirmed / Pending / Cancelled
  - Desktop: DataTable — traveler name, trip, package, amount, status, date
  - Mobile: Card list
  - Paginated
- [ ] **5.3** Build Agency Trip Bookings Screen
  - File: `screens/agency_trip_bookings_screen.dart` (NEW)
  - Same layout but filtered to one trip
  - Header: trip name + total bookings + revenue
  - Route: /agency/trips/:id/bookings
- [ ] **5.4** Add route for trip bookings in app_router.dart
- [ ] **5.5** Verify: agency views all bookings across trips
- [ ] **5.6** Verify: filter by status works
- [ ] **5.7** Verify: per-trip booking view shows correct data

**Checkpoint:** Agency can view and filter all bookings.

---

## Phase 6: Agency Signup

**Goal:** Self-serve agency registration.

- [ ] **6.1** Build Agency Signup Screen — Step 1: Company Details
  - File: `screens/agency_signup_screen.dart` (NEW)
  - Fields: business name, email, phone, description, specialties, team size, experience
- [ ] **6.2** Build Signup Step 2: Document Upload
  - GST certificate + portfolio photos (up to 5)
  - Firebase Storage integration
- [ ] **6.3** Build Signup Step 3: Bank Details
  - Account holder, account number, IFSC, bank name
- [ ] **6.4** Build Agency Pending Screen
  - File: `screens/agency_pending_screen.dart` (NEW)
  - "Under review" message + logout button
  - Listens to verificationStatus stream, auto-redirect on approval
- [ ] **6.5** Add `registerAgency()` to AuthRepository
  - Creates agency doc (pending) + updates user (role, agencyId)
  - File: `lib/src/features/authentication/data/auth_repository.dart`
- [ ] **6.6** Add "Register as Agency Partner" link on login screen
- [ ] **6.7** Add routes: /agency-signup, /agency-pending in app_router.dart
- [ ] **6.8** Verify: new user registers → sees pending screen
- [ ] **6.9** Verify: pending user cannot access /agency dashboard

**Checkpoint:** Full agency registration flow working.

---

## Phase 7: Superadmin

**Goal:** Admin can approve agencies, view platform stats.

- [ ] **7.1** Build Admin Shell (reuse DashboardScaffold pattern)
  - File: `lib/src/features/admin_dashboard/presentation/admin_shell.dart` (NEW)
- [ ] **7.2** Build Admin Home Screen
  - File: `screens/admin_home_screen.dart` (NEW)
  - Stats: Total Users, Total Agencies, Pending Approvals, Revenue, Active Trips
- [ ] **7.3** Build Admin Agencies Screen
  - File: `screens/admin_agencies_screen.dart` (NEW)
  - Tabs: Pending / Approved / Rejected
  - Card list with agency info + Approve/Reject buttons
- [ ] **7.4** Build Admin Agency Detail Screen
  - File: `screens/admin_agency_detail_screen.dart` (NEW)
  - Full agency info + documents + their trips
- [ ] **7.5** Wire StatefulShellRoute for admin in app_router.dart
  - /admin, /admin/agencies, /admin/agencies/:id
- [ ] **7.6** Deploy Firestore security rules
  - Users: own doc only
  - Agencies: owner + superAdmin can update
  - Trips: agency owner can CRUD their trips
  - Bookings: agency can read their trips' bookings
- [ ] **7.7** Verify: admin approves agency → agency auto-redirects to dashboard
- [ ] **7.8** Verify: admin rejects agency → agency sees rejected state
- [ ] **7.9** Verify: consumer cannot access /admin or /agency routes

**Checkpoint:** Full admin approval flow working. All roles properly gated.

---

## Progress Summary

| Phase | Tasks | Done | Status |
|-------|-------|------|--------|
| 1. Foundation | 9 | 0 | Not started |
| 2. Dashboard Shell | 9 | 0 | Not started |
| 3. Home + Profile | 6 | 0 | Not started |
| 4. Trip Management | 15 | 0 | Not started |
| 5. Booking Management | 7 | 0 | Not started |
| 6. Agency Signup | 9 | 0 | Not started |
| 7. Superadmin | 9 | 0 | Not started |
| **Total** | **64** | **0** | — |
